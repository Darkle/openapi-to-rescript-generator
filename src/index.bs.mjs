#!/usr/bin/env node
#!/usr/bin/env node
// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Fs from "fs";
import * as Path from "path";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Process from "process";
import Minimist from "minimist";
import * as Js_option from "rescript/lib/es6/js_option.js";
import * as Handlebars from "./Handlebars.bs.mjs";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Child_process from "child_process";
import * as Caml_exceptions from "rescript/lib/es6/caml_exceptions.js";
import SwaggerParser from "@apidevtools/swagger-parser";
import JsonSchemaRefParser from "@apidevtools/json-schema-ref-parser";

var ArgsError = /* @__PURE__ */Caml_exceptions.create("Index.ArgsError");

var InputFileNotFoundError = /* @__PURE__ */Caml_exceptions.create("Index.InputFileNotFoundError");

var ValidationError = /* @__PURE__ */Caml_exceptions.create("Index.ValidationError");

var DereferenceError = /* @__PURE__ */Caml_exceptions.create("Index.DereferenceError");

var $$process = Process;

var inputFile = Js_dict.get(Minimist($$process.argv.slice(2, 99)), "inputFile");

var outputFile = Js_dict.get(Minimist($$process.argv.slice(2, 99)), "outputFile");

if (Js_option.isNone(inputFile)) {
  throw {
        RE_EXN_ID: ArgsError,
        _1: "🚨 Error: --inputFile cli arg not set!",
        Error: new Error()
      };
}

if (Js_option.isNone(outputFile)) {
  throw {
        RE_EXN_ID: ArgsError,
        _1: "🚨 Error: --outputFile cli arg not set!",
        Error: new Error()
      };
}

var validInputFileArg = Js_option.getExn(inputFile);

var validOutputFileArg = Js_option.getExn(outputFile);

if (!Fs.existsSync(validInputFileArg)) {
  throw {
        RE_EXN_ID: InputFileNotFoundError,
        _1: "🚨 Error: input file does not exist!",
        Error: new Error()
      };
}

SwaggerParser.validate(validInputFileArg, (function (err) {
        if (!Js_option.isSome((err == null) ? undefined : Caml_option.some(err))) {
          return ;
        }
        throw {
              RE_EXN_ID: ValidationError,
              _1: err,
              Error: new Error()
            };
      }));

JsonSchemaRefParser.dereference(validInputFileArg, (function (err, schema) {
        if (Js_option.isSome((err == null) ? undefined : Caml_option.some(err))) {
          throw {
                RE_EXN_ID: DereferenceError,
                _1: err,
                Error: new Error()
              };
        }
        var compiledTemplate = Handlebars.compileTemplate({
              paths: schema.paths
            });
        Fs.writeFileSync(validOutputFileArg, compiledTemplate);
        var rescriptPath = Path.join("node_modules", ".bin", "rescript");
        var formattedOutputFile = Child_process.execSync("" + rescriptPath + " format -stdin .res < " + validOutputFileArg + "");
        Fs.writeFileSync(validOutputFileArg, formattedOutputFile.toString());
      }));

export {
  ArgsError ,
  InputFileNotFoundError ,
  ValidationError ,
  DereferenceError ,
  $$process ,
  inputFile ,
  outputFile ,
  validInputFileArg ,
  validOutputFileArg ,
}
/* process Not a pure module */
