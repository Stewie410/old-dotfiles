<#
	.SYNOPSIS
	Converts obejct properties in INI format into a hashtable

	.DESCRIPTION
	Converts obejct properties in INI formatted data to a hashtable

	.PARAMETER Comments
	Include comments in the result

	.PARAMETER InputObject
	Specifies the INI strings to be converted

	.INPUTS
	System.PSObject

	.OUTPUTS
	System.Collections.Hashtable

	.EXAMPLE
	PS> ConvertFrom-Ini $content

	.EXAMPLE
	PS> ConvertFrom-Ini -Comments $content

	.EXAMPLE
	PS> ConvertFrom-Ini -Comments -InputObject $content

	.EXAMPLE
	PS> Get-Content .\foo.ini | ConvertFrom-Ini

	.EXAMPLE
	PS> Get-Content .\foo.ini | ConvertFrom-Ini -Comments
#>
function ConvertFrom-Ini {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory, ValueFromPipeline, Position = 0)]
		[string[]]
		$InputObject,

		[Parameter()]
		[switch]
		$Comments
	)

	BEGIN {
		$section = 'NO_SECTION'
		$ini = @{
			"$section" = [PSCustomObject]@{
				Comments = @()
			}
		}
	}

	PROCESS {
		foreach ($str in $InputObject) {
			switch ($str) {
				'^\s*\[(.*?)\]\s*$' {
					$section = $Matches[1].Trim()
					$ini[$section] = [PSCustomObject]@{
						Comments = @()
					}
				}
				'^\s*;(.*)' {
					if ($Comments) {
						$ini[$section].Comments += @($Matches[1].Trim())
					}
				}
				'^([^#]+?)=(.*)$' {
					$member = @{
						InputObject = $ini[$section]
						MemberType  = 'NoteProperty'
						Name        = $Matches[1].Trim()
						Value       = $Matches[2].Trim()
						Force       = $True
					}

					if (($Comments) -and ($Matches[2] -match ';')) {
						$comment = ($member['Value'] -replace '^[^;]+?;', '').Trim()
						$member['Value'] = ($member['Value'] -replace '^([^;]+?);.*$', '$1').Trim()

						$ini[$section].Comments += @($comment)
					}

					Add-Member @member
				}
			}
		}
	}

	END {
		$ini
	}
}