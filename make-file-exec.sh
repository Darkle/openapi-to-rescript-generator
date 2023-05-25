#!/usr/bin/env bash
sed -i '1s;^;#!/usr/bin/env node\n;' src/index.bs.mjs
chmod +x src/index.bs.mjs