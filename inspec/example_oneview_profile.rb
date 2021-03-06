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
# chef-oneview-code:: example_oneview_profile.rb
#

rom_version_attr = attribute('rom_version', default: 'I37 v2.52 (10/25/2017)', description: 'Version of the server hardware firmware to test for')
mp_firmware_version_attr = attribute('mp_firwmare_version', default: '2.55 Aug 16 2017', description: 'Version of the firmware installed on the iLO')
power_state_attr = attribute('power_state', default: 'On', description: 'Power state of the machines to look for')
server_count = attribute('server_count', default: 14, description: 'Number of servers to check against')

title 'OneView Servers'

control 'oneview-servers-1.0' do
  impact 1.0
  title 'Ensure that the servers in OneView are at the correct rom version'

  describe oneview_servers do
    its('category') { should cmp 'server-hardware' }
    its('total') { should > server_count }
  end

  # Check the power state of all the servers
  describe oneview_servers.where { power_state != power_state_attr } do
    its('name') { should eq [] }
    its('power_state') { should eq [] }
  end

  describe oneview_servers.where { rom_version != rom_version_attr } do
    its('entries.length') { should cmp 0 }
    its('rom_version') { should eq [] }
    its('rom_version_type') { should cmp 'I38' }
    its('name') { should eq [] }
  end

  describe oneview_servers.where { rom_version_type_version < Gem::Version.new('40') } do
    its('name') { should eq [] }
  end

  describe oneview_servers.where { mp_firmware_version != mp_firmware_version_attr } do
    its('name') { should eq [] }
  end

  target_date = Date.parse('2017-10-25')
  describe oneview_servers.where { rom_version_date < target_date } do
    its('rom_version_date') { should eq [] }
    its('name') { should eq [] }
  end

  # output all servers that are currently turned off
  describe oneview_servers.where { status == 'Critical' } do
    it { should_not exist }
  end
end
