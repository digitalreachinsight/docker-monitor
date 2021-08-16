#!/bin/bash
#version='1.0.6'
version='2021.16.08.09.5828'
unhealthycount=$(docker ps | grep unhealthy | grep nginxserver | grep $imagename | wc -l);
healthy=$(docker ps | grep "(healthy)" | grep nginxserver | grep $imagename | grep $version | wc -l);
starting=$(docker ps | grep starting | grep nginxserver | grep $imagename | wc -l);
echo $healthy;
echo $starting;

if [ $healthy -eq 0 ]
then
   if [ $starting -eq 0 ]
   then 	   
      echo "Unhealthy - restarting";	
      docker stop nginxserver
      docker rm nginxserver
      docker container run --name=nginxserver --mount type=bind,source=/container-data/container2/conf/nginx,target=/etc/webconfs/nginx/ --mount type=bind,source=/container-data/container2/conf/letsencrypt,target=/etc/letsencrypt -p 80:80  -p 443:443 -d -i -t digitalreachinsight/nginx-ubuntu-docker:$version
   fi
fi
if [ $unhealthycount -eq 0 ]
then
   echo "Healthy";
fi
#docker run --name=nginxserver --mount type=bind,source=/mnt/data/,target=/data -p 8901:80  -d -i -t digitalreachinsight/nginx-ubuntu-docker:latest
