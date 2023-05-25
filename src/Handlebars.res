open NodeJs

// Can't put in utils. Needs to be in each file that uses it.
@val external importMetaUrl: NodeJs.Url.t = "import.meta.url"

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

let esmDirname = Url.fileURLToPath(Url.fromBaseUrl(~input=".", ~base=importMetaUrl))

let templageFilePath = Path.join([esmDirname, "template.hbs"])

let templateFile = Utils.readFileSync(. templageFilePath, {"encoding": "utf8"})

let compileTemplate = handlebars.compile(. templateFile)
