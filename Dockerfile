FROM debian:jessie

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -qy install --no-install-recommends wget ca-certificates

COPY ./map_updater.sh /usr/local/bin/map_updater.sh
COPY ./default_level_sounds.txt /srv/default_level_sounds.txt

ENTRYPOINT ["/home/steam/steamcmd/run_tf2.sh"]
