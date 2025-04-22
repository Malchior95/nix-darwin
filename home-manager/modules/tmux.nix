{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    mouse = true;
    escapeTime = 0;
    keyMode = "vi";
    terminal = "screen-256color";
    extraConfig = ''
      bind -n Ń select-window -t 1
      bind -n ™ select-window -t 2
      bind -n € select-window -t 3
      bind -n ß select-window -t 4
      bind -n į select-window -t 5

      bind -n √ split-window -v
      bind -n ķ split-window -h

      bind -n M-Enter new-window
    '';
    plugins = with pkgs; [
      tmuxPlugins.gruvbox
      # {
      #   plugin = tmuxPlugins.resurrect;
      #   extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      # }
      # {
      #   plugin = tmuxPlugins.continuum;
      #   extraConfig = ''
      # set -g @continuum-restore 'on'
      # set -g @continuum-save-interval '60' # minutes
      #   '';
      # }
    ];
  };
}
