# Analysis inputs

The code repository contains input lists, not the large scientific datasets.

- [inputs.tsv](inputs.tsv): 136 required files, their project-relative destinations and SHA256 identities. This includes 124 processed analysis inputs and 12 saved supplementary-export inputs.
- [method-inputs.tsv](method-inputs.tsv): separately supplied inputs for the optional model and diagnostic scripts in `dev/`.
- [source-checksums.tsv](source-checksums.tsv): source and parameter checksums used by the input-checking analysis.

Place each required file at its listed project-relative path, typically `analyses/data/00-raw/d<analysis>/`. Contact the maintainer for these inputs; no public download URL or accession is asserted here. The additional worksheet TSVs contain adopted saved cells, not newly fitted results.

Analyses create their working products under `analyses/data/<analysis>/`. These generated directories and large data files are ignored by Git. Full annotation SQLite data are required for the optional VF-position diagnostic; a reduced community snapshot is insufficient.
