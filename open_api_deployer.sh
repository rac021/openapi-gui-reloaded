#!/bin/bash

 CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
 
 cd $CURRENT_PATH 
 
 DOCKER_IMAGE_NAME="arkhineo-openapi-gui"
 DOCKER_CONTAINER_NAME="arkhineo-openapi-gui"
 
 DOCKER_CONTAINER_RO_NAME="arkhineo-openapi-ro"
 
 # YAML PRODUCED BY SCANING resource.conf
 
 IP="192.168.56.102" # THIS IS FIX FOR THE MOMENT ! 
  
 if [ ! -f "$1" ] ; then 
    echo 
    echo " You have to provide a YAML Path as first ARG to the script"
    echo ; exit     
 fi
 
 YAML_ENTRY="$(readlink -f $1)" # Generated File by scanning resource.conf
 
 OUTPUT_JSON_FILE="arkh_open_api.json" # Do not change ( used in docker )
 OUTPUT_YAML_FILE="arkh_open_api.yaml"
 
 OPEN_API_PATH="custom_api/arkhineo_open_api" # Folder used as volume in Docker 
 
 
 # Clear the folder which contains the YAML AND JSON Files if already exists Files 
 
 if [ -d "$OPEN_API_PATH" ]; then
      rm -rf $OPEN_API_PATH
 fi      
 
 cd custom_api  
 
 docker container rm -f $DOCKER_CONTAINER_NAME ; 
 
 docker network remove mynet123 
 
 docker network create --subnet=192.168.56.250/24 mynet123 # Because of CORS 
 
 docker build -t $DOCKER_IMAGE_NAME . ;   
 
 cd $CURRENT_PATH
 
 mkdir $OPEN_API_PATH
 
 # Now generate the Folder that will be used as Volume in Docker 
 ./scripts/yaml2json.sh $YAML_ENTRY $(readlink -f $OUTPUT_JSON_FILE)
 
 cp  $YAML_ENTRY   $OPEN_API_PATH 
 cp  $(readlink -f $OUTPUT_JSON_FILE) $OPEN_API_PATH 
 
 mv "$OPEN_API_PATH/$1" "$OPEN_API_PATH/$OUTPUT_YAML_FILE"
 
 rm $(readlink -f $OUTPUT_JSON_FILE)
 
 # We can run Docker ( Edition Mode )
 docker run  --net mynet123 --ip 192.168.56.102 --name $DOCKER_CONTAINER_NAME -v `pwd`/custom_api/arkhineo_open_api:/usr/src/app/arkhineo_open_api -p 8080:3000 -d $DOCKER_IMAGE_NAME 
 
 ## SWAGGER API ( READ ONLY Mode ) 
 docker container rm -f $DOCKER_CONTAINER_RO_NAME 
 docker run -p 8181:8080 -e SWAGGER_JSON=/mnt/$OUTPUT_YAML_FILE --name $DOCKER_CONTAINER_RO_NAME -v `pwd`/custom_api/arkhineo_open_api/:/mnt -d swaggerapi/swagger-ui
 
 echo ; echo 
 
 echo " ***  Swagger ( R/W    ) Server started at : http://192.168.56.102:3000 *** "
 echo " ***  Swagger ( R ONLY ) Server started at : http://localhost:8181      *** "
 echo ; echo 
 
 
 
