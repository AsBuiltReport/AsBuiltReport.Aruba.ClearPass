function Get-AbrCPPMAuthentication {
    <#
    .SYNOPSIS
        Used by As Built Report to returns Authentication settings.
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
        Write-PScriboMessage "Discovering Authentication settings information from $System."
    }

    process {
        Section -Style Heading2 'Authentication' {
            Paragraph "The following section details Authentication settings configured on ClearPass."
            BlankLine

            $Method = Get-ArubaCPAuthMethod -limit 1000
            $Source = Get-ArubaCPAuthSource -limit 1000

            if ($Method -and $Source -and $InfoLevel.Authentication -ge 1) {
                Section -Style Heading3 'Summary' {
                    Paragraph "The following section provides a summary of Authentication settings."
                    BlankLine

                    #Method, Source start with [ is configured by default (factory) on Clearpass
                    $method_count = @($Method).count
                    $method_count_default = @($Method | Where-Object { $_.name -like '`[*' }).Count

                    $source_count = @($Source).count
                    $source_count_default = @($Source | Where-Object { $_.name -like '`[*' }).Count

                    $OutObj = @()
                    $OutObj = [pscustomobject]@{
                        "Method" = "$method_count (default: $method_count_default)"
                        "Source" = "$source_count (default: $source_count_default)"
                    }

                    $TableParams = @{
                        Name         = "Authentication Summary"
                        List         = $true
                        ColumnWidths = 50, 50
                    }

                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }

                    $OutObj | Table @TableParams

                }
            }

            if ($Method -and $InfoLevel.Authentication -ge 1) {
                Section -Style Heading3 'Authentication Method' {
                    Paragraph "The following section details Authentication Method configured on ClearPass."
                    BlankLine

                    $OutObj = @()
                    foreach ($m in $Method) {
                        $OutObj += [pscustomobject]@{
                            "Id"            = $m.id
                            "Name"          = $m.name
                            "Description"   = $m.description
                            "Method Type"   = $m.method_type
                            "Inner Methods" = $m.inner_methods
                            "Details Count" = @($m.details | Get-Member -Type NoteProperty).count
                        }
                    }

                    $TableParams = @{
                        Name         = "Authentication Method"
                        List         = $false
                        ColumnWidths = 10, 25, 25, 15, 15, 10
                    }

                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }

                    $OutObj | Table @TableParams

                    if ($InfoLevel.Authentication -ge 2) {

                        Paragraph "The following section details Authentification Method configured on ClearPass."
                        BlankLine
                        foreach ($m in $Method) {
                            Section -Style Heading3 "Authentication Method: $($m.name)" {
                                $OutObj = @()

                                $OutObj = [pscustomobject]@{
                                    "Id"            = $m.id
                                    "Name"          = $m.name
                                    "Description"   = $m.description
                                    "Method Type"   = $m.method_type
                                    "Inner Methods" = $m.inner_methods
                                }

                                $TableParams = @{
                                    Name         = "Authentification Method: $($m.name)"
                                    List         = $true
                                    ColumnWidths = 20, 80
                                }

                                if ($Report.ShowTableCaptions) {
                                    $TableParams['Caption'] = "- $($TableParams.Name)"
                                }

                                $OutObj | Table @TableParams

                                #Details
                                if (@($m.details | Get-Member -Type NoteProperty).count) {
                                    $OutObj = @()
                                    foreach ($detail in $m.details.PSObject.Properties) {

                                        $OutObj += [pscustomobject]@{
                                            "Name"  = $detail.name
                                            "Value" = $detail.value
                                        }

                                    }

                                    $TableParams = @{
                                        Name         = "Details : $($m.name)"
                                        List         = $false
                                        ColumnWidths = 40, 60
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

            if ($Source -and $InfoLevel.Authentication -ge 1) {
                Section -Style Heading3 'Authentication Source' {
                    Paragraph "The following section details Authentication Source configured on ClearPass."
                    BlankLine

                    $OutObj = @()
                    foreach ($s in $source) {
                        $OutObj += [pscustomobject]@{
                            "Id"            = $s.id
                            "Name"          = $s.name
                            "Description"   = $s.description
                            "Type"          = $s.type
                            "Authorization" = $s.use_for_authorization
                        }
                    }

                    $TableParams = @{
                        Name         = "Authentication Source"
                        List         = $false
                        ColumnWidths = 10, 25, 25, 10, 30
                    }

                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }

                    $OutObj | Table @TableParams

                    if ($InfoLevel.Authentication -ge 2) {

                        Paragraph "The following section details Authentification Source configured on ClearPass."
                        BlankLine
                        foreach ($s in $Source) {
                            Section -Style Heading3 "Authentication Source: $($s.name)" {
                                $OutObj = @()

                                $OutObj = [pscustomobject]@{
                                    "Id"            = $s.id
                                    "Name"          = $s.name
                                    "Description"   = $s.description
                                    "Type"          = $s.type
                                    "Authorization" = $s.use_for_authorization
                                }

                                $TableParams = @{
                                    Name         = "Authentification Source: $($s.name)"
                                    List         = $true
                                    ColumnWidths = 20, 80
                                }

                                if ($Report.ShowTableCaptions) {
                                    $TableParams['Caption'] = "- $($TableParams.Name)"
                                }

                                $OutObj | Table @TableParams

                                #auth_source_filters
                                if ($s.auth_source_filters) {
                                    $OutObj = @()
                                    foreach ($asf in $s.auth_source_filters) {

                                        $OutObj += [pscustomobject]@{
                                            "Name"      = $asf.name
                                            "Query"     = $asf.query
                                            "Attribute" = $asf.attributes.attribute_name
                                        }

                                    }

                                    $TableParams = @{
                                        Name         = "Auth Source Filters : $($s.name)"
                                        List         = $false
                                        ColumnWidths = 20, 40, 40
                                    }

                                    if ($Report.ShowTableCaptions) {
                                        $TableParams['Caption'] = "- $($TableParams.Name)"
                                    }

                                    $OutObj | Table @TableParams

                                    #cppm_primary_auth_source_connection_details
                                    if (@($s.cppm_primary_auth_source_connection_details | Get-Member -Type NoteProperty).count) {
                                        $OutObj = @()
                                        foreach ($cpascd in $s.cppm_primary_auth_source_connection_details.PSObject.Properties) {
                                            #Only display when there is a value...
                                            if ($cpascd.value) {
                                                $OutObj += [pscustomobject]@{
                                                    "Name"  = $cpascd.name
                                                    "Value" = $cpascd.value
                                                }
                                            }

                                        }

                                        $TableParams = @{
                                            Name         = "Primary Auth Source Connection Details : $($s.name)"
                                            List         = $false
                                            ColumnWidths = 40, 60
                                        }

                                        if ($Report.ShowTableCaptions) {
                                            $TableParams['Caption'] = "- $($TableParams.Name)"
                                        }
                                        if ($OutObj.count) {
                                            $OutObj | Table @TableParams
                                        }
                                    }
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