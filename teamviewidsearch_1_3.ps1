<#

Määritetään ensimmäisenä muutujat ja scriptblock elementit. Luodaan objecti käyttämällä ForEach Statement rakennetta.
Tulostetaan kerätty tieto csv formaatina ulos. PSRemoting pitää olla päällä jotta komento toimisi.

#>



If ( Get-Module -ListAvailable | Where-Object ($_.name -eq 'Active Directory') ){ #tarkistetaan onko moduulia koneessa.

 

        Import-Modules Active Directory
		
    $computers = Get-ADComputer -Filter * -SearchBase 'DC=sro,DC=local' | Select CN # Listataan tietokoneet, Voidaan määrittää haku johonkin muuhunkin container

	ForEach (  $computer in $computers ){
	$TeamIDJob = Invoke-Command -ComputerName $computer -ScriptBlock {Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Teamviewer | Select-Object ClientID} -AsJob |Wait-Job -Timeout 1 |  Get-Job | Receive-Job | Select-Object ClientId #totetutetaan toimenpide etsi Teamviewer ID koneesta.
	}
	
	ForEach (  $computer in $computers ){
		$Name = Invoke-Command -ComputerName $computer -ScriptBlock {Get-ChildItem -Path env:computername | Select-Object Value} -AsJob | Wait-Job -Timeout 1 |  Get-Job | Receive-Job | Select-Object Value  # Etsiään myös koneen nimi. 
	}

	$teamIDobject New-Object PSObject -Property {

		'Tietokone' = $Name
		'TeamviewerID' = $TeamIDJob 

}
 

    $teamIDobject | Export-Csv -NoTypeInformation -Path .\teamidlist.csv #Tulostetaan tieto suhteelisen polun avulla siihen kansioon jossa scripti sijaiksee.

} Else {

Write-Output 'Vaaditavaa moduulia ei ole. Asenna Remote Server Administration Tools tai aja scripti AD palvelimessa.' #varoitusviesti.
} # If Else rakenne loppuu.


