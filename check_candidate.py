#!/usr/bin/env python3
"""Jinlong Ru; Cunli Pan. Read-only integrity checks of the local code candidate.

No scientific execution, model importing, network access, or file modification.
"""
from pathlib import Path
import csv, hashlib, json, re, sys
from urllib.parse import unquote

ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def table(p):
    with p.open(encoding='utf-8') as f:return list(csv.DictReader(f,delimiter='\t'))
def is_runtime(p):
    return any(s in ('.git','__pycache__','.Rproj.user','.quarto') for s in p.parts) or p.name in ('.DS_Store','.Rhistory','.RData','.Rdata') or p.suffix=='.pyc'
def main():
    errors=[];manifest=table(ROOT/'FILE_MANIFEST.tsv')
    for r in manifest:
        f=ROOT/r['path']
        if not f.is_file() or f.is_symlink() or sha(f)!=r['sha256']:errors.append('Candidate file missing/changed: '+r['path'])
    expected={r['path'] for r in manifest}|{'FILE_MANIFEST.tsv','LOCAL_CHECKS.json'}
    actual={str(f.relative_to(ROOT)) for f in ROOT.rglob('*') if f.is_file() and not is_runtime(f.relative_to(ROOT))}
    errors += ['Unmanifested candidate file: '+p for p in sorted(actual-expected)]
    copies=table(ROOT/'provenance/copied-sources.tsv')
    for r in copies:
        if r['status']=='byte-identical' and sha(ROOT/r['path'])!=r['sha256']:errors.append('Copied scientific/source file changed: '+r['path'])
    wf=ROOT/'code/workflow'
    counts={}
    for name in ('raw-inputs.tsv','frozen-files.tsv'):
        register=table(wf/'metadata'/name);counts[name]=len(register)
        for r in register:
            p=wf/r['path']
            if not p.is_file() or sha(p)!=r['sha256']:errors.append('Registered input changed: '+r['path'])
    if counts['raw-inputs.tsv']!=124:errors.append('Expected 124 staged inputs')
    source_receipt=json.loads((ROOT/'provenance/submission-publication-check.json').read_text())
    records=sorted((wf/'analyses/data').glob('*/step-record.json'))
    registered={r['step']:r for r in source_receipt['step_records']}
    if len(records)!=21:errors.append('Expected 21 saved workflow records')
    for p in records:
        r=json.loads(p.read_text());old=registered.get(p.parent.name,{})
        if r.get('status')!='complete' or sha(p)!=old.get('record_sha256') or r.get('run_id')!=old.get('run_id'):errors.append('Workflow record changed: '+p.parent.name)
    ma=ROOT/'code/model_archive'
    models=json.loads((ma/'source-manifest.json').read_text())
    for r in models:
        p=ma/r['path']
        if not p.is_file() or sha(p)!=r['sha256']:errors.append('Model archive file changed: '+r['path'])
    for script,inputs in json.loads((ma/'declared-file-dependencies.json').read_text()).items():
        for rel in inputs:
            if not (ma/'original-layout'/rel).is_file():errors.append('Model dependency missing: '+rel)
    patterns=[re.compile(r'github_pat_[A-Za-z0-9_]{30,}'),re.compile(r'gh[pousr]_[A-Za-z0-9]{30,}'),re.compile(r'-----BEGIN (?:RSA |OPENSSH |EC )?PRIVATE KEY-----')]
    private_path_files=[];secret_files=[]
    for r in manifest:
        p=ROOT/r['path']
        if p.name=='.env' or p.name.startswith('.env.') or p.name=='.Renviron':errors.append('Environment file included: '+r['path']);continue
        if p.suffix.lower() not in ('.py','.r','.cjs','.js','.qmd','.md','.tsv','.json','.yml','.yaml','.txt','.html','.cff'):continue
        try:contents=p.read_text(encoding='utf-8')
        except UnicodeError:continue
        if '/Users/' in contents or '/home/' in contents or '/scratch/' in contents:private_path_files.append(r['path'])
        if any(pattern.search(contents) for pattern in patterns):secret_files.append(r['path'])
    errors += ['Potential credential marker requires review: '+p for p in secret_files]
    # Navigation is a checked interface: do not infer supplementary figure IDs
    # from historical notebook filenames.
    figure_specs={}
    for line in (wf/'config/figures.yml').read_text().splitlines():
        match=re.search(r'^\s+\w+:\s*\{step:\s*([^,]+),\s*label:\s*"([^"]+)"',line)
        if match:figure_specs[match.group(2)]=match.group(1).strip()
    mappings=table(ROOT/'FIGURE_CODE_MAP.tsv');figure_mapping_count=0
    for row in mappings:
        label=row['manuscript_item'].replace('Supplementary Fig. S','Supplementary Figure ').replace('Fig. ','Figure ')
        if label in figure_specs:
            figure_mapping_count+=1
            if Path(row['qmd']).stem!=figure_specs[label]:errors.append('Incorrect current figure/code mapping: '+row['manuscript_item'])
        for key in ('qmd','report','current_preview','final_publication_entry'):
            if row.get(key) and not (ROOT/row[key]).is_file():errors.append('Missing mapped '+key+': '+row[key])
    if figure_mapping_count!=9:errors.append('Expected nine checked figure assignments')
    navs=[ROOT/'README.md',ROOT/'PREVIEWS.md',ROOT/'REVIEW_BEFORE_UPLOAD.md',ROOT/'code/workflow/analyses/README.md',ROOT/'reference/bmc-clean-2026-10-26/README.md']
    navigation_links=0
    for page in navs:
        if not page.is_file():errors.append('Missing navigation document: '+str(page.relative_to(ROOT)));continue
        for target in re.findall(r'!?\[[^\]]*\]\(([^)]+)\)',page.read_text()):
            target=target.strip('<>').split('#')[0]
            if not target or re.match(r'^[a-z]+:',target):continue
            navigation_links+=1
            if not (page.parent/unquote(target)).exists():errors.append('Broken navigation link in '+str(page.relative_to(ROOT))+': '+target)
    clean=json.loads((ROOT/'provenance/bmc-clean-baseline.json').read_text())
    if clean.get('baseline')!='BMC_Microbiology_submission_clean_2026-10-26':errors.append('Wrong current publication authority')
    cleanroot=ROOT/'reference/bmc-clean-2026-10-26'
    for rel,expected_sha in clean['clean_files'].items():
        if rel.endswith('.docx'):continue
        f=cleanroot/rel
        if not f.is_file() or sha(f)!=expected_sha:errors.append('Current clean reference asset differs: '+rel)
    result=dict(status='PASS' if not errors else 'FAIL',manifest_files=len(manifest),byte_identical_source_copies=sum(r['status']=='byte-identical' for r in copies),packaging_adjusted_source_copies=[r['path'] for r in copies if r['status']!='byte-identical'],registered_inputs=counts['raw-inputs.tsv'],frozen_files=counts['frozen-files.tsv'],saved_step_records=len(records),model_archive_files=len(models),potential_credential_marker_files=secret_files,historical_path_files=private_path_files,history_path_review_pending=bool(private_path_files),errors=errors,scientific_execution=False,network_access=False)
    result.update(current_authority=clean['baseline'],checked_figure_assignments=figure_mapping_count,checked_navigation_links=navigation_links)
    print(json.dumps(result,indent=2))
    return int(bool(errors))
if __name__=='__main__':sys.exit(main())
