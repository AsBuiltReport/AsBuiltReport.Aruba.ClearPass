function Get-AbrCPPMService {
    <#
    .SYNOPSIS
        Used by As Built Report to returns Service settings.
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
        Write-PScriboMessage "Discovering Service settings information from $System."
    }

    process {
        PageBreak
        Section -Style Heading2 'Service' {
            Paragraph "The following section details Service settings configured on FortiGate."
            BlankLine

            $service = Get-ArubaCPService | Sort-Object order_no
            $enf_policy = (Invoke-ArubaCPRestMethod "api/enforcement-policy")._embedded.items
            $enf_profile = (Invoke-ArubaCPRestMethod "api/enforcement-profile")._embedded.items

            if ($service -and $InfoLevel.Service -ge 1) {
                Section -Style Heading3 'Summary' {
                    Paragraph "The following section details Settings Summary configured on ClearPass."
                    BlankLine

                    $OutObj = @()
                    $OutObj = [pscustomobject]@{
                        "Service" = @($Service).count
                        "Enforcement Policy" = @($enf_policy).count
                        "Enforcement Profile" = @($enf_profile).count
                    }

                    $TableParams = @{
                        Name = "Service Summary"
                        List = $true
                        ColumnWidths = 50, 50
                    }

                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }

                    $OutObj | Table @TableParams

                }
            }

            if ($service -and $InfoLevel.service -ge 1) {
                Section -Style Heading3 'Service' {
                    Paragraph "The following section details Service configured on ClearPass."
                    BlankLine

                    $OutObj = @()
                    foreach ($srvc in $Service) {
                        $OutObj += [pscustomobject]@{
                            "Id" = $srvc.id
                            "Name" = $srvc.name
                            "Type" = $srvc.type
                            "Enabled" = $srvc.enabled
                            "No" = $srvc.order_no
                            "Policy" = $srvc.enf_policy
                        }
                    }

                    $TableParams = @{
                        Name = "Network Device"
                        List = $false
                        ColumnWidths = 10, 30, 15, 10, 5, 30
                    }

                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }

                    $OutObj | Table @TableParams

                    if ($InfoLevel.service -ge 2) {

                        Paragraph "The following section details Service configured on ClearPass."
                        BlankLine
                        foreach ($srvc in $Service) {
                            Section -Style Heading3 "Service: $($srvc.name)" {
                                $OutObj = @()

                                $OutObj = [pscustomobject]@{
                                    "Name" = $srvc.name
                                    "Type" = $srvc.type
                                    "Template" = $srvc.template
                                    "Enabled" = $srvc.enabled
                                    #"Hit Count" = $srvc.hit_count
                                    "Order No" = $srvc.order_no
                                    "Description" = $srvc.description
                                    "Monitor Mode" = $srvc.monitor_mode
                                    "Auth Sources" = $srvc.auth_sources -join ", "
                                    "Auth zSources" = $srvc.authz_sources -join ", "
                                    "Strip Username" = $srvc.strip_username
                                    "Enforcement Policy" = $srvc.enf_policy
                                    "Rules Match Type" = $srvc.rules_match_type
                                }

                                $TableParams = @{
                                    Name = "Service: $($srvc.name)"
                                    List = $true
                                    ColumnWidths = 20, 80
                                }

                                if ($Report.ShowTableCaptions) {
                                    $TableParams['Caption'] = "- $($TableParams.Name)"
                                }

                                $OutObj | Table @TableParams

                                #Rules Conditions
                                if ($srvc.rules_conditions) {
                                    $OutObj = @()
                                    foreach ($rule in $srvc.rules_conditions) {

                                        $OutObj += [pscustomobject]@{
                                            "Type" = $rule.type
                                            "Name" = $rule.name
                                            "Operator" = $rule.operator
                                            "Value" = $rule.value
                                        }
                                    }

                                    $TableParams = @{
                                        Name = "Rules Conditions: $($srvc.name)"
                                        List = $false
                                        ColumnWidths = 25, 30, 10, 35
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

    }

    end {

    }

}