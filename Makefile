DEBIAN_BOXES= buster stretch
UBUNTU_BOXES= xenial
TODAY=$(shell date -u +"%Y-%m-%d")

# Replace i686 with i386 and x86_64 with amd64
ARCH=$(shell uname -m | sed -e "s/68/38/" | sed -e "s/x86_64/amd64/")

default:

all: debian ubuntu

debian: $(DEBIAN_BOXES)
ubuntu: $(UBUNTU_BOXES)

$(DEBIAN_BOXES): CONTAINER = "vagrant-base-${@}-$(ARCH)"
$(DEBIAN_BOXES): PACKAGE = "output/${TODAY}/vagrant-lxc-${@}-$(ARCH).box"
$(DEBIAN_BOXES):
	@mkdir -p $$(dirname $(PACKAGE))
	@./mk-debian.sh debian $(@) $(ARCH) $(CONTAINER) $(PACKAGE)
	@chmod +rw $(PACKAGE)

$(UBUNTU_BOXES): CONTAINER = "vagrant-base-${@}-$(ARCH)"
$(UBUNTU_BOXES): PACKAGE = "output/${TODAY}/vagrant-lxc-${@}-$(ARCH).box"
$(UBUNTU_BOXES):
	@mkdir -p $$(dirname $(PACKAGE))
	@./mk-debian.sh ubuntu $(@) $(ARCH) $(CONTAINER) $(PACKAGE)
	@chmod +rw $(PACKAGE)

clean: ALL_BOXES = ${DEBIAN_BOXES} ${UBUNTU_BOXES}
clean:
	@for r in $(ALL_BOXES); do \
		./clean.sh $${r}\
			vagrant-base-$${r}-$(ARCH) \
			output/${TODAY}/vagrant-lxc-$${r}-$(ARCH).box; \
	done
