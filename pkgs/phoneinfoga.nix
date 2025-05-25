{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nodejs,
  yarn
}:

buildGoModule rec {
  pname = "phoneinfoga";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "sundowndev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jjgRgpwT1n5TUQYnqsGkyfaJ6q7NJzhIm5/VToz5Luc=";
  };

# === GO MODULE VENDORING ===
  # Tell buildGoModule to fetch dependencies based on go.mod and go.sum,
  # ignoring any vendor directory in src.
  proxyVendor = true;

  # This is the hash of the vendored dependencies that Nix will download.
  vendorHash = "sha256-OUS2UeLwUDx0zH8+GcIb1XqYJ9rEqHmWVzruyNG2Tjw=";

  # It's good practice to remove the potentially problematic vendor directory
  # from the source when using proxyVendor = true.
  postPatch = ''
    rm -rf vendor
    # Optionally, if go.sum is also inconsistent (though less likely to be the primary issue here):
    # go mod tidy # This would require 'go' in nativeBuildInputs for postPatch
  '';


# === WEB CLIENT ASSETS BUILD ===
  # Add Node.js and Yarn to build inputs for the web client
  nativeBuildInputs = [ nodejs yarn ];

  # The Go embed directive in web/client.go is: //go:embed all:client/dist
  # This means it expects 'client/dist' relative to the 'web' directory.
  # So, we need to build the client assets into 'web/client/dist/'
  preBuild = ''
    echo "Current directory before client build: $(pwd)"
    ls -la web # Check contents of web directory

    echo "Building web UI in web/client..."
    pushd web/client
      # Install dependencies using yarn
      # --frozen-lockfile: Ensures yarn.lock is authoritative and not modified.
      # --ignore-platform: Skips platform-specific checks for optional dependencies.
      # --ignore-scripts: Skips running postinstall scripts (can help in sandboxed builds).
      echo "Running: yarn install --frozen-lockfile --ignore-scripts"
      yarn install --frozen-lockfile --ignore-scripts
      # Build the static assets
      yarn build # This should create the 'dist' directory (i.e., web/client/dist)
    popd

    echo "Web UI built. Checking for web/client/dist:"
    ls -R web/client # Verify that web/client/dist exists and has files
  '';


# === GO BUILD CONFIGURATION ===
  # The main package seems to be at the root.
  subPackages = [ "." ];

  ldflags = [
    "-s" "-w"
    "-X github.com/sundowndev/phoneinfoga/v2/build.Version=v${version}"
  ];


# === PACKAGE METADATA ===
  meta = with lib; {
    description = "Advanced information gathering & OSINT framework for phone numbers";
    homepage = "https://github.com/sundowndev/phoneinfoga";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ]; # Add your Nixpkgs/GitHub username
    platforms = platforms.linux ++ platforms.darwin;
  };
}
