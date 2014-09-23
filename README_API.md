# Setting up the VM for API developments

Setup everything as per the main [README](README.md)...

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

    Use CPAN to find a good mirror:

    ```bash
    cpan -P
    export CPAN_MIRROR=[mirror URL]
    ```

    Then load up CPAN::Mini and download the mirror:

    ```bash
    export MINICPAN=$HOME/CPAN
    minicpan -l $MINICPAN -r $CPAN_MIRROR
    wget -O $MINICPAN/authors/00whois.xml $CPAN_MIRROR/authors/00whois.xml
    wget -O $MINICPAN/modules/06perms.txt $CPAN_MIRROR/modules/06perms.txt
    # You only need the --cut-dir param if the CPAN_MIRROR has some directory like /CPAN/ on it
    wget -P $MINICPAN -nv -e robots=off -nH --cut-dir=1 -r -l 1 $CPAN_MIRROR/indices/
    ```

    If you don't need/want a full mirror, you might want to consider something like WorePAN.  (Doc patches
    welcome for instructions on that.)  Or maybe a partial wget command, like:

    ```bash
    wget -P $MINICPAN -nv -e robots=off -nH --cut-dir=1 -r -l 3 -nc -np \
        --reject "index.html" $CPAN_MIRROR/authors/id/S/ $CPAN_MIRROR/indices/ \
        $CPAN_MIRROR/authors/00whois.xml $CPAN_MIRROR/modules/06perms.txt \
        $CPAN_MIRROR/modules/02packages.details.txt.gz
    ```

- Initialize the API

    Oh, you want to actually ***use*** your new CPAN mirror?  Well, that's going to take some adjustments to
    the VirtualBox.

    You can change the amount of memory and the number of CPUs assigned to your vm
    by setting some simple environment variables:

    ```bash
    METACPAN_DEVELOPER_MEMORY=1536 METACPAN_DEVELOPER_CPUS=2 vagrant reload
    ```

    The `vagrant reload` command is a shortcut for halting and rebooting the vm
    and vagrant will adjust the resources for you before it brings it back up.
    Memory should be the number of megabytes (1.5 GB => 1536 MB).

    Alternatively you can use the VirtualBox Manager (not Vagrant) to change the settings:
    Right-click on your developer vm, select "Settings", go to the "System" tab,
    and adjust the "Memory" and "Processor" settings as necessary:

    * **Memory:** 1.5GB or more
    * **CPU:** Half of your total cores

    Both of these settings greatly increase how fast the API loading takes, and in the case of memory,
    impacts whether ES can even operate within the footprint.

    After changing the vm settings run `vagrant provision` again
    to make sure things are reconfigured appropriately.

    Now, you are ready to run through the API loader commands.  Depending on how much data you want to
    load, it's going to take a while to process.  Processing times and other hints are listed below,
    though YMMV.

    ```bash
    vagrant ssh

    cd /home/vagrant/metacpan-api

    export MINICPAN=$HOME/CPAN

    # Easy and quick
    carton exec ./bin/metacpan mapping --delete

    # Release processing will be the most time consuming
    # Around 10-15 distros a minute, or 40-50 hours for a full load
    # Use the --age parameter for partial loading (like --age 4320 for six months)
    ./bin/carton exec ./bin/metacpan release $MINICPAN/authors/id/

    # Around 60 distros a minute
    # Large/weird files (ie: Alien::Debian::Apt::PM) might timeout ES; re-run it if it chokes
    ./bin/carton exec ./bin/metacpan latest --cpan $MINICPAN

    # Easy and quick
    ./bin/carton exec ./bin/metacpan author --cpan $MINICPAN
    ```

- Running the API test suite

    The vm has an instance of elasticsearch running on the default port of 9200.
    This is the instance that the API will use for development
    to store any minicpan data you index.

    Additionally the vm already has a second instance of elasticsearch running on port 9900
    (using a small amount of memory and an alternate cluster name)
    which the test suite will use.

    Since these two instances are separate from each other you shouldn't need
    to do anything to manage the elasticsearch services.
    If anything isn't working right just try a `vagrant provision`
    to make sure the services are setup.

    SSH into the box again, and run the tests as shown.

    ```bash
    vagrant ssh

    cd /home/vagrant/metacpan-api
    ./bin/prove t
    ```
