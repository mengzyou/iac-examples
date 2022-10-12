.PHONY: image build-image upload-image
.DEFAULT_GOAL := image

PACKER_VERSION := 1.8.3
LIBVIRT_HYPERVISOR_URI := "qemu:///system"
LIBVIRT_TEMPLATES_IMAGES_POOL := "templates"
LIBVIRT_TEMPLATES_IMAGES_POOL_DIR := "/var/lib/libvirt/images/templates"
LIBVIRT_IMAGE_NAME := "debian11-5.qcow2"
ROOT_PASSWORD := "rootPassword"
$(eval SSH_IDENTITY=$(shell find ~/.ssh/ -name 'id_*' -not -name '*.pub' | head -n 1))

install-packer: ## Install Packer.
	test -f $(LOCAL_BIN)packer || \
	(curl https://releases.hashicorp.com/packer/$(PACKER_VERSION)/packer_$(PACKER_VERSION)_linux_amd64.zip -o /tmp/packer_$(PACKER_VERSION)_linux_amd64.zip; \
	unzip /tmp/packer_$(PACKER_VERSION)_linux_amd64.zip -d $(LOCAL_BIN); \
	rm -f /tmp/packer_$(PACKER_VERSION)_linux_amd64.zip); \
	chmod +x $(LOCAL_BIN)packer

image: build-image upload-image ## Build image with Packer and upload it to libvirt with virsh.

build-image: ## Build image with Packer.
	rm -rf  output/
	$(eval CRYPTED_PASSWORD = $$(shell openssl passwd -6 "$(ROOT_PASSWORD)"))
	sed -r 's@^(d-i passwd\/root-password-crypted password).*@\1 $(CRYPTED_PASSWORD)@g' preseed/debian11.txt > preseed/debian11.txt.password
	ROOT_PASSWORD=$(ROOT_PASSWORD) SSH_PUB_KEY="$(shell cat $(SSH_IDENTITY).pub)" packer build base.pkr.hcl

upload-image: ## Upload image to libvirt with virsh.
	$(eval  size = $(shell stat -Lc%s output/debian11))
	test -d $(LIBVIRT_TEMPLATES_IMAGES_POOL_DIR) || mkdir $(LIBVIRT_TEMPLATES_IMAGES_POOL_DIR)
	virsh -c $(LIBVIRT_HYPERVISOR_URI) pool-create-as $(LIBVIRT_TEMPLATES_IMAGES_POOL) dir --target $(LIBVIRT_TEMPLATES_IMAGES_POOL_DIR) 2>/dev/null || echo "did not create pool"
	virsh -c $(LIBVIRT_HYPERVISOR_URI) pool-start $(LIBVIRT_TEMPLATES_IMAGES_POOL) 2>/dev/null || echo "did not enable pool"
	test ! -e $(LIBVIRT_TEMPLATES_IMAGES_POOL_DIR)/$(LIBVIRT_IMAGE_NAME) || virsh -c $(LIBVIRT_HYPERVISOR_URI) vol-delete --pool $(LIBVIRT_TEMPLATES_IMAGES_POOL) $(LIBVIRT_IMAGE_NAME)
	virsh -c $(LIBVIRT_HYPERVISOR_URI) vol-create-as $(LIBVIRT_TEMPLATES_IMAGES_POOL) $(LIBVIRT_IMAGE_NAME) $(size) --format qcow2 && \
	virsh -c $(LIBVIRT_HYPERVISOR_URI) vol-upload --pool $(LIBVIRT_TEMPLATES_IMAGES_POOL) $(LIBVIRT_IMAGE_NAME) output/debian11
