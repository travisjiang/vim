#!/bin/bash
echo "安装将花费一定时间，请耐心等待直到安装完成^_^"
if which apt-get >/dev/null; then
	sudo apt-get install -y vim vim-gnome ctags xclip astyle python-setuptools python-dev git cscope
elif which yum >/dev/null; then
	sudo yum install -y gcc vim git ctags xclip astyle python-setuptools python-devel cscope
fi

##Add HomeBrew support on  Mac OS
if which brew >/dev/null;then
    echo "You are using HomeBrew tool"
    brew install vim ctags git astyle cscope
fi

sudo ln -s /usr/bin/ctags /usr/local/bin/ctags
sudo ln -s /usr/bin/cscope /usr/local/bin/cscope

mv -f ~/.vim_runtime ~/.vim_runtime_old
mv -f ~/.vimrc ~/.vimrc_old

git clone https://github.com/Jiangty08/vim.git ~/.vim_runtime
cd ~/.vim_runtime

echo 'set runtimepath+=~/.vim_runtime

source ~/.vim_runtime/vimrcs/basic.vim
source ~/.vim_runtime/vimrcs/filetypes.vim
source ~/.vim_runtime/vimrcs/plugins_config.vim
source ~/.vim_runtime/vimrcs/extended.vim

try
source ~/.vim_runtime/my_configs.vim
catch
endtry' > ~/.vimrc

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim_runtime/bundle/Vundle.vim
echo "正在努力为您安装bundle程序" > tmp
echo "安装完毕将自动退出" >> tmp
echo "请耐心等待" >> tmp
vim tmp -c "PluginInstall" -c "q" -c "q"
rm tmp
echo "安装完成"
