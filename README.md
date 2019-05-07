
I - Generation du Yaml 

   - Jackson pour la Serialization / Deserialization 
   --> Ex : https://dzone.com/articles/read-yaml-in-java-with-jackson


II - Swagger Api ( Read Only ) : 

   docker run -p 8989:8080 -e SWAGGER_JSON=/mnt/swagger.yaml -v `pwd`:/mnt swaggerapi/swagger-ui
   

III - Edition Mode : 

     1 - Versions : 
        * New Version : https://github.com/Mermade/openapi-gui
        * Old Version ( Nice UI but not maintained ) ( Import Style in the new Version ? )
        
     2 - Convert Yaml to JSON      
        * ./yaml2json.sh swagger.yaml swagger.json
     
     
     docker network create --subnet=192.168.56.250/24 mynet123
     
     docker build -t mermade/openapi-gui . ;   docker container rm -f openapi-gui ; docker run  --net mynet123  --ip 192.168.56.102 --name openapi-gui -p 8080:3000 -d mermade/openapi-gui
     
     
