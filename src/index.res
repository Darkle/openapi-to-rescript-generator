open NodeJs

@module("fs")
external writeFileSync: (. string, string) => unit = "writeFileSync"

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

let process = Process.process

let inputFile =
  Process.argv(process)->Js.Array2.slice(~start=2, ~end_=99)->minimist->Js.Dict.get("inputFile")

let outputFile =
  Process.argv(process)->Js.Array2.slice(~start=2, ~end_=99)->minimist->Js.Dict.get("outputFile")

if Js.Option.isNone(inputFile) {
  raise(ArgsError("🚨 Error: --inputFile cli arg not set!"))
}
if Js.Option.isNone(outputFile) {
  raise(ArgsError("🚨 Error: --outputFile cli arg not set!"))
}

let validInputFileArg = Js.Option.getExn(inputFile)
let validOutputFileArg = Js.Option.getExn(outputFile)

if !Fs.existsSync(validInputFileArg) {
  raise(InputFileNotFoundError("🚨 Error: input file does not exist!"))
}

swaggerParser.validate(.validInputFileArg, (. err) => {
  if Js.Option.isSome(Js.Nullable.toOption(err)) {
    raise(ValidationError(err))
  }
})->ignore

// This combines all referenced types into one file
refParser.dereference(.validInputFileArg, (. err, schema) => {
  if Js.Option.isSome(Js.Nullable.toOption(err)) {
    raise(DereferenceError(err))
  }

  let compiledTemplate: string = Handlebars.compileTemplate(. {"paths": schema.paths})

  writeFileSync(. validOutputFileArg, compiledTemplate)

  let rescriptPath = Path.join(["node_modules", ".bin", "rescript"])

  //Format file we just created
  let formattedOutputFile = ChildProcess.execSync(
    `${rescriptPath} format -stdin .res < ${validOutputFileArg}`,
  )

  writeFileSync(. validOutputFileArg, Buffer.toString(formattedOutputFile))
})
