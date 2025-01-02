#!/bin/bash
# 删除luci所在行
# sed -i '/luci/d' feeds.conf.default
# sed -i '/packages/d' feeds.conf.default
# sed -i '/small/d' feeds.conf.default

# 修改默认IP
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

#　修改主机名
sed -i "s/hostname='OpenWrt'/hostname='QihooV6'/g" package/base-files/files/bin/config_generate


sed -i '$a src-git smpackage https://github.com/kenzok8/small-package' feeds.conf.default
./scripts/feeds update
rm -rf feeds/smpackage/{base-files,dnsmasq,firewall*,fullconenat,libnftnl,nftables,ppp,opkg,ucl,upx,vsftpd-alt,miniupnpd-iptables,wireless-regdb}
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang


# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# Themes
git clone --depth=1 -b 18.06 https://github.com/kiddin9/luci-theme-edge package/luci-theme-edge
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
git clone --depth=1 https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
git_sparse_clone main https://github.com/haiibo/packages luci-theme-atmaterial luci-theme-opentomcat luci-theme-netgear


# 添加额外插件
git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome package/luci-app-adguardhome
git clone --depth=1 -b openwrt-18.06 https://github.com/tty228/luci-app-wechatpush package/luci-app-serverchan
git clone --depth=1 https://github.com/ilxp/luci-app-ikoolproxy package/luci-app-ikoolproxy
git clone --depth=1 https://github.com/esirplayground/luci-app-poweroff package/luci-app-poweroff
git clone --depth=1 https://github.com/destan19/OpenAppFilter package/OpenAppFilter
git clone --depth=1 https://github.com/Jason6111/luci-app-netdata package/luci-app-netdata
git_sparse_clone main https://github.com/Lienol/openwrt-package luci-app-filebrowser luci-app-ssr-mudb-server
git_sparse_clone openwrt-18.06 https://github.com/immortalwrt/luci applications/luci-app-eqos

# SmartDNS
git clone --depth=1 -b lede https://github.com/pymumu/luci-app-smartdns package/luci-app-smartdns
git clone --depth=1 https://github.com/pymumu/openwrt-smartdns package/smartdns


# Alist
git clone --depth=1 https://github.com/sbwml/luci-app-alist package/luci-app-alist

# DDNS.to
git_sparse_clone main https://github.com/linkease/nas-packages-luci luci/luci-app-ddnsto
git_sparse_clone master https://github.com/linkease/nas-packages network/services/ddnsto

# iStore
git_sparse_clone main https://github.com/linkease/istore-ui app-store-ui
git_sparse_clone main https://github.com/linkease/istore luci

#修改默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

./scripts/feeds install -a  








# 删除luci所在行
# sed -i '/luci/d' feeds.conf.default
# sed -i '/packages/d' feeds.conf.default
# sed -i '/small/d' feeds.conf.default

# 删除所有空白行
# sed －i '/^\s*$/d' feeds.conf.default







# MosDNS
git clone --depth=1 https://github.com/sbwml/luci-app-mosdns package/luci-app-mosdns

# Alist
git clone --depth=1 https://github.com/sbwml/luci-app-alist package/luci-app-alist




# 修改本地时间格式
sed -i 's/os.date()/os.date("%a %Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/*/index.htm

# 修改版本为编译日期
date_version=$(date +"%y.%m.%d")
orig_version=$(cat "package/lean/default-settings/files/zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
sed -i "s/${orig_version}/R${date_version} by Haiibo/g" package/lean/default-settings/files/zzz-default-settings

# 取消主题默认设置
find package/luci-theme-*/* -type f -name '*luci-theme-*' -print -exec sed -i '/set luci.main.mediaurlbase/d' {} \;



./scripts/feeds update -a
./scripts/feeds install -a