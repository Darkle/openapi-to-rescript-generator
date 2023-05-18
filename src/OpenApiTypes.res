type schemaObject = {}

type mediaTypeObject = {schema: schemaObject}

type requestBodyObject = {required: bool, content: mediaTypeObject}

type responseObjectContent = {content: mediaTypeObject}

type responseObject = {"application/json": responseObjectContent}

type responsesObject = {"200": responseObject, "201": responseObject, "204": responseObject}

type parameterObject = {
  name: string,
  in_: [#query | #header | #path | #cookie],
  required: bool,
  schema: schemaObject,
}

type openApiOperationObject = {
  operationId: string,
  requestBody: requestBodyObject,
  responses: responsesObject,
  parameters: array<Js.Dict.t<parameterObject>>,
}

type pathItemOpject = {
  // parameters: array<Js.Dict.t<parameterObject>>,
  get: Js.Dict.t<openApiOperationObject>,
  put: Js.Dict.t<openApiOperationObject>,
  post: Js.Dict.t<openApiOperationObject>,
  delete: Js.Dict.t<openApiOperationObject>,
  options: Js.Dict.t<openApiOperationObject>,
  head: Js.Dict.t<openApiOperationObject>,
  patch: Js.Dict.t<openApiOperationObject>,
  trace: Js.Dict.t<openApiOperationObject>,
}

// Not typing all of it atm.
type openApi = {paths: Js.Dict.t<Js.Dict.t<pathItemOpject>>}
