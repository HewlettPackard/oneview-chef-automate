# coding: utf-8
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

chef_gem 'oneview-sdk' do
  compile_time true
end

require 'oneview-sdk'

my_client = { url: 'https://ONEVIEW.example.com', user: 'Administrator', password: '*******', api_version: 500 }

# Create a new fiber channel network
oneview_fc_network 'FCNetwork1' do
  data(
    autoLoginRedistribution: true,
    fabricType: 'FabricAttach'
  )
  client my_client
  action :create
end

# Create a new fiber channel over ethernet network
oneview_fcoe_network 'FCoENetwork1' do
  data(
    vlanId: 2101,
    bandwidth: {
      typicalBandwidth: 2000,
      maximumBandwidth: 9000,
    }
  )
  associated_san 'VSAN2101'
  client my_client
  action :create
end

# Create a new ethernet network
oneview_ethernet_network 'EthernetNetwork1' do
  client my_client
  data(
    vlanId: 1001,
    purpose: 'General',
    smartLink: false,
    privateNetwork: false
  )
end

# Create an enclosure group
oneview_enclosure_group 'EnclosureGroup1' do
  data(
    stackingMode: 'Enclosure',
    portMappingCount: 8,
    portMappings: [
      { midplanePort: 1, interconnectBay: 1 },
      { midplanePort: 2, interconnectBay: 2 },
      { midplanePort: 3, interconnectBay: 3 },
      { midplanePort: 4, interconnectBay: 4 },
      { midplanePort: 5, interconnectBay: 5 },
      { midplanePort: 6, interconnectBay: 6 },
      { midplanePort: 7, interconnectBay: 7 },
      { midplanePort: 8, interconnectBay: 8 },
    ],
    interconnectBayMappingCount: 2,
    interconnectBayMappings: [
      { interconnectBay: 3, logicalInterconnectGroupUri: '/rest/logical-interconnect-groups/02c6d1b0-e081-4da4-beb4-1991451ec5d4' },
      { interconnectBay: 6, logicalInterconnectGroupUri: '/rest/logical-interconnect-groups/02c6d1b0-e081-4da4-beb4-1991451ec5d4' },
    ],
    ipAddressingMode: 'IpPool',
    ipRangeUris: ['/rest/id-pools/ipv4/ranges/c8f08983-f55f-4894-99e5-497e57ff2081'],
    powerMode: 'RedundantPowerFeed',
    description: nil,
    enclosureCount: 3,
    associatedLogicalInterconnectGroups: ['/rest/logical-interconnect-groups/02c6d1b0-e081-4da4-beb4-1991451ec5d4']
  )
  logical_interconnect_groups ['MLAG-ImageStreamer']
  client my_client
  action :create
end

servers = 3

oneview_server_profile 'Chef-Node-1' do
  client my_client
  server_hardware 'BOT-CN75150107, bay 4'
  server_hardware_type 'SY 480 Gen9 CNA Only'
  enclosure_group 'EnclosureGroup1'
  server_profile_template 'RedHat 7.3'
end

oneview_server_hardware 'BOT-CN75150107, bay 4' do
  client my_client
  power_state 'on'
  # action [ :set_power_state, :update_ilo_firmware ]
  action :set_power_state
end
