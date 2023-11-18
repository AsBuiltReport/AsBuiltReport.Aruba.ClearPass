function Get-AbrCPPMSystem {
    <#
    .SYNOPSIS
        Used by As Built Report to returns System settings.
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
    [CmdletBinding()]
    param (

    )

    begin {
        Write-PScriboMessage "Discovering System settings information from $System."
    }

    process {

        $version = Get-ArubaCPCPPMVersion
        $configuration = Get-ArubaCPServerConfiguration

        if ($version -and $InfoLevel.System -ge 1) {
            Section -Style Heading2 'Version' {
                Paragraph "The following section details Version settings configured on ClearPass."
                BlankLine

                $OutObj = @()
                $app = $version.app_major_version + "." + $version.app_minor_version + ". " + $version.app_service_release
                $OutObj = [pscustomobject]@{
                    "Version" = $app
                    "Build" = $version.app_build_number
                    "Hardware Version" = $version.hardware_version
                    "FIPS" = $version.fips_enabled
                    "Evaluation" = $version.eval_license
                    "Cloud" = $version.cloud_mode
                }

                $TableParams = @{
                    Name = "Version"
                    List = $false
                    ColumnWidths = 20, 16, 16, 16, 16, 16
                }

                if ($Report.ShowTableCaptions) {
                    $TableParams['Caption'] = "- $($TableParams.Name)"
                }

                $OutObj | Table @TableParams
            }
        }

        if ($configuration -and $InfoLevel.System -ge 1) {
            Section -Style Heading2 'Server Configuration' {
                Paragraph "The following section details Server Configuration settings configured on ClearPass."
                BlankLine

                $OutObj = @()
                $OutObj = [pscustomobject]@{
                    "Name" = $configuration.name
                    "DNS Name" = $configuration.server_dns_name
                    "FQDN" = $configuration.fqdn
                    "MGMT IP" = $configuration.management_ip
                    "DATA IP" = $configuration.server_ip
                    "Publisher" = $configuration.is_publisher
                    "Insight" = $configuration.is_insight_enabled
                    "Insight Primary" = $configuration.is_insight_primary
                }

                $TableParams = @{
                    Name = "Server Configuration"
                    List = $true
                    ColumnWidths = 50, 50
                }

                if ($Report.ShowTableCaptions) {
                    $TableParams['Caption'] = "- $($TableParams.Name)"
                }

                $OutObj | Table @TableParams
            }
        }

    }

    end {

    }

}