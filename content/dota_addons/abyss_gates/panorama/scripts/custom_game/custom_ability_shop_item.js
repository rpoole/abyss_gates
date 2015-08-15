    function BuyAbility() {
    var ability = $.GetContextPanel().GetAttributeString('abilityname', '');
    var playerID = Players.GetLocalPlayer();
    var playerName = Players.GetPlayerName(playerID);
    var entityIndex = Players.GetPlayerHeroEntityIndex(playerID);
    var heroName = Players.GetPlayerSelectedHero(playerID);
    var heroLevel = Players.GetLevel(playerID);
    var slotOne = Entities.GetAbility(entityIndex, 0);
    var slotTwo = Entities.GetAbility(entityIndex, 1);
    var slotThree = Entities.GetAbility(entityIndex, 2);
    var slotFour = Entities.GetAbility(entityIndex, 3);
    var slotFive = Entities.GetAbility(entityIndex, 4);
    var abilityOne = Abilities.GetAbilityName(slotOne);
    $.Msg('test')
    $.Msg(abilityOne)
    var abilityTwo = Abilities.GetAbilityName(slotTwo);
    var abilityThree = Abilities.GetAbilityName(slotThree);
    var abilityFour = Abilities.GetAbilityName(slotFour);
    var abilityFive = Abilities.GetAbilityName(slotFive);

    if (ability.indexOf("tier_1") > -1)
    {
        if (slotOne == -1)
        {
            GameEvents.SendCustomGameEventToServer("buy_ability", {
                ability: ability,
                playerID: playerID,
                playerName: playerName,
                entityIndex: entityIndex,
                heroName: heroName
            });

            $('#AbilityShopBuyButton').ToggleClass('hidden');
        }
        else
        {
            var tierOne = 1;
            GameEvents.SendCustomGameEventToServer("tier_ability", {
                tier: tierOne
            });
        }
    }

    if (ability.indexOf("tier_2") > -1)
    {
        if (abilityOne.indexOf("tier_1") > -1)
        {
            if (slotTwo == -1)
            {
                GameEvents.SendCustomGameEventToServer("buy_ability", {
                    ability: ability,
                    playerID: playerID,
                    playerName: playerName,
                    entityIndex: entityIndex,
                    heroName: heroName
                });

                $('#AbilityShopBuyButton').ToggleClass('hidden');
            }
            else
            {
                var tierOne = 2;
                GameEvents.SendCustomGameEventToServer("tier_ability", {
                    tier: tierOne
                });
            }
        }
        else
        {
            var tierOne = 2;
            GameEvents.SendCustomGameEventToServer("tier_ability_two", {
                tier: tierOne
            });
        }
    }

     if (ability.indexOf("tier_3") > -1)
    {
        if (abilityTwo.indexOf("tier_2") > -1)
        {
            if (slotThree == -1)
            {
                GameEvents.SendCustomGameEventToServer("buy_ability", {
                    ability: ability,
                    playerID: playerID,
                    playerName: playerName,
                    entityIndex: entityIndex,
                    heroName: heroName
                });

                $('#AbilityShopBuyButton').ToggleClass('hidden');
            }
            else
            {
                var tierOne = 3;
                GameEvents.SendCustomGameEventToServer("tier_ability", {
                    tier: tierOne
                });
            }
        }
        else
        {
            var tierOne = 3;
            GameEvents.SendCustomGameEventToServer("tier_ability_two", {
                tier: tierOne
            });
        }
    }

     if (ability.indexOf("tier_4") > -1)
    {
        if (abilityThree.indexOf("tier_3") > -1)
        {
            if (slotFour == -1)
            {
                GameEvents.SendCustomGameEventToServer("buy_ability", {
                    ability: ability,
                    playerID: playerID,
                    playerName: playerName,
                    entityIndex: entityIndex,
                    heroName: heroName
                });

                $('#AbilityShopBuyButton').ToggleClass('hidden');
            }
            else
            {
                var tierOne = 4;
                GameEvents.SendCustomGameEventToServer("tier_ability", {
                    tier: tierOne
                });
            }
        }
        else
        {
            var tierOne = 4;
            GameEvents.SendCustomGameEventToServer("tier_ability_two", {
                tier: tierOne
            });
        }
    }

     if (ability.indexOf("tier_5") > -1)
    {
        if (abilityFour.indexOf("tier_4") > -1)
        {
            if (slotFive == -1)
            {
                GameEvents.SendCustomGameEventToServer("buy_ability", {
                    ability: ability,
                    playerID: playerID,
                    playerName: playerName,
                    entityIndex: entityIndex,
                    heroName: heroName
                });

                $('#AbilityShopBuyButton').ToggleClass('hidden');
            }
            else
            {
                var tierOne = 5;
                GameEvents.SendCustomGameEventToServer("tier_ability", {
                    tier: tierOne
                });
            }
        }
        else
        {
            var tierOne = 5;
            GameEvents.SendCustomGameEventToServer("tier_ability_two", {
                tier: tierOne
            });
        }
    }
}

function AddAbility() {
    var AbilityName = $.GetContextPanel().GetAttributeString('abilityname', '');
    var AbilityCost = $.GetContextPanel().GetAttributeInt('abilitycost', 0);

    var AbilityImage = $('#AbilityImage');
    var AbilityCostLabel  = $('#AbilityCost');

    AbilityImage.abilityname = AbilityName;
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

function ToggleAbilityItem() {
    $('#AbilityShopBuyButton').ToggleClass('hidden');
    $.Msg('toggleHidden')
}

(function() {
    AddAbility();
})();