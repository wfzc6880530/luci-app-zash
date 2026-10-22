module("luci.controller.zashboard", package.seeall)

function index()
	local fs = require "nixio.fs"
	if not fs.access("/www/dualweb/zashboard/index.html") then
		return
	end

	local page = entry({"admin", "services", "zashboard"}, call("action_index"), _("Zashboard"), 90)
	page.dependent = false
	page.leaf = true
end

function action_index()
	local http = require "luci.http"

	-- The plugin's standalone Nginx server listens on 8081. Keep the
	-- existing LuCI/uhttpd listener on 8080 and the firmware's :80 site intact.
	local host = http.getenv("HTTP_HOST") or http.getenv("SERVER_NAME") or "192.168.1.1"
	-- Strip the incoming port so the plugin port is always used.
	host = host:gsub(":%d+$", "")
	-- Prevent malformed Host headers from being reflected into a redirect.
	if not host:match("^[%w%.%-%[%]:]+$") then
		host = "192.168.1.1"
	end

	http.redirect("http://" .. host .. ":8081/zashboard/#/proxies?secondaryPath=/clash")
end
