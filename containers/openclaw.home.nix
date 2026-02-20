{
  lib,
  pkgs,
  ...
}:
let
  # Match upstream docker-setup.sh flow: build from repo Dockerfile.
  openclawSrc = pkgs.fetchFromGitHub {
    owner = "openclaw";
    repo = "openclaw";
    rev = "master";
    hash = "sha256-Ha+khhDT9+uL8xRmFs92avqQ5mbC6UM+i+WjMJuIlFo=";
  };

  srcStoreName = builtins.baseNameOf (toString openclawSrc);
  srcHash = builtins.unsafeDiscardStringContext (
    builtins.head (lib.strings.splitString "-" srcStoreName)
  );

  # Extra tools installed by upstream Dockerfile via OPENCLAW_DOCKER_APT_PACKAGES.
  aptPackages = "git curl jq ffmpeg nix-bin";
  aptHash = builtins.substring 0 12 (builtins.hashString "sha256" aptPackages);

  imageName = "openclaw-repo";
  imageTag = "${srcHash}-${aptHash}";
  imageRef = builtins.unsafeDiscardStringContext "${imageName}:${imageTag}";
  baseImageRef = builtins.unsafeDiscardStringContext "${imageName}-base:${imageTag}";
in
{
  home.activation.buildOpenclawImage = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    base_image="docker.io/library/node:22-bookworm"
    local_base="node:22-bookworm"

    if ${pkgs.podman}/bin/podman image exists ${imageRef}; then
      echo "OpenClaw image ${imageRef} already exists; skipping rebuild."
    else
      if ! ${pkgs.podman}/bin/podman image exists "$local_base"; then
        if ${pkgs.podman}/bin/podman image exists "$base_image"; then
          ${pkgs.podman}/bin/podman tag "$base_image" "$local_base"
        else
          # Stale credentials in rootless auth.json can break anonymous pulls.
          ${pkgs.podman}/bin/podman logout docker.io >/dev/null 2>&1 || true
          ${pkgs.podman}/bin/podman pull "$base_image"
          ${pkgs.podman}/bin/podman tag "$base_image" "$local_base"
        fi
      fi

      ${pkgs.podman}/bin/podman image rm -f ${baseImageRef} >/dev/null 2>&1 || true
      ${pkgs.podman}/bin/podman build \
        --pull=never \
        --build-arg OPENCLAW_DOCKER_APT_PACKAGES='${aptPackages}' \
        -t ${baseImageRef} \
        -f ${openclawSrc}/Dockerfile \
        ${openclawSrc}

      tmpdir="$(mktemp -d)"
      cat >"$tmpdir/Containerfile" <<EOF
FROM ${baseImageRef}
USER root
RUN mkdir -p /home/ceru && chown 1000:1000 /home/ceru
USER 1000
EOF
      ${pkgs.podman}/bin/podman build --pull=never -t ${imageRef} -f "$tmpdir/Containerfile" "$tmpdir"
      rm -rf "$tmpdir"
    fi
  '';

  services.podman = {
    enable = true;
    containers.openclaw = {
      autoStart = true;
      image = imageRef;
      network = "host";
      user = "1000";
      group = "1000";
      userNS = "keep-id";

      volumes = [
        "/home/neko/.openclaw:/home/ceru/.openclaw:rw"
        "/home/neko/.openclaw:/home/ceru/.clawdbot:rw"
        "/home/neko/Notes:/home/ceru/Notes:rw"
        "/home/neko/.nixcfg:/home/ceru/nixcfg:rw"
        "/nix/var/nix/daemon-socket/socket:/nix/var/nix/daemon-socket/socket:rw"
        "/nix/store:/nix/store:ro"
        "/home/neko/.config/gogcli:/home/ceru/.config/gogcli:rw"
      ];

      environment = {
        HOME = "/home/ceru";
        XDG_CONFIG_HOME = "/home/ceru/.config";
        XDG_STATE_HOME = "/home/ceru/.local/state";
        NVIDIA_VISIBLE_DEVICES = "all";
        NVIDIA_DRIVER_CAPABILITIES = "all";
        NIX_REMOTE = "daemon";
      };

      exec = "bash -lc 'mkdir -p /home/ceru/.config /home/ceru/.local/state /home/ceru/Notes /home/ceru/nixcfg /home/ceru/.openclaw && exec node dist/index.js gateway --bind loopback --port 18789'";

      # Modern NVIDIA path via CDI (nvidia-ctk), instead of raw /dev/nvidia* binds.
      devices = [
        "nvidia.com/gpu=all"
        "/dev/dri:/dev/dri"
      ];
    };
  };
}
