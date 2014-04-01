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

Provision the required topology using the CCW workbench web interface, using the credentials provided in the welcome email, SSH onto the workbench jump VM.

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

x
