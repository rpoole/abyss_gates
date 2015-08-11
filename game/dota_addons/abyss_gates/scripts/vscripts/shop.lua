function onBuyAbility(_, args)
	print("onBuyAbility")
	local purchasedAbility = args["ability"]
	print("purchasedAbility " .. purchasedAbility)
	local playerID = args["playerID"]
	local player = PlayerResource:GetPlayer(playerID)
	local hero = player:GetAssignedHero()
	hero:AddAbility(purchasedAbility)
end

function addAbility(playerId, hero, sourceHero)
	print("addAbility")
	local slotOne = hero:GetAbilityByIndex(0)
	local slotTwo = hero:GetAbilityByIndex(1)
	local slotThree = hero:GetAbilityByIndex(2)
	local slotFour = hero:GetAbilityByIndex(3)
	local slotFive = hero:GetAbilityByIndex(4)
end
