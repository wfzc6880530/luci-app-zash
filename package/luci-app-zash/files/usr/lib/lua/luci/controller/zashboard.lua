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

	-- Use the same host and scheme as the current request, but let the
	-- router's existing :80/:443 reverse-proxy path serve the UI and API.
	-- Never send browser requests to 127.0.0.1:9090 or a standalone port.
	local host = http.getenv("HTTP_HOST") or http.getenv("SERVER_NAME") or "192.168.1.1"
	-- Remove an optional port, including the usual :8080 LuCI port.
	host = host:gsub(":%d+$", "")
	if not host:match("^[%w%.%-%[%]:]+$") then
		host = "192.168.1.1"
	end

	local scheme = http.getenv("HTTP_X_FORWARDED_PROTO") or http.getenv("REQUEST_SCHEME") or "http"
	-- Only accept standard schemes to avoid reflecting an arbitrary header.
	if scheme ~= "http" and scheme ~= "https" then
		scheme = "http"
	end

	http.redirect(scheme .. "://" .. host .. "/zashboard/#/proxies?secondaryPath=/clash")
end
