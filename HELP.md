# metacpan-developer help / faq

## Problems starting the VM

- Make sure you have recent versions [Vagrant](http://downloads.vagrantup.com/) (1.2.2+) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (4.2.12+)

- Open VirtualBox
	- Shutdown the box,
	- Go to 'display' options for the VM, then 'remote display' and 'enable server'
	- Then start the VM through VirtualBox and you will see a large console

## Problems running a script?

- Make sure you have the right perl... run

		source /home/metacpan/.metacpanrc

## Where are the log files?

- /opt/elasticsearch/logs
- /var/www/<site>/logs
- /home/metacpan/api.metacpan.org/var/log/