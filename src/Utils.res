@module("fs")
external writeFileSync: (. string, string) => unit = "writeFileSync"

@module("fs")
external readFileSync: (. string, {"encoding": string}) => string = "readFileSync"

type url = {}

@module("url") @new
external urlFromBaseUrl: (~input: string, ~base: Js.Nullable.t<string>) => url = "URL"

@module("url") external urlFileURLToPath: url => string = "fileURLToPath"

type swaggerValidationFunc = {validate: (. string, (. Js.nullable<Js.Exn.t>) => unit) => unit}

@module("@apidevtools/swagger-parser")
external swaggerParser: swaggerValidationFunc = "default"

type refParserDerefFunc = {
  dereference: (. string, (. Js.nullable<Js.Exn.t>, OpenApiTypes.openApi) => unit) => unit,
}

@module("@apidevtools/json-schema-ref-parser")
external refParser: refParserDerefFunc = "default"

@module("minimist")
external minimist: array<string> => Js.Dict.t<string> = "default"

exception ArgsError(string)
exception InputFileNotFoundError(string)
exception ValidationError(Js.Nullable.t<Js.Exn.t>)
exception DereferenceError(Js.Nullable.t<Js.Exn.t>)

// In dev we are ESM, in build we are CJS format
let getDirName = (esmImportMetaUrl, cjsDirname) =>
  Js.Nullable.isNullable(esmImportMetaUrl)
  // we are in CJS env
    ? Js.Option.getWithDefault("", Js.Nullable.toOption(cjsDirname))
      // we are in ESM env
    : urlFileURLToPath(urlFromBaseUrl(~input=".", ~base=esmImportMetaUrl))
