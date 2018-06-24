#!/bin/sh
#
# This entrypoint script creates a OpenKore instance prepared to use a random, unused account and character.
# If the enviroment variable OK_USERNAMEMAXSUFFIX is set, the script will connect to the rAthena database
# and retrieve query accounts matching OK_USERNAME plus 0...n number sequence. If the character happen to
# be already online, then skips to the next username.
#
# Variable description:
# ====================
# OK_IP="IP address of the Ragnarok Online server"
# OK_USERNAME="Account username"
# OK_PWD="Account password"
# OK_CHAR="Character slot. Default: 1"
# OK_USERNAMEMAXSUFFIX="Maximum number of suffixes to generate with the username."
# OK_KILLSTEAL="It is ok that the bot attacks monster that are already being attacked by other players."
# OK_FOLLOW_USERNAME1="Name of the username to follow with 20% probability"
# OK_FOLLOW_USERNAME2="Name of a second username to follow with 20% probability"
# MYSQL_HOST="Hostname of the MySQL database. Ex: calnus-beta.mysql.database.azure.com."
# MYSQL_DB="Name of the MySQL database."
# MYSQL_USER="Database username for authentication."
# MYSQL_PWD="Password for authenticating with database. WARNING: it will be visible from Azure Portal."

echo "rAthena Development Team presents"
echo "           ___   __  __"
echo "     _____/   | / /_/ /_  ___  ____  ____ _"
echo "    / ___/ /| |/ __/ __ \/ _ \/ __ \/ __  /"
echo "   / /  / ___ / /_/ / / /  __/ / / / /_/ /"
echo "  /_/  /_/  |_\__/_/ /_/\___/_/ /_/\__,_/"
echo ""
echo "http://rathena.org/board/"
echo ""
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "Initalizing Docker container..."

if [ -z "${OK_IP}" ]; then echo "Missing OK_IP environment variable. Unable to continue."; exit 1; fi
if [ -z "${OK_USERNAME}" ]; then echo "Missing OK_USERNAME environment variable. Unable to continue."; exit 1; fi
if [ -z "${OK_PWD}" ]; then echo "Missing OK_PWD environment variable. Unable to continue."; exit 1; fi
if [ -z "${OK_CHAR}" ]; then OK_CHAR=1; fi

if [ "${OK_KILLSTEAL}" == "1" ]; then 
    sed -i "1487s|return 0|return 1|" /opt/openkore/src/Misc.pm
    sed -i "1514s|return 0|return 1|" /opt/openkore/src/Misc.pm
    sed -i "1551s|return !objectIsMovingTowardsPlayer(\$monster);|return 1;|" /opt/openkore/src/Misc.pm
    sed -i "1563s|return 0|return 1|" /opt/openkore/src/Misc.pm
fi

if [ -z "${OK_USERNAMEMAXSUFFIX}" ]; then
    sed -i "s|^username$|username ${OK_USERNAME}|g" /opt/openkore/control/config.txt
