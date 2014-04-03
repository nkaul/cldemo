Cumulus - Demo Packages
-----------------------

## Workbench demos

Demo matrix:

| Topology | Demo                          | Bash | Puppet                    | Chef     | Ansible | Salt |
| -------- | ----------------------------- | ---- | ------------------------- | -------- | ------- | ---- |
| 2s2l     | PTM, OSPF Unnumbered IPv4     |      | **Complete** *3 Mar 2014* | Ratnakar | Stanley |      |
| 2s2l     | PTM, BGP IPv4                 |      | Nat                       |          |         |      |
| 2s       |                               |      |                           |          |         |      |
| 1s       |                               |      |                           |          |         |      |

## Preparing the environment

### CCW

Request the required topology via the CCW workbench web interface, use the credentials provided in the welcome email to SSH onto the workbench jump VM.

Add the temporary cldemo package repository:

```
cumulus@wbench:~$ sudo echo "deb http://dev.cumulusnetworks.com/~nat/cldemo/repo cldemo workbench" >>/etc/apt/sources.list
cumulus@wbench:~$ sudo apt-get update
```

Display a list of available packages:

```
cumulus@wbench:~$ sudo apt-cache search cldemo
```

Install a demo:

```
cumulus@wbench:~$ sudo apt-get install cldemo-wbench-2s2l-puppet1
```

### Standalone

At events such as trade shows and onsite customer demos it may be handy to give an offline demo.

Requirements

* Laptop running Linux, OSX or Windows
* VirtualBox, VMWare Fusion or VMWare Workstation
* Ubuntu Server install ISO, currently 64bit 12.04 LTS (Precise Pangolin) is supported
* Ethernet interface - builtin, USB Ethernet or Thunderbolt Ethernet
* Serial cable, with appropriate USB adaptor
* Dumb switch for management interfaces, such as a 5 port Netgear or TP-LINK. Only required if your are demoing a 2 or 4 switch topology.

#### Installation steps

Download the Ubuntu Server ISO: http://www.ubuntu.com/start-download?distro=server&bits=64&release=lts

Create a new VM of the following spec:

* Single Core
* 1gb RAM
* 20gb HDD
* 1 network interface (we will add a 2nd later)

Ubuntu install parameters:

| Option / prompt                     |  Value                    |
| ----------------------------------- | ------------------------- |
| Install type                        | Server Install            |
| Language                            | English                   |
| Keyboard mapping                    | *Your choice*             | 
| Hostname                            | wbench                    |
| Full name for new user              | cumulus                   |
| Password for new user               | *Your choice*             |
| Encrypt your home directory         | No                        |
| Time zone                           | *Your choice*             |
| Partitioning method                 | Guided - use entire disk  |
| Select partition                    | sda                       |
| Write changes to disks              | Yes                       |
| HTTP proxy information              | None                      |
| How do you want to manage upgrades? | No automatic updates      |
| Choose software to install          | Nothing                   |
| Install GRUB to the MBR?            | Yes                       |

Complete the install and boot into Ubuntu.

Login as cumulus

Permit the cumulus user to sudo with no password:

```
cumulus@wbench:~$ sudo visudo
```

Add the following line to the bottom of the file:

```
cumulus ALL = NOPASSWD: ALL
```

Run this:

```
cumulus@wbench:~$ curl -s http://dev.cumulusnetworks.com/~nat/cldemo/standalone1 | sudo bash -s --
```


## Demo development

### Setting up your environment

TODO: git checkout, deb tools required, advice on topologies / etc.

