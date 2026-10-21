include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-zash
PKG_VERSION:=1.0.0
PKG_RELEASE:=1
PKG_LICENSE:=GPL-3.0-only
PKG_MAINTAINER:=wfzc6880530
PKGARCH:=all

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-zash
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=LuCI Zashboard reverse proxy integration
  DEPENDS:=+luci-base +nginx
  PKGARCH:=all
endef

define Package/luci-app-zash/description
LuCI shortcut and dedicated Nginx reverse proxy for an existing Mihomo/Zashboard UI.
endef

define Build/Compile
endef

define Package/luci-app-zash/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/zashboard $(1)/etc/config/zashboard
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/zashboard-nginx $(1)/etc/init.d/zashboard-nginx
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/controller/zashboard.lua $(1)/usr/lib/lua/luci/controller/zashboard.lua
endef

$(eval $(call BuildPackage,luci-app-zash))
