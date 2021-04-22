#!/bin/bash
version='1.0.2'
imagename="mariadb-ubuntu";

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
      docker container run --name=$imagename --mount type=bind,source=/container-data/mariadb-container,target=/data  --mount type=bind,source=/rotating-backups,target=/backups -p 172.17.0.1:3306:3306 -d -i -t digitalreachinsight/mariadb-ubuntu:$version
   fi
fi
if [ $unhealthycount -eq 0 ]
then
   echo "Healthy";
fi
