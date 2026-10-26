# Shared configuration

Authors (code-document order): Jinlong Ru, Cunli Pan.

The SHA256 entries in metadata/frozen-files.tsv are checked by step 010. Downstream readers require the same verified bytes. Deliberate configuration edits must update that register and their change record.

| File | Purpose |
|---|---|
| style.yml | Arial, type sizes, physical dimensions, site colours and export devices |
| samples.tsv | Fixed order: bc1, bd1, bc2, gc1, gd1, oc1, od1; site metadata |
| palettes.yml | Registered semantic category colours and shapes |
| figures.yml | Current figure labels, producing steps and output dimensions |
| definitions.tsv | Single source of units, counts, denominators and interpretation limits |
| workflow.yml | Implemented steps and their declared dependencies, inputs and outputs |
| community.yml | Supported community methods and fixed random seeds |
| analysis-version.yml | Active community analysis version |

Site labels derived from ID prefixes are checked against source sample metadata in 020. c/d are record labels, not demonstrated treatment stages. Site colours identify sites only. The current numbered step IDs are stable dependency keys: legacy S2/S3/S4 filenames do not change the actual figure roles declared in figures.yml.
