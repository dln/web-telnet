FROM debian as build
# RUN apk add -U bash python util-linux
RUN apt-get update && apt-get install -qy python
COPY ./ /app
WORKDIR /app
RUN libapps/libdot/bin/concat.sh -i libapps/hterm/concat/hterm_all.concat -o hterm_all.js

FROM alpine:3.7
RUN apk add -U python py2-numpy py2-pip
COPY --from=build /app/index.html /app/hterm_all.js /app/
COPY --from=build /app/websockify /app/websockify

ENV TELNET_SERVER localhost:23

CMD /app/websockify/run -v --web=/app :8000 ${TELNET_SERVER}
