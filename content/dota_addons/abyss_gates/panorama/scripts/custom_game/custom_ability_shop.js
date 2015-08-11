var Abilities = [
    {name: 'grim_magus_bloodshed',  cost: 100},
    {name: 'grim_magus_darkbolt', cost: 20},
    {name: 'grim_magus_skull_spear',   cost: 20},
    {name: 'grim_magus_bleed_earth',       cost: 50}
];

function ToggleAbilityShop() {
    $('#AbilityShopContainer').ToggleClass('hidden');
}

function AppendAbility(Panel, ability) {
    var abilityPanel = $.CreatePanel( "Panel", Panel, "" );
    abilityPanel.SetAttributeString( "abilityname", ability.name );
    abilityPanel.SetAttributeInt( "abilitycost", ability.cost );
    abilityPanel.BLoadLayout( "file://{resources}/layout/custom_game/custom_ability_shop_item.xml", false, false );
}

function BuildAbilityShopMenu() {
    var Container = $('#AbilityShopContainer');

    for (var ability of Abilities) {
        AppendAbility(Container, ability);
    }
}

(function() {
    BuildAbilityShopMenu();
})();