/* eslint-disable */
module.exports = {
  root: true,
  parserOptions: {
    ecmaVersion: 2022,
    sourceType: 'module',
  },
  env: {
    node: true,
    es2022: true,
  },
  extends: ['eslint:recommended'],
  rules: {
    'arrow-parens': 'off',
    complexity: ['error', 4],
    'comma-dangle': 'off',
    camelcase: 'off',
    'dot-notation': 'off',
    'eol-last': 'off',
    'implicit-arrow-linebreak': 'off',
    'max-depth': ['error', 3],
    'max-lines-per-function': ['error', { max: 22, skipComments: true }],
    'max-params': ['error', 4],
    'no-console': 'off',
    'no-duplicate-imports': 'warn',
    'no-unused-vars': ['error', { args: 'after-used', argsIgnorePattern: '_' }],
    'no-confusing-arrow': 'off',
    'object-curly-newline': 'off',
  },
}
