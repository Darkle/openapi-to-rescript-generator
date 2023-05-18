open NodeJs

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

@val external processExit: int => unit = "process.exit"

let process = Process.process

let inputFile =
  Process.argv(process)->Js.Array2.slice(~start=2, ~end_=99)->minimist->Js.Dict.get("inputFile")

switch inputFile {
| None => {
    Js.Console.error("🚨 Error: --inputFile cli arg not set!")
    processExit(1)
  }
| Some(validInputFile) => {
    if !Fs.existsSync(validInputFile) {
      Js.Console.error("🚨 Error: input file does not exist!")
      processExit(1)
    }

    swaggerParser.validate(.validInputFile, (. err) => {
      if Js.Option.isSome(Js.Nullable.toOption(err)) {
        Js.Console.error(err)
        processExit(1)
      }
    })->ignore

    // This combines all referenced types into one file
    refParser.dereference(.validInputFile, (. err, schema) => {
      if Js.Option.isSome(Js.Nullable.toOption(err)) {
        Js.Console.error(err)
        processExit(1)
      }

      Js.Array2.forEach(Js.Dict.keys(schema.paths), p => Js.log(p))
    })
  }
}
