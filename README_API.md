# Setting up the VM for API developments

Setup everything as per the main [README](README.md)...

- Running the API test suite

    If you have a lot of RAM allocated to your box, you may not need to stop
    the live ElasticSearch.  Otheriwise, if you haven't done so already, bump
    up the RAM allocated to this machine to 1.5 GB.  (We keep the default low
    for the people who only want to work on the metacpan-web repo -- and you'll
    need to halt the VM in order to update the RAM.)  You'll find the memory
    settings in VirtualBox under:

    Settings => System => Motherboard => Base Memory

    If you had to adjust the RAM, bring the VM up again.

    SSH into the box.  Stop the live ElasticSearch and start a test instance,
    as shown.  The '-f' option runs ElasticSearch in the foreground, so after
    about a dozen lines of output, it's ready to go (you won't see a prompt)
    and you can move on to the next step. (Just ^C to stop ElasticSearch when
    you're done.)

    ```bash
    vagrant ssh
    sudo /etc/init.d/elasticsearch stop
    sudo /opt/elasticsearch-0.20.2/bin/elasticsearch -f -Des.http.port=9900 -Des.cluster.name=testing
    ```

    SSH into the box again, and run the tests as shown.

    ```bash
    vagrant ssh
    sudo su metacpan
    cd ~/api.metacpan.org
    source ~/.metacpanrc
    prove -lv t
    ```

    Note that, unlike the metacpan-web test suite, -r has not been passed to
    prove when running the tests.

    Once the test suite has been completed, stop the ElasticSearch test
    instance with a ^C, and re-start the normal ElasticSearch. This should get
    your system back to the state that it was in before you started running the
    API test suite.

    ```bash
    # Test instance of elastic searching running ..
    ^C
    #  Test instance stops, does cleanup and returns you to a bash prompt.
    sudo /etc/init.d/elasticsearch start
    ```

- Setup a CPAN mirror

    If you are working on the API, you will need a CPAN mirror to load into ElasticSearch.  A full CPAN
    mirror is going to take up around 4GB.  A good mirror and a good connection should be able to knock
    that out in a couple of hours.

    If you just want a few files to index (you don't need a full CPAN) run this
    script as the vagrant user.  You'll be ready in a few minutes.

    ```bash
    vagrant ssh
    sh /vagrant/bin/partial-cpan-mirror.sh
    ```

    Need the whole thing?  Read on.

    Log in as metacpan and make sure your Perl path is pointing to Perlbrew:

    ```bash
    sudo su - metacpan    # from vagrant user
    source /home/metacpan/.metacpanrc
    ```

    Use CPAN to find a good mirror:

    ```bash
    cpan -P
    export CPAN_MIRROR=[mirror URL]
    ```

    Then load up CPAN::Mini and download the mirror:

    ```bash
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
        $CPAN_MIRROR/authors/00whois.xml $CPAN_MIRROR/modules/06perms.txt \
        $CPAN_MIRROR/modules/02packages.details.txt.gz
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
    bin/metacpan release /home/metacpan/CPAN/authors/id/

    # Around 60 distros a minute
    # Large/weird files (ie: Alien::Debian::Apt::PM) might timeout ES; re-run it if it chokes
    bin/metacpan latest

    # Easy and quick
    bin/metacpan author
    ```

