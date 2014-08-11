#
# Cookbook Name:: cldemo_ospf_unnumbered
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

interface_items = search( :interfaces, "id:#{node['hostname']}" )

cookbook_file "/etc/quagga/daemons" do
	source "quagga_daemons"
	owner "root"
	group "root"
	mode "0644"
	notifies :restart, "service[quagga]"
end

interface_items.each do |item|
	template "/etc/quagga/Quagga.conf" do
		source "Quagga.conf.erb"
		owner "root"
		group "root"
		mode "0644"
		variables({
			:interfaces => item
			})
		notifies :restart, "service[quagga]"
	end
end

service "quagga" do
	supports :status => true, :restart => true
	action [ :enable, :start ]
end
