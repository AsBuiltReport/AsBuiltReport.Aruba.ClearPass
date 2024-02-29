<!-- ********** DO NOT EDIT THESE LINKS ********** -->
<p align="center">
    <a href="https://www.asbuiltreport.com/" alt="AsBuiltReport"></a>
            <img src='https://github.com/AsBuiltReport.png' width="8%" height="8%" /></a>
</p>
<p align="center">
    <a href="https://www.powershellgallery.com/packages/AsBuiltReport.Aruba.ClearPass/" alt="PowerShell Gallery Version">
        <img src="https://img.shields.io/powershellgallery/v/AsBuiltReport.Aruba.ClearPass.svg" /></a>
    <a href="https://www.powershellgallery.com/packages/AsBuiltReport.Aruba.ClearPass/" alt="PS Gallery Downloads">
        <img src="https://img.shields.io/powershellgallery/dt/AsBuiltReport.Aruba.ClearPass.svg" /></a>
    <a href="https://www.powershellgallery.com/packages/AsBuiltReport.Aruba.ClearPass/" alt="PS Platform">
        <img src="https://img.shields.io/powershellgallery/p/AsBuiltReport.Aruba.ClearPass.svg" /></a>
</p>
<p align="center">
    <a href="https://github.com/AsBuiltReport/AsBuiltReport.Aruba.ClearPass/graphs/commit-activity" alt="GitHub Last Commit">
        <img src="https://img.shields.io/github/last-commit/AsBuiltReport/AsBuiltReport.Aruba.ClearPass/master.svg" /></a>
    <a href="https://raw.githubusercontent.com/AsBuiltReport/AsBuiltReport.Aruba.ClearPass/master/LICENSE" alt="GitHub License">
        <img src="https://img.shields.io/github/license/AsBuiltReport/AsBuiltReport.Aruba.ClearPass.svg" /></a>
    <a href="https://github.com/AsBuiltReport/AsBuiltReport.Aruba.ClearPass/graphs/contributors" alt="GitHub Contributors">
        <img src="https://img.shields.io/github/contributors/AsBuiltReport/AsBuiltReport.Aruba.ClearPass.svg"/></a>
</p>
<p align="center">
    <a href="https://twitter.com/AsBuiltReport" alt="Twitter">
            <img src="https://img.shields.io/twitter/follow/AsBuiltReport.svg?style=social"/></a>
</p>

<p align="center">
    <a href='https://ko-fi.com/B0B7DDGZ7' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://cdn.ko-fi.com/cdn/kofi1.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>
</p>
<!-- ********** DO NOT EDIT THESE LINKS ********** -->

# Aruba ClearPass As Built Report


