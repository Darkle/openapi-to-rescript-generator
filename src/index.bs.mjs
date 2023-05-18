// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Fs from "fs";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Process from "process";
import Minimist from "minimist";
import * as Js_option from "rescript/lib/es6/js_option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import SwaggerParser from "@apidevtools/swagger-parser";
import JsonSchemaRefParser from "@apidevtools/json-schema-ref-parser";

var $$process = Process;

var inputFile = Js_dict.get(Minimist($$process.argv.slice(2, 99)), "inputFile");

if (inputFile !== undefined) {
  if (!Fs.existsSync(inputFile)) {
    console.error("🚨 Error: input file does not exist!");
    process.exit(1);
  }
  SwaggerParser.validate(inputFile, (function (err) {
          if (Js_option.isSome((err == null) ? undefined : Caml_option.some(err))) {
            console.error(err);
            process.exit(1);
            return ;
          }
          
        }));
  JsonSchemaRefParser.dereference(inputFile, (function (err, schema) {
          if (Js_option.isSome((err == null) ? undefined : Caml_option.some(err))) {
            console.error(err);
            process.exit(1);
          }
          Object.keys(schema.paths).forEach(function (p) {
                console.log(p);
              });
        }));
} else {
  console.error("🚨 Error: --inputFile cli arg not set!");
  process.exit(1);
}

export {
  $$process ,
  inputFile ,
}
/* process Not a pure module */
