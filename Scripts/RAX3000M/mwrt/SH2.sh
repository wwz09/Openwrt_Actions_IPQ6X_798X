#!/bin/bash
#=================================================
# MZwrt script
#=================================================             



##配置IP
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate



#修改默认主题
sed -i "s/luci-theme-bootstrap/luci-theme-argon/g" $(find ./feeds/luci/collections/ -type f -name "Makefile")

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


#WiFi相关设置1
sed -i "s/MT7981_AX3000_2.4G/YM520-2.4G/g" package/mtk/drivers/wifi-profile/files/mt7981/mt7981.dbdc.b0.dat
sed -i "s/12345678/abc5124937,/g" package/mtk/drivers/wifi-profile/files/mt7981/mt7981.dbdc.b0.dat
sed -i "s/MT7981_AX3000_5G/YM520-5G/g" package/mtk/drivers/wifi-profile/files/mt7981/mt7981.dbdc.b1.dat
sed -i "s/12345678/abc5124937,/g" package/mtk/drivers/wifi-profile/files/mt7981/mt7981.dbdc.b1.dat

#WiFi相关设置2
sed -i "s/ImmortalWrt-2.4G/YM520-2.4G/g" package/mtk/applications/mtwifi-cfg/files/mtwifi.sh
sed -i "s/ImmortalWrt-5G/YM520-5G/g" package/mtk/applications/mtwifi-cfg/files/mtwifi.sh
#sed -i "s/htbsscoex="1"/htbsscoex="0"/g" package/mtk/applications/mtwifi-cfg/files/mtwifi.sh

#WiFi相关设置3
sed -i 's/encryption=none/encryption=psk2+ccmp\n            set wireless.default_radio${devidx}.key=abc5124937,\n/g' package/mtk/applications/mtwifi-cfg/files/mtwifi.sh

## golang编译环境
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang


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

## 添加额外插件

git_sparse_clone main https://github.com/mzwrt/mzwrt_package_Lite  luci-app-ikoolproxy luci-app-store luci-app-quickstart luci-app-openclash luci-app-easymesh luci-app-ddnsto  luci-theme-argon luci-theme-design luci-app-design-config luci-app-argon-config luci-app-lucky luci-app-smartdns luci-lib-xterm luci-lib-taskd luci-lib-iform

git_sparse_clone main https://github.com/mzwrt/mzwrt_package_Lite  quickstart ucl upx taskd ddnsto filebrowser lua-maxminddb  smartdns upx-static docker lucky luci-app-homeproxy vlmcsd

git_sparse_clone IMM https://github.com/wwz09/LEDE-IMM-package luci-app-control-timewol luci-app-control-webrestriction luci-app-control-weburl luci-app-timecontrol luci-app-parentcontrol relevance


#更换luci-app-vlmcsd
# rm -rf feeds/luci/applications/luci-app-vlmcsd
# git_sparse_clone main https://github.com/ssuperh/luci-app-vlmcsd-new luci-app-vlmcsd
# git clone https://github.com/flytosky-f/openwrt-vlmcsd.git package/openwrt-vlmcsd

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
chmod -R a+x $GITHUB_WORKSPACE/Scripts/RAX3000M/mwrt/preset-clash-core.sh
$GITHUB_WORKSPACE/Scripts/RAX3000M/mwrt/preset-clash-core.sh
