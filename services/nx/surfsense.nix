{ pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_13;  # Using PostgreSQL 13 to match your current version

    # Enable network listening
    enableTCPIP = true;

    # Authentication settings
    authentication = pkgs.lib.mkOverride 10 ''
      # TYPE  DATABASE       USER            ADDRESS                METHOD
      local   all            all                                    trust
      host    all            all             127.0.0.1/32           md5
      host    all            all             192.168.1.1/32         md5
      host    all            all             ::1/128                md5
      host    all            all             0.0.0.0/0              md5
    '';

    # Initial superuser settings
    initialScript = pkgs.writeText "backend-init.sql" ''
      CREATE USER surfsense WITH PASSWORD 'uaithljt';
      CREATE DATABASE surfsense_db;
      GRANT ALL PRIVILEGES ON DATABASE surfsense_db TO surfsense;
    '';

    settings = {
      listen_addresses = "*";  # Listen on all available addresses
      max_connections = 100;
      # Add any other PostgreSQL settings you need here
    };
  };

  # Open the PostgreSQL port
  networking.firewall.allowedTCPPorts = [ 5432 ];
}
