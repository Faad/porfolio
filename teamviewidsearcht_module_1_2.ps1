$scriptblockteamid = Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Teamviewer | Select ClientID  #Etsitään Teamviewer ID
$GetName = Get-ChildItem -Path env:computername | Select-Object Value # Haetaan tietokoneen nimi env kautta.

$TeamIDJob = Invoke-Command -ComputerName 127.0.0.1 -ScriptBlock {Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Teamviewer | Select ClientID} -AsJob  #totetutetaan toimenpide etsi Teamviewer ID koneesta.
$Name = Invoke-Command -ComputerName localhost -ScriptBlock $GetName -AsJob # Etsiään myös koneen nimi.
                        
   $g=  Invoke-Command -ComputerName 127.0.0.1 -ScriptBlock {Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Teamviewer |select ClientId} -AsJob |Wait-Job -Timeout 1 |  Get-Job | Receive-Job | Select-Object ClientId
                Receive-Job -job $g


Invoke-Command -ComputerName 127.0.0.1 -ScriptBlock {Get-ChildItem -Path env:computername |Select-Object Value} -AsJob | Wait-Job -Timeout 1 |  Get-Job | Receive-Job | Select-Object Value



$scriptblockteamid = Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Teamviewer | Select-Object ClientID #Etsitään Teamviewer ID
$GetName = Get-ChildItem -Path env:computername | Select-Object Value # Haetaan tietokoneen nimi env kautta.


    $TeamIDJob = Invoke-Command -ComputerName 127.0.0.1 -ScriptBlock{Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Teamviewer | Select-Object ClientID} -AsJob |Wait-Job -Timeout 1 |  Get-Job | Receive-Job | Select-Object ClientId #totetutetaan toimenpide etsi Teamviewer ID koneesta.
    $Name = Invoke-Command -ComputerName 127.0.0.1 -ScriptBlock {Get-ChildItem -Path env:computername | Select-Object Value} -AsJob | Wait-Job -Timeout 1 |  Get-Job | Receive-Job | Select-Object Value  # Etsiään myös koneen nimi.

            
            $teamIDobject =New-Object PSObject -Property @{  # Määritetään Objectin ominaisuudet.

            'Tietokone' = $Name    # ensimmäinen sarake, Tietokoneen nimi 
            'TeamviewerID'   = $TeamIDJob # toinen sarake, Tietokoneen TeamviewerID
    
            }      
         $teamIDobject|Get-Member 
        
        Export-Csv -NoTypeInformation -Path .\teamidlist.csv


<#
If ( Get-Module -ListAvailable | Where-Object ($_.name -eq 'Active Directory') ) {

Write-Output 'Toimii'

    } Else {

Write-Output 'Vaaditavaa moduulia ei ole. Asenna Remote Server Administration Tools tai aja scripti AD palvelimessa.'

}


funktio rakenne
    moduulien arviointi
    sessessiondebug
    prosessi

 ?
#>