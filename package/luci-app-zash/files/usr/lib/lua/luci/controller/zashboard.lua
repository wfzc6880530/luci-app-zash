module("luci.controller.zashboard", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/zashboard") then
		return
	end
	local page = entry({"admin", "services", "zashboard"}, call("action_index"), _("Zashboard"), 90)
	page.dependent = false
	page.leaf = true
end

function action_index()
	local http = require "luci.http"
	local uci = require "luci.model.uci".cursor()
	local port = uci:get("zashboard", "main", "listen_port") or "8088"
	if not port:match("^%d+$") or tonumber(port) < 1 or tonumber(port) > 65535 then
		port = "8088"
	end

	local host = http.getenv("HTTP_HOST") or http.getenv("SERVER_NAME") or "192.168.1.1"
	host = host:gsub(":%d+$", "")
	if not host:match("^[%w%.:%[%]-]+$") then
		host = "192.168.1.1"
	end
	http.redirect("http://" .. host .. ":" .. port .. "/ui/")
end
