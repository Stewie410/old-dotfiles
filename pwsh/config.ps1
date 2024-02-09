# Encoding
$OutputEncoding = [Text.Encoding]::UTF8
$null = [console]::InputEncoding = [console]::OutputEncoding = $OutputEncoding
$Global:PSDefaultParameterValues['*:Encoding'] = $OutputEncoding
$Global:PSDefaultParameterValues['*:InputEncoding'] = $OutputEncoding
$Global:PSDefaultParameterValues['*:OutputEncoding'] = $OutputEncoding

# Function Imports
$funcs = Join-Path -Path $env:XDG_CONFIG_HOME -ChildPath 'pwsh' |
	Join-Path -ChildPath 'functions' |
	Get-ChildItem -Recurse -Filter '*.ps1'
foreach ($f in $funcs) {
	. $f.FullName
}

# Module Imports
$modules = @(
	Join-Path -Path $env:XDG_CONFIG_HOME -ChildPath 'pwsh' |
		Join-Path -ChildPath 'modules' |
		Get-ChildItem -Recurse -Depth 1 -Filter '*.psm1' |
		Select-Object -ExpandProperty 'FullName'
)
$modules += @(
	# 'ExchangeOnlineManagement',
	# 'ExchangePowershell',
	# 'MicrosoftGraph',
	# 'MicrosoftTeams',
	# 'PromptForChoice',
	# 'PSScriptTools',
	# 'ImportExcel',
	'powershell-yaml',
	# 'PSWriteHTML',
	# 'PSWritePDF',
	# 'PSWriteOffice',
	'pwshEmojiExplorer',
	# 'platyPS',
	# 'PoShLog',
	# 'PoshRSJob',
	# 'PSMenu',
	# 'SimplySql',
	# 'Catesta',
	'Terminal-Icons',
	'Microsoft.Winget.Client',
	'posh-git',
	'PSFzf'
)
Import-Module -Name $modules

# Aliases
$aliases = @{
	'which'	= 'Get-Command'
	'unset' = 'Remove-Variable'
	'll'    = 'Get-ChildItem'
	'lla'   = 'Get-ChildItem'
	'grep'  = 'Select-String'
	'man'   = 'Get-Help'
	'vim'   = 'nvim'
	'z'     = 'zoxide'
	'hf'    = 'hyperfine'
}
foreach ($f in $aliases.Keys) {
	Set-Alias -Name $f -Value $aliases[$f]
}

# Cleanup
Remove-Variable -Name @('funcs', 'modules', 'aliases', 'f')

# PSReadline
Set-PSReadLineOption -PredictionSource History

# Github
if ((gh auth status)[1] -notmatch 'Logged in to github') {
	gh auth login
}

# Chocolatey
$ChocolateyProfile = Join-Path -Path $env:CHOCOLATEYINSTALL -ChildPath 'helpers' |
	Join-Path -ChildPath 'chocolateyProfile.psm1'
Import-Module -Name $ChocolateyProfile

# Zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# PS1
Invoke-Expression (& starship init powershell)