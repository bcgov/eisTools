#' @export
get_token <- function(username, password){

  try(
    token <- request("https://metabase-0dff19-tools-tools.apps.silver.devops.gov.bc.ca/api/session") %>%
      req_body_json(list('username' = username, 'password' = password)) %>%
      req_headers("Content-Type" = "application/json", 'Accept' = "application/json") %>%
      req_perform() %>%
      resp_body_json() %>%
      unlist()
  )

  token
}

#' @export
get_collections <- function(token=NULL){

  if(is.null(token)) stop('You need to include your token from get_token()')

  try(
    collections <- request(paste0("https://metabase-0dff19-tools-tools.apps.silver.devops.gov.bc.ca/api/collection/")) %>%
      req_headers("X-Metabase-Session" = token) %>%
      req_perform() %>%
      resp_body_json() %>%
      do.call(rbind, .) %>%
      as.data.frame() %>%
      dplyr::select(name, id, description) %>%
      rename(collection_id = id)
  )

  collections
}

#' @export
get_collection_items <- function(collection_id, token){


  if(!all.equal(collection_id, as.integer(collection_id))){
    stop("You must provide a collection_id as an integer. Use get_collections()
    to find collections that you have access to.")
  }

  try(
    data <- request(paste0("https://metabase-0dff19-tools-tools.apps.silver.devops.gov.bc.ca/api/collection/", collection_id, "/items")) %>%
      req_headers("X-Metabase-Session" = token) %>%
      req_perform() %>%
      resp_body_json()
  )

  res <- lapply(data$data, function(x) x[c('id', 'name', 'description')]) %>%
    do.call(rbind, .) %>%
    as.data.frame() %>%
    rename(item_id = id)

  res
}

#' @export
get_data <- function(card_id, token){
  try(
    request(paste0("https://metabase-0dff19-tools-tools.apps.silver.devops.gov.bc.ca/api/card/", card_id, "/query/json")) %>%
      req_headers("X-Metabase-Session" = token) %>%
      req_method("POST") %>%
      req_perform() %>%
      resp_body_json() %>%
      do.call(rbind, .) %>%
      as.data.frame()
  )
}

