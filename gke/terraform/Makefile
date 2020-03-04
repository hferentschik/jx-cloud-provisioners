.DEFAULT_GOAL := help

.PHONY: help
help:
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: apply 
apply: ## Applies Terraform plan
	terraform apply --var-file terraform.tfvars

.PHONY: destroy 
apply: ## Destroys Terraform infrastructure
	terraform destroy

.PHONY: lint 
lint: ## Verifies Terraform syntax
	terraform version
	terraform fmt -check -diff
	terraform validate

.PHONY: test 
test: ## Runs ShellSpec tests
	shellspec --format document	

.PHONY: clean
clean: ## Deletes temporary files
	rm -rf report
	rm jx-requirements.yml
			