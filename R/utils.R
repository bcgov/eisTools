#' @noRd
#' @description A utility function for checking and displaying whether the http response from httr2 is 401 Unauthorized
auth_error <- function(err){
  if(err$message == "HTTP 401 Unauthorized."){
    stop('Request not authorized. Please check that your username and password are correct.')
  } else {
      err
    }
}