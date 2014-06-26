// author: InMon
// version: 1.0
// date: 4/16/2014
// description: Startup settings for cumulus demo

setFlow('bytes',{value:'bytes',filter:'direction=ingress'});
setFlow('flows',{keys:'macsource,macdestination,ipsource,ipdestination,stack',value:'bytes'});
setFlow('tcp',{keys:'ipsource,ipdestination,tcpsourceport,tcpdestinationport',value:'bytes'});
setFlow('udp',{keys:'ipsource,ipdestination,udpsourceport,udpdestinationport',value:'bytes'});
setFlow('icmp',{keys:'ipsource,ipdestination,ipprotocol,icmptype',value:'bytes'});
setFlow('icmp2',{keys:'ipsource,ipdestination,ipprotocol,icmptype',value:'bytes'});
setFlow('tcpip',{keys:'ipsource,ipdestination,stack,or:tcpsourceport:udpsourceport:icmptype,or:tcpdestinationport:udpdestinationport:icmpcode',value:'bytes'});
setFlow('vxlan',{keys:'ipsource,ipdestination,vni,ipsource.1,ipdestination.1,ipprotocol.1',value:'bytes'});
