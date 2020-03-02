################################################################################
#
# Vagrantfile
#
################################################################################

BUILDROOT_DEFCONFIG='raspberrypi2_raspyan_defconfig'

### Change here for more memory/cores ###
VM_MEMORY=2048
VM_CORES=2

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

	config.vm.provision :shell do |s|
		s.inline = 'echo Setting up machine name'

		config.vm.provider :vmware_fusion do |v, override|
			v.vmx['displayname'] = "Raspyan Buildroot"
		end

		config.vm.provider :virtualbox do |v, override|
			v.name = "Raspyan Buildroot"
		end
	end

	config.vm.provision :shell, path: "provision/setup.sh", privileged: true
	config.vm.provision :shell, path: "provision/build.sh", args: "#{BUILDROOT_DEFCONFIG}", privileged: false

end
