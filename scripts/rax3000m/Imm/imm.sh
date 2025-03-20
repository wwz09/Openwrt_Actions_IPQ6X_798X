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

## golang编译环境
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang

# 加入OpenClash核心
chmod -R a+x $GITHUB_WORKSPACE/scripts/rax3000m/Imm/preset-clash-core.sh
$GITHUB_WORKSPACE/scripts/rax3000m/Imm/preset-clash-core.sh


