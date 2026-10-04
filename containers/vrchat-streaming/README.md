# VRChat streaming on meow

Create `/data/.secret/vrchat-streaming.env` with mode `0600` before activating:

```sh
NEKO_USER_PASSWORD=choose-a-long-password
NEKO_ADMIN_PASSWORD=choose-another-long-password
```

The Compose service runs under your `neko` account with rootless Podman. Open n.eko at `http://<meow-lan-ip>:8085`.
The HLS stream for a VRChat video player is
`http://<meow-lan-ip>:8888/live/index.m3u8`.

`NEKO_WEBRTC_NAT1TO1` defaults to meow's LAN address (`192.168.1.5`) so Neko's
WebRTC ICE candidates point at an address LAN clients can reach. If meow's LAN
address changes, update the value in `/data/.secret/vrchat-streaming.env`.

For access from outside the LAN, forward TCP 8085, 8888, and UDP 52000–52100
to meow, and set `NEKO_WEBRTC_NAT1TO1` to the public IP in the environment file.
Neko advertises one address at a time, so clients on both LAN and WAN need
working NAT loopback when using the public address. Put the web interface behind
HTTPS before exposing it publicly.

The NVIDIA Neko image uses the GPU for browser rendering and GStreamer
`nvautogpuh264enc` for both the WebRTC video and the outgoing H.264 stream. It
uses CUDA memory for the encode pipeline and requires a recent NVIDIA driver
(590 or newer for `nvautogpuh264enc`). The image tracks Neko's latest release
because older NVIDIA image versions were missing the required encoder plugin.
