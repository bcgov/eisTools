#' Generate a session token to access the Metabase API for the BC Telemetry Warehouse
#'
#' @param password Password of Metabase account
#' @param username Username or email or Metabase account
#'
#' @return A string to be passed as an argument to functions requiring it
#' @importFrom magrittr %>%
#' @importFrom httr2 request req_headers req_body_json req_perform resp_body_json
#' @export
get_token <- function(username, password){

  if(!is.character(username)) stop('Your username must be a character')
  if(!is.character(password)) stop('Your password must be a character')

  req <- tryCatch({
      request("https://metabase-0dff19-tools-tools.apps.silver.devops.gov.bc.ca/api/session")
    }, error = function(err){
      err$message <- stop('Failed to build the API request: ', err)
    }
  )

  req_exp <- req %>%
    req_body_json(list('username' = toString(username),
                       'password' = toString(password))) %>%
    req_headers("Content-Type" = "application/json",
                'Accept' = "application/json")

  token_tmp <- tryCatch({
    req_exp %>%
      req_perform()
    }, error = function(err){
      err$message <- stop('Request not authorized. Please check that your username and password are correct.', err)
    })

  token <- token_tmp %>%
    resp_body_json() %>%
    unlist()

  if(!is.null(token)){
    token
  } else {stop('Failed to generate token')}
}

#' Get all collections that the user has access to
#'
#' @param token A session token generated by `get_token()` that is used to authenticate the request
#'
#' @return A dataframe containing information about the collections that the user has access to
#' @importFrom magrittr %>%
#' @importFrom httr2 request req_headers req_perform resp_body_json
#' @importFrom dplyr rename select
#' @export
get_collections <- function(token=NULL){

  if(is.null(token)) stop('You need to include your access token from `get_token()`')

  req <- tryCatch({
    collections <- request(paste0("https://metabase-0dff19-tools-tools.apps.silver.devops.gov.bc.ca/api/collection/")) %>%
      req_headers("X-Metabase-Session" = token)
  }, error = function(err){
    err$message <- stop('Failed to build the API request: ', err)
  })

  resp_tmp <- tryCatch({
    req %>%
      req_perform()
  }, error = function(err){
    err$message <- stop('Request not authorized. Please check that your username and password are correct.', err)
  })

  resp <- resp_tmp %>%
    resp_body_json() %>%
    do.call(rbind, .) %>%
    as.data.frame() %>%
    dplyr::select(name, id, description) %>%
    rename(collection_id = id)

  if(!is.null(resp)){resp} else{stop('Failed to get collections')}
}

#' Get all items within a specific collection that the user has access to
#'
#' @param token A session token generated by `get_token()` that is used to authenticate the request
#' @param collection_id The unique identifier of a collection discovered in `get_collections()`
#'
#' @return A dataframe containing information about the items with a specific collection
#' @importFrom magrittr %>%
#' @importFrom httr2 request req_headers req_perform resp_body_json
#' @importFrom dplyr rename
#' @importFrom base lapply
#' @export
get_collection_items <- function(collection_id, token){

  if(is.null(token)) stop('You need to include your access token from `get_token()`')

  if(!all.equal(collection_id, as.integer(collection_id))){
    stop("You must provide a collection_id as an integer. Use `get_collections()`
    to find collections that you have access to.")
  }

  req <- tryCatch({
    request(paste0("https://metabase-0dff19-tools-tools.apps.silver.devops.gov.bc.ca/api/collection/", collection_id, "/items")) %>%
      req_headers("X-Metabase-Session" = token)
    }, error = function(err){
      err$message <- stop('Failed to build the API request: ', err)
  })

  resp_tmp <- tryCatch({
    req %>%
      req_perform()
  }, error = function(err){
    err$message <- stop('Request not authorized. Please check that your username and password are correct.', err)
  })

  resp <- tryCatch({
    resp_tmp %>%
      resp_body_json() %>%
      lapply(.$data, function(x) x[c('id', 'name', 'description')]) %>%
      do.call(rbind, .) %>%
      as.data.frame() %>%
      rename(item_id = id)
  })

  if(!is.null(resp)){resp} else{stop('Failed to get collection items')}
}

#' Get all items within a specific collection that the user has access to
#'
#' @param token A session token generated by `get_token()` that is used to authenticate the request
#' @param card_id The unique identifier of an item discovered in `get_collection_items()`
#'
#' @return A dataframe containing information about the items with a specific collection
#' @importFrom magrittr %>%
#' @importFrom httr2 request req_headers req_perform resp_body_json
#' @export
get_data <- function(item_id, token){

  if(is.null(token)) stop('You need to include your access token from `get_token()`')

  req <- tryCatch({
    request(paste0("https://metabase-0dff19-tools-tools.apps.silver.devops.gov.bc.ca/api/card/", item_id, "/query/json")) %>%
      req_headers("X-Metabase-Session" = token) %>%
      req_method("POST")
  }, error = function(err){
    err$message <- stop('Failed to build the API request: ', err)
  })

  resp <- tryCatch({
    req %>%
      req_perform()
  }, error = function(err){
    err$message <- stop('Request not authorized. Please check that your username and password are correct.', err)
  })

  resp <- resp %>%
    resp_body_json() %>%
    do.call(rbind, .) %>%
    as.data.frame()

  if(!is.null(resp)){resp} else{stop('Failed to get the requested data')}
}

