$default_filter_path = "C:\Games\diablo2_1\ProjectD2\default.filter"
$tmp_out_file_path = "out\default.filter"
$TRUE_EXPR = "(FILTLVL>0 OR FILTLVL=0)"
$FALSE_EXPR = "(FILTLVL<0)"

$filters = @(
    "kryszard"
    # "header"
    # # renames on RW base items
    # "renames/utilities"
    # "renames/runes-and-gems"
    # "renames/remove-superior-and-inferior-from-name"
    # "renames/add-sockets"
    # "renames/add-corrupted"
    # "renames/add-sup-or-inf"
    # "renames/add-eth"
    # "renames/add-pricetags"
    # "renames/add-staffmods"
    # "renames/add-quantities"
    # "renames/rename-uniques-and-sets"
    # "utilities/gold"
    # "utilities/charms"
    # "utilities/potions"
    # "utilities/quivers"
    # "bases/possible-runewords"
    # "bases/high-def-or-ed-bases"
    # "bases/armor"
    # "bases/weapon"
    # "item-notes/upgrading"
    # "item-notes/max-sockets"
    # "item-notes/show-skills-on-nmag"
    # "item-notes/notes-runes-and-gems"
    # "shop-hunting"
    # # # # slap anything to fully nuke here
    # # # # "overrides/eth-normal"
    # # # # "overrides/eth-socket"
    # # # # "overrides/socket"
    # # # # "overrides/magic"
    # # # # "overrides/rare"
    # # # # "overrides/unique"
    # # # # "overrides/runeword"
    # "original"
    # "rarity-filters/eth"
    # "rarity-filters/normal"
    # "rarity-filters/magic"
    # "rarity-filters/rare"
    # "rarity-filters/set"
    # "rarity-filters/unique"
    # "rarity-filters/craft"
    # "rarity-filters/others"
    # "footer"
)

$variables = @{
    ENABLE_OVERRIDES = $true
    REMOVE_UNFILTERED_INFERIOR_BASES = $true
    DEBUG = $true
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