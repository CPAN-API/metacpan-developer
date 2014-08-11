# Virtual development machine for the metacpan project

- You will need:

    - [Vagrant](http://www.vagrantup.com/downloads.html) (1.2.2 or later)
    - [VirtualBox](https://www.virtualbox.org/), we recommend [4.3.10](https://www.virtualbox.org/wiki/Download_Old_Builds), see [guest additions](http://stackoverflow.com/questions/22717428/vagrant-error-failed-to-mount-folders-in-linux-guest) if you get mounting issues
    - [A git client](http://git-scm.com/downloads)
    - An ssh client if not build in, [Windows users see
      this](http://docs-v1.vagrantup.com/v1/docs/getting-started/ssh.html).
    - To be able to download about 900MB of data on the first run

-  Check out this repo.

    ```bash
    git clone git://github.com/CPAN-API/metacpan-developer.git
    ```

-  Set Up repositories
   ````bash
    cd metacpan-developer
    sh bin/init.sh
   ```

- Start the virtual machine (first run will download our .box disk image
  ~900MB)

    ```bash
    vagrant up
    ```

- Run all the extra bits that were added after we created the .box file (you
might need to run this each time you start up the machine or if we have made
further changes)

    ```bash
    vagrant provision
    ```

If you get this error when provisioning "err: Could not request certificate: Connection refused - connect(2)"
then add the following to your /etc/resolv.conf as the first nameserver:

    ```bash
    nameserver 8.8.8.8
    ```

So, your /etc/resolv.conf should look something like

    ```bash
    domain home
    search home
    nameserver 8.8.8.8
    nameserver 10.0.2.3
    ```

- Connect to the vm

    ```bash
    vagrant ssh
    ```

- To edit and test

    Your workflow from this point will be to edit the MetaCPAN repositories
    which you have just checkout out to your local machine.  After you have
    made your changes, you can ssh to your box and restart the relevant
    services.  You will not develop on the VM directly.

    To install any missing (newly required) perl modules, as root run

    ```bash
    cd <to the mount as listed below>
    ./bin/carton install
    ```
    It's good practice to add the new modules to the cpanfile in the respective repository. And do a carton install as above.

    - metacpan-web is the web front end
        - mounted as /home/metacpan/metacpan.org
        - ./bin/carton exec bin/daemon-control.pl restart
    - cpan-api is the backend that talks to the elasticsearch
        - mounted as /home/metacpan/api.metacpan.org
        - ./bin/carton exec bin/daemon-control.pl restart
    - metacpan-puppet is the sysadmin/server setup
        - mounted as /etc/puppet
        - /etc/puppet/run.sh

    Make changes in your checked out 'metacpan' repos and restart the service

- To debug the changes in the code.

    - For metacpan-web
        - cd /home/metacpan/metacpan.org
        - ./bin/carton exec bin/daemon-control.pl stop
        - ./bin/carton exec plackup -p 5001 -r
    - For cpan-api
        - cd /home/metacpan/api.metacpan.org
        - ./bin/carton exec bin/daemon-control.pl stop
        - ./bin/carton exec plackup -p 5000 -r

- To connect the web front-end to your local cpan-api backend.

    At times you may have to make a few changes to the backend and reflect the same on the front end. 
    For Example: Setting up a new API endpoint. 
    metacpan-web by default uses the hosted api i.e https://api.metacpan.org as its backend.
    To configure your local cpan-api, do the following.

    - In the metacpan-web repository,
	- Copy and Paste the `metacpan_web.conf` file and rename it as `metacpan_web_local.conf` that will contain:

    api                 http://127.0.0.1:5000
    api_external        http://127.0.0.1:5000
    api_secure          http://127.0.0.1:5000
    api_external_secure http://127.0.0.1:5000

    - This local configuration file will be loaded on top of the existing config file.
    - Do a vagrant reload after this or simply follow the debug steps that will reload this file.

- To connect to services on the VM

    WEB: [http://localhost:5001/](http://localhost:5001/)

    API: [http://localhost:5000/](http://localhost:5000/)

    SSH: `vagrant ssh`

- Running the metacpan-web test suite

    You'll want to run the suite at least once before getting started to make sure the VM has a clean bill of health.

    ```bash
    vagrant ssh

    cd /home/metacpan/metacpan.org
    ./bin/prove t
    ```

### More documentation

 * [SETTING UP / TESTING THE API](README_API.md) page
 * [HELP](HELP.md) page (including VM tuning notes)

### Problems?
 * Check the [FAQs](FAQs.md) page for common issues faced during the development process.
 * If you have trouble mounting the folders, check this fix for [guest additions](http://stackoverflow.com/questions/22717428/vagrant-error-failed-to-mount-folders-in-linux-guest)
 * Ask on #metacpan (irc.perl.org), or open an [issue](https://github.com/CPAN-API/metacpan-developer/issues)


