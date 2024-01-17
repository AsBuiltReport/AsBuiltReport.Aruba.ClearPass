function Get-AbrCPPMCertificate {
    <#
    .SYNOPSIS
        Used by As Built Report to returns Certificate Trusted List settings.
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
        Section -Style Heading2 'Certificate' {
            Paragraph "The following section details Certificate settings configured on FortiGate."
            BlankLine

            $CertTrustList = Get-ArubaCPCertTrustList -details -limit 1000
            $ServerConfiguration = Get-ArubaCPServerConfiguration
            $ServiceCertificate = Get-ArubaCPServiceCertificate

            if ($InfoLevel.Certificate -ge 1) {
                Section -Style Heading3 'Server Certificate' {
                    Paragraph "The following section provides a summary of Certificate settings."
                    BlankLine

                    foreach ($sc in $ServerConfiguration) {
                        #No API call to get directly ALL Server certificate, need to ask service_name by service name...
                        $c_https_rsa = Get-ArubaCPServerCertificate -server_uuid $sc.server_uuid -service_name "HTTPS(RSA)"
                        $c_https_ecc = Get-ArubaCPServerCertificate -server_uuid $sc.server_uuid -service_name "HTTPS(ECC)"
                        $c_radius = Get-ArubaCPServerCertificate -server_uuid $sc.server_uuid -service_name "RADIUS"
                        $c_radsec = Get-ArubaCPServerCertificate -server_uuid $sc.server_uuid -service_name "RadSec"
                        $c_database = Get-ArubaCPServerCertificate -server_uuid $sc.server_uuid -service_name "Database"

                        $OutObj = @()
                        #HTTPS RSA
                        $OutObj += [pscustomobject]@{
                            "Id"           = $c_https_rsa.service_id
                            "Service Name" = $c_https_rsa.service_name
                            "Subject"      = $c_https_rsa.subject
                            "Issue Date"   = $c_https_rsa.issue_date
                            "Expiry Date"  = $c_https_rsa.expiry_date
                            "Validity"     = $c_https_rsa.validity
                            "Enable"       = $c_https_rsa.enabled
                        }

                        #HTTPS ECC
                        $OutObj += [pscustomobject]@{
                            "Id"           = $c_https_ecc.service_id
                            "Service Name" = $c_https_ecc.service_name
                            "Subject"      = $c_https_ecc.subject
                            "Issue Date"   = $c_https_ecc.issue_date
                            "Expiry Date"  = $c_https_ecc.expiry_date
                            "Validity"     = $c_https_ecc.validity
                            "Enable"       = $c_https_ecc.enabled
                        }

                        #RADIUS
                        $OutObj += [pscustomobject]@{
                            "Id"           = $c_radius.service_id
                            "Service Name" = $c_radius.service_name
                            "Subject"      = $c_radius.subject
                            "Issue Date"   = $c_radius.issue_date
                            "Expiry Date"  = $c_radius.expiry_date
                            "Validity"     = $c_radius.validity
                            "Enable"       = $c_radius.enabled
                        }

                        #RadSec
                        $OutObj += [pscustomobject]@{
                            "Id"           = $c_radsec.service_id
                            "Service Name" = $c_radsec.service_name
                            "Subject"      = $c_radsec.subject
                            "Issue Date"   = $c_radsec.issue_date
                            "Expiry Date"  = $c_radsec.expiry_date
                            "Validity"     = $c_radsec.validity
                            "Enable"       = $c_radsec.enabled
                        }

                        #Database
                        $OutObj += [pscustomobject]@{
                            "Id"           = $c_database.service_id
                            "Service Name" = $c_database.service_name
                            "Subject"      = $c_database.subject
                            "Issue Date"   = $c_database.issue_date
                            "Expiry Date"  = $c_database.expiry_date
                            "Validity"     = $c_database.validity
                            "Enable"       = $c_database.enabled
                        }
                        $TableParams = @{
                            Name         = "Certificate $($sc.name)"
                            List         = $false
                            ColumnWidths = 5, 17, 30, 16, 16, 8, 8
                        }

                        if ($Report.ShowTableCaptions) {
                            $TableParams['Caption'] = "- $($TableParams.Name)"
                        }

                        $OutObj | Table @TableParams
                    }
                }
            }

            if ($ServiceCertificate -and $InfoLevel.Certificate -ge 1) {
                Section -Style Heading3 'Service Certificate' {
                    Paragraph "The following section provides a summary of Service Certificate settings."
                    BlankLine

                    $OutObj = @()
                    foreach ($scert in $ServiceCertificate) {
                        $OutObj += [pscustomobject]@{
                            "Id"          = $scert.id
                            "Subject"     = $scert.subject
                            "Issued By"   = $scert.issued_by
                            "Issue Date"  = $scert.issue_date
                            "Expiry Date" = $scert.expiry_date
                            "Validity"    = $scert.validity
                        }
                    }

                    $TableParams = @{
                        Name         = "Service Certificate"
                        List         = $false
                        ColumnWidths = 5, 25, 30, 16, 16, 8
                    }

                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }

                    $OutObj | Table @TableParams
                }
            }

            if ($CertTrustList -and $InfoLevel.Certificate -ge 1) {
                Section -Style Heading3 'Certificate Trust List Summary' {
                    Paragraph "The following section provides a summary of Certificate Trusted List settings."
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
                Section -Style Heading3 'Certificate Trust List Detail' {
                    Paragraph "The following section details Certificate Trust List configured on ClearPass."
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