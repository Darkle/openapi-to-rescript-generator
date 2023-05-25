#!/usr/bin/env bash
sed -i '1s;^;#!/usr/bin/env node\n;' src/index.bundle.cjs
chmod +x src/index.bundle.cjs