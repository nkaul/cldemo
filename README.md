Cumulus - Demo Packages
-----------------------

## Workbench demos

### 2 spine 2 leaf

#### cldemo-wbench-2s2l-puppet1

Puppet sets up a templated interfaces file, Quagga with OSPF Unnumbered (IPv4 only) and PTM for 4 switches.

#### cldemo-wbench-2s2l-puppet2

Puppet sets up a templated interfaces file, Quagga with BGP (IPv4 only) and PTM for 4 switches. - Being developed.

## Setting up the demo environment

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

Ubuntu install:

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
