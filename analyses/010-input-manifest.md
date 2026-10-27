# Verify registered scientific inputs and current code/configuration

Jinlong Ru; Cunli Pan.

[Editable QMD](010-input-manifest.qmd) · [Analysis index](README.md)

Source reading companion with accepted figure previews; not a new scientific execution report.

## Tasks

This step verifies registered design/configuration files against analyses/data/source-checksums.tsv and staged scientific inputs against analyses/data/inputs.tsv. Inputs were copied or extracted read-only from the source project with source paths and SHA256 provenance. Missing, changed or unregistered raw files stop the step. The source project is not accessed at runtime.

### Task 1: Verify the frozen-file register

The frozen-file register supplies the expected SHA256 of each registered file. Every hash is recomputed and compared. The register itself is the trust anchor; its own hash is recorded rather than compared with itself.

```r
register_file <- "analyses/data/source-checksums.tsv"
register <- rwv_register_read(step, register_file)
verified <- rwv_register_verify(step, register)
register_path <- file.path(step$root, register_file)
manifest <- rbind(
  data.frame(
    path = register_file, role = "register", bytes = file.size(register_path),
    sha256 = rwv_sha256(register_path), expected_sha256 = NA_character_,
    status = "root of trust (no expected hash)", origin = "project-authored", source_sha256 = ""
  ),
  verified
)
rwv_write_tsv(manifest, path_target("input-manifest.tsv"))
knitr::kable(
  transform(manifest[, c("path", "role", "bytes", "status")], sha256 = substr(manifest$sha256, 1, 16)),
  caption = "input-manifest.tsv (sha256 shortened here; full values are in the file)"
)
```

### Task 2: Verify staged scientific inputs

The raw-input register is itself hash-verified in Task 1. This task recomputes each staged input hash; downstream steps access these verified files through rwv_raw_input().

```r
raw_register <- rwv_raw_register_read(step, "analyses/data/inputs.tsv")
raw_manifest <- rwv_raw_register_verify(step, raw_register, path_raw)
rwv_write_tsv(raw_manifest, path_target("raw-input-manifest.tsv"))
science <- aggregate(list(files = raw_manifest$path), list(consumer_step = raw_manifest$consumer_step), length)
science$bytes <- tapply(raw_manifest$bytes, raw_manifest$consumer_step, sum)[science$consumer_step]
science$status <- "staged and hash-verified; reconstruction scope is defined by the consumer step"
science <- rbind(
  data.frame(consumer_step = "all", files = nrow(raw_manifest), bytes = sum(raw_manifest$bytes),
             status = "migrated: every file in analyses/data/00-raw/ is registered and matches"),
  science
)
rwv_write_tsv(science, path_target("science-input-status.tsv"))
knitr::kable(science, caption = "science-input-status.tsv")
knitr::kable(transform(raw_manifest[, c("path", "bytes", "status", "origin_path")],
                       sha256 = substr(raw_manifest$sha256, 1, 12)),
             caption = "raw-input-manifest.tsv (sha256 shortened)")
```

Staged inputs include a viral SQLite snapshot, amplicon counts/taxonomy/trees, archived analysis tables and saved figure materials. Steps 012 and 020 rebuild community objects and calculations; the function, VF and global modules read archived results. This is not a workflow from raw sequencing reads.

### Task 3: Record the run

```r
rwv_write_session_info(
  path_target("session-info.txt"),
  c(step = params$name, run_id = step$run_id, mode = step$mode, quarto = rwv_quarto_version())
)
```
