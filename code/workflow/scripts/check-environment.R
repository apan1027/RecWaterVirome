# Read-only environment preflight; no installation or scientific calculation.
# Authors (display order): Jinlong Ru, Cunli Pan.
(function() {
  d <- read.dcf("DESCRIPTION")
  required <- trimws(strsplit(gsub("\n", "", d[1,"Imports"]), ",")[[1]])
  available <- vapply(required, requireNamespace, logical(1), quietly=TRUE)
  print(data.frame(package=required, installed=available,
                   version=vapply(required, function(p) if (available[[p]]) as.character(utils::packageVersion(p)) else NA_character_, "")), row.names=FALSE)
  expected <- "4665814be79e13f7440f26b95279c014e6a5e209"
  if (available[["qproj"]]) {
    q <- utils::packageDescription("qproj")
    message("qproj installed RemoteSha: ", if (is.null(q$RemoteSha)) "unavailable" else q$RemoteSha,
            "; recorded reference: ", expected)
    if (is.null(q$RemoteSha) || !identical(q$RemoteSha, expected)) warning("qproj source revision differs or is unavailable; compatibility is unverified.", call.=FALSE)
  }
  quarto <- Sys.getenv("QUARTO_PATH", unset=unname(Sys.which("quarto")))
  if (!nzchar(quarto) || !file.exists(quarto)) stop("Quarto CLI not found.", call.=FALSE)
  message("Quarto: ", paste(system2(quarto,"--version",stdout=TRUE),collapse=" "))
  if (!all(available)) stop("Missing R packages; consult environment/README.md.",call.=FALSE)
  sys.source("R/workflow.R", envir=environment());sys.source("R/fonts.R", envir=environment())
  style <- yaml::read_yaml("config/style.yml")
  print(rwv_fonts_resolve(style, italic=TRUE),row.names=FALSE)
  message("Environment discovery and Arial checks passed. Export devices are probed at render time; this is not a clean-machine restoration test.")
})()
