#!/bin/bash
#=================================================
# MZwrt script
#=================================================             



##配置IP
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate


##取消bootstrap为默认主题
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-nginx/Makefile

##更改主机名
sed -i "s/hostname='.*'/hostname='RAX3000M'/g" package/base-files/files/bin/config_generate

##加入作者信息
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='wwz09-$(date +%Y%m%d)'/g"  package/base-files/files/etc/openwrt_release
sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION=' By Mz'/g" package/base-files/files/etc/openwrt_release
# cp -af feeds/extraipk/patch/diy/banner-MZwrt  package/base-files/files/etc/banner

# sed -i "2iuci set istore.istore.channel='MZ_wrt'" package/emortal/default-settings/files/99-default-settings
sed -i "2iuci set istore.istore.channel='wwz09'" package/emortal/default-settings/files/99-default-settings
sed -i "3iuci commit istore" package/emortal/default-settings/files/99-default-settings
sed -i.bak "s,mirrors.vsean.net/openwrt,mirrors.vsean.net/openwrt,g" package/emortal/default-settings/files/99-default-settings


##WiFi
sed -i "s/MT7981_AX3000_2.4G/YM520-2.4G/g" package/mtk/drivers/wifi-profile/files/mt7981/mt7981.dbdc.b0.dat
sed -i "s/MT7981_AX3000_5G/YM520-5G/g" package/mtk/drivers/wifi-profile/files/mt7981/mt7981.dbdc.b1.dat

##New WiFi
sed -i "s/ImmortalWrt-2.4G/YM520-2.4G/g" package/mtk/applications/mtwifi-cfg/files/mtwifi.sh
sed -i "s/ImmortalWrt-5G/YM520-5G/g" package/mtk/applications/mtwifi-cfg/files/mtwifi.sh

# 移除 openwrt feeds 自带的核心包
rm -rf feeds/packages/net/{xray-core,xray-plugin,v2ray-core,v2ray-plugin,v2ray-geodata,sing-box,hysteria,naiveproxy,shadowsocks-rust,tuic-client,microsocks,chinadns-ng,alist,dns2socks,dns2tcp,ipt2socks}
rm -rf feeds/luci/applications/{luci-app-passwall,luci-app-ssr-plus}
git clone https://github.com/sbwml/openwrt_helloworld package/helloworld

# 更新 golang 1.24 版本
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang

# 添加luci-app-alist源码
git clone https://github.com/sbwml/luci-app-alist package/alist

# 替换最新版brook
rm -rf feeds/packages/net/brook
git clone -b main https://github.com/xiaorouji/openwrt-passwall-packages.git
cp -r openwrt-passwall-packages/brook feeds/packages/net
rm -rf openwrt-passwall-packages

# 克隆 coolsnowwolf 的 luci 和 packages 仓库
git clone https://github.com/coolsnowwolf/luci.git coolsnowwolf-luci
git clone https://github.com/coolsnowwolf/packages.git coolsnowwolf-packages

# 替换luci-app-zerotier和luci-app-frpc
rm -rf feeds/luci/applications/{luci-app-zerotier,luci-app-frpc}
cp -r coolsnowwolf-luci/applications/{luci-app-zerotier,luci-app-frpc} feeds/luci/applications
cp coolsnowwolf-luci/luci.mk package/
sed -i 's|include ../../luci\.mk|include ../../../../package/luci.mk|' feeds/luci/applications/luci-app-zerotier/Makefile
sed -i 's|include ../../luci\.mk|include ../../../../package/luci.mk|' feeds/luci/applications/luci-app-frpc/Makefile

# 替换zerotier、frp 和kcptun
rm -rf feeds/packages/net/{zerotier,frp,kcptun,haproxy}
cp -r coolsnowwolf-packages/net/{zerotier,frp,kcptun,haproxy} feeds/packages/net

# 修改frp版本为官网最新v0.61.2 https://github.com/fatedier/frp
rm -rf feeds/packages/net/frp
wget https://github.com/coolsnowwolf/packages/archive/0f7be9fc93d68986c179829d8199824d3183eb60.zip -O OldPackages.zip
unzip OldPackages.zip
cp -r packages-0f7be9fc93d68986c179829d8199824d3183eb60/net/frp feeds/packages/net/
rm -rf OldPackages.zip packages-0f7be9fc93d68986c179829d8199824d3183eb60s
sed -i 's/PKG_VERSION:=0.53.2/PKG_VERSION:=0.61.2/' feeds/packages/net/frp/Makefile
sed -i 's/PKG_HASH:=ff2a4f04e7732bc77730304e48f97fdd062be2b142ae34c518ab9b9d7a3b32ec/PKG_HASH:=19600d944e05f7ed95bac53c18cbae6ce7eff859c62b434b0c315ca72acb1d3c/' feeds/packages/net/frp/Makefile

# 删除克隆的 coolsnowwolf-luci 和 coolsnowwolf-packages 仓库
rm -rf coolsnowwolf-luci
rm -rf coolsnowwolf-packages

git clone https://github.com/coolsnowwolf/lede.git coolsnowwolf-lede
cp -r coolsnowwolf-lede/package/lean/upx package/
rm -rf coolsnowwolf-lede


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

git_sparse_clone main https://github.com/mzwrt/mzwrt_package_Lite  luci-app-ikoolproxy luci-app-store luci-app-quickstart luci-app-openclash luci-app-easymesh luci-app-ddnsto luci-app-vlmcsd luci-theme-argon luci-theme-design luci-app-design-config luci-app-argon-config luci-app-lucky luci-app-smartdns luci-lib-xterm luci-lib-taskd luci-lib-iform

git_sparse_clone main https://github.com/mzwrt/mzwrt_package_Lite  quickstart ucl upx taskd ddnsto filebrowser lua-maxminddb lucky smartdns upx-static docker

# 新建new目录
mkdir -p package/new

## 加入 luci-app-socat
rm -rf feeds/packages/net/socat
git clone https://github.com/immortalwrt/packages package/new/immortalwrt-packages
mv package/new/immortalwrt-packages/net/socat package/new/socat
rm -rf package/new/immortalwrt-packages
rm -rf feeds/luci/applications/luci-app-socat
git clone --depth 1 https://github.com/chenmozhijin/luci-app-socat package/new/chenmozhijin-socat
mv -n package/new/chenmozhijin-socat/luci-app-socat package/new/
rm -rf package/new/chenmozhijin-socat

## adguardhome
#git clone -b patch-1 https://github.com/kiddin9/openwrt-adguardhome package/new/openwrt-adguardhome
#mv package/new/openwrt-adguardhome/*adguardhome package/new/
#rm -rf package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml
#cp -rf $GITHUB_WORKSPACE/patches/AdGuardHome/AdGuardHome_template.yaml #package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml
#rm -rf package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/links.txt
#cp -rf $GITHUB_WORKSPACE/patches/AdGuardHome/links.txt package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/links.txt
# sed -i 's/+adguardhome/+PACKAGE_$(PKG_NAME)_INCLUDE_binary:adguardhome/g' package/new/luci-app-adguardhome/Makefile
#rm -rf package/new/openwrt-adguardhome

# 加入OpenClash核心
chmod -R a+x $GITHUB_WORKSPACE/scripts/rax3000m/Imm/preset-clash-core.sh
$GITHUB_WORKSPACE/scripts/rax3000m/Imm/preset-clash-core.sh


