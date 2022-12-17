#' Get observations from the Species Inventory database through the BC Data Catalogue
#' 
#' @description A wrapper around `bcdata::bcdata_get_data()` to retrieve all non-secure species observations from the Species Inventory database through the BC Data Catalogue
#' 
#' @param species The English name of a species to filter the results by
#' @param start_end The minimum date to filter the results by. Returns records on or after this date.
#' @param end_date The maximum date to filter the results by. Returns records before this date.
#' @param crs The coordinate reference system that the results should be returned in. Defauls to EPSG:3005 BC Albers.
#' 
#' @importFrom bcdata bcdc_query_geodata
#' @importFrom magrittr %>%
#' @importFrom dplyr filter
#' @export
#' 
get_species_obs <- function(species=NULL, start_date=NULL, end_date=NULL, crs=3005){
  
  d <- tryCatch({
    bcdata::bcdc_query_geodata('1733feb0-9e33-4228-8078-d0f0e4df568e', crs=crs)
  }, error = function(err){
    err$message <- stop('Failed to build the query statement')
  })
  
  if(!is.null(species)){
    d <- d %>%
      filter(SPECIES_ENGLISH_NAME == species)
  }
  
  if(!is.null(start_date)){
    d <- d %>%
      filter(OBSERVATION_DATE >= as.Date(start_date))
  }
  
  if(!is.null(end_date)){
    d <- d %>%
      filter(OBSERVATION_DATE < as.Date(end_date))
  }
  
  resp <- tryCatch({
    d %>% 
      collect()
    }, error = function(err){
      err$message <- stop('Failed to collect species observations')
    })
  
  resp
}

#' Get telemetry records from the Species Inventory database through the BC Data Catalogue
#' 
#' @description A wrapper around `bcdata::bcdata_get_data()` to retrieve all non-secure telemetry records from the Species Inventory database through the BC Data Catalogue
#' 
#' @param species The English name of a species to filter the results by
#' @param start_end The minimum date to filter the results by. Returns records on or after this date.
#' @param end_date The maximum date to filter the results by. Returns records before this date.
#' @param crs The coordinate reference system that the results should be returned in. Defauls to EPSG:3005 BC Albers.
#' 
#' @importFrom bcdata bcdc_query_geodata
#' @importFrom magrittr %>%
#' @importFrom dplyr filter
#' @export
#' 
get_telemetry <- function(species=NULL, start_date=NULL, end_date=NULL, crs=3005){
  
  d <- tryCatch({
    bcdata::bcdc_query_geodata('6d48657f-ab33-43c5-ad40-09bd56140845', crs=crs)
  }, error = function(err){
    err$message <- stop('Failed to build the query statement')
  })
  
  if(!is.null(species)){
    d <- d %>%
      filter(SPECIES_ENGLISH_NAME == as.character(species))
  }
  
  if(!is.null(start_date)){
    d <- d %>%
      filter(OBSERVATION_DATE >= as.Date(start_date))
  }
  
  if(!is.null(end_date)){
    d <- d %>%
      filter(OBSERVATION_DATE < as.Date(end_date))
  }
  
  resp <- tryCatch({
    d %>%
      collect()
  }, error = function(err){
    err$message <- stop('Failed to collect the query statement')
  })
    
  resp
}

#' Get survey summaries from the Species Inventory database through the BC Data Catalogue
#' 
#' @description A wrapper around `bcdata::bcdata_get_data()` to retrieve all non-secure survey summaries from the Species Inventory database through the BC Data Catalogue
#' 
#' #' @param species The English name of a species to filter the results by
#' @param region The natural resource region to filter the results by
#' @param crs The coordinate reference system that the results should be returned in. Defauls to EPSG:3005 BC Albers.
#' 
#' @importFrom bcdata bcdc_query_geodata
#' @importFrom dplyr filter
#' @importFrom magrittr %>%
#' @export
get_surveys <- function(species=NULL, region=NULL, crs=3005){
  dup <- tryCatch({
    bcdata::bcdc_query_geodata('8f45a611-ce07-4e9f-a4b5-27e123972816', crs=crs)
    }, error = function(err){
    err$message <- stop('Failed to get survey summaries')
  })
  
  if(!is.null(species)){
    dup <- dup %>%
      dplyr::filter(SPECIES_ENGLISH_NAME == species)
  }
  
  if(!is.null(region)){
    dup <- dup %>%
      dplyr::filter(REGION == region)
  }
  
  resp <- tryCatch({
    dup %>% 
      dplyr::select(SPECIES_ENGLISH_NAME, LATITUDE, LONGITUDE,
                    SURVEY_NAME, SURVEY_START_DATE,
                    SEX, PROJECT_ID, REGION) %>%
      collect()
  }, error = function(err){
    err$message <- stop('Failed to collect the SQL query')
  })
  
  resp
}
