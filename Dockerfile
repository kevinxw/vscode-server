FROM lscr.io/linuxserver/code-server:latest

SHELL ["/bin/bash", "-c"]
# Install specified docker mods directly.
RUN \
  DOCKER_MODS='linuxserver/mods:universal-package-install|\
  linuxserver/mods:code-server-extension-arguments|\
  ' bash /docker-mods && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
  gnupg curl wget apt-transport-https ca-certificates build-essential lsb-core \
  gcc g++ make cmake software-properties-common \
  clang ninja-build pkg-config libgtk-3-dev liblzma-dev && \
  mkdir -p /etc/apt/keyrings && chmod -R 0755 /etc/apt/keyrings && \
  LC_ALL=C.UTF-8 add-apt-repository --yes ppa:ondrej/php && \
  curl -fsSL "https://download.docker.com/linux/ubuntu/gpg" | gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
  curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /etc/apt/keyrings/yarnkey.gpg >/dev/null && \
  echo "deb [signed-by=/etc/apt/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list >/dev/null && \
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash && \
  curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - && \
  apt-get update && \
  echo "Installing nvm" && \
  export NVM_DIR="${HOME}/.nvm" && \
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
  nvm install --lts && \
  nvm install node && \
  npm install -g npm@latest && \
  npm install -g @bazel/bazelisk && \
  DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && \
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
  python3 python3-pip python3-dev python3-setuptools python3-wheel \
  golang-go \
  git \
  unzip \
  shellcheck \
  openjdk-11-jdk \
  iptables \
  openssh-client \
  php8.0 \
  nodejs yarn \
  docker-ce docker-ce-cli containerd.io docker-compose-plugin && \
  go install golang.org/x/tools/gopls@latest && \
  go install mvdan.cc/gofumpt@latest && \
  go install github.com/bazelbuild/buildtools/buildifier@latest && \
  go install github.com/bazelbuild/buildtools/buildozer@latest && \
  echo "Installing sshuttle" && \
  pip3 install sshuttle && \
  echo "Installing flutter" && \
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 /flutter && \
  ln -s /flutter/bin/flutter /usr/bin/flutter && \
  flutter channel stable && \
  flutter upgrade && \
  flutter doctor && \
  flutter config --enable-web && \
  flutter config --no-analytics && \
  flutter precache && \
  apt-get clean && \
  rm -rf \
  /tmp/* \
  /var/lib/apt/lists/* \
  /var/tmp/* \
  /flutter/.git
