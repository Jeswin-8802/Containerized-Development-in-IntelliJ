#!/bin/sh

# ssh-keygen -A
# https://www.ssh.com/academy/ssh/sshd#startup-and-roles-of-different-sshd-processes
ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/ssh_host_rsa_key -N ""
ssh-keygen -t ecdsa -b 521 -f $HOME/.ssh/ssh_host_ecdsa_key -N ""
ssh-keygen -t ed25519 -f $HOME/.ssh/ssh_host_ed25519_key -N ""

# Port 2200

echo "HostKey $HOME/.ssh/ssh_host_rsa_key
HostKey $HOME/.ssh/ssh_host_ecdsa_key
HostKey $HOME/.ssh/ssh_host_ed25519_key

LogLevel DEBUG
PasswordAuthentication yes
PermitRootLogin no
MaxSessions 2
AllowTcpForwarding yes
AllowStreamLocalForwarding yes
GatewayPorts yes" >> $HOME/.ssh/sshd_config

echo "----------------------------------- starting sshd"

exec /usr/sbin/sshd -D -f $HOME/.ssh/sshd_config -E $HOME/.ssh/log/auth.log