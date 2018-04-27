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
$vcenter_server = <vcenter instance>
$vcenter_user = 'administrator@vsphere.local'
$vcenter_password = Read-Host -Prompt 'Enter the vCenter password for user $vcenter_user'
$vcenter_datastore = <Datastore you are going to install the OVAs to>
$vcenter_vmhost = <The ESXi host that has access the above datastore>
$vcenter_cert_action = 'ignore' # If you have a self signed certificate

# Download phase
if (-Not (Test-Path chef-server-centos.ova)) {
  Write-Host "Downloading the chef-server-centos.ova file"
  $wc = New-Object net.webclient
  $chef_server_url='http://chef-ova.io/chef/chef-server-centos.ova'
  $chef_server_out='chef-server-centos.ova'
  $chef_server_dl = $PSScriptRoot + "\" + $chef_server_out
  $wc.Downloadfile($chef_server_url, $chef_server_dl)
}

if (-Not (Test-Path automate-server-centos.ova)) {
  Write-Host "Downloading the automate-server-centos.ova file"
  $wc = New-Object net.webclient
  $automate_server_url='http://chef-ova.io/chef/automate-server-centos.ova'
  $automate_server_out='automate-server-centos.ova'
  $automate_server_dl = $PSScriptRoot + "\" + $automate_server_out
  $wc.Downloadfile($automate_server_url, $automate_server_dl)
}

# Upload to vSphere phase
# Connect to the vCenter Instance
Set-PowerCLIConfiguration -InvalidCertificateAction $vcenter_cert_action -confirm:$false
Connect-VIServer -Server $vcenter_server -User $vcenter_user -Password $vcenter_password
$mydatastore = Get-Datastore -Name $vcenter_datastore
$vmhost = Get-VMhost -Name $vcenter_vmhost

if ( (Get-VM | Where-Object {$_.Name -eq "chef-server-centos"}).count -eq 0 ) {
  $chef_server_out='chef-server-centos.ova'
  $chef_server_dl = $PSScriptRoot + "\" + $chef_server_out
  Write-Host "Uploading chef-server-centos.ova to vcenter server $vcenter_server, datastore $vcenter_datastore"
  $vmhost | Import-VApp -Source $chef_server_dl -Datastore $mydatastore -Force
}

if ( (Get-VM | Where-Object {$_.Name -eq "automate-server-centos"}).count -eq 0 ) {
  $automate_server_out='automate-server-centos.ova'
  $automate_server_dl = $PSScriptRoot + "\" + $automate_server_out
  Write-Host "Uploading automate-server-centos.ova to vcenter server $vcenter_server, datastore $vcenter_datastore"
  $vmhost | Import-VApp -Source $automate_server_dl -Datastore $mydatastore -Force
}

Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
