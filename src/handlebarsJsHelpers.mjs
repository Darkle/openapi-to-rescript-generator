import handlebars from 'handlebars'

// https://rescript-lang.org/docs/manual/latest/reserved-keywords
const isReservedKeyword = word =>
  /^(and|as|assert|constraint|else|exception|external|false|for|if|in|include|lazy|let|module|mutable|of|open|rec|switch|true|try|type|when|while|with)$/gu.test(
    word
  )

// https://stackoverflow.com/a/69874941/2785644
const isCapetilized = str => /\p{Lu}/u.test(str)

const hasNonAsciiChars = str => /[^a-zA-Z]/gu.test(str)

const fixIfReservedKeyword = str => (isReservedKeyword(str) ? `${str}_` : str)

// eslint-disable-next-line max-lines-per-function
function registerJSHandlebarHelpers() {
  handlebars.registerHelper('capitalize', aString => {
    if (!aString) {
      throw new Error("🚨 can't capitalize an undefined argument in capitalize handlebars helper")
    }
    if (!aString?.length) {
      throw new Error("🚨 can't capitalize an empty argument in capitalize handlebars helper")
    }

    // Don't need fixIfReservedKeyword as we are uppercasing first letter
    return `${aString.charAt(0).toUpperCase()}${aString.slice(1)}`
  })

  handlebars.registerHelper('unCapitalize', aString => {
    if (!aString) {
      throw new Error("🚨 can't unCapitalize an undefined argument in unCapitalize handlebars helper")
    }
    if (!aString?.length) {
      throw new Error("🚨 can't unCapitalize an empty argument in unCapitalize handlebars helper")
    }

    return fixIfReservedKeyword(`${aString.charAt(0).toLowerCase()}${aString.slice(1)}`)
  })

  handlebars.registerHelper('toAtoZonly', aString => {
    if (!aString) {
      throw new Error('🚨 no valid argument suppled to toAtoZonly handlebars helper')
    }
    if (!aString?.length) {
      throw new Error('🚨 empty string supplied to toAtoZonly handlebars helper')
    }

    // Don't need fixIfReservedKeyword here as it is being used in between other characters in var creation
    return aString.replaceAll(/[^a-zA-Z]/gu, '')
  })

  /*****
    Can't change the names of the api type keys as they need to match up, so instead use this trick
    from the docs: https://rescript-lang.org/docs/manual/latest/use-illegal-identifier-names
  *****/
  // eslint-disable-next-line complexity
  handlebars.registerHelper('toValidRecordFieldName', aString => {
    if (!aString) {
      throw new Error('🚨 no valid argument suppled to toValidRecordFieldName handlebars helper')
    }
    if (!aString?.length) {
      throw new Error('🚨 empty string supplied to toValidRecordFieldName handlebars helper')
    }

    return isCapetilized(aString) || isReservedKeyword(aString) || hasNonAsciiChars(aString)
      ? `\\"${aString}"`
      : aString
  })

  handlebars.registerHelper('paramContainsParamType', (paramType, params) => {
    if (!paramType) {
      throw new Error('1st arg not set in paramContainsParamType handlebars helper')
    }
    if (!params) {
      throw new Error('2nd arg not set in paramContainsParamType handlebars helper')
    }

    return !!params.find(param => param.in === paramType)
  })

  handlebars.registerHelper('eq', (param1, param2) => {
    if (!param1) {
      throw new Error('1st arg not set in eq handlebars helper')
    }
    if (!param2) {
      throw new Error('2nd arg not set in eq handlebars helper')
    }

    return param1 == param2
  })

  handlebars.registerHelper('jsonstringify', param1 => {
    if (!param1) {
      throw new Error('arg not set in jsonstringify handlebars helper')
    }

    return JSON.stringify(param1)
  })

  handlebars.registerHelper('setVariable', (varName, varValue, options) => {
    if (!varName) {
      throw new Error('1st arg not set in setVariable handlebars helper')
    }
    if (!varValue) {
      throw new Error('2nd arg not set in setVariable handlebars helper')
    }

    options.data.root[varName] = varValue
  })

  handlebars.registerHelper('stringEnumToPolyVariant', stringArr => {
    if (!stringArr || !stringArr.length) {
      throw new Error('arg not set or empty in stringEnumToPolyVariant handlebars helper')
    }

    // formatting gets rid of any excess pipes
    return stringArr.reduce((acc, currentItem) => `${acc} | #${fixIfReservedKeyword(currentItem)}`, '[') + ']'
  })
}

export { registerJSHandlebarHelpers }
