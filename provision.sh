# Break open the var cache here for metacpan.org
mkdir -p /tmp/meta_var/tmp
chmod -R 777 /tmp/meta_var
ln -s /tmp/meta_var /home/metacpan/metacpan.org/var

# Sort out puppet's ssl dir so it can be written to
ssldir=/etc/puppet/ssl
mkdir -p $ssldir

ssl_bind_src=/etc/puppet-ssl
mkdir -p $ssl_bind_src
chown puppet:puppet $ssl_bind_src

mount --bind $ssl_bind_src $ssldir
chown -R puppet:puppet $ssldir

# Run puppet to cleanup and check everything is running
/etc/puppet/run.sh
