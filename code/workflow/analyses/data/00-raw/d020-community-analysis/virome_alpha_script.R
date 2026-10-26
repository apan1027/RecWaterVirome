# Virome alpha diversity (supplement to 060, which skipped the virome by design).
# Input : analyses/data/020-tse_virome/tse_virome.rds  (assay count_masked:
#         CoverM read counts, zeroed where breadth < 75%)
# Output: dev/390-virome-alpha-2026-09-27/{virome_alpha.tsv, clean_dirty_pairs.tsv, depth_check.tsv}
# Rarefaction mirrors 060 (alpha on rarefied counts); unrarefied values kept as sensitivity.
suppressMessages({library(TreeSummarizedExperiment); library(vegan)})
out <- "dev/390-virome-alpha-2026-09-27"
tse <- readRDS("analyses/data/020-tse_virome/tse_virome.rds")
cd  <- as.data.frame(colData(tse))
m   <- t(round(as.matrix(assay(tse, "count_masked"))))   # samples x vOTU
stopifnot(identical(rownames(m), cd$sample_id), all(m >= 0))

alpha <- function(x) {
  s <- specnumber(x); h <- diversity(x, "shannon")
  data.frame(observed = s, shannon = h, pielou = ifelse(s > 1, h / log(s), NA))
}
raw <- alpha(m)

depth <- rowSums(m); rdepth <- min(depth)
set.seed(42); n_iter <- 100
it <- replicate(n_iter, as.matrix(alpha(rrarefy(m, rdepth))), simplify = "array")
rar <- apply(it, c(1, 2), mean); rar_sd <- apply(it, c(1, 2), sd)

res <- data.frame(
  experiment = "virome", sample_id = cd$sample_id, desc = cd$desc,
  location = cd$location, water_condition = cd$water_condition,
  masked_reads = depth, rarefy_depth = rdepth,
  observed = rar[, "observed"], shannon = rar[, "shannon"], pielou = rar[, "pielou"],
  observed_sd = rar_sd[, "observed"], shannon_sd = rar_sd[, "shannon"],
  observed_unrarefied = raw$observed, shannon_unrarefied = raw$shannon,
  pielou_unrarefied = raw$pielou, row.names = NULL)
write.table(res, file.path(out, "virome_alpha.tsv"), sep = "\t", quote = FALSE, row.names = FALSE)

# Depth dependence: detection vs sequencing depth (7 points, descriptive only)
vl <- read.delim("analyses/data/020-tse_virome/viral_load_per_sample.tsv")
vl <- vl[match(res$sample_id, vl$sample_id), ]
dc <- data.frame(
  metric = c("observed_unrarefied~mapped_viral_reads", "observed_unrarefied~clean_reads",
             "observed_rarefied~mapped_viral_reads"),
  spearman_rho = c(cor(res$observed_unrarefied, vl$mapped_viral_reads, method = "spearman"),
                   cor(res$observed_unrarefied, vl$clean_reads, method = "spearman"),
                   cor(res$observed, vl$mapped_viral_reads, method = "spearman")))
write.table(dc, file.path(out, "depth_check.tsv"), sep = "\t", quote = FALSE, row.names = FALSE)

# Within-site clean/dirty pairs (bc2 has no dirty partner), all three omics
a16 <- read.delim("analyses/data/060-diversity/alpha_summary.tsv")
a16 <- a16[a16$experiment %in% c("bact_16s", "euk_18s_microeuk"), c("experiment","sample_id","observed","shannon","pielou")]
all_a <- rbind(a16, res[, c("experiment","sample_id","observed","shannon","pielou")])
pairs <- list(Tsinghua = c("bc1","bd1"), Garching = c("gc1","gd1"), Oberschleissheim = c("oc1","od1"))
pp <- do.call(rbind, lapply(split(all_a, all_a$experiment), function(d) do.call(rbind, lapply(names(pairs), function(p) {
  cl <- d[d$sample_id == pairs[[p]][1], ]; di <- d[d$sample_id == pairs[[p]][2], ]
  data.frame(experiment = d$experiment[1], pair = p,
             observed_clean = cl$observed, observed_dirty = di$observed,
             shannon_clean = cl$shannon, shannon_dirty = di$shannon,
             shannon_diff_dirty_minus_clean = di$shannon - cl$shannon)
}))))
write.table(pp, file.path(out, "clean_dirty_pairs.tsv"), sep = "\t", quote = FALSE, row.names = FALSE)
print(res[, c(2,6:12,13,14)], digits = 3); print(dc, digits = 3); print(pp, digits = 3)
