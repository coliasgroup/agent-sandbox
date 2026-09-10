{ lib, pkgs, ... }:

let
  mntDir = "/work";

in {
  home.username = "x";
  home.homeDirectory = "/home/x";
  home.stateVersion = "24.11";

  targets.genericLinux.enable = true;

  systemd.user.enable = false;

  nix.enable = true;

  home.sessionVariables = {
    CLAUDE_CONFIG_DIR = "${mntDir}/claude";
    CODEX_HOME = "${mntDir}/codex";
  };

  home.packages = with pkgs; [ 
    less
    vim
    file
    curl
    wget
    nix
    cacert
  ];

  programs.home-manager.enable = true;

  programs.claude-code.enable = true;

  programs.codex.enable = true;
  programs.codex.settings = {
    default_permissions = ":danger-full-access";
    sandbox_mode = "danger-full-access";
    approval_policy = "never";
  };

  programs.git = {
    enable = true;
    settings.user.name = "Nick Spinale";
    settings.user.email = "nick@nickspinale.com";
    settings.core.editor = "vim";
  };

  programs.readline = {
    enable = true;
    variables = {
      editing-mode = "vi";
      show-mode-in-prompt = "on";
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    historySize = 100000;
    historyFileSize = 100000;

    shellAliases = {
      "gs" = "git status";
      "gd" = "git diff";
      "gb" = "git branch";
      "ga" = "git add -A :/";
      "gc" = "git commit";
      "gx" = "gs && ga && gs && gcx";
      "gca" = "git commit --amend";
      "gcx" = "git commit -m x";
      "gcy" = "git commit -m y";
      "gcd" = "git commit -m d";
      "gl" = "git log";
      "gm" = "git submodule update --init --recursive";
      "gri" = "git rebase -i";
      "grc" = "git rebase --continue";
      "gra" = "git rebase --abort";
      "gk" = "git checkout";
      "gkb" = "git checkout -b";
    };

    initExtra = lib.mkMerge [
      ''
        # Prompt

        reset="\[$(tput sgr0)\]"
        symbol="\[$(tput setaf 6)\]"
        text="\[$(tput setaf 2)\]"

        if printf '%s' "$LANG" | egrep -qi 'utf-?8'; then
            lambda='λ'
            arrow='→'
        else
            lambda='\\'
            arrow='->'
        fi

        PS1="$text \u@\h $symbol$lambda$text \w $symbol$arrow$reset "
      ''
      # would ideally be in .profile, but must be after last sourcing of nix.sh
      (lib.mkAfter ''
        if [ -z "''${IN_NIX_SHELL+x}" ]; then
          shell_drv=/work/shell.drv
          if [ -e "$shell_drv" ]; then
            # restore_tmpdir="$(declare -px TMPDIR 2>/dev/null)"
            # eval "$(nix-shell "$shell_drv" --run 'declare -px' 2>/dev/null)"
            # eval "$restore_tmpdir"
            eval "$(nix-shell "$shell_drv" --run 'declare -px' 2>/dev/null | grep -Ev '^declare -x TMP(DIR)?=')"
          fi
        fi
      '')
    ];
  };

}
