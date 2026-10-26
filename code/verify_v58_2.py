#!/usr/bin/env python3
"""Verify the v58.2 code candidate against supplied figure/data references (no Word documents).

Authors (code-document order): Jinlong Ru, Cunli Pan.
Default: NO scientific execution. --render explicitly runs the established 21-step
workflow first. No model fitting, raw-read pipeline, installation or download.
"""
from pathlib import Path
from lxml import etree as E
from PIL import Image, ImageChops
import argparse,csv,hashlib,io,json,os,shutil,subprocess,sys,tempfile,zipfile

CODE=Path(__file__).resolve().parent; PACKAGE=CODE.parent/'reference'; WORKFLOW=CODE/'workflow'
sys.path.insert(0,str(CODE/'publication'))
from v56_overrides import figure2 as patch_v56_figure, workbook as patch_v56_workbook
from v57_overrides import figure4 as patch_v57_figure4, extend_workbook
from v58_overrides import workbook_labels
from v58_2_overrides import apply_labels as patch_v58_2_workbook, reader_files
NS={'s':'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}
ST='{'+NS['s']+'}'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()

def check(condition,message):
    if not condition:raise RuntimeError(message)

def patch_svg(payload,provenance):
    source=payload.decode('utf-8');old=provenance['before'];new=provenance['after']
    if hashlib.sha256(payload).hexdigest()==provenance['source_sha256']:
        check(source.count(old)==1,'Registered Figure2 legend block is not unique')
        changed=source.replace(old,new,1)
        check(changed.replace(new,old,1)==source,'Unexpected edit outside registered legend')
    else:
        check(source.count(new)==1,'Unrecognized Figure2 SVG: source geometry/legend must be reviewed')
        restored=source.replace(new,old,1).encode('utf-8')
        check(hashlib.sha256(restored).hexdigest()==provenance['source_sha256'],
              'Figure2 has unreviewed changes outside the registered legend')
        changed=source
    check('c: treated wastewater' in changed and 'c: nearby water' not in changed,
          'Figure2 publication water category is incorrect')
    return changed.encode('utf-8')

def patch_workbook(source,destination,metadata):
    with zipfile.ZipFile(source) as z:infos=z.infolist();parts={k:z.read(k) for k in z.namelist()}
    parts['docProps/core.xml']=(metadata/'publication-core.xml').read_bytes()
    workbook=E.fromstring(parts['xl/workbook.xml']);rels={x.get('Id'):x.get('Target') for x in E.fromstring(parts['xl/_rels/workbook.xml.rels'])}
    sheet=next(x for x in workbook.findall('s:sheets/s:sheet',NS) if x.get('name')=='S37_gaps')
    target=rels[sheet.get('{http://schemas.openxmlformats.org/officeDocument/2006/relationships}id')]
    target=target.lstrip('/') if target.startswith('/') else 'xl/'+target
    root=E.fromstring(parts[target]);dictionary=json.loads((metadata/'metadata-patch.json').read_text())
    shared=E.fromstring(parts['xl/sharedStrings.xml']) if 'xl/sharedStrings.xml' in parts else None
    def value(cell):
        if cell.get('t')=='s':return ''.join(shared[int(cell.find('s:v',NS).text)].itertext())
        if cell.get('t')=='inlineStr':return ''.join(cell.find('s:is',NS).itertext())
        return cell.findtext('s:v',namespaces=NS) or ''
    addresses={x['cell'] for x in dictionary['changes']};check(addresses=={'B2','C2'},'Only two approved S37 cells may change')
    for item in dictionary['changes']:
        cells=root.xpath('.//s:c[@r="'+item['cell']+'"]',namespaces=NS);check(len(cells)==1,'Missing S37 cell')
        cell=cells[0];check(value(cell) in [item['before'],item['after']],'S37 has unreviewed text changes')
        for child in list(cell):cell.remove(child)
        cell.set('t','inlineStr');E.SubElement(E.SubElement(cell,ST+'is'),ST+'t').text=item['after']
    parts[target]=E.tostring(root,encoding='UTF-8',xml_declaration=True)
    with zipfile.ZipFile(destination,'w') as z:
        for info in infos:z.writestr(info,parts[info.filename])
    with (destination.parent/'Data1_S37_gaps.tsv').open('w') as f:
        csv.writer(f,delimiter='\t',lineterminator='\n').writerows([[value(c) for c in r.findall('s:c',NS)] for r in root.findall('s:sheetData/s:row',NS)])
    return target

def workbook_equal(a,b):
    with zipfile.ZipFile(a) as x,zipfile.ZipFile(b) as y:
        return set(x.namelist())==set(y.namelist()) and all(x.read(k)==y.read(k) for k in x.namelist())

def copy_workbook_with_publication_timestamps(source,destination,reference):
    """Permit only already-known core-property dates to differ; never mask worksheet changes."""
    with zipfile.ZipFile(source) as z,zipfile.ZipFile(reference) as ref:
        infos=z.infolist();parts={k:z.read(k) for k in z.namelist()}
        check(set(parts)==set(ref.namelist()),'Data2 workbook part list differs')
        differences=[k for k in parts if parts[k]!=ref.read(k)]
        check(set(differences)<={'docProps/core.xml'},'Data2 has changes beyond publication timestamps')
        if differences:
            def without_dates(blob):
                root=E.fromstring(blob)
                for name in ['created','modified']:
                    for node in root.findall('{http://purl.org/dc/terms/}'+name):root.remove(node)
                return E.tostring(root,method='c14n')
            check(without_dates(parts['docProps/core.xml'])==without_dates(ref.read('docProps/core.xml')),
                  'Data2 has unreviewed core properties beyond dates')
            parts['docProps/core.xml']=ref.read('docProps/core.xml')
    with zipfile.ZipFile(destination,'w') as z:
        for info in infos:z.writestr(info,parts[info.filename])
    return differences

def image_equal(a,b):
    with Image.open(a) as x,Image.open(b) as y:
        x=x.convert('RGB');y=y.convert('RGB')
        return x.size==y.size and ImageChops.difference(x,y).getbbox() is None

def embedded_images(doc):
    ns={'w':'http://schemas.openxmlformats.org/wordprocessingml/2006/main','a':'http://schemas.openxmlformats.org/drawingml/2006/main','r':'http://schemas.openxmlformats.org/officeDocument/2006/relationships'}
    with zipfile.ZipFile(doc) as z:
        root=E.fromstring(z.read('word/document.xml'));rels={r.get('Id'):r.get('Target') for r in E.fromstring(z.read('word/_rels/document.xml.rels'))}
        return [z.read('word/'+rels[b.get('{'+ns['r']+'}embed')]) for b in root.findall('.//a:blip',ns)]

def runtime_snapshot():
    rows=[]
    for f in sorted((WORKFLOW/'analyses/data').glob('*/step-record.json')):
        status=f.parent/'.rwv-status.json';st=json.loads(status.read_text()) if status.exists() else {}
        check(st.get('status','complete')=='complete','An unfinished workflow step exists: '+f.parent.name)
        r=json.loads(f.read_text());check(r.get('status')=='complete','Incomplete step record: '+f.parent.name)
        rows.append({'step':f.parent.name,'run_id':r['run_id'],'record_sha256':sha(f)})
    check(len(rows)==21,'Expected all 21 current step records');return rows

def node_environment(env):
    """Use an existing Node/sharp installation, including an installed Codex runtime; never install."""
    bundled=Path.home()/'.cache/codex-runtimes/codex-primary-runtime/dependencies/node'
    candidates=[]
    ordinary=os.environ.get('RWV_NODE') or shutil.which('node')
    if ordinary:candidates.append((ordinary,env.copy()))
    if (bundled/'bin/node').is_file() and (bundled/'node_modules/sharp').is_dir():
        bundled_env=env.copy();bundled_env['NODE_PATH']=str(bundled/'node_modules')
        candidates.append((str(bundled/'bin/node'),bundled_env))
    for node,node_env in candidates:
        probe=subprocess.run([node,'-p',"require.resolve('sharp')"],cwd=CODE/'publication',env=node_env,capture_output=True,text=True)
        if probe.returncode==0:return node,node_env
    raise RuntimeError('No existing Node.js installation can resolve sharp. Configure PATH/NODE_PATH or the installed Codex runtime; no installation was attempted.')

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--render',action='store_true',help='Explicitly rerender established 21-step workflow before checking/publication')
    parser.add_argument('--check',action='store_true',help='Check reproduction in temporary storage without replacing publication/current')
    args=parser.parse_args();env=os.environ.copy();env.update(LANG='en_US.UTF-8',LC_ALL='en_US.UTF-8')
    if args.render:
        subprocess.run(['Rscript','scripts/render.R','--with-checks'],cwd=WORKFLOW,env=env,check=True)
    snapshot=runtime_snapshot()
    sync=subprocess.run(['Rscript','scripts/check-sync.R','--with-checks'],cwd=WORKFLOW,env=env,capture_output=True,text=True)
    check(sync.returncode==0,'Workflow synchronization failed:\n'+sync.stdout+sync.stderr)
    archive=subprocess.run([sys.executable,str(CODE/'model_archive/validate_archive.py')],capture_output=True,text=True,check=True)
    reference=PACKAGE/'08_Manuscript_Source';override=reference/'v2026.09.28.54/editorial-overrides/provenance.json'
    bundle=WORKFLOW/'analyses/data/900-publication-bundle/review-candidate'
    with tempfile.TemporaryDirectory(prefix='rwv-publication-') as tmp:
        stage=Path(tmp)/'artifacts';stage.mkdir();provenance=json.loads(override.read_text())
        source_svg=WORKFLOW/'analyses/data/120-fig2-community-links/fig2.svg'
        v54_svg=patch_svg(source_svg.read_bytes(),provenance)
        v56_svg,figure_edit_receipt=patch_v56_figure(v54_svg,json.loads((CODE/'metadata_release_v56/figure2-patch.json').read_text()))
        (stage/'Figure2.svg').write_bytes(v56_svg)
        check((stage/'Figure2.svg').read_bytes()==(reference/'figures/Figure2.svg').read_bytes(),'Published Figure2 SVG differs from registered reconstruction')
        fonts=Path(os.environ.get('RWV_ARIAL_DIR','/System/Library/Fonts/Supplemental'))
        check(fonts.is_dir(),'Set RWV_ARIAL_DIR to the directory containing the approved Arial fonts')
        conf=Path(tmp)/'fonts.conf';cfg=E.Element('fontconfig');E.SubElement(cfg,'dir').text=str(fonts);E.SubElement(cfg,'cachedir').text=str(Path(tmp)/'font-cache');conf.write_bytes(E.tostring(cfg,xml_declaration=True,encoding='UTF-8'))
        node,render_env=node_environment(env);render_env.update(FONTCONFIG_FILE=str(conf),FONTCONFIG_PATH=str(Path(tmp)))
        subprocess.run([node,str(CODE/'publication/render_figure2.cjs'),str(stage)],env=render_env,check=True)
        v57meta=CODE/'metadata_release_v57'
        v58meta=CODE/'metadata_release_v58'
        aliases=json.loads((v58meta/'file-aliases.json').read_text())['aliases']
        label_records=json.loads((v58meta/'workbook-label-patches.json').read_text())
        f4reg=json.loads((v57meta/'figure4-patch.json').read_text())
        (stage/'Figure4.svg').write_bytes(patch_v57_figure4((bundle/'Figure4.svg').read_bytes(),f4reg))
        check((stage/'Figure4.svg').read_bytes()==(reference/'figures/Figure4.svg').read_bytes(),'Figure4 registered text edit differs')
        subprocess.run([node,str(CODE/'publication/render_svg.cjs'),str(stage),'4','2125','2740'],env=render_env,check=True)
        figure_rows=[]
        for key in ['1','2','3','4','5','S1','S2','S3','S4']:
            png=stage/('Figure'+key+'.png')
            if key not in ['2','4']:shutil.copy2(bundle/('Figure'+key+'.png'),png)
            tif=stage/('Figure_'+key+'.tif')
            if key not in ['2','4']:shutil.copy2(bundle/('Figure'+key+'.tiff'),tif)
            if key.startswith('S'):expected_tif=PACKAGE/'04_Supplementary_Information/Supplementary_Figures'/('Supplementary_Figure_'+key[1:]+'.tif')
            else:expected_tif=PACKAGE/'03_Figures'/('Figure_'+key+'.tif')
            check(image_equal(tif,expected_tif),'Publication TIFF pixels differ: '+key)
            if not key.startswith('S'):check(image_equal(png,reference/'figures'/png.name),'Published PNG pixels differ: '+key)
            figure_rows.append({'figure':key,'png_sha256':sha(png),'tiff_sha256':sha(tif),'published_tiff_pixels_identical':True})
        # Public code candidate verifies published figure assets. Word manuscripts
        # are deliberately not supplied; their earlier checks remain historical.
        patch_workbook(WORKFLOW/'analyses/data/320-data1-local/Data1_local.xlsx',stage/'Data1_v54.xlsx',CODE/'metadata_release_v54')
        v56_data=json.loads((CODE/'metadata_release_v56/data1-patch.json').read_text())
        patch_v56_workbook(stage/'Data1_v54.xlsx',stage/'Data1_v56.xlsx',v56_data)
        data1_v57=extend_workbook(stage/'Data1_v56.xlsx',stage/'Data1_local.xlsx',json.loads((v57meta/'Data1-append.json').read_text()),v57meta)
        (stage/'Data1_v56.xlsx').unlink()
        (stage/'Data1_v54.xlsx').unlink()
        data1_labels=workbook_labels(stage/'Data1_local.xlsx',stage/'Data1_v58.xlsx',label_records['Data1_local.xlsx'])
        v58_2meta=CODE/'metadata_release_v58_2'
        data1_reference_repairs=patch_v58_2_workbook(stage/'Data1_v58.xlsx',stage/aliases['Data1_local.xlsx'],json.loads((v58_2meta/'workbook-label-patches.json').read_text()))
        (stage/'Data1_v58.xlsx').unlink()
        check(workbook_equal(stage/aliases['Data1_local.xlsx'],PACKAGE/'05_Supplementary_Data'/aliases['Data1_local.xlsx']),'Publication workbook parts differ')
        (stage/'Data1_local.xlsx').unlink()
        (stage/'Data1_S37_gaps.tsv').rename(stage/aliases['Data1_S37_gaps.tsv'])
        check((stage/aliases['Data1_S37_gaps.tsv']).read_bytes()==(PACKAGE/'05_Supplementary_Data'/aliases['Data1_S37_gaps.tsv']).read_bytes(),'Publication S37 export differs')
        data2reg=json.loads((v57meta/'Data2-append.json').read_text())
        with zipfile.ZipFile(bundle/'Data2_global.xlsx') as z:timestamp_normalization=['docProps/core.xml'] if hashlib.sha256(z.read('docProps/core.xml')).hexdigest()!=data2reg['base_part_sha256']['docProps/core.xml'] else []
        data2_v57=extend_workbook(bundle/'Data2_global.xlsx',stage/'Data2_global.xlsx',data2reg,v57meta)
        data2_labels=workbook_labels(stage/'Data2_global.xlsx',stage/aliases['Data2_global.xlsx'],label_records['Data2_global.xlsx'])
        check(workbook_equal(stage/aliases['Data2_global.xlsx'],PACKAGE/'05_Supplementary_Data'/aliases['Data2_global.xlsx']),'Data2 workbook differs')
        (stage/'Data2_global.xlsx').unlink()
        reader_verification=reader_files(CODE,PACKAGE,stage,v58_2meta)
        check(snapshot==runtime_snapshot(),'Workflow changed during publication check; repeat after render finishes')
        manifest={f.name:sha(f) for f in sorted(stage.iterdir()) if f.is_file()}
        receipt={'publication_version':'v58.2','v58_2_reference_repairs':data1_reference_repairs,'v58_2_reader_files':reader_verification,'publication_file_aliases':aliases,'v58_Data1_labels':data1_labels,'v58_Data2_labels':data2_labels,'v57_Data1_additions':data1_v57,'v57_Data2_additions':data2_v57,'v57_Figure4_text_only':True,'v56_figure_edit':figure_edit_receipt,'Data1_v56_string_cell_edits':len(v56_data['changes']),'strict_workflow_sync':True,'step_count':21,'run_ids':sorted({r['run_id'] for r in snapshot}),'step_records':snapshot,'figure_checks':figure_rows,'four_word_documents_embedded_images_match':None,'word_check_scope':'Not executed by public entry; see original submission receipt' ,'Data1_v54_two_cell_and_v56_publication_string_patches_reproduced':True,'Data2_workbook_parts_match':True,'Data2_publication_timestamp_parts_normalized':timestamp_normalization,'model_archive_check':json.loads(archive.stdout),'new_analysis_this_command':args.render,'scientific_scope':'Only existing community calculations are rerun with --render; no raw-read processing, annotation or VF/global model fitting. Default is verification, rasterization and publication-text patching only.','artifacts':manifest}
        (stage/'publication-check.json').write_text(json.dumps(receipt,indent=2)+'\n');(stage/'workflow-sync.log').write_text(sync.stdout+sync.stderr)
        if not args.check:
            dest=CODE/'publication/current-v58.2';dest.parent.mkdir(exist_ok=True)
            check(not dest.exists(),'publication/current-v58.2 already exists; use --check for verification')
            shutil.copytree(stage,dest)
        print(json.dumps(receipt,indent=2))

if __name__=='__main__':main()
