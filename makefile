all:
	@git ls-files | grep -v -E 'makefile|readme.md' | awk -v prefix=$(HOME) '{print prefix"/"$$0}' | xargs make

colors=$(shell cat $$HOME/.colors \
			 | awk -F: '/base[0|1].?/ {print $$1 $$2} /variant/ {print $$1 $$2} /name/ {print $$1 $$2}  /system/ {print $$1 $$2}' \
			 | tr -d '"|\#' \
			 | awk -F" " '{ print "s/{{" $$1 "}}/" tolower($$2) "/g"}' \
			 | sed -E 's/(base[0|1].?)/\1-hex/g' \
			 | tr "\n" ";")

hostname=$(shell hostname -s)

$(HOME)/%: %
	@mkdir -p $$(dirname $(@))
	@cat $(<) \
		| sed -r "s/^[--;#\/\"\!]+$(hostname) //g; /^#(carbon|mcbpro)/d; s/\{\{hostname\}\}/$(hostname)/g;" \
		| sed "$(colors)" \
		| tee $(@) > /dev/null
	@$(if $(filter $<, .zshrc),                        pgrep -a zsh         1>/dev/null 2>/dev/null && kill -USR1 `pgrep -a zsh  | awk '{print $$1}' | xargs`     || true)
	@$(if $(filter $<, .config/nvim/init.lua),         pgrep -a nvim        1>/dev/null 2>/dev/null && kill -USR1 `pgrep -a nvim | awk '{print $$1}' | xargs`     || true)
	@$(if $(filter $<, .tmux.conf),                    pgrep -a tmux        1>/dev/null 2>/dev/null && tmux source-file $(HOME)/.tmux.conf                        || true)
	@$(if $(filter $<, .aerospace.toml),               which aerospace      1>/dev/null 2>/dev/null && aerospace reload-config --no-gui                           || true)
	@$(if $(filter $<, .xbindkeysrc),                  pgrep -a xbindkeys   1>/dev/null 2>/dev/null && pkill -SIGKILL xbindkeys && xbindkeys                      || true)
	@$(if $(filter $<, .config/qutebrowser/config.py), pgrep -a qutebrowser 1>/dev/null 2>/dev/null && qutebrowser ':config-source' 2>/dev/null                   || true)
	@printf '[dot] %s\n' $(@)

.PHONY: sync
sync:
	git commit -am "`date +%s`@$(hostname)" || true
	git pull || true
	git push || true


