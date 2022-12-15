#' Get geometry object of the provincial boundaries of British Columbia
#' 
#' @param res Whether the spatial resolution should be 'high' or 'low'
#'
#' @return A geometry object of the British Columbia provincial boundaries
#' @importFrom bcmaps bc_bound
#' @importFrom bcmaps bc_bound_hres
#' @export
bc_bounds <- function(res='low'){
  if(res == 'low'){bc_bound()} else {bc_bound_hres()}
}

#' Get geometry object of the biogeoclimatic zones of British Columbia
#' 
#' @return A geometry object of the British Columbia biogeoclimatic zones
#' @importFrom bcmaps bec
#' @export
bc_bec <- function(){
  bcmaps::bec()
}

#' Get geometry object of the natural resource regions of British Columbia
#' 
#' @return A geometry object of the British Columbia natural resource zones
#' @importFrom bcmaps bec
#' @export
bc_admin_regions <- function(){
  regions <- bcmaps::nr_regions()
  reg <- regions %>% dplyr::select(REGION_NAME, geometry)

  reg
}

#' Get species observations from the Species Inventory database
#' 
#' @importFrom bcdata bcdc_get_data
#' @export
get_spi_obs <- function(){
  bcdata::bcdc_get_data('1733feb0-9e33-4228-8078-d0f0e4df568e')
}
