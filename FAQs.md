I am completely new to MetaCPAN. What material could I refer to, to get acquainted with the codebase?
   - We would suggest you go through these videos to learn about MetaCPAN.
      - https://www.youtube.com/watch?v=qSKbVm4SnUk
      - https://www.youtube.com/watch?v=576nhptjT8A
      - http://www.slideshare.net/oalders/the-metacpan-vm-for-dummies-part-one-installation
      - http://www.slideshare.net/oalders/meta-cpan-vmparttwo
      - www.slideshare.net/oalders/abusing-metacpan2013
   - We also maintain a 'metacpan-examples' repository so that you can try the examples out yourself. This will be cloned along with the other repos in the /src folder.

---------------------------------------------------------------------------------------------------------------------

Ran into some error you don't understand? Read on to see if it's a commonly faced error.

1. I ran into certain permission errors while running a test or command.
   - Make sure that you are operating as the 'vagrant' and NOT 'metacpan'.
   - Hence, after 'vagrant ssh', do NOT do a 'sudo su metacpan'.
   - Simply go to the respective folder and run the tests as the vagrant user.


2. Why do I get the info/notices during vagrant provision? Do I need to worry about them?
   - Those info messages are puppet info/notices which come because MetaCPAN recently switched to puppet apply, and are basically just noise. So, the messages can be safely ignored.


3. I always run into errors in the tidyall.t test while running the test suite. How could it be dealt with?
   - 'sh git/setup.sh' command will set a pre-commit hook for you.
   - Running a 'tidyall -g' command before pushing your code will help pass the test.
     This way the code will be tidied automatically before committing it and hence you won't have to worry about the test failing.


4. While I try to start the Elasticsearch instance, it gives me an error saying 'unable to get gid to 100 operation not permitted... '.
   - This can happen when an instance is already running at ports 9200 and 9900. so simply kill the instances and try the command again.
   - You can always check the log files at var/logs/starman_error.log and /opt/elasticsearch/logs for any other error.
   - A 'vagrant reload' also helps.


5. I'm running into an ES error which says that the host timed out while trying to start the Elasticsearch service.
   - The best solution for this is to run ES in the foreground:

    ```
    cd /opt/elasticsearch-0.20.2 && sudo ./bin/elasticsearch -f
    ```


6. I got permission errors while doing a 'plackup' and this time the errors are related to the ScoreBoard.pm module.
   - ScoreBoard errors come when it is unable to detect its folder present under var/tmp/scoreboard.
   - A good practice would be to AVOID using 'sudo service (metacpan-www/cpan-api) start|restart|stop' and use carton to run the daemon-control script as mentioned in the ReadMe. A plackup after this wouldn't give the error.


7. Why does './bin/carton exec prove -l t' or './bin/prove t' work while the tests fail on 'prove -l t'?
   - Perl has a bunch of modules installed to the system (/usr/local/perlbrew/...), but not all of them, and not all of the necessary versions.
   - Carton will install the required modules (with the correct versions) into the ~/carton/[site] directory. So when you do './bin/carton exec ...' it will use the local directory for perl's @INC instead of the system wide directory and then run the command you specify so that it has the right modules available to it.
   - Sometimes you can get away with just installing all dependencies into one place... but if you ever have two apps that have different requirements, then you run into trouble so Carton is a tool to help isolate dependencies so that each app has its own.
   - So, if you install all your dependencies into the system lib then you don't ever need to use Carton, but if you use Carton to install your dependencies, then you have to use Carton in order to run everything.


8. I want to reinstantiate the base box and do a clean install. How could that be done?
   - Just do a 'vagrant box add mcbase (box-name as mentioned in the VagrantFile)'
   - Do 'vagrant destroy' and 'vagrant up && vagrant provision' to setup this new box.


