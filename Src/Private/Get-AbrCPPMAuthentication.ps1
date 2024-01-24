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

                }
            }
        }

    }

    end {

    }

}