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


# 移除要替换的包
# rm -rf feeds/packages/net/mosdns
# rm -rf feeds/packages/net/msd_lite
# rm -rf feeds/packages/net/smartdns
# rm -rf feeds/packages/lang/golang
# rm -rf feeds/smpackage/{base-files,dnsmasq,firewall*,fullconenat,libnftnl,nftables,ppp,opkg,ucl,upx,vsftpd-alt,miniupnpd-iptables,wireless-regdb}
# rm -rf feeds/luci/themes/luci-theme-argon
# rm -rf feeds/openwrt-packages/luci-theme-argon
# rm -rf feeds/openwrt-packages/luci-app-argon-config
# rm -rf feeds/luci/themes/luci-theme-netgear
# rm -rf feeds/openwrt-packages/luci-app-ikoolproxy
# rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf package/feeds/luci/luci-app-samba
# rm -rf feeds/luci/applications/luci-app-serverchan




# 移除要替换的包
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang feeds/packages/lang/golang
rm -rf feeds/luci/applications
git clone https://github.com/wwz09/applications feeds/luci/applications
git clone https://github.com/sirpdboy/luci-app-parentcontrol.git feeds/luci/applications/luci-app-parentcontrol
# git clone https://github.com/rianjskis/luci-app-filetransfer.git luci/applications/luci-app-filetransfer
git clone --depth=1 -b openwrt-18.06 https://github.com/tty228/luci-app-wechatpush package/luci-app-serverchan
# git clone --depth=1 https://github.com/ilxp/luci-app-ikoolproxy package/luci-app-ikoolproxy


# 添加主题
# git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
# git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config

#　编译的固件文件名
sed -i 's/IMG_PREFIX:=$(VERSION_DIST_SANITIZED)/IMG_PREFIX:=CWIFI-$(VERSION_DIST_SANITIZED)/g' include/image.mk

# 取消主题默认设置
# find package/luci-theme-*/* -type f -name '*luci-theme-*' -print -exec sed -i '/set luci.main.mediaurlbase/d' {} \;
