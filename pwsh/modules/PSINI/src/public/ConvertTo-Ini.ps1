<#
	.SYNOPSIS
	Converts (ini) hashtables into an INI format

	.DESCRIPTION
	Converts (ini) hashtables into an INI format

	.PARAMETER Table
	Hashtable (ini) to convert

	.PARAMETER NoSpace
	Do not surround '=' with spaces in section keys

	.INPUTS
	System.Collections.Hashtable

	.OUTPUTS
	System.String[]

	.EXAMPLE
	PS> ConvertTo-Ini $object

	.EXAMPLE
	PS> ConvertTo-Ini -InputObject $object

	.EXAMPLE
	PS> $object | ConvertTo-Ini
#>

function ConvertTo-Ini {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory, ValueFromPipeline, Position = 0)]
		[hashtable]
		$Table,

		[Parameter()]
		[switch]
		$NoSpace
	)

	BEGIN {
		$format = if ($NoSpace) {
			'{0}={1}'
		} else {
			'{0} = {1}'
		}
	}

	PROCESS {
		foreach ($key in $Table.Keys) {
			Write-Output "[$key]"
			$Table[$key].Properties | ForEach-Object {
				$format -f $_.Name, $_.Value
			}
		}
	}

	END {}
}