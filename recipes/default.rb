#
# Cookbook Name:: tmux-backported
# Recipe:: default
#
# Copyright 2012, Nat Lownes
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
if node[:lsb][:codename] == 'lucid'
  apt_repository 'lucid-backports' do
    uri "http://archive.ubuntu.com/ubuntu" 
    distribution 'lucid-backports'
    components %w(main restricted universe multiverse)
  end

  apt_preference 'tmux' do
    pin 'version 1.5*'
    pin_priority '990'

    notifies :run, "execute[apt-get update]", :immediately
  end
end

package 'tmux' do
  action :install
end

template '/etc/tmux.conf' do
  source 'tmux.conf.erb'
end

execute 'make sys-wide tmux.conf readable' do
  command 'chmod 0644 /etc/tmux.conf'
end
