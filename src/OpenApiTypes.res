type schemaObject = {}

type mediaTypeObject = {schema: schemaObject}

type requestBodyObject = {required: option<bool>, content: mediaTypeObject}

type responseObjectContent = {content: mediaTypeObject}

type responseObject = {"application/json": responseObjectContent}

type responsesObject = {
  "200": responseObject,
  "201": responseObject,
  "202": responseObject,
  "203": responseObject,
  "204": responseObject,
  "205": responseObject,
  "206": responseObject,
  "207": responseObject,
  "208": responseObject,
  "226": responseObject,
  "300": responseObject,
  "301": responseObject,
  "302": responseObject,
  "303": responseObject,
  "304": responseObject,
  "305": responseObject,
  "307": responseObject,
  "308": responseObject,
  "400": responseObject,
  "401": responseObject,
  "402": responseObject,
  "403": responseObject,
  "404": responseObject,
  "405": responseObject,
  "406": responseObject,
  "407": responseObject,
  "408": responseObject,
  "409": responseObject,
  "410": responseObject,
  "411": responseObject,
  "413": responseObject,
  "414": responseObject,
  "415": responseObject,
  "416": responseObject,
  "417": responseObject,
  "418": responseObject,
  "421": responseObject,
  "422": responseObject,
  "423": responseObject,
  "424": responseObject,
  "426": responseObject,
  "428": responseObject,
  "429": responseObject,
  "431": responseObject,
  "444": responseObject,
  "451": responseObject,
  "499": responseObject,
  "500": responseObject,
  "501": responseObject,
  "502": responseObject,
  "503": responseObject,
  "504": responseObject,
  "505": responseObject,
  "506": responseObject,
  "507": responseObject,
  "508": responseObject,
  "510": responseObject,
  "511": responseObject,
  "599": responseObject,
}

type parameterObject = {
  name: string,
  @as("in") in_: [#query | #header | #path | #cookie],
  required: option<bool>,
  schema: schemaObject,
}

type openApiOperationObject = {
  operationId: option<string>,
  requestBody: option<requestBodyObject>,
  responses: responsesObject,
  parameters: array<parameterObject>,
}

// parameters: array<parameterObject>,
type pathItemObject = {
  get: openApiOperationObject,
  put: openApiOperationObject,
  post: openApiOperationObject,
  delete: openApiOperationObject,
  options: openApiOperationObject,
  head: openApiOperationObject,
  patch: openApiOperationObject,
  trace: openApiOperationObject,
}

// /* cSpell:disable */
// /*
// Example:
// {
//   paths:
//   {
//     '/favs/all': {
//       get: {
//         operationId: 'getAllFavs',
//         ...
//       }
//     },
//     '/favs/subs': {
//       get: {
//         operationId: 'getFavSubs',
//         ...
//       }
//     },
//   }
// }
// */
// /* cSpell:enable */

// Not typing all of it atm.
type openApi = {paths: Js.Dict.t<pathItemObject>}
