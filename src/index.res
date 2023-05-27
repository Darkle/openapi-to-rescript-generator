open NodeJs

let process = Process.process

let inputFile =
  Process.argv(process)
  ->Js.Array2.slice(~start=2, ~end_=99)
  ->Utils.minimist
  ->Js.Dict.get("inputFile")

let outputFile =
  Process.argv(process)
  ->Js.Array2.slice(~start=2, ~end_=99)
  ->Utils.minimist
  ->Js.Dict.get("outputFile")

if Js.Option.isNone(inputFile) {
  raise(Utils.ArgsError("🚨 Error: --inputFile cli arg not set!"))
}
if Js.Option.isNone(outputFile) {
  raise(Utils.ArgsError("🚨 Error: --outputFile cli arg not set!"))
}

let validInputFileArg = Js.Option.getExn(inputFile)
let validOutputFileArg = Js.Option.getExn(outputFile)

if !Fs.existsSync(validInputFileArg) {
  raise(Utils.InputFileNotFoundError("🚨 Error: input file does not exist!"))
}

Utils.swaggerParser.validate(.validInputFileArg, (. err) => {
  if Js.Option.isSome(Js.Nullable.toOption(err)) {
    raise(Utils.ValidationError(err))
  }
})->ignore

// This combines all referenced types into one file
Utils.refParser.dereference(.validInputFileArg, (. err, schema) => {
  if Js.Option.isSome(Js.Nullable.toOption(err)) {
    raise(Utils.DereferenceError(err))
  }

  let compiledTemplate: string = Handlebars.compileTemplate(. {"paths": schema.paths})

  Utils.writeFileSync(. validOutputFileArg, compiledTemplate)

  let rescriptPath = Path.resolve([Global.dirname, "..", "node_modules", ".bin", "rescript"])

  //Format file we just created
  let formattedOutputFile = ChildProcess.execSync(
    `${rescriptPath} format -stdin .res < ${validOutputFileArg}`,
  )

  Utils.writeFileSync(. validOutputFileArg, Buffer.toString(formattedOutputFile))
})
