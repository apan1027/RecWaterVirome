from pathlib import Path
import hashlib,json
p=Path(__file__).resolve().parent
manifest=json.loads((p/'source-manifest.json').read_text())
for row in manifest:
 f=p/row['path']
 assert f.is_file() and hashlib.sha256(f.read_bytes()).hexdigest()==row['sha256'],row['path']
for script,inputs in json.loads((p/'declared-file-dependencies.json').read_text()).items():
 for rel in inputs:assert (p/'original-layout'/rel).is_file(),(script,rel)
print(json.dumps({'files_verified':len(manifest),'declared_input_files_present':True,'model_fitting_executed':False}))
