$instance = search("aws_opsworks_instance","hostname:#{node['hostname']}").first

# Configuring freeswitch
# remote_directory '/etc/freeswitch' do
#   source 'freeswitch'
#   owner 'freeswitch'
#   group 'freeswitch'
#   mode '0755'
#   action :create
# end

service "freeswitch" do
  action [:enable, :start]
  supports :restart => true, :reload => true, :status => true
  ignore_failure true
end

template '/etc/freeswitch/vars.xml' do
  source 'freeswitch/vars.xml.erb'
  owner 'freeswitch'
  group 'freeswitch'
  mode '0755'
  variables({
     :public_ip => $instance['public_ip']
  })
  notifies :start, 'service[freeswitch]', :delayed
end

template '/etc/freeswitch/autoload_configs/distributor.conf.xml' do
  source 'freeswitch/autoload_configs/distributor.conf.xml.erb'
  owner 'freeswitch'
  group 'freeswitch'
  mode '0755'
  notifies :start, 'service[freeswitch]', :delayed
end

cookbook_file '/etc/freeswitch/sip_profiles/external/zentrunk.xml' do
  source 'zentrunk/zentrunk-external.xml'
  owner 'root'
  group 'root'
  mode '0644'
end

cookbook_file '/etc/freeswitch/dialplan/default/000_zentrunk.xml' do
  source 'zentrunk/zentrunk-dialplan.xml'
  owner 'root'
  group 'root'
  mode '0644'
end

cookbook_file '/etc/freeswitch/sip_profiles/external.xml' do
  source 'sip_profiles/external.xml'
  owner 'root'
  group 'root'
  mode '0644'
end

cookbook_file '/etc/freeswitch/sip_profiles/internal.xml' do
  source 'sip_profiles/internal.xml'
  owner 'root'
  group 'root'
  mode '0644'
end
