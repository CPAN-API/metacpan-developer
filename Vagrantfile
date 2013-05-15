Vagrant::Config.run do |config|

  config.vm.box_url = "https://dl.dropboxusercontent.com/u/86959817/mc_base001.box"
  config.vm.box = "mcbase"

  config.vm.provision :shell, :path => 'provision.sh'

  config.vm.forward_port 5000, 5000 # api
  config.vm.forward_port 5001, 5001 # www

  config.vm.share_folder('v-puppet', '/etc/puppet', '../metacpan/metacpan-puppet')
  config.vm.share_folder('v-meta-api', '/home/metacpan/api.metacpan.org', '../metacpan/cpan-api')
  config.vm.share_folder('v-meta-web', '/home/metacpan/metacpan.org', '../metacpan/metacpan-web')
end
