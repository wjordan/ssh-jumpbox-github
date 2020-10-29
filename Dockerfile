FROM alpine
RUN apk add --no-cache openssh curl jq
COPY rootfs /
EXPOSE 22
ENTRYPOINT ["/entrypoint.sh"]
