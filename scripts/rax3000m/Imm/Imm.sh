#!/bin/bash
#=================================================
# MZwrt script
#================================================= 


# 删除luci所在行
# sed -i '/luci/d' feeds.conf.default
# sed -i '/packages/d' feeds.conf.default
# sed -i '/small/d' feeds.conf.default

##添加自己的插件库
# echo 'src-git coolsnowwolf_luci https://github.com/coolsnowwolf/luci' >>feeds.conf.default
# echo 'src-git coolsnowwolf_packages https://github.com/coolsnowwolf/packages' >>feeds.conf.default
echo -e "\nsrc-git extraipk https://github.com/wwz09/RAX3000MIPK" >> feeds.conf.default