import handlebars from 'handlebars'

// eslint-disable-next-line max-lines-per-function
function registerJSHandlebarHelpers() {
  handlebars.registerHelper('capitalize', aString => {
    if (!aString) {
      throw new Error("🚨 can't capitalize an undefined argument in capitalize handlebars helper")
    }
    if (!aString?.length) {
      throw new Error("🚨 can't capitalize an empty argument in capitalize handlebars helper")
    }

    return `${aString.charAt(0).toUpperCase()}${aString.slice(1)}`
  })

  handlebars.registerHelper('unCapitalize', aString => {
    if (!aString) {
      throw new Error("🚨 can't unCapitalize an undefined argument in unCapitalize handlebars helper")
    }
    if (!aString?.length) {
      throw new Error("🚨 can't unCapitalize an empty argument in unCapitalize handlebars helper")
    }

    return `${aString.charAt(0).toLowerCase()}${aString.slice(1)}`
  })

  handlebars.registerHelper('toValidVarName', aString => {
    if (!aString) {
      throw new Error("🚨 can't toValidVarName an undefined argument in toValidVarName handlebars helper")
    }
    if (!aString?.length) {
      throw new Error("🚨 can't toValidVarName an empty argument in toValidVarName handlebars helper")
    }

    return aString.replaceAll(/[^a-zA-Z]/gu, '')
  })

  handlebars.registerHelper('paramContainsParamType', (paramType, params) => {
    if (!paramType) {
      throw new Error('paramType not set in paramContainsParamType handlebars helper')
    }
    if (!params) {
      throw new Error('params not set in paramContainsParamType handlebars helper')
    }

    return !!params.find(param => param.in === paramType)
  })

  handlebars.registerHelper('eq', (param1, param2) => {
    if (!param1) {
      throw new Error('param1 not set in eq handlebars helper')
    }
    if (!param2) {
      throw new Error('param2 not set in eq handlebars helper')
    }

    return param1 == param2
  })

  handlebars.registerHelper('jsonstringify', param1 => {
    if (!param1) {
      throw new Error('param1 not set in jsonstringify handlebars helper')
    }

    return JSON.stringify(param1)
  })

  handlebars.registerHelper('setVariable', (varName, varValue, options) => {
    if (!varName) {
      throw new Error('varName not set in setVariable handlebars helper')
    }
    if (!varValue) {
      throw new Error('varValue not set in setVariable handlebars helper')
    }

    options.data.root[varName] = varValue
  })

  handlebars.registerHelper('stringEnumToPolyVariant', stringArr => {
    if (!stringArr || !stringArr.length) {
      throw new Error('stringArr not set or empty in stringEnumToPolyVariant handlebars helper')
    }

    // formatting gets rid of any excess pipes
    return stringArr.reduce((acc, currentItem) => `${acc} | #${currentItem}`, '[') + ']'
  })
}

export { registerJSHandlebarHelpers }
