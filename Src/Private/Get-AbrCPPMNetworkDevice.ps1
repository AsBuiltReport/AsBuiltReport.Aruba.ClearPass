function Get-AbrCPPMNetworkDevice {
    <#
    .SYNOPSIS
        Used by As Built Report to returns Network Device settings.
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
        Write-PScriboMessage "Discovering Network Device settings information from $System."
    }

    process {
        Section -Style Heading2 'Network Device' {
            Paragraph "The following section details Network Device settings configured on FortiGate."
            BlankLine

            $NetworkDevice = Get-ArubaCPNetworkDevice -limit 1000
            $NetworkDeviceGroup = Get-ArubaCPNetworkDeviceGroup -limit 1000

            if ($NetworkDevice -and $NetworkDeviceGroup -and $InfoLevel.NetworkDevice -ge 1) {
                Section -Style Heading3 'Summary' {
                    Paragraph "The following section provides a summary of Network Device settings."
                    BlankLine

                    $OutObj = @()
                    $OutObj = [pscustomobject]@{
                        "Network Device"       = @($NetworkDevice).count
                        "Network Device Group" = @($NetworkDeviceGroup).count
                    }

                    $TableParams = @{
                        Name         = "Network Device Summary"
                        List         = $true
                        ColumnWidths = 50, 50
                    }

                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }

                    $OutObj | Table @TableParams

                }
            }

            if ($NetworkDevice -and $InfoLevel.NetworkDevice -ge 1) {
                Section -Style Heading3 'Network Device' {
                    Paragraph "The following section details Network Device configured on ClearPass."
                    BlankLine

                    $OutObj = @()
                    foreach ($nad in $NetworkDevice) {
                        $OutObj += [pscustomobject]@{
                            "Id"          = $nad.id
                            "Name"        = $nad.name
                            "Description" = $nad.license_type
                            "IP Address"  = $nad.ip_address
                            "Vendor"      = $nad.vendor_name
                            "CoA "        = $nad.coa_capable
                        }
                    }

                    $TableParams = @{
                        Name         = "Network Device"
                        List         = $false
                        ColumnWidths = 10, 25, 25, 15, 15, 10
                    }

                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }

                    $OutObj | Table @TableParams

                }
            }

            if ($NetworkDeviceGroup -and $InfoLevel.NetworkDevice -ge 1) {
                Section -Style Heading3 'Network Device Group' {
                    Paragraph "The following section details Network Device Group configured on ClearPass."
                    BlankLine

                    $OutObj = @()
                    foreach ($ndg in $NetworkDeviceGroup) {
                        $OutObj += [pscustomobject]@{
                            "Id"           = $ndg.id
                            "Name"         = $ndg.name
                            "Description"  = $ndg.description
                            "Group Format" = $ndg.group_format
                            "Value"        = $ndg.value
                        }
                    }

                    $TableParams = @{
                        Name         = "Network Device Group"
                        List         = $false
                        ColumnWidths = 10, 25, 25, 10, 30
                    }

                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }

                    $OutObj | Table @TableParams

                }
            }
        }

    }

    end {

    }

}