.PHONY: dotfiles
dotfiles:
	@zsh -c "TMUX= NO_DIFF=1 source $$HOME/.files/.zprofile"

