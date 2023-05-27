#!/usr/bin/env bash
sed -i '1s;^;#!/usr/bin/env node\n;' bundle/index.bundle.cjs
chmod +x bundle/index.bundle.cjs