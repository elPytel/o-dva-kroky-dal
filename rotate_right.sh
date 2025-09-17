#!/bin/bash

# Použití: ./rotate_right.sh cesta/k/obrazku.jpg
path_to_img="$1"

if [ -z "$path_to_img" ]; then
  echo "Použití: $0 cesta/k/obrazku.jpg"
  exit 1
fi

convert "$path_to_img" -rotate 90 "$path_to_img"