#!/usr/bin/env python3
"""Reconstruct figures and attachments against BMC_Microbiology_submission_clean_2026-10-26.

Authors: Jinlong Ru; Cunli Pan. Default and --check never run new science.
"""
from pathlib import Path
import argparse,hashlib,json,os,shutil,subprocess,sys,tempfile
CODE=Path(__file__).resolve().parent
sys.path.insert(0,str(CODE/'publication'))
from bmc_clean_release import assemble
def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check',action='store_true',help='Reconstruct and compare in temporary storage only')
    parser.add_argument('--render',action='store_true',help='Explicitly rerun the established workflow before verification')
    args=parser.parse_args();env=os.environ.copy();env['PYTHONDONTWRITEBYTECODE']='1'
    with tempfile.TemporaryDirectory(prefix='rwv-bmc-clean-') as folder:
        folder=Path(folder);legacy=folder/'historical';target=folder/'current'
        command=[sys.executable,str(CODE/'build_v58_2.py'),'--check','--artifact-dir',str(legacy)]
        if args.render:command.append('--render')
        result=subprocess.run(command,env=env,capture_output=True,text=True)
        if result.returncode:
            raise RuntimeError('Historical workflow/publication chain failed:\n'+result.stdout+result.stderr)
        previous=json.loads((legacy/'publication-check.json').read_text())
        receipt=assemble(legacy,target,CODE)
        receipt['strict_workflow_sync']=previous['strict_workflow_sync']
        receipt['saved_step_count']=previous['step_count']
        receipt['run_ids']=previous['run_ids']
        receipt['step_records']=previous['step_records']
        receipt['explicit_workflow_render']=args.render
        receipt['new_scientific_analysis']=args.render
        receipt['baseline_receipt']='provenance/bmc-clean-baseline.json'
        receipt['files']={str(p.relative_to(target)):hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(target.rglob('*')) if p.is_file()}
        (target/'publication-check.json').write_text(json.dumps(receipt,indent=2)+'\n')
        if not args.check:
            dest=CODE/'publication/current-bmc-clean-2026-10-26'
            if dest.exists():raise RuntimeError('Current output exists; use --check or choose a separate execution copy')
            shutil.copytree(target,dest)
        print(json.dumps(receipt,indent=2))
if __name__=='__main__':main()
