#!/bin/bash


CFG_FILE="./package/base-files/files/bin/config_generate"
#修改默认IP地址
sed -i "s/192\.168\.1\.[0-9]*/192.168.2.1/g" $CFG_FILE
#修改默认主机名
sed -i "s/hostname='.*'/hostname='Qihoo360V6'/g" $CFG_FILE

#wifi设置
WIFI_SH=$(find ./target/linux/{mediatek/filogic,qualcommax}/base-files/etc/uci-defaults/ -type f -name "*set-wireless.sh")
WIFI_UC="./package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc"
if [ -f "$WIFI_SH" ]; then
	#修改WIFI名称
	sed -i "s/BASE_SSID='.*'/BASE_SSID='YM520'/g" $WIFI_SH
	#修改WIFI密码
	sed -i "s/BASE_WORD='.*'/BASE_WORD='abc5124937,'/g" $WIFI_SH
elif [ -f "$WIFI_UC" ]; then
	#修改WIFI名称
	sed -i "s/ssid='.*'/ssid='YM520'/g" $WIFI_UC
	#修改WIFI密码
	sed -i "s/key='.*'/key='abc5124937,'/g" $WIFI_UC
	#修改WIFI地区
	sed -i "s/country='.*'/country='CN'/g" $WIFI_UC
	#修改WIFI加密
	sed -i "s/encryption='.*'/encryption='psk2+ccmp'/g" $WIFI_UC
fi

# 更改默认 Shell 为 zsh
# sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# TTYD 免登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# 移除要替换的包
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/net/msd_lite
rm -rf feeds/packages/net/smartdns
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/themes/luci-theme-netgear
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/luci/applications/luci-app-netdata
rm -rf feeds/luci/applications/luci-app-serverchan

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
git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome package/luci-app-adguardhome
git clone --depth=1 -b openwrt-18.06 https://github.com/tty228/luci-app-wechatpush package/luci-app-serverchan
git clone --depth=1 https://github.com/ilxp/luci-app-ikoolproxy package/luci-app-ikoolproxy
git clone --depth=1 https://github.com/esirplayground/luci-app-poweroff package/luci-app-poweroff
git clone --depth=1 https://github.com/destan19/OpenAppFilter package/OpenAppFilter
git clone --depth=1 https://github.com/Jason6111/luci-app-netdata package/luci-app-netdata
git_sparse_clone main https://github.com/Lienol/openwrt-package luci-app-filebrowser luci-app-ssr-mudb-server
git_sparse_clone openwrt-18.06 https://github.com/immortalwrt/luci applications/luci-app-eqos 
git_sparse_clone IMM https://github.com/wwz09/IPQ_package luci-app-control-timewol luci-app-control-webrestriction luci-app-control-weburl luci-app-timecontrol luci-app-socat luci-app-wolplus
git_sparse_clone mzwrt_package https://github.com/wwz09/IPQ_package luci-theme-argon luci-app-argon-config luci-app-quickstart quickstart ucl luci-app-ddnsto ddnsto luci-app-vlmcsd 
# git_sparse_clone master https://github.com/syb999/openwrt-19.07.1 package/network/services/msd_lite

# 科学上网插件
#git clone --depth=1 -b main https://github.com/fw876/helloworld package/luci-app-ssr-plus
#git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall
#git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/luci-app-passwall
#git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2 package/luci-app-passwall2
#git_sparse_clone master https://github.com/vernesong/OpenClash luci-app-openclash

# Themes
git clone --depth=1 -b 18.06 https://github.com/kiddin9/luci-theme-edge package/luci-theme-edge
# git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
# git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
# git clone --depth=1 https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
# git_sparse_clone main https://github.com/haiibo/packages luci-theme-atmaterial luci-theme-opentomcat luci-theme-netgear

# 更改 Argon 主题背景
# cp -f $GITHUB_WORKSPACE/images/bg1.jpg package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

