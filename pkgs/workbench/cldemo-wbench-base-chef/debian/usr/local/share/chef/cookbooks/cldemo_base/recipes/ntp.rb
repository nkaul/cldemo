#
# Cookbook Name:: cldemo_base
# Recipe:: ntp
#
# Copyright 2014, Cumulus Networks
#

template "/etc/ntp.conf" do
	source "ntp.conf.erb"
	mode   0644
	owner  "root"
	group  "root"
	variables({
		:servers => node["ntp"]["servers"]
		})
	notifies :restart, "service[ntp]"
end

service "ntp" do
	supports :status => true, :restart => true, :reload => false
	action [ :enable, :start ]
end
