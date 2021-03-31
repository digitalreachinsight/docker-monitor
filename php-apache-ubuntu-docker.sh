#!/bin/bash
imagename="phpapacheubuntu";
unhealthycount=$(docker ps | grep unhealthy | grep $imagename | wc -l);
healthy=$(docker ps | grep "(healthy)" | grep $imagename | wc -l);
starting=$(docker ps | grep starting | grep $imagename | wc -l);


if [ $healthy -eq 0 ]
then
   if [ $starting -eq 0 ]
   then 	   
      echo "Unhealthy - restarting";	
      docker stop $imagename 
      docker rm $imagename
      docker run --name=$imagename --mount type=bind,source=/mnt/data/,target=/data -p 172.17.0.1:8000-8100:8000-8100 -d -i -t digitalreachinsight/php-apache-ubuntu:1.0.2
   fi
fi
if [ $unhealthycount -eq 0 ]
then
   echo "Healthy";
fi
#docker run --name=nginxserver --mount type=bind,source=/mnt/data/,target=/data -p 8901:80  -d -i -t digitalreachinsight/nginx-ubuntu-docker:latest
