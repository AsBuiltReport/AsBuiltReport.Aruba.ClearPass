function Get-AbrCPPMCertificate {
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
        Write-PScriboMessage "Discovering Certificate settings information from $System."
    }

    process {
        PageBreak
        Section -Style Heading2 'Certificate' {
            Paragraph "The following section details Certificate settings configured on FortiGate."
            BlankLine

            $CertTrustList = Get-ArubaCPCertTrustList -details -limit 1000

            if ($CertTrustList -and $InfoLevel.Certificate -ge 1) {
                Section -Style Heading3 'Summary' {
                    Paragraph "The following section provides a summary of Network Device settings."
                    BlankLine

                    $OutObj = @()
                    $OutObj = [pscustomobject]@{
                        "Certificate Trust List"           = @($CertTrustList).count
                        "Certificate Trust List (Enabled)" = @($CertTrustList | Where-Object { $_.enabled -eq "True" } ).count
                    }

                    $TableParams = @{
                        Name         = "Certificate Summary"
                        List         = $true
                        ColumnWidths = 50, 50
                    }

                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }

                    $OutObj | Table @TableParams

                }
            }

            if ($CertTrustList -and $InfoLevel.Certificate -ge 1) {
                Section -Style Heading3 'Certificate Trust List' {
                    Paragraph "The following section details Certificate Trust Lis configured on ClearPass."
                    BlankLine

                    $OutObj = @()
                    foreach ($ctl in $CertTrustList) {
                        $OutObj += [pscustomobject]@{
                            "Id"          = $ctl.id
                            "Subject DN"  = $ctl.subject_DN
                            "Issue Date"  = $ctl.issue_date
                            "Expiry Date" = $ctl.expiry_date
                            "Enable"      = $ctl.enabled
                            "Valid"       = $ctl.valid
                            "Usage"       = $ctl.cert_usage -join ", "
                        }
                    }

                    $TableParams = @{
                        Name         = "Certificate Trust Lis"
                        List         = $false
                        ColumnWidths = 6, 30, 14, 14, 8, 7, 21
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