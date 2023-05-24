import handlebars from 'handlebars'

// eslint-disable-next-line max-lines-per-function
function registerJSHandlebarHelpers() {
  handlebars.registerHelper('capitalize', aString => {
    if (!aString) throw new Error("🚨 can't capitalize an undefined argument in capitalize handlebars helper")
    if (!aString?.length)
      throw new Error("🚨 can't capitalize an empty argument in capitalize handlebars helper")
    return `${aString.charAt(0).toUpperCase()}${aString.slice(1)}`
  })

  handlebars.registerHelper(
    'paramContainsParamType',
    (paramType, params) =>
      !!params.find(param => {
        if (!paramType) {
          throw new Error('paramType not set in paramContainsParamType handlebars helper')
        }
        if (!params) {
          throw new Error('params not set in paramContainsParamType handlebars helper')
        }

        return param.in === paramType
      })
  )

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
}

export { registerJSHandlebarHelpers }
