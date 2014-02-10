# metacpan-developer help / faq

## A note about tuning VirtualBox

    There is anecdotal evidence that some VirtualBox VMs consume a great deal
    of CPU time, even when idle. A metacpan VM normally consumes about 5% of
    CPU when idle.

    While everyone's setup is different, the following seems to work well (note
    that the VM will have to be halted before these settings can be changed):

    In the VirtualBox Manager, set the System configuration as follows:

    - Motherboard / Extended Features:
        - [ ] Enable IO APIC
    - Processor / 1 CPU, no execution cap
    - Acceleration / Hardware Virtualization:
        - [x] Enable VT-x/AMD-V
	- [ ] Enable Nested Paging

    See http://tech.shantanugoel.com/2009/07/07/virtualbox-high-cpu-usage-problem-solved.html for some discussion on this topic.

## Problems starting the VM

- Make sure you have recent versions [Vagrant](http://www.vagrantup.com/downloads.html) (1.2.2+) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (4.2.12+)

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
