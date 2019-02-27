#' createBoilerplate
#'
#' @param name Name of the API (used as the root url)
#' @param path Path to the directory where the boilerplate will be created
#' @param webapp Is a webapi needed
#' @param webapp_name Name of the webapp (Default is the same of the API).
#'
#' @importFrom magrittr %>%
#' @return invisibly NULL
#' @export
#'
#' @examples
createBoilerplate <- function(name,
                              path = ".",
                              webapp = TRUE,
                              webapp_name = name) {

  # if (dir.exists(path)) {
  #   if(length(list.files(path)) > 0) {
  #     stop("Provided path is not empty. Aborting.")
  #   }
  # } else {
  #   dir.create(path)
  # }

  if (!dir.exists(path)) {
    dir.create(path)
  }

  getTemplate <- getFile("templates", "PlumberAPImanager")

  # Create required directories
  c("conf", "endpoints", "utils") %>%
    purrr::walk(~dir.create(paste0(path, "/", .x)))

  # Create mandatory plumber.R file
  getTemplate("plumber.R") %>%
    file.copy(path)

  # Create skeleton of the class containing API logic
  getTemplate("APIclass.R") %>%
    readr::read_file() %>%
    whisker::whisker.render(list(name = name)) %>%
    readr::write_file(paste0(path, "/utils/", name, "APImanager.R"))

  # Create skeleton of the main plumber file managing routes
  getTemplate("entrypoint.R") %>%
    readr::read_file() %>%
    whisker::whisker.render(list(name = name,
                                 webapp = webapp,
                                 webapp_name = webapp_name)) %>%
    readr::write_file(paste0(path, "/entrypoint.R"))

  # if webapp is needed
  if (webapp) {
    webapp_path <- paste0(path, "/www")
    dir.create(webapp_path)

    getTemplate("www.zip") %>%
      unzip(exdir = webapp_path)

    getTemplate("index.html") %>%
      readr::read_file() %>%
      whisker::whisker.render(list(webapp_name = webapp_name)) %>%
      readr::write_file(paste0(webapp_path, "/index.html"))
  }

  cat("You can now launch your basic API with plumber::plumb() from inside ",
      path, " directory. By default, API will be available through
      http://127.0.0.1:9543/", name, "/", sep = "")

  invisible(NULL)
}
