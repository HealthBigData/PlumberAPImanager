source("utils/{{name}}APImanager.R")

api <- {{name}}APImanager$new()

api$generateEndpoints("endpoints")

{{#webapp}}
api$generateWebApp(name = "{{webapp_name}}", folder = "./www")
{{/webapp}}

api$run(host = "127.0.0.1", port = 9543, swagger = FALSE)