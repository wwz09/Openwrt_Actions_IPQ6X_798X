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
sed -i 's/192.168.1.1/192.168.3.1/g' package/base-files/files/bin/config_generate

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


# rm -rf ./feeds/mzwrt_package/luci-app-shadowsocks
# rm -rf ./feeds/mzwrt_package/luci-app-bypass
# rm -rf ./feeds/mzwrt_package/luci-app-bandwidthd
# rm -rf ./feeds/mzwrt_package/luci-app-ssr-plus
# rm -rf ./feeds/mzwrt_package/luci-app-gowebdav


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

git_sparse_clone main https://github.com/wwz09/mzwrt_package_Lite  luci-app-quickstart luci-app-store luci-app-adguardhome luci-app-control-timewol luci-app-control-webrestriction luci-app-control-weburl luci-app-filebrowser luci-app-ikoolproxy luci-app-linkease luci-app-socat luci-app-vlmcsd luci-app-smartdns luci-theme-design luci-app-eqos 
git_sparse_clone main https://github.com/wwz09/mzwrt_package_Lite  quickstart adguardhome filebrowser linkease smartdns lua-maxminddb ucl upx linkmount luci-lib-taskd taskd luci-lib-xterm
# git_sparse_clone main https://github.com/Lienol/openwrt-package luci-app-parentcontrol 
# git_sparse_clone main https://github.com/linkease/nas-packages-luci luci
# git_sparse_clone main https://github.com/chenmozhijin/luci-app-socat luci-app-socat
# git clone  https://github.com/sirpdboy/luci-app-parentcontrol.git feeds/luci/applications/luci-app-parentcontrol
git clone --depth=1 -b lede https://github.com/pymumu/luci-app-smartdns package/luci-app-smartdns
git clone --depth=1 https://github.com/pymumu/openwrt-smartdns package/smartdns
git_sparse_clone main https://github.com/linkease/nas-packages-luci luci/luci-app-ddnsto
git_sparse_clone master https://github.com/linkease/nas-packages network/services/ddnsto
# git_sparse_clone main https://github.com/linkease/istore-ui app-store-ui
# git_sparse_clone main https://github.com/linkease/istore luci

##取消bootstrap为默认主题
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
sed -i 's/luci-theme-bootstrap/luci-theme-argone/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argone/g' feeds/luci/collections/luci-nginx/Makefile

# 设置ttyd免帐号登录
sed -i 's/\/bin\/login/\/bin\/login -f root/' feeds/packages/utils/ttyd/files/ttyd.config

# 修复 hostapd 报错
cp -f $GITHUB_WORKSPACE/scripts/qihoo360v6/011-fix-mbo-modules-build.patch package/network/services/hostapd/patches/011-fix-mbo-modules-build.patch

# 设置 root 密码
# sed -i 's/root:::0:99999:7:::/root:$1$KejhO3Om$wf8JAUSNHj0y2RiewTObe1:20185:0:99999:7:::/g' package/lean/default-settings/files/zzz-default-settings
sed -i 's/root:::0:99999:7:::/root:$1$KejhO3Om$wf8JAUSNHj0y2RiewTObe1:20185:0:99999:7:::/g' package/base-files/files/etc/shadow

# 修改 Wi-Fi 国家代码为中国
# sed -i 's/set wireless.radio[0-9]*.country=.*/set wireless.radio$devidx.country=CN/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

#修改默认无线名称及密码
# sed -i 's/libwrt/BM520/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i 's/BASE_SSID='LiBwrt'/BASE_SSID='BM520'/g' target/linux/qualcommax/base-files/etc/uci-defaults/990_set-wireless.sh
sed -i 's/BASE_WORD='12345678'/BASE_WORD='abc5124937,'/g' target/linux/qualcommax/base-files/etc/uci-defaults/990_set-wireless.sh

##更改主机名
sed -i "s/hostname='.*'/hostname='Qihoo360V6'/g" package/base-files/files/bin/config_generate

# 修改插件名字
#sed -i 's/"Socat"/"端口转发"/g' `egrep "Socat" -rl ./`
#sed -i 's/"终端"/"TTYD"/g' `egrep "终端" -rl ./`
#sed -i 's/"网络存储"/"NAS"/g' `egrep "网络存储" -rl ./`
#sed -i 's/"实时流量监测"/"流量"/g' `egrep "实时流量监测" -rl ./`
#sed -i 's/"KMS 服务器"/"KMS激活"/g' `egrep "KMS 服务器" -rl ./`
#sed -i 's/"USB 打印服务器"/"打印服务"/g' `egrep "USB 打印服务器" -rl ./`
#sed -i 's/"Web 管理"/"Web管理"/g' `egrep "Web 管理" -rl ./`
#sed -i 's/"管理权"/"改密码"/g' `egrep "管理权" -rl ./`
#sed -i 's/"带宽监控"/"监控"/g' `egrep "带宽监控" -rl ./`

./scripts/feeds update -a
./scripts/feeds install -a