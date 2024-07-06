#!/bin/bash
version='latest'
imagename="vscode-server";
unhealthycount=$(docker ps | grep unhealthy | grep $imagename | wc -l);
healthy=$(docker ps | grep "(healthy)" | grep $imagename | grep $version | wc -l);
starting=$(docker ps | grep starting | grep $imagename | wc -l);
echo $healthy;
echo $starting;
if [ $healthy -eq 0 ]
then
   if [ $starting -eq 0 ]
   then
      echo "Unhealthy - restarting";
      docker stop $imagename
      docker rm $imagename
      docker container run --hostname=$1 --name=$imagename -e PUID=33 -e PGID=33 -e PASSWORD=vscode2023 -e TZ=Etc/UTC  --mount type=bind,source=/container-data/vscode-server/config,target=/config/  --mount type=bind,source=/container-data/,target=/container-data/ -e DEFAULT_WORKSPACE=/container-data/ -p 8443:8443 -d -i -t  lscr.io/linuxserver/code-server:$version
   fi
fi
if [ $unhealthycount -eq 0 ]
then
   echo "Healthy";
fi
# https://github.com/linuxserver/docker-code-server/releases
