#!/bin/bash

if [ $# -gt 0 ]; then
    filename=`date +%Y-%m-%d-`
    filename+=`echo "$@" | sed -e 's/ /-/g'`.md
else
    filename=`date +%Y-%m-%d-new-post.md`
fi

cat > $filename <<EOF
---
layout: post
title: "A title"
description: A description
categories: ["tag"]
---
EOF

echo "New post created: $filename"