"""Registered packaging transforms for the 2026-10-26 BMC clean release.

Authors: Jinlong Ru; Cunli Pan. No model fitting or scientific recalculation.
"""
from pathlib import Path
from decimal import Decimal, InvalidOperation
from lxml import etree as E
import csv, hashlib, json, re, shutil, zipfile

NS={'s':'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}
RID='{http://schemas.openxmlformats.org/officeDocument/2006/relationships}id'
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def require(ok,message):
    if not ok:raise RuntimeError(message)
def parts(path):
    with zipfile.ZipFile(path) as z:return {n:z.read(n) for n in z.namelist()}
def hashes(values):return {n:hashlib.sha256(v).hexdigest() for n,v in values.items()}
def sheets(values):
    rels={x.get('Id'):x.get('Target') for x in E.fromstring(values['xl/_rels/workbook.xml.rels'])}
    return {x.get('name'):(rels[x.get(RID)].lstrip('/') if rels[x.get(RID)].startswith('/') else 'xl/'+rels[x.get(RID)]) for x in E.fromstring(values['xl/workbook.xml']).findall('s:sheets/s:sheet',NS)}
def workbook_delta(source,destination,record,metadata):
    values=parts(source)
    require(hashes(values)==record['base_parts'],'Unregistered change to the historical publication workbook: '+record['filename'])
    for name in record['remove_parts']:values.pop(name)
    for item in record['changes']:
        patch=metadata/item['patch']
        require(patch.resolve().is_relative_to(metadata.resolve()),'Patch path outside registered metadata')
        require(sha(patch)==item['sha256'],'Changed registered clean packaging patch: '+item['patch'])
        values[item['part']]=patch.read_bytes()
    require(hashes(values)==record['target_parts'],'Clean workbook reconstruction differs from the registered target')
    with zipfile.ZipFile(destination,'w',compression=zipfile.ZIP_DEFLATED) as z:
        for name,payload in values.items():z.writestr(name,payload)
    return {'file':record['filename'],'inherited_scientific_sheets_byte_identical':len(record['inherited_scientific_sheets_unchanged']),'added_sheets':record['added_sheets'],'numbered_scientific_sheets':record['final_numbered_sheet_count'],'all_zip_parts_match_registered_target':True}
def column_index(ref):
    n=0
    for c in re.match('[A-Z]+',ref).group():n=n*26+ord(c)-64
    return n-1
def matrix(path,name):
    values=parts(path);sm=sheets(values)
    strings=[]
    if 'xl/sharedStrings.xml' in values:
        strings=[''.join(x.itertext()) for x in E.fromstring(values['xl/sharedStrings.xml'])]
    rows=[]
    for row in E.fromstring(values[sm[name]]).findall('s:sheetData/s:row',NS):
        cells={}
        for cell in row.findall('s:c',NS):
            typ=cell.get('t');value=cell.findtext('s:v',namespaces=NS) or ''
            if typ=='s':value=strings[int(value)]
            elif typ=='inlineStr':value=''.join(cell.find('s:is',NS).itertext())
            elif typ=='b':value='TRUE' if value=='1' else 'FALSE'
            require(cell.find('s:f',NS) is None,'Unexpected formula in archived source table')
            cells[column_index(cell.get('r'))]=value
        rows.append(cells)
    width=max(rows[0])+1
    out=[[row.get(i,'') for i in range(width)] for row in rows]
    while out and not any(out[-1]):out.pop()
    return out
def normal(value):
    if value in ('TRUE','FALSE'):return ('number',Decimal(1 if value=='TRUE' else 0))
    try:return ('number',Decimal(value)) if value and value.strip()==value else ('text',value)
    except InvalidOperation:return ('text',value)
def same_table(actual,expected,label):
    require(len(actual)==len(expected),f'Row count differs for {label}')
    for ri,(a,b) in enumerate(zip(actual,expected),1):
        require(len(a)==len(b),f'Column count differs for {label} row {ri}')
        for ci,(x,y) in enumerate(zip(a,b),1):
            require(normal(x)==normal(y),f'Source value differs for {label} row {ri} column {ci}')
    return {'sheet':label,'data_rows':len(expected)-1,'every_source_cell_checked':True}
def verify_added_tables(stage,historical):
    data1=stage/'Supplementary_Data_1_Local_analyses.xlsx'
    mapping={'S65_comparison_members':'Supplementary_Data_1_comparison_members.tsv','S66_input_diagnostics':'Supplementary_Data_1_input_diagnostics.tsv','S67_full_definitions':'Supplementary_Table_S1_full_definitions.tsv','S68_S2_host_links':'Supplementary_Figure_S2_links.tsv'}
    checks=[]
    for sheet,filename in mapping.items():
        with (historical/filename).open() as f:expected=list(csv.reader(f,delimiter='\t'))
        checks.append(same_table(matrix(data1,sheet),expected,sheet))
    with (historical/'Supplementary_Data_3_construct_genome_register.tsv').open() as f:expected=list(csv.reader(f,delimiter='\t'))
    checks.append(same_table(matrix(stage/'Supplementary_Data_3_construct_genome_register.xlsx','Genome_register'),expected,'Genome_register'))
    keywords=json.loads((historical/'global-feature-keywords.json').read_text())
    expected=[['record_type','category','priority','position','value']]
    for i,c in enumerate(keywords['precedence'],1):expected.append(['precedence',c,str(i),str(i),c])
    for c,words in keywords['keywords'].items():
        for i,w in enumerate(words,1):expected.append(['keyword',c,str(keywords['precedence'].index(c)+1),str(i),w])
    for k in ('matching','source_relative','source_sha256'):expected.append([k,'','','',keywords[k]])
    actual=matrix(stage/'Supplementary_Data_2_Reference_genome_analyses.xlsx','G28_feature_keywords')
    checks.append(same_table(actual,expected,'G28_feature_keywords'))
    require([r[-1] for r in actual]==[r[-1] for r in expected],'Keyword literal text, including trailing spaces, differs')
    field=E.fromstring(parts(data1)[sheets(parts(data1))['FIELDS']])
    cell=field.find('.//s:c[@r="G650"]',NS)
    require(cell is not None and '114 sites occur on 96 representatives' in ''.join(cell.itertext()),'Current S62 field clarification is missing')
    return checks
def assemble(old_stage,target,code):
    metadata=code/'metadata_bmc_clean';reg=json.loads((metadata/'workbook-delta.json').read_text())
    reference=code.parent/'reference/bmc-clean-2026-10-26'
    target.mkdir();(target/'Figures').mkdir();sd=target/'Supplementary_Data';sd.mkdir();supp=target/'Supplementary_Figures';supp.mkdir()
    book_checks=[]
    for record in reg['books']:
        dest=sd/record['filename'];book_checks.append(workbook_delta(old_stage/record['filename'],dest,record,metadata))
        require(parts(dest)==parts(reference/'Supplementary_Data'/record['filename']),'Final clean workbook differs: '+record['filename'])
    record=reg['register'];src=metadata/record['filename'];require(sha(src)==record['sha256'],'Archived register changed');shutil.copy2(src,sd/record['filename'])
    require(parts(sd/record['filename'])==parts(reference/'Supplementary_Data'/record['filename']),'Construct workbook differs from clean')
    record=reg['structure'];src=code.parent/'reference/05_Supplementary_Data'/record['filename'];require(sha(src)==record['sha256'],'Structure ZIP changed');shutil.copy2(src,sd/record['filename'])
    source_checks=verify_added_tables(sd,code.parent/'reference/05_Supplementary_Data')
    from PIL import Image,ImageChops
    def same_image(a,b):
        with Image.open(a) as x,Image.open(b) as y:
            x=x.convert('RGB');y=y.convert('RGB');return x.size==y.size and ImageChops.difference(x,y).getbbox() is None
    image_checks=[]
    for k in ['1','2','3','4','5','S1','S2','S3','S4']:
        src=old_stage/f'Figure{k}.png'
        if k.startswith('S'):
            dest=supp/src.name;shutil.copy2(src,dest);expected=reference/'Supplementary_Figures'/src.name
        else:
            dest=target/'Figures'/f'Figure_{k}.tif';shutil.copy2(old_stage/f'Figure_{k}.tif',dest);expected=reference/'Figures'/dest.name
        require(same_image(dest,expected),'Clean image pixels differ: '+k)
        image_checks.append({'figure':k,'pixels_match_clean_baseline':True})
    return {'baseline':reg['baseline'],'workbooks':book_checks,'source_table_checks':source_checks,'figure_checks':image_checks,'construct_register_archived_not_refitted':True,'word_image_check_scope':'Historical receipt in provenance/bmc-clean-baseline.json; documents are deliberately not distributed','new_scientific_analysis':False}
