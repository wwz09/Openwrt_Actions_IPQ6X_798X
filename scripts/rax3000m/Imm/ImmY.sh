#!/bin/bash
#=================================================
# File name: preset-clash-core.sh
# Usage: <preset-clash-core.sh $platform> | example: <preset-clash-core.sh armv8>
# System Required: Linux
# Version: 1.0
# Lisence: MIT
# Author: SuLingGG
# Blog: https://mlapp.cn
#=================================================
##配置IP
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

##更改主机名
sed -i "s/hostname='ImmortalWrt'/hostname='RAX3000M'/g" package/base-files/files/bin/config_generate

#修改wifi名
# sed -i "s/ImmortalWrt/YM520-2.4G/g" package/network/config/wifi-scripts/files/lib/wifi/mac80211.sh
# sed -i "s/ssid=ImmortalWrt/ssid=YM520-2.4G/g" ./package/network/config/wifi-scripts/files/lib/wifi/mac80211.sh
sed -i 's/ssid=ImmortalWrt/ssid=YM520-2.4G' package/network/config/wifi-scripts/files/lib/wifi/mac80211.sh
# sed -i "s/encryption=none/encryption=psk-mixed+ccmp\n            set wireless.default_radio${devidx}.key=abc5124937,\n/g" ./package/network/config/wifi-scripts/files/lib/wifi/mac80211.sh

# 修改默认wifi密码key为password
sed -i "s/encryption=none/encryption=psk-mixed+ccmp/g" ./package/network/config/wifi-scripts/files/lib/wifi/mac80211.sh
sed -i '/set wireless.default_radio${devidx}.encryption=psk-mixed+ccmp/a\set wireless.default_radio${devidx}.key=abc5124937,' ./package/network/config/wifi-scripts/files/lib/wifi/mac80211.sh






# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# 添加额外插件

git_sparse_clone main https://github.com/Lienol/openwrt-package luci-app-control-timewol luci-app-control-webrestriction luci-app-control-weburl luci-app-timecontrol
# git_sparse_clone master https://github.com/wwz09/RAX3000MIPK helloworld

# 预置openclash内核
# mkdir -p files/etc/openclash/core


# dev内核
# CLASH_DEV_URL="https://github.com/vernesong/OpenClash/raw/core/dev/dev/clash-linux-arm64.tar.gz"
# premium内核
# CLASH_TUN_URL="https://github.com/vernesong/OpenClash/raw/core/dev/premium/clash-linux-arm64-2023.08.17-13-gdcc8d87.gz"
# Meta内核版本
# CLASH_META_URL="https://github.com/vernesong/OpenClash/raw/core/dev/meta/clash-linux-arm64.tar.gz"

#wget -qO- $CLASH_DEV_URL | gunzip -c > files/etc/openclash/core/clash
#wget -qO- $CLASH_TUN_URL | gunzip -c > files/etc/openclash/core/clash_tun
#wget -qO- $CLASH_META_URL | gunzip -c > files/etc/openclash/core/clash_meta
# 给内核权限
#chmod +x files/etc/openclash/core/clash*

# meta 要GeoIP.dat 和 GeoSite.dat
# GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
# GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
# wget -qO- $GEOIP_URL > files/etc/openclash/GeoIP.dat
# wget -qO- $GEOSITE_URL > files/etc/openclash/GeoSite.dat

# Country.mmdb
# COUNTRY_LITE_URL=https://raw.githubusercontent.com/alecthw/mmdb_china_ip_list/release/lite/Country.mmdb
# COUNTRY_FULL_URL=https://raw.githubusercontent.com/alecthw/mmdb_china_ip_list/release/Country.mmdb
# wget -qO- $COUNTRY_LITE_URL > files/etc/openclash/Country.mmdb
# wget -qO- $COUNTRY_FULL_URL > files/etc/openclash/Country.mmdb