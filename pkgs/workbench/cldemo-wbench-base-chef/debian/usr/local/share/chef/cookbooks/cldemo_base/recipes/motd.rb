#
# Cookbook Name:: cldemo_base
# Recipe:: motd
#
# Copyright 2014, Cumulus Networks
#

template "/etc/motd" do
	source "motd.erb"
	owner "root"
	group "root"
	mode "0644"

end
