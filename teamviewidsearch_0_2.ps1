$adserver = "DC=,DC=" 
$scriptblockteamid = Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Teamviewer | Select-Object ClientID
$Domainlist = {} 

$computer = Get-ADComputer -Filter * -SearchBase $adserver | Select CN

$table = @{Expression={$_.CN}; Label="Tietokone"},
        @{Expression={$_.ClientID}; Label="TeamviewerID"}


ForEach (  $list in $computer ) {



}

        $computer = $_ 
        $TeamID = Invoke-Command -ComputerName $Domainlist -ScriptBlock $scriptblockteamid -AsJob

New-Object -TypeName TeamObject -Property @{
    Computer = $computer.CN
    TeamID = $TeamID
    
    }