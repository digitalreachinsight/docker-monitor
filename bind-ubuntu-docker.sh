#!/bin/bash
#version='v1.0.8'
version='2024.02.12.11.0629'
imagename="bind-ubuntu"
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
      docker container run --name=$imagename --mount type=bind,source=/container-data/bind-container/,target=/shared-mount/  --mount type=bind,source=/rotating-backups,target=/backups  -p 53:53 -p 53:53/udp -d -i -t  digitalreachinsight/bind-ubuntu:$version
   fi
fi
if [ $unhealthycount -eq 0 ]
then
   echo "Healthy";
fi
