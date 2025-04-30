hostname=$(shell hostname -s)
files=$(shell git ls-files | grep -v makefile | grep -v readme.md)

default: $(files)

colors=$(shell cat $(HOME)/.colors \
			 | awk -F: '/base0.?/ {print $$1 $$2} /variant/ {print $$1 $$2}' \
			 | tr -d '"' \
			 | awk -F" " '{ print "s/{{" $$1 "}}/" tolower($$2) "/g"}' \
			 | sed -E 's/(base0.?)/\1-hex/g' \
			 | tr "\n" ";")

.PHONY: $(files)
$(files):
	@mkdir -p `dirname ${HOME}/$(@)`
	@printf '%s' "$(HOME)/$(@)"
	@cat $(HOME)/.files/$(@) \
		| sed -r "s/^[--;#\/\"\!]+$(hostname) //g; /^#(carbon|mcbpro)/d" \
		| sed "$(colors)" > $(HOME)/$(@)
	@printf ' [%s]' "update"
	@$(if $(filter $@, .zshrc),                         printf ' [%s]' "source"; kill -USR1 `pgrep -a zsh | xargs` 2>/dev/null || true)
	@$(if $(filter $@, .tmux.conf),                     printf ' [%s]' "source"; tmux source-file $(HOME)/.tmux.conf 2>/dev/null || true)
	@$(if $(filter $@, .aerospace.toml),                printf ' [%s]' "source"; aerospace reload-config 2>/dev/null || true)
	@$(if $(filter $@, .xbindkeysrc),                   printf ' [%s]' "source"; pkill -SIGKILL xbindkeys; xbindkeys 2>/dev/null || true)
	@$(if $(filter $@, .config/qutebrowser/config.py),  printf ' [%s]' "source"; qutebrowser ':config-source' 2>/dev/null || true)
	@printf '\n'

sync:
	git commit -am "`date +%s`@`hostname -s`"
	git pull
	git push

edit:
	nvim $(file)
	make $(file)
