#!/bin/bash
#version='v1.0.12'
#version='2022.03.23.06.1616'
version='2022.12.08.14.3838'
imagename="phpapache2ubuntu";
unhealthycount=$(docker ps | grep unhealthy | grep $imagename | wc -l);
healthy=$(docker ps | grep "(healthy)" | grep $imagename | grep $version | wc -l);
starting=$(docker ps | grep starting | grep $imagename | wc -l);


container_dir="/container-data/php-apache-container"
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



if [ $healthy -eq 0 ]
then
   if [ $starting -eq 0 ]
   then 	   
      echo "Unhealthy - restarting";	
      docker stop $imagename 
      docker rm $imagename
      docker run --name=$imagename --mount type=bind,source=/container-data/php-apache-container/,target=/shared-mount/ -p 172.17.0.1:8000-8100:8000-8100 -d -i -t digitalreachinsight/php-apache2-ubuntu:$version
   fi
fi
if [ $unhealthycount -eq 0 ]
then
   echo "Healthy";
fi
#docker run --name=nginxserver --mount type=bind,source=/mnt/data/,target=/data -p 8901:80  -d -i -t digitalreachinsight/nginx-ubuntu-docker:latest

#docker run --name=$imagename --mount type=bind,source=/container-data/apache/container1/conf/apache,target=/etc/webconfs/apache  --mount type=bind,source=/container-data/apache/container1/web,target=/var/web/  --mount type=bind,source=/container-data/apache/container1/conf/postfix,target=/etc/postfix-conf --mount type=bind,source=/container-data/apache/container1/conf/cron,target=/etc/contanercron/  -p 172.17.0.1:9000-9100:9000-9100 -p 172.17.0.1:8999:80  -d -i -t digitalreachinsight/python-apache-ubuntu:1.0.19

