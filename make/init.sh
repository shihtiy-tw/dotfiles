mkdir -p "$HOME"/.config/nvim/

# tmux support .config
# https://unix.stackexchange.com/questions/644819/is-it-possible-to-move-tmux-conf-to-config-folder
mkdir -p "$HOME"/.config/tmux/

if [ -e "$HOME"/.zshrc ]; then \
  mv "$HOME"/.zshrc "$HOME"/.zshrc.backup; \
fi
#if [ -e ${HOME}/.bashrc ]; then \
#	mv ${HOME}/.bashrc ${HOME}/.bash.backup; \
#fi
if [ -e "$HOME"/.tmux.conf ]; then \
  mv "$HOME"/.tmux.conf "$HOME"/.tmux.conf.backup; \
fi
if [ -e "$HOME"/.gitconfig ]; then \
  mv "$HOME"/.gitconfig "$HOME"/.gitconfig.backup; \
fi
if [ -e "$HOME"/.config/nvim/init.vim ]; then \
  mv "$HOME"/.config/nvim/init.vim "$HOME"/.config/nvim/init.vim.backup; \
fi

#ln -sf ${HOME}/dotfiles/zsh/ieni.zsh-theme ${HOME}/.oh-my-zsh/custom/themes/ieni.zsh-theme
#ln -sf ${HOME}/dotfiles/bash/themes/fish ${HOME}/.bash_it/custom/themes/fish
#ln -sf ${HOME}/dotfiles/bashrc ${HOME}/.bashrc
#ln -sf ${HOME}/dotfiles/bashrc ${HOME}/.bash_profile
ln -sf "$HOME"/dotfiles/zsh/zshrc "$HOME"/.zshrc
ln -sf "$HOME"/dotfiles/tmux/tmux.conf "$HOME"/.config/tmux/tmux.conf
# ln -sf "$HOME"/dotfiles/tmux/themes "$HOME"/.tmux/themes
ln -sf "$HOME"/dotfiles/git/gitconfig "$HOME"/.gitconfig
ln -sf "$HOME"/dotfiles/vim/vimrc "$HOME"/.vimrc
ln -sf "$HOME"/dotfiles/vim/editorconfig "$HOME"/.editorconfig
#ln -sf ${HOME}/dotfiles/zsh/antigenrc ${HOME}/.antigenrc
ln -sf "$HOME"/dotfiles/nvim/coc-settings.json "$HOME"/.config/nvim/coc-settings.json
#ln -sf ${HOME}/dotfiles/nvim/init.vim ${HOME}/.config/nvim/init.vim
ln -sf "$HOME"/dotfiles/nvim/init.lua "$HOME"/.config/nvim/init.lua
ln -sf "$HOME"/dotfiles/nvim/lua "$HOME"/.config/nvim/lua
ln -sf "$HOME"/dotfiles/aws/config "$HOME"/.aws/config
ln -sf "$HOME"/dotfiles/kitty/kitty.conf ~/.config/kitty/kitty.conf
ln -sf "$HOME"/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme "$HOME"/.oh-my-zsh/custom/themes/spaceship.zsh-theme

# ghostty
$ mkdir ~/.config/ghostty
$ ln -s ~/dotfiles/ghostty/ghostty.conf ~/.config/ghostty/config

# neovim
#nvim -c "PlugInstall"
#nvim -c "call coc#util#install()"
#nvim -c "CocInstall coc-dictionary"
#nvim -c "CocInstall coc-json coc-css coc-python coc-yaml coc-tabnine"
#nvim -c "CocInstall coc-python coc-yaml coc-tabnine"

echo "\ndone\n"
