FROM alpine:latest

LABEL \
maintainer="Eric Sage <eric.david.sage@gmail.com>" \ 
repository="https://github.com/ericsage/code"

# Dockerfile variables
ENV \
REPONAME=port \
HOME=/root \
GOPATH=/root/Code \
LANG=en_US.UTF-8

# Set and update package repositories
COPY /repositories /etc/apk/repositories
RUN apk update -q && apk upgrade --latest -q

# Install system packages
COPY /packages/apk $HOME/.packages/apk
RUN apk add -q $(cat $HOME/.packages/apk)

# Install python packages
COPY /packages/pip $HOME/.packages/pip
RUN pip3 install --upgrade -qqq -r $HOME/.packages/pip

# Install go packages
COPY /packages/go $HOME/.packages/go
RUN go get $(cat $HOME/.packages/go) && \
$GOPATH/bin/gometalinter --install &> /dev/null

# Install gcloud SDK and kubectl
RUN \
wget -q https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.zip && \
unzip -q google-cloud-sdk.zip -d /usr/lib && rm google-cloud-sdk.zip && \
/usr/lib/google-cloud-sdk/install.sh \
 --quiet \
 --path-update=true \
 --bash-completion=true \
 --additional-components kubectl alpha beta &> /dev/null

# Install vim plugins
COPY /configfiles/.vimrc $HOME/.vimrc
RUN \
vim -u NONE +'silent! source ~/.vimrc' +PlugInstall +qa! &> /dev/null

# Set the initial directory
WORKDIR $HOME/Code/src/github.com/ericsage

# Add and symlink user configuration files
COPY . $HOME/Code/src/github.com/ericsage/$REPONAME
RUN \
rm -f $HOME/.vimrc $HOME/.bashrc $HOME/.bash_profile && \
cd $PWD/$REPONAME && stow --target $HOME configfiles

# Set tmux as the starting process
CMD [ "/usr/bin/tmux", "-2", "new-session", "-s", "main" ]
