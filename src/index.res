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

// type objEntries = (string, OpenApiTypes.pathItemObject)

// This combines all referenced types into one file
refParser.dereference(.validInputFileArg, (. err, schema) => {
  if Js.Option.isSome(Js.Nullable.toOption(err)) {
    raise(DereferenceError(err))
  }

  Js.Dict.entries(schema.paths)->Js.Array2.forEach(pathKeyVal => {
    let (pathString, pathData) = pathKeyVal

    let getPathDataObjEntries: 't => array<(
      string,
      OpenApiTypes.openApiOperationObject,
    )> = %raw(`Object.entries`)

    // Getting get/patch/delete entries for the path data
    let pathDataStuff = getPathDataObjEntries(pathData)->Js.Array2.map(
      entry => {
        let (httpVerb, httpVerbData) = entry

        let {operationId, parameters, responses} = httpVerbData
      },
    )
    Js.log("================================")
    Js.log(pathDataStuff)
    // Js.log(pathDataStuff)
    // if Js.Option.isSome(pathData.get) {
    //   Js.log2(pathString, Js.Option.getExn(pathData.get))
    // }
    // if Js.Option.isSome(pathData.put) {
    //   Js.log2(pathString, Js.Option.getExn(pathData.put))
    // }
    // if Js.Option.isSome(pathData.post) {
    //   Js.log2(pathString, Js.Option.getExn(pathData.post))
    // }
    // if Js.Option.isSome(pathData.delete) {
    //   Js.log2(pathString, Js.Option.getExn(pathData.delete))
    // }
    // if Js.Option.isSome(pathData.options) {
    //   Js.log2(pathString, Js.Option.getExn(pathData.options))
    // }
    // if Js.Option.isSome(pathData.head) {
    //   Js.log2(pathString, Js.Option.getExn(pathData.head))
    // }
    // if Js.Option.isSome(pathData.patch) {
    //   Js.log2(pathString, Js.Option.getExn(pathData.patch))
    // }
    // if Js.Option.isSome(pathData.trace) {
    //   Js.log2(pathString, Js.Option.getExn(pathData.trace))
    // }
  })
})
