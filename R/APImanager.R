#' APImanager
#'
#' @return an instance of the APImanager class
#' @export
#'
#' @examples
APImanager <- R6::R6Class(
  "APImanager",

  private = list(
    con = NULL,
    routes = NULL,

    createConnection = function(name, connection) {
      private$con[[name]] <- connection
    },

    getConnection = function(name) {
      private$con[[name]]
    }
  ),

  public = list(

    initialize = function() {
      private$con <- vector("list")
      private$routes <- plumber$new()
    },

    generateEndpoints = function(folder) {
      endpoints <- list.files(folder, full.names = TRUE)

      for (file in endpoints) {
        endpoint <- plumber$new(file)
        url <- paste0("/", stringr::str_sub(basename(file), 1, -3))
        private$routes$mount(url, endpoint)
      }
    },

    generateWebApp = function(name, folder) {
      appli <- PlumberStatic$new(folder)
      private$routes$mount(paste0("/", name), appli)
    },

    run = function(host, port, swagger = TRUE) {
      private$routes$run(host = host, port = port, swagger = swagger)
    }
  )
)