#!/bin/bash
#version='1.0.9'
version='2021.16.08.09.5828'
imagename="postgres-ubuntu";

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
      docker container run --name=$imagename --mount type=bind,source=/container-data/databases/postgres/postgresdb1/var-lib/,target=/var/lib/postgresql-mount/  --mount type=bind,source=/container-data/databases/postgres/postgresdb1/etc/,target=/etc/postgresql-mount/ --mount type=bind,source=/container-data/databases/postgres/postgresdb1/log/,target=/var/log/postgresql-mount/ --mount type=bind,source=/container-data/databases/postgres/postgresdb1/etc-progresql-common/,target=/etc/postgresql-common-mount/  --mount type=bind,source=/rotating-backups,target=/backups  -p 172.17.0.1:5432:5432  -d -i -t digitalreachinsight/postgres-ubuntu:$version
   fi
fi
if [ $unhealthycount -eq 0 ]
then
   echo "Healthy";
fi
#docker run --name=nginxserver --mount type=bind,source=/mnt/data/,target=/data -p 8901:80  -d -i -t digitalreachinsight/nginx-ubuntu-docker:latest
