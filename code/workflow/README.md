# RecWaterVirome workflow

Authors (code-document order): [Jinlong Ru](https://orcid.org/0000-0002-6757-6018), [Cunli Pan](https://orcid.org/0000-0002-2595-7533).

Current code: 0.1.1, revised inside submission package v50.1 on 2026-10-19. Scientific analysis: analysis-v2026.09.28.1.

Read [docs/WORKFLOW-GUIDE.md](docs/WORKFLOW-GUIDE.md), [environment/README.md](environment/README.md) and [CODE-CHANGELOG.md](CODE-CHANGELOG.md). Start with `python3 ../check_inputs.py --require-raw` and `Rscript scripts/check-environment.R`. The default entry is `Rscript scripts/render.R`; optional checks use `--with-checks`.

All registered staged inputs are supplied. This is not an upstream raw-sequence workflow. Historical records live in archive/ and are preserved separately from the English current code. GitHub/Nextcloud publication awaits the author's final confirmation.

Figure previews are emitted after staged outputs are published. Check generated image references with `python3 scripts/check-report-images.py`; test the path-lifetime regression with `Rscript scripts/selftest-published-preview.R`.
