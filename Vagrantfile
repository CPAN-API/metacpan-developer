Vagrant.configure("2") do |config|
  config.vm.box_url = "http://vmbox.metacpan.org/mcwheezy_vm_base_001_32.box"
  config.vm.box = "mcbase"

  config.vm.provision :shell, :path => 'provision/all.sh'
  config.vm.provision :shell, :path => 'provision/carton.sh', :privileged => false

  config.vm.network "forwarded_port", guest: 5000, host: 5000 # api
  config.vm.network "forwarded_port", guest: 5001, host: 5001 # www
  config.vm.network "forwarded_port", guest: 80, host: 5080 # nginx
  config.vm.network "forwarded_port", guest: 9200, host: 9200 # production ES
  config.vm.network "forwarded_port", guest: 9900, host: 9900 # test ES

  config.vm.synced_folder('src/metacpan-puppet', '/etc/puppet')
  config.vm.synced_folder('src/cpan-api', '/home/metacpan/api.metacpan.org')
  config.vm.synced_folder('src/metacpan-web', '/home/metacpan/metacpan.org')
  config.vm.synced_folder('src/metacpan-explorer', '/home/metacpan/explorer.metacpan.org')
end
