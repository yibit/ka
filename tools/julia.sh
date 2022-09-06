#!/bin/sh

set -e

if test $# -ne 1; then
    echo "$0 <project name>"
    exit 1
fi

NAME=$1
cat > /tmp/julia.jl <<EOF
using Pkg
Pkg.generate("$NAME")
EOF

julia /tmp/julia.jl
