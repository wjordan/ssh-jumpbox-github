FROM alpine
RUN apk add --no-cache openssh curl jq
COPY sshd_config /etc/ssh/
COPY root/* /root/
EXPOSE 22
ENTRYPOINT ["/root/entrypoint.sh"]
