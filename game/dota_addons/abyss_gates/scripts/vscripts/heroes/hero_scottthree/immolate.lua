--[[
    author: jacklarnes
    email: christucket@gmail.com
    reddit: /u/jacklarnes
    Date: 05.04.2015.
]]

--[[
    Notes: logic might be a bit different around when damage ticks/when mana is drained
]]

function immolate_start( keys )
    local caster = keys.caster
    local ability = keys.ability

    local mana_per_sec = ability:GetLevelSpecialValueFor("mana_per_second", ability:GetLevel() - 1)
    local damage_tick = ability:GetLevelSpecialValueFor("damage_tick", ability:GetLevel() - 1)

    immolate_take_mana({caster=caster,
                        ability=ability,
                        mana_per_sec=mana_per_sec,
                        damage_tick=damage_tick})
end

function immolate_take_mana( params )
    if params.ability:GetToggleState() == false then
        return
    end

    params.caster:ReduceMana(params.mana_per_sec)
    if params.caster:GetMana() < params.mana_per_sec then
        params.ability:ToggleAbility()
    end
    
    Timers:CreateTimer(params.damage_tick,
        function()
            immolate_take_mana(params)
        end
    )
end

function immolate_stop( keys )
    local caster = keys.caster
    local sound = "Hero_Leshrac.Pulse_Nova"

    StopSoundEvent(sound, caster)
end