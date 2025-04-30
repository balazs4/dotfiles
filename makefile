hostname=$(shell hostname -s)
files=$(shell git ls-files)

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
	@printf ' [%s]\n' "updated"
	@$(if $(filter $@, .zshrc), kill -USR1 `pgrep zsh` 2>/dev/null)
