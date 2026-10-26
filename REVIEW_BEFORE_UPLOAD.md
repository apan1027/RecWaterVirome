# Personal repository upload

Date: 2026-10-26. Authors: Jinlong Ru; Cunli Pan. Maintainer: Cunli Pan.

The author authorised placing the prepared code on their own GitHub. This independent snapshot contains the checked publication workflow, selected processed inputs, saved reports and reference figures/data. The baseline is **BMC_Microbiology_submission_clean_2026-10-26**. Main/SI Word files and the cover letter are excluded. No new scientific analyses are performed.

## Upload from your terminal

Run `bash UPLOAD_TO_GITHUB.sh` here, or give the script's absolute path. The default repository name is `p0061-RecWaterVirome-code`; an optional first argument selects another name. The script uses the owner returned by the existing GitHub CLI login, creates a private repository if absent, refuses an existing public destination or mismatched origin, and pushes only `dev_pan` without force. It verifies the uploaded commit before reporting success. Upload receipts go in `.git/`, outside the scientific payload.

Automatic upload in the preparation environment was blocked by the GitHub API domain allowlist, including an approved retry. No remote creation or upload is claimed. Local preparation receipts are dated evidence, not a report of subsequent remote actions.

## Scope

- Inspect [the nine figure previews](PREVIEWS.md), [figure/code mapping](FIGURE_CODE_MAP.tsv) and [analysis navigation](code/workflow/analyses/README.md).
- The inherited repository licence is preserved in [upstream-LICENSE.md](provenance/upstream-LICENSE.md). Imported-workflow licence scope remains unresolved; this packaging grants no new licence. Upload defaults to private.
- Historical paths remain in frozen provenance and model scripts. They are not credentials or a claim that default verification requires those external locations.
- Original sequencing reads, raw-data deposition and archival DOI creation are outside this upload. No accession is invented.
- The latest author-saved Word files were checked by embedded-image content: all five main and four supplementary figures match. Word text is outside this snapshot. Later author edits need a fresh comparison.

The senior colleague's repository, branch and working files are not modified. Packaging/reconstruction checks do not constitute scientific or submission approval.
