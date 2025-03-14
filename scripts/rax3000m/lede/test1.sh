#!/bin/bash
#=================================================
# 
#================================================= 


##添加自己的插件库
# echo -e "\nsrc-git extraipk https://github.com/wwz09/RAX3000MIPK" >> feeds.conf.default
# echo -e "\nsrc-git immo https://github.com/immortalwrt/luci.git;openwrt-21.02" >> feeds.conf.default
 echo -e "\nsrc-git mzwrt_package https://github.com/mzwrt/mzwrt_package_Lite.git" >> feeds.conf.default


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

git_sparse_clone main https://github.com/Lienol/openwrt-package  luci-app-control-webrestriction 
# git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-parentcontrol
git_sparse_clone main https://github.com/Lienol/openwrt-package luci-app-timecontrol
git_sparse_clone main https://github.com/sirpdboy/sirpdboy-package luci-app-control-timewol
git_sparse_clone main https://github.com/ksong008/sirpdboy-package luci-app-control-weburl
# git_sparse_clone main https://github.com/linkease/nas-packages-luci luci
# git_sparse_clone main https://github.com/wwz09/RAX3000MIPK luci-app-parentcontrol
# git clone  https://github.com/sirpdboy/luci-app-parentcontrol.git feeds/luci/applications/luci-app-parentcontrol
# git clone  https://github.com/firkerword/luci-app-parentcontrol.git ./package/luci-app-parentcontrol
