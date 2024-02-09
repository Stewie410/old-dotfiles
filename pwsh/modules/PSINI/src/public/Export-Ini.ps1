<#
	.SYNOPSIS
	Converts (ini) hashtables into an INI format and saves the strings to a file

	.DESCRIPTION
	Converts (ini) hashtables into an INI format and saves the strings to a file

	.PARAMETER Table
	Hashtable (ini) to convert

	.PARAMETER NoSpace
	Do not surround '=' with spaces in section keys

	.PARAMETER Path
	Location to save the INI output file

	.PARAMETER NoClobber
	Do not overwrite an existing file

	.PARAMETER Append
	Add INI content to the end of the specified file, instead of overwriting

	.PARAMETER Force
	Set/Add content to a read-only file

	.INPUTS
	System.Collections.Hashtable
#>

function Export-Ini {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory, ValueFromPipeline, Position = 0)]
		[hashtable]
		$Table,

		[Parameter(Mandatory, Position = 1)]
		[ValidateScript({ Test-Path -Path $_ -IsValid })]
		[string]
		$Path,

		[Parameter()]
		[switch]
		$NoSpace,

		[Parameter()]
		[switch]
		$NoClobber,

		[Parameter()]
		[switch]
		$Append,

		[Parameter()]
		[switch]
		$Force
	)

	BEGIN {
		if ((Test-Path -Path $Path -PathType Leaf) -and $NoClobber) {
			throw "Output file already exists: $Path"
		}

		$write_splat = @{
			Path      = $Path
			Force     = $Force
			NoNewLine = $True
		}

		$result = @()
	}

	PROCESS {
		$conv_splat = @{
			Table   = $Table
			NoSpace = $NoSpace
		}

		$result += @(ConvertTo-Ini @conv_splat)
	}

	END {
		if ($Append) {
			$result | Add-Content @write_splat
		} else {
			$result | Set-Content @write_splat
		}
	}
}