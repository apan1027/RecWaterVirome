#!/usr/bin/env python3
"""Exercise the actual post-render hook using a Pandoc-only test launcher.

Authors (display order): Jinlong Ru, Cunli Pan.
This validates the hook/conversion contract, not the restricted Quarto launcher.
No R analysis chunks are executed by the test launcher.
"""
from pathlib import Path
import os,shutil,subprocess,sys,tempfile

ROOT=Path(__file__).resolve().parents[1]
PANDOC=shutil.which('pandoc')
if not PANDOC:sys.exit('Pandoc is required; no post-render test ran.')
passed=0
def ok(name,value):
    global passed
    if not value:raise AssertionError(name)
    passed+=1;print('PASS',name)

with tempfile.TemporaryDirectory(prefix='rwv-hook-') as folder:
    base=Path(folder)
    launcher=base/'markdown-only-launcher'
    launcher.write_text('#!'+sys.executable+'\n'+f'''import subprocess,sys
args=sys.argv[1:]
assert args[0]=='render'
source=args[1];dest=args[args.index('--output')+1]
raise SystemExit(subprocess.run([{PANDOC!r},source,'--from','markdown+raw_html','--to','gfm','--output',dest]).returncode)
''')
    launcher.chmod(0o700)
    for markers in [True,False]:
        wf=base/('with-markers' if markers else 'ordinary')
        analyses=wf/'analyses';analyses.mkdir(parents=True)
        if markers:
            (wf/'R').mkdir();shutil.copy2(ROOT/'R/report.R',wf/'R/report.R')
            text='''<!-- RWV_REPORT_SUMMARY_POSITION -->

<details><summary>Analysis detail</summary>

Recorded results.

</details>

<!-- RWV_REPORT_SUMMARY_START -->
<section class="rwv-report-summary"><h2>Run summary</h2><p>Complete</p></section>
<!-- RWV_REPORT_SUMMARY_END -->
'''
        else:text='## Ordinary report\n\nSaved results.\n'
        kept=analyses/'probe.html.md';kept.write_text(text)
        html=analyses/'probe.html'
        subprocess.run([PANDOC,str(kept),'--from','markdown+raw_html','--to','html5','--output',str(html)],check=True)
        env=os.environ.copy();env.pop('RWV_GFM_CONVERTING',None)
        env.update(QUARTO_PATH=str(launcher),QUARTO_PROJECT_OUTPUT_FILES=str(html))
        result=subprocess.run(['Rscript',str(ROOT/'scripts/gfm-from-knit.R')],cwd=analyses,env=env,capture_output=True,text=True)
        if result.returncode:raise RuntimeError(result.stdout+result.stderr)
        md=analyses/'probe.md'
        if markers:
            ok('actual post-render hook relocates overview in HTML and GFM',
               all(p.read_text().index('rwv-report-summary')<p.read_text().index('<details>')
                   and 'RWV_REPORT_SUMMARY_POSITION' not in p.read_text() for p in [html,md]))
        else:
            ok('ordinary reports still convert without any report-helper file',md.exists() and 'Saved results.' in md.read_text())
        ok(('marker' if markers else 'ordinary')+' reports retain matched timestamps and remove intermediates',
           md.stat().st_mtime==html.stat().st_mtime and not kept.exists() and not (analyses/'probe.knit-gfm.md').exists())
print(f'All {passed} post-render conversion checks passed (isolated Pandoc-only launcher).')
