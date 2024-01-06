# Enable Script Excution 
Set-ExecutionPolicy RemoteSigned -Force
# Define the registry key path
$regKeyPath = "HKLM:\System\CurrentControlSet\Services\TCPIP6\Parameters"

# Define the registry value name and data
$regValueName = "DisabledComponents"
$regValueData = 0xFF  # Make sure to use an integer value for DWORD

# Check if running with administrative privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "This script requires administrative privileges. Please run the script as an administrator."
    exit
}

# Check if the registry value already exists
$existingValue = Get-ItemProperty -Path $regKeyPath -Name $regValueName -ErrorAction SilentlyContinue

if ($existingValue -eq $null) {
    # Registry value does not exist, create it
    try {
        New-Item -Path $regKeyPath -Force | Out-Null
        Set-ItemProperty -Path $regKeyPath -Name $regValueName -Value $regValueData -Type DWORD
        Write-Host "Registry key updated successfully."
    } catch {
        Write-Host "Error updating the registry key: $_"
    }
#Machine Restart
Restart-Computer -Force

} else {
    # Registry value already exists, display a message
    Write-Host "Registry value '$regValueName' already exists with data $($existingValue.$regValueName)."
}
