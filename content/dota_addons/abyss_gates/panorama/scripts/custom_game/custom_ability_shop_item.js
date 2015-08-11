function BuyAbility() {
    var ability = $.GetContextPanel().GetAttributeString('abilityname', '');
    var playerID = Players.GetLocalPlayer();
    var playerName = Players.GetPlayerName(playerID);
    var entityIndex = Players.GetPlayerHeroEntityIndex(playerID);

    GameEvents.SendCustomGameEventToServer("buy_ability", {
        ability: ability,
        playerID: playerID,
        playerName: playerName,
        entityIndex: entityIndex
    });
}

function AddAbility() {
    var AbilityName = $.GetContextPanel().GetAttributeString('abilityname', '');
    var AbilityCost = $.GetContextPanel().GetAttributeInt('abilitycost', 0);

    var AbilityImage = $('#AbilityImage');
    var AbilityCostLabel  = $('#AbilityCost');

    AbilityImage.abilityname = AbilityName;
    AbilityCostLabel.text = AbilityCost;
};

function AbilityShowTooltip() {
    var AbilityButton = $('#AbilityShopBuyButton');
    var AbilityName = $.GetContextPanel().GetAttributeString('abilityname', '');

    $.DispatchEvent( "DOTAShowAbilityTooltip", AbilityButton, AbilityName );
}

function AbilityHideTooltip() {
    var AbilityButton = $('#AbilityShopBuyButton');
    $.DispatchEvent( "DOTAHideAbilityTooltip", AbilityButton );
}

(function() {
    AddAbility();
})();