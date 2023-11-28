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

            $service = Get-ArubaCPService -limit 1000 | Sort-Object order_no
            $enf_policy = (Invoke-ArubaCPRestMethod "api/enforcement-policy" -limit 1000)._embedded.items
            $enf_profile = (Invoke-ArubaCPRestMethod "api/enforcement-profile" -limit 1000)._embedded.items

            if ($service -and $InfoLevel.Service -ge 1) {
                Section -Style Heading3 'Summary' {
                    Paragraph "The following section details Settings Summary configured on ClearPass."
                    BlankLine

                    #Service, Enforcement (policy or profile) start with [ is configured by default (factory) on Clearpass
                    $service_count = @($Service).count
                    $service_count_default = @($service | Where-Object {$_.name -like '`[*' }).Count

                    $service_count_enabled = @($Service | Where-Object {$_.enabled -eq 'true' }).count
                    $service_count_enabled_default = @($service | Where-Object {$_.name -like '`[*' -and $_.enabled -eq 'true'}).Count

                    $enf_policy_count = @($enf_policy).count
                    $enf_policy_count_default = @($enf_policy | Where-Object {$_.name -like '`[*' }).count

                    $enf_profile_count = @($enf_profile).count
                    $enf_profile_count_default = @($enf_profile | Where-Object {$_.name -like '`[*' }).count

                    $OutObj = @()
                    $OutObj = [pscustomobject]@{
                        "Service" = "$service_count (default: $service_count_default)"
                        "Service Enabled" = "$service_count_enabled (default: $service_count_enabled_default)"
                        "Enforcement Policy" = "$enf_policy_count (default: $enf_policy_count_default)"
                        "Enforcement Profile" = "$enf_profile_count (default: $enf_profile_count_default)"
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