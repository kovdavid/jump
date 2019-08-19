# DESCRIPTION

`jump` is a command line utility to jump to specific directories based on configured aliases

# USAGE

```
cd ~/workspace
git clone https://github.com/DavsX/jump
echo "source ~/workspace/jump/jump" >> .bashrc
echo "alias j='__davsx_jump'" >> .bashrc

sudo ln -s ~/workspace/jump/jump-bash-complete.sh /etc/bash_completion.d

source ~/.bashrc
j help
```