Aruba ClearPass As Built Report is a PowerShell module which works in conjunction with [AsBuiltReport.Core](https://github.com/AsBuiltReport/AsBuiltReport.Core).

[AsBuiltReport](https://github.com/AsBuiltReport/AsBuiltReport) is an open-sourced community project which utilises PowerShell to produce as-built documentation in multiple document formats for multiple vendors and technologies.

Please refer to the AsBuiltReport [website](https://www.asbuiltreport.com) for more detailed information about this project.

# :books: Sample Reports

## Sample Report

Sample Aruba ClearPass As Built report HTML file: [Sample Aruba ClearPass As-Built Report.html](https://htmlpreview.github.io/?https://raw.githubusercontent.com/AsBuiltReport/AsBuiltReport.Aruba.ClearPass/dev/Samples/Aruba%20ClearPass%20As%20Built%20Report.html)

Sample Aruba ClearPass As Built report Word file: [Sample Aruba ClearPass As-Built Report.docx](https://raw.githubusercontent.com/AsBuiltReport/AsBuiltReport.Aruba.ClearPass/dev/Samples/Aruba%20ClearPass%20As%20Built%20Report.docx)

# :beginner: Getting Started
Below are the instructions on how to install, configure and generate a Aruba ClearPass As Built report.

## :floppy_disk: Supported Versions
The Aruba ClearPass As Built Report supports the following ClearPass versions 6.10.x, 6.11.x, 6.12.x

### PowerShell
This report is compatible with the following PowerShell versions;

| Windows PowerShell 5.1 |     PowerShell 7    |
|:----------------------:|:--------------------:|
|   :white_check_mark:   | :white_check_mark: |
## :wrench: System Requirements
PowerShell 5.1 or PowerShell 7, and the following PowerShell modules are required for generating a Aruba ClearPass As Built Report.

- [AsBuiltReport.Aruba.ClearPass Module](https://www.powershellgallery.com/packages/AsBuiltReport.Aruba.ClearPass/)
- [PowerArubaCP Module](https://www.powershellgallery.com/packages/PowerArubaCP/)

### :closed_lock_with_key: Required Privileges
You need to have an API Token (can be Read Only)

Go on WebGUI of your ClearPass, on Guest Modules
generate a API Client but you don't need to store the Client Secret

On `API Clients List`, select the your client
![](https://raw.githubusercontent.com/PowerAruba/PowerArubaCP/master/Medias/CPPM_Generate_Access_Token.PNG)  

Click on `Generate Access Token`

![](https://raw.githubusercontent.com/PowerAruba/PowerArubaCP/master/Medias/CPPM_Get_Token.PNG)  
And kept the token (for example : 70680f1d19f86110800d5d5cb4414fbde7be12ae)

## :package: Module Installation

### PowerShell
```powershell
Install-Module PowerArubaCP
Install-Module AsBuiltReport.Aruba.ClearPass
```

### GitHub
If you are unable to use the PowerShell Gallery, you can still install the module manually. Ensure you repeat the following steps for the [system requirements](https://github.com/AsBuiltReport/AsBuiltReport.Aruba.ClearPass#wrench-system-requirements) also.

1. Download the code package / [latest release](https://github.com/AsBuiltReport/AsBuiltReport.Aruba.ClearPass/releases/latest) zip from GitHub
2. Extract the zip file
3. Copy the folder `AsBuiltReport.Aruba.ClearPass` to a path that is set in `$env:PSModulePath`.
4. Open a PowerShell terminal window and unblock the downloaded files with
    ```powershell
    $path = (Get-Module -Name AsBuiltReport.Aruba.ClearPass -ListAvailable).ModuleBase; Unblock-File -Path $path\*.psd1; Unblock-File -Path $path\Src\Public\*.ps1; Unblock-File -Path $path\Src\Private\*.ps1
    ```
5. Close and reopen the PowerShell terminal window.

_Note: You are not limited to installing the module to those example paths, you can add a new entry to the environment variable PSModulePath if you want to use another path._

## :pencil2: Configuration

The Aruba ClearPass As Built Report utilises a JSON file to allow configuration of report information, options, detail and healthchecks.

A Aruba ClearPass report configuration file can be generated by executing the following command;
```powershell
New-AsBuiltReportConfig -Report Aruba.ClearPass -FolderPath <User specified folder> -Filename <Optional>
```

Executing this command will copy the default Aruba ClearPass report JSON configuration to a user specified folder.

All report settings can then be configured via the JSON file.

The following provides information of how to configure each schema within the report's JSON file.

<!-- ********** DO NOT CHANGE THE REPORT SCHEMA SETTINGS ********** -->
### Report
The **Report** schema provides configuration of the Aruba ClearPass report information.

| Sub-Schema          | Setting      | Default                        | Description                                                  |
|---------------------|--------------|--------------------------------|--------------------------------------------------------------|
| Name                | User defined | Aruba ClearPass As Built Report | The name of the As Built Report                              |
| Version             | User defined | 1.0                            | The report version                                           |
| Status              | User defined | Released                       | The report release status                                    |
| ShowCoverPageImage  | true / false | true                           | Toggle to enable/disable the display of the cover page image |
| ShowTableOfContents | true / false | true                           | Toggle to enable/disable table of contents                   |
| ShowHeaderFooter    | true / false | true                           | Toggle to enable/disable document headers & footers          |
| ShowTableCaptions   | true / false | true                           | Toggle to enable/disable table captions/numbering            |

### Options
The **Options** schema allows certain options within the report to be toggled on or off.

| Sub-Schema      | Setting      | Default | Description |
|-----------------|--------------|---------|-------------|
| HideLicenseKey | Licence Key | false | Hide License key value on report
| HidePassword | Hide Password | false | Hide Password on Authentication chapiter (bind...)

### InfoLevel
The **InfoLevel** schema allows configuration of each section of the report at a granular level. The following sections can be set.

There are 3 levels (0-2) of detail granularity for each section as follows;

| Setting | InfoLevel         | Description                                                                                                                                |
|:-------:|-------------------|--------------------------------------------------------------------------------------------------------------------------------------------|
|    0    | Disabled          | Does not collect or display any information                                                                                                |
|    1    | Enabled / Summary | Provides summarised information for a collection of objects                                                                                |
|    2    | Adv Summary       | Provides condensed, detailed information for a collection of objects                                                                       |

The table below outlines the default and maximum InfoLevel settings for each *ClearPass* section.

| Sub-Schema | Default Settings | Maximum Settings |
|:----------:|------------------|------------------|
| System     | 1                | 1                |
| Licence    | 2                | 2                |
| Authentication | 2            | 2                |
| Certificate | 1               | 1                |
| Service    | 2                | 2                |
| NetworkDevice  | 1            | 1                |

### Healthcheck
The **Healthcheck** schema is used to toggle health checks on or off.

Health checks are yet to be developed.

## :computer: Examples
There are a few examples listed below on running the AsBuiltReport script against a ClearPass. Refer to the README.md file in the main AsBuiltReport project repository for more examples.

```powershell
# Generate a Aruba ClearPass As Built Report for ClearPass clearpass.arubademo.net using specified token. Export report to HTML & DOCX formats. Use default report style. Append timestamp to report filename. Save reports to 'C:\Users\PowerArubaCP\Documents'
PS C:\> New-AsBuiltReport -Report Aruba.ClearPass -Target clearpass.arubademo.net -token XXXXXXX -Format Html,Word -OutputFolderPath 'C:\Users\PowerArubaCP\Documents' -Timestamp

# Generate a Aruba ClearPass  As Built Report for ClearPass clearpass.arubademo.net using specified token and report configuration file. Export report to Text, HTML & DOCX formats. Use default report style. Save reports to 'C:\Users\PowerArubaCP\Documents'. Display verbose messages to the console.
PS C:\>  New-AsBuiltReport -Report Aruba.ClearPass -Target clearpass.arubademo.net -token XXXXXXX -Format Text,Html,Word -OutputFolderPath 'C:\Users\PowerArubaCP\Documents' -ReportConfigFilePath 'C:\Users\Jon\AsBuiltReport\AsBuiltReport.Aruba.ClearPass.json' -Verbose

# Generate a Aruba ClearPass As Built Report for ClearPass clearpass.arubademo.net using specified token. Export report to HTML & Text formats. Use default report style. Highlight environment issues within the report. Save reports to 'C:\Users\PowerArubaCP\Documents'.
PS C:\> $Creds = Get-Credential
PS C:\>  New-AsBuiltReport -Report Aruba.ClearPass -Target clearpass.arubademo.net -token XXXXXXX -Format Html,Text -OutputFolderPath 'C:\Users\PowerArubaCP\Documents' -EnableHealthCheck

# Generate a Aruba ClearPass As Built Report for ClearPass clearpass.arubademo.net using specified token. Export report to HTML & DOCX formats. Use default report style. Reports are saved to the user profile folder by default. Attach and send reports via e-mail.
PS C:\>  New-AsBuiltReport -Report Aruba.ClearPass -Target clearpass.arubademo.net -token XXXXXXX -Format Html,Word -OutputFolderPath 'C:\Users\PowerArubaCP\Documents' -SendEmail
```

