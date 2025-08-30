#!/bin/bash

if [ $# -gt 0 ]; then
    filename=`date +%Y-%m-%d-`
    filename+=`echo "$@" | sed -e 's/ /-/g'`.md
    title=$@
else
    filename=`date +%Y-%m-%d-new-post.md`
    title="A title"
fi

cat > $filename <<EOF
---
layout: post
title: "$title"
description: A description
categories: ["tag"]
---
EOF

echo "New post created: $filename"