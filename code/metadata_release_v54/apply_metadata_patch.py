"""Jinlong Ru; Cunli Pan. Legacy entry retained as a safe current-release verifier.
The original v54 implementation is archived in apply_metadata_patch_v54-original.py.txt.
It must not overwrite a later multi-layer publication workbook.
"""
from pathlib import Path
import subprocess,sys
if __name__=='__main__':
    code=Path(__file__).resolve().parents[1]
    subprocess.run([sys.executable,str(code/'sync_publication.py'),'--check'],check=True)
