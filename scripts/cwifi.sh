# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default
# 修改默认IP
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

#　修改主机名
sed -i "s/hostname='OpenWrt'/hostname='QihooV6'/g" package/base-files/files/bin/config_generate
# 删除luci所在行
# sed -i '/luci/d' feeds.conf.default

# 删除所有空白行
# sed －i '/^\s*$/d' feeds.conf.default

# echo 'src-git luci https://github.com/immortalwrt/luci.git' >>feeds.conf.default
echo 'src-git small_package https://github.com/kenzok8/small-package.git;main' >>feeds.conf.default
# echo 'src-git openwrt_packages https://github.com/wwz09/openwrt-packages;master' >>feeds.conf.default
echo 'src-git openwrt_small https://github.com/wwz09/small;master' >>feeds.conf.default
# echo 'src-git mosdns https://github.com/sbwml/luci-app-mosdns;v5' >>feeds.conf.default
# echo 'src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2' >>feeds.conf.default
# echo 'src-git adguardhome https://github.com/xiaoxiao29/luci-app-adguardhome;master' >>feeds.conf.default


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
# rm -rf feeds/luci/applications/luci-app-netdata
# rm -rf feeds/luci/applications/luci-app-serverchan




# 移除要替换的包
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang feeds/packages/lang/golang
rm -rf feeds/luci/applications
git clone  https://github.com/wwz09/applications feeds/luci/applications
git clone --depth=1 -b openwrt-18.06 https://github.com/tty228/luci-app-wechatpush package/luci-app-serverchan
# git clone --depth=1 https://github.com/ilxp/luci-app-ikoolproxy package/luci-app-ikoolproxy


# 添加主题
# git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
# git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config


# 取消主题默认设置
# find package/luci-theme-*/* -type f -name '*luci-theme-*' -print -exec sed -i '/set luci.main.mediaurlbase/d' {} \;
