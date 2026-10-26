"""Jinlong Ru; Cunli Pan. Approved v58.2 metadata and original companion exports."""
from pathlib import Path
from lxml import etree as E
import csv,hashlib,json,re,shutil,zipfile
from v58_overrides import workbook_labels
NS={'s':'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}
def require(condition,message):
    if not condition:raise RuntimeError(message)
def apply_labels(source,destination,record):
    with zipfile.ZipFile(source) as z:
        require(set(z.namelist())==set(record['base_part_sha256']),'v58.2 workbook part list changed')
        require(all(hashlib.sha256(z.read(k)).hexdigest()==h for k,h in record['base_part_sha256'].items()),'Unregistered v58.2 workbook input')
    return workbook_labels(source,destination,record)
def sheet_rows(book,name):
    with zipfile.ZipFile(book) as z:
        wb=E.fromstring(z.read('xl/workbook.xml'));rels={x.get('Id'):x.get('Target') for x in E.fromstring(z.read('xl/_rels/workbook.xml.rels'))}
        sh=next(x for x in wb.find('s:sheets',NS) if x.get('name')==name);dest=rels[sh.get('{http://schemas.openxmlformats.org/officeDocument/2006/relationships}id')]
        part=dest.lstrip('/') if dest.startswith('/') else 'xl/'+dest;root=E.fromstring(z.read(part))
        ss=E.fromstring(z.read('xl/sharedStrings.xml')) if 'xl/sharedStrings.xml' in z.namelist() else None
        def value(c):
            if c.get('t')=='s':return ''.join(ss[int(c.find('s:v',NS).text)].itertext())
            if c.get('t')=='inlineStr':return ''.join(c.find('s:is',NS).itertext())
            v=c.findtext('s:v',namespaces=NS) or ''
            if c.get('t')=='b':return str(v=='1')
            if re.fullmatch(r'[+-]?\d+',v):return str(int(v))
            if re.fullmatch(r'[+-]?(?:\d+\.\d*|\.\d+)(?:[eE][+-]?\d+)?',v):return str(float(v))
            return v
        def col(ref):
            n=0
            for c in re.match(r'[A-Z]+',ref)[0]:n=n*26+ord(c)-64
            return n-1
        result=[]
        for row in root.findall('s:sheetData/s:row',NS):
            cells={col(c.get('r')):value(c) for c in row.findall('s:c',NS)}
            result.append([cells.get(i,'') for i in range(max(cells,default=-1)+1)])
        width=len(result[0]);return [r+['']*(width-len(r)) for r in result]
def reader_files(code,package,stage,metadata):
    code=Path(code);package=Path(package);stage=Path(stage);metadata=Path(metadata)
    companions=json.loads((metadata/'companion-files.json').read_text())
    exports=[]
    for x in companions:
        f=code/x['source_relative_to_code'];payload=f.read_bytes()
        require(hashlib.sha256(payload).hexdigest()==x['sha256'],'Companion source changed: '+str(f))
        require(payload==(package/'05_Supplementary_Data'/x['public_filename']).read_bytes(),'Public companion differs from original workflow output')
        (stage/x['public_filename']).write_bytes(payload);exports.append(x['public_filename'])
    for name,h in json.loads((metadata/'reader-artifacts.json').read_text()).items():
        f=package/'05_Supplementary_Data'/name;require(hashlib.sha256(f.read_bytes()).hexdigest()==h,'Public reader metadata changed: '+name)
        if name not in exports:shutil.copy2(f,stage/name)
    mirrors=[]
    for num,book in [(1,'Supplementary_Data_1_Local_analyses.xlsx'),(2,'Supplementary_Data_2_Reference_genome_analyses.xlsx')]:
        for sheet,suffix in [('INDEX','sheet_index'),('FIELDS','field_dictionary')]:
            with (stage/('Supplementary_Data_'+str(num)+'_'+suffix+'.tsv')).open() as f:expected=list(csv.reader(f,delimiter='\t'))
            rows=sheet_rows(stage/book,sheet);require(rows==expected,'INDEX/FIELDS mirror mismatch: '+book+'/'+sheet)
            mirrors.append({'book':book,'sheet':sheet,'cells':sum(map(len,rows)),'mismatches':0})
    return {'companions_byte_identical_to_workflow':exports,'INDEX_FIELDS_mirrors':mirrors,'new_scientific_analysis':False}
