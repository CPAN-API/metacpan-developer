#!/bin/bash

service=elasticsearch-test-cluster
script=/etc/init.d/$service

cat <<'INIT' > $script
#!/bin/bash

### BEGIN INIT INFO
# Provides:          elasticsearch-test-cluster
# Required-Start:    $ALL
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
### END INIT INFO

ES_HOME=/opt/elasticsearch-0.20.2
USER=elasticsearch
PIDFILE=/var/run/elasticsearch-test-cluster.pid

# The test suite doesn't need much memory.
export ES_HEAP_SIZE=32m

daemon () {
  #--signal INT

  start-stop-daemon \
    --pidfile $PIDFILE \
    --oknodo \
    "$@"
}

# Changing the port and cluster name is what separates the two instances
# and makes this one just for testing.
start () {
  daemon \
    --chuid $USER \
    --background --make-pidfile \
    --startas $ES_HOME/bin/elasticsearch \
    --start \
      -- -f -Des.http.port=9900 -Des.cluster.name=testing
}

stop () {
  daemon --stop
}

status () {
  daemon --status
}

action="$1"
case "$action" in
  start|stop|status)
    $action
    ;;
  restart)
    status && stop && sleep 2
    start
    ;;
  *)
    echo "Usage: $0 (start|stop|status|restart)";
    exit 1
    ;;
esac

INIT

chmod 0755 "$script"
sudo /usr/sbin/update-rc.d "$service" defaults 95 10
sudo service "$service" restart
