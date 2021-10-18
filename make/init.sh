mkdir -p ${HOME}/.config/nvim/

if [ -e ${HOME}/.zshrc ]; then \
  mv ${HOME}/.zshrc ${HOME}/.zshrc.backup; \
fi
#if [ -e ${HOME}/.bashrc ]; then \
#	mv ${HOME}/.bashrc ${HOME}/.bash.backup; \
#fi
if [ -e ${HOME}/.tmux.conf ]; then \
  mv ${HOME}/.tmux.conf ${HOME}/.tmux.conf.backup; \
fi
if [ -e ${HOME}/.gitconfig ]; then \
  mv ${HOME}/.gitconfig ${HOME}/.gitconfig.backup; \
fi
if [ -e ${HOME}/.config/nvim/init.vim ]; then \
  mv ${HOME}/.config/nvim/init.vim ${HOME}/.config/nvim/init.vim.backup; \
fi

ln -sf ${HOME}/dotfiles/zshrc ${HOME}/.zshrc
#ln -sf ${HOME}/dotfiles/zsh/ieni.zsh-theme ${HOME}/.oh-my-zsh/custom/themes/ieni.zsh-theme
#ln -sf ${HOME}/dotfiles/bash/themes/fish ${HOME}/.bash_it/custom/themes/fish
#ln -sf ${HOME}/dotfiles/bashrc ${HOME}/.bashrc
#ln -sf ${HOME}/dotfiles/bashrc ${HOME}/.bash_profile
ln -sf ${HOME}/dotfiles/tmux.conf ${HOME}/.tmux.conf
ln -sf ${HOME}/dotfiles/gitconfig ${HOME}/.gitconfig
ln -sf ${HOME}/dotfiles/vimrc ${HOME}/.vimrc
ln -sf ${HOME}/dotfiles/gitconfig ${HOME}/.gitconfig
ln -sf ${HOME}/dotfiles/vim/editorconfig ${HOME}/.editorconfig
ln -sf ${HOME}/dotfiles/zsh/antigenrc ${HOME}/.antigenrc
ln -sf ${HOME}/dotfiles/nvim/coc-settings.json ${HOME}/.config/nvim/coc-settings.json
ln -sf ${HOME}/dotfiles/zsh/spaceship-prompt/spaceship.zsh ${HOME}/.oh-my-zsh/custom/themes/spaceship.zsh-theme

# neovim
#nvim -c "PlugInstall"
#nvim -c "call coc#util#install()"
#nvim -c "CocInstall coc-dictionary"
#nvim -c "CocInstall coc-json coc-css coc-python coc-yaml coc-tabnine"
#nvim -c "CocInstall coc-python coc-yaml coc-tabnine"

@echo "\ndone\n"
