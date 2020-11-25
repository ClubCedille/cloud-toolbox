# FROM alpine:3.12
FROM docker:stable-dind

# Set maintainer label
LABEL maintainer="Club CEDILLE"

# Alpine packages installation & updates
RUN apk update && \
	apk add curl wget openssl unzip bash ca-certificates git python3 make colordiff --upgrade

# ENV variables
ENV KUSTOMIZE_VERSION=3.8.7 \
	KUBECTL_VERSION=1.19.4 \
	TERRAFORM_VERSION=0.13.5

# Create folder for Terraform plugins
RUN mkdir -p ~/.terraform.d/plugins

# Install Terraform
RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
	unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin && \
	rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
	chmod +x /usr/local/bin/terraform

# Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
	mv kubectl /usr/local/bin/kubectl && \
	chmod +x /usr/local/bin/kubectl

# Install kustomize
RUN curl -s https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh | bash -s ${KUSTOMIZE_VERSION} && \
	mv kustomize /usr/local/bin/kustomize && \
	chmod +x /usr/local/bin/kustomize

# Install gcloud
RUN curl -s https://sdk.cloud.google.com | bash