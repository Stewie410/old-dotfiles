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
	[Parameter()][switch]$Help,
)

function Write-Help {
	$me = Split-Path -Path $PSCommandPath -Leaf
	Write-Host @"
synopsis

USAGE:  $me [OPTIONS]

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

function New-LogFile {
	$params = @{
		Path = Join-Path -Path $env:USERPROFILE -ChildPath '.log' |
			Join-Path -Childpath 'scripts' |
			Join-Path -ChildPath $env:USERNAME
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
