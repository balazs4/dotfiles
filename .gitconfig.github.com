; vim: ft=gitconfig
[user]
  email = balazs4@users.noreply.github.com
  signingkey = ~/.ssh/id_ed25519.pub
[gpg]
  format = ssh
[commit]
  gpgSign = true
[init]
  defaultBranch = main
