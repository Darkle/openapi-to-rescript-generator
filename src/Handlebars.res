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
  // compile: (. string) => (. dataForHandlebarsTemplate) => string,
  compile: (. string) => (. {"paths": Js.Dict.t<OpenApiTypes.pathItemObject>}) => string,
  registerHelperCap: (. string, option<string> => string) => unit,
  registerHelperEq: (. string, (option<unknown>, option<unknown>) => bool) => unit,
  registerHelperParam: (
    . string,
    (option<string>, option<array<OpenApiTypes.parameterObject>>) => bool,
  ) => unit,
  registerHelperVar: (
    . string,
    (option<string>, option<unknown>, {"data": {"root": unknown}}) => unit,
  ) => unit,
}

@module("handlebars")
external handlebars: handleBarsMethods = "default"

// Borrowed from https://github.com/Orasund/elm-pen/blob/master/src/cli/Handlebars.res
handlebars.registerHelperCap(."capitalize", (aString: option<string>) => {
  switch aString {
  | None => Js.Exn.raiseError("can't capitalize an undefined argument")
  | Some("") => Js.Exn.raiseError("can't capitalize an empty argument")
  | Some(string) =>
    Js.String.charAt(0, string)->Js.String.toUpperCase ++ Js.String.substringToEnd(~from=1, string)
  }
})

handlebars.registerHelperEq(."eq", (param1, param2) => {
  if Js.Option.isNone(param1) {
    Js.Exn.raiseError("param1 is not set")
  }
  if Js.Option.isNone(param2) {
    Js.Exn.raiseError("param2 is not set")
  }
  param1 == param2
})

handlebars.registerHelperParam(.
  "paramContainsParamType",
  // (paramType, params) => !!params.find(param => param.in === paramType)
  (paramType: option<string>, params: option<array<OpenApiTypes.parameterObject>>) => {
    if Js.Option.isNone(paramType) {
      Js.Exn.raiseError("paramType is not set")
    }

    switch params {
    | Some(p) => Js.Array.some(p => p.in_ === paramType, params)
    | None => Js.Exn.raiseError("params is not set")
    }

    // Js.Array.some(param => param.in_ === paramType, params)
  },
)

handlebars.registerHelperVar(."setVariable", (varName, varValue, options) => {
  if Js.Option.isNone(varName) {
    Js.Exn.raiseError("varName is not set")
  }
  if Js.Option.isNone(varValue) {
    Js.Exn.raiseError("varValue is not set")
  }

  let addVarToOptions = %raw(`
    function(varName, varValue, options) {
      options.data.root[varName] = varValue
    }
  `)

  addVarToOptions(varName, varValue, options)->ignore

  ()
})

let templateFile = readFileSync(. "./src/template.hbs", {"encoding": "utf8"})

let compileTemplate = handlebars.compile(. templateFile)
