"""Reproducible publication edits; no scientific calculations. Jinlong Ru, Cunli Pan."""
from pathlib import Path
from lxml import etree as E
import hashlib,json,re,zipfile
SVG={'s':'http://www.w3.org/2000/svg'}
S={'s':'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}
ST='{'+S['s']+'}'

def figure2(payload,registered):
    assert hashlib.sha256(payload).hexdigest()==registered['source_sha256'],'Unreviewed Figure2 source'
    r=E.fromstring(payload);changes=[]
    labels={'Water position':'Water type','c: treated wastewater':'c: reclaimed water','d: process water':'d: wastewater','Outline: host co-detected':'Outline: 16S genus detected'}
    for old,new in labels.items():
        nodes=r.xpath('//s:text[text()=$t]',namespaces=SVG,t=old);assert len(nodes)==1,(old,len(nodes))
        n=nodes[0];n.text=new
        for k in ['textLength','lengthAdjust']:n.attrib.pop(k,None)
        changes.append({'text_before':old,'text_after':new})
    old_y=436.23;axis_y=443.0;point_y=432.0
    dark=[];axes=[];ticks=[];points=[];tick_text=[]
    for line in r.xpath('//s:line',namespaces=SVG):
        y1=float(line.get('y1','0'));y2=float(line.get('y2','0'))
        if abs(y1-old_y)<0.001 and abs(y2-old_y)<0.001:
            if '#2F3E46' in line.get('style',''):dark.append(line)
            elif '#D9D9D9' in line.get('style',''):axes.append(line)
        elif abs((y1+y2)/2-old_y)<0.001 and line.get('x1')==line.get('x2'):ticks.append(line)
    for n in r.xpath('//s:circle',namespaces=SVG):
        if abs(float(n.get('cy','0'))-old_y)<0.001:points.append(n)
    for n in r.xpath('//s:text',namespaces=SVG):
        y=float(n.get('y','0'))
        if 440<y<453 and n.text in ['−1','-1','0','1']:tick_text.append(n)
    assert [len(dark),len(axes),len(ticks),len(points),len(tick_text)]==[3,3,9,3,9]
    xs=[float(n.get('cx')) for n in points]
    for n in dark:n.getparent().remove(n)
    for n in axes:n.set('y1',str(axis_y));n.set('y2',str(axis_y))
    for n in ticks:
        for k in ['y1','y2']:n.set(k,f'{float(n.get(k))+axis_y-old_y:.2f}')
    for n in points:n.set('cy',str(point_y))
    for n in tick_text:n.set('y','451.40')
    assert [float(n.get('cx')) for n in points]==xs
    expected=['r = 0.416; p = 0.115','r = 0.129; p = 0.328','r = 0.699; p = 0.002']
    assert all(len(r.xpath('//s:text[text()=$t]',namespaces=SVG,t=t))==1 for t in expected)
    out=E.tostring(r,encoding='UTF-8',xml_declaration=True)
    return out,{'labels':changes,'removed_dark_lines':3,'point_x_coordinates_unchanged':xs,'point_y':point_y,'axis_y':axis_y,'r_p_text_unchanged':expected}

def string_value(cell,parts):
    if cell.get('t')=='inlineStr':return ''.join(cell.find('s:is',S).itertext())
    if cell.get('t')=='s':
        shared=E.fromstring(parts['xl/sharedStrings.xml'])
        return ''.join(shared[int(cell.findtext('s:v',namespaces=S))].itertext())
    return cell.findtext('s:v',namespaces=S) or ''

def workbook(source,destination,registration):
    with zipfile.ZipFile(source) as z:infos=z.infolist();parts={x:z.read(x) for x in z.namelist()}
    trees={}
    for change in registration['changes']:
        name=change['part'];r=trees.setdefault(name,E.fromstring(parts[name]))
        cells=r.xpath('.//s:c[@r=$address]',namespaces=S,address=change['cell']);assert len(cells)==1
        c=cells[0];assert c.get('t') in ['s','inlineStr'],'Publication edit is not a string cell'
        assert string_value(c,parts)==change['before'],change
        for child in list(c):c.remove(child)
        c.set('t','inlineStr');t=E.SubElement(E.SubElement(c,ST+'is'),ST+'t');t.text=change['after']
    for name,r in trees.items():parts[name]=E.tostring(r,encoding='UTF-8',xml_declaration=True)
    with zipfile.ZipFile(destination,'w',zipfile.ZIP_DEFLATED) as z:
        for info in infos:z.writestr(info,parts[info.filename])
    return sorted(trees)
