install: targets:=$(shell git ls-files | grep -v -E 'makefile|readme.md|.gitignore' | awk -v prefix=$(HOME) '{print prefix"/"$$0}')
install:
	@$(MAKE) --jobs 16 $(targets)

$(HOME)/%: %
	@mkdir -p $$(dirname $(@))
	@cat $(<) \
		| sed -r "s/^[--;#\/\"\!]+$$(cat /etc/hostname) //g; /^#(carbon|aspire)/d; s/\{\{hostname\}\}/$$(cat /etc/hostname)/g;" \
		| sed "$$(cat .colors)" \
		| tee $(@) > /dev/null
	@$(if $(filter $<, .zshrc),                        pgrep -a zsh         1>/dev/null 2>/dev/null && kill -USR1 `pgrep -a zsh  | awk '{print $$1}' | xargs`                           || true)
	@$(if $(filter $<, .config/nvim/init.lua),         pgrep -a nvim        1>/dev/null 2>/dev/null && kill -USR1 `pgrep -a nvim | awk '{print $$1}' | xargs`                           || true)
	@$(if $(filter $<, .tmux.conf),                    pgrep -a tmux        1>/dev/null 2>/dev/null && tmux source-file $(HOME)/.tmux.conf                                              || true)
	@$(if $(filter $<, .aerospace.toml),               which aerospace      1>/dev/null 2>/dev/null && aerospace reload-config --no-gui                                                 || true)
	@$(if $(filter $<, .config/i3/config),             which i3-msg         1>/dev/null 2>/dev/null && i3-msg restart                                                                   || true)
	@$(if $(filter $<, .i3blocks.conf),                which i3-msg         1>/dev/null 2>/dev/null && i3-msg restart                                                                   || true)
	@$(if $(filter $<, .xbindkeysrc),                  pgrep -a xbindkeys   1>/dev/null 2>/dev/null && pkill -SIGKILL xbindkeys && xbindkeys                                            || true)
	@$(if $(filter $<, .config/qutebrowser/config.py), pgrep -a qutebrowser 1>/dev/null 2>/dev/null && qutebrowser ':config-source' 2>/dev/null                                         || true)
	@$(if $(filter $<, .config/nvim/lsp/bun.lock),     which bun            1>/dev/null 2>/dev/null && bun install --cwd $(HOME)/.config/nvim/lsp/ --frozen-lockfile --ignore-scripts   || true)
	@printf 'made[.]: "%s" is now up to date.\n' $(@)

.PHONY:
chmod:
	find $(HOME)/.local/bin/ -type f -exec chmod 744 {} +

.PHONY: sync
sync:
	@cat /etc/hostname | xargs -t -I{} git commit -am "{}" || true
	git pull || true
	git push || true


.colors: $(HOME)/.cache/schemes
	@git -C $(HOME)/.cache/schemes ls-files \
		| sort \
		| vipe \
		| xargs -I{} cat $(HOME)/.cache/schemes/{} \
		| tee /dev/stderr \
		| awk -F: '/system/{next;} /base[0|1].?/ {print $$1 $$2} /variant/ {print $$1 $$2} /name/ {print $$1 $$2}' \
		| tr -d '"|\#' \
		| awk -F" " '{ print "s/{{" $$1 "}}/" tolower($$2) "/g"}' \
		| sed -E 's/(base[0|1].?)/\1-hex/g' \
		| tr "\n" ";" \
		| tee .colors

$(HOME)/.cache/schemes:
	test -d $(HOME)/.cache/schemes || git clone https://github.com/tinted-theming/schemes.git $(HOME)/.cache/schemes --depth=1
