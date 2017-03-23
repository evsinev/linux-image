# linux-image

Scripts to install the minimum ubuntu version on ARMv7 boards.

# Requirements

apt-get install parted bsdtar dosfstools

# After install

Run the commands after booting

    apt-get update && apt-get -y upgrade && apt-get install -y mc htop openssh-server docker.io
    localedef -i en_US -c -f UTF-8 en_US.UTF-8

# Adding user

    USERNAME=es
    useradd -m $USERNAME && usermod -aG sudo,dialout $USERNAME
    passwd $USERNAME

