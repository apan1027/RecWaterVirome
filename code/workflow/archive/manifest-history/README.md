# 010 manifest history (content-addressed)

Authors (display order): Jinlong Ru, Cunli Pan.

Each file is named `<stem>-<sha256>.<ext>` and must hash to that SHA; `R/workflow.R` (`rwv_history_file`) refuses a
file whose bytes do not. `rwv_manifest_reuse()` uses them to compare the 010 manifest a step recorded with the current
one, row by row, and the recorded `config/workflow.yml` with the current one, step by step. A step is reused only when
every difference is review/publication metadata; a missing history file means no reuse.

- `input-manifest-8bbb42e8….tsv`: the 010 manifest of run 20261018T190404-1499, byte-identical to the copy sealed in
  `deliveries/2026-10-18-v45-text-s1_analysis-v2026.09.28.1_run-20261018T190404-1499/runs/010-input-manifest/`.
- `workflow-31b57367….yml`: `config/workflow.yml` registered in that manifest (frozen-files hash before 2026-10-19).
- `workflow-79cc1ab9….yml`: `config/workflow.yml` after the v50 release closeout (only 900's project inputs changed).

Added 2026-10-19 (v50 release closeout, Codex task book docs/figure-cleanup-v49-2026-10-19/03); never edit in place.
