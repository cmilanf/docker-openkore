# Docker OpenKore, a free/open source client and automation tool for Ragnarok Online
This repository is a Docker build of [OpenKore](https://github.com/OpenKore/openkore), an open-source client and automation tool for Ragnarok Online that with the correct tweaking it is compatible with [rAthena](https://github.com/cmilanf/docker-rathena) server software.

  * Build features:
    * Uses [Alpine Linux](https://hub.docker.com/_/alpine/) as base image.
    * Builds from the master branch of OpenKore's Github repository.
    * As any other Docker container, it can be run multiple times in the same host with proper resource management.
  * Runtime features:
    * It can connect to the servers with IP, username and password or...
    * If server MySQL database (rAthena) is accesible to the Docker container, it can randomly select a user account for login.
    * It supports random automation behaviour depending on the character class and if it is selected to have a master character to support.

This Docker image was developed for the call for speakers of the [Global Azure Bootcamp 2018 - Madrid](http://azurebootcamp.es) and you can view the session recording (Spanish only):

[![GAB 2018 - Track 1 - Modo Dios en un MMORPG sobre AKS y la ciudad de los 200 bots](https://img.youtube.com/vi/ZBDJImdmiUo/0.jpg)](https://www.youtube.com/watch?v=ZBDJImdmiUo)

Even if this Docker build was developed for that session, it is focused at [Kubernetes](https://kubernetes.io) and container orchestration in [Azure Kubernetes Service](https://azure.microsoft.com/es-es/services/kubernetes-service/).

## File description

  * **config/**. Custom automation config depending on character class.
  * **k8s/**. Kubernetes YAML files to deploy the service in on-premises development environment, AKS and Rancher 2.x.
  * **tools/**. Some small Windows batch scripts for automating some operations as ACR permissions for AKS cluster.
  * **Dockerfile**. The core of this repo, documented with the LABEL entries.
  * **docker-entrypoint.sh**. The Docker entrypoint that leaves the container in the desired state for execution.
  * **recvpackets.txt**. Sample results from [this process](http://openkore.com/index.php/Packet_Length_Extractor), needed if we are connecting OpenKore to rAthena.
  * **servers.txt**. Server configuration for rAthena, values explanation can be found [here](http://openkore.com/index.php/Connectivity_Guide)

## Requeriments
OpenKore requires a Ragnarok Online or [rAthena](https://github.com/cmilanf/docker-rathena) server online in order to work.
The image is based on Alpine Linux and targets to run at Linux x64 architectures.

Alpine Linux footprint is fairly small, but OpenKore can be quite consuming in terms of CPU and RAM memory usage. Each container can take about 500-1000 mCPU and ~380 MB RAM.

## Environment variables accepted by the image

  * OK_IP. IP address of the Ragnarok Online or rAthena server
  * OK_USERNAME. Account username.
  * OK_PWD. Account password.
  * OK_CHAR. Character slot. Default: 1
  * OK_USERNAMEMAXSUFFIX. Maximum number of suffixes to generate with the username.
  * OK_KILLSTEAL. It is ok that the bot attacks monster that are already being attacked by other players.
  * OK_FOLLOW_USERNAME1. Name of the username to follow with 20% probability.
  * OK_FOLLOW_USERNAME2. Name of a second username to follow with 20% probability.
  * MYSQL_HOST. Hostname of the MySQL database. Ex: calnus-beta.mysql.database.azure.com.
  * MYSQL_DB. Name of the MySQL database.
  * MYSQL_USER. Database username for authentication.
  * MYSQL_PWD. Password for authenticating with database.

## Usage
If you have a readily accesible rAthena's MySQL sever and the rAthena server itself, then usage is straight forward:

```
docker run -d --restart=unless-stopped -e MYSQL_HOST="MYSQL host IP" -e MYSQL_USER="MySQL username" -e MYSQL_PWD="MySQL password" -e MYSQL_DB="rAthena" -e OK_IP="10.0.0.3" -e OK_USERNAME="botijo" -OK_PWD="p4ss@w0rd" -e OK_USERNAMEMAXSUFFIX="5000" -e OK_FOLLOW_USERNAME1="Karloch" cmilanf/docker-openkore:latest
```

## Related projects:

  * [docker-rathena](https://github.com/cmilanf/docker-rathena)
  * [docker-rathena-fluxcp](https://github.com/cmilanf/docker-rathena-fluxcp)

## License
MIT License

Copyright (c) 2018 Carlos Milán Figueredo

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
