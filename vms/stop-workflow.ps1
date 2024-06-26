workflow stopVM {
    param(
        [string]$vmName,
        [string]$resourceGroup
    )
    InlineScript {
        # Ensures you do not inherit an AzContext in your runbook
        $null = Disable-AzContextAutosave -Scope Process

        # Connect using a Managed Service Identity
        try {
            $AzureConnection = (Connect-AzAccount -Identity).context
        }
        catch {
            Write-Output "There is no system-assigned user identity. Aborting." 
            exit
        }

        # set and store context
        $AzureContext = Set-AzContext -SubscriptionName $AzureConnection.Subscription -DefaultProfile $AzureConnection

        Stop-AzVM -ResourceGroupName $using:resourceGroup -Name $using:vmName
    }
}
