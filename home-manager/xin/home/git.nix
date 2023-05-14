{ inputs, outputs, lib, config, pkgs, ... }: {

  package = pkgs.gitFull;
  lfs.enable = true;
  userName = "Que";
  userEmail = "git@ironshark.org";
  ignores = [
    "*~"
    ".*~"
    "#*#"
    "'#*#'"
    ".*.swp"
  ];
  aliases = {
    send = "! git status &&
echo -n \"Commit Message: \" &&
read -r commitMessage &&
git add . &&
git commit -m \"$commitMessage\" &&
git push";
  };
  extraConfig = {
    init = {
      defaultBranch = "main";
      pull = {
        rebase = true;
      };
    };
  };
}
