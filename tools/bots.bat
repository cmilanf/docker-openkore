IF %1==launch goto LAUNCH
IF %1==stop goto STOP
IF %1==start goto START
IF %1==remove goto REMOVE
EXIT /B

:LAUNCH
FOR /L %%i IN (1, 1, %2) DO (
    docker run -d --name rathena-openkore%%i -e OK_USERNAME=botijo%%i -e OK_PWD=p4ssw0rd -e OK_IP=172.17.0.3 cmilanf/openkore:latest
)
EXIT /B

:STOP
FOR /L %%i IN (1, 1, %2) DO (
    docker stop rathena-openkore%%i
)
EXIT /B

:START
FOR /L %%i IN (1, 1, %2) DO (
    docker start rathena-openkore%%i
)
EXIT /B

:REMOVE
FOR /L %%i IN (1, 1, %2) DO (
    docker rm rathena-openkore%%i
)
EXIT /B
