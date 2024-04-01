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
sed -i 's/192.168.1.1/192.168.3.1/g' package/base-files/files/bin/config_generate

#　修改主机名
sed -i "s/hostname='OpenWrt'/hostname='QihooV6'/g" package/base-files/files/bin/config_generate

#　编译的固件文件名
sed -i 's/IMG_PREFIX:=$(VERSION_DIST_SANITIZED)/IMG_PREFIX:=ZYBWIFI-$(VERSION_DIST_SANITIZED)/g' include/image.mk

# 删除luci所在行
# sed -i '/luci/d' feeds.conf.default
# sed -i '/packages/d' feeds.conf.default
sed -i '/small/d' feeds.conf.default
# 删除所有空白行
sed －i '/^\s*$/d' feeds.conf.default

# echo 'src-git luci https://github.com/immortalwrt/luci.git' >>feeds.conf.default
# echo 'src-git packages https://github.com/immortalwrt/packages.git' >>feeds.conf.default
# echo 'src-git small_package https://github.com/kenzok8/small-package.git;main' >>feeds.conf.default
# echo 'src-git openwrt_packages https://github.com/wwz09/openwrt-packages;master' >>feeds.conf.default
# echo 'src-git openwrt_small https://github.com/wwz09/small;master' >>feeds.conf.default
# echo 'src-git mosdns https://github.com/sbwml/luci-app-mosdns;v5' >>feeds.conf.default
# echo 'src-git kenzo https://github.com/kenzok8/openwrt-packages' >>feeds.conf.default
echo 'src-git small https://github.com/kenzok8/small;master' >>feeds.conf.default

./scripts/feeds update -a
./scripts/feeds install -a