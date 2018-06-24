FROM alpine:3.7

LABEL title="openkore" \
  maintainer="Carlos Milán Figueredo" \
  version="1.1" \
  url1="https://calnus.com" \
  url2="http://www.hispamsx.org" \
  bbs="telnet://bbs.hispamsx.org" \
  twitter="@cmilanf" \
  thanksto1="Beatriz Sebastián Peña" \
  thanksto2="Alberto Marcos González"

LABEL OK_IP="IP address of the Ragnarok Online server" \
  OK_USERNAME="Account username" \
  OK_PWD="Account password" \
  OK_CHAR="Character slot. Default: 1" \
  OK_USERNAMEMAXSUFFIX="Maximum number of suffixes to generate with the username." \
  OK_FOLLOW_USERNAME1="Name of the username to follow with 20% probability" \
  OK_FOLLOW_USERNAME2="Name of a second username to follow with 20% probability" \
  OK_KILLSTEAL="It is ok that the bot attacks monster that are already being attacked by other players." \
  MYSQL_HOST="Hostname of the MySQL database. Ex: calnus-beta.mysql.database.azure.com." \
  MYSQL_DB="Name of the MySQL database." \
  MYSQL_USER="Database username for authentication." \
  MYSQL_PWD="Password for authenticating with database. WARNING: it will be visible from Azure Portal."

RUN mkdir -p /opt/openkore \
  && apk update \
  && apk add --no-cache git build-base g++ perl perl-dev perl-time-hires perl-compress-raw-zlib readline readline-dev ncurses-libs ncurses-terminfo-base ncurses-dev python2 curl curl-dev nano dos2unix mysql-client bind-tools \
  && git clone https://github.com/openkore/openkore.git /opt/openkore \
  && ln -s /usr/lib/libncurses.so /usr/lib/libtermcap.so \
  && ln -s /usr/lib/libncurses.a /usr/lib/libtermcap.a \
  && cd /opt/openkore/ \
  && make \
  && mv /opt/openkore/tables/servers.txt /opt/openkore/tables/servers.txt.bak \
  && mkdir /opt/openkore/control/class/

COPY recvpackets.txt /opt/openkore/tables/
COPY servers.txt /opt/openkore/tables/
COPY docker-entrypoint.sh /usr/local/bin/
COPY config/acolyte.txt /opt/openkore/control/class/acolyte.txt
COPY config/archer.txt /opt/openkore/control/class/archer.txt
COPY config/knight.txt /opt/openkore/control/class/knight.txt
COPY config/mage.txt /opt/openkore/control/class/mage.txt
COPY config/monk.txt /opt/openkore/control/class/monk.txt
COPY config/priest.txt /opt/openkore/control/class/priest.txt
COPY config/sage.txt /opt/openkore/control/class/sage.txt
COPY config/swordman.txt /opt/openkore/control/class/swordman.txt
COPY config/wizard.txt /opt/openkore/control/class/wizard.txt

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

WORKDIR /opt/openkore
CMD ["/opt/openkore/openkore.pl"]
