@module("fs")
external readFileSync: (. string, {"encoding": string}) => string = "readFileSync"

type dataForHandlebarsTemplate = {
  pathItemObjects?: OpenApiTypes.pathItemObject,
  operationId?: string,
  pathString?: string,
  httpVerb?: string,
  // params: option<array<OpenApiTypes.parameterObject>>,
  // bodyItems: option<array<OpenApiTypes.requestBodyObject>>,
  // responseDataItems: option<array<OpenApiTypes.requestBodyObject>>,
}

type handleBarsMethods = {
  compile: (. string) => (. dataForHandlebarsTemplate) => string,
  registerHelper: (. string, option<string> => string) => unit,
}

@module("handlebars")
external handlebars: handleBarsMethods = "default"

// Borrowed from https://github.com/Orasund/elm-pen/blob/master/src/cli/Handlebars.res
handlebars.registerHelper(."capitalize", (aString: option<string>) => {
  switch aString {
  | None => Js.Exn.raiseError("can't capitalize an undefined argument")
  | Some("") => Js.Exn.raiseError("can't capitalize an empty argument")
  | Some(string) =>
    Js.String.charAt(0, string)->Js.String.toUpperCase ++ Js.String.substringToEnd(~from=1, string)
  }
})

let templateFile = readFileSync(. "./src/template.hbs", {"encoding": "utf8"})

let compileTemplate = handlebars.compile(. templateFile)
