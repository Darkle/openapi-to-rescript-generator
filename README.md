# Openapi to Rescript generator

> **Note**
> This is just a first pass at this. Some stuff isn't supported yet. Expect some bugs.

#### Introduction:

- Generate rescript code from an [openapi spec](https://spec.openapis.org/oas/v3.1.0) document to help you validate & parse responses from your api. It also generates types for parameters and validation for request bodies.

- It supports openapi specs in json and yaml form.

- Most of the heavy lifting is done by the [Rescript Struct](https://github.com/DZakh/rescript-struct) and [Rescript Json Schema](https://github.com/DZakh/rescript-json-schema) libs.

#### Usage:

1. Install via `npm install openapi-to-rescript-generator -g`
2. Run `openapi-to-rescript --inputFile <inputFilePath> --outputFile <outputFilePath>`.
   - Example: `openapi-to-rescript --inputFile ./foo/openapi.json --outputFile ./bar/output.res`
3. You will then need to install [rescript struct](https://github.com/DZakh/rescript-struct#install) in your app for working with the file you created.

#### Limitations

- Needs an [operationId](https://spec.openapis.org/oas/v3.1.0#fixed-fields-7) to be specified
- The [validation structs](https://github.com/DZakh/rescript-struct) are only generated for responses and request bodies.
- Parameters are just generated as types and have no validation.
- We only support string enums for parameters at the moment
- You may need to manually annotate unions in the output. See here for more details: https://github.com/DZakh/rescript-struct/issues/56
  - Here is an example of annotating a union inline:

```rescript
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
    "service": o->S.field("service", S.string()),
  }
)->S.Object.strict
```

- If an enum contains a Rescript reserved keyword, we can't convert it to a polymorphic variant, so instead we just set it as a string. (I don't know of a way to alias a poly variant's name).

  - e.g. `type queryParams = {state: [#open | #merged | #declined]}` becomes `type queryParams = {state: string}` as `open` is a Rescript reserved keyword.

- We don't do nested parameter schemas at the moment. We only do the first level of the schema. e.g.

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

#### Things to possibly add in the future

- Maybe going forward we could implement a full RPC library similar to [trpc](https://trpc.io/):
  - https://github.com/Nicolas1st/net-cli-rock-paper-scissors/blob/main/apps/client/src/Api.res

#### Dev:

- Use [npm link](https://docs.npmjs.com/cli/v9/commands/npm-link) for trying out while developing
- Note: we develop in esm, but bundle to cjs as I had issues of dynamically created import statements being created when i tried to bundle to esm (e.g. `import("foo" + bar + "baz")`). I think it was a library file.
- Run `node bundle/index.bundle.cjs --inputFile /wherever/openapi.json --outputFile ./output.res` to run/test when developing
- To publish a new version:
  1. First check it installs ok by running `npm run build-and-publish-dry-run`, then `npm install . -g` from the project folder and test the command works globally
     - If it works ok, run `npm uninstall openapi-to-rescript-generator -g` to uninstall.
  1. bump the version in `package.json`
  1. run `npm build-and-publish-dry-run` and check there are no wayward files listed.
  1. run `npm build-and-publish`
