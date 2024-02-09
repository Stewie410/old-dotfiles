<#
	.SYNOPSIS
	Converts obejct properties in INI format into a hashtable

	.DESCRIPTION
	Converts obejct properties in INI formatted data to a hashtable

	.PARAMETER Comments
	Include comments in the result

	.PARAMETER Path
	Path to an INI file to be converted

	.INPUTS
	System.String

	.OUTPUTS
	System.Collections.Hashtable

	.EXAMPLE
	PS> Import-Ini .\foo.ini

	.EXAMPLE
	PS> Import-Ini -Comments .\foo.ini

	.EXAMPLE
	PS> Import-Ini -Comments -Path .\foo.ini

	.EXAMPLE
	PS> '.\foo.ini' | Import-Ini

	.EXAMPLE
	PS> '.\foo.ini' | Import-Ini -Comments
#>
function Import-Ini {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory, ValueFromPipeline, Position = 0)]
		[ValidateScript(
			{
				if (!(Test-Path -Path $_ -IsValid)) {
					throw "Ini file path is not valid: $_"
				}
				if (!(Test-Path -Path $_)) {
					throw "Ini file path does not exist: $_"
				}
				if (!(Test-Path -Path $_ -PathType Leaf)) {
					throw "Ini file path is not a file: $_"
				}
				$True
			}
		)]
		[string]
		$Path,

		[Parameter()]
		[switch]
		$Comments
	)

	BEGIN {}

	PROCESS {
		$convert_splat = @{
			Comments    = $Comments
			InputObject = Get-Content -Path $Path
		}
		ConvertFrom-Ini @convert_splat
	}

	END {}
}