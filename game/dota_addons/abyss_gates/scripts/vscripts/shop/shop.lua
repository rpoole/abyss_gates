function onBuyAbility(_, args)
	print("onBuyAbility")
	local playerId = args["PlayerID"]
	print("PlayerID: " .. playerId)
	local sourceHero = args["sourceHero"]
	print("sourceHero " .. sourceHero)
	local purchasedAbility = args["ability"]
	print("purchasedAbility " .. purchasedAbility)
	local hero = PlayerResource:GetPlayer(playerId):GetAssignedHero()
	print("hero: " .. hero)
end


function addAbility(playerId, hero, sourceHero)
	print("addAbility")
	local slotOne = hero:GetAbilityByIndex(0)
	local slotTwo = hero:GetAbilityByIndex(1)
	local slotThree = hero:GetAbilityByIndex(2)
	local slotFour = hero:GetAbilityByIndex(3)
	local slotFive = hero:GetAbilityByIndex(4)
end

function registerShopCallbacks()
	CustomGameEventManager:RegisterListener("buy_ability", onBuyAbility)
end
