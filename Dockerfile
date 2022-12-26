FROM lscr.io/linuxserver/code-server:latest

# Install specified docker mods directly.
RUN \
  DOCKER_MODS='linuxserver/mods:universal-package-install|\
  linuxserver/mods:universal-docker|\
  linuxserver/mods:code-server-shellcheck|\
  linuxserver/mods:code-server-golang|\
  linuxserver/mods:code-server-python3|\
  linuxserver/mods:code-server-flutter|\
  linuxserver/mods:code-server-nvm|\
  linuxserver/mods:code-server-npmglobal|\
  linuxserver/mods:code-server-nodejs|\
  linuxserver/mods:code-server-java11|\
  linuxserver/mods:code-server-php8\
  linuxserver/mods:code-server-extension-arguments\
  ' bash /docker-mods ; \
  mkdir -p /config/.config && \
  sudo chown -R abc:abc /config
USER abc

SHELL ["/bin/bash", "-c"]
RUN \
  EXTENSIONS_GALLERY='{"serviceUrl": "https://extensions.coder.com/api"}' && \
  _VSCODE_EXTENSION_IDS=( \
  'eamodio.gitlens' \
  'Shan.code-settings-sync' \
  'ms-azuretools.vscode-docker' \
  'bierner.github-markdown-preview' \
  'dracula-theme.theme-dracula' \
  'thejustinwalsh.textproto-grammer' \
  'zhangciwu.swig-tpl' \
  'BazelBuild.vscode-bazel' \
  'xaver.clang-format' \
  'Dart-Code.dart-code' \
  'Dart-Code.flutter' \
  'ms-vscode.makefile-tools' \
  'brunnerh.insert-unicode' \
  'donjayamanne.githistory' \
  'golang.Go' \
  'DavidAnson.vscode-markdownlint' \
  'esbenp.prettier-vscode' \
  'ms-python.python' \
  'zxh404.vscode-proto3' \
  'njpwerner.autodocstring' \
  ) && \
  _INSTALL_EXTENSION="$(which install-extension)" && \
  # Use newly available abstraction if available (>= v4.0.x), else fallback to old method.
  if [ -x "${_INSTALL_EXTENSION}" ]; then \
  for ID in "${_VSCODE_EXTENSION_IDS[@]}"; do \
  bash ${_INSTALL_EXTENSION} ${ID} ;\
  done ; \
  fi

USER root
RUN ls -al /config