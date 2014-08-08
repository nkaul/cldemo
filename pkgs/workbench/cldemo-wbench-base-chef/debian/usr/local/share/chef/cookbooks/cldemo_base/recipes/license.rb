#
# Cookbook Name:: cldemo_base
# Recipe:: license
#
# Copyright 2014, Cumulus Networks
#

execute "/usr/cumulus/bin/cl-license -i http://192.168.0.1/#{node['hostname']}.lic" do
	not_if "/usr/bin/test -f /etc/cumulus/.license.txt"
	notifies :restart, "service[switchd]"
end

service "switchd" do
	supports :status => true, :restart => true, :reload => false
	action [ :enable, :start ]
end
