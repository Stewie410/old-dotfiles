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
	[CmdletBinding()]
	param(
		[Parameter()][ValidateSet('info', 'warn', 'error', 'debug', 'verb')][string]$Level = 'info',
		[Parameter(ValueFromPipeline, Mandatory)][ValidateNotNullOrEmpty()][string]$Message,
		[Parameter()][switch]$AddToLogFile,
	)

	$parts = @(
		(Get-Date -UFormat '+%Y-%m-%dT%T%Z'),
		$Level.ToUpper(),
		(
			if ((Get-PSCallStack)[1].Command -match 'ScriptBlock') {
				Split-Path -Path $PSCommandPath -Leaf
			} else {
				(Get-PSCallStack)[1].Command
			}
		),
		$Message
	)
	$full = $parts -join '|'
	$short = ($parts | Select-Object -Last 2) -join '|'

	if ($True -eq $AddToLogFile) {
		Add-Content -Path $LogFile -Value $full
	}

	if (-not (Get-Variable -Name LogFile -ErrorAction SilentlyContinue)) {
		$LogFile = $null
	}

	switch ($Level) {
		'info' { Write-Host $short }
		'warn' { Write-Warning -Message $short }
		'error' { Write-Error -Message $short }
		'debug' { Write-Debug -Message $short }
		'verbose' { Write-Verbose -Message $short }
	}
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
	$params = @{
		Path = "$env:USERPROFILE\.log\scripts"
		ItemType = 'File'
		Name = "$(Split-Path -Path ($PSCommandPath -Replace '\.ps1$', '') -Leaf).log"
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
