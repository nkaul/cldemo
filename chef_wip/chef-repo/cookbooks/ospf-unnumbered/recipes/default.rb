#
# Cookbook Name:: ospf-unnumbered
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#include_recipe "apt"
#
#apt_repository "debian-wheezy" do
#  uri "http://ftp.us.debian.org/debian"
#  distribution "wheezy"
#  components ["main", "contrib"]
#  action :add
#end

file "/etc/apt/sources.list.d/deb.list" do
  owner "root"
  group "root"
  mode  "0644"
  content "deb http://ftp.us.debian.org/debian wheezy main contrib"
  action :create
  notifies :run, "execute[apt-update]", :immediately
end

execute "apt-update" do
  command "apt-get update"
  action :nothing
end

package "python-apt" do
  action :install
end

package "python-augeas" do
  action :install
  options "--install-recommends"
end

package "augeas-tools" do
  action :install
end

service "networking" do
  supports :status => true, :restart => true
end

service "quagga" do
  supports :status => true, :restart => true
end

service "ptmd" do
  supports :status => true, :restart => true
end

tdata = data_bag_item('topo', 'topo')

tdata['devices'].keys.each do |hname|
  if node.name == hname
    icfg = tdata['devices'][hname]['icfg']
    icfg.keys.each do |intf|
      bash "define_interface_#{intf}" do
        user "root"
        cwd "/tmp"
        code <<-EOH
augtool -s <<-EOF
set /files/etc/network/interfaces/auto[child::1="#{intf}"]/1 #{intf}
rm /files/etc/network/interfaces/iface[.="#{intf}"]
set /files/etc/network/interfaces/iface[last()+1] #{intf}
set /files/etc/network/interfaces/iface[.="#{intf}"]/family #{icfg[intf]['family']}
set /files/etc/network/interfaces/iface[.="#{intf}"]/method #{icfg[intf]['method']}
set /files/etc/network/interfaces/iface[.="#{intf}"]/address #{icfg[intf]['address']}
save
EOF
        EOH
        notifies :restart, resources(:service => "networking")
      end
    end
  end
end

template "/etc/quagga/daemons" do
  source "daemons.conf.erb"
  action :create
  notifies :restart, resources(:service => "quagga")
end

tdata['devices'].keys.each do |hname|
  if node.name == hname
    template "/etc/quagga/ospfd.conf" do
      source "ospfd.conf.erb"
      owner "quagga"
      group "quagga"
      variables({
        :routerid => tdata['devices'][hname]['routerid'],
        :ospfnetwork => tdata['devices'][hname]['ospfnetwork'],
        :ospfarea => tdata['devices'][hname]['ospfarea'],
        :interfaces => tdata['devices'][hname]['icfg'].keys
      })
      action :create
      notifies :restart, resources(:service => "quagga")
    end
  end
end

template "/etc/cumulus/ptm.d/topology.dot" do
  source "topology.dot.erb"
  owner "root"
  group "root"
  mode 00644
  notifies :restart, resources(:service => "ptmd")
end

#template "/etc/quagga/ospfd.conf" do
#  source "ospfd.conf.erb"
#  variables(
#    :routerid => harray['routerid'],
#    :ospfnetwork => harray['ospfnetwork'],
#    :ospfarea => harray['ospfarea'],
#    :icfg => icfg
#  )
#  action :create
#  notifies :restart, resources(:service => "quagga")
#end
