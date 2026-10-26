# Environment and scope

Authors: Jinlong Ru; Cunli Pan.

- Recorded computational environment: R 4.5.2, Quarto 1.8.27; see [workflow/environment](code/workflow/environment/README.md), `code/workflow/DESCRIPTION`, and the saved session records. qproj is pinned there to commit `4665814be79e13f7440f26b95279c014e6a5e209`.
- Integrity checker: Python 3 standard library.
- Publication reconstruction/regression checks: Python with lxml/Pillow; Node.js with sharp; R and the packages required by the saved workflow synchronization check.
- Font rendering: licensed local Arial installation. Fonts are not distributed. `RWV_ARIAL_DIR` selects their directory. `RWV_NODE`, `NODE_PATH` and `RWV_PYTHON` can select existing compatible runtimes; no installation happens automatically.
- Existing scripts may detect an installed Codex runtime as a convenience fallback. Codex is not required; ordinary compatible Python and Node environments are supported.
- The packaging check is not a clean-machine installation test, an upstream sequencing workflow, a new model fit or cross-platform pixel-equivalence certification.

Use a separate execution copy for intentional reruns. Do not execute archived model scripts in their archival directory; some overwrite saved results. Additional QC prerequisites are documented beside their original scripts.
