# https://www.bsi.bund.de/SharedDocs/Downloads/DE/BSI/Cyber-Sicherheit/SiSyPHus/E20172000_BSI_Win10_AFUNKT_TELE_DEAKTIVIEREN_v1_0.html

# Makes sure you are Admin
#Requires -RunAsAdministrator

# BSI - 2.1 Deaktivierung von Telemetrie-Dienst und ETW Session
## Deaktiviert Benutzererfahrung und Telemetrie im verbundenen Modus (Connected User Experience and Telemetry)
Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\DiagTrack\ -Name Start -Value 4
echo "DiagTrack deaktiviert."
## Deaktiviert die DiagTrack-Listener Session
Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Diagtrack-Listener\ -Name Start -Value 0
echo "DiagTrack-Listener deaktiviert."
## Löschet der Logdatei(en) des Autologgers unter %systemroot%\System32\LogFiles\WMI\Diagtrack-Listener.etl<id>, falls diese vorhanden sind
Remove-Item "LogFiles\WMI\Diagtrack-Listener.etl*"
echo "ggf. vorhandene Diagtrack-Listener-Logfiles gelöscht."

# BSI - 2.2 Deaktivierung Telemetrie nach Microsoft Empfehlung (Nur Enterprise/Education und ab Server 2016)
#  Microsoft weist darauf hin, dass diese Einstellung nicht gewählt werden soll, wenn Windows Updates benötigt werden, da im Falle eines fehlgeschlagenen Updates keine Telemetrie-Daten gesendet werden, welche im Supportfall relevant sein könnten.

## Telemetrie auf Kompatiblen Geräten auf 0 setzen.
$TestForCompatibleWinVersion=(Get-WmiObject -class Win32_OperatingSystem).Caption | Select-String -Pattern "Enterprise","Server 2016","Server 2019","Education"
if($TestForCompatibleWinVersion){
	Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection\ -name AllowTelemetry -Value 0
	Write-Host "AllowTelemetry auf 0 gesetzt" -ForegroundColor Green
	}
	else{
	Write-Host "Betriebssystem für Deaktivierung von Microsoft Telemetrie nicht Unterstützt" -ForegroundColor Yellow
}

$TestForFirewallRule= Get-NetFirewallRule -DisplayName "BlockDiagTrackService" 2> $null;
if($TestForFirewallRule){
    Write-Host 'Firewall Regel "BlockDiagTrackService" existiert schon' -ForegroundColor Yellow
    Remove-NetFirewallRule -DisplayName "BlockDiagTrackService"
    Write-Host 'Firewall Regel "BlockDiagTrackService" wurde gelöscht (um mit defaulteinstellungen neu angelegt zu werden)' -ForegroundColor Yellow
}

New-NetFirewallRule -DisplayName "BlockDiagTrackService" -Name "BlockDiagTrackService" -Direction Outbound -Service "DiagTrack" -Action Block
Write-Host 'Firewall Regel "BlockDiagTrackService" gesetzt' -ForegroundColor Green

