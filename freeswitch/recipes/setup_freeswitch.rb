# apt_repository 'freeswitch1.6' do
#   uri 'http://files.freeswitch.org/repo/deb/freeswitch-1.6/'
#   components ['main']
#   distribution 'jessie'
#   key 'https://files.freeswitch.org/repo/deb/debian/freeswitch_archive_g0.pub'
#   action :add
#   deb_src true
# end

bash 'add_freeswitch_repo' do
  code <<-EOH
    wget -O - https://files.freeswitch.org/repo/deb/debian/freeswitch_archive_g0.pub | apt-key add -
    echo "deb http://files.freeswitch.org/repo/deb/freeswitch-1.6/ jessie main" > /etc/apt/sources.list.d/freeswitch.list
  EOH
end

package "freeswitch-meta-all" do
  notifies :run, 'bash[cp_vanilla]', :immediately
end

bash 'cp_vanilla' do
  code <<-EOH
    mkdir /etc/freeswitch
    cp -r /usr/share/freeswitch/conf/vanilla/* /etc/freeswitch/
  EOH
end

