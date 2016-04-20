<#

Määritetään ensimmäisenä muutujat ja scriptblock elementit. Luodaan objecti käyttämällä ForEach Statement rakennetta.
Tulostetaan kerätty tieto csv formaatina ulos. PSRemoting pitää olla päällä jotta komento toimisi.

#>

If ( Get-Module -ListAvailable | Where-Object ($_.name -eq 'Active Directory') ){ #Checking if computer has needed module to run script
 

        Import-Modules Active Directory

    $scriptblockteamid = Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Teamviewer | Select-Object ClientID #Search Teamvier id
    $GetName = Get-ChildItem -Path env:computername | Select-Object Value # Search a computer name by queryn environmental variable env:computername 
    $computers = Get-ADComputer -Filter * -SearchBase 'DC=sro,DC=local' | Select CN # Listing computer, Changing SearchBase information you can change where query is done.




  $teamIDobject  ForEach (  $computer in $computers ) {   # TeamIDobject is created with ForEach loop statement.
   

        $TeamIDJob = Invoke-Command -ComputerName $computer -ScriptBlock $scriptblockteamid -AsJob |Wait-Job -Timeout 1 |  Get-Job | Receive-Job | Select-Object ClientId # Excute query of an TeamviewerID
        $Name = Invoke-Command -ComputerName $computers -ScriptBlock $GetName -AsJob | Wait-Job -Timeout 1 |  Get-Job | Receive-Job | Select-Object Value  # I am going to do query for a computername . 
        #Wait-Job komentoa käytetään jotta työ ehdittäisiin suorittaa ennen pipeline receive-job
        #

                       
           [PSCustomObject]@{  # Determing properties of a object. 

            'Tietokone' = $Name   # First colum, computername 
            'TeamviewerID'   = $TeamIDJob # Second , Tietokoneen TeamviewerID
    
            }     #teamIDobject and forEach Loop statement end                                                     

     

}  #ForEach loop end


# 

    $teamIDobject | Export-Csv -NoTypeInformation -Path .\teamidlist.csv #Tulostetaan tieto suhteelisen polun avulla siihen kansioon jossa scripti sijaiksee.

} Else {

Write-Output 'Vaaditavaa moduulia ei ole. Asenna Remote Server Administration Tools tai aja scripti AD palvelimessa.' #varoitusviesti.
} # If(){} Else {} statement end.
