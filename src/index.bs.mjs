// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Fs from "fs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Process from "process";
import Minimist from "minimist";
import * as Js_option from "rescript/lib/es6/js_option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Caml_exceptions from "rescript/lib/es6/caml_exceptions.js";
import SwaggerParser from "@apidevtools/swagger-parser";
import JsonSchemaRefParser from "@apidevtools/json-schema-ref-parser";

var InputFileError = /* @__PURE__ */Caml_exceptions.create("Index.InputFileError");

var ValidationError = /* @__PURE__ */Caml_exceptions.create("Index.ValidationError");

var DereferenceError = /* @__PURE__ */Caml_exceptions.create("Index.DereferenceError");

var $$process = Process;

var inputFile = Js_dict.get(Minimist($$process.argv.slice(2, 99)), "inputFile");

if (Js_option.isNone(inputFile)) {
  throw {
        RE_EXN_ID: InputFileError,
        _1: "🚨 Error: --inputFile cli arg not set!",
        Error: new Error()
      };
}

var validInputFileArg = Js_option.getExn(inputFile);

if (!Fs.existsSync(validInputFileArg)) {
  throw {
        RE_EXN_ID: InputFileError,
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
        Js_dict.entries(schema.paths).forEach(function (pathKeyVal) {
              var getPathDataObjEntries = Object.entries;
              var pathDataStuff = Curry._1(getPathDataObjEntries, pathKeyVal[1]).map(function (entry) {
                    
                  });
              console.log("================================");
              console.log(pathDataStuff);
            });
      }));

export {
  InputFileError ,
  ValidationError ,
  DereferenceError ,
  $$process ,
  inputFile ,
  validInputFileArg ,
}
/* process Not a pure module */
