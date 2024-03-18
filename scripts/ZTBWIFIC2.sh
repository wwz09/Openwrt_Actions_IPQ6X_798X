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
rm -rf package/feeds/packages/uspot
rm -rf package/feeds/sup/upx
rm -rf package/feeds/sup/shadowsocksr-libev
# rm -rf package/feeds/luci/luci-app-appfilter
# rm -rf package/feeds/luci/luci-app-bitsrunlogin-go
# rm -rf package/feeds/luci/luci-app-cpulimit
# rm -rf package/feeds/luci/luci-app-daed
# rm -rf package/feeds/luci/luci-app-ddns-go
# rm -rf package/feeds/luci/luci-app-gowebdav
# rm -rf package/feeds/luci/luci-app-homeproxy
# rm -rf package/feeds/luci/luci-app-k3screenctrl
# rm -rf package/feeds/luci/luci-app-samba
# rm -rf feeds/luci/applications/luci-app-serverchan




# 移除要替换的包
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang feeds/packages/lang/golang
# rm -rf feeds/luci/applications
# git clone https://github.com/wwz09/applications feeds/luci/applications
# git clone  https://github.com/wwz09/sup.git feeds/luci/applications/sup
git clone https://github.com/sirpdboy/luci-app-parentcontrol.git feeds/luci/applications/luci-app-parentcontrol
# git clone https://github.com/rianjskis/luci-app-filetransfer.git luci/applications/luci-app-filetransfer
git clone --depth=1 -b openwrt-18.06 https://github.com/tty228/luci-app-wechatpush package/luci-app-serverchan
# git clone --depth=1 https://github.com/ilxp/luci-app-ikoolproxy package/luci-app-ikoolproxy


# 添加主题
# git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
# git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config

#　编译的固件文件名
sed -i 's/IMG_PREFIX:=$(VERSION_DIST_SANITIZED)/IMG_PREFIX:=ZTBWIFIC-$(VERSION_DIST_SANITIZED)/g' include/image.mk

# 取消主题默认设置
# find package/luci-theme-*/* -type f -name '*luci-theme-*' -print -exec sed -i '/set luci.main.mediaurlbase/d' {} \;
