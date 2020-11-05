#!/bin/sh
GITHUB_ORG=${GITHUB_ORG?Required}
GITHUB_TEAM=${GITHUB_TEAM?Required}
GITHUB_TOKEN=${GITHUB_TOKEN?Required}
export | grep GITHUB > /etc/github_keys

SSH_USER=${SSH_USER:-user}
adduser -D -s /sbin/nologin "$SSH_USER"
passwd -u "$SSH_USER" 2>&-

if [ -n "$SSH_HOST_RSA_KEY" ]; then
  RSA_KEY=/etc/ssh/ssh_host_rsa_key
  printf "$SSH_HOST_RSA_KEY" > $RSA_KEY
  chmod 600 $RSA_KEY
  echo "HostKey $RSA_KEY" >> /etc/ssh/sshd_config
else
  ssh-keygen -A
fi

/usr/sbin/sshd -D -e
