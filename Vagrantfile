################################################################################
#
# Vagrantfile
#
################################################################################

# Buildroot version to use
BUILDROOT_RELEASE='2019.11'
BUILDROOT_CONFIG='pykernel_qemu_arm_versatile'
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

	config.vm.provision "file", source: "configs/#{BUILDROOT_CONFIG}", destination: "$HOME/#{BUILDROOT_CONFIG}"
	config.vm.provision 'shell', privileged: true, path: "provision/setup.sh", args: "#{PYTHON} #{BUILDROOT_RELEASE}"
	config.vm.provision 'shell', privileged: false, path: "provision/build.sh", args: "#{BUILDROOT_RELEASE} #{BUILDROOT_CONFIG}"
	# config.vm.provision 'shell', privileged: false, path: "provision/build_cpython.sh", args: "#{PYVERSION} #{PYTHON}"

end
