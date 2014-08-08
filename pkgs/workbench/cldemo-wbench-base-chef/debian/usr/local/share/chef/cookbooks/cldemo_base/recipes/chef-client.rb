#
# Cookbook Name:: cldemo_base
# Recipe:: chef-client
#
# Copyright 2014, Cumulus Networks
#

cookbook_file "/etc/init.d/chef-client" do
	source "chef-client"
	owner "root"
	group "root"
	mode "0754"
	notifies :restart, "service[chef-client]"
	notifies :enable, "service[chef-client]"
end

service "chef-client" do
	supports :status => true, :restart => true, :reload => false
	action [ :enable, :start ]
end
