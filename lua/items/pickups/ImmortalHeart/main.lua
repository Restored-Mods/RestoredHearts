local ComplianceImmortalLocal = {}
local Helpers = RestoredHearts.Helpers
local sfx = SFXManager()

function ComplianceImmortalLocal:ImmortalHeartCollision(pickup, collider)
	if collider.Type == EntityType.ENTITY_PLAYER and pickup.SubType == RestoredHearts.Enums.Pickups.Hearts.HEART_IMMORTAL then
		local player = collider:ToPlayer()
		if not Helpers.CanCollectCustomShopPickup(player, pickup) then
			return true
		end
		if ComplianceImmortal.CanPickImmortalHearts(player) then
			local collect = Helpers.CollectCustomPickup(player,pickup)
			if collect ~= nil then
				return collect
			end
			if not Helpers.IsLost(player) then
				ComplianceImmortal.AddImmortalHearts(player, 2)
			end
			sfx:Play(RestoredHearts.Enums.SFX.Hearts.IMMORTAL_PICKUP, 1, 0)
			Game():GetLevel():SetHeartPicked()
			Game():ClearStagesWithoutHeartsPicked()
			Game():SetStateFlag(GameStateFlag.STATE_HEART_BOMB_COIN_PICKED, true)
			return true
		else
			return pickup:IsShopItem()
		end
	end
end
RestoredHearts:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, ComplianceImmortalLocal.ImmortalHeartCollision, PickupVariant.PICKUP_HEART)

if REPENTOGON then
	function ComplianceImmortalLocal:ActOfImmortal(collectible, charge, firstTime, slot, VarData, player)
		if firstTime and collectible == CollectibleType.COLLECTIBLE_ACT_OF_CONTRITION
		and RestoredHearts:GetDefaultFileSave("ActOfContritionImmortal") then
			player:AddEternalHearts(-1)
			ComplianceImmortal.AddImmortalHearts(player, 2)
		end
	end
	RestoredHearts:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, ComplianceImmortalLocal.ActOfImmortal)
else
	function ComplianceImmortalLocal:OnPlayerInit(player)
		local data = Helpers.GetData(player)
		data.ActCount = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_ACT_OF_CONTRITION)
	end
	RestoredHearts:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, ComplianceImmortalLocal.OnPlayerInit)

	function ComplianceImmortalLocal:ActOfImmortal(player, cache)
		if player.Parent ~= nil then return end
		if RestoredHearts:GetDefaultFileSave("ActOfContritionImmortal") == false then return end
		if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B then
			player = player:GetMainTwin()
		end
		local data = Helpers.GetData(player)
		if data.ActCount and player:GetCollectibleNum(CollectibleType.COLLECTIBLE_ACT_OF_CONTRITION) > data.ActCount then
			local p = player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN and player:GetSubPlayer() or player
			player:AddEternalHearts(-1)
			ComplianceImmortal.AddImmortalHearts(p, 2)
		end
		data.ActCount = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_ACT_OF_CONTRITION)
	end
	RestoredHearts:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ComplianceImmortalLocal.ActOfImmortal, CacheFlag.CACHE_FIREDELAY)
end

---@param pickup EntityPickup
function ComplianceImmortalLocal:PreEternalSpawn(pickup)
	if TSIL.Random.GetRandom(pickup.InitSeed) >= (1 - RestoredHearts:GetDefaultFileSave("ImmortalHeartSpawnChance") / 100)
	and pickup.SubType == HeartSubType.HEART_ETERNAL then
		pickup:Morph(pickup.Type, PickupVariant.PICKUP_HEART, RestoredHearts.Enums.Pickups.Hearts.HEART_IMMORTAL, true, true)
	end
end
RestoredHearts:AddCallback(TSIL.Enums.CustomCallback.POST_PICKUP_INIT_FIRST, ComplianceImmortalLocal.PreEternalSpawn, PickupVariant.PICKUP_HEART)