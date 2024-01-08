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
        $server_version = Get-ArubaCPServerVersion
        $configuration = Get-ArubaCPServerConfiguration

        if ($version -and $server_version -and $InfoLevel.System -ge 1) {
            Section -Style Heading2 'Version' {
                Paragraph "The following section details Version settings configured on ClearPass."
                BlankLine

                $OutObj = @()
                $app = $version.app_major_version + "." + $version.app_minor_version + "." + $version.app_service_release
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

                Paragraph "The following section details Patches settings configured on ClearPass."
                BlankLine

                $OutObj = @()
                foreach ($patches in $server_version.installed_patches) {
                    $OutObj += [pscustomobject]@{
                        "Name" = $patches.name
                        #"Description" = $patches.description
                        "Date" = $patches.installed
                    }
                }

                $TableParams = @{
                    Name = "Patches"
                    List = $false
                    ColumnWidths = 50, 50
                    #ColumnWidths = 25, 50, 25
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
                foreach ($conf in $configuration) {
                    $OutObj += [pscustomobject]@{
                        "Name" = $conf.name
                        "DNS Name" = $conf.server_dns_name
                        #"FQDN" = $conf.fqdn
                        "MGMT IP" = $conf.management_ip
                        "DATA IP" = $conf.server_ip
                        "Publisher" = $conf.is_publisher
                        "Insight (Primary)" = "$($conf.is_insight_enabled) ($($conf.is_insight_primary))"
                    }
                }

                $TableParams = @{
                    Name = "Server Configuration"
                    List = $false
                    ColumnWidths = 20, 20, 16, 16, 12, 16
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