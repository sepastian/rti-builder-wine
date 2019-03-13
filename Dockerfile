FROM tianon/wine:32
LABEL maintainer="Sebastian Gassner <sebastian.gassner@gmail.com>"
ADD ./vendor /vendor
ENTRYPOINT ["/usr/bin/wine", "/vendor/HSHfitter/hshfitter.exe"]
