# Openapi to Rescript generator

#### Introduction:

- Generate rescript code from an [openapi spec](https://spec.openapis.org/oas/v3.1.0) document to help you validate & parse responses from your api. It also generates types for parameters and validation for request bodies.

- It supports openapi specs in json and yaml form.

- Note: this is just a first pass at this. Some stuff isn't supported yet, so expect some bugs.

- Most of the heavy lifting is done by the [Rescript Struct](https://github.com/DZakh/rescript-struct) and [Rescript Json Schema](https://github.com/DZakh/rescript-json-schema) libs.

#### Usage:

- Git clone this repo
- Run `npm run start -- --inputFile <inputFilePath> --outputFile <outputFilePath>`. Note: the `--` after `start` is required.
  - example: `npm run start --inputFile /foo/bar/openapi.json --outputFile ./output.res`
- You will then need to install [rescript struct](https://github.com/DZakh/rescript-struct#install) in your app.

#### Limitations

- Needs an [operationId](https://spec.openapis.org/oas/v3.1.0#fixed-fields-7) to be specified for each path
- The [Rescript validation structs](https://github.com/DZakh/rescript-struct) are only generated only for responses and request bodies.
- Parameters are just generated as types and have no validation.
- We only support string enums for parameters at the moment
- You may need to annotate unions with variants. See here for more details: https://github.com/DZakh/rescript-struct/issues/56
  - Here is an example of annotating a union variant inline:

```
let saveLogRequestBodyStruct = S.object(o =>
  {
    "level": o->S.field(
      "level",
      (
        S.union([
          S.literalVariant(String("fatal"), #fatal),
          S.literalVariant(String("error"), #error),
          S.literalVariant(String("warn"), #warn),
          S.literalVariant(String("info"), #info),
          S.literalVariant(String("debug"), #debug),
          S.literalVariant(String("trace"), #trace),
        ]): S.t<[#fatal | #error | #warn | #info | #debug | #trace]>
      ),
    ),
    "message": o->S.field("message", S.option(S.string())),
    "service": o->S.field("service", S.string()),
    "error": o->S.field("error", S.option(S.string())),
    "other": o->S.field("other", S.option(S.jsonable())),
  }
)->S.Object.strict
```

- It will error if a enum-to-poly variant conversion has a keyword in it. e.g `type queryParams = {state?: [#open | #merged | #declined]}`, where `#open` is a rescript reserved keyword. I don't know a way around this. 😞

- We only do one level of parameters. e.g.

```yaml
parameters:
  - name: tags
    in: query
    description: tags to filter by
    required: false
    style: form
    schema:
      type: array
      items:
        type: string
  - name: limit
    in: query
    description: maximum number of results to return
    required: false
    schema:
      type: integer
      format: int32
```

will be converted to:

```
type queryParams = {
  tags?: array,
  limit?: integer,
}
```

#### Things to add in the future

- Maybe going forward we could implement a full RPC library similar to [trpc](https://trpc.io/):
  - https://github.com/Nicolas1st/net-cli-rock-paper-scissors/blob/main/apps/client/src/Api.res

#### Dev:
