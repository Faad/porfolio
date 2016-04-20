$adconnection = "OU=Asennus, OU=Kauniainen, OU=diak, DC=diak, DC=fi" ## määritetään mistä kysely tehdään
$adpropertie= @("Name", "Created", "Description", "LastLogonDate", "OperatingSystem") ## määritetään kerättävät arvot
$suomenkielinen= @{Expression= {$_.Name};Label="Nimi"},                          ## määritetään taulun nimet
                  @{Expression= {$_.Created};Label="Luotu"},
                  @{Expression= {$_.Description};Label="Kuvaus"},
                  @{Expression= {$_.LastLogonDate};Label="Viimeisin kirjautuminen"},
                  @{Expression= {$_.OperatingSystem};Label="Kayttojarjestelma"}
 
 <#

 Tiedot syötetään Get-ADComputer komentoon. Suodatetaan halutuut muotoon. 

 #>
                 
 
 Get-ADComputer -Filter * -SearchBase $adconnection -Properties $adpropertie | Select $adpropertie |
    Select-Object $suomenkielinen | Export-Csv ".\tietokonelista2.csv" -NoTypeInformation
    
    ## jos siirtää csv tiedostoon dataa on käytettävä Select-Object

    ##Get-ADComputer -Filter * -SearchBase "OU=Asennus,OU=Kauniainen,OU=diak,DC=diak,DC=fi"