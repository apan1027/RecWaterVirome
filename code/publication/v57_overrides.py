"""Jinlong Ru; Cunli Pan. Deterministic publication-only additions; no scientific execution."""
from pathlib import Path
from copy import deepcopy
from lxml import etree as E
import csv,hashlib,json,re,zipfile
S='http://schemas.openxmlformats.org/spreadsheetml/2006/main';R='http://schemas.openxmlformats.org/officeDocument/2006/relationships'
REL='http://schemas.openxmlformats.org/package/2006/relationships';CT='http://schemas.openxmlformats.org/package/2006/content-types'
def sha(b):return hashlib.sha256(b).hexdigest()
def figure4(payload,registration):
    assert sha(payload)==registration['source_sha256'],'Unregistered Figure4 source'
    a=registration['before'];b=registration['after'];s=payload.decode();assert s.count(a)==1
    out=s.replace(a,b,1).encode();assert out.decode().replace(b,a,1)==s
    return out
def cell(value,ref):
    n=E.Element('{'+S+'}c',r=ref)
    if value in ('TRUE','FALSE'):
        n.set('t','b');E.SubElement(n,'{'+S+'}v').text='1' if value=='TRUE' else '0'
    elif re.fullmatch(r'[+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?',str(value)):
        E.SubElement(n,'{'+S+'}v').text=str(value)
    else:
        n.set('t','inlineStr');t=E.SubElement(E.SubElement(n,'{'+S+'}is'),'{'+S+'}t');t.text=str(value);t.set('{http://www.w3.org/XML/1998/namespace}space','preserve')
    return n
def letters(n):
    out=''
    while n:n,d=divmod(n-1,26);out=chr(65+d)+out
    return out
def append_rows(root,rows):
    data=root.find('{'+S+'}sheetData');start=max([int(x.get('r')) for x in data]+[0])+1
    for i,values in enumerate(rows,start):
        row=E.SubElement(data,'{'+S+'}row',r=str(i))
        for j,v in enumerate(values,1):row.append(cell(v,letters(j)+str(i)))
    dim=root.find('{'+S+'}dimension')
    if dim is not None:dim.set('ref','A1:'+letters(max(len(x) for x in rows))+str(start+len(rows)-1))
