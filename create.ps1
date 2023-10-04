$default_filter_path = "C:\Games\diablo2_1\ProjectD2\default.filter"
$tmp_out_file_path = "out\default.filter"
$TRUE_EXPR = "FILTLVL>=0"
$FALSE_EXPR = "FILTLVL<0"

$filters = @(
    "header",
    "gold",
    "remove-superior-and-inferior-from-name",
    "utilities/utilities",
    "runes-and-gems",
    "charms",
    "potions",
    "colors-and-renames",
    "bases/possible-runewords",
    "bases/armor",
    "bases/weapon",
    "bases/high-def-or-ed-bases",
    "item-notes/upgrading",
    "item-notes/max-sockets",
    "item-notes/show-skills-on-nmag",
    "shop-hunting",
    "overrides", # slap anything to fully nuke here
    "quivers"
    "original"
)

$variables = @{
    ENABLE_OVERRIDES = $false
}

New-Item -ItemType Directory -Force -Path out
Remove-Item $tmp_out_file_path
foreach ($filter in $filters) {
    Write-Output "Adding $filter.filter file"
    $src = Get-Content -Path .\filters\$filter.filter
    Add-Content -Path .\out\default.filter -Value $src
}

foreach ($variable in $variables.Keys) {
    Write-Host "${variable}: $($variables.$variable)"
    (Get-Content $tmp_out_file_path).replace($variable, $(If ($($variables.$variable)) {$TRUE_EXPR} Else {$FALSE_EXPR})) | Set-Content $tmp_out_file_path
}

Remove-Item -Path $default_filter_path -Force
Move-Item -Path out/default.filter -destination $default_filter_path