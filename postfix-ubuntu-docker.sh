#!/bin/bash
version='v1.0.12'
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
      docker container run --name=$imagename --mount type=bind,source=/container-data/postfix-container/,target=/shared-mount/  --mount type=bind,source=/rotating-backups,target=/backups  -p 125:25 -p 1465:465  -p 1993:993 -p 1143:143  -p 1587:587 -d -i -t  digitalreachinsight/postfix-ubuntu:$version
   fi
fi
if [ $unhealthycount -eq 0 ]
then
   echo "Healthy";
fi
#docker run --name=nginxserver --mount type=bind,source=/mnt/data/,target=/data -p 8901:80  -d -i -t digitalreachinsight/nginx-ubuntu-docker:latest
