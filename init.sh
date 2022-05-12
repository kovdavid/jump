#!/bin/bash

sudo mkdir -p /etc/bash_completion.d
sudo ln -sf $(readlink -f jump-bash-complete.sh) /etc/bash_completion.d/