else
    if [ -z "${MYSQL_HOST}" ]; then echo "Missing MYSQL_HOST environment variable. Unable to continue."; exit 1; fi
    if [ -z "${MYSQL_DB}" ]; then echo "Missing MYSQL_DB environment variable. Unable to continue."; exit 1; fi
    if [ -z "${MYSQL_USER}" ]; then echo "Missing MYSQL_USER environment variable. Unable to continue."; exit 1; fi
    if [ -z "${MYSQL_PWD}" ]; then echo "Missing MYSQL_PWD environment variable. Unable to continue."; exit 1; fi
    for i in `seq 0 ${OK_USERNAMEMAXSUFFIX}`;
    do
        USERNAME=${OK_USERNAME}${i}
        MYSQL_QUERY="SELECT \`online\` FROM \`char\` WHERE name='${USERNAME}';"
        CHAR_IS_ONLINE=$(mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h ${MYSQL_HOST} -D ${MYSQL_DB} -ss -e "${MYSQL_QUERY}");
        if [ "${CHAR_IS_ONLINE}" == "0" ]; then
            MYSQL_QUERY="UPDATE \`char\` SET \`online\`=1 WHERE name='${USERNAME}'"
            mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h ${MYSQL_HOST} -D ${MYSQL_DB} -ss -e "${MYSQL_QUERY}"
            CLASS=$(mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h ${MYSQL_HOST} -D ${MYSQL_DB} -ss -e "SELECT class FROM \`char\` WHERE name='${USERNAME}';")
            case ${CLASS} in
                4) # ACOLYTE
                    mv /opt/openkore/control/config.txt /opt/openkore/control/config.txt.bak
                    cp /opt/openkore/control/class/acolyte.txt /opt/openkore/control/config.txt
                    ;;
                8) # PRIEST
                    mv /opt/openkore/control/config.txt /opt/openkore/control/config.txt.bak
                    cp /opt/openkore/control/class/priest.txt /opt/openkore/control/config.txt
                    ;;
                15) # MONK
                    mv /opt/openkore/control/config.txt /opt/openkore/control/config.txt.bak
                    cp /opt/openkore/control/class/monk.txt /opt/openkore/control/config.txt
                    ;;
                2) # MAGE
                    mv /opt/openkore/control/config.txt /opt/openkore/control/config.txt.bak
                    cp /opt/openkore/control/class/mage.txt /opt/openkore/control/config.txt
                    ;;
                9) # WIZARD
                    mv /opt/openkore/control/config.txt /opt/openkore/control/config.txt.bak
                    cp /opt/openkore/control/class/wizard.txt /opt/openkore/control/config.txt
                    ;;
                16) # SAGE
                    mv /opt/openkore/control/config.txt /opt/openkore/control/config.txt.bak
                    cp /opt/openkore/control/class/sage.txt /opt/openkore/control/config.txt
                    ;;
                1) # SWORDMAN
                    mv /opt/openkore/control/config.txt /opt/openkore/control/config.txt.bak
                    cp /opt/openkore/control/class/swordman.txt /opt/openkore/control/config.txt
                    ;;
                7) # KNIGHT
                    mv /opt/openkore/control/config.txt /opt/openkore/control/config.txt.bak
                    cp /opt/openkore/control/class/knight.txt /opt/openkore/control/config.txt
                    ;;
            esac
            sed -i "s|^username$|username ${USERNAME}|g" /opt/openkore/control/config.txt
            # 1,2 -> Follow OK_FOLLOW_USERNAME1, 3,4 -> Follow OK_FOLLOW_USERNAME2, 5-10 -> Do not follow
            case $(shuf -i1-10 -n1) in
                1|2)
                    if ! [ -z "${OK_FOLLOW_USERNAME1}" ]; then
                        sed -i "s|^followTarget$|followTarget ${OK_FOLLOW_USERNAME1}|g" /opt/openkore/control/config.txt
                        #sed -i "s|^attackAuto 2$|attackAuto 1|g" /opt/openkore/control/config.txt
                    fi
                    ;;
                3|4)
                    if ! [ -z "${OK_FOLLOW_USERNAME2}" ]; then
                        sed -i "s|^followTarget$|followTarget ${OK_FOLLOW_USERNAME2}|g" /opt/openkore/control/config.txt
                        #sed -i "s|^attackAuto 2$|attackAuto 1|g" /opt/openkore/control/config.txt
                    fi
                    ;;
            esac
            break
        fi
    done
fi
sed -i "s|^master$|master rAthena|g" /opt/openkore/control/config.txt
sed -i "s|^server$|server 0|g" /opt/openkore/control/config.txt
sed -i "s|^password$|password ${OK_PWD}|g" /opt/openkore/control/config.txt
sed -i "s|^char$|char ${OK_CHAR}|g" /opt/openkore/control/config.txt
sed -i "s|^autoResponse 0$|autoResponse 1|g" /opt/openkore/control/config.txt
sed -i "s|^autoResponseOnHeal 0$|autoResponseOnHeal 1|g" /opt/openkore/control/config.txt
sed -i "s|^route_randomWalk_inTown 0$|route_randomWalk_inTown 1|g" /opt/openkore/control/config.txt
sed -i "s|^partyAuto 1$|partyAuto 2|g" /opt/openkore/control/config.txt
sed -i "s|^follow 0$|follow 1|g" /opt/openkore/control/config.txt
sed -i "s|^followSitAuto 0$|followSitAuto 1|g" /opt/openkore/control/config.txt
sed -i "s|^attackAuto_inLockOnly 1$|attackAuto_inLockOnly 0|g" /opt/openkore/control/config.txt

sed -i "s|^lockMap$|lockMap gef_fild07|g" /opt/openkore/control/config.txt
sed -i "s|^lockMap_x$|lockMap_x 218|g" /opt/openkore/control/config.txt
sed -i "s|^lockMap_y$|lockMap_y 185|g" /opt/openkore/control/config.txt
sed -i "s|^lockMap_randX$|lockMap_randX 115|g" /opt/openkore/control/config.txt
sed -i "s|^lockMap_randY$|lockMap_randY 20|g" /opt/openkore/control/config.txt

sed -i "s|^ip 172.17.0.3$|ip ${OK_IP}|g" /opt/openkore/tables/servers.txt

exec "$@"
