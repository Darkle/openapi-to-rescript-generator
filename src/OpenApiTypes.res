type schemaObject = {}

type mediaTypeObject = {schema: schemaObject}

type requestBodyObject = {required?: bool, content: mediaTypeObject}

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
  required?: bool,
  schema: schemaObject,
}

type openApiOperationObject = {
  operationId?: string,
  requestBody?: requestBodyObject,
  responses: responsesObject,
  parameters: array<parameterObject>,
}

// parameters: array<parameterObject>,
type pathItemOpject = {
  get?: openApiOperationObject,
  put?: openApiOperationObject,
  post?: openApiOperationObject,
  delete?: openApiOperationObject,
  options?: openApiOperationObject,
  head?: openApiOperationObject,
  patch?: openApiOperationObject,
  trace?: openApiOperationObject,
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

// // Not typing all of it atm.
type openApi = {paths: Js.Dict.t<pathItemOpject>}

// type openApiOperationObject = {operationId?: string}

// type pathItemOpject = {get: option<openApiOperationObject>}

// let openApiStruct = S.object(o => {
//   paths: o->S.field(
//     "paths",
//     S.object(o => {
//       get: o->S.field(
//         "get",
//         S.option(
//           S.object(
//             o => {
//               operationId: o->S.field("operationId", S.string()),
//             },
//           ),
//         ),
//       ),
//     }),
//   ),
// })

// type openApiOperationObject = {
//   operationId: option<string>,
//   thing: string,
// }

// type pathItemOpject = {
//   get: option<Js.Dict.t<openApiOperationObject>>,
//   put: option<Js.Dict.t<openApiOperationObject>>,
//   post: option<Js.Dict.t<openApiOperationObject>>,
//   delete: option<Js.Dict.t<openApiOperationObject>>,
//   options: option<Js.Dict.t<openApiOperationObject>>,
//   head: option<Js.Dict.t<openApiOperationObject>>,
//   patch: option<Js.Dict.t<openApiOperationObject>>,
//   trace: option<Js.Dict.t<openApiOperationObject>>,
// }

// type openApi = {paths: Js.Dict.t<pathItemOpject>}
