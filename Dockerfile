FROM	debian:jessie-slim

RUN	useradd --create-home --shell /bin/bash --user-group kernelbuild \
	&& apt-get update \
	&& apt-get install -y \
	bc \
	bison \
	build-essential \
	dirmngr \
	file \
	flex \
	gnupg \
	libssl-dev \
	wget \
	&& rm -rf /var/lib/apt/lists/* \
	&& mkdir /kbuild \
	&& chown kernelbuild:kernelbuild /kbuild

COPY	--chown=kernelbuild:kernelbuild \
	arch.sh \
	build-kernel.sh \
	build-modules.sh \
	build-toolchain.sh \
	concur.sh.template \
	configs/paxed-debian-config \
	deb-diff.sh \
	fixed-dir.sh \
	gen-fingerprint.sh \
	gen-x509-key.sh \
	grsecurity-3.1-4.9.24-201704252333.patch.gz \
	grsecurity-3.1-4.9.24-201704252333.patch.sig \
	import-keys.sh \
	modules \
	run.sh \
	try-reproduce.sh \
	ver.sh \
	/home/kernelbuild/scripts/
COPY	--chown=kernelbuild:kernelbuild \
	hacks/ /home/kernelbuild/scripts/hacks/
COPY	--chown=kernelbuild:kernelbuild \
	modules/ /home/kernelbuild/scripts/modules/

USER	kernelbuild:kernelbuild
WORKDIR	/home/kernelbuild
RUN	cd scripts \
	&& cp paxed-debian-config config \
	&& { gpg /dev/null >/dev/null 2>&1 || true; }
#	&& ./import-keys.sh # This fails intermittently
CMD	/bin/bash
