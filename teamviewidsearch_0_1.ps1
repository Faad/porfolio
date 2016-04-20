$adserver = "DC=sro,DC=local" 
$scriptblockteamid = Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Teamviewer | Select-Object ClientID
$Domainlist = {} 

$computer = Get-ADComputer -Filter * -SearchBase $adserver | Select CN

$table = @{Expression={$_.CN}; Label="Tietokone"},
        @{Expression={$_.ClientID}; Label="TeamviewerID"}

<#

Pitää luoda array, joka täytetään tietokoneiden cn nimillä.
Objektin luonin aikana verrataan onko Invoke-Command komennon kohteen nimi sama kuin hash taulussa oleva nimi.
Jos ne vastaavat toisia, luodaan record objectiin.

#>


<#

Luodaan objekti jolla on cn nimi ominaisuus ja teamviewer id

#>


Get-ADComputer -Filter * -SearchBase $adserver | Select-Object CN | ForEarch-Object  {  # jokaisesta cn luodaan objeksti jolla on ominaisuutena cn ja teamviewer Id.  

$computer = $_ 
$TeamID = Invoke-Command -ComputerName $Domainlist -ScriptBlock $scriptblockteamid -AsJob

New-Object -TypeName TeamObject -Property @{
    Computer = $computer.CN
    TeamID = $TeamID
    }
}

#Invoke-Command -ComputerName $Domainlist -AsJob {Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Teamviewer | Select-Object ClientID} 

  <#
  
  Get-ADComputer -Filter ... | ForEarch-Object  { 

$computer = $_ 
$TeamID = Invoke-Command -ComputerName $Domainlist -AsJob {Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Teamviewer | Select-Object ClientID}

New-Object -TypeName TeamObject -Property @{
    Computer = $computer.
    TeamID = $TeamID
    }




}
  
  #>

Format-Table -Property  -GroupBy $table



