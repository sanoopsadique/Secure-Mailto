
#checking RSAT AD status & installing if not present
$adm = Get-WindowsCapability -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0 -Online
if($adm.state -eq 'NotPresent') {
    Write-Output 'Required modules are not installed on the machine. Starting installation'
    Add-WindowsCapability -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0 -Online
    Write-Output 'Installed required modules. Starting script'
}
else{
    Write-Output 'Required modules are present in the system. Starting script'
}


#Start
import-module ActiveDirectory
$choice = 'e'

$departments = @{
    EXEC = '0'
    TLMC = '1'
    PG = '2'
    SAITSA = '3'
    BOD = '4'
    ESS = '5'
    GR = '6'
    ARIS = '7'
    VPAS = '9'
    VPER = '10'
    VPFI = '11'
    ECA = '13'
    ER = '5'
    IA = '12'
    IPA = '13'
    FM = '14'
    FIN = '15'
    ITS = '16'
    SEM = '17'
    CS = '18'
    MA = '21'
    CNST = '24'
    ICT = '25'
    EN = '27'
    HT = '28'
    LS = '29'
    LAS = '30'
    TRN = '31'
    PQD = '4091'
    CALS = '42'
    HPS = '44'
    BUS = '45'
    CAEI = '51'
    ES = '52'
    AD = '54'
    AR = '56'
    CM = '59'
    OTR = '60'
    AREC = '61'
    CDIC = '62'
    CDCTS = '70'
    CDPP = '71'
    CDIP = '72'
    CDBO = '73'
    CDMC = '74'
    CDBIA = '77'
    COMM = '81'
    MARK = '82'
    CE = '83'
    SP = '84'
    SADT = '83'
    0 = '0'
    1 = '1'
    2 = '2'
    3 = '3'
    4 = '4'
    5 = '5'
    6 = '6'
    7 = '7'
    8 = '8'
    9 = '9'
    10 = '10'
    11 = '11'
    13 = '13'
    12 = '12'
    14 = '14'
    15 = '15'
    16 = '16'
    17 = '17'
    18 = '18'
    21 = '21'
    24 = '24'
    25 = '25'
    27 = '27'
    28 = '28'
    29 = '29'
    30 = '30'
    31 = '31'
    4091 = '4091'
    42 = '42'
    44 = '44'
    45 = '45'
    51 = '51'
    52 = '52'
    54 = '54'
    56 = '56'
    59 = '59'
    60 = '60'
    61 = '61'
    62 = '62'
    70 = '70'
    71 = '71'
    72 = '72'
    73 = '73'
    74 = '74'
    77 = '77'
    81 = '81'
    82 = '82'
    83 = '83'
    84 = '84'
    
}

while (($choice -eq 'e') -or ($choice -eq 'E')) {
    
#Input computername
$asset= Read-Host -Prompt "Enter the asset tag#"

#Input localadmin account
$admin= Read-Host -Prompt "Enter the email of local admin account"

#Input department name
$dept= Read-Host -Prompt "Enter the department name"

$current_name = $env:computername
$new_name = $dept+$asset
$ou = $departments[$dept]
$ou_path = 'OU='+$ou+',OU=Staff,OU=PCs,DC=ACDM,DC=DS,DC=SAIT,DC=CA'

#Confirm
Write-Output '________________________________________________________'`r`n'Computer will be renamed from '$current_name' to '$new_name`r`n$admin' will be added as local administrator'`r`n'Device will be added to OU# '$ou
Write-Output '________________________________________________________'
$choice= Read-Host -Prompt 'Do you want to continue? (y -> Yes | n -> No | e -> Edit Values)[y]'

}
if(($choice -eq 'y') -or ($choice -eq 'Y') -or ($choice -eq '')) {
    
    # Adding computer to OU
    $Credential = Get-Credential acdm\saitmgr 
    Get-ADComputer $current_name -Credential $Credential | Move-ADObject -TargetPath $ou_path -Verbose -Credential $Credential

    # Adding user to the local admin group
    $user = Get-AdUser -Filter {emailaddress -eq $admin} -Credential $Credential
    if(!$user) { 
        Write-Output 'Error: User not found in active directory'
    }
    else {
        Add-LocalGroupMember -Group "Administrators" -Member $user.SamAccountName -Verbose
    }
    
    #Renaming computer
    Rename-Computer $new_name -Force -Verbose -DomainCredential $Credential

    #Restart
    $choice= Read-Host -Prompt "Do you want to restart now? (y/n)[y]"
    if(($choice -eq 'y') -or ($choice -eq 'Y') -or ($choice -eq '')) {
        Restart-Computer -Force
    }
    else {
        Write-Output 'Exiting script. Restart later to apply changes'
    }

}
else {
    Write-Output 'Cancelled and exiting'
}

