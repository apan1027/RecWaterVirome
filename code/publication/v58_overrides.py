"""Jinlong Ru; Cunli Pan. Registered INDEX/FIELDS wording only; preserve scientific XML."""
from lxml import etree as E
import hashlib,zipfile
NS={'s':'http://schemas.openxmlformats.org/spreadsheetml/2006/main'};T='{'+NS['s']+'}'
def workbook_labels(source,destination,record):
    with zipfile.ZipFile(source) as z:infos=z.infolist();parts={k:z.read(k) for k in z.namelist()}
    assert set(parts)==set(record['base_part_sha256'])
    assert all(hashlib.sha256(v).hexdigest()==record['base_part_sha256'][k] for k,v in parts.items()),'Unregistered v57 workbook input'
    shared=E.fromstring(parts['xl/sharedStrings.xml']) if 'xl/sharedStrings.xml' in parts else None
    def value(c):
        if c.get('t')=='s':return ''.join(shared[int(c.find('s:v',NS).text)].itertext())
        if c.get('t')=='inlineStr':return ''.join(c.find('s:is',NS).itertext())
        return None
    for part in record['changed_parts']:
        root=E.fromstring(parts[part])
        for item in [x for x in record['cells'] if x['part']==part]:
            assert item['sheet'] in ['INDEX','FIELDS']
            cells=root.xpath('.//s:c[@r="'+item['cell']+'"]',namespaces=NS);assert len(cells)==1;cell=cells[0]
            assert value(cell)==item['before'] and cell.find('s:f',NS) is None
            for c in list(cell):cell.remove(c)
            cell.set('t','inlineStr');t=E.SubElement(E.SubElement(cell,T+'is'),T+'t');t.text=item['after'];t.set('{http://www.w3.org/XML/1998/namespace}space','preserve')
        parts[part]=E.tostring(root,encoding='UTF-8',xml_declaration=True)
    with zipfile.ZipFile(destination,'w') as z:
        for info in infos:z.writestr(info,parts[info.filename])
    return {'public_filename':record['public_filename'],'string_cells_changed':len(record['cells']),'only_INDEX_FIELDS_changed':True}
