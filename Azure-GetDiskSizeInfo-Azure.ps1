# Define log, output result
$ExportPath = "D:\temp"
$ExportFile = $ExportPath + "\GetDiskSizeInfo-AzureVM.csv"

#Delete output file first
Remove-Item $ExportFile

#Output header
"Computer, Disk, TotalSpace(in GB), UsedSpace(in GB), FreeSpace(in GB)" | Add-Content $ExportFile

# Connect Azure Germany. Need to enter credentials
# se

# Set subscription. By default, current context assigned to subscription "Production"
# DE Testing     ID: 69318b14-5b0e-4694-aee1-c89571ac2979
# DE Playground  ID: 66177410-b204-4004-b5a1-2752619b89ab
# DE Production  ID: 458b5608-0edf-48ee-90c5-cfe2540a895d 
# MS Azure De    ID: 5c0ddd7b-399e-4ea6-a812-1bad05e4629d

$subDETestID = "69318b14-5b0e-4694-aee1-c89571ac2979"
$subDEPgID   = "66177410-b204-4004-b5a1-2752619b89ab"
$subDEPrdID  = "458b5608-0edf-48ee-90c5-cfe2540a895d"
$subMSAzDEID = "5c0ddd7b-399e-4ea6-a812-1bad05e4629d"

# Set DE Testing
Set-AzContext -Subscription $subDETestID

# vm-db-testing
$rgName      = "testing_azuredc01"
$vmName      = "vm-db-testing"
$vm   = Get-AzVM -ResourceGroupName $rgName -Name $vmName
$osdisk = Get-AzDisk -ResourceGroupName $rgName -DiskName $vm.StorageProfile.OsDisk.Name
$output = $vmName + "," + $vm.StorageProfile.OsDisk.Name + "," + $osdisk.DiskSizeGB
$output | Add-Content $ExportFile

# vm-win16-test
$rgName      = "testing_azuredc01"
$vmName      = "vm-win16-test"
$vm   = Get-AzVM -ResourceGroupName $rgName -Name $vmName
$osdisk = Get-AzDisk -ResourceGroupName $rgName -DiskName $vm.StorageProfile.OsDisk.Name
$output = $vmName + "," + $vm.StorageProfile.OsDisk.Name + "," + $osdisk.DiskSizeGB
$output | Add-Content $ExportFile


# Set DE Playground
Set-AzContext -Subscription $subDEPgID

# payment-vm-test
$rgName      = "payment-group-test"
$vmName      = "payment-vm-test"
$vm   = Get-AzVM -ResourceGroupName $rgName -Name $vmName
$osdisk = Get-AzDisk -ResourceGroupName $rgName -DiskName $vm.StorageProfile.OsDisk.Name
$output = $vmName + "," + $vm.StorageProfile.OsDisk.Name + "," + $osdisk.DiskSizeGB
$output | Add-Content $ExportFile


# Set DE Production
Set-AzContext -Subscription $subDEPrdID

# vm-airp-crw01
$rgName      = "hoteldb-crawler-prd"
$vmName      = "vm-airp-crw01"
$vm   = Get-AzVM -ResourceGroupName $rgName -Name $vmName
$osdisk = Get-AzDisk -ResourceGroupName $rgName -DiskName $vm.StorageProfile.OsDisk.Name
$output = $vmName + "," + $vm.StorageProfile.OsDisk.Name + "," + $osdisk.DiskSizeGB
$output | Add-Content $ExportFile

#vm-build-prd
$rgName      = "build-azure-prd"
$vmName      = "vm-build-prd"
$vm   = Get-AzVM -ResourceGroupName $rgName -Name $vmName
$osdisk = Get-AzDisk -ResourceGroupName $rgName -DiskName $vm.StorageProfile.OsDisk.Name
$output = $vmName + "," + $vm.StorageProfile.OsDisk.Name + "," + $osdisk.DiskSizeGB
$output | Add-Content $ExportFile

#vm-rbes-prd
$rgName      = "rg-invoice-auto-process-prd"
$vmName      = "vm-rbes-prd"
$vm   = Get-AzVM -ResourceGroupName $rgName -Name $vmName
$osdisk = Get-AzDisk -ResourceGroupName $rgName -DiskName $vm.StorageProfile.OsDisk.Name
$output = $vmName + "," + $vm.StorageProfile.OsDisk.Name + "," + $osdisk.DiskSizeGB
$output | Add-Content $ExportFile

#vm-webproxy-prd
$rgName      = "webproxy-prd"
$vmName      = "vm-webproxy-prd"
$vm   = Get-AzVM -ResourceGroupName $rgName -Name $vmName
$osdisk = Get-AzDisk -ResourceGroupName $rgName -DiskName $vm.StorageProfile.OsDisk.Name
$output = $vmName + "," + $vm.StorageProfile.OsDisk.Name + "," + $osdisk.DiskSizeGB
$output | Add-Content $ExportFile


# Set DE Microsoft Azure Deutschland – CSP
Set-AzContext -Subscription $subMSAzDEID

# vm-autoserv-prd
$rgName      = "autoservice-vm-prd"
$vmName      = "vm-autoserv-prd"
$vm   = Get-AzVM -ResourceGroupName $rgName -Name $vmName
$osdisk = Get-AzDisk -ResourceGroupName $rgName -DiskName $vm.StorageProfile.OsDisk.Name
$output = $vmName + "," + $vm.StorageProfile.OsDisk.Name + "," + $osdisk.DiskSizeGB
$output | Add-Content $ExportFile


$rgName      = "mail_azuredc01_prd"
$vmName      = "vm-mail-prod"
$vm   = Get-AzVM -ResourceGroupName $rgName -Name $vmName
$osdisk = Get-AzDisk -ResourceGroupName $rgName -DiskName $vm.StorageProfile.OsDisk.Name
$output = $vmName + "," + $vm.StorageProfile.OsDisk.Name + "," + $osdisk.DiskSizeGB
$output | Add-Content $ExportFile

$rgName      = "ocr_azuredc01_prd"
$vmName      = "vm-ocr1-prd"
$vm   = Get-AzVM -ResourceGroupName $rgName -Name $vmName
$osdisk = Get-AzDisk -ResourceGroupName $rgName -DiskName $vm.StorageProfile.OsDisk.Name
$output = $vmName + "," + $vm.StorageProfile.OsDisk.Name + "," + $osdisk.DiskSizeGB
$output | Add-Content $ExportFile

$rgName      = "ocr_azuredc01_prd"
$vmName      = "vm-ocr2-prd"
$vm   = Get-AzVM -ResourceGroupName $rgName -Name $vmName
$osdisk = Get-AzDisk -ResourceGroupName $rgName -DiskName $vm.StorageProfile.OsDisk.Name
$output = $vmName + "," + $vm.StorageProfile.OsDisk.Name + "," + $osdisk.DiskSizeGB
$output | Add-Content $ExportFile

$rgName      = "web_azuredc01_prd"
$vmName      = "vm-web1-prd"
$vm   = Get-AzVM -ResourceGroupName $rgName -Name $vmName
$osdisk = Get-AzDisk -ResourceGroupName $rgName -DiskName $vm.StorageProfile.OsDisk.Name
$output = $vmName + "," + $vm.StorageProfile.OsDisk.Name + "," + $osdisk.DiskSizeGB
$output | Add-Content $ExportFile