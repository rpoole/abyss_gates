var GrimMagusAbilitiesTier1 = [
    {name: 'grim_magus_bloodshed_tier_1'},
    {name: 'grim_magus_raise_skeleton_tier_1'},
    {name: 'grim_magus_fear_tier_1'}
];

var GrimMagusAbilitiesTier2 = [
    {name: 'grim_magus_darkbolt_tier_2'},
    {name: 'grim_magus_skeleton_mastery_tier_2'},
    {name: 'grim_magus_amplify_damage_tier_2'}
];

var GrimMagusAbilitiesTier3 = [
    {name: 'grim_magus_skull_spear_tier_3'},
    {name: 'grim_magus_corpse_explosion_tier_3'},
    {name: 'grim_magus_life_tap_tier_3'}
];

var GrimMagusAbilitiesTier4 = [
    {name: 'grim_magus_bleed_earth_tier_4'},
    {name: 'grim_magus_raise_skeleton_mage_tier_4'},
    {name: 'grim_magus_mana_rip_tier_4'}
];

var GrimMagusAbilitiesTier5 = [
    {name: 'grim_magus_shatter_bones_tier_5'},
    {name: 'grim_magus_the_creature_tier_5'},
    {name: 'grim_magus_taint_resistance_tier_5'}
];




var SpiritWarriorAbilitiesTier1 = [
    {name: 'spirit_warrior_hardened_skin_tier_1'},
    {name: 'spirit_warrior_hidden_strike_tier_1'},
    {name: 'spirit_warrior_retribution_tier_1'}
];

var SpiritWarriorAbilitiesTier2 = [
    {name: 'spirit_warrior_critical_strike_tier_2'},
    {name: 'spirit_warrior_serpent_strike_tier_2'},
    {name: 'spirit_warrior_salvation_tier_2'}
];

var SpiritWarriorAbilitiesTier3 = [
    {name: 'spirit_warrior_vampirism_tier_3'},
    {name: 'spirit_warrior_freezing_strike_tier_3'},
    {name: 'spirit_warrior_purification_tier_3'}
];

var SpiritWarriorAbilitiesTier4 = [
    {name: 'spirit_warrior_spirit_image_tier_4'},
    {name: 'spirit_warrior_storm_strike_tier_4'},
    {name: 'spirit_warrior_conversion_tier_4'}
];

var SpiritWarriorAbilitiesTier5 = [
    {name: 'spirit_warrior_true_focus_tier_5'},
    {name: 'spirit_warrior_firestorm_strike_tier_5'},
    {name: 'spirit_warrior_tel_qeres_tier_5'}
];


var PaladinAbilitiesTier1 = [
    {name: 'paladin_stone_fist_tier_1'},
    {name: 'paladin_regeneration_aura_tier_1'},
    {name: 'paladin_weakness_aura_tier_1'}
];

var PaladinAbilitiesTier2 = [
    {name: 'paladin_divine_light_tier_2'},
    {name: 'paladin_stoneskin_aura_tier_2'},
    {name: 'paladin_frailty_aura_tier_2'}
];

var PaladinAbilitiesTier3 = [
    {name: 'paladin_zeal_tier_3'},
    {name: 'paladin_might_aura_tier_3'},
    {name: 'paladin_fire_aura_tier_3'}
];

var PaladinAbilitiesTier4 = [
    {name: 'paladin_charge_tier_4'},
    {name: 'paladin_warmth_aura_tier_4'},
    {name: 'paladin_blinding_light_aura_tier_4'}
];

