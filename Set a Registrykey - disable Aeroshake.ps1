#####################################################################################
### Beschreibung:
# Stellt einen registry key so ein wie angegeben.
#  - Egal wo. (Pfade werden automatisch angelegt, existierende Werte (im Schlüssel) überschrieben.
#
### Limitationen:
#  - Es müssen die richtigen Präfixe für den Pfad verwendet werden
#  - Muss als Admin ausgeführt werden
#  - Es müssen gültige Werte angegeben werden. (keine Strings bei einem DWord z.B.)
#####################################################################################
### Todo:
# already existing extra Drives abfangen
# $RegKeyPath | Split-path -qualifier # nur prefix bekommen

############################ Config Set Registry Key ##################################### 
# Wo soll der Key angelegt werden?
# HKLM:\ = HKEY_LOCAL_MACHINE
# HKCU:\ = HKEY_CURRENT_USER
# HKCR:\ = HKEY_CURRENT_ROOT
# HKU:\ = HKEY_USERS
$RegKeyPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" # z.B. "HKLM:\SOFTWARE\Microsoft\Office\16.0\Common\ExperimentEcs\Overrides"
# Wie heisst der Key?
$RegKeyName = "DisallowShaking"
# Mögliche Werte
# String: Specifies a null-terminated string. Used for REG_SZ values.
# ExpandString: Specifies a null-terminated string that contains unexpanded references to environment variables that are expanded when the value is retrieved. Used for REG_EXPAND_SZ values.
# Binary: Specifies binary data in any form. Used for REG_BINARY values.
# DWord: Specifies a 32-bit binary number. Used for REG_DWORD values.
# MultiString: Specifies an array of null-terminated strings terminated by two null characters. Used for REG_MULTI_SZ values.
# Qword: Specifies a 64-bit binary number. Used for REG_QWORD values.
# Unknown: Indicates an unsupported registry data type, such as REG_RESOURCE_LIST values.
$RegKeyType = "DWord"
$RegKeyValue = "1"

############################ Config Set Registry Key ##################################### 


############################ Code Set Registry Key ##################################### 
# Create New-PSDrives when needed

if ( $RegKeyPath.StartsWith("HKCT:") -eq "TRUE") {
    echo "Create PSProvider for HKEY_CLASSES_ROOT"
    New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR
}

if ( $RegKeyPath.StartsWith("HKU:") -eq "TRUE") {
    echo "Create PSProvider for HKEY_USERS"
    New-PSDrive -PSProvider registry -Root HKEY_USERS -Name HKU
}

# Create Path when needed
if (Test-Path $RegKeyPath){
    echo "Registry Path $RegKeyPath already exists"
    } 
    else {
    echo "Create Registry Path $RegKeyPath"
    New-Item -Path $RegKeyPath -Force
}

# Create and Set the Key
echo "Setze Regitry Key $RegKeyPath\$RegKeyName mit Value $RegKeyValue"
Set-ItemProperty -Path $RegKeyPath -Name $RegKeyName -Value $RegKeyValue -Type $RegKeyType

############################ Code Set Registry Key ##################################### 

sleep 5