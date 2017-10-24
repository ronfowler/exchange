#https://blogs.technet.microsoft.com/rmilne/2015/03/17/how-to-check-exchange-schema-and-object-values-in-ad/


#Our Exchange Container is not named Exchange so we need to search for it.
$ExchangeContainers = Get-ADObject -SearchBase “CN=Microsoft Exchange,CN=Services,$((Get-ADRootDSE).configurationNamingContext)" -Filter { ObjectClass -eq "msExchOrganizationContainer" }

#Take the first returned object and grab both msExchProductId and objectVersion
$ExchangeContainer = $ExchangeContainers | select -First 1 | Get-ADObject -Properties msExchProductId,objectVersion

#Get the RangeUpper from the schema
$ExchangeSchema = Get-ADObject "CN=ms-Exch-Schema-Version-Pt,$((Get-ADRootDSE).schemaNamingContext)" -Properties RangeUpper

#Get the objectVersion
$ExchangeObjects = Get-ADObject "CN=Microsoft Exchange System Objects,$((Get-ADRootDSE).defaultNamingContext)" -Properties objectVersion

#Create a customobject to return a single row with all of the above information without all the noteproperty junk
$ExchangeInformation = [PSCustomObject]@{
    "msExchProductId"=$ExchangeContainer.msExchProductId
    "RangeUpper"=$ExchangeSchema.RangeUpper
    "objectVersion"=$ExchangeObjects.objectVersion
    "OrgObjectVersion"=$ExchangeContainer.objectVersion
}

$ExchangeInformation
