include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-zash
PKG_VERSION:=1.1.0
PKG_RELEASE:=1
PKG_LICENSE:=MIT
PKG_MAINTAINER:=wfzc6880530
PKGARCH:=all

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-zash
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=LuCI Zashboard same-origin integration
  DEPENDS:=+luci-base +nginx
  PKGARCH:=all
endef

define Package/luci-app-zash/description
Bundles the Zashboard frontend and adds a LuCI shortcut using the existing Nginx
/zashboard/ static path and /clash/ same-origin Mihomo API proxy. The build
workflow downloads the upstream frontend before packaging.
endef

define Build/Compile
endef

define Package/luci-app-zash/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/controller/zashboard.lua $(1)/usr/lib/lua/luci/controller/zashboard.lua
	$(INSTALL_DIR) $(1)/www/dualweb/zashboard
	test -s ./files/www/dualweb/zashboard/index.html
	$(CP) ./files/www/dualweb/zashboard/. $(1)/www/dualweb/zashboard/
endef

$(eval $(call BuildPackage,luci-app-zash))
