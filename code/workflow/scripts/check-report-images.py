#!/usr/bin/env python3
"""Check local image references in generated HTML/Markdown without rendering.

Authors (code-document order): Jinlong Ru, Cunli Pan.
This checks image availability, not scientific correctness or source freshness.
"""
from pathlib import Path
from html.parser import HTMLParser
from urllib.parse import unquote, urlsplit
import base64
import re
import sys

root = Path(__file__).resolve().parents[1]
reports = sorted([*(root/'analyses').glob('*.html'), *(root/'analyses').glob('*.md')])
errors = []
count = 0
remote = 0
class Images(HTMLParser):
    def __init__(self):
        super().__init__();self.sources=[]
    def handle_starttag(self, tag, attrs):
        if tag == 'img':self.sources.append(dict(attrs).get('src',''))

for report in reports:
    text=report.read_text();parser=Images();parser.feed(text)
    sources=parser.sources + (re.findall(r'!\[[^\]]*\]\(([^)]+)\)',text) if report.suffix=='.md' else [])
    for src in sources:
        count+=1
        if '.rwv-staging' in src:
            errors.append(f'{report.name}: temporary staging reference {src}')
        elif src.startswith('data:'):
            try:
                head,payload=src.split(',',1)
                if ';base64' in head:base64.b64decode(payload,validate=True)
            except (ValueError,TypeError):errors.append(f'{report.name}: malformed embedded image')
        elif urlsplit(src).scheme in ('http','https'):
            remote+=1
        elif not src or not (report.parent/unquote(urlsplit(src).path)).is_file():
            errors.append(f'{report.name}: missing local image {src}')
if not reports:
    print('NO REPORTS: render a QMD before checking generated image references.');sys.exit(2)
print(f'{"FAIL" if errors else "PASS"}: {len(reports)} reports, {count} image references, {len(errors)} broken/staging references; {remote} remote references unverified.')
for error in errors:print(error)
sys.exit(1 if errors else 0)
