# MetaCPAN Developer

- [Initial Setup](#initial)
  - [Requirements](#requirements)
  - [Setup Repos and VM](#setup)
  - [API and Web Interface](#api)
  - [Fork the Repo](#fork)
- [Workflow](#workflow)
  - [Run the Tests](#tests)
  - [Make a Change](#change)
  - [Restart the Service](#restart)
  - [Update the VM](#update)
  - [Make a Pull Request](#pr)
- [Getting Help](#help)

This is a virtual machine for the use of MetaCPAN contributors.  We do not recommend installing manually, but if you want to try it there are some instructions in the [puppet repository](https://github.com/metacpan/metacpan-puppet).

For information on using MetaCPAN, see [the api docs](https://github.com/metacpan/metacpan-api/blob/master/docs/API-docs.md).

## <a name="initial"></a>Initial Setup

### <a name="requirements"></a>Requirements

* [Vagrant](http://www.vagrantup.com/downloads.html) (1.2.2 or later)
* [VirtualBox](https://www.virtualbox.org/), we recommend [4.3.10](https://www.virtualbox.org/wiki/Download_Old_Builds), see [guest additions](http://stackoverflow.com/questions/22717428/vagrant-error-failed-to-mount-folders-in-linux-guest) if you get mounting issues
* [A git client](http://git-scm.com/downloads)
* An ssh client if not built in, [Windows users see this](http://docs-v1.vagrantup.com/v1/docs/getting-started/ssh.html).
* To be able to download about 900MB of data on the first run

### <a name="setup"></a>Setup Repos and VM

```bash
git clone git://github.com/metacpan/metacpan-developer.git
cd metacpan-developer
sh bin/init.sh # clone all of the metacpan repos
vagrant up # start the VM - will download the base box (900M) on the first run
vagrant provision # necessary installation and configuration
```

`vagrant provision` can be run multiple times, and includes running the puppet setup (which will also install any Carton dependencies, though there are instructions below for doing this manually as well). Warnings in the puppet setup (in red) are usually ok, Errors are not.

At this point you have a virtual machine with all of the MetaCPAN services up and running!  You can connect to it with:

```bash
vagrant ssh
```

### Seed Elasticsearch

Running this script will set up the Elasticsearch mappings, fetch some CPAN modules and index them for you.

```bash
vagrant ssh
sh /vagrant/bin/index-cpan.sh
```

### <a name="api"></a>API and Web Interface

The API and web interface are also forwarded to ports on your machine: [5000](http://localhost:5000/) and [5001](http://localhost:5001/) respectively.

For simplicity, from now on we'll assume you're working on metacpan-web.  Working on the API is very similar - you can essentially replace 'web' with 'api' in the following instructions - except that you need to get some test data to use.  Instructions for that are [here](README_API.md).

Note that the web service connects to the *actual* metacpan api, not your local one.  If your patch changes both and you need to test them together, instructions for connecting them are in the [FAQ](FAQs.md).

### <a name="fork"></a>Fork the Repo

You'll need to make a fork of the repository you're working on; then instead of cloning that to your local machine, you can point the copy you already have to it.

```bash
cd /path/to/metacpan-web
git remote rename origin upstream
git remote add origin git@github.com:username/metacpan-web.git
```


## <a name="workflow"></a>Workflow

### <a name="tests"></a>Run the Tests

You'll want to run the suite at least once before getting started to make sure the VM has a clean bill of health.

*NOTE:* `./bin/prove` is _not_ the system `prove` but the one in the metacpan-web (or metacpan-api) bin directory.

```bash
 vagrant ssh
 cd metacpan-web
 ./bin/prove t
```

This recursively runs all the tests in the `t` directory in metacpan-web.  To do a partial run during development, specify the path to the file or directory containing the tests you want to run, for example:

```bash
./bin/prove t/model/release.t
```

This will save time during development, but of course you should always run the full test suite before submitting a pull request.

### <a name="change"></a>Make a Change

The init script you ran during the initial setup cloned all of the metacpan repositories; then the Vagrant provisioning script mounted those repositories on the VM.

So you can open a separate terminal and code on your own machine:

```bash
cd /path/to/metacpan-developer/src/metacpan-web
git checkout -b MyBranch
# hack hack hack
git add somefile
git commit -m"comments in somefile/ now are fully compliant/ with haiku spec, yay!"
```

The changes you make will show up on the VM and can be used next time you run the test suite.

## Installing Dependencies

If you need to add or update a module, make the change in the `cpanfile` of the
repository.  In order to install the module you can either run `vagrant
provision` (which is slow) or run a carton wrapper for your repository (which
is fast).  For example, if you've added a dependency to
`metacpan-api/cpanfile`, you can run `sh /home/vagrant/bin/metacpan-api-carton
install`.


### <a name="restart"></a>Restart the Service

The projects use Carton to manage dependencies.  This is very useful if you are, or might later be, working on more than one of them.  Even if you choose to install modules globally on the VM, remember to add them to the repository's cpanfile.

If you've updated the cpanfile, you can run metacpan-web's carton from the vagrant user's home directory:

```bash
cd ~
./bin/metacpan-web-carton
```

Next, restart the web service:

```bash
sudo service starman_metacpan-web restart
```

Now you can go back and run the tests as described above.  Repeat until your code is sufficiently awesome.


### <a name="update"></a>Update the VM

If you're working on a long-lived branch, you should update the VM periodically.  Pull the master branch of metacpan-developer and all of the repos in src:

```bash
cd /path/to/metacpan-developer
git checkout master
git pull
cd src/metacpan-puppet
git checkout master
git pull
# etc
```

Then shut down the VM and bring it up again to ensure you are running the correct versions of all dependencies:

```bash
vagrant halt
vagrant up --provision
```

You may wish to write a script to automate this process.


### <a name="pr"></a>Make a Pull Request

You'll need to rebase off of master, which can be done on your machine:

```bash
cd /path/to/metacpan-web
git checkout master
git pull
git checkout MyBranch
git rebase master
```

Resolve any conflicts, then restart the service and run the test suite.

Here's a simple PR checklist:

  * I've run the entire test suite and it passes
  * I've committed all of the changes that are necessary for my patch to work
  * I've added tests to show how my patch is supposed to behave
  * I've added or edited comments and documentation as appropriate

Now you can push to your fork and create a pull request - we look forward to seeing your work!


## <a name="help"></a>Getting Help

First, check the [FAQs](FAQs.md) page for common issues faced during the development process.  If your problem isn't solved there, join us on #metacpan (irc.perl.org), or open an [issue](https://github.com/metacpan/metacpan-developer/issues).
