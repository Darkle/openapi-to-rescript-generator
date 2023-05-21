import SwaggerParser from '@apidevtools/swagger-parser'
import minimist from 'minimist'
import RefParser from '@apidevtools/json-schema-ref-parser'
import type { OpenAPIObject, ParameterObject } from 'openapi3-ts/oas31'
import fs from 'fs'
import handlebars from 'handlebars'
// @ts-expect-error
import helpers from 'handlebars-helpers'

const handlebarHelpers = helpers()

handlebarHelpers.compare()

const cliArgs = minimist(process.argv.slice(2))

if (!cliArgs.inputFile) throw new Error('🚨 --inputFile cli arg not set!')

if (!fs.existsSync(cliArgs.inputFile)) throw new Error('🚨 inputFile does not exist!')

handlebars.registerHelper('capitalize', (aString?: string) => {
  if (!aString) throw new Error("🚨 can't capitalize an undefined argument")
  if (!aString?.length) throw new Error("🚨 can't capitalize an empty argument")
  return `${aString.charAt(0).toUpperCase()}${aString.slice(1)}`
})

handlebars.registerHelper(
  'paramContainsParamType',
  (paramType: string, params: ParameterObject[]) => !!params.find(param => param.in === paramType)
)

handlebars.registerHelper('setVariable', (varName, varValue, options) => {
  options.data.root[varName] = varValue
})

const templateFile = fs.readFileSync('./src/template.hbs', { encoding: 'utf8' })

const compileTemplate = handlebars.compile(templateFile)

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
