#!/bin/bash
# Dumps the dotfile paths make exports, for eyeballing `make env`. The variables come from
# the environment, so an empty line means that name is not set in make/envfile.
echo "${ZSHRCPATH}"
echo "${ZSHRCBACKUPPATH}"
echo "${BASHRCPATH}"
echo "${BASHRCBACKUPPATH}"
echo "${TMUXCONFPATH}"
echo "${TMUXCONFBACKUPPATH}"
echo "${GITCONFIGPATH}"
echo "${GITCONFIGBACKUPPATH}"
echo "${VIMRCPATH}"
echo "${VIMRCBACKUPPATH}"
echo "${INITVIMPATH}"
echo "${INITVIMBACKUPPATH}"
