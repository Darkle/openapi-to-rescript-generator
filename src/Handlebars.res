@module("fs")
external readFileSync: (. string, {"encoding": string}) => string = "readFileSync"

type handleBarsMethods = {
  compile: (. string) => (. {"paths": Js.Dict.t<OpenApiTypes.pathItemObject>}) => string,
  registerHelper: (. string, option<JSONSchema.t> => string) => unit,
}

@module("handlebars")
external handlebars: handleBarsMethods = "default"

@module("./handlebarsJsHelpers.mjs")
external registerJSHandlebarHelpers: unit => unit = "registerJSHandlebarHelpers"

registerJSHandlebarHelpers()

handlebars.registerHelper(."structify", (jsonSchema: option<JSONSchema.t>) => {
  switch jsonSchema {
  | None => Js.Exn.raiseError("no arg supplied to structify handlebars helper")
  | Some(thing) => // let consoleDir = %raw("(thing) => console.dir(thing, {depth:Infinity})")
    // consoleDir(JSONSchema.toStruct(thing))
    JSONSchema.toStruct(thing)->S.inline
  }
})

let templateFile = readFileSync(. "./src/template.hbs", {"encoding": "utf8"})

let compileTemplate = handlebars.compile(. templateFile)
