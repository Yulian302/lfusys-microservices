.PHONY: update-submodules-auto
update-submodules-auto:
	@echo "Auto-detecting and updating all submodules..."
	@# Get list of all submodule paths
	@submodules=$$(git config --file .gitmodules --get-regexp path | awk '{print $$2}'); \
	if [ -z "$$submodules" ]; then \
		echo "No submodules found"; \
		exit 0; \
	fi; \
	echo "Found submodules: $$submodules"; \
	for sub in $$submodules; do \
		if [ -d "$$sub" ]; then \
			echo "=== Updating $$sub ==="; \
			$(MAKE) update-submodule SUBMODULE=$$sub || echo "Failed to update $$sub, continuing..."; \
		else \
			echo "Skipping $$sub (directory not found)"; \
		fi; \
	done
	@echo "All submodules updated successfully"

.PHONY: update-submodule
update-submodule:
	@if [ -z "$(SUBMODULE)" ]; then echo "Usage: make update-submodule SUBMODULE=<name>"; exit 1;fi
	git add $(SUBMODULE)
	git commit -m "sub: add submodule $(SUBMODULE) to latest commit"
	git push origin master

