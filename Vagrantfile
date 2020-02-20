################################################################################
#
# Vagrantfile
#
################################################################################

# Buildroot version to use
BUILDROOT_RELEASE='2019.11'
PYVERSION='3.7'
PYTHON="python#{PYVERSION}"

### Change here for more memory/cores ###
VM_MEMORY=2048
VM_CORES=1

Vagrant.configure('2') do |config|
	config.vm.box = 'ubuntu/bionic64'

	config.vm.provider :vmware_fusion do |v, override|
		v.vmx['memsize'] = VM_MEMORY
		v.vmx['numvcpus'] = VM_CORES
	end

	config.vm.provider :virtualbox do |v, override|
		v.memory = VM_MEMORY
		v.cpus = VM_CORES

		required_plugins = %w( vagrant-vbguest )
		required_plugins.each do |plugin|
		  system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
		end
	end

	config.vm.provision 'shell' do |s|
		s.inline = 'echo Setting up machine name'

		config.vm.provider :vmware_fusion do |v, override|
			v.vmx['displayname'] = "Pykernel Buildroot"
		end

		config.vm.provider :virtualbox do |v, override|
			v.name = "Pykernel Buildroot"
		end
	end

	config.vm.provision 'shell', privileged: true, inline:
		"sed -i 's|deb http://us.archive.ubuntu.com/ubuntu/|deb mirror://mirrors.ubuntu.com/mirrors.txt|g' /etc/apt/sources.list
		sed -i \
			-e 's|^#\?deb-src http://archive.ubuntu.com/ubuntu bionic main restricted|deb-src http://archive.ubuntu.com/ubuntu bionic main restricted|' \
			-e 's|^#\?deb-src http://archive.ubuntu.com/ubuntu bionic universe|deb-src http://archive.ubuntu.com/ubuntu bionic universe|' \
			/etc/apt/sources.list 
		sed -i -e 's|^deb |deb \[arch=amd64,i386\] |g' -e 's|^deb-src |deb-src \[arch=amd64,i386\] |g' /etc/apt/sources.list
		sed -i \
			-e '$ a deb [arch=armhf] http://ports.ubuntu.com/ bionic main multiverse restricted universe' \
			-e '$ a deb [arch=armhf] http://ports.ubuntu.com/ bionic-updates main multiverse restricted universe' \
			-e '$ a deb-src [arch=armhf] http://ports.ubuntu.com/ bionic main multiverse restricted universe' \
			-e '$ a deb-src [arch=armhf] http://ports.ubuntu.com/ bionic-updates main multiverse restricted universe' \
			/etc/apt/sources.list
		dpkg --add-architecture i386
		dpkg --add-architecture armhf
		apt-get -q update
		apt-get purge -q -y snapd lxcfs lxd ubuntu-core-launcher snap-confine
		apt-get -q -y upgrade
		apt-get -q -y install build-essential libncurses5-dev \
			git bzr cvs mercurial subversion libc6:i386 unzip bc \
			libffi-dev libssl-dev #{PYTHON} #{PYTHON}-dev \
			binutils-multiarch gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf
		apt-get -q -y install libssl-dev:armhf libffi-dev:armhf \
			liblzma-dev:armhf libbz2-dev:armhf libgdbm-dev:armhf \
			libreadline-dev:armhf libsqlite3-dev:armhf zlib1g-dev:armhf \
			uuid-dev:armhf tk-dev:armhf libncurses5-dev:armhf
		apt-get -q -y build-dep #{PYTHON}
		apt-get -q -y build-dep #{PYTHON}:armhf
		apt-get -q -y autoremove
		apt-get -q -y clean
		update-locale LC_ALL=C"

	config.vm.provision 'shell', privileged: false, inline:
		"echo 'Downloading and extracting buildroot #{BUILDROOT_RELEASE}'
		wget -q -c http://buildroot.org/downloads/buildroot-#{BUILDROOT_RELEASE}.tar.gz
		tar axf buildroot-#{BUILDROOT_RELEASE}.tar.gz
		echo 'Cloning cpython from git'
		git clone https://github.com/1uka/cpython.git
		cd cpython
		git checkout pykernel-#{PYVERSION}-integration
		chmod +x crossbuild.sh
        mkdir #{PYTHON}-build
		./crossbuild.sh -t arm-linux -a gnueabihf -o /tmp/#{PYTHON}-build
        mv /tmp/#{PYTHON}-build/#{PYTHON}-arm-linux-gnueabihf.tar.gz /vagrant/
		echo 'Done'"

end
