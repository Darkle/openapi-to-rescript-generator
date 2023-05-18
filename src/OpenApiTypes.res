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
}

type pathItemOpject = {
  parameters: array<parameterObject>,
  get: openApiOperationObject,
  put: openApiOperationObject,
  post: openApiOperationObject,
  delete: openApiOperationObject,
  options: openApiOperationObject,
  head: openApiOperationObject,
  patch: openApiOperationObject,
  trace: openApiOperationObject,
}

// Not typing all of it atm.
type openApi = {paths: Js.Dict.t<pathItemOpject>}
