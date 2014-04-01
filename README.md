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
* Ethernet interface - either builtin, USB Ethernet or Thunderbolt Ethernet
* Serial cable, with appropriate USB adaptor
* Dumb switch for a management interfaces, such as a 5 port Netgear or TP-LINK

#### Installation steps

http://www.ubuntu.com/start-download?distro=server&bits=64&release=lts
