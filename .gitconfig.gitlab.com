; vim: ft=gitconfig
[user]
	email = 959395-balazs4@users.noreply.gitlab.com
  signingkey = ~/.ssh/id_ed25519.pub
[gpg]
  format = ssh
[commit]
  gpgSign = true
[init]
  defaultBranch = main
