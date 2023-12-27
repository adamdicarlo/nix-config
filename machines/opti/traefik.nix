{config, ...}: {
  users.users.traefik.extraGroups = ["acme"];

  services.traefik = let
    certDir = config.security.acme.certs."sleeping-panda.net".directory;
  in {
    enable = true;
    dynamicConfigOptions = {
      http.routers.adguardhome = {
        rule = "Host(`adguardhome.sleeping-panda.net`)";
        entryPoints = "websecure";
        service = "adguardhome";
        tls = true;
      };
      http.routers.traefik = {
        rule = "Host(`traefik.sleeping-panda.net`)";
        entryPoints = "websecure";
        service = "api@internal";
        tls = true;
      };
      http.services.adguardhome = {
        loadBalancer.servers = [{url = "http://localhost:5300/";}];
      };
      tls = {
        certificates = [
          {
            certFile = "${certDir}/cert.pem";
            keyFile = "${certDir}/key.pem";
            stores = ["default"];
          }
        ];
      };
    };
    staticConfigOptions = {
      api.dashboard = true;
      dns = ["localhost"];
      entryPoints = {
        web = {
          address = ":80";
          http.redirections.entryPoint = {
            to = "websecure";
            scheme = "https";
            permanent = true;
          };
        };
        websecure = {
          address = ":443";
        };
      };
      global = {
        checkNewVersion = false;
        sendAnonymousUsage = false;
      };
    };
  };
}
