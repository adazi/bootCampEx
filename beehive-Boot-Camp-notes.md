# Beehive Boot Camp 
**A workshop on how to use the linux command line, our group's cluster, and the queueing system.**  
Workshop date: 2020-05-13  
Notes updated: 2020-05-25  
_Author:_ Adam Iaizzi	| iaizzi@bu.edu | www.iaizzi.me  
[Ying-Jer Kao Group](https://yingjerkao.gitlab.io/)  
National Taiwan University

## Prerequisites:

There are a few things you will need to have ready **before** the workshop. Please make sure to give yourself some time to set these up. 

1. An account on **beehive**, if you do not have an account or know your password, contact Prof. Kao. 
2. A terminal/ssh client for your computer. (on macs and linux, this is built in, on windows, I recommend downloading [putty](https://www.putty.org/). )
3. A FTP client for copying files to and from the server (Cyberduck on mac, ???? for windows).

## Outline

Today we will cover several topics with slides and then hands-on exercises. My goal is that you will know how to

- Log into the cluster or workstations
- Navigate using the command line
- Create, rename and copy files
- Run basic bash shell scripts
- Write a basic submission script
- Submit jobs to the queue
- Monitor the status of your jobs
- Log into and use the workstations 

Outline for today: 

1. Logging into the cluster
2. Basic command line
3. Bash shell scripts 
4. The queuing system
5. Using workstations

# Using the terminal

## Logging in

To get started, we first need to log into the cluster. 

On macOS or linux, open a terminal program and use the `ssh` (secure shell) command to log in: 

```bash
ssh username@beehive.phys.ntu.edu.tw
```
It will then ask you for your password. Type it in. If that is successful you should see the following text: 

```bash
ssh username@beehive.phys.ntu.edu.tw
##Last login: Fri May  1 15:30:00 2020 from wlan15.cc.ntu.edu.tw
##Rocks 7.0 (Manzanita)
##Profile built 10:58 22-Feb-2018
##
##Kickstarted 12:15 22-Feb-2018
##
##-----------------------------
##
prompt$ 

```

If you are on a **windows** machine using an ssh client like putty, you should enter `beehive.phys.ntu.edu.tw` in the server field and your username and password when prompted. 

### Passwordless login using public key

Rather than typing your password in every time you log in can use a **public key.** This key will work with `ssh`, `scp` and probably other commands. Since you won't be typing it all the time, you can choose a more complex (better) password. [This setup is pretty easy,](https://www.tecmint.com/ssh-passwordless-login-using-ssh-keygen-in-5-easy-steps/) and once it's done, you won't have do to it again. 

## The command line

Now that you have logged into the server, you have access to a linux command line. By default, you will be in your **home directory**: `/home/username/` You can check the name of your current directory using the command `pwd` (for print working directory):  

```bash
pwd
##/home/username
```
**Note** You should be able to copy and paste my example commands into your terminal to run them. Line set off by `##` indicate the **output** you should expect from the commands. 

You can see what is in your home directory using the `ls` command. If this is your first time logging in, you won't see anything: 

```bash
ls
##[nothing]
```
Let's create a file. Use the command 
`touch my_test_file.txt` 
to create an empty text file called `my_test_file.txt`. You should now see that file when you run `ls`. 

Before we go any further, let's copy the example scripts from my home directory to yours using this command

```bash
cp -r /home/iaizzi/bootCampEx . 
```
These files are also available on [github](https://github.com/adazi/bootCampEx). To download from github, use the command

```bash
git clone https://github.com/adazi/bootCampEx.git
```

When you run `ls` you should see a new directory `bootCampEx/`. Change to that directory and view the files there. 

```bash
cd bootCampEx
ls
```

### Directories

Directories are separated by forward slashes `directory/subdirectory`. The top level directory is called **root**: `/` The location of a file can be specified with an **absolute** path (relatively to root) `/home/username/file.txt` or a **relative** path such as `../file.txt` (one level up from the current directory) or `~/dir1/file.txt`, where `~` represents the user's home directory. 

### Tab completion and up arrow

Fortunately, you don't have to type all these commands all the way. The **tab** key will autocomplete a partially-typed command or filename. You can also use the **up arrow** key to reuse previously-typed commands. 

You can also use `!!` to get the previous command and `!$` to get the first argument from the previous command. 


## Basic Bash commands: 

### Navigation
```bash
ls 				# list files in current directory
ls -l			# view files with more information
ls -a			# view hidden files (files that start with .)
pwd				# full path of current directory
cd dir1			# move to directory dir1
cd ../			# move to parent directory
cd				# move to home directory
mkdir dir1 	# create a new directory called dir1
```

### Viewing/editing files
```bash
cat file1 			# writes contents of file to screen
head [-n 5] file1 	# prints first 5 lines of file
tail [-n 5] file1	# prints last 5 lines of file
more file1    		# scroll through contents of file
emacs file1			# open file in emacs (text editor) OR
nano file1			# open file in nano (easier text editor)
```

For editing files: If you are already familiar with `emacs` or `vi`, go ahead and use that. If you are not familiar with either, `nano` provides an intuitive user interface. 

### Create, copy, move files
```bash
touch file1		# create empty file file1
cp file1 file2	# copy file1 to file2
mv file1 dir1/	# move file1 into dir1
mv file1 file2	# rename file1 to file2
rm file1		# delete file1 (cannot be undone)
```

To copy a file from `dir1/file1.txt` to `dir2/` use the command

`cp dir1/file1.txt dir2/file2.txt`
If you don't want to change the name of the file, you can simply use 

`cp dir1/file1.txt dir2/`
`mv` works in much the same way. 

**CAUTION:** These commands do what you tell them. It is very easy to overwrite or delete important files if you are not careful. 

### Wildcards

The wildcards `*` and `?` allow you to look for files matching a set of conditions. `*` stands in for **any** number of **any** character. 

```bash
ls *.txt
##numbers.txt  some_text.txt
ls *_*.txt
##some_text.txt
```

`?` stands in for **exactly one** wildcard character. Useful if files are formatted a specific way. 

```bash
ls *.??
##clean.sh  helloWorld.sh  my_first_script.sh  startJobs.sh
```

### Other useful linux commands

`du -sh *` To see how much disk space is being used by files in the current directory.  
`man` command will show you documentation for any command, for example `man cp` will list all the options for the `cp` command.  

Resources/tips: 

- (https://explainshell.com/) Will explain what each flag in a command does 
- [More unix commands](https://www.unixtutorial.org/basic-unix-commands)
- Bear in mind, no one remembers all these things. You just need to remember enough to google the rest. [see XKCD](https://xkcd.com/1168/)

### ==_Exercise 1:_== Making a new directory

Make a new directory called `dir1` and copy all files ending in .txt into that directory. (Hint: use the `*` wildcard.) 

[Solution](https://github.com/adazi/bootCampEx/blob/master/beehive-Boot-Camp-notes.md#solution-to-exercise-1-making-a-new-directory)

## Redirecting output and chaining commands together 

### Pipe

The most powerful thing about the linux commands is that you can **chain them together** to do complicated things. 

We have the file `numbers.txt` with the numbers 1-100. Take a look using `cat numbers.txt` 

If we only want to entries with the number 8 in them we can use `grep` 

```bash
cat numbers.txt | grep 8
```
`|` is the **pipe** command, which takes the output from one command and sends it as input to the next command. The pipe is really powerful because it allows you to string unix tools together to do complicated things. 

If we only want the first 3 numbers that have the number 8 in them, we can use another pipe and the `head` command: 

```bash
cat numbers.txt | grep 8 | head -n 3
```

### Redirect to file

If we  want to save the output of our command to a file we can use a **redirect**. 
Let's take that list of the first three numbers with 8 in them and send it to a file called `res.txt`:

```bash
cat numbers.txt | grep 8 | head -n 3 > res.txt
cat res.txt
##8
##18
##28
```
here `> res.txt` writes the output to the file `res.txt` **overwriting** the previous contents. We can also use `>>` to **append** text to the end of the file. 

```bash
cat numbers.txt | grep 8 | head -n 3 >> res.txt
cat res.txt
##8
##18
##28
##8
##18
##28
```

### ==_Exercise 2:_== Using pipe to string together unix commands

1. Write a one-liner that prints numbers that from the first 20 lines of `numbers.txt` that have the numeral 0 in them. 
2. Write a one liner that prints only the lines from `numbers.txt` that have **both** 2 and 8.  

```
Correct result for part 1:
10
20
Correct result for part 2:
28
82
```

[Solution](https://github.com/adazi/bootCampEx/blob/master/beehive-Boot-Camp-notes.md#solution-to-exercise-2-using-pipe-to-string-together-unix-commands)

## Scripting

Bash is a complete programming language with loops, conditionals, variables among other things. It's very slow, but very powerful for automating tasks. A bash script is just a text file that contains a bunch of bash commands. The file must start with `#!/bin/bash` (this tell the command line which interpreter to use) and after that it is just a list of bash commands. `#` is the comment character. By convention, bash scripts end in `.sh`

Let's create your first bash script. Create a file called `my_first_script.sh` and copy the following text into it. 

```bash
#!/bin/bash
echo "Hey, you just ran a script!"
```

Exit and save the file. 


### Permissions and running

Right now, your bash script is just a text file. If you try to run it, you'll get an error: 

```bash
./my_first_script.sh
##-bash: ./my_first_script.sh: Permission denied
```

Linux maintains a system of permissions to determine who can read, edit and run each file. [More about file permissions.](https://www.guru99.com/file-permissions.html) You can see the permissions of the files in your working directory using the command  

```bash
ls -l
##total 28
##-rwxr--r-- 1 username users   34 May  1 16:50 helloWorld.sh
##drwxr-xr-x 2 username users 4096 May  1 16:41 job_ex
##-rw-r--r-- 1 username users   34 May 11 19:51 my_first_script.sh
##-rw-r--r-- 1 username users  584 May  1 16:59 numbers.txt
##-rw-r--r-- 1 username users  509 May  1 16:28 some_text.txt
##-rwxr--r-- 1 username users  926 May  1 22:09 startJobs.sh
```

The first column of the output lists the permissions for each file. First is either **d** for directory or **-** for file. After that there are three sets of letters **rwx**. The first set is for the **user** (you), the second set is for the group (don't worry about this) and the last set is all (for any user on the system). **r** for read, **w** for write (or edit) and **x** for execute. 

Currently, the permissions for `my_first_script.sh` are `-rw-r--r--`, which means that it is a *file*, which **I** can read or write to and any other user can just read. To run it I have to add execute permissions for the *user* using the command 

```bash
chmod u+x my_first_script.sh 
ls -l my_first_script.sh 
##-rwxr--r-- 1 iaizzi users 34 May 11 19:51 my_first_script.sh
```

Then I can run the script: 

```bash
./my_first_script.sh
##Hey, you just ran a script!
```

_Sidebar:_ The 'all' section of the permissions can be very useful. For example, you were all able to access and copy my `bootCampEx` directory in **my** home directory because I had given all users read permissions. Note also that your home directory is not very private because all users have read access by default. 

### Printing to screen

You can print to screen with the `echo` command. Enclose strings in quotes. Use the 

```bash
echo "test"
##test
echo "test" 1 "another word"
##test 1 another word
# use -e to allow formatting characters
echo -e "test\nnewline\ttab\n"
##test
##newline		tab
```

### ==_Exercise 3:_== Write your own script

Modify `my_first_script.sh` so it prints your "Name's first shell script" and your current working directory to screen on separate lines. 

[Solution](https://github.com/adazi/bootCampEx/blob/master/beehive-Boot-Camp-notes.md#solution-to-exercise-3-write-your-own-script)

### Variables

Variables are flexibly typed do not need to be initialized. Use `$` access the value of a variable. 

```bash
var1=5
var2="a string"
echo var1 $var1 $var2
##var1 5 a string
```

Arrays are enclosed in parentheses

```bash
list1=( 0 20 50 secret word)
echo ${list1[0]} ${list1[4]}
##0 word
```

### Loops

Bash includes **for** and **while** loops. A for loop has the structure

```bash
for x in {1..5} #loop x from 1 to 5
do
	echo $x
	for y in {10..14..3} #loop from 10 to 6 by 3s
	do
		echo -e "\t" $y
	done
done
```
The for loop can also loop over any list. You can manually list things: 

```bash
total=0
for x in 0001 0002 0003 0004 0005
do 
	total=`expr $total + $x` #set total to the output from the command `expr...`
	echo $x $total
done
```

The for loop can also be over the output from a command. 

```bash
for x in `ls *.txt`
do 
	wc -l $x 	   #print the number of lines in each file matching *.txt
done
```

### Conditionals

Bash also has [if and if-else statements](http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html) that can check if a file exists, compare numerical values, etc. 

```bash
if [ $x -eq 4 ]
then
	echo "x is 4"
else
	echo "x is not 4"
fi
```


### ==_Exercise 4:_== Loops and conditionals

Make a new script `oddsEvens.sh` that: loops over the numbers 1-30 and writes the even numbers into a file `evens.txt` and prints the odd numbers to screen. (Hint: `$((x%2))` will evaluate the variable x mod 2). 

**Bonus:** Have your script use the contents of `numbers.txt` instead of looping over the numbers 1-30. 

[Solution](https://github.com/adazi/bootCampEx/blob/master/beehive-Boot-Camp-notes.md#solution-to-exercise-4-loops-and-conditionals)

### Arguments

You can also pass arguments to your bash scripts like `./my_script.sh arg1 arg2`, but I will not cover that here. 

### Making one-liners

You can combine multiple lines of bash script on the command line using the `;` to mark the end of the line. 

```bash
for x in {1..10}; do echo $x; echo "--"; done
```

### ==_Exercise 5:_== One liners

Make a one-liner that writes the numbers 20-40 to a text file `res.txt` where each line says `20 21` `21 22`... `40 41`. (Hint: `$((x+3))` will evaluate the variable `x` plus 3). 

[Solution](https://github.com/adazi/bootCampEx/blob/master/beehive-Boot-Camp-notes.md#solution-to-exercise-5-one-liners)

### An example script: startJobs.sh

I've included an example of a script that I use in my research. startJobs.sh sets up my simulations. I can use this to start hundreds of jobs with a single command. 

- Loops over system size, inverse temperature and field
- For each combination of parameters it
	- Makes a directory
	- Copies source code to directory
	- Generates the input file (read.in) with parameters
	- Generates the submission script with an appropriate name
	- Submits the job to the queue

Just this one script does in minutes what would take me hours to do by hand. I have similar scripts that automate my data post-processing. The data processing itself is done with octave, but the data is moved around and the files are combined using a shell script that loops over hundreds of directories with the results of individual simulations and performs the analysis on each. (Note: I this script requires input files, which I have not provided, so it will not run on its own). 

## Set up your environment and custom commands with `.bashrc`

In your home directory there is a file called `.bashrc` (or `.bash_profile`, which is similar). This is essentially a bash script that is run every time you log in. You can use this file to set up your environment (such as adding things to the path, creating aliases, etc). There is some [basic information about bashrc files here](https://unix.stackexchange.com/questions/129143/what-is-the-purpose-of-bashrc-and-how-does-it-work) and some [sample `.bashrc` files here](https://www.tldp.org/LDP/abs/html/sample-bashrc.html). 

For example, in my `.bashrc` file, I change my command line prompt to have say "username@host current_directory\$":


```bash
export PS1="[\u@\h \W]\$ "
```

You can also create custom aliases--short commands that stand in for something more complicated, for example, I set `emacs` to always open with the `-nw` flag (for no GUI), create a shortcut for logging into boromir, and a shortcut for viewing the whole queue (with everyone's jobs)

```bash
#no window for emacs
alias emacs='emacs -nw'
# servers
alias boromir='ssh -X boromir.phys.ntu.edu.tw`
#queue
alias jobs="qstat -u '*' "
``` 
Now, for example, when I type `jobs` it's like I typed out `qstat -u '*'`. 

**Note:** When you edit .bashrc, the changes won't appear until the next time you log in. You can activate them right away using the command `source .bashrc`

**Warning:** `.bashrc` is run before you get to use the shell went logging in, so if you add a command that causes a problem, it might be hard for you to log in. There are flags you can use to log in without running `.bashrc`. 

***

# Beehive and the Queue

## Structure of beehive

<img src="https://iaizzi.files.wordpress.com/2020/05/image-e1589292108197.jpg" alt="Beehive cluster" width="250"/>

Beehive uses scientific linux (CentOS 7). When you log into beehive you connect to the **login** node, called just **beehive**. This node is used by everyone for editing files, moving things around, and submitting jobs to the queue. It's fine for those things, but **should not** be used for any extended simulations. 

**Beehive login node:**
- 4-core Intel(R) Xeon(R)  E5620 (2010)
- 8GB RAM

The **login** node is in charge of all 14 **compute** nodes, where the jobs run. These nodes have between 8 and 28 cores and 8-128 GB of memory. In general, you don't need to worry about the specifics of the nodes because the queue will assign your job to an appropriate node for you. (The detailed specs are in the Appendix)

**Compute nodes:** 

- compute-0-0.local
- compute-0-1.local
- compute-0-2.local
- compute-0-3.local
- compute-0-4.local
- compute-0-5.local
- compute-0-6.local
- compute-0-7.local
- compute-0-8.local
- compute-0-9.local
- compute-0-10.local
- compute-0-11.local
- compute-0-12.local
- compute-0-13.local

## How to use beehive

Here are some basic rules about how to use beehive:

1. Use the log-in node for moving files around, compiling and very short tests of your code. 
2. If you have a longer calculation (more than a few minutes of CPU time), you should submit it to the queue so you don't clog up the login node. 
3. Be careful about how much disk space you use. The disk space on beehive is finite and shared between all users. If you're not careful, you can create huge numbers of files or huge files that use up massive amount of disk space. This could cause problems for other users if you end up filling up the whole drive. As a rule, you should have no problems if you keep the files in your home directory under 50GB. If you need more storage than that, talk to an admin. 
4. If you need to do complicated interactive jobs or extended testing, use the **workstations**. 
5. Be cautious about **memory usage**. The queue cannot enforce limits on memory. If your job requires more than 1gb of memory, ask an admin for advice. 

**Other tips:**

 - If your job runs out of time, your program will be killed by the queue. Design your code so it easy to restart. 
 - The queue assigns priority based on how much time you are requesting and how many jobs you are currently running. If you request less time your jobs can jump ahead of long jobs. 

**Advantages of using a queuing system**

 - Makes sure you get the resources (memory, CPU) that you need
 - Starts and stops jobs automatically
 - Jobs run in background, overnight, start whenever there are slots available
 - No need to log into many different machines (queue does that for you)
 - Automation 
 
 
### Checking the status of the queue

```bash
qstat
##job-ID  prior   name       user         state submit/start at     queue                          ##slots ja-task-ID 
##-----------------------------------------------------------------------------------------------------------------
##  19352 0.55500 hw4-test   someone        r     05/11/2020 20:07:16 cpu_short@compute-0-13.local       1        
```
 
We have (from left to right) the job ID, the priority (assigned by the queue based on your usage, lower is better), job name, user, state (r=running, qw=waiting), submit/start time, node, # of processors. 
 
If you want to see jobs from **all** users, you use the command `qstat -u '*'`
 
### Submitting your first job

To submit a job to the queue, you use the `qsub` command 

```bash 
qsub script.sh
``` 
where `script.sh` is a bash script that sets up and runs your actual program. 

I have an example code and submission script in `bootCampEx/job_ex/`. This folder contains two things: 
`ex-hw4.f90` -- a Fortran program that does some calculation 
`runFile.sh` -- the submission script 
Before I explain the submission script, let's all try starting our first job:

```bash
qsub runFile.sh
##Your job 19353 ("TestName") has been submitted
```

Everyone try this now. Once you're done, use `qsub` to see your job running **and** everyone else's job. 

Now let's take a look at `runFile.sh`:

```bash
#!/bin/bash -l
#choose which queue to submit to
#$ -q cpu_short
#set a time limit (in hours)
#$ -l h_rt=1:00:00
# start the job in the current working directory
#$ -cwd
# set the name of the job
#$ -N TestName
echo "Job started on `hostname` at `date`"
echo "compile code "
gfortran ex-hw4.f90
echo "start job" 
time ./a.out  > log.txt
echo " "
echo "Job ended at `date`"
```
Line 1 is the standard beginning of a bash script. Then we have a series of commands for the queue, these always start with `#$` so they appears as **comments** to bash. 
`#$ -q cpu_short` means we want this job to be sent to the queue "cpu_short" [More information on available queues](https://github.com/adazi/bootCampEx/blob/master/beehive-Boot-Camp-notes.md#beehive-queues)  
`#$ -l h_rt=1:00:00` set the time limit for this job to be 1 hour **wall clock time**  
`#$ -cwd` means we want the job to run in the current working directory (where we executed `qsub`)  
`#$ -N TestName` sets the name of the job to "TestName", this is optional, but it's useful when you have a lot of jobs to know what they each do  

From line **10** on it is just an ordinary shell script that compiles and runs the program. (You can compile the program in advance if you want). 

Now let's look at the **output** from running our job. There are a bunch of data files (don't worry about those). There are also two log files generated by the queue: 
`TestName.o19353` -- the stdout from `runFile.sh`:  

```
Job started on compute-0-10.local at Mon May 11 20:19:31 CST 2020
compile code 
start job
 
Job ended at Mon May 11 20:24:13 CST 2020
```
and `TestName.e19353` the stderr from `runFile.sh`: 

```
real	4m41.941s
user	4m41.905s
sys	0m0.002s
```

From this we can see that our job ran, it compiled and ran the program with no errors, and the program ran for about 5 minutes. 


#### ==_Exercise 6:_== Modify runFile.sh (5 minutes)

Modify runFile.sh:

 - Change the job name to something more descriptive
 - Change the time limit to two hours
 - Have the script write the contents of the directory to the log file

Then use `qsub` to submit your job and `qstat -j job_number` to check on it. 

[Solution](https://github.com/adazi/bootCampEx/blob/master/beehive-Boot-Camp-notes.md#solution-to-exercise-6-modify-runfilesh)
 
#### ==_Exercise 7:_== Make a second job directory

1. Create a new directory in `bootCampEx` called `new_job`
2. Copy `ex-hw4.f90` and `runFile.sh` into the new directory. 
3. Change the job name in `runFile.sh` in `new_job/` 
4. Submit both `job_ex/runFile.sh` and `new_job/runFile.sh` 
5. Confirm that they are both running in the queue with `qstat`

[Solution](https://github.com/adazi/bootCampEx/blob/master/beehive-Boot-Camp-notes.md#solution-to-exercise-7-make-a-second-job-directory)

### Advanced use of queue:

```bash
qdel job_ID		#to delete jobs
qhold job_ID		#to pause a job (while its waiting to run)
qrls job_ID		#release your job from a hold
```

If you have many jobs, you may need to use this commands with a loop in a one liner format, e.g. `for x in {firstjob..lastjob}; do qdel $x; done`. If you want to delete all your jobs, use `qdel -u username`

Running parallel/GPU jobs requires other flags in your submission script, talk to an admin if you need to do this. 


### Environment variables

When your job is running, it will have access to certain **environment variables** that can tell you where the job is, what machine it's running on, etc. 
For example, if you wanted to know from what directory your job was submitted (where you executed `qsub ...`), you can add `echo $SGE_O_WORKDIR` to your submission script. Or you could use `echo $HOSTNAME` to tell which node your job actually ran on. This can be very useful if certain nodes cause errors in your code. 

The full list of environment variables for SGE can be found [here](https://docs.oracle.com/cd/E19957-01/820-0699/chp4-21/index.html). 

## Beehive etiquette

- Keep your home directory under 50 GB (check with `du -sh *`)
- Do **not** run jobs on login node
- Be careful about memory usage
- Use the queue
- Don't be afraid to use a lot. Idle CPUs are wasted CPUs
- **NO BITCOIN OR CRYPTOCURRENCY MINING** 
- If something seems broken, contact an admin for help. 

***

# Workstations 

The workstations are basically ordinary desktop computers that you can log into for running calculations that are too intense for your laptop. The workstations do not have a queueing systems. Your account (username/password) on the workstations are the same as for beehive, but your account data **is not synchronized**. Crucially, the data on the workstations **is not backed up** so you must do your own backups (to beehive or your own computer). 

## List of workstations: 
**aragorn**

 - 8-core Intel(R) Core(TM) i7-9700 CPU @ 3.00GHz
 - 62 GB RAM
 - GPU 0: GeForce GTX 1660 SUPER
 - GPU 1: GeForce RTX 2080 Ti
	 
**boromir**

- 12-core Intel(R) Core(TM) i7-6850K CPU @ 3.60GHz
- 31 GB RAM
- GPU 0: GeForce GTX 980
- GPU 1: GeForce GTX 1080 Ti

**legolas**

**gimli** 

## Using workstations

Log in just like you would any other system. Today we will use **aragorn**

```bash
ssh user@aragorn.phys.ntu.edu.tw
```
Now let's copy over our example exercises from the beehive using the `scp` (secure copy) command: 

```bash
scp -r beehive.phys.ntu.edu.tw:~/bootCampEx/ . 
```
`-r` is a *recursive* copy (allows you to copy folders)  
`beehive.phys.ntu.edu.tw` the address of the other computer where the files are located  
`~/bootCampEx/` source folder on remote machine (your home directory)  
`.` copy destination (the current directory)  

You can then use the command line just like you would on your own computer. Since these are a shared resource, however, you should be courteous of the other users. First check if anyone else is running things using the `top` command. 

```bash
top - 16:09:27 up 49 days, 21:44,  1 user,  load average: 1.30, 1.27, 1.25
Tasks: 257 total,   4 running, 253 sleeping,   0 stopped,   0 zombie
%Cpu(s): 12.5 us,  0.0 sy, 12.5 ni, 75.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem : 65721656 total, 52847068 free,  2627500 used, 10247088 buff/cache
KiB Swap: 32964604 total, 32736508 free,   228096 used. 62457096 avail Mem 

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND                                               
13186 me        39  19   15076    796    628 R  99.7  0.0   0:17.59 a.out                                                 
25143 someone   20   0   12704   1604   1232 R  99.7  0.0   4232:31 a.out   
...
```
To leave the `top` interface, just hit **q**. 

### Running jobs while logged out

**Problem:** for long jobs, the program gets killed if I logout or my connection is interrupted. 

**Solution:** Use the `nohup` command. 

Move to the `job_ex` directory and compile `ex-hw4.f90`  

```bash
cd bootCampEx/job_ex/
gfortran ex-hw4.f90
```
Now run the job using `nohup`

```bash
nohup ./a.out &
##[1] 13128
##nohup: ignoring input and appending output to ‘nohup.out’
```
Adding an ampersand `&` to the end of your command causes it to run in the background, and you get a command line back. If you forget to do this, you can use CTRL+Z and type `bg` and hit enter. Use the command `fg` to bring the job back to the foreground. 

If you run the `top` command, you should see your job running. 

Now log out (using `exit`) and log back in to check that your job is still running.   When the job ends you will see an output like this to the screen: 

```
[1]+  Done                    nohup time ./a.out
```
The output that would have normally gone to the screen goes to the file `nohup.out`. (see that with `cat nohup.out`)

### Be `nice -19`

When you're running anything long on the workstations, you should prepend `nice -19` to your command. This tells the computer that your job is low priority, so when other people log in to check on their jobs or edit files, it won't be super slow. 

For example:

```bash
nohup nice -19 ./a.out &
```
This runs `a.out` at low priority using `nohup` (you can also use `nice` without nohup). 

### ==_Exercise 8:_== Start two jobs

On aragorn:

1. Start `job_ex/runFile.sh` using `nohup` and `nice -19` (do **not** use `qsub`)
2. Start `new_job/runFile.sh` using `nohup` and `nice -19`
3. Use `top` to check that both jobs are running. 
4. Log out of aragorn
5. Log back in
6. Check that both jobs are running again with `top`
7. Wait a few minutes and check that they have finished successfully. 

[Solution](https://github.com/adazi/bootCampEx/blob/master/beehive-Boot-Camp-notes.md#solution-to-exercise-8-start-two-jobs)

## Workstation etiquette

- Use `top` command to see who else is using the machine. 
- Don't use the whole machine for a super long time (especially GPUs)
- Don't leave huge amounts of data in your home directory
- **NO BITCOIN OR CRYPTOCURRENCY MINING** 
- Use `nice -19`

***

# Resources:

Here are some useful links if you need to learn more: 

- [Beehive status/monitoring](http://beehive.phys.ntu.edu.tw/ganglia/?r=hour&cs=&ce=&m=load_one&s=by+name&c=Beehive&tab=m&vn=&hide-hf=false) 
- [Beehive documentation, list of queues, commands, etc](http://beehive.phys.ntu.edu.tw/dokuwiki/doku.php) 
- [Stack exchange Unix/Linux Q&A](https://unix.stackexchange.com/) 
- [ExplainShell.com - explains options for commands](https://explainshell.com/)
- [Bash Tutorial](https://linuxconfig.org/bash-scripting-tutorial-for-beginners) 
- [CodeAcademy - Learn the command line](https://www.codecademy.com/learn/learn-the-command-line)
- [Set up passwordless login using a public key](https://www.tecmint.com/ssh-passwordless-login-using-ssh-keygen-in-5-easy-steps/)


***

# Appendix

## Beehive queues

There are three queues on beehive. You can check the status and usage of the queues using the command

```bash
> qstat -g c
CLUSTER QUEUE                   CQLOAD   USED    RES  AVAIL  TOTAL  
------------------------------------------------------------------
cpu_long                          0.00      0      0     46     46 
cpu_short                         0.01      0      0     94     94 
gpu                               0.04      1      0     10     11 
```

**cpu_long** 

- 46 cores
- No time limit
- Runs on slower/older nodes

**cpu_short** 

 - 94 cores
 - Time limit: 5 days (120 hours)
 - Runs on faster/newer nodes

**gpu**

- For jobs that require a GPU
- 11 GPUs
- Unlimited time
- Nodes:
	- compute-0-9.local (3x Tesla M2090)
	- compute-0-10.local (2x Tesla M2090)
	- compute-0-11.local (1x Tesla K20c)
	- compute-0-12.local (3x GeForce GTX 1080 Ti, 1x Tesla K40c)

## List of nodes and specs

Using the `qhost` command

```
HOSTNAME       ARCH         NCPU NSOC NCOR NTHR    MEMTOT
---------------------------------------------------------
compute-0-0    lx-amd64        8    2    8    8     15.5G
compute-0-1    lx-amd64        8    2    8    8     23.4G
compute-0-2    lx-amd64        8    2    8    8     23.4G
compute-0-3    lx-amd64        8    2    8    8     15.5G
compute-0-4    lx-amd64        8    2    8    8      7.6G
compute-0-5    lx-amd64        8    2    8    8      7.6G
compute-0-6    lx-amd64        8    2    8    8      7.6G
compute-0-7    lx-amd64        8    2    8    8      7.6G
compute-0-8    lx-amd64        8    2    8    8      7.6G
compute-0-9    lx-amd64        8    2    8    8     23.4G
compute-0-10   lx-amd64        8    2    8    8     70.6G
compute-0-11   lx-amd64        8    2    8    8     15.5G
compute-0-12   lx-amd64       28    2   28   28    125.6G
compute-0-13   lx-amd64       28    2   28   28     62.7G
```

## Solutions to exercises

### Solution to ==_Exercise 1_==: Making a new directory 

**Problem:** Make a new directory called dir1 and copy all files ending in .txt into that directory. (Hint: use the * wildcard.) 

**Solution:** From `bootCampEx/`, execute the following commands: 

```bash
mkdir dir1
cp *.txt dir1/
ls dir1/
```

[Back to exercise 1](https://github.com/adazi/bootCampEx/blob/master/beehive-Boot-Camp-notes.md#exercise-1-making-a-new-directory)

### Solution to ==_Exercise 2_==: Using pipe to string together unix commands

**Problem:**

1. Write a one-liner that prints numbers that from the first 20 lines of `numbers.txt` that have the numeral 0 in them. 
2. Write a one liner that prints only the lines from `numbers.txt` that have **both** 2 and 8.  

**Solution:** 

```bash
#part 1
cat numbers.txt | head -n 20 | grep 0
#part 2
cat numbers.txt | grep 8 | grep 2
```

```
Correct result for part 1:
10
20
Correct result for part 2:
28
82
```

[Back to exericse 2](https://github.com/adazi/bootCampEx/blob/master/beehive-Boot-Camp-notes.md#exercise-2-using-pipe-to-string-together-unix-commands)

### Solution to ==_Exercise 3_==: Write your own script

**Problem:** Modify `my_first_script.sh` so it prints your "Name's first shell script" and your current working directory to screen on separate lines. 


**Solution:** 

```bash
#!/bin/bash

echo "Someone's first shell script!"
```

[Back to exercise 3](https://github.com/adazi/bootCampEx/blob/master/beehive-Boot-Camp-notes.md#exercise-3-write-your-own-script)

### Solution to ==_Exercise 4_==: Loops and conditionals

**Problem:** Make a new script oddsEvens.sh that: loops over the numbers 1-30 and writes the even numbers into a file evens.txt and prints the odd numbers to screen. (Hint: `$((x%2))` will evaluate the variable x mod 2).

*Bonus:* Have your script use the contents of numbers.txt instead of looping over the numbers 1-30. 

**Solution:** The solution is in `bootCampEx/solutions/oddsEvens.sh`

```bash
#!/bin/bash
for x in {1..30}
do
    # if even
    if [ $((x%2)) -eq 0 ]
    then
	echo $x >> evens.txt
    else
	echo $x "is odd"
    fi
done
```

*Bonus:*

```bash
#!/bin/bash
for x in `head -n 30 numbers.txt`
do
    # if even
    if [ $((x%2)) -eq 0 ]
    then
	echo $x >> evens.txt
    else
	echo $x "is odd"
    fi
done
```

[Back to exercise 4](https://github.com/adazi/bootCampEx/blob/master/beehive-Boot-Camp-notes.md#exercise-4-loops-and-conditionals)

### Solution to ==_Exercise 5_==: One liners

**Problem:** Make a one-liner that writes the numbers 20-40 to a text file `res.txt` where each line says `20 21`, `21 22`,... `40 41`. (Hint: `$((x+3))` will evaluate the variable x plus 3). 

**Solution:** 

```bash
for x in {20..40}; do echo $x $((x+1)); done
```

[Back to exercise 5](https://github.com/adazi/bootCampEx/blob/master/beehive-Boot-Camp-notes.md#exercise-5-one-liners)

### Solution to ==_Exercise 6_==: Modify runFile.sh

**Problem:** Modify `runFile.sh`:

- Change the job name to something more descriptive
- Change the time limit to two hours
- Have the script write the contents of the directory to the log file

Then use `qsub` to submit your job and `qstat -j job_number` to check on it. 

**Solution:** 

```bash
#!/bin/bash -l
#choose which queue to submit to
#$ -q cpu_short
#set a time limit (in hours)
#$ -l h_rt=2:00:00
# start the job in the current working directory
#$ -cwd
# set the name of the job
#$ -N AnotherName

echo "Job started on `hostname` at `date`"

echo "compile code "
gfortran ex-hw4.f90

echo "start job" 

time ./a.out  > log.txt
echo " "
echo "Job ended at `date`"

ls
```

[Back to exercise 6](https://github.com/adazi/bootCampEx/blob/master/beehive-Boot-Camp-notes.md#exercise-6-modify-runfilesh-5-minutes)

### Solution to ==_Exercise 7_==: Make a second job directory

**Problem:**

1. Create a new directory in `bootCampEx` called `new_job`
2. Copy `ex-hw4.f90` and `runFile.sh` into the new directory. 
3. Change the job name in `runFile.sh` in `new_job/` 
4. Submit both `job_ex/runFile.sh` and `new_job/runFile.sh` 
5. Confirm that they are both running in the queue with `qstat`

**Solution:** From `bootCampEx/`

```bash
mkdir new_job
cd new_job
cp ../job_ex/runFile.sh .
cp ../job_ex/ex-hw4.f90 .
#use text editor to change name in runFile.sh
qsub runFile.sh
qstat
```

[Back to exercise 7](https://github.com/adazi/bootCampEx/blob/master/beehive-Boot-Camp-notes.md#exercise-7-make-a-second-job-directory)

### Solution to ==_Exercise 8:_== Start two jobs

**Problem:** On aragorn:

1. Start `job_ex/runFile.sh` using `nohup` and `nice -19`
2. Start `new_job/runFile.sh` using `nohup` and `nice -19`
3. Use `top` to check that both jobs are running. 
4. Log out of aragorn
5. Log back in
6. Check that both jobs are running again with `top`
7. Wait a few minutes and check that they have finished successfully. 

**Solution:** Starting from `bootCampEx/`

```bash
cd job_ex/
nohup nice -19 ./runFile.sh &
cd ../new_job/
nohup nice -19 ./runFile.sh &
top
```

[Back to exercise 8](https://github.com/adazi/bootCampEx/blob/master/beehive-Boot-Camp-notes.md#exercise-8-start-two-jobs)
