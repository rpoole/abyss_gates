function onBuyAbility(_, args)
	print("onBuyAbility")
	local purchasedAbility = args["ability"]
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

function tierMessage(_, args)
	local number = args["tier"]
	local message = ("You already have a Tier " .. number .. " skill.")
	GameRules:SendCustomMessage(message, 0, 0)
end

function tierMessageTwo(_, args)
	local number = args["tier"]
	local message = ("Select your Tier " .. number - 1 .. " skill first!")
	GameRules:SendCustomMessage(message, 0, 0)
end

function newSpellsMessage(_, args)
	local number = args["tier"]
	local message = ("Tier " .. number .. " skills are available! Check the shop!")
	GameRules:SendCustomMessage(message, 0, 0)
end
