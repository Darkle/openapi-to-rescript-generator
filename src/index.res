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

exception InputFileError(string)
exception ValidationError(Js.Nullable.t<Js.Exn.t>)
exception DereferenceError(Js.Nullable.t<Js.Exn.t>)

let process = Process.process

let inputFile =
  Process.argv(process)->Js.Array2.slice(~start=2, ~end_=99)->minimist->Js.Dict.get("inputFile")

if Js.Option.isNone(inputFile) {
  raise(InputFileError("🚨 Error: --inputFile cli arg not set!"))
}

let validInputFileArg = Js.Option.getExn(inputFile)

if !Fs.existsSync(validInputFileArg) {
  raise(InputFileError("🚨 Error: input file does not exist!"))
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

  Js.Dict.entries(schema.paths)->Js.Array2.forEach(pathKeyVal => {
    // Js.log(pathKeyVal)
    let (pathString, pathData) = pathKeyVal
    // Js.log(pathData)
    let pathHttpVerbs = Js.Dict.keys(pathData)
    let res = Js.Array2.map(
      pathHttpVerbs,
      httpVerb => {
        Js.log(Js.Dict.get(pathData, httpVerb))
        httpVerb
      },
    )
    Js.log("=======")
    // Js.log(res)
  })
})

// let convertedPaths = Js.Dict.map((. pathKeyVal) => {
//   Js.log(pathKeyVal)
//   // let (pathString, pathData) = pathKeyVal
//   // let pathHttpVerbs = Js.Obj.keys(pathData)
//   // let res = Js.Array2.map(
//   //   pathHttpVerbs,
//   //   httpVerb => {
//   //     Js.log(Js.Dict.get(pathData, httpVerb))
//   //     httpVerb
//   //   },
//   // )
//   // Js.log("=======")
//   // Js.log(res)
// }, schema.paths)