def extend_workbook(source,destination,registration,metadata):
    """Keep all existing scientific worksheet XML byte-identical; append QC sheets and index/dictionary rows."""
    metadata=Path(metadata)
    with zipfile.ZipFile(source) as z:infos=z.infolist();parts={x:z.read(x) for x in z.namelist()}
    for key,expected in registration['base_part_sha256'].items():
        if sha(parts[key])!=expected and key=='docProps/core.xml':
            wanted=(metadata/registration['base_core']).read_bytes()
            def undated(b):
                r=E.fromstring(b)
                for tag in ['created','modified']:
                    for n in r.findall('{http://purl.org/dc/terms/}'+tag):r.remove(n)
                return E.tostring(r,method='c14n')
            assert undated(parts[key])==undated(wanted);parts[key]=wanted
        assert sha(parts[key])==expected,(key,'unregistered base change')
    workbook=E.fromstring(parts['xl/workbook.xml']);rels=E.fromstring(parts['xl/_rels/workbook.xml.rels']);types=E.fromstring(parts['[Content_Types].xml'])
    sheets=workbook.find('{'+S+'}sheets');targets={x.get('Id'):x.get('Target') for x in rels}
    paths={x.get('name'):(targets[x.get('{'+R+'}id')].lstrip('/') if targets[x.get('{'+R+'}id')].startswith('/') else 'xl/'+targets[x.get('{'+R+'}id')]) for x in sheets}
    index=E.fromstring(parts[paths['INDEX']]);fields=E.fromstring(parts[paths['FIELDS']])
    rid=max(int(x.get('Id')[3:]) for x in rels if x.get('Id','').startswith('rId'))
    sheetid=max(int(x.get('sheetId')) for x in sheets);newparts={};indexrows=[];fieldrows=[]
    for spec in registration['sheets']:
        f=metadata/spec['file'];assert sha(f.read_bytes())==spec['sha256']
        with f.open() as h:reader=csv.reader(h,delimiter='\t');rows=list(reader)
        assert len(rows)-1==spec['rows']
        sheetid+=1;rid+=1;target='worksheets/sheet'+str(sheetid)+'.xml';part='xl/'+target
        assert part not in parts
        root=E.Element('{'+S+'}worksheet',nsmap={None:S});E.SubElement(root,'{'+S+'}dimension',ref='A1:'+letters(len(rows[0]))+str(len(rows)))
        views=E.SubElement(root,'{'+S+'}sheetViews');view=E.SubElement(views,'{'+S+'}sheetView',workbookViewId='0');E.SubElement(view,'{'+S+'}pane',ySplit='1',topLeftCell='A2',activePane='bottomLeft',state='frozen')
        E.SubElement(root,'{'+S+'}sheetFormatPr',defaultRowHeight='15');cols=E.SubElement(root,'{'+S+'}cols')
        for j in range(1,len(rows[0])+1):E.SubElement(cols,'{'+S+'}col',min=str(j),max=str(j),width='25',customWidth='1')
        E.SubElement(root,'{'+S+'}sheetData');append_rows(root,rows);E.SubElement(root,'{'+S+'}autoFilter',ref='A1:'+letters(len(rows[0]))+str(len(rows)))
        newparts[part]=E.tostring(root,encoding='UTF-8',xml_declaration=True)
        ss=E.SubElement(sheets,'{'+S+'}sheet',name=spec['sheet'],sheetId=str(sheetid));ss.set('{'+R+'}id','rId'+str(rid))
        E.SubElement(rels,'{'+REL+'}Relationship',Id='rId'+str(rid),Type=R+'/worksheet',Target=target)
        E.SubElement(types,'{'+CT+'}Override',PartName='/'+part,ContentType='application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml')
        indexrows.append([spec['sheet'],spec['rows'],len(rows[0]),spec['figures'],spec['content'],spec['units_and_limits'],'Post-release scoped QC',spec['file']])
        for j,key in enumerate(rows[0],1):
            values=[row[j-1] for row in rows[1:]];non=[v for v in values if v not in ('','NA')]
            typ='logical' if non and set(non)<= {'TRUE','FALSE'} else ('numeric' if non and all(re.fullmatch(r'[+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?',v) for v in non) else 'character')
            desc=spec['fields'][key]
            fieldrows.append([spec['sheet'],j,key,typ,len(values)-len(non),non[0] if non else '',desc,spec.get('field_units',{}).get(key,''),'Blank or NA means not recorded; original flags retained.',True,spec['content'],spec['file']])
    append_rows(index,indexrows);append_rows(fields,fieldrows)
    for part,root in [('xl/workbook.xml',workbook),('xl/_rels/workbook.xml.rels',rels),('[Content_Types].xml',types),(paths['INDEX'],index),(paths['FIELDS'],fields)]:parts[part]=E.tostring(root,encoding='UTF-8',xml_declaration=True)
    if 'docProps/app.xml' in parts:
        a=E.fromstring(parts['docProps/app.xml']);ns={'a':'http://schemas.openxmlformats.org/officeDocument/2006/extended-properties','v':'http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes'}
        titles=a.find('a:TitlesOfParts/v:vector',ns)
        if titles is not None:
            for spec in registration['sheets']:E.SubElement(titles,'{'+ns['v']+'}lpstr').text=spec['sheet']
            titles.set('size',str(len(titles)))
        hp=a.find('a:HeadingPairs/v:vector',ns)
        if hp is not None:
            vs=list(hp)
            for i,v in enumerate(vs[:-1]):
                if ''.join(v.itertext())=='Worksheets':
                    q=vs[i+1].find('v:i4',ns)
                    if q is not None:q.text=str(len(sheets))
        parts['docProps/app.xml']=E.tostring(a,encoding='UTF-8',xml_declaration=True)
    with zipfile.ZipFile(destination,'w') as z:
        for info in infos:z.writestr(info,parts[info.filename])
        for name,payload in newparts.items():
            info=zipfile.ZipInfo(name,date_time=(2026,10,25,0,0,0));info.compress_type=zipfile.ZIP_DEFLATED;z.writestr(info,payload)
    return {'new_sheets':[s['sheet'] for s in registration['sheets']],'existing_scientific_sheet_parts_unchanged':True,'index_rows_added':len(indexrows),'dictionary_rows_added':len(fieldrows)}
