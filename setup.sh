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


function update_vim() {
	vim_version=$(vim --version | head -1 | grep -o '[0-9]\.[0-9]')

	if [ ! $(echo "$vim_version >= 7.4" | bc -l) ] ; then
		 echo "vim version must be at least 7.4, now auto install from src"
		sudo apt-get install -y libncurses5-dev libgnome2-dev libgnomeui-dev \
		libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
		libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
		python3-dev ruby-dev lua5.1 lua5.1-dev git
		sudo apt-get -y remove vim vim-runtime gvim
		sudo apt-get -y remove vim-tiny vim-common vim-gui-common vim-nox
		cd ~
		git clone https://github.com/vim/vim.git vim_src
		cd vim_src
		./configure --with-features=huge \
					--enable-multibyte \
					--enable-rubyinterp \
					--enable-pythoninterp \
					--with-python-config-dir=/usr/lib/python2.7/config \
					--enable-python3interp \
					--with-python3-config-dir=/usr/lib/python3.5/config \
					--enable-perlinterp \
					--enable-luainterp \
					--enable-gui=gtk2 --enable-cscope --prefix=/usr
		make VIMRUNTIMEDIR=/usr/share/vim/vim74
		sudo apt-get install -y checkinstall
		sudo checkinstall
		rm vim_src -rf
		sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
		sudo update-alternatives --set editor /usr/bin/vim
		sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
		sudo update-alternatives --set vi /usr/bin/vim
	else
		 echo "vim version is > 7.4, OK"
	fi
}
function config_ycm () {
	update_vim
	sudo apt-get install build-essential cmake
	sudo apt-get install python-dev python3-dev
	cd ~/.vim_runtime/bundle/YouCompleteMe
	./install.py --clang-completer
}
