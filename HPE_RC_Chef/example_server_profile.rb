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

#
# The following example would bring up a new physical server in enclosure 1, bay 2 of the data center the following example
#
oneview_server_profile 'ServerProfile2' do 
  client my_client 
  data( 
       description: 'Override Description', 
       boot: { 
               order: [], 
               manageBoot: true 
             } 
      ) 
  server_profile_template'ServerProfileTemplate1' 
  server_hardware 'Encl1, bay 2' 
end

#
# Note the fine-grained control this Chef recipe gives over the hardware and software. The new blade server is assigned in the
# bottom rack of the enclosure in bay 4 and the firmware can also be updated using Chef.
#
oneview_server_profile 'Chef-Node-1' do 
  client my_client 
  server_hardware 'BOT-CN75150107, bay 4' 
  server_hardware_type 'SY 480 Gen9 CNA Only' 
  enclosure_group 'EnclosureGroup1' 
  server_profile_template 'RedHat 7.3' 
end
