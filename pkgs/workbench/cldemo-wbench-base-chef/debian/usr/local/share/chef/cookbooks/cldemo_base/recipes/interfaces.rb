#
# Cookbook Name:: cldemo_base
# Recipe:: chef-client
#
# Copyright 2014, Cumulus Networks
#

interface_items = search( :interfaces, "id:#{node['hostname']}" )

interface_items.each do |item|
	template "/etc/network/interfaces" do
		source "interfaces.erb"
		owner "root"
		group "root"
		mode "0644"
		variables({
			:interfaces => item
			})
		notifies :restart, "service[networking]"
	end

	service "networking" do
		supports :status => true, :restart => true
		action [ :enable, :start ]
	end

end
