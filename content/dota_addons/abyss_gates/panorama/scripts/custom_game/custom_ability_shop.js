var Abilities = [
    {name: 'vengefulspirit_magic_missile', cost: 20},
    {name: 'vengefulspirit_nether_swap',   cost: 20},
    {name: 'furion_wrath_of_nature',       cost: 50},
    {name: 'grim_magus_bloodshed',  cost: 100}
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