#!/bin/bash

# Initialize variables
DOMAIN=""

# Function to process -se switch
function function1() {
    echo "Executing function1 for -se"
}

# Function to process -eu switch
function function2() {
    echo "Executing function2 for -eu"
}

# Process command-line arguments
while [ $# -gt 0 ]; do
    case "$1" in
        "-d" )
            shift
            DOMAIN="$1"
            ;;
        "-se" )
            function1
            ;;
        "-eu" )
            function2
            ;;
        * )
            echo "Unknown option or argument: $1"
            exit 1
            ;;
    esac
    shift
done

# Display the processed values
echo "Domain: $DOMAIN"
