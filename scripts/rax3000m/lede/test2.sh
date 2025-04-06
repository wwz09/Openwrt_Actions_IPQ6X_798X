#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

./scripts/feeds clean

##配置IP
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

##
rm -rf ./feeds/extraipk/theme/luci-theme-argon-18.06
rm -rf ./feeds/extraipk/theme/luci-app-argon-config-18.06
rm -rf ./feeds/extraipk/theme/luci-theme-design
rm -rf ./feeds/extraipk/theme/luci-theme-edge
rm -rf ./feeds/extraipk/theme/luci-theme-ifit
rm -rf ./feeds/extraipk/theme/luci-theme-opentopd
rm -rf ./feeds/extraipk/theme/luci-theme-neobird

rm -rf ./package/feeds/extraipk/luci-theme-argon-18.06
rm -rf ./package/feeds/extraipk/luci-app-argon-config-18.06
rm -rf ./package/feeds/extraipk/theme/luci-theme-design
rm -rf ./package/feeds/extraipk/theme/luci-theme-edge
rm -rf ./package/feeds/extraipk/theme/luci-theme-ifit
rm -rf ./package/feeds/extraipk/theme/luci-theme-opentopd
rm -rf ./package/feeds/extraipk/theme/luci-theme-neobird



# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}


## 添加额外插件

git_sparse_clone main https://github.com/Lienol/openwrt-package  luci-app-control-webrestriction 
# git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-parentcontrol
git_sparse_clone main https://github.com/Lienol/openwrt-package luci-app-timecontrol
git_sparse_clone main https://github.com/sirpdboy/sirpdboy-package luci-app-control-timewol
git_sparse_clone main https://github.com/ksong008/sirpdboy-package luci-app-control-weburl
# git_sparse_clone main https://github.com/linkease/nas-packages-luci luci
# git_sparse_clone main https://github.com/wwz09/RAX3000MIPK luci-app-parentcontrol
# git clone  https://github.com/sirpdboy/luci-app-parentcontrol.git feeds/luci/applications/luci-app-parentcontrol
# git clone  https://github.com/firkerword/luci-app-parentcontrol.git ./package/luci-app-parentcontrol

##取消bootstrap为默认主题
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
sed -i 's/luci-theme-bootstrap/luci-theme-argone/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argone/g' feeds/luci/collections/luci-nginx/Makefile

# 设置ttyd免帐号登录
sed -i 's/\/bin\/login/\/bin\/login -f root/' feeds/packages/utils/ttyd/files/ttyd.config

# 修改 Wi-Fi 国家代码为中国
# sed -i 's/set wireless.radio[0-9]*.country=.*/set wireless.radio$devidx.country=CN/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

#修改默认无线名称
# sed -i 's/LEDE/TEST520-2.4G/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

#修改无线加密及密码
# sed -i 's/encryption=none/encryption=psk-mixed+ccmp\n            set wireless.default_radio${devidx}.key=abc5124937,\n/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 加入 2.4G 和 5G 名称及密码配置
sed -i '/set wireless.radio0/,/option disabled/d' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i '/set wireless.radio1/,/option disabled/d' package/kernel/mac80211/files/lib/wifi/mac80211.sh

cat >> package/kernel/mac80211/files/lib/wifi/mac80211.sh << EOF
  set wireless.radio0=wifi-device
  set wireless.radio0.type=mac80211
  set wireless.radio0.path='platform/18000000.wmac'
  set wireless.radio0.channel=11
  set wireless.radio0.htmode=HT40
  set wireless.radio0.country=CN
  set wireless.radio0.disabled=0
  set wireless.default_radio0=wifi-iface
  set wireless.default_radio0.device=radio0
  set wireless.default_radio0.network=lan
  set wireless.default_radio0.mode=ap
  set wireless.default_radio0.ssid=YM520-2.4G
  set wireless.default_radio0.encryption=psk-mixed+ccmp
  set wireless.default_radio0.key=abc5124937，

  set wireless.radio1=wifi-device
  set wireless.radio1.type=mac80211
  set wireless.radio1.path='platform/18000000.wmac+1'
  set wireless.radio1.channel=36
  set wireless.radio1.htmode=VHT80
  set wireless.radio1.country=CN
  set wireless.radio1.disabled=0
  set wireless.default_radio1=wifi-iface
  set wireless.default_radio1.device=radio1
  set wireless.default_radio1.network=lan
  set wireless.default_radio1.mode=ap
  set wireless.default_radio1.ssid=YM520-5G
  set wireless.default_radio1.encryption=psk-mixed+ccmp
  set wireless.default_radio1.key=abc5124937，
EOF


##更改主机名
sed -i "s/hostname='.*'/hostname='RAX3000M'/g" package/base-files/files/bin/config_generate

# 加入OpenClash核心
# chmod -R a+x $GITHUB_WORKSPACE/scripts/rax3000m/Imm/preset-clash-core.sh
# $GITHUB_WORKSPACE/scripts/rax3000m/Imm/preset-clash-core.sh
