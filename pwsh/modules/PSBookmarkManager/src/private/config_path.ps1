<#
	.SYNOPSIS
	Create & Get default configuration file path

	.DESCRIPTION
	Create & Get default configuration file path

	.OUTPUTS
	System.String

	.EXAMPLE
	# If $env:XDG_CONFIG_HOME is defined
	PS> Get-PSBMDefaultConfigPath
	$env:XDG_CONFIG_HOME/bookmarks/bm.rc

	.EXAMPLE
	# If $env:XDG_CONFIG_HOME is not defined
	PS> Get-PSBMDefaultConfigPath
	$HOME/.config/bookmarks/bm.rc

	.NOTES
	Will use $env:XDG_CONFIG_HOME if defined, else uses $HOME/.config as root path
#>
function Get-PSBMDefaultConfigPath {
	$root = if ($null -ne $env:XDG_CONFIG_HOME) {
		$env:XDG_CONFIG_HOME
	} else {
		Join-Path -Path $HOME -ChildPath '.config'
	}

	$path = Join-Path -Path $root -ChildPath 'bookmarks' |
		Join-Path -ChildPath 'bm.rc'

	New-Item -Path $path -ItemType File
	return $path
}

<#
	.SYNOPSIS
	Ensure that configuration file path is valid and exists

	.DESCRIPTION
	Ensure that configuration file path is valid and exists

	.PARAMETER Path
	Configuration file path

	.OUTPUTS
	System.Boolean
	System.Exception

	.EXAMPLE
	PS> Test-PSBMConfigPath .\existing\bm.rc
	$True

	.EXAMPLE
	PS> Test-PSBMConfigPath .\nonexistent\bm.rc
	[System.Exception]
#>
function Test-PSBMConfigPath {
	param([string]$path)
	if (!(Test-Path -Path $path -IsValid)) {
		throw "Configuration path is invalid: $path"
	} elseif (!(Test-Path -Path $path -PathType Leaf)) {
		New-Item -Path $path -PathType File
	}

	return $True
}