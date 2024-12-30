#!/bin/bash
#=================================================
# MZwrt script
#================================================= 


##添加自己的插件库
# echo 'src-git coolsnowwolf_luci https://github.com/coolsnowwolf/luci' >>feeds.conf.default
# echo 'src-git coolsnowwolf_packages https://github.com/coolsnowwolf/packages' >>feeds.conf.default
#echo -e "\nsrc-git extraipk https://github.com/wwz09/RAX3000MIPK" >> feeds.conf.default
# echo -e "\nsrc-git extraipk https://github.com/mzwrt/extra_ipk" >> feeds.conf.default
sed -i '$a src-git 281677160 https://github.com/281677160/openwrt-package' feeds.conf.default
sed -i '$a src-git haiibo https://github.com/haiibo/openwrt-packages' feeds.conf.default
