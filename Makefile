# Get directory of this file. https://stackoverflow.com/a/23324703
NIXOS_CONFIG_PATH:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

# Need --impure in order to pass in NIXOS_CONFIG_PATH

boot:
	sudo NIXOS_CONFIG_PATH=$(NIXOS_CONFIG_PATH) nixos-rebuild boot --flake . --impure

default:
	sudo NIXOS_CONFIG_PATH=$(NIXOS_CONFIG_PATH) nixos-rebuild test --flake . --impure

check:
	sudo NIXOS_CONFIG_PATH=$(NIXOS_CONFIG_PATH) nixos-rebuild dry-build --flake . --impure

switch:
	sudo NIXOS_CONFIG_PATH=$(NIXOS_CONFIG_PATH) nixos-rebuild switch --flake . --impure

test:
	sudo NIXOS_CONFIG_PATH=$(NIXOS_CONFIG_PATH) nixos-rebuild test --flake . --impure

upgrade:
	nix flake update
	sudo NIXOS_CONFIG_PATH=$(NIXOS_CONFIG_PATH) nixos-rebuild test --upgrade --flake . --impure