var PaladinAbilitiesTier5 = [
    {name: 'paladin_purify_hammer_tier_5'},
    {name: 'paladin_swiftness_aura_tier_5'},
    {name: 'paladin_cold_aura_tier_5'}
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
    var playerID = Players.GetLocalPlayer();
    var heroEntityIndex = Players.GetPlayerHeroEntityIndex(playerID);
    var heroName = Players.GetPlayerSelectedHero(playerID);
    var heroLevel = Entities.GetLevel(heroEntityIndex);

    $.Msg(heroLevel)

    if (heroName == 'npc_dota_hero_rubick')
    {
        for (var ability of GrimMagusAbilitiesTier1) {
        AppendAbility(Container, ability);
        }
    }

    if (heroName == 'npc_dota_hero_juggernaut')
    {
        for (var ability of SpiritWarriorAbilitiesTier1) {
        AppendAbility(Container, ability);
        }
    }

    if (heroName == 'npc_dota_hero_omniknight')
    {
        for (var ability of PaladinAbilitiesTier1) {
        AppendAbility(Container, ability);
        }
    }

    
             
}

function UpdateAbilityShopMenu()
{
    var Container = $('#AbilityShopContainer');
    var playerID = Players.GetLocalPlayer();
    var heroName = Players.GetPlayerSelectedHero(playerID);
    var heroEntityIndex = Players.GetPlayerHeroEntityIndex(playerID);
    var heroLevel = Entities.GetLevel(heroEntityIndex);

    if (heroName == 'npc_dota_hero_rubick')
    {
        if (heroLevel == 2)
        {
            for (var ability of GrimMagusAbilitiesTier2) {
            var childCount = $('#AbilityShopContainer').GetChildCount();
                if (childCount == 6)
                {
                    break;
                }
            AppendAbility(Container, ability);
            var childCount = $('#AbilityShopContainer').GetChildCount();
                if (childCount == 6)
                {
                    
                    break;
                }
            }

            var tierOne = 2;
            GameEvents.SendCustomGameEventToServer("new_spells", {
                tier: tierOne
            });
        }
        
        if (heroLevel == 5)
        {
            for (var ability of GrimMagusAbilitiesTier3) {
            var childCount = $('#AbilityShopContainer').GetChildCount();
                if (childCount == 9)
                {
                    break;
                }
            AppendAbility(Container, ability);
            var childCount = $('#AbilityShopContainer').GetChildCount();
                if (childCount == 9)
                {
                    
                    break;
                }
            }

            var tierOne = 3;
            GameEvents.SendCustomGameEventToServer("new_spells", {
                tier: tierOne
            });
        }

        if (heroLevel == 10)
        {
            for (var ability of GrimMagusAbilitiesTier4) {
            var childCount = $('#AbilityShopContainer').GetChildCount();
                if (childCount == 12)
                {
                    break;
                }
            AppendAbility(Container, ability);
            var childCount = $('#AbilityShopContainer').GetChildCount();
                if (childCount == 12)
                {
                    
                    break;
                }
            }

            var tierOne = 4;
            GameEvents.SendCustomGameEventToServer("new_spells", {
                tier: tierOne
            });
        }

        if (heroLevel == 15)
        {
            for (var ability of GrimMagusAbilitiesTier5) {
            var childCount = $('#AbilityShopContainer').GetChildCount();
                if (childCount == 15)
                {
                    break;
                }
            AppendAbility(Container, ability);
            var childCount = $('#AbilityShopContainer').GetChildCount();
                if (childCount == 15)
                {
                    
                    break;
                }
            }

            var tierOne = 5;
            GameEvents.SendCustomGameEventToServer("new_spells", {
                tier: tierOne
            });    
        }
    }

    if (heroName == 'npc_dota_hero_juggernaut')
    {
        if (heroLevel == 2)
        {
            for (var ability of SpiritWarriorAbilitiesTier2) {
            var childCount = $('#AbilityShopContainer').GetChildCount();
                if (childCount == 6)
                {
                    break;
                }
            AppendAbility(Container, ability);
            var childCount = $('#AbilityShopContainer').GetChildCount();
                if (childCount == 6)
                {
                    
                    break;
                }
            }

            var tierOne = 2;
            GameEvents.SendCustomGameEventToServer("new_spells", {
                tier: tierOne
            });
        }
        
        if (heroLevel == 5)
        {
            for (var ability of SpiritWarriorAbilitiesTier3) {
            var childCount = $('#AbilityShopContainer').GetChildCount();
                if (childCount == 9)
                {
                    break;
                }
            AppendAbility(Container, ability);
            var childCount = $('#AbilityShopContainer').GetChildCount();
                if (childCount == 9)
                {
                    
                    break;
                }
            }

            var tierOne = 3;
            GameEvents.SendCustomGameEventToServer("new_spells", {
                tier: tierOne
            });
        }

        if (heroLevel == 10)
        {
            for (var ability of SpiritWarriorAbilitiesTier4) {
            var childCount = $('#AbilityShopContainer').GetChildCount();
                if (childCount == 12)
                {
                    break;
                }
            AppendAbility(Container, ability);
            var childCount = $('#AbilityShopContainer').GetChildCount();
                if (childCount == 12)
                {
                    
                    break;
                }
            }

            var tierOne = 4;
            GameEvents.SendCustomGameEventToServer("new_spells", {
                tier: tierOne
            });
        }

        if (heroLevel == 15)
        {
            for (var ability of SpiritWarriorAbilitiesTier5) {
            var childCount = $('#AbilityShopContainer').GetChildCount();
                if (childCount == 15)
                {
                    break;
                }
            AppendAbility(Container, ability);
            var childCount = $('#AbilityShopContainer').GetChildCount();
                if (childCount == 15)
                {
                    
                    break;
                }
            }

            var tierOne = 5;
            GameEvents.SendCustomGameEventToServer("new_spells", {
                tier: tierOne
            });    
        }
    }

    if (heroName == 'npc_dota_hero_omniknight')
    {
        if (heroLevel == 2)
        {
            for (var ability of PaladinAbilitiesTier2) {
            var childCount = $('#AbilityShopContainer').GetChildCount();
                if (childCount == 6)
                {
                    break;
                }
            AppendAbility(Container, ability);
            var childCount = $('#AbilityShopContainer').GetChildCount();
                if (childCount == 6)  
                {
                    break;
                }
            }

            var tierOne = 2;
            GameEvents.SendCustomGameEventToServer("new_spells", {
                tier: tierOne
            });
        }
        
        if (heroLevel == 5)
        {
            for (var ability of PaladinAbilitiesTier3) {
            var childCount = $('#AbilityShopContainer').GetChildCount();
                if (childCount == 9)
                {
                    break;
                }
            AppendAbility(Container, ability);
            var childCount = $('#AbilityShopContainer').GetChildCount();
                if (childCount == 9)
                {
                    
                    break;
                }
            }

            var tierOne = 3;
            GameEvents.SendCustomGameEventToServer("new_spells", {
                tier: tierOne
            });
        }

        if (heroLevel == 10)
        {
            for (var ability of PaladinAbilitiesTier4) {
            var childCount = $('#AbilityShopContainer').GetChildCount();
                if (childCount == 12)
                {
                    break;
                }
            AppendAbility(Container, ability);
            var childCount = $('#AbilityShopContainer').GetChildCount();
                if (childCount == 12)
                {
                    
                    break;
                }
            }

            var tierOne = 4;
            GameEvents.SendCustomGameEventToServer("new_spells", {
                tier: tierOne
            });
        }

        if (heroLevel == 15)
        {
            for (var ability of PaladinAbilitiesTier5) {
            var childCount = $('#AbilityShopContainer').GetChildCount();
                if (childCount == 15)
                {
                    break;
                }
            AppendAbility(Container, ability);
            var childCount = $('#AbilityShopContainer').GetChildCount();
                if (childCount == 15)
                {
                    
                    break;
                }
            }

            var tierOne = 5;
            GameEvents.SendCustomGameEventToServer("new_spells", {
                tier: tierOne
            });    
        }
    }

   
}

(function() {
    BuildAbilityShopMenu();
})();


GameEvents.Subscribe("dota_player_gained_level", UpdateAbilityShopMenu);

