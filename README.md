# luci-app-zash

LuCI menu integration for opening the Zashboard/Mihomo web UI through a dedicated local Nginx reverse proxy.

> Target: ImmortalWrt/OpenWrt 24.10, initially aimed at `ipq40xx/generic` (ARMv7). The package itself is architecture-independent; the CI build uses the matching ImmortalWrt SDK.

## What it does

- Adds **Services → Zashboard** in LuCI.
- Runs a separate Nginx instance on port **8088** by default, avoiding edits to the router's main Nginx/uhttpd listener.
- Proxies the UI, Mihomo controller API, and WebSocket traffic to the configured controller (default `127.0.0.1:9090`).
- Does not change OpenClash configuration or expose a WAN firewall port automatically.

The menu redirects to `http://<router-address>:8088/ui/`. The Mihomo controller must already be configured to serve Zashboard (usually under `/ui/`) and accept requests from the router itself.

## Important security notes

The controller API is privileged. Keep port 8088 on trusted LAN access only. Do not publish it directly to the Internet or expose it through NPS/Nginx Proxy Manager unless you have separately implemented strong access control (for example, an authenticated VPN or an authenticated reverse proxy). This package does not add authentication to Mihomo.

## Install

Download the `.ipk` for your target from the GitHub Actions artifact or Releases, then install it on the router:

```sh
opkg install ./luci-app-zash_*.ipk
/etc/init.d/zashboard-nginx enable
/etc/init.d/zashboard-nginx restart
/etc/init.d/rpcd restart
/etc/init.d/uhttpd restart
```

The package depends on `luci-base` and `nginx`; opkg should install missing dependencies if your configured package feeds provide them.

Open **LuCI → Services → Zashboard**. If the menu does not appear, sign out/in or refresh the browser.

## Configure

Defaults are stored in `/etc/config/zashboard`:

```sh
uci show zashboard
uci set zashboard.main.listen_port='8088'
uci set zashboard.main.controller_host='127.0.0.1'
uci set zashboard.main.controller_port='9090'
uci commit zashboard
/etc/init.d/zashboard-nginx restart
```

Check the proxy locally:

```sh
wget -S -O /dev/null http://127.0.0.1:8088/ui/
logread | grep -i zashboard
```

If the controller uses a different port, update `controller_port`. Do not set the controller host to a public address unless you understand the routing and security implications.

## Build IPK

The GitHub Actions workflow builds with the ImmortalWrt 24.10.5 `ipq40xx/generic` SDK. On GitHub, open **Actions → Build ImmortalWrt IPK → Run workflow**. The resulting IPK is uploaded as an artifact. Builds may fail if the upstream SDK URL or package feed changes; check the Actions log.

## Current scope / limitations

- This package provides the LuCI shortcut and reverse-proxy service. It does not bundle the Zashboard frontend files.
- Zashboard must already be available from the controller's `/ui/` endpoint.
- The default proxy listener is port 8088 and is not added to any firewall zone by this package.
- This first version targets the OpenWrt/ImmortalWrt 24.10 package layout. Test on a backup or non-production router before using it remotely.
