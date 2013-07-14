# Virtual development machine for the metacpan project

## We are still testing this setup...

- You will need:

    - [Vagrant](http://downloads.vagrantup.com/) (1.2.2 or later)
    - [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (4.2.12 or later)
    - [A git client](http://git-scm.com/downloads)
    - An ssh client if not build in, [Windows users see
      this](http://docs-v1.vagrantup.com/v1/docs/getting-started/ssh.html).
    - To be able to download about 900MB of data on the first run

-  Check out this repo.

    ```bash
    git clone git://github.com/CPAN-API/metacpan-developer.git
    ```

-  Set Up repositories

    Make a 'metacpan' directory at the same level and check out the
    repositories which will be shared into the virtual machine
    to create a structure like this:

        ├── metacpan
        │   ├── cpan-api
        │   ├── metacpan-explorer
        │   ├── metacpan-puppet
        │   └── metacpan-web
        └── metacpan-developer

    Below we are
    cloning the official repositories as read only - you could of course either
    fork any of these, or just add your own fork as a remote to push to.

    ```bash
    mkdir metacpan
    cd metacpan
    git clone git://github.com/CPAN-API/metacpan-puppet.git
    git clone git://github.com/CPAN-API/cpan-api.git
    git clone git://github.com/CPAN-API/metacpan-web.git
    git clone git://github.com/CPAN-API/metacpan-explorer.git

    cd ../metacpan-developer
    ```

- Start the virtual machine (first run will download our .box disk image
  ~900MB)

    ```bash
    vagrant up
    ```

- Connect to the vm and run our puppet setup.

    ```bash
    vagrant ssh
    sudo su -     # to become root
    ```

- To edit and test

    Your workflow from this point will be to edit the MetaCPAN repositories
    which you have just checkout out to your local machine.  After you have
    made your changes, you can ssh to your box and restart the relevant
    services.  You will not develop on the VM directly.  (See below for
    instructions on how to run puppet).

    To install any missing (newly required) perl modules, as root run

    ```bash
    cd <to the mount as listed below>
    /home/metacpan/bin/install_modules --installdeps .
    ```

    - metacpan-web is the web front end
        - mounted as /home/metacpan/metacpan.org
        - service metacpan-www restart
    - cpan-api is the backend that talks to the elasticsearch
        - mounted as /home/metacpan/api.metacpan.org
        - service metacpan-api restart
    - metacpan-puppet is the sysadmin/server setup
        - mounted as /etc/puppet
        - /etc/puppet/run.sh

- To edit and test

    Make changes in your checked out 'metacpan' repos and restart the service or use the run.sh script for puppet

- To connect to services on the VM

    WEB: [http://localhost:5001/](http://localhost:5001/)

    API: [http://localhost:5000/](http://localhost:5000/)

    SSH: `vagrant ssh`

- Running the metacpan-web test suite

    You'll want to run the suite at least once before getting started to make sure the VM has a clean bill of health.
    
    ```bash
    vagrant ssh
    sudo su metacpan
    cd ~/metacpan.org
    source ~/.metacpanrc
    prove -lvr t
    ```
    
    If you're not planning to work on the API itself, congratulations!  You're ready to start hacking.  If you do
    need to work on the VM, please read on.
    
- Running the API test suite

    SSH into the box.  Stop the live ElasticSearch and start a test instance.  If you have a lot of RAM allocated 
    to your box, you may not need to stop the live ElasticSearch.  If you haven't done so already, bump up the RAM
    allocated to this machine to 1.5 GB.  (We keep the default low for the people who only want to work on the 
    metacpan-web repo).  You'll find the memory settings in VirtualBox under:
    
    Settings => System => Motherboard => Base Memory

    ```bash
    vagrant ssh
    sudo /etc/init.d/elasticsearch stop
    sudo /opt/elasticsearch-0.20.2/bin/elasticsearch -f -Des.http.port=9900 -Des.cluster.name=testing

    sudo su metacpan
    cd ~/api.metacpan.org
    source ~/.metacpanrc
    prove -lv t
    ```
    
    Note that -r has not been passed to prove when running the tests.

- Setup a CPAN mirror

    If you are working on the API, you will need a CPAN mirror to load into ElasticSearch.  A full CPAN
    mirror is going to take up around 4GB.  A good mirror and a good connection should be able to knock
    that out in a couple of hours.
    
    Log in as metacpan and make sure your Perl path is pointing to Perlbrew:

    ```bash
    sudo su - metacpan    # from vagrant user
    source /home/metacpan/.metacpanrc
    ```
        
    Use CPAN to find a good mirror:
    
    ```bash
    cpanm -n CPAN
    cpan -P
    export CPAN_MIRROR=[mirror URL]
    ```

    Then load up CPAN::Mini and download the mirror: 
    
    ```bash
    cpanm CPAN::Mini
    minicpan -l /home/metacpan/CPAN -r $CPAN_MIRROR
    wget -O /home/metacpan/CPAN/authors/00whois.xml $CPAN_MIRROR/authors/00whois.xml
    wget -O /home/metacpan/CPAN/modules/06perms.txt $CPAN_MIRROR/modules/06perms.txt
    # You only need the --cut-dir param if the CPAN_MIRROR has some directory like /CPAN/ on it
    wget -P /home/metacpan/CPAN -nv -e robots=off -nH --cut-dir=1 -r -l 1 $CPAN_MIRROR/indices/
    ```
    
    If you don't need/want a full mirror, you might want to consider something like WorePAN.  (Doc patches
    welcome for instructions on that.)  Or maybe a partial wget command, like:
    
    ```bash
    wget -P /home/metacpan/CPAN -nv -e robots=off -nH --cut-dir=1 -r -l 3 -nc -np \
        --reject "index.html" $CPAN_MIRROR/authors/id/S/ $CPAN_MIRROR/indices/ \
        $CPAN_MIRROR/authors/00whois.xml $CPAN_MIRROR/modules/06perms.txt
    ```

- Initialize the API

    Oh, you want to actually ***use*** your new CPAN mirror?  Well, that's going to take some adjustments to 
    the VirtualBox.
    
    First, make sure the VM is down via `vagrant halt`.  Fire up VirtualBox manager (not Vagrant) and
    change the following settings:
    
    * **Memory:** 1.5GB or more
    * **CPU:** Half of your total cores
    
    Both of these settings greatly increase how fast the API loading takes, and in the case of memory, 
    impacts whether ES can even operate within the footprint.
    
    ```bash
    # Boot it back up
    vagrant up && vagrant ssh
    
    # Upgrade ES's memory
    sudo su
    vi /etc/puppet/modules/elasticsearch/manifests/init.pp  # or find it in your linked puppet repo
    # set $memory = 1024 and save
    /etc/puppet/run.sh
    ```
    
    Now, you are ready to run through the API loader commands.  Depending on how much data you want to
    load, it's going to take a while to process.  Processing times and other hints are listed below,
    though YMMV.
    
    ```bash
    sudo su - metacpan
    cd /home/metacpan/api.metacpan.org
    
    # Easy and quick
    bin/metacpan mapping --delete
    
    # Release processing will be the most time consuming
    # Around 10-15 distros a minute, or 40-50 hours for a full load
    # Use the --age parameter for partial loading (like --age 4320 for six months)
    bin/metacpan release /usr/share/mirrors/cpan/authors/id/
    
    # Around 60 distros a minute
    # Large/weird files (ie: Alien::Debian::Apt::PM) might timeout ES; re-run it if it chokes
    bin/metacpan latest
    
    # Easy and quick
    bin/metacpan author
    ```

- Problems?

    See our [HELP](HELP.md) page, or ask on #metacpan (irc.perl.org), or open
    an [issue](https://github.com/CPAN-API/metacpan-developer/issues)


