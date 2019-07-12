Function AddRawDisktoCSV{


Param(
[string]$diskname=""
)


$diskinfo=Get-Disk | Where partitionstyle -eq ‘raw’  

Initialize-Disk -Number $diskinfo.number -PartitionStyle GPT -PassThru -Verbose

Start-Sleep -Seconds 15

Write-Host "Creating Partition on "$diskinfo.friendlyname""
 
New-Partition -DiskNumber $diskinfo.Number -UseMaximumSize  -WarningAction Continue| Format-Volume -FileSystem NTFS -NewFileSystemLabel $diskname -Confirm:$false -Verbose

Get-ClusterAvailableDisk | Add-ClusterDisk| Add-ClusterSharedVolume $diskname -Verbose 

Get-ClusterSharedVolume | ?{$_.Name -eq "Cluster Disk 1"} | %{$_.Name = $diskname}

Rename-Item -Path C:\ClusterStorage\Volume1 -NewName C:\ClusterStorage\"$diskname"


}


