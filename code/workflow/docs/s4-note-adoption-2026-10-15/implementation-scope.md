# S4-to-Note adoption: implementation scope (2026-10-15)

Reviewer identity: Codex, implementer. Status: independent review pending.

Authorized scope: replace the independent six-panel S4 with Supplementary Note 4, a three-row saved-result Firth summary and Data 2 navigation; update v25 writing, workflow/bundle and learning HTML. The original v24 delivery and all scientific detail including failed fits remain traceable. Figure 1–5 and S1–S3 designs are unchanged; only Figure 5 caption navigation changes.

Existing full entry: `Rscript scripts/render.R --with-checks`. This re-executes the existing 012 TSE construction and 020 community calculations, optional legacy/style checks, saved-input extraction, figure exports and packaging. It does not refit global models or rerun upstream annotations. Numeric assertions and per-sheet packaging checks remain required. Step 240 now checks saved results and writes the Note. Expected metadata changes: run/time/session/export records, configuration hashes, Data 2 INDEX/navigation and definition pointers; scientific values are expected unchanged.

This record declares scope and pending independent review; it does not pre-certify the forthcoming run. Implementation comparisons, failures and final checks are recorded in `outputs/s4-note-adoption-2026-10-15/REPORT.md`. That mutable report is not an independent review or an active frozen review basis. A later independent reviewer must separately register their scope and report.
