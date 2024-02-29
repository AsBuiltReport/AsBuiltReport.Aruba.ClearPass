function Get-AbrCPPMLicense {
    <#
    .SYNOPSIS
        Used by As Built Report to returns License settings.
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
        Write-PScriboMessage "Discovering License settings information from $System."
    }

    process {
        Section -Style Heading2 'License' {
            Paragraph "The following section details License settings configured on ClearPass."
            BlankLine

            $summary = (Invoke-ArubaCPRestMethod "api/application-license/summary").items
            $app_license = Get-ArubaCPApplicationLicense

            if ($summary -and $InfoLevel.License -ge 1) {
                Section -Style Heading3 'Summary' {
                    Paragraph "The following section details license Summary configured on ClearPass."
                    BlankLine

                    $OutObj = @()
                    foreach ($item in $summary) {
                        $OutObj += [pscustomobject]@{
                            "Type"    = $item.license_type
                            "Count"   = $item.licensed_count
                            "Used"    = $item.used_count
                            "Updated" = $item.updated_at
                        }
                    }

                    $TableParams = @{
                        Name         = "License Summary"
                        List         = $false
                        ColumnWidths = 25, 25, 25, 25
                    }

                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }

                    $OutObj | Table @TableParams

                }
            }

            if ($app_license -and $InfoLevel.License -ge 1) {
                Section -Style Heading3 'Application License' {
                    Paragraph "The following section details license Application License configured on ClearPass."
                    BlankLine

                    $OutObj = @()
                    foreach ($lic in $app_license) {
                        $OutObj += [pscustomobject]@{
                            "Product Name"      = $lic.product_name
                            "Licence Type"      = $lic.license_type
                            "User Count"        = $lic.user_count
                            "Licence Added "    = $lic.license_added_on
                            "Activation Status" = $lic.activation_status
                        }
                    }

                    $TableParams = @{
                        Name         = "Application License Summary"
                        List         = $false
                        ColumnWidths = 20, 20, 15, 25, 20
                    }

                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }

                    $OutObj | Table @TableParams

                    if ($InfoLevel.License -ge 2) {

                        Paragraph "The following section details license Application License configured on ClearPass."
                        BlankLine
                        foreach ($lic in $app_license) {
                            Section -Style Heading3 "Application License: $($lic.product_name) $($lic.product_id)" {
                                $OutObj = @()

                                if ($Options.HideLicenseKey) {
                                    $key = $lic.license_key -replace '(?s)-----BEGIN .*? KEY-----.*?-----END .*? KEY-----', '-----BEGIN [Anonymised] KEY-----'
                                }
                                else {
                                    $key = $lic.license_key
                                }

                                $OutObj = [pscustomobject]@{
                                    "Product Id"        = $lic.product_id
                                    "Product Name"      = $lic.product_name
                                    "Licence Key"       = $key
                                    "Licence Type"      = $lic.license_type
                                    "User Count"        = $lic.user_count
                                    "Duration"          = "$($lic.duration) $($lic.duration_units)"
                                    "Licence Added "    = $lic.license_added_on
                                    "Activation Status" = $lic.activation_status
                                }

                                $TableParams = @{
                                    Name         = "Application License: $($lic.product_name) $($lic.product_id)"
                                    List         = $true
                                    ColumnWidths = 20, 80
                                }

                                if ($Report.ShowTableCaptions) {
                                    $TableParams['Caption'] = "- $($TableParams.Name)"
                                }

                                $OutObj | Table @TableParams
                            }
                        }
                    }
                }
            }
        }

    }

    end {

    }

}