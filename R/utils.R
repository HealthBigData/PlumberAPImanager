getFile <- function(dir, package) {
  function(name) {
    system.file(dir, name, package = package)
  }
}
