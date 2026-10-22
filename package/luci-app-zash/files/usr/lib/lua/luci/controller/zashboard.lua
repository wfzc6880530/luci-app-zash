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

	-- Use a relative URL so the browser keeps the exact current origin:
	-- scheme, public hostname, and port (including :8080 when present).
	-- Never redirect to a hard-coded LAN address or silently drop :8080.
	http.redirect("/zashboard/#/proxies?secondaryPath=/clash")
end
