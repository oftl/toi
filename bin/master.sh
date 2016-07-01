# PORT=__UNSET__
APP_HOME=__UNSET__

case $1 in
    start)
        echo "starting toi master ..."
        start_server \
            --daemonize \
            --dir $APP_HOME \
            --log-file $APP_HOME/log/master.log \
            --pid-file $APP_HOME/run/master.pid \
            --status-file $APP_HOME/run/master.status \
            $APP_HOME/bin/master.pl
        echo "done"
    ;;
    stop)
        echo "stopping toi master ..."
        start_server \
            --stop \
            --pid-file $APP_HOME/run/master.pid \
            --status-file $APP_HOME/run/master.status
        echo "done"
    ;;
    restart)
        echo "restarting toi master ..."
        start_server \
            --restart \
            --pid-file $APP_HOME/run/master.pid \
            --status-file $APP_HOME/run/master.status
        echo "done"
    ;;
    *)
        echo "USAGE: $0 [start|stop|restart]"
    ;;
esac
