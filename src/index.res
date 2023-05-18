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

  // Js.log(schema.paths)
  Js.Dict.entries(schema.paths)->Js.Array2.forEach(pathKeyVal => {
    let (pathString, pathData) = pathKeyVal
    // Js.log(pathData)
    switch pathData {
    // | {get} => Js.log(get)
    // | {put} => Js.log(put)
    // | {post} => Js.log(post)
    | {delete} => Js.log(delete)
    // | {options} => Js.log(options)
    // | {head} => Js.log(head)
    // | {patch} => Js.log(patch)
    // | {trace} => Js.log(trace)
    | _ => ()
    }

    // let pathHttpVerbs = Js.Dict.entries(pathData)
    // if Js.Option.isSome(pathData.get) {
    //   Js.log2(pathString, Js.Option.getExn(pathData.get))
    // }
    // switch pathData {
    // | "get" => Js.log(get)
    // | _ => Js.log("got nothing")
    // }
  })
  // let foo = Belt.Map.String.toArray(Js.Option.getExn(schema.paths.get))
  // Js.log(Belt.Map.String.get(schema.paths, "get"))
  // let foo = Belt.Map.String.forEach(schema.paths, (key, v) => {
  //   Js.log(key)
  //   Js.log(v)
  // })

  // Js.Dict.entries(schema.paths)->Js.Array2.forEach(pathKeyVal => {
  //   let (pathString, pathData) = pathKeyVal
  //   let pathHttpVerbs = Js.Dict.entries(pathData)
  // })
  // Js.log(schema["paths"])
  // Js.Obj.keys(schema["paths"])->Js.Array2.forEach(path => {
  //   Js.log(path)
  //   let pathData = schema["paths"][path]
  //   // Js.log(Js.Option.getExn())
  // })

  // S.parseWith(schema, OpenApiTypes.openApiStruct)

  // Js.Dict.entries(schema.paths)->Js.Array2.forEach(path => {
  // let (pathString, pathData) = path
  // Js.log(schema["paths"])
  // switch path {
  // | Some("get") => expression
  // | pattern2 => expression
  // }
  // let foo = Js.Dict.get(pathData, "get")
  // Js.log(Js.Dict.get(pathData, "get"))
  // switch pathData {
  // | Some("get") => expression
  // | pattern2 => expression
  // }
  // Js.log(Js.Obj.keys(Js.Option.getExn(pathData, "get")))
  // Js.log(schema["paths"][path])
  // Js.log("===========================")
  // })
  // Js.Dict.entries(schema.paths)->Js.Array2.forEach(pathKeyVal => {
  //   // Js.log(pathKeyVal)
  //   let (pathString, pathData) = pathKeyVal
  //   Js.Option.getExn(pathData, "get")
  //   // Js.log(pathData)
  //   // Js.Dict.entries(pathData)->Js.Array2.forEach(
  //   //   pathHttpVerbAndData => {
  //   //     let (httpVerb, httpVerbData) = pathHttpVerbAndData
  //   //     Js.log(httpVerb)
  //   //     Js.log(httpVerbData)
  //   //   },
  //   // )
  //   // let thing = Js.Dict.get(pathData, "get")
  //   // switch thing {
  //   // | Some(val) => {
  //   //     let thing2 = Js.Dict.keys(val)
  //   //   }
  //   // | _ => ()
  //   // }
  //   // let thing2 = Js.Dict.keys(thing)
  //   // let res = Js.Array2.map(
  //   //   pathHttpVerbs,
  //   //   httpVerb => {
  //   //     Js.log(Js.Dict.get(pathData, httpVerb))
  //   //     httpVerb
  //   //   },
  //   // )
  //   // Js.log("=======")
  //   // Js.log(res)
  // })
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
