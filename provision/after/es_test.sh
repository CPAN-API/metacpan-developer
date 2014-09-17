#!/bin/bash

service=elasticsearch-test-cluster
script=/etc/init.d/$service

cat <<'INIT' | perl -pe "s/{{service}}/$service/g" > $script
#!/bin/bash

### BEGIN INIT INFO
# Provides:          {{service}}
# Required-Start:    $ALL
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
### END INIT INFO

es_real=es-01
. /etc/default/elasticsearch${es_real:+-}$es_real
DATA_DIR=/tmp/{{service}}/data
WORK_DIR=/tmp/{{service}}/work

USER=${ES_USER:-elasticsearch}
PIDFILE=/var/run/{{service}}.pid

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
      -- \
        -Des.http.port=9900 \
        -Des.cluster.name=testing \
        -Des.node.name=testing \
        -Des.default.config=$CONF_FILE \
        -Des.default.path.home=$ES_HOME \
        -Des.default.path.logs=$LOG_DIR \
        -Des.default.path.data=$DATA_DIR \
        -Des.default.path.work=$WORK_DIR \
        -Des.default.path.conf=$CONF_DIR \
        -f
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
