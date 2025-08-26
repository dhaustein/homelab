.PHONY: help install lint format lint-ansible lint-python

# vars
VENV_DIR := .venv
VENV_STAMP := $(VENV_DIR)/.synced

# should respect direnv's VIRTUAL_ENV if it's set
VENV_BIN := $(if $(VIRTUAL_ENV),$(VIRTUAL_ENV)/bin,$(VENV_DIR)/bin)
ANSIBLE_GALAXY := $(VENV_BIN)/ansible-galaxy
ANSIBLE_LINT := $(VENV_BIN)/ansible-lint
RUFF := $(VENV_BIN)/ruff

help:
	@echo "Makefile for my Ansible Homelab project"
	@echo ""
	@echo "Usage:"
	@echo "  make install      - Create virtual environment and install dependencies"
	@echo "  make lint         - Run all linters (ansible-lint, ruff)"
	@echo "  make lint-ansible - Run ansible-lint"
	@echo "  make lint-python  - Run ruff linter"
	@echo "  make format       - Run ruff formatter"
	@echo ""

# Installation
# set up the virtual environment and install dependencies
install: $(VENV_STAMP)
	@echo "Checking for Ansible collections..."
	@if ! $(ANSIBLE_GALAXY) collection list | grep -q 'community.general'; then \
		echo "Installing community.general collection..."; \
		$(ANSIBLE_GALAXY) collection install community.general; \
	else \
		echo "community.general collection is already installed."; \
	fi

# ensures the venv exists and dependencies are synced
# uses a stamp file in the venv dir to track whether sync has been run
$(VENV_STAMP): pyproject.toml
	@if [ ! -d "$(VENV_DIR)" ]; then \
		echo "Creating virtual environment at $(VENV_DIR)..."; \
		uv venv; \
	fi
	@echo "Syncing dependencies..."
	uv sync
	@touch $(VENV_STAMP)

# Linting
lint: lint-ansible lint-python

lint-ansible: install
	@echo "Running ansible-lint..."
	$(ANSIBLE_LINT)

lint-python: install
	@echo "Running ruff linter..."
	$(RUFF) check .

# Formatting
format: install
	@echo "Running ruff formatter..."
	$(RUFF) format .
