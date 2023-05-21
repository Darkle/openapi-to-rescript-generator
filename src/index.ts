import SwaggerParser from '@apidevtools/swagger-parser'
import minimist from 'minimist'
import RefParser from '@apidevtools/json-schema-ref-parser'
import type { OpenAPIObject } from 'openapi3-ts/oas31'
import fs from 'fs'
import { compileTemplate } from './handlebars'

const cliArgs = minimist(process.argv.slice(2))

if (!cliArgs.inputFile) throw new Error('🚨 --inputFile cli arg not set!')

if (!fs.existsSync(cliArgs.inputFile)) throw new Error('🚨 inputFile does not exist!')

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

  if (!schema.paths || !Object.keys(schema.paths).length) {
    throw new Error('🚨 No paths found!')
  }

  //FIXME:
  console.log(
    compileTemplate({ paths: { '/posts/get/single/{postId}': schema.paths['/posts/get/single/{postId}'] } })
  )

  // Object.entries(schema.paths!).forEach(([pathString, pathItemObj]) => {
  //   console.log(compileTemplate({ operationId: pathItemObj. }))
  // })
})
