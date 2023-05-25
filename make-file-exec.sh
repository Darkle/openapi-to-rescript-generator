#!/usr/bin/env bash
sed -i '1s;^;#!/usr/bin/env node\n;' src/index.bundle.mjs
chmod +x src/index.bundle.mjs