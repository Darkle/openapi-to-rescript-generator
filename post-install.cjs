const path = require('path')
const fs = require('fs')
const { execSync } = require('child_process')

const rescriptJsonSchemaLibFolder = path.join('node_modules', 'rescript-json-schema')

const rescriptJsonSchemaBsConfigFilePath = path.join(rescriptJsonSchemaLibFolder, 'bsconfig.json')

const bsconfigFileData = JSON.parse(fs.readFileSync(rescriptJsonSchemaBsConfigFilePath, { encoding: 'utf8' }))

delete bsconfigFileData['bs-dev-dependencies']

bsconfigFileData.sources = [bsconfigFileData.sources[0]]

fs.writeFileSync(rescriptJsonSchemaBsConfigFilePath, JSON.stringify(bsconfigFileData, null, 2))

execSync('npm install', { cwd: rescriptJsonSchemaLibFolder })

execSync('npm run res:build', { cwd: rescriptJsonSchemaLibFolder })
