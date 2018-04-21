ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

Vagrant.configure("2") do |config|

    config.vm.box = "debian/stretch64"

    # Use METACPAN_DEVELOPER_* env vars to set vm hardware resources.
    vbox_custom = %w[cpus memory].map do |hw|
        key = "METACPAN_DEVELOPER_#{hw.upcase}"
        ENV[key] ? ["--#{hw}", ENV[key]] : []
    end.flatten

$msg = <<MSG
------------------------------------------------------
The API is available on port 5000
The web front end is available on port 5001
------------------------------------------------------
MSG

    config.vm.post_up_message = $msg

    config.vm.provider :virtualbox do |vb|
        vb.name = "metacpan-stretch"
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        if not vbox_custom.empty?
            vb.customize [ "modifyvm", :id, *vbox_custom ]
        end
    end

    config.vm.network "forwarded_port", guest: 5000, host: 5000 # api
    config.vm.network "forwarded_port", guest: 5001, host: 5001 # www
    config.vm.network "forwarded_port", guest: 5002, host: 5002 # gmc
    config.vm.network "forwarded_port", guest: 80, host: 5080 # nginx http
    config.vm.network "forwarded_port", guest: 443, host: 5443 # nginx https
    config.vm.network "forwarded_port", guest: 9200, host: 9200 # production ES
    config.vm.network "forwarded_port", guest: 9900, host: 9900 # test ES

    config.vm.synced_folder '.', '/vagrant', disabled: true
    config.vm.synced_folder "bin", "/vagrant/bin"
    config.vm.synced_folder "src/metacpan-puppet", "/etc/puppet", owner: "puppet", group: "puppet"
    config.vm.synced_folder "src/metacpan-api", "/home/vagrant/metacpan-api"
    config.vm.synced_folder "src/metacpan-web", "/home/vagrant/metacpan-web"
    config.vm.synced_folder "src/metacpan-explorer", "/home/vagrant/metacpan-explorer"
    config.vm.synced_folder "src/github-meets-cpan", "/home/vagrant/github-meets-cpan"

    config.vm.provision :shell, :path => 'provision/all.sh'
end
