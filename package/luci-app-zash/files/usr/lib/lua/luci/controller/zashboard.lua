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

	-- Prefer reverse-proxy headers so the menu preserves the public host,
	-- scheme and (when present) public port. For direct LuCI access on :8080,
	-- remove that local management port and use the web server on :80.
	local forwarded_host = http.getenv("HTTP_X_FORWARDED_HOST")
	local host = forwarded_host or http.getenv("HTTP_HOST") or http.getenv("SERVER_NAME") or "192.168.1.1"
	local server_port = http.getenv("SERVER_PORT") or ""
	local host_port = host:match(":(%d+)$")

	if not forwarded_host and host_port and host_port == server_port then
		host = host:gsub(":%d+$", "")
	end

	local proto = http.getenv("HTTP_X_FORWARDED_PROTO") or ""
	proto = proto:match("^%s*([^,%s]+)") or ""
	if proto ~= "http" and proto ~= "https" then
		proto = (server_port == "443") and "https" or "http"
	end

	if not host:match("^[%w%.:%[%]-]+$") then
		host = "192.168.1.1"
	end

	-- Same-origin UI and API proxy: the browser never connects to localhost
	-- or to the standalone legacy port 8088.
	http.redirect(proto .. "://" .. host .. "/zashboard/#/proxies?secondaryPath=/clash")
end
