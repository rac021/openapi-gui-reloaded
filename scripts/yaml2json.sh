#!/bin/bash

# Needs Ruby

 CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
 cd $CURRENT_PATH

 INPUT_YAML_FILE=$1

 OUTPUT_JSON_FILE=$2

function yaml2json()
{
    ruby -ryaml -rjson -e \
         'puts JSON.pretty_generate(YAML.load(ARGF))' $*
}


yaml2json $INPUT_YAML_FILE > $OUTPUT_JSON_FILE 

echo
echo " File created in the folder : $OUTPUT_JSON_FILE "
echo
