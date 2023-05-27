const esbuild = require('esbuild')
const fs = require('fs')

const esbuildPluginCopyHbsFile = () => ({
  name: 'copy-handlebars-file',
  setup(build) {
    build.onEnd(() => fs.copyFileSync('./src/template.hbs', './bundle/template.hbs'))
  },
})

/** @type {import('esbuild').BuildOptions} */
const esbuildConfig = {
  entryPoints: ['./src/index.bs.mjs'],
  outfile: './bundle/index.bundle.cjs',
  bundle: true,
  minify: !!process.env.MINIFY,
  sourcemap: false,
  platform: 'node',
  treeShaking: true,
  format: 'cjs',
  plugins: [esbuildPluginCopyHbsFile()],
}

if (process.env.WATCH) {
  esbuild
    .context(esbuildConfig)
    .then(ctx => ctx.watch())
    .catch(err => console.error(err))
} else {
  esbuild.build(esbuildConfig).catch(err => console.error(err))
}
