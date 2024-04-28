fmt:
	prettier --write .
	terraform fmt -recursive

fmt-check:
	prettier --check .
	terraform fmt -recursive -check

setup-git-hooks:
	rm -rf .git/hooks
	(cd .git && ln -s ../.git-hooks hooks)

git-pre-commit:
	@make fmt-check
