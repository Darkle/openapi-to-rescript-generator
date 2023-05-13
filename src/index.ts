import SwaggerParser from '@apidevtools/swagger-parser'
import minimist from 'minimist'
import RefParser from '@apidevtools/json-schema-ref-parser'
import type { OpenAPIObject } from 'openapi3-ts/oas31'
// import fs from 'fs'

/**
 TODO:s
 * Check it on some other random schemas
 * 
 */

const cliArgs = minimist(process.argv.slice(2))

if (!cliArgs.inputFile) throw new Error('--inputFile cli arg not set!')

SwaggerParser.validate(cliArgs.inputFile, err => {
  if (err) {
    console.error('Validation Error!', err)
    process.exit(1)
  }
})

RefParser.dereference(cliArgs.inputFile, (err, s) => {
  const schema = s as OpenAPIObject

  if (err) {
    console.error(err)
    process.exit(1)
  }

  // console.dir(schema, { depth: Infinity })
  // fs.writeFileSync('output.json', JSON.stringify(schema))
})
