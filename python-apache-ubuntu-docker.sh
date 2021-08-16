#!/bin/bash
#version='1.0.20'
version='2021.16.08.09.5828'
imagename="pythonapacheubuntu";

unhealthycount=$(docker ps | grep unhealthy | grep $imagename | wc -l);
healthy=$(docker ps | grep "(healthy)" | grep $imagename | grep $version | wc -l);
starting=$(docker ps | grep starting | grep $imagename | wc -l);


if [ $healthy -eq 0 ]
then
   if [ $starting -eq 0 ]
   then 	   
      echo "Unhealthy - restarting";	
      docker stop $imagename 
      docker rm $imagename
      docker run --name=$imagename --mount type=bind,source=/container-data/apache/container1/conf/apache,target=/etc/webconfs/apache  --mount type=bind,source=/container-data/apache/container1/web,target=/var/web/  --mount type=bind,source=/container-data/apache/container1/conf/postfix,target=/etc/postfix-conf --mount type=bind,source=/container-data/apache/container1/conf/cron,target=/etc/contanercron/  -p 172.17.0.1:9000-9100:9000-9100 -p 172.17.0.1:8999:80  -d -i -t digitalreachinsight/python-apache-ubuntu:$version
   fi
fi
if [ $unhealthycount -eq 0 ]
then
   echo "Healthy";
fi
#docker run --name=nginxserver --mount type=bind,source=/mnt/data/,target=/data -p 8901:80  -d -i -t digitalreachinsight/nginx-ubuntu-docker:latest
