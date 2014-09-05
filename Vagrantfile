Vagrant.configure("2") do |config|
  config.vm.box_url = "http://vmbox.metacpan.org/mcwheezy_vm_debian_004_32.box"
  config.vm.box = "mcbase_004"

  # Use METACPAN_DEVELOPER_* env vars to set vm hardware resources.
  vbox_custom = %w[cpus memory].map do |hw|
    key = "METACPAN_DEVELOPER_#{hw.upcase}"
    ENV[key] ? ["--#{hw}", ENV[key]] : []
  end.flatten

  if not vbox_custom.empty?
    config.vm.provider :virtualbox do |vb|
      vb.customize [
        "modifyvm", :id,
        *vbox_custom
      ]
    end
  end

  config.vm.provision :shell, :path => 'provision/all.sh'

  config.vm.network "forwarded_port", guest: 5000, host: 5000 # api
  config.vm.network "forwarded_port", guest: 5001, host: 5001 # www
  config.vm.network "forwarded_port", guest: 80, host: 5080 # nginx http
  config.vm.network "forwarded_port", guest: 443, host: 5443 # nginx https
  config.vm.network "forwarded_port", guest: 9200, host: 9200 # production ES
  config.vm.network "forwarded_port", guest: 9900, host: 9900 # test ES

  config.vm.synced_folder('src/metacpan-puppet', '/etc/puppet')
  config.vm.synced_folder('src/metacpan-api', '/home/metacpan/metacpan-api')
  config.vm.synced_folder('src/metacpan-web', '/home/metacpan/metacpan-web')
  config.vm.synced_folder('src/metacpan-explorer', '/home/metacpan/metacpan-explorer')
end
