
PROFILE ?= default/linux/amd64/17.0
PORTAGE_DIR ?= /usr/portage

.PHONY: ebuildtester
ebuildtester:
	ebuildtester --profile=$(PROFILE) --portage-dir=$(PORTAGE_DIR) --overlay-dir . --update=yes --manual
