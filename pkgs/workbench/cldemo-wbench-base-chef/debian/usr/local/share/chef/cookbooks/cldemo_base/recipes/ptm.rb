#
# Cookbook Name:: cldemo_base
# Recipe:: ptm
#
# Copyright 2014, Cumulus Networks
#

remote_file "/etc/ptm.d/topology.dot" do
  owner "root"
  group "root"
  mode "0644"
  source "http://192.168.0.1/topology.dot"
  checksum "sha256checksum"
  notifies :restart, "service[ptmd]"
end


service "ptmd" do
	supports :status => true, :restart => true, :reload => false
	action [ :enable, :start ]
end
