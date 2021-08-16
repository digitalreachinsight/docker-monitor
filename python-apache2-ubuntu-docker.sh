#!/bin/bash
#version='v1.0.8'
version='2021.16.08.12.3651'
imagename="pythonapache2ubuntu";

unhealthycount=$(docker ps | grep unhealthy | grep $imagename | wc -l);
healthy=$(docker ps | grep "(healthy)" | grep $imagename | grep $version | wc -l);
starting=$(docker ps | grep starting | grep $imagename | wc -l);

container_dir="/container-data/python-apache-container"
if [ -d "$container_dir/web" ]
then
   echo "Directory Exists $container_dir/web"
else
   mkdir "$container_dir/web"
fi

if [ -d "$container_dir/apache-web-config" ]
then
   echo "Directory Exists $container_dir/apache-web-config"
else
   mkdir "$container_dir/apache-web-config"
fi

if [ -d "$container_dir/postfix-conf" ]
then
   echo "Directory Exists $container_dir/postfix-conf"
else
   mkdir "$container_dir/postfix-conf"
fi

if [ -d "$container_dir/cron-conf" ]
then
   echo "Directory Exists $container_dir/cron-conf"
else
   mkdir "$container_dir/cron-conf"
fi


if [ $healthy -eq 0 ]
then
   if [ $starting -eq 0 ]
   then 	   
      echo "Unhealthy - restarting";	
      docker stop $imagename 
      docker rm $imagename
      docker run --name=$imagename --mount type=bind,source=/container-data/python-apache-container/,target=/shared-mount/       -p 172.17.0.1:9000-9100:9000-9100 -p 172.17.0.1:8999:80  -d -i -t digitalreachinsight/python-apache2-ubuntu:$version
   fi
fi
if [ $unhealthycount -eq 0 ]
then
   echo "Healthy";
fi
#docker run --name=nginxserver --mount type=bind,source=/mnt/data/,target=/data -p 8901:80  -d -i -t digitalreachinsight/nginx-ubuntu-docker:latest