9. I recently got a PAUSE account, but it is not reflected in my localhost:5000.
   - The authors/02authors.txt.gz needs to be updated in such a case.
   - CPAN usually takes a day or two for indexing the new PAUSE data, if you want to hack into the MetaCPAN backend and get started faster, a quick hack would be to add your PAUSE details manually to the authors/02authors.txt.gz that is downloaded by 'sh bin/partial-cpan-mirror.sh' in /home/vagrant/CPAN/...


10. I want to log in as a Pause user in localhost:5000 on my machine, what steps should I follow for the same?
   - Get a PAUSE account working.
   - Make sure it is present in authors/02authors.txt.gz file.
   - Enter your PAUSE id normally as you would for looging into metacpan.org
   - It'll say that a link has been mailed to your mail id. But obviously you did not receive this mail.
   - The link is present in /home/metacpan/api.metacpan.org/var/tmp/mail/new/(mail-link)
   - Simply click on the link to log into MetaCPAN through your local machine.


11. What is cpanfile.snapshot? I think it looks like a log from cpanfile, should we commit too when we make change on cpanfile?
   - Essentially when carton reads cpanfile, it figures out all the exact versions of the modules it installs, and then writes that snapshot file so that next time, it can read from the snapshot file to install the exact same versions.
   - Yes, the changes to both need to be committed, that is why we have added it to git
   - So, on another machine, Carton will use that snapshot to determine exactly what to install whereas the cpanfile is much less strict in what it specifies, so it can lead to subtle differences on machines.


12. I added some code to MetaCPAN and pushed a few commits, but I have not made any tests to test this code.
   - It is good practice to adhere to the perl-critic rules while coding. We have included a perl-critic.t test which tests if your code goes by the basic rules of coding. This helps us set a particular standard to our metacpan code.

13. The VM is consuming a large percentage of my processor.
   - This is a rare problem, but the following has helped some people:
   - Shutdown the machine (vagrant halt)
   - In the VirtualBox Manager, set the System configuration as follows:
      - Motherboard / Extended Features:
         - [ ] Enable I/O APIC
      - Processor / 1 CPU, no execution cap
      - Acceleration / Hardware Virtualization:
         - [x] Enable VT-x/AMD-V
         - [ ] Enable Nested Paging
   - See http://tech.shantanugoel.com/2009/07/07/virtualbox-high-cpu-usage-problem-solved.html for some discussion on this topic.

14. I'm having trouble starting the VM.
   - Make sure you have recent versions of [Vagrant](http://www.vagrantup.com/downloads.html) (1.2.2+) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (4.2.12+)
   - Open VirtualBox
      - Shut down the box.
      - Go to 'display' options for the VM, then 'remote display' and 'enable server'
      - Then start the VM through VirtualBox and you will see a large console
   - Sometimes the VM can enter a 'Guru Meditation' state during a 'vagrant up' command. In such a situation,
      - Force stop the VM from the terminal: VBoxManage controlvm (VM Name) poweroff
      - Go to the 'Settings' options for the VM from the Virtual Box.
      - Go to the 'System' tab, and then the 'Processors' tab. Enable the 'PAE mode' by checking the option.
      - Now do a 'vagrant up'.

15. I'm having trouble running a script
   - Make sure you have the right perl... run source /home/vagrant/.metacpanrc

16. Where are the log files?
   - /opt/elasticsearch/logs
   - /var/www/[site]/logs
   - /home/metacpan/[site]/var/log/

17. I get "err: Could not request certificate: Connection refused - connect(2)" when provisioning. 
   - Add 8.8.8.8 to your /etc/resolv.conf as the first nameserver
   - So, your /etc/resolv.conf should look something like:

    ```bash
    domain home
    search home
    nameserver 8.8.8.8
    nameserver 10.0.2.3
    ```


----
Point to be noted:
   - Always do a 'git pull' on all the repositories before starting off with development.
   - A lot of changes keep happening in the repos and so, it's always safe to have all the recent changes in your local machine.
