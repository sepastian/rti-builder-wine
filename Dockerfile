FROM tianon/wine:32
LABEL maintainer="Sebastian Gassner <sebastian.gassner@gmail.com>"
ADD app /app
ENTRYPOINT ["/app/bin/run.sh"]
