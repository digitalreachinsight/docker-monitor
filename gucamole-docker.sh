#!/bin/bash

# gucamole (rdp web)
docker container run --mount type=bind,source=/container-data/guacamole-oznu/config,target=/config/ --mount type=bind,source=/container-data/guacamole-oznu/guacarecording,target=/guacarecording -p 8888:8080  -d -i -t oznu/guacamole

