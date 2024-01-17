function Invoke-AsBuiltReport.Aruba.ClearPass {
    <#
    .SYNOPSIS
        PowerShell script to document the configuration of Aruba ClearPass in Word/HTML/Text formats
    .DESCRIPTION
        Documents the configuration of Aruba ClearPass in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.1.0
        Author:         Alexis La Goutte
        Twitter:        @alagoutte
        Github:         alagoutte
        Credits:        Iain Brighton (@iainbrighton) - PScribo module

    .LINK
        https://github.com/AsBuiltReport/AsBuiltReport.Aruba.ClearPass
    #>

    # Do not remove or add to these parameters
    param (
        [String[]] $Target,
        [string] $Token
    )

    Write-PScriboMessage -Plugin "Module" -Message "Please refer to the AsBuiltReport.Aruba.ClearPass GitHub website for more detailed information about this project."
    Write-PScriboMessage -Plugin "Module" -Message "Do not forget to update your report configuration file after each new version release: https://www.asbuiltreport.com/user-guide/new-asbuiltreportconfig/"
    Write-PScriboMessage -Plugin "Module" -Message "Documentation: https://github.com/AsBuiltReport/AsBuiltReport.Aruba.ClearPass"
    Write-PScriboMessage -Plugin "Module" -Message "Issues or bug reporting: https://github.com/AsBuiltReport/AsBuiltReport.Aruba.ClearPass/issues"

    # Check the current AsBuiltReport.Aruba.ClearPass module
    $InstalledVersion = Get-Module -ListAvailable -Name AsBuiltReport.Aruba.ClearPass -ErrorAction SilentlyContinue | Sort-Object -Property Version -Descending | Select-Object -First 1 -ExpandProperty Version

    if ($InstalledVersion) {
        Write-PScriboMessage -Plugin "Module" -Message "AsBuiltReport.Aruba.ClearPass $($InstalledVersion.ToString()) is currently installed."
        $LatestVersion = Find-Module -Name AsBuiltReport.Aruba.ClearPass -Repository PSGallery -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Version
        if ($LatestVersion -gt $InstalledVersion) {
            Write-PScriboMessage -Plugin "Module" -Message "AsBuiltReport.Aruba.ClearPass $($LatestVersion.ToString()) is available."
            Write-PScriboMessage -Plugin "Module" -Message "Run 'Update-Module -Name AsBuiltReport.Aruba.ClearPass -Force' to install the latest version."
        }
    }

    # Import Report Configuration
    $Report = $ReportConfig.Report
    $InfoLevel = $ReportConfig.InfoLevel
    $Options = $ReportConfig.Options

    # Used to set values to TitleCase where required
    $TextInfo = (Get-Culture).TextInfo

    # Update/rename the $System variable and build out your code within the ForEach loop. The ForEach loop enables AsBuiltReport to generate an as built configuration against multiple defined targets.

    #region foreach loop
    foreach ($System in $Target) {

        try {
            #Connection to ClearPass (TODO: Add Parameter for Certificate Check and Port)
            Connect-ArubaCP -Server $System -token $token -SkipCertificateCheck | Out-Null

            #Get Model
            $name = (Get-ArubaCPServerConfiguration | Where-Object { $_.is_publisher -eq "True" }).name
            Write-PScriboMessage "Connect to $System : $name"

            Section -Style Heading1 "Implementation Report $name" {
                Paragraph "The following section provides a summary of the implemented components on the Aruba ClearPass infrastructure."
                BlankLine
                if ($InfoLevel.System.PSObject.Properties.Value -ne 0) {
                    Get-AbrCPPMSystem
                }
                if ($InfoLevel.License.PSObject.Properties.Value -ne 0) {
                    Get-AbrCPPMLicense
                }
                if ($InfoLevel.Certificate.PSObject.Properties.Value -ne 0) {
                    Get-AbrCPPMCertificate
                }
                if ($InfoLevel.Service.PSObject.Properties.Value -ne 0) {
                    Get-AbrCPPMService
                }
                if ($InfoLevel.NetworkDevice.PSObject.Properties.Value -ne 0) {
                    Get-AbrCPPMNetworkDevice
                }
            }
        }
        catch {
            Write-PScriboMessage -IsWarning $_.Exception.Message
        }

        #Disconnect
        Disconnect-ArubaCP -Confirm:$false
    }
    #endregion foreach loop
}
