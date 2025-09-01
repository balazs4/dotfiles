hostname=$(shell hostname -s)

all:
	@git ls-files | grep -v -E 'makefile|readme.md|.gitignore' | awk -v prefix=$(HOME) '{print prefix"/"$$0}' | xargs make

$(HOME)/%: % .colors .hostname
	@mkdir -p $$(dirname $(@))
	@cat $(<) \
		| sed -r "s/^[--;#\/\"\!]+$(file < .hostname) //g; /^#(carbon|mcbpro)/d; s/\{\{hostname\}\}/$(file < .hostname)/g;" \
		| sed "$(file < .colors)" \
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
	git commit -am "`date +%s`@$(file < .hostname)" || true
	git pull || true
	git push || true

.hostname:
	@hostname -s | tee .hostname

.colors: $(HOME)/.cache/schemes
	@git -C $(HOME)/.cache/schemes ls-files \
		| sort \
		| fzf --reverse \
		| xargs -I{} cat $(HOME)/.cache/schemes/{} \
		| tee /dev/stderr \
		| awk -F: '/base[0|1].?/ {print $$1 $$2} /variant/ {print $$1 $$2} /name/ {print $$1 $$2}  /system/ {print $$1 $$2}' \
		| tr -d '"|\#' \
		| awk -F" " '{ print "s/{{" $$1 "}}/" tolower($$2) "/g"}' \
		| sed -E 's/(base[0|1].?)/\1-hex/g' \
		| tr "\n" ";" \
		| tee .colors

$(HOME)/.cache/schemes:
	git clone git@github.com:tinted-theming/schemes.git $$HOME/.cache/schemes --depth=1

