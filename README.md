# SSH Jumpbox for GitHub

Docker container providing a simple, minimal (<100 lines of code) SSH 'jump box' for a single GitHub Team.

SSH authentication is restricted to public keys of GitHub Team members, authorizing access to a single login user that allows only TCP forwarding.

## Usage

Prepare a few runtime environment variables:

|Variable|Description|
|---|---|
|GITHUB_ORG|GitHub organization name|
|GITHUB_TEAM|GitHub team name|
|GITHUB_TOKEN|GitHub access token (with `read:org` permissions)|
|SSH_USER|SSH login user name (optional; default `user`)|
|SSH_HOST_RSA_KEY|SSH host RSA key (optional; default generated at runtime)|

Run the Docker container to start the SSH server, providing the environment variables and publishing Port 22:
```shell
docker run \
  -e GITHUB_ORG=my-org \
  -e GITHUB_TEAM=my-team \
  -e GITHUB_TOKEN=[token] \
  -p 2222:22 \
  ssh-jumpbox-github
```

Try logging in to the server using `ssh`, and you can authenticate using your GitHub private key, but can't login to an interactive shell:

```shell
$ ssh user@localhost -p 2222
PTY allocation request failed on channel 0
nologin: this account is not available
Connection to localhost closed.
```

You can now set up a TCP-forwarding-only SSH session using `-N` and `-L` (`LocalForward`) command-line options:

```shell
$ ssh user@localhost -p 2222 -N -L 0.0.0.0:8080:google.com:80
# [port forwarding established]

# [in another terminal...]
$ curl -s localhost:8080/ -H "Host: www.google.com" -I
HTTP/1.1 200 OK
[...]
```

Or you can use the server as a jump host using the `-J` (`ProxyJump`) option:

```shell
$ ssh -J user@localhost:2222 me@network-server.internal
Logged in to Internal Server
me@network-server.internal:~$
```
