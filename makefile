hostname=$(shell hostname -s)
files=$(shell git ls-files | grep -v makefile | grep -v readme.md)

default: $(files)

colors=$(shell cat $(HOME)/.colors \
			 | awk -F: '/base[0|1].?/ {print $$1 $$2} /variant/ {print $$1 $$2}' \
			 | tr -d '"|#' \
			 | awk -F" " '{ print "s/{{" $$1 "}}/" tolower($$2) "/g"}' \
			 | sed -E 's/(base[0|1].?)/\1-hex/g' \
			 | tr "\n" ";")

.PHONY: $(files)
$(files):
	@mkdir -p `dirname ${HOME}/$(@)`
	@printf '[dot] %s' "$(HOME)/$(@)"
	@cat $(HOME)/.files/$(@) \
		| sed -r "s/^[--;#\/\"\!]+$(hostname) //g; /^#(carbon|mcbpro)/d" \
		| sed "$(colors)" > $(HOME)/$(@)
	@$(if $(filter $@, .zshrc),                        pgrep -a zsh         1>/dev/null 2>/dev/null && kill -USR1 `pgrep -a zsh | awk '{print $$1}' | xargs`      || true)
	@$(if $(filter $@, .tmux.conf),                    pgrep -a tmux        1>/dev/null 2>/dev/null && tmux source-file $(HOME)/.tmux.conf                        || true)
	@$(if $(filter $@, .aerospace.toml),               pgrep -a aerospace   1>/dev/null 2>/dev/null && aerospace reload-config                                    || true)
	@$(if $(filter $@, .xbindkeysrc),                  pgrep -a xbindkeys   1>/dev/null 2>/dev/null && pkill -SIGKILL xbindkeys && xbindkeys                      || true)
	@$(if $(filter $@, .config/qutebrowser/config.py), pgrep -a qutebrowser 1>/dev/null 2>/dev/null && qutebrowser ':config-source'                               || true)
	@printf '\n'

sync:
	git commit -am "`date +%s`@`hostname -s`"
	git pull
	git push

edit:
	nvim $(file)
	make $(file)
