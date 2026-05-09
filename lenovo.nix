# NixOS configuration for Lenovo Y50-70
{ config, lib, pkgs, ... }:

let
  home-manager = builtins.fetchTarball
    "https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz";
in
{
  imports =
    [
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Y50-70 kernel params
  boot.kernelParams = [
    "mem_sleep_default=deep"
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # NVIDIA Optimus (Intel + GTX 860M)
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    intelBusId  = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # No swap
  # swapDevices = [];

  services.logind.lidSwitch = "suspend";
  networking.networkmanager.wifi.powersave = false;
  networking.networkmanager.dns = "default";

  programs.adb.enable = true;

  networking.hostName = "nixos";

  home-manager.users.pablo = import ./home.nix;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;

  # wlp8s0 is the WiFi interface on this machine
  networking.firewall.trustedInterfaces = [ "wlp8s0" ];
  services.blueman.enable = true;

  time.timeZone = "America/Chihuahua";

  # X11
  services.xserver.displayManager.lightdm.enable = false;
  services.xserver.displayManager.startx.enable = true;

  services.xserver.windowManager.dwm = {
    enable = true;
    package = pkgs.dwm.overrideAttrs {
      src = builtins.fetchGit {
        url = "https://github.com/pabloduarte9679/dwm";
        rev = "388409f2436f876fc32b4ed5f487cb74d0502b4e";
      };
    };
  };

  services.xserver = {
    enable = true;
    xkb.layout = "us";
  };

  # Printing
  services.printing = {
    enable = true;
    drivers = with pkgs; [ hplipWithPlugin ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Touchpad
  services.libinput.enable = true;

  # Dnsmasq for hotspot

  # User
  users.users.pablo = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "lp" "adbusers" "dialout" "fuse" ];
    shell = pkgs.yash;
    packages = with pkgs; [
      tree
    ];
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    st
    dmenu
    tmux
    fastfetch
    htop
    brightnessctl
    acpi
    git
    gnumake
    gcc
    yash
    pamixer
    nodejs_24
    freetds
    unixODBC
    arandr
    bluetui
    xsel
    unzip
    feh
    mupdf
    python315
    unixtools.arp
    usbutils
    scrot
    cowsay
    unrar
    mlocate
    sc
    file
    ghostscript
    man-pages
    man-pages-posix
    zathura
    gdb
    xorg.libXxf86vm
    gtk3
    glib
    nvtopPackages.nvidia
    numlockx
    appimage-run
    localsend
  ];

  services.locate.locate = pkgs.mlocate;
  services.locate.enable = true;

  documentation.dev.enable = true;
  documentation.man = {
    man-db.enable = false;
    mandoc.enable = true;
  };

  environment.shells = with pkgs; [ yash ];
  environment.variables = {
    SSH_ASKPASS = "";
    SSH_ASKPASS_REQUIRE = "never";
  };
  programs.ssh.askPassword = "";
  programs.ssh.startAgent = false;

  virtualisation.docker = {
    enable = true;
  };

  services.openssh.enable = true;

  system.stateVersion = "25.11";
}
