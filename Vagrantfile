Vagrant::Config.run do |config|

  config.vm.box_url = "http://vmbox.metacpan.org/mcwheezy_vm_base_001_32.box"
  config.vm.box = "mcbase"

  config.vm.provision :shell, :path => 'provision/all.sh'


  # Do 'vagrant ssh' as 'metacpan' user for ease of use.
  # Until we generate a vm that has the authorized_keys we need to fix it with a provisioner.
  # So we need a way to identify (outside of the vm) if this has been done.
  # Compare mtime to vm id file to re-sync after a destroy/reimport.
  ssh_as_metacpan_files = %w[.vagrant_ssh_as_metacpan_user .vagrant/machines/default/virtualbox/id].map do |file|
    # Use mtime if exists, else use 0 for root file and now for vbox id so cmp fails if either is missing.
    File.exists?(file) ? File.mtime(file).to_i : file =~ %r{/} ? Time.now.to_i : 0
  end

  if ssh_as_metacpan_files[0] >= ssh_as_metacpan_files[1]
    config.ssh.username = 'metacpan'
  else
    config.vm.provision :shell,
      :inline => '/bin/cp -f /home/{vagrant,metacpan}/.ssh/authorized_keys && touch /vagrant/.vagrant_ssh_as_metacpan_user'
  end


  config.vm.forward_port 5000, 5000 # api
  config.vm.forward_port 5001, 5001 # www
  config.vm.forward_port 80,   5080 # nginx
  config.vm.forward_port 9200, 9200 # production ES
  config.vm.forward_port 9900, 9900 # test ES

  config.vm.share_folder('v-puppet', '/etc/puppet', '../metacpan/metacpan-puppet')
  config.vm.share_folder('v-meta-api', '/home/metacpan/api.metacpan.org', '../metacpan/cpan-api')
  config.vm.share_folder('v-meta-web', '/home/metacpan/metacpan.org', '../metacpan/metacpan-web')
  config.vm.share_folder('v-meta-explore',
  				'/home/metacpan/explorer.metacpan.org',
  				'../metacpan/metacpan-explorer')

end
