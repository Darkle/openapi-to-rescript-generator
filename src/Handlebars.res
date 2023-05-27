open NodeJs

// Can't put in utils. Needs to be in each file that uses it.
@val external importMetaUrl: Js.Nullable.t<string> = "import.meta.url"
@val external dirname: Js.Nullable.t<string> = "globalThis.__dirname"

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
  | Some(thing) => JSONSchema.toStruct(thing)->S.inline
  }
})

let safeDirname = Utils.getDirName(importMetaUrl, dirname)

let templageFilePath = Path.join([safeDirname, "template.hbs"])

let templateFile = Utils.readFileSync(. templageFilePath, {"encoding": "utf8"})

let compileTemplate = handlebars.compile(. templateFile)
