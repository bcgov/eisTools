#' Get geometry object of the provincial boundaries of British Columbia
#' 
#' @param res Whether the spatial resolution should be 'high' or 'low'
#'
#' @return A geometry object of the British Columbia provincial boundaries
#' @importFrom bcmaps bc_bound
#' @importFrom bcmaps bc_bound_hres
#' @export
#' 
bc_bounds <- function(res='low'){
  r <- tolower(res)
  if(!any(r == 'low', r == 'high')) stop('`Res` must be one of "high" or "low"')
  
  if(r == 'low'){
    try(bcmaps::bc_bound())
  } else {
    try(bcmaps::bc_bound_hres())}
}

#' Get geometry object of the biogeoclimatic zones of British Columbia
#' 
#' @return A geometry object of the British Columbia biogeoclimatic zones
#' @importFrom bcmaps bec
#' @export
NULL
# bc_bec <- function(){
#   bcmaps::bec()
# }

#' Get geometry object of the natural resource regions of British Columbia
#' 
#' @return A geometry object of the British Columbia natural resource zones
#' @importFrom bcmaps bec
#' @export
bc_admin_regions <- function(){
  
  regions <- tryCatch({
    bcmaps::nr_regions()
  }, error = function(err){
    err$message <- stop('Failed to retrieve natural resource regions')
  })

  if(!is.null(regions)){regions}
}