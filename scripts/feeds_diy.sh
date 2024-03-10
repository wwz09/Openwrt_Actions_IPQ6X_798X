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

# Add a feed source
echo 'src-git openwrt_packages https://github.com/wwz09/openwrt-packages;master' >>feeds.conf.default
echo 'src-git openwrt_small https://github.com/wwz09/small;master' >>feeds.conf.default
echo 'src-git mosdns https://github.com/sbwml/luci-app-mosdns;v5' >>feeds.conf.default
#echo 'src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2' >>feeds.conf.default
#echo 'src-git adguardhome https://github.com/xiaoxiao29/luci-app-adguardhome;master' >>feeds.conf.default