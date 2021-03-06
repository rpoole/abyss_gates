requires = {
	'util',
	'timers',
	'physics',
	'lib.statcollection',
	'abilities',
	'abyss_gates',
	'base_trigger',
	'shop'
}

function Precache( context )
	-- NOTE: IT IS RECOMMENDED TO USE A MINIMAL AMOUNT OF LUA PRECACHING, AND A MAXIMAL AMOUNT OF DATADRIVEN PRECACHING.
	-- Precaching guide: https://moddota.com/forums/discussion/119/precache-fixing-and-avoiding-issues

	print("[ABYSS_GATES] Performing pre-load precache")

	PrecacheUnitByNameSync("creature_tgarri", context)
	PrecacheUnitByNameSync("creature_tgarri_first_split", context)
	PrecacheUnitByNameSync("creature_tgarri_second_split", context)
	PrecacheUnitByNameSync("creature_tgarri_third_split", context)
	PrecacheUnitByNameSync("creature_tgarri_fourth_split", context)
	PrecacheUnitByNameSync("creature_spiderling", context)
	PrecacheUnitByNameSync("undead_burning_skeleton_archer", context)
	PrecacheUnitByNameSync("undead_skeleton_archer", context)
	PrecacheUnitByNameSync("undead_skeleton_warrior", context)
	PrecacheUnitByNameSync("undead_burning_skeleton_warrior", context)
	PrecacheUnitByNameSync("undead_skeleton_fire_mage", context)
	PrecacheUnitByNameSync("creature_boar", context)
	PrecacheUnitByNameSync("creature_grasper", context)
	PrecacheUnitByNameSync("creature_grasper_venomancer", context)
	PrecacheUnitByNameSync("creature_great_turtle", context)
	PrecacheUnitByNameSync("creature_ancient_turtle", context)
	PrecacheUnitByNameSync("creature_mervian_clasper", context)
	PrecacheUnitByNameSync("creature_mervian_mauler", context)
	PrecacheUnitByNameSync("creature_kerrang", context)
	PrecacheUnitByNameSync("creature_dryad", context)
	PrecacheUnitByNameSync("creature_nightshade_huntress", context)
	PrecacheUnitByNameSync("creature_harlequin_spider", context)
	PrecacheUnitByNameSync("creature_arachnesser", context)
	PrecacheUnitByNameSync("the_creature", context)
	PrecacheUnitByNameSync("npc_dota_hero_juggernaut", context)
	PrecacheUnitByNameSync("creature_centaur_hunter", context)
	PrecacheUnitByNameSync("creature_centaur_shaman", context)
	PrecacheUnitByNameSync("creature_oghmar_grayskin", context)
	PrecacheUnitByNameSync("creature_tauren_warrior", context)
	PrecacheUnitByNameSync("creature_tauren_cleanser", context)
	PrecacheUnitByNameSync("creature_urmgot", context)
	PrecacheUnitByNameSync("creature_megremoros", context)
	PrecacheUnitByNameSync("creature_enfrit", context)
	PrecacheUnitByNameSync("creature_fire_priest", context)
	PrecacheUnitByNameSync("creature_pyramourn", context)
	PrecacheUnitByNameSync("creature_greater_fire_priest", context)
	PrecacheUnitByNameSync("creature_corrupt_troll", context)
	PrecacheUnitByNameSync("creature_troll_shadowpriest", context)
	PrecacheModel("models/creeps/neutral_creeps/n_creep_troll_skeleton/n_creep_troll_skeleton_fx.vmdl", context) --[[Returns:void
	( modelName, context ) - Manually precache a single model
	]]
	-- Particles can be precached individually or by folder
	-- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed
	--PrecacheResource("particle", "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", context)
	--PrecacheResource("particle_folder", "particles/test_particle", context)
	PrecacheResource("particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_witchdoctor/witchdoctor_cask.vpcf", context)
	PrecacheResource("particle", "particles/skull_spear.vpcf", context)
	PrecacheResource("particle", "particles/bleed_earth.vpcf", context)
	PrecacheResource("particle", "particles/bleed_earth2.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti4/teleport_start_l_ti4.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", context)
	PrecacheResource("particle", "particles/divine_light.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_ursa/ursa_earthshock.vpcf", context)
	PrecacheResource("particle", "particles/stone_fist_two.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_life_stealer/life_stealer_rage.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf", context)
	PrecacheResource("particle", "particles/heal_aura.vpcf", context)
	PrecacheResource("particle", "particles/stone_skin_aura.vpcf", context)
	PrecacheResource("particle", "particles/might_aura.vpcf", context)
	PrecacheResource("particle", "particles/warmth_aura.vpcf", context)
	PrecacheResource("particle", "particles/swiftness_aura.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_bane/bane_enfeeble.vpcf", context)
	PrecacheResource("particle", "particles/items2_fx/medallion_of_courage.vpcf", context)
	PrecacheResource("particle", "particles/status_fx/status_effect_rupture.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture_nuke.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_team_blastup_immortal1.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_death_prophet/death_prophet_carrion_swarm.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/riki/riki_haze_atrocity/riki_versuta_eye_smoke.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_slardar/slardar_amp_damage.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/necrolyte/necronub_ambient/necrolyte_ambient_glow_ka.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_medusa/medusa_mana_shield_snakeskin_base2.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_skywrath_mage/skywrath_mage_ancient_seal_debuff.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_warlock/warlock_rain_of_chaos_explosion.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_echoslam_start_fallback_mid_egset.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti5/cyclone_ti5.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_bounty_hunter/bounty_hunter_windwalk.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_venomancer/venomancer_poison_debuff_nova.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_pugna/pugna_life_drain_beam.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_undying/undying_decay.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_lich/lich_frost_nova.vpcf", context)
	PrecacheResource("particle", "particles/status_fx/status_effect_frost_lich.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_wings.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_jakiro/jakiro_macropyre.vpcf", context)
	PrecacheResource("particle", "particles/neutral_fx/mini_rosh_fire.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_ground.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/sven/sven_warcry_ti5/sven_warcry_cast_arc_lightning.vpcf", context)
	PrecacheResource("particle", "particles/items2_fx/mekanism_recipient.vpcf", context)
	PrecacheResource("particle", "particles/items_fx/arcane_boots_recipient.vpcf", context)
	PrecacheResource("particle", "particles/items2_fx/mekanism.vpcf", context)
	PrecacheResource("particle", "particles/items_fx/arcane_boots.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf", context)
	PrecacheResource("particle", "particles/items2_fx/skadi_projectile.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_lich/lich_frost_armor_model.vpcf", context)
	PrecacheResource("particle", "particles/items2_fx/mjollnir_shield_arc_system.vpcf", context)
	PrecacheResource("particle", "particles/items2_fx/mjollnir_shield.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_lina.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray_team.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_wisp/wisp_guardian_.vpcf", context)
	PrecacheResource("particle", "particles/one_charge.vpcf", context)
	PrecacheResource("particle", "particles/two_charge.vpcf", context)
	PrecacheResource("particle", "particles/three_charge.vpcf", context)
	PrecacheResource("particle", "particles/parent_charge_one.vpcf", context)
	PrecacheResource("particle", "particles/parent_charge_two.vpcf", context)
	PrecacheResource("particle", "particles/parent_charge_three.vpcf", context)


	-- Models can also be precached by folder or individually
	--PrecacheModel should generally used over PrecacheResource for individual models
	--PrecacheResource("model_folder", "particles/heroes/antimage", context)
	--PrecacheResource("model", "particles/heroes/viper/viper.vmdl", context)
	--PrecacheModel("models/heroes/viper/viper.vmdl", context)

	-- Sounds can precached here like anything else


	-- Entire items can be precached by name
	-- Abilities can also be precached in this way despite the name

	-- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
	-- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way

end

-- Create the game mode when we activate
function Activate()
	GameRules.Abyss_Gates = Abyss_Gates()
	GameRules.Abyss_Gates:InitAbyss_Gates()
end

for i,v in ipairs(requires) do
	require(v)	
end
