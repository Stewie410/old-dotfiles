<#
.SYNOPSIS
synopsis
.Description
Description
.PARAMETER Help
Show a traditional help message
#>

[CmdletBinding(DefaultParameterSetName = 'Default')]
param (
    [Parameter()][switch]$Help
)

function Write-Help {
    Write-Host @"
synopsis

USAGE:  $(Split-Path -Path $PSCommandPath -Leaf) [OPTIONS]

OPTIONS:
    -Help               Show this help message
"@
}

function Write-Log {
    [CmdletBinding(DefaultParameterSetName = 'Options')]
    param(
        [Parameter()][ValidateSet('info', 'warn', 'error', 'debug', 'verb')][string]$Level = 'info',
        [Parameter(ValueFromPipeline, Mandatory)][ValidateNotNullOrEmpty()][string]$Message,
        [Parameter()][switch]$AddToLogFile

        [Parameter(Mandatory = $True, ParameterSetName = "Info")]
        [switch]
        $Info,

        [Parameter(Mandatory = $True, ParameterSetName = "Warn")]
        [switch]
        $Warn,

        [Parameter(Mandatory = $True, ParameterSetName = "Error")]
        [switch]
        $Error,

        [Parameter(Mandatory = $False, ParameterSetName = "Error")]
        [switch]
        $Throw,

        [Parameter(Mandatory = $True, ParameterSetName = "Debug")]
        [switch]
        $Debug,

        [Parameter(Mandatory = $True, ParameterSetName = "Verb")]
        [switch]
        $Verbose,

        [Parameter(Mandatory = $True, ValueFromPipeline = $True, Position = 0)]
        [string]
        $Message,

        [Parameter(Mandatory = $False)]
        [switch]
        $Append
    )

    BEGIN {
        $parts = @{
            Time = Get-Date -UFormat '+%FT%T%Z'
            Level = (
                if ($Info) {
                    'info'
                } elseif ($Warn) {
                    'warn'
                } elseif ($Error) {
                    'error'
                } elseif ($Debug) {
                    'debug'
                } elseif ($Verbose) {
                    'verbose'
                } else {
                    ""
                }
            )
            Caller = (Get-PSCallStack[1])
        }

        if ($parts.Caller -match 'ScriptBlock') {
            $parts.Caller = Split-Path -Path $PSCommandPath -Leaf
        }

        if (!(Get-Variable -Name 'LogFile' -ErrorAction SilentlyContinue)) {
            $LogFile = $null
        }
    }

    PROCESS {
        $full = ($parts.Values -join '|') + '|' + $Message
        $short = ($full -split '|' | Select-Object -Last 3) -join '|'

        if ($Append) {
            Add-Content -Path $LogFile -Value $full
        }

        switch ($parts.Level) {
            'info' {
                Write-Host $short
            }
            'warn' {
                Write-Warning -Message $short
            }
            'error' {
                Write-Error -Message $short -ErrorAction Continue
                if ($Throw) {
                    throw $short
                }
            }
            'debug' {
                Write-Debug -Message $short
            }
            'verbose' {
                Write-Verbose -Message $short
            }
        }
    }

    END {}
}

function Send-Notification {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, Mandatory)][string]$Message,
        [Parameter()][string]$Subject = 'N/A'
    )

    [Windows.UI.Notifications.ToastNotificationsManager, Windows.UI.Notifications, ContentType = WindowsRunTime] | Out-Null
    $template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent(
        [Windows.UI.Notifications.GetTemplateType]::ToastText02
    )

    $raw = [xml] $template.GetXml()
    ($raw.toast.visual.binding.text | Where-Object { $_.id -eq '1' }).AppendChild($raw.CreateTextNode($Subject)) | Out-Null
    ($raw.toast.visual.binding.text | Where-Object { $_.id -eq '2' }).AppendChild($raw.CreateTextNode($Message)) | Out-Null

    $serial = [Windows.Data.Xml.Dom.XmlDocument]::new()
    $serial.LoadXml($raw.OuterXml)

    $toast = [Windows.UI.Notifications.ToastNotification]::new($serial)
    $toast.Tag = 'Powershell'
    $toast.Group = 'Powershell'
    $toast.ExpirationTime = [DateTimeOffset]::Now.AddMinutes(1)

    $notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('Powershell')
    $notifier.Show($toast)
}

function New-LogFile {
    $root = Join-Path -Path $HOME -ChildPath '.log'
    $basename = (Split-Path -Path $PSCommandPath -Leaf) -Replace '\.ps1$', ''

    $params = @{
        Path = Join-Path -Path $root -ChildPath 'scripts'
        ItemType = 'File'
        Name = "$basename.log"
        Force = $True
        ErrorAction = 'Ignore'
    }

    New-Item @params
}

function Invoke-Main {
    if ($True -eq $Help) {
        Write-Help
        return 0
    }
}

[string] $LogFile = (New-LogFile).FullName

Invoke-Main
