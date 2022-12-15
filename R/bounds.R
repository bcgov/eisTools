# Geometries of BC provincial boundaries
#' @export
bc_bounds <- function(res='low'){
  if(res == 'low'){bcmaps::bc_bound()} else {bc_bound_hres()}
}

#' @export
# Geometries of BC Biogeoclimatic Zones
bc_bec <- function(){
  bcmaps::bec()
}

#' @export
# Geometries of BC Ecoprovinces
bc_ecoprovinces <- function(){
  bcmaps::ecoprovinces()
}

#' @export
# Geometries of BC Ecosections
bc_ecosections <- function(){
  bcmaps::ecosections()
}

#' @export
bc_admin_regions <- function(){
  regions <- bcmaps::nr_regions()
  reg <- regions %>% dplyr::select(REGION_NAME, geometry)

  reg
}

#' @export
# SPI species observations
get_spi_obs <- function(){
  bcdata::bcdc_get_data('1733feb0-9e33-4228-8078-d0f0e4df568e')
}
