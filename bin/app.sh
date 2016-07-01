#!/bin/sh

PORT=__UNSET__
APP_HOME=__UNSET__

case $1 in
    start)
        echo "starting toi ..."
        start_server \
            --daemonize \
            --dir $APP_HOME \
            --port $PORT \
            --log-file $APP_HOME/log/app.log \
            --pid-file $APP_HOME/run/app.pid \
            --status-file $APP_HOME/run/app.status \
            -- plackup -s Twiggy $APP_HOME/bin/app.pl
        echo "done"
    ;;
    stop)
        echo "stopping toi ..."
        start_server \
            --stop \
            --pid-file $APP_HOME/run/app.pid \
            --status-file $APP_HOME/run/app.status
        echo "done"
    ;;
    restart)
        echo "restarting toi ..."
        start_server \
            --restart \
            --pid-file $APP_HOME/run/app.pid \
            --status-file $APP_HOME/run/app.status
        echo "done"
    ;;
    *)
        echo "USAGE: $0 [start|stop|restart]"
    ;;
esac
