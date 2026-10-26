#!/usr/bin/env python3
"""Clean packaging checks and rejection of unregistered input changes.

Authors: Jinlong Ru; Cunli Pan. No scientific execution.
"""
from pathlib import Path
import json, shutil, sys, tempfile, zipfile
CODE=Path(__file__).resolve().parent
sys.path.insert(0,str(CODE/'publication'))
from bmc_clean_release import workbook_delta,parts,verify_added_tables,sha

metadata=CODE/'metadata_bmc_clean';reg=json.loads((metadata/'workbook-delta.json').read_text())
historical=CODE.parent/'reference/05_Supplementary_Data'
reference=CODE.parent/'reference/bmc-clean-2026-10-26/Supplementary_Data'
with tempfile.TemporaryDirectory(prefix='rwv-clean-regression-') as tmp:
    tmp=Path(tmp)
    for row in reg['books']:
        source=historical/row['filename'];dest=tmp/row['filename']
        workbook_delta(source,dest,row,metadata)
        assert parts(dest)==parts(reference/row['filename'])
        print('PASS: registered clean workbook reconstructed:',row['filename'])
    shutil.copy2(metadata/reg['register']['filename'],tmp/reg['register']['filename'])
    checked=verify_added_tables(tmp,historical)
    assert len(checked)==6
    print('PASS: all added tables and 66-row register match source values; keyword literals and S62 clarification match')
    row=reg['books'][0];bad=tmp/'bad-base.xlsx'
    with zipfile.ZipFile(historical/row['filename']) as z,zipfile.ZipFile(bad,'w') as out:
        for name in z.namelist():out.writestr(name,z.read(name)+(b'\n' if name=='xl/worksheets/sheet3.xml' else b''))
    try:workbook_delta(bad,tmp/'rejected.xlsx',row,metadata)
    except RuntimeError:pass
    else:raise AssertionError('Unregistered scientific workbook change was accepted')
    print('PASS: changed inherited scientific input is rejected')
    changed=tmp/'bad-metadata';shutil.copytree(metadata,changed)
    patch=changed/row['changes'][0]['patch'];patch.write_bytes(patch.read_bytes()+b'\n')
    try:workbook_delta(historical/row['filename'],tmp/'rejected-patch.xlsx',row,changed)
    except RuntimeError:pass
    else:raise AssertionError('Unregistered packaging patch was accepted')
    print('PASS: altered clean packaging metadata is rejected')
print('All clean-release checks passed; no scientific execution')
