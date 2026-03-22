{ config, pkgs, ... }:

{
  home.username = "pablo";
  home.homeDirectory = "/home/pablo";
  home.stateVersion = "25.11";

  home.file.".xinitrc" = {
    executable = true;
    text = ''
      xsetroot -solid black
      while true; do
        xsetroot -name "$(date +"%F %R")"
        sleep 1m
      done &
      exec dwm
    '';
  };

  home.file.".yashrc" = {
    source = /etc/nixos/yashrc;
  };

  home.file.".vimrc" = {
    text = ''
      :set number
      :set autoindent
      syntax off
      map t :below term
      map z :vert sp
      map c :s/^/\/\/<CR><CR>
    '';
  };
}
