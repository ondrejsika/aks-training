infracost:
	infracost breakdown --path . --show-skipped

acr-creds-show:
	terraform output acr

kubeconfig-basic-save:
	terraform output -raw kubeconfig-basic > kubeconfig.basic.yml

kubeconfig-basic-add: kubeconfig-basic-save
	slu k8s config add -p kubeconfig.basic.yml

kubeconfig-ad-save:
	terraform output -raw kubeconfig-ad > kubeconfig.ad.yml

kubeconfig-ad-add: kubeconfig-ad-save
	slu k8s config add -p kubeconfig.ad.yml
