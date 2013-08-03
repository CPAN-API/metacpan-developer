Vagrant::Config.run do |config|

  config.vm.box_url = "http://vmbox.metacpan.org/mcwheezy_vm_base_001_32.box"
  config.vm.box = "mcbase"

  config.vm.provision :shell, :path => 'provision/all.sh'

  config.vm.forward_port 5000, 5000 # api
  config.vm.forward_port 5001, 5001 # www
  config.vm.forward_port 9200, 9200 # production ES
  config.vm.forward_port 9900, 9900 # test ES

  config.vm.share_folder('v-puppet', '/etc/puppet', '../metacpan/metacpan-puppet')
  config.vm.share_folder('v-meta-api', '/home/metacpan/api.metacpan.org', '../metacpan/cpan-api')
  config.vm.share_folder('v-meta-web', '/home/metacpan/metacpan.org', '../metacpan/metacpan-web')
  config.vm.share_folder('v-meta-explore',
  				'/home/metacpan/explorer.metacpan.org',
  				'../metacpan/metacpan-explorer')

end
