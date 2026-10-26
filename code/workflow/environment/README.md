# Tested environment and installation

Authors (code-document order): Jinlong Ru, Cunli Pan.

The formal reference used R 4.5.2 and Quarto 1.8.27 on Apple Silicon macOS. qproj 0.1.5 was installed from rujinlong/qproj commit `4665814be79e13f7440f26b95279c014e6a5e209` (installed metadata, not an independently fetched remote). DESCRIPTION now records that Remotes pin. tested-packages.tsv and tested-system.txt record the local environment used for this code revision's checks, including transitive package versions and available source-revision metadata. They are an observed environment record, not a verified lockfile or a claim of clean-machine restoration.

## Prepare another machine

Install the matching R and Quarto versions through their official distributions. R packages are listed in DESCRIPTION. The following is a dependency installation recipe to run deliberately in R; it is not executed by any workflow script:

```r
install.packages(c("BiocManager", "remotes"))
d <- read.dcf("DESCRIPTION")
required <- trimws(strsplit(gsub("\n", "", d[1, "Imports"]), ",")[[1]])
BiocManager::install(setdiff(required, "qproj"), ask = FALSE, update = FALSE)
remotes::install_github(
  "rujinlong/qproj@4665814be79e13f7440f26b95279c014e6a5e209",
  upgrade = "never"
)
```

BiocManager selects Bioconductor/CRAN sources for the installed R release. The recipe alone does not pin every dependency: compare the resulting versions with tested-packages.tsv, and resolve differences before claiming equivalent rendering. Source revision availability and repository access may require checking on the destination machine. No packages were installed for this revision.

Arial regular, bold and italic must be installed with valid font licensing; silent font substitution is refused. Current figures/style proof use English text and do not require the optional legacy CJK font. systemfonts resolves font files; no personal font path is hard-coded in the R workflow. SVG viewers need matching fonts. Linux may also need system libraries for sf, pdftools, xml2, ragg and graphics devices (GDAL/GEOS/PROJ, poppler, XML and font/graphics libraries).

The exporter probes cairo_pdf and then quartz_pdf in the declared order; Quartz is macOS-specific. The reference machine used Quartz when its X11/cairo libraries were unavailable. A different working graphics device may change PDF metadata or rendering bytes without changing plotted values. Run `Rscript scripts/check-environment.R`, then the non-scientific style proof if graphics validation is needed. The Python historical-material scripts require PyMuPDF, NumPy, PyYAML and Pillow, and PyMOL only for the optional saved-structure overlay; they do not generate the final current S3 layout.

## Verification boundary

The revision's 160 unit/regression checks use isolated fixtures. The full Quarto toy-render test is blocked on this restricted host and is not counted as passed; six non-rendering contracts and four post-render conversion checks using an isolated Pandoc-only launcher passed. Five drawing-only replays passed 477 export checks with zero warnings and byte-identical PNGs; no scientific analysis/model was rerun. Each future actual run writes its own session-info.txt and source/input/output hashes. This package supplies all registered staged inputs; it does not supply raw sequencing reads, sequence-analysis databases or a full upstream bioinformatics environment.

## Temporary vector capture

Installing Arial does not add it to R's PostScript font database. rwv_capture_grob therefore avoids grid.grabExpr's default pdf(NULL) device and opens a real temporary PDF through the existing verified cairo/Quartz selection. Regular and bold Arial embedding is checked before capture. This uses existing dependencies; it neither aliases Arial to another family nor suppresses device warnings.

## Completed execution on 2026-10-20

The previous blocked-full-render statement describes the earlier Codex-only checks. Claude subsequently completed the fixed-source 21-step Quarto run 20261020T001926-86706 and all 13 real report-sync probes in the configured environment. Codex independently verified the delivered source/input/output records and strict synchronization and adopted that complete run. The package already includes readable reports: no initial rerender is needed. Clean-machine restoration remains untested. Full evidence and accurate test counts (167 passed, three optional skips) are in ../../review-2026-10-20/Codex-acceptance.md.
