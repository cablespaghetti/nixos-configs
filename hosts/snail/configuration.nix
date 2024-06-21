# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{
  config,
  pkgs,
  modules,
  ...
}: {
  networking.hostName = "snail";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  # I mean why not use ZSH...
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = ["git"];
      theme = "robbyrussell";
    };
  };
  home-manager = {
    users.sam = {
      home.sessionVariables = {
        EDITOR = "vim";
      };
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          show-battery-percentage = true;
        };
        "org/gnome/settings-daemon/plugins/color" = {
          night-light-enabled = true;
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybinding/custom0" = {
          binding = "<Super>t";
          command = "kgx";
          name = "Terminal";
        };
        "org/gnome/shell/weather" = {
          locations = "[<(uint32 2, <('Southampton', 'EGHI', true, [(0.88837258926511375, -0.024434609527920613)], [(0.88837258926511375, -0.024434609527920613)])>)>]";
        };
        "org/gnome/Weather" = {
          locations = "[<(uint32 2, <('Southampton', 'EGHI', true, [(0.88837258926511375, -0.024434609527920613)], [(0.88837258926511375, -0.024434609527920613)])>)>]";
        };
      };
      programs = {
        librewolf = {
          enable = true;
          settings = {
            "identity.fxaccounts.enabled" = true;
            "privacy.clearOnShutdown.cookies" = false;
            "privacy.clearOnShutdown.history" = false;
            "privacy.clearOnShutdown.sessions" = false;
            "services.sync.engine.passwords" = false;
            "browser.bookmarks.addedImportButton" = false;
            "browser.startup.page" = 3;
          };
        };
      };
    };
  };
}
