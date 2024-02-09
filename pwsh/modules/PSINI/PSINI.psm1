$item_splat = @{
	Filter      = '*.ps1'
	Recurse     = $True
	ErrorAction	= 'Stop'
}

try {
	$public = @(Get-ChildItem -Path "$PSScriptRoot\src\public" @item_splat)
} catch {
	Write-Error $_
	throw "Unable to get file information from src/public"
}

foreach ($file in $public) {
	try {
		. $file.FullName
	} catch {
		throw "Unable to dot-source [$($file.FullName)]"
	}
}

Export-ModuleMember -Function $public.Basename