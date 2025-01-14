{ ... }:{
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    #applications = {
    #  env = {
    #    PATH = "$(PATH):$(HOME)/.local/bin";
    #  };
    #  apps = [
    #    {
    #
    #    }
    #  ];
    #};
  };
}
