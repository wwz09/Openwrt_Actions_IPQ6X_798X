#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default
# 修改默认IP
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

#　修改主机名
sed -i "s/hostname='OpenWrt'/hostname='QihooV6'/g" package/base-files/files/bin/config_generate

# Add a feed source
echo 'src-git openwrt_packages https://github.com/wwz09/openwrt-packages;master' >>feeds.conf.default
echo 'src-git openwrt_small https://github.com/wwz09/small;master' >>feeds.conf.default
echo 'src-git mosdns https://github.com/sbwml/luci-app-mosdns;v5' >>feeds.conf.default
#echo 'src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2' >>feeds.conf.default
#echo 'src-git adguardhome https://github.com/xiaoxiao29/luci-app-adguardhome;master' >>feeds.conf.default

# 移除要替换的包
#rm -rf feeds/packages/net/mosdns
#rm -rf feeds/packages/net/msd_lite
#rm -rf feeds/packages/net/smartdns
# rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/themes/luci-theme-netgear
#rm -rf feeds/luci/applications/luci-app-mosdns
#rm -rf feeds/luci/applications/luci-app-netdata
rm -rf feeds/luci/applications/luci-app-serverchan

# 修改插件名字
# sed -i 's/"挂载点"/"磁盘挂载"/g' `grep "挂载点" -rl ./`
# sed -i 's/"Argon 主题设置"/"主题设置"/g' `grep "Argon 主题设置" -rl ./`
# sed -i 's/"解锁网易云灰色歌曲"/"音乐解锁"/g' `grep "解锁网易云灰色歌曲" -rl ./`
# sed -i 's/"状态"/"系统状态"/g' `grep "状态" -rl ./`
# sed -i 's/"接口"/"有线设置"/g' `grep "接口" -rl ./`
# sed -i 's/"无线"/"无线设置"/g' `grep "无线" -rl ./`
# sed -i 's/"File Transfer"/"文件上传"/g' `grep "File Transfer" -rl ./`
# sed -i 's/"iKoolProxy滤广告"/"广告拦截"/g' `grep "iKoolProxy滤广告" -rl ./`
# sed -i 's/"终端"/"超级终端"/g' `grep "终端" -rl ./`
# sed -i 's/"Frps"/"Frps内网穿透"/g' `grep "Frps" -rl ./`
# sed -i 's/"系统"/"系统设置"/g' `grep "系统" -rl ./`
# sed -i 's/"Hello World"/"世界你好"/g' `grep "Hello World" -rl ./`
# sed -i 's/"广告屏蔽大师 Plus+"/"广告屏蔽"/g' `grep "广告屏蔽大师 Plus+" -rl ./`
# sed -i 's/"DDNSTO 远程控制"/"远程控制"/g' `grep "DDNSTO 远程控制" -rl ./`
# sed -i 's/"网络存储"/"存储设置"/g' `grep "网络存储" -rl ./`
# sed -i 's/"重启"/"系统重启"/g' `grep "重启" -rl ./`
# sed -i 's/"服务"/"应用服务"/g' `grep "服务" -rl ./`
# sed -i 's/"CPU 性能优化调节"/"CPU 设置"/g' `grep "CPU 性能优化调节" -rl ./`
# sed -i 's/"网络"/"网络设置"/g' `grep "网络" -rl ./`
# sed -i 's/"Control"/"家长控制"/g' `grep "Control" -rl ./`
# sed -i 's/"wolplus"/"网络重启"/g' `grep "wolplus" -rl ./`
# sed -i 's/"Parent Control"/"家长控制"/g' `grep "parentcontrol" -rl ./`

# 添加额外插件
git clone --depth=1 -b openwrt-18.06 https://github.com/tty228/luci-app-wechatpush package/luci-app-serverchan
git clone --depth=1 https://github.com/ilxp/luci-app-ikoolproxy package/luci-app-ikoolproxy
# svn export https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
# svn export https://github.com/haiibo/packages/trunk/luci-app-vssr package/luci-app-vssr

# 添加主题
git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
# git clone --depth=1 https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
# svn export https://github.com/haiibo/packages/trunk/luci-theme-atmaterial package/luci-theme-atmaterial

# 取消主题默认设置
# find package/luci-theme-*/* -type f -name '*luci-theme-*' -print -exec sed -i '/set luci.main.mediaurlbase/d' {} \;