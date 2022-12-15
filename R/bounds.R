bcmaps::available_layers() %>% as.data.frame()

# Geometries of BC provincial boundaries
bc_bounds <- function(res='low'){
  if(res == 'low'){bcmaps::bc_bound()} else {bc_bound_hres()}
}

# Geometries of BC Biogeoclimatic Zones
bc_bec <- function(){
  bcmaps::bec()
}

# Geometries of BC Ecoprovinces
bc_ecoprovinces <- function(){
  bcmaps::ecoprovinces()
}

# Geometries of BC Ecosections
bc_ecosections <- function(){
  bcmaps::ecosections()
}

bc_admin_regions <- function(){
  regions <- bcmaps::nr_regions()
  reg <- regions %>% dplyr::select(REGION_NAME, geometry)

  reg
}

bc_admin_regions()

bcdata::bcdc_list() %>% as.data.frame()

bcdata::bcdc_get_data('bc-parks-api')

bcdc_search()

# SPI species observations
bcdata::bcdc_get_data('1733feb0-9e33-4228-8078-d0f0e4df568e')
