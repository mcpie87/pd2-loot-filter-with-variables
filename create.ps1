$default_filter_path = "C:\Games\diablo2_1\ProjectD2\default.filter"
$tmp_out_file_path = "out\default.filter"
$TRUE_EXPR = "(FILTLVL>0 OR FILTLVL=0)"
$FALSE_EXPR = "(FILTLVL<0)"

$filters = @(
    # "kryszard"
    "header"
    "utilities/gold"
    "utilities/potions"
    "utilities/charms"
    "utilities/quivers"
    # renames on RW base items
    "renames/runes-and-gems"
    "renames/remove-superior-and-inferior-from-name"
    "renames/add-corrupted"
    "renames/add-sockets"
    "renames/add-pricetags"
    "renames/add-skills-on-nmag"
    "renames/add-staffmods" # todo - needed?
    "renames/add-sup-or-inf"
    "renames/add-eth"
    "renames/rename-uniques-and-sets"
    "renames/add-quantities"
    "renames/utilities"
    "bases/possible-runewords"
    "bases/high-def-or-ed-bases"
    "bases/armor"
    "bases/weapon"
    "item-notes/upgrading"
    "item-notes/max-sockets"
    "item-notes/notes-runes-and-gems"
    "shop-hunting"
    # # # slap anything to fully nuke here
    # # "overrides/eth-normal"
    # # "overrides/eth-socket"
    # # "overrides/socket"
    # # "overrides/magic"
    # # "overrides/rare"
    # # "overrides/unique"
    # # "overrides/runeword"
    "rarity-filters/priority"
    "rarity-filters/class-dependant"
    "rarity-filters/eth"
    "rarity-filters/normal"
    "rarity-filters/magic"
    "rarity-filters/rare"
    "rarity-filters/set"
    "rarity-filters/unique"
    "rarity-filters/craft"
    "rarity-filters/others"
    "footer"
    # "kryszard-edited"
)

$variables = @{
    ENABLE_OVERRIDES = $true
    REMOVE_UNFILTERED_INFERIOR_BASES = $true
    DEBUG = $true
    SHOW_ANTIDOTES = $false
    PLAYING_CLASS = @{ # todo rename?
        SHOW_IF_NOT_AMAZON =      $true
        SHOW_IF_NOT_ASSASSIN =    $false
        SHOW_IF_NOT_NECROMANCER = $false
        SHOW_IF_NOT_BARBARIAN =   $false
        SHOW_IF_NOT_PALADIN =     $false
        SHOW_IF_NOT_SORCERESS =   $false
        SHOW_IF_NOT_DRUID =       $false
    }
    SHOW_MAGIC_CLASS_ITEMS = @{
        SHOW_MAGIC_AMAZON_SPEARS =       $false
        SHOW_MAGIC_AMAZON_JAVELINS =     $true
        SHOW_MAGIC_AMAZON_BOWS =         $true
        SHOW_MAGIC_ASSASSIN_KATARS =     $false
        SHOW_MAGIC_WANDS =               $false
        SHOW_MAGIC_NECROMANCER_SHIELDS = $false
        SHOW_MAGIC_BARBARIAN_HELMS =     $false
        SHOW_MAGIC_PALADIN_SHIELDS =     $false
        SHOW_MAGIC_SORCERESS_ORBS  =     $true
        SHOW_MAGIC_SCEPTERS =            $false
        SHOW_MAGIC_DRUID_HELMS =         $false
        SHOW_MAGIC_CLUBS =               $false
    }
    SHOW_RARE_CLASS_ITEMS = @{
        SHOW_RARE_AMAZON_SPEARS =       $false
        SHOW_RARE_AMAZON_JAVELINS =     $true
        SHOW_RARE_AMAZON_BOWS =         $true
        SHOW_RARE_ASSASSIN_KATARS =     $false
        SHOW_RARE_WANDS =               $false
        SHOW_RARE_NECROMANCER_SHIELDS = $false
        SHOW_RARE_BARBARIAN_HELMS =     $true
        SHOW_RARE_PALADIN_SHIELDS =     $false
        SHOW_RARE_SORCERESS_ORBS  =     $true
        SHOW_RARE_SCEPTERS =            $false
        SHOW_RARE_DRUID_HELMS =         $true
        SHOW_RARE_CLUBS =               $false
    }
    SHOW_ARMOR_BASES = @{
        SHOW_NORMAL_ARMOR_BASES      = $false
        SHOW_EXCEPTIONAL_ARMOR_BASES = $false
        SHOW_ELITE_ARMOR_BASES       = $true
    }
    SHOW_MAGIC_ITEMS = @{
        SHOW_MAGIC_RINGS = $false
        SHOW_MAGIC_AMULETS = $false
    }
    SHOW_RARE_ITEMS = @{
        SHOW_RARE_CHESTS = $false
        SHOW_RARE_SHIELDS = $false
    }
    SHOW_BASES_BOWS = @{
        SHOW_NMAG_BOWS_0_SOCK_0_ED = $false
        SHOW_NMAG_BOWS_GTE_3_SOCK_0_ED = $true
    }
}

New-Item -ItemType Directory -Force -Path out
Remove-Item $tmp_out_file_path
foreach ($filter in $filters) {
    Write-Output "Adding $filter.filter file"
    $src = Get-Content -Path .\filters\$filter.filter
    Add-Content -Path .\out\default.filter -Value $src
}

function ReplaceExpr($variable) {
    if ($variable) {
        $TRUE_EXPR
    } else {
        $FALSE_EXPR
    }
}


$content = Get-Content $tmp_out_file_path
foreach ($variable in $variables.Keys) {
    if ($variables.$variable -is [Hashtable]) {
        $new_hash = $variables.$variable
        foreach ($k in $new_hash.Keys) {
            Write-Host "    ${k}: $($new_hash.$k)"
            $content = $content.replace($k, $(ReplaceExpr($new_hash.$k)))
        }
    } else {
        Write-Host "${variable}: $($variables.$variable)"
        $content = $content.replace($variable, $(ReplaceExpr($variables.$variable)))
    }
}

Set-Content $tmp_out_file_path $content

Remove-Item -Path $default_filter_path -Force
Move-Item -Path out/default.filter -destination $default_filter_path