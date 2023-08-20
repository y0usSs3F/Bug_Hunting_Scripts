#!/bin/bash

echo "Before shift:"
echo "Argument 1: $1"
echo "Argument 2: $2"
echo "Argument 3: $3"

# Shift the arguments to the left
shift
shift

echo "After shift:"
echo "Argument 1: $1"
echo "Argument 2: $2"
echo "Argument 3: $3"
