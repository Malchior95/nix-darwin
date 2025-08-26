{ pkgs, ... }:
{
  programs.tmux = {
    enable = false;
    baseIndex = 1;
    mouse = true;
    escapeTime = 0;
    keyMode = "vi";
    terminal = "screen-256color";
    extraConfig = ''
      set -g default-terminal "tmux-256color"

      bind -n Ń select-window -t 1
      bind -n ™ select-window -t 2
      bind -n € select-window -t 3
      bind -n ß select-window -t 4
      bind -n į select-window -t 5

      bind -n √ split-window -v
      bind -n ķ split-window -h

      bind -n M-Enter new-window

      set -g @tmux-gruvbox "dark"
    '';
    plugins = with pkgs; [ tmuxPlugins.gruvbox ];
  };
}
