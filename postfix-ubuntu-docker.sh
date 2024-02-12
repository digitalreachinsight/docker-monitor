#!/bin/bash
#version='v1.0.31'
version='2024.02.12.11.0629'
imagename="postfix-ubuntu";
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
      docker container run --hostname=$1 --name=$imagename --cap-add NET_ADMIN --mount type=bind,source=/container-data/postfix-container/,target=/shared-mount/  --mount type=bind,source=/rotating-backups,target=/backups  -p 25:25 -p 465:465  -p 993:993 -p 143:143  -p 587:587 -d -i -t  digitalreachinsight/postfix-ubuntu:$version
   fi
fi
if [ $unhealthycount -eq 0 ]
then
   echo "Healthy";
fi
