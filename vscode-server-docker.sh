#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
version='latest'
imagename="vscode-server";
unhealthycount=$(docker ps | grep unhealthy | grep $imagename | wc -l);
healthy=$(docker ps | grep "(healthy)" | grep $imagename | grep $version | wc -l);
starting=$(docker ps | grep starting | grep $imagename | wc -l);
echo $healthy;
echo $starting;
ENV_FILE="/env/vscodeserver.env"

# -e PUID=33 -e PGID=33 -e PASSWORD=vscode2023 -e TZ=Etc/UTC 
if [ $healthy -eq 0 ]
then
   if [ $starting -eq 0 ]
   then
      echo "Unhealthy - restarting";
      docker stop $imagename
      docker rm $imagename
      docker container run --hostname=$1 --name=$imagename --env-file=$SCRIPTPATH$ENV_FILE --mount type=bind,source=/container-data/vscode-server/config,target=/config/  --mount type=bind,source=/container-data/,target=/container-data/ -e DEFAULT_WORKSPACE=/container-data/ -p 8443:8443 -d -i -t  lscr.io/linuxserver/code-server:$version
   fi
fi
if [ $unhealthycount -eq 0 ]
then
   echo "Healthy";
fi
# https://github.com/linuxserver/docker-code-server/releases

#PUID=33
#PGID=33
#PASSWORD=vscodepassword 
#TZ=Etc/UTC
#PROXY_DOMAIN=proxyurl.example.com
#DEFAULT_WORKSPACE=/config/workspace
