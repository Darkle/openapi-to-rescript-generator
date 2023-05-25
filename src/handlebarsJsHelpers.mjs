import handlebars from 'handlebars'

// https://rescript-lang.org/docs/manual/latest/reserved-keywords
// https://github.com/rescript-lang/rescript-compiler/blob/master/jscomp/syntax/src/res_token.ml
const isReservedKeyword = word =>
  /^(and|as|assert|await|constraint|else|exception|external|false|for|if|in|include|lazy|let|module|mutable|of|open|rec|switch|true|try|type|when|while|with)$/gu.test(
    word
  )

// https://stackoverflow.com/a/69874941/2785644
const isCapetilized = str => /\p{Lu}/u.test(str)

const hasNonAtoZChars = str => /[^a-zA-Z]/gu.test(str)

const removeNonAtoZChars = str => str.replaceAll(/[^a-zA-Z]/gu, '')

const fixIfReservedKeyword = str => (isReservedKeyword(str) ? `${str}_` : str)

const upperCaseFirstLetter = str => `${str.charAt(0).toUpperCase()}${str.slice(1)}`

const lowerCaseFirstLetter = str => `${str.charAt(0).toLowerCase()}${str.slice(1)}`

const arrayContainsReservedWord = strArr => strArr.find(isReservedKeyword)

// eslint-disable-next-line max-lines-per-function
function registerJSHandlebarHelpers() {
  handlebars.registerHelper('createModuleName', aString => {
    if (!aString) {
      throw new Error('🚨 undefined argument in createModuleName handlebars helper')
    }
    if (!aString?.length) {
      throw new Error('🚨 empty argument in createModuleName handlebars helper')
    }

    // Don't need fixIfReservedKeyword as we are uppercasing first letter
    return upperCaseFirstLetter(removeNonAtoZChars(aString))
  })

  handlebars.registerHelper('createReqBodyStructName', aString => {
    if (!aString) {
      throw new Error("🚨 can't unCapitalize an undefined argument in unCapitalize handlebars helper")
    }
    if (!aString?.length) {
      throw new Error("🚨 can't unCapitalize an empty argument in unCapitalize handlebars helper")
    }

    return fixIfReservedKeyword(lowerCaseFirstLetter(removeNonAtoZChars(aString)))
  })

  /*****
    Can't change the names of the api type keys as they need to match up, so instead use either @as() and \""
    https://rescript-lang.org/docs/manual/latest/use-illegal-identifier-names
    https://rescript-lang.org/syntax-lookup#as-decorator
  *****/
  // eslint-disable-next-line complexity, max-lines-per-function
  handlebars.registerHelper('toValidRecordFieldName', aString => {
    if (!aString) {
      throw new Error('🚨 no valid argument suppled to toValidRecordFieldName handlebars helper')
    }
    if (!aString?.length) {
      throw new Error('🚨 empty string supplied to toValidRecordFieldName handlebars helper')
    }

    const aStringOrig = aString

    let isLegitName = true

    if (isCapetilized(aString)) {
      isLegitName = false
      aString = lowerCaseFirstLetter(aString)
    }

    if (hasNonAtoZChars(aString)) {
      isLegitName = false
      aString = `\\"${aString}"`
    }

    // Has to be after check above, otherwise the underscore will trigger the hasNonAtoZChars(aString) check
    if (isReservedKeyword(aString)) {
      isLegitName = false
      aString = `${aString}_`
    }

    return isLegitName ? aStringOrig : `@as("${aStringOrig}") ${aString}`
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

    // Dunno what else to do here. I don't know of a way to alias a poly variant name if it uses a keyword
    if (arrayContainsReservedWord(stringArr)) {
      return 'string'
    }

    // formatting gets rid of any excess pipes
    return stringArr.reduce((acc, currentItem) => `${acc} | #${currentItem}`, '[') + ']'
  })
}

export { registerJSHandlebarHelpers }
