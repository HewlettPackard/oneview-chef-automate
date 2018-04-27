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

my_client = { url: 'https://Synergy.lab', user: 'Access_1', password: '@cce$$_1', api_version: 500 }

oneview_server_profile 'chef-server' do
  client my_client
  server_hardware 'CN759000AC, bay 1'
  server_hardware_type 'SY 480 Gen9 1'
  enclosure_group 'TME_Synergy_R1'
  server_profile_template 'chef-demo-rhel7-server'
end

oneview_server_hardware 'CN759000AC, bay 1' do
  client my_client
  power_state 'on'
  action :set_power_state
end

oneview_server_profile 'chef-automate' do
  client my_client
  server_hardware 'CN759000AC, bay 2'
  server_hardware_type 'SY 480 Gen9 1'
  enclosure_group 'TME_Synergy_R1'
  server_profile_template 'chef-demo-rhel7-automate'
end

oneview_server_hardware 'CN759000AC, bay 2' do
  client my_client
  power_state 'on'
  action :set_power_state
end
