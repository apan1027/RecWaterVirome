# Font resolution through systemfonts.
# Authors (display order): Jinlong Ru, Cunli Pan
#
# systemfonts silently falls back to another family when a requested font is
# missing, so the resolved family is compared with the request and any
# mismatch is an error. Pure function definitions only.

rwv_font_resolve <- function(family, weight = c("normal", "bold"), role = family, italic = FALSE) {
  weight <- match.arg(weight)
  info <- systemfonts::font_info(family = family, weight = weight, italic = italic)
  resolved <- if (nrow(info)) info$family[1] else NA_character_
  face <- paste0(weight, if (isTRUE(italic)) ", italic" else "")
  if (is.na(resolved) || !identical(tolower(resolved), tolower(family))) {
    rwv_fail("Font '", family, "' (", face, ") is not available: systemfonts resolved it to '", resolved,
             "' (", info$path[1], "). Install the font or change config/style.yml deliberately; ",
             "silent substitution is not allowed.")
  }
  if (identical(weight, "bold") && !isTRUE(info$bold[1])) {
    rwv_fail("Font '", family, "' has no real bold face (resolved ", info$path[1], ").")
  }
  if (isTRUE(italic) && !isTRUE(info$italic[1])) {
    rwv_fail("Font '", family, "' has no real italic face (resolved ", info$path[1], ").")
  }
  data.frame(
    role = role, family = family, weight = weight,
    resolved_family = resolved, style = info$style[1], postscript_name = info$name[1],
    path = info$path[1], index = info$index[1], sha256 = rwv_sha256(info$path[1])
  )
}

# Regular and bold text font, plus the CJK font only when a figure declares
# CJK text, and the italic face only when a figure sets gene symbols in italic
# (Figure 3a since 2026-10-14). The no-substitution rule applies to every face.
rwv_fonts_resolve <- function(style, cjk = FALSE, italic = FALSE) {
  fonts <- rbind(
    rwv_font_resolve(style$font$family, "normal", "text"),
    rwv_font_resolve(style$font$family, "bold", "text-bold")
  )
  if (cjk) fonts <- rbind(fonts, rwv_font_resolve(style$font$cjk_family, "normal", "cjk"))
  if (italic) fonts <- rbind(fonts, rwv_font_resolve(style$font$family, "normal", "text-italic", italic = TRUE))
  fonts
}
