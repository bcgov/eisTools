# SPI species observations
spi_obs <- function(){
  try(
    data <- bcdata::bcdc_get_data('1733feb0-9e33-4228-8078-d0f0e4df568e')
  )
  
  data %>% as.data.frame()
}
bcdata::bcdc_get_data('1733feb0-9e33-4228-8078-d0f0e4df568e')