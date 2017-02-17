<#

Määritetään ensimmäisenä muutujat ja scriptblock elementit. Luodaan objecti käyttämällä ForEach Statement rakennetta.
Tulostetaan kerätty tieto csv formaatina ulos. PSRemoting pitää olla päällä jotta komento toimisi.

#>

If ( Get-Module -ListAvailable | Where-Object ($_.name -eq 'Active Directory') ){ #tarkistetaan onko moduulia koneessa.

 

        Import-Modules Active Directory

    $scriptblockteamid = Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Teamviewer | Select-Object ClientID #Etsitään Teamviewer ID
    $GetName = Get-ChildItem -Path env:computername | Select-Object Value # Haetaan tietokoneen nimi env kautta.
    $computers = Get-ADComputer -Filter * -SearchBase 'DC=,DC=' | Select CN # Listataan tietokoneet, Voidaan määrittää haku johonkin muuhunkin container




  $teamIDobject = ForEach (  $computer in $computers ) {   # TeamIDobject luodaan ForEach loop statement avulla.
   

        $TeamIDJob = Invoke-Command -ComputerName $computer -ScriptBlock $scriptblockteamid -AsJob |
					Wait-Job -Timeout 1 |  Get-Job | Receive-Job | Select-Object ClientId #totetutetaan toimenpide etsi Teamviewer ID koneesta.
        $Name = Invoke-Command -ComputerName $computers -ScriptBlock $GetName -AsJob |
				Wait-Job -Timeout 1 |  Get-Job | Receive-Job | Select-Object Value  # Etsiään myös koneen nimi. 
        #Wait-Job komentoa käytetään jotta työ ehdittäisiin suorittaa ennen pipeline receive-job
        #

                       
           [PSCustomObject]@{  # Käytetään PSCustomObject ominaisuutta

            'Tietokone' = $Name   # ensimmäinen sarake, Tietokoneen nimi 
            'TeamviewerID'   = $TeamIDJob # toinen sarake, Tietokoneen TeamviewerID
    
            }     #teamIDobject and forEach Loop statement end                                                     

     

}  #ForEach loop loppuu


# 

    $teamIDobject | Export-Csv -NoTypeInformation -Path .\teamidlist.csv #Tulostetaan tieto suhteelisen polun avulla siihen kansioon jossa scripti sijaiksee.

} Else {

Write-Output 'Vaaditavaa moduulia ei ole. Asenna Remote Server Administration Tools tai aja scripti AD palvelimessa.' #varoitusviesti.
} # If Else rakenne loppuu.
