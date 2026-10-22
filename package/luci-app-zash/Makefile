include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-zash
PKG_VERSION:=1.2.0
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
Bundles Zashboard and adds HTTPS same-origin Nginx routes for /zashboard/ and
/clash/, proxying the Mihomo API to 127.0.0.1:9090 on the router itself.
endef

define Build/Compile
endef

define Package/luci-app-zash/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/controller/zashboard.lua $(1)/usr/lib/lua/luci/controller/zashboard.lua
	$(INSTALL_DIR) $(1)/www/dualweb/zashboard
	test -s ./files/www/dualweb/zashboard/index.html
	$(CP) ./files/www/dualweb/zashboard/. $(1)/www/dualweb/zashboard/
	$(INSTALL_DIR) $(1)/etc/nginx/conf.d
	$(INSTALL_DATA) ./files/etc/nginx/conf.d/zashboard.locations $(1)/etc/nginx/conf.d/zashboard.locations
endef

$(eval $(call BuildPackage,luci-app-zash))
