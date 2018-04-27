#!/bin/bash
#
# chef-oneview-code:: chef_server_bootstrap.sh
#
# Copyright 2018 Chef Software, Inc.
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

# install chef-solo
$ curl -L https://www.chef.io/chef/install.sh | sudo bash
# create required bootstrap dirs/files
$ sudo mkdir -p /var/chef/cache /var/chef/cookbooks
# pull down this chef-server cookbook
$ wget -qO- https://supermarket.chef.io/cookbooks/chef-server/download | sudo tar xvzC /var/chef/cookbooks
# pull down dependency cookbooks
$ for dep in chef-ingredient
do
  wget -qO- https://supermarket.chef.io/cookbooks/${dep}/download | sudo tar xvzC /var/chef/cookbooks
done
# GO GO GO!!!
$ sudo chef-solo -o 'recipe[chef-server::default]'
