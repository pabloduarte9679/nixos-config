# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  home-manager = builtins.fetchTarball
    "https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  boot.kernelParams = [
    "mem_sleep_default=deep"
  ];

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;


  services.logind.lidSwitch = "suspend";
  networking.networkmanager.wifi.powersave = false;

  programs.adb.enable = true;

  networking.hostName = "nixos";

  home-manager.users.pablo = import ./home.nix;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;


  networking.firewall.trustedInterfaces = [ "wlan0" ];
  services.blueman.enable = true;

  time.timeZone = "America/Chihuahua";

  
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;  
    open = false;  
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_470; 
  };

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true; 
    };
   
    intelBusId  = "PCI:0:2:0";
    nvidiaBusId = "PCI:4:0:0";
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable the X11 windowing system.
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
  };

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [ hplipWithPlugin ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable touchpad support.
  services.libinput.enable = true;


  users.users.pablo = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "lp" "adbusers" "dialout" "fuse" ];
    shell = pkgs.yash;
    packages = with pkgs; [
      tree
    ];
  };

  nixpkgs.config.allowUnfree = true;
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
    php
    dbeaver-bin
    nodejs_24
    freetds
    unixODBC
    arandr
    bluetui
    xsel
    unzip
    localsend
    feh
    wkhtmltopdf
    mupdf
    netsurf-browser
    qemu
    python315
    unixtools.arp
    hplip
    usbutils
    freecad
    scrot
    cowsay
    unrar
    swtpm
    OVMF
    mlocate
    sc
    file
    ghostscript
    man-pages
    man-pages-posix
    zathura
    gdb
    quickemu
    mplayer
    jdk
    xorg.libXxf86vm
    gtk3
    glib
    prismlauncher
    php84Packages.composer
    libreoffice
    python313Packages.pip
    python313Packages.pymodbus
    libmodbus
    wine64
    dotnet-sdk
    usql
    nvtopPackages.nvidia 
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

  services.samba = {


  services.openssh.enable = true;

  services.xserver = {
  enable = true;
  xkb.layout = "es";
};
  system.stateVersion = "25.11";
}
