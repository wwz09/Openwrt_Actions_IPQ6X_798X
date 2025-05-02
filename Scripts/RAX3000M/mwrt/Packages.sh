#!/bin/bash

#安装和更新软件包
UPDATE_PACKAGE() {
	local PKG_NAME=$1
	local PKG_REPO=$2
	local PKG_BRANCH=$3
	local PKG_SPECIAL=$4
	local PKG_LIST=("$PKG_NAME" $5)  # 第5个参数为自定义名称列表
	local REPO_NAME=${PKG_REPO#*/}

	echo " "

	# 删除本地可能存在的不同名称的软件包
	for NAME in "${PKG_LIST[@]}"; do
		# 查找匹配的目录
		echo "Search directory: $NAME"
		local FOUND_DIRS=$(find ../feeds/luci/ ../feeds/packages/ -maxdepth 3 -type d -iname "*$NAME*" 2>/dev/null)

		# 删除找到的目录
		if [ -n "$FOUND_DIRS" ]; then
			while read -r DIR; do
				rm -rf "$DIR"
				echo "Delete directory: $DIR"
			done <<< "$FOUND_DIRS"
		else
			echo "Not fonud directory: $NAME"
		fi
	done

	# 克隆 GitHub 仓库
	git clone --depth=1 --single-branch --branch $PKG_BRANCH "https://github.com/$PKG_REPO.git"

	# 处理克隆的仓库
	if [[ $PKG_SPECIAL == "pkg" ]]; then
		find ./$REPO_NAME/*/ -maxdepth 3 -type d -iname "*$PKG_NAME*" -prune -exec cp -rf {} ./ \;
		rm -rf ./$REPO_NAME/
	elif [[ $PKG_SPECIAL == "name" ]]; then
		mv -f $REPO_NAME $PKG_NAME
	fi
}

# 调用示例
# UPDATE_PACKAGE "OpenAppFilter" "destan19/OpenAppFilter" "master" "" "custom_name1 custom_name2"
# UPDATE_PACKAGE "open-app-filter" "destan19/OpenAppFilter" "master" "" "luci-app-appfilter oaf" 这样会把原有的open-app-filter，luci-app-appfilter，oaf相关组件删除，不会出现coremark错误。

# UPDATE_PACKAGE "包名" "项目地址" "项目分支" "pkg/name，可选，pkg为从大杂烩中单独提取包名插件；name为重命名为包名"
# UPDATE_PACKAGE "argon" "sbwml/luci-theme-argon" "openwrt-24.10"
UPDATE_PACKAGE "kucat" "sirpdboy/luci-theme-kucat" "js"

UPDATE_PACKAGE "homeproxy" "VIKINGYFY/homeproxy" "main"
UPDATE_PACKAGE "nikki" "nikkinikki-org/OpenWrt-nikki" "main"
UPDATE_PACKAGE "openclash" "vernesong/OpenClash" "dev" "pkg"
UPDATE_PACKAGE "passwall" "xiaorouji/openwrt-passwall" "main" "pkg"
UPDATE_PACKAGE "passwall2" "xiaorouji/openwrt-passwall2" "main" "pkg"

UPDATE_PACKAGE "luci-app-timecontrol" "wwz09/IPQ_package" "IMM" "pkg"
UPDATE_PACKAGE "luci-app-control-webrestriction" "wwz09/IPQ_package" "IMM" "pkg"
UPDATE_PACKAGE "luci-app-control-weburl" "wwz09/IPQ_package" "IMM" "pkg"
UPDATE_PACKAGE "luci-app-control-timewol" "wwz09/IPQ_package" "IMM" "pkg"
UPDATE_PACKAGE "luci-app-ikoolproxy" "wwz09/IPQ_package" "IMM" "pkg"
UPDATE_PACKAGE "luci-app-store" "wwz09/IPQ_package" "IMM" "pkg"
UPDATE_PACKAGE "luci-app-quickstart" "wwz09/IPQ_package" "IMM" "pkg"
UPDATE_PACKAGE "luci-app-openclash" "wwz09/IPQ_package" "IMM" "pkg"
UPDATE_PACKAGE "luci-app-easymesh" "wwz09/IPQ_package" "IMM" "pkg"
UPDATE_PACKAGE "luci-app-ddnsto" "wwz09/IPQ_package" "IMM" "pkg"
UPDATE_PACKAGE "luci-theme-argon" "wwz09/IPQ_package" "IMM" "pkg"
UPDATE_PACKAGE "luci-app-argon-config" "wwz09/IPQ_package" "IMM" "pkg"
UPDATE_PACKAGE "luci-app-smartdns" "wwz09/IPQ_package" "IMM" "pkg"


UPDATE_PACKAGE "luci-app-adguardhome" "kenzok8/small-package" "main" "pkg"
UPDATE_PACKAGE "luci-app-socat" "kenzok8/small-package" "main" "pkg"


UPDATE_PACKAGE "adguardhome" "kenzok8/small-package" "main" "pkg"
UPDATE_PACKAGE "luci-app-lucky" "sirpdboy/luci-app-lucky" "main" 
UPDATE_PACKAGE "alist" "sbwml/luci-app-alist" "main"
UPDATE_PACKAGE "easytier" "EasyTier/luci-app-easytier" "main"
UPDATE_PACKAGE "mosdns" "sbwml/luci-app-mosdns" "v5" "" "v2dat"
UPDATE_PACKAGE "viking" "VIKINGYFY/packages" "main" "" "luci-app-timewol luci-app-wolplus"
# UPDATE_PACKAGE "luci-app-socat" "sbwml/openwrt_pkgs" "main" "pkg"
# UPDATE_PACKAGE "vnt" "lmq8267/luci-app-vnt" "main"
# UPDATE_PACKAGE "luci-app-tailscale" "asvow/luci-app-tailscale" "main"
# UPDATE_PACKAGE "gecoosac" "lwb1978/openwrt-gecoosac" "main"
# UPDATE_PACKAGE "qmodem" "FUjr/modem_feeds" "main"

if [[ $WRT_REPO != *"immortalwrt"* ]]; then
	UPDATE_PACKAGE "qmi-wwan" "immortalwrt/wwan-packages" "master" "pkg"
fi

#更新软件包版本
UPDATE_VERSION() {
	local PKG_NAME=$1
	local PKG_MARK=${2:-false}
	local PKG_FILES=$(find ./ ../feeds/packages/ -maxdepth 3 -type f -wholename "*/$PKG_NAME/Makefile")

	if [ -z "$PKG_FILES" ]; then
		echo "$PKG_NAME not found!"
		return
	fi

	echo -e "\n$PKG_NAME version update has started!"

	for PKG_FILE in $PKG_FILES; do
		local PKG_REPO=$(grep -Po "PKG_SOURCE_URL:=https://.*github.com/\K[^/]+/[^/]+(?=.*)" $PKG_FILE)
		local PKG_TAG=$(curl -sL "https://api.github.com/repos/$PKG_REPO/releases" | jq -r "map(select(.prerelease == $PKG_MARK)) | first | .tag_name")

		local OLD_VER=$(grep -Po "PKG_VERSION:=\K.*" "$PKG_FILE")
		local OLD_URL=$(grep -Po "PKG_SOURCE_URL:=\K.*" "$PKG_FILE")
		local OLD_FILE=$(grep -Po "PKG_SOURCE:=\K.*" "$PKG_FILE")
		local OLD_HASH=$(grep -Po "PKG_HASH:=\K.*" "$PKG_FILE")

		local PKG_URL=$([[ $OLD_URL == *"releases"* ]] && echo "${OLD_URL%/}/$OLD_FILE" || echo "${OLD_URL%/}")

		local NEW_VER=$(echo $PKG_TAG | sed -E 's/[^0-9]+/\./g; s/^\.|\.$//g')
		local NEW_URL=$(echo $PKG_URL | sed "s/\$(PKG_VERSION)/$NEW_VER/g; s/\$(PKG_NAME)/$PKG_NAME/g")
		local NEW_HASH=$(curl -sL "$NEW_URL" | sha256sum | cut -d ' ' -f 1)

		echo "old version: $OLD_VER $OLD_HASH"
		echo "new version: $NEW_VER $NEW_HASH"

		if [[ $NEW_VER =~ ^[0-9].* ]] && dpkg --compare-versions "$OLD_VER" lt "$NEW_VER"; then
			sed -i "s/PKG_VERSION:=.*/PKG_VERSION:=$NEW_VER/g" "$PKG_FILE"
			sed -i "s/PKG_HASH:=.*/PKG_HASH:=$NEW_HASH/g" "$PKG_FILE"
			echo "$PKG_FILE version has been updated!"
		else
			echo "$PKG_FILE version is already the latest!"
		fi
	done
}


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
git_sparse_clone IMM https://github.com/wwz09/LEDE-IMM-package quickstart ucl upx taskd ddnsto filebrowser lua-maxminddb  smartdns upx-static docker lucky luci-lib-xterm luci-lib-taskd luci-lib-iform
# git_sparse_clone main https://github.com/wwz09/mzwrt_package_Lite luci-app-control-timewol luci-app-control-weburl luci-app-lucky lucky  luci-app-socat 
# git_sparse_clone main https://github.com/wwz09/mzwrt_package_Lite filebrowser luci-theme-argon luci-app-argon-config luci-theme-design
# git_sparse_clone openwrt-21.02 https://github.com/immortalwrt/luci applications/luci-app-firewall
# git_sparse_clone main https://github.com/gxnas/ImmortalWrt-2410-Packages luci-app-firewall

#UPDATE_VERSION "软件包名" "测试版，true，可选，默认为否"
UPDATE_VERSION "sing-box"
UPDATE_VERSION "tailscale"
