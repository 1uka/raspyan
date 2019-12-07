################################################################################
#
# Vagrantfile
#
################################################################################

# Buildroot version to use
RELEASE='2019.11'

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
			v.vmx['displayname'] = "Pykernel Buildroot #{RELEASE}"
		end

		config.vm.provider :virtualbox do |v, override|
			v.name = "Pykernel Buildroot #{RELEASE}"
		end
	end

	config.vm.provision 'shell', privileged: true, inline:
		"sed -i 's|deb http://us.archive.ubuntu.com/ubuntu/|deb mirror://mirrors.ubuntu.com/mirrors.txt|g' /etc/apt/sources.list
		sed -i '$ a 192.168.0.3 gitlab.pinet.home' /etc/hosts
		sed -i \
			-e 's|^#\?deb-src http://archive.ubuntu.com/ubuntu bionic main restricted|deb-src http://archive.ubuntu.com/ubuntu bionic main restricted|' \
			-e 's|^#\?deb-src http://archive.ubuntu.com/ubuntu bionic universe|deb-src http://archive.ubuntu.com/ubuntu bionic universe|' \
			/etc/apt/sources.list 
		dpkg --add-architecture i386
		apt-get -q update
		apt-get purge -q -y snapd lxcfs lxd ubuntu-core-launcher snap-confine
		apt-get -q -y upgrade
		apt-get -q -y install build-essential libncurses5-dev \
			git bzr cvs mercurial subversion libc6:i386 unzip bc \
			libffi-dev python3.7 python3.7-dev \
			gcc-arm-linux-gnueabihf
		apt-get build-dep python3.7
		apt-get -q -y autoremove
		apt-get -q -y clean
		update-locale LC_ALL=C"

	config.vm.provision 'file', source: '~/.ssh/pykernel_deploy_key', destination: '$HOME/.ssh/pykernel_deploy_key'

	config.vm.provision 'shell', privileged: false, inline:
		"echo 'Downloading and extracting buildroot #{RELEASE}'
		wget -q -c http://buildroot.org/downloads/buildroot-#{RELEASE}.tar.gz
		tar axf buildroot-#{RELEASE}.tar.gz

        cat > ~/.ssh/config << EOF
        Host gitlab.pinet.home
            IdentityFile ~/.ssh/pykernel_deploy_key
        EOF

		echo 'Cloning cpython and linux repositories from git server'
		git clone ssh://git@gitlab.pinet.home:5222/pykernel/cpython.git
		git clone ssh://git@gitlab.pinet.home:5222/pykernel/linux.git
		echo 'Done'"

end