# 晶晨宝盒
# git_sparse_clone main https://github.com/ophub/luci-app-amlogic luci-app-amlogic
# sed -i "s|firmware_repo.*|firmware_repo 'https://github.com/haiibo/OpenWrt'|g" package/luci-app-amlogic/root/etc/config/amlogic
# sed -i "s|kernel_path.*|kernel_path 'https://github.com/ophub/kernel'|g" package/luci-app-amlogic/root/etc/config/amlogic
# sed -i "s|ARMv8|ARMv8_PLUS|g" package/luci-app-amlogic/root/etc/config/amlogic

# SmartDNS
git clone --depth=1 -b lede https://github.com/pymumu/luci-app-smartdns package/luci-app-smartdns
git clone --depth=1 https://github.com/pymumu/openwrt-smartdns package/smartdns

# msd_lite
git clone --depth=1 https://github.com/ximiTech/luci-app-msd_lite package/luci-app-msd_lite
git clone --depth=1 https://github.com/ximiTech/msd_lite package/msd_lite

# MosDNS
git clone --depth=1 https://github.com/sbwml/luci-app-mosdns package/luci-app-mosdns

# Alist
# git clone --depth=1 https://github.com/sbwml/luci-app-alist package/luci-app-alist

# DDNS.to
git_sparse_clone main https://github.com/linkease/nas-packages-luci luci/luci-app-ddnsto
git_sparse_clone master https://github.com/linkease/nas-packages network/services/ddnsto

# iStore
git_sparse_clone main https://github.com/linkease/istore-ui app-store-ui
git_sparse_clone main https://github.com/linkease/istore luci

# 在线用户
git_sparse_clone main https://github.com/haiibo/packages luci-app-onliner
sed -i '$i uci set nlbwmon.@nlbwmon[0].refresh_interval=2s' package/lean/default-settings/files/zzz-default-settings
sed -i '$i uci commit nlbwmon' package/lean/default-settings/files/zzz-default-settings
chmod 755 package/luci-app-onliner/root/usr/share/onliner/setnlbw.sh

# x86 型号只显示 CPU 型号
sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}${hydrid}/g' package/lean/autocore/files/x86/autocore

# 修改本地时间格式
sed -i 's/os.date()/os.date("%a %Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/*/index.htm

# 修改版本为编译日期
date_version=$(date +"%y.%m.%d")
orig_version=$(cat "package/lean/default-settings/files/zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
sed -i "s/${orig_version}/R${date_version} by Haiibo/g" package/lean/default-settings/files/zzz-default-settings

# 修复 hostapd 报错
cp -f $GITHUB_WORKSPACE/scripts/360V6/LiBwrt/011-fix-mbo-modules-build.patch package/network/services/hostapd/patches/011-fix-mbo-modules-build.patch

# 修复 armv8 设备 xfsprogs 报错
sed -i 's/TARGET_CFLAGS.*/TARGET_CFLAGS += -DHAVE_MAP_SYNC -D_LARGEFILE64_SOURCE/g' feeds/packages/utils/xfsprogs/Makefile

# 修改 Makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/lang\/golang\/golang-package.mk/$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang-package.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHREPO/PKG_SOURCE_URL:=https:\/\/github.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload.github.com/g' {}

# 取消主题默认设置
# find package/luci-theme-*/* -type f -name '*luci-theme-*' -print -exec sed -i '/set luci.main.mediaurlbase/d' {} \;

#修改默认主题
sed -i "s/luci-theme-bootstrap/luci-theme-argon/g" $(find ./feeds/luci/collections/ -type f -name "Makefile")

# 调整 V2ray服务器 到 VPN 菜单
# sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/controller/*.lua
# sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/model/cbi/v2ray_server/*.lua
# sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/view/v2ray_server/*.htm

# 加入OpenClash核心
chmod -R a+x $GITHUB_WORKSPACE/Scripts/360V6/LiBwrt/preset-clash-core.sh
$GITHUB_WORKSPACE/Scripts/360V6/LiBwrt/preset-clash-core.sh

./scripts/feeds update -a
./scripts/feeds install -a
