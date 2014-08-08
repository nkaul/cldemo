#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

users = data_bag("demo_users")

users.each do |login|
	user = data_bag_item('users', login)
	home = "home/#{login}"

	user(login) do
		uid      user['uid']
		gid      "cumulus"
		shell    "/bin/bash"
		comment  user['comment']
		password user['password']
        home     home
    end

    group "sudo" do
    	append  true
    	members login
    end
end
