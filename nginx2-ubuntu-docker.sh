#!/bin/bash
#version='1.0.6'
version='2021.12.07.14.5029'
imagename='nginxserver'
unhealthycount=$(docker ps | grep unhealthy | grep $imagename | wc -l);
healthy=$(docker ps | grep "(healthy)" | grep $imagename | grep $version | wc -l);
starting=$(docker ps | grep starting | grep $imagename | wc -l);
echo $healthy;
echo $starting;
container_dir="/container-data/nginx-container"

mkdir /container-data/nginx-container/log
mkdir /container-data/nginx-container/log/nginx
if [ -d "$container_dir/log" ] 
then
   echo "Directory Exists $container_dir/log"
else
   mkdir "$container_dir/log"
fi

if [ -d "$container_dir/log/nginx" ] 
then
   echo "Directory Exists $container_dir/log/nginx"
else
   mkdir "$container_dir/log/nginx"
fi



if [ -d "$container_dir/nginx-config" ] 
then
   echo "Directory Exists $container_dir/nginx-config"
else
   mkdir "$container_dir/nginx-config"
fi

if [ -d "$container_dir/letsencrypt-config" ]
then
   echo "Directory Exists $container_dir/letsencrypt-config"
else
   mkdir "$container_dir/letsencrypt-config"
fi


if [ $healthy -eq 0 ]
then
   if [ $starting -eq 0 ]
   then 	   
      echo "Unhealthy - restarting";	
      docker stop nginxserver
      docker rm nginxserver
      docker container run --name=nginxserver --mount type=bind,source=/container-data/nginx-container/nginx-config,target=/etc/webconfs/nginx/ --mount type=bind,source=/container-data/nginx-container/letsencrypt-config,target=/etc/letsencrypt --mount type=bind,source=/container-data/nginx-container/log/nginx,target=/var/log/nginx -p 80:80  -p 443:443 -d -i -t digitalreachinsight/nginx-ubuntu-docker:$version
   fi
fi
if [ $unhealthycount -eq 0 ]
then
   echo "Healthy";
fi
#docker run --name=nginxserver --mount type=bind,source=/mnt/data/,target=/data -p 8901:80  -d -i -t digitalreachinsight/nginx-ubuntu-docker:latest
