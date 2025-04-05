#!/bin/bash
#=================================================
# MZwrt script
#================================================= 


##添加自己的插件库
# echo -e "\nsrc-git extraipk https://github.com/wwz09/RAX3000MIPK" >> feeds.conf.default
# echo -e "\nsrc-git immo https://github.com/immortalwrt/luci.git;openwrt-21.02" >> feeds.conf.default
echo -e "\nsrc-git mzwrt_package https://github.com/mzwrt/mzwrt_package_Lite.git" >> feeds.conf.default
