Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.StartPosition = "Manual"
$form.Size = New-Object System.Drawing.Size(1,1)
$form.Location = New-Object System.Drawing.Point(-1000,-1000)
$form.ShowInTaskbar = $false
$form.TopMost = $true
$form.Show() > $null
$form.Focus() > $null

$current = bcdedit | Select-String "hypervisorlaunchtype" | ForEach-Object {
    ($_ -split '\s{2,}')[1]
}

if ($current -eq "Auto") {
    bcdedit /set hypervisorlaunchtype off > $null
    $status = "Hypervisor OFF"
} else {
    bcdedit /set hypervisorlaunchtype auto > $null
    $status = "Hypervisor ON"
}

$result = [System.Windows.Forms.MessageBox]::Show($form, "$status`nПерезагрузить сейчас?", "Status", 'OKCancel', 'Information')

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    shutdown /r /t 0
}

$form.Close() > $null
$form.Dispose() > $null
