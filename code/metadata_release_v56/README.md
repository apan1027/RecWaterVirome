# v56.1 publication provenance

Authors (code-document order): Jinlong Ru, Cunli Pan.

figure2-patch.json registers the SHA256 of the accepted v54 SVG. publication/v56_overrides.py changes only the two sample-category labels, reference-axis layout of the existing three Mantel points and the outline label; it checks all r/p strings and preserves their x coordinates.

data1-patch.json lists all 15 changed string cells by worksheet, XML part and address, with exact before/after text. Numeric values, scientific rows and all original data remain unchanged. The v54 S37 metadata correction is applied first by sync_publication.py. The current original workflow is retained unchanged as the computational base.

No analysis or model was run to create these publication edits. See ../../V56_执行与核验说明.md for checks and the manuscript issue ledger for author decisions. Historical source material and earlier publication layers remain labelled separately.
