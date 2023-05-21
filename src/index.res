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

let template = ref(Handlebars.compileTemplate(. {}))

// This combines all referenced types into one file
refParser.dereference(.validInputFileArg, (. err, schema) => {
  if Js.Option.isSome(Js.Nullable.toOption(err)) {
    raise(DereferenceError(err))
  }

  Js.Dict.entries(schema.paths)->Js.Array2.forEach(pathKeyVal => {
    let (pathString, pathData) = pathKeyVal

    //TODO:remove this if statement
    if pathString == "/logs/create" || pathString == "/posts/get/single/{postId}" {
      template :=
        Handlebars.compileTemplate(. {
          pathItemObjects: pathData,
          // httpVerb: Some(httpVerb),
          pathString,
        })

      Js.log(template.contents)

      let getPathDataObjEntries: 't => array<(
        string,
        OpenApiTypes.openApiOperationObject,
      )> = %raw(`Object.entries`)

      // Getting get/patch/delete entries for the path data
      let pathDataStuff = getPathDataObjEntries(pathData)->Js.Array2.map(
        entry => {
          let (httpVerb, httpVerbData) = entry

          let {operationId, parameters, responses, requestBody} = httpVerbData

          // if Js.Option.isSome(operationId) {
          //   Js.log2("operationId", operationId)
          // }

          // if Js.Option.isSome(requestBody) {
          //   Js.log2("requestBody", requestBody)
          // }

          // module Api = {
          //   module GetPost = {
          //     let path = pathString
          //     let verb = httpVerb
          //     // Since can have multiple params, group in a sub-module
          //     module Params = {
          //       @spice
          //       type postId = string
          //       @spice
          //       type includeTags = option<bool>
          //     }

          //     @spice
          //     type tag = {tag: string, favourited: bool}

          //     @spice
          //     type response = {
          //       postId: string,
          //       title: string,
          //       postUrl: string,
          //       score: int,
          //       timestamp: string,
          //       mediaUrl: string,
          //       mediaHasBeenDownloaded: bool,
          //       couldNotDownload: bool,
          //       postMediaImagesHaveBeenProcessed: bool,
          //       postThumbnailsCreated: bool,
          //       postMediaImagesProcessingError: option<string>,
          //       downloadError: option<string>,
          //       mediaDownloadTries: int,
          //       downloadedMediaCount: int,
          //       downloadedMedia: array<string>,
          //       subredditName: string,
          //       tags: option<array<tag>>,
          //     }
          //   }

          //   module SaveLog = {
          //     let path = pathString
          //     let verb = httpVerb

          //     @spice
          //     type logLevel =
          //       | @spice.as("fatal") FATAL
          //       | @spice.as("error") ERROR
          //       | @spice.as("warn") WARN
          //       | @spice.as("info") INFO
          //       | @spice.as("debug") DEBUG
          //       | @spice.as("trace") TRACE

          //     @spice
          //     type body = {
          //       level: logLevel,
          //       service: string,
          //       message: option<string>,
          //       error: option<string>,
          //       other: Js.Json.t,
          //     }
          //   }
          // }

          // if Js.Array2.length(parameters) > 0 {
          //   let params = Js.Array2.map(
          //     parameters,
          //     param => {
          //       Js.log(param)
          //       param
          //     },
          //   )
          // }
          // Js.log2("responses", responses)
        },
      )
      Js.log("================================")
      Js.log(Js.Array2.length(pathDataStuff))
    }
  })
})
