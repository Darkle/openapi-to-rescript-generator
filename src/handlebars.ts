import handlebars from 'handlebars'
import type { ParameterObject } from 'openapi3-ts/oas31'
import fs from 'fs'

handlebars.registerHelper('capitalize', (aString?: string) => {
  if (!aString) throw new Error("🚨 can't capitalize an undefined argument")
  if (!aString?.length) throw new Error("🚨 can't capitalize an empty argument")
  return `${aString.charAt(0).toUpperCase()}${aString.slice(1)}`
})

handlebars.registerHelper(
  'paramContainsParamType',
  (paramType: string, params: ParameterObject[]) => !!params.find(param => param.in === paramType)
)

handlebars.registerHelper('eq', (thing1, thing2) => thing1 == thing2)

handlebars.registerHelper('setVariable', (varName, varValue, options) => {
  options.data.root[varName] = varValue
})

const createObjType = (name, jsonSchema) => {
  let subObjTypes = `
    @spice
    type ${name}Obj = {
      ${Object.entries(jsonSchema).map(
        ([key, val]) => {
         const type = jsonSchema[key].type
          return `
        ${key}: ${type === 'boolean' ? 'bool' : type === 'null' ? 'Js.Nullable.null' : type === 'number' ? 'float'? type === 'object'? `${key}Obj` :''  }
        `
        })}
  `
  // let thing = jsonSchema.properties
  // don't for get to do required
  return subObjTypes + `\n}`
}

handlebars.registerHelper('genSpiceType', (required, name, jsonSchema) => {
  if (jsonSchema.type === 'boolean') {
    return `
          @spice
          type ${name}${required ? '' : '?'} = bool
    `
  }
  //TODO:check if Js.Nullable.null is right thing to use here
  if (jsonSchema.type === 'null') {
    return `
          @spice
          type ${name}${required ? '' : '?'} = Js.Nullable.null
    `
  }

  // Float to be safe as json schema doesn't seem to distinguish between int and float
  if (jsonSchema.type === 'number') {
    return `
          @spice
          type ${name}${required ? '' : '?'} = float
    `
  }

  if (jsonSchema.type === 'object') {
    return `
          ${createObjType(name, jsonSchema)}
          @spice
          type ${name}${required ? '' : '?'} = ${name}Obj
    `
  }

  return ``
})

const templateFile = fs.readFileSync('./src/template.hbs', { encoding: 'utf8' })

const compileTemplate = handlebars.compile(templateFile)

export { compileTemplate }
