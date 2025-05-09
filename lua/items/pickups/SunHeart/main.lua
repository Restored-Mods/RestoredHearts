local ComplianceSunLocal = {}
local Helpers = RestoredHearts.Helpers
local sfx = SFXManager()

function ComplianceSunLocal:SunHeartCollision(pickup, collider)
	if collider.Type == EntityType.ENTITY_PLAYER and pickup.SubType == RestoredHearts.Enums.Pickups.Hearts.HEART_SUN then
		local player = collider:ToPlayer()
		if not Helpers.CanCollectCustomShopPickup(player, pickup) then
			return true
		end
		if ComplianceSun.CanPickSunHearts(player) then
			local collect = Helpers.CollectCustomPickup(player,pickup)
			if collect ~= nil then
				return collect
			end
			if Helpers.IsLost(player) then
				Helpers.AddCharge(player, 1, Helpers.GetUnchargedSlot(player, 0), true)
			else
				ComplianceSun.AddSunHearts(player, 2)
			end
			sfx:Play(RestoredHearts.Enums.SFX.Hearts.SUN_PICKUP, 1, 0)
			Game():GetLevel():SetHeartPicked()
			Game():ClearStagesWithoutHeartsPicked()
			Game():SetStateFlag(GameStateFlag.STATE_HEART_BOMB_COIN_PICKED, true)
			return true
		else
			return pickup:IsShopItem()
		end
	end
end
RestoredHearts:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, ComplianceSunLocal.SunHeartCollision, PickupVariant.PICKUP_HEART)

---@param pickup EntityPickup
function ComplianceSunLocal:PreEternalSpawn(pickup)
	if TSIL.Random.GetRandom(pickup.InitSeed) >= (1 - RestoredHearts:GetDefaultFileSave("SunHeartSpawnChance") / 100)
	and pickup.SubType == HeartSubType.HEART_ETERNAL then
		pickup:Morph(pickup.Type, PickupVariant.PICKUP_HEART, RestoredHearts.Enums.Pickups.Hearts.HEART_SUN, true, true)
	end
end
RestoredHearts:AddCallback(TSIL.Enums.CustomCallback.POST_PICKUP_INIT_FIRST, ComplianceSunLocal.PreEternalSpawn, PickupVariant.PICKUP_HEART)

function ComplianceSunLocal:SunClear(rng, pos)
	for i=0, Game():GetNumPlayers()-1 do
		local player = Isaac.GetPlayer(i)
		if ComplianceSun.GetSunHeartsNum(player) > 0 then
			for slot = 0,2 do
				if player:GetActiveItem(slot) ~= nil and player:GetActiveItem(slot) ~= CollectibleType.COLLECTIBLE_ALABASTER_BOX then
					local itemConfig = Isaac.GetItemConfig():GetCollectible(player:GetActiveItem(slot))
					if itemConfig and itemConfig.ChargeType ~= 2 then
						local charge = Helpers.GetCharge(player, slot)
						local battery = itemConfig.MaxCharges * Helpers.BatteryChargeMult(player)
						local tocharge = math.min(ComplianceSun.GetSunHeartsNum(player) / 2, battery - charge)
						local newcharge = 0
						for j = 1, tocharge do
							if rng:RandomInt(2) == 1 then
								newcharge = newcharge + 1
							end
						end
						if charge < battery and newcharge > 0 then
							Helpers.AddCharge(player, newcharge, slot, true)
							sfx:Play(RestoredHearts.Enums.SFX.Hearts.SUN_PICKUP,1,0)
							local BatteryEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BATTERY, 0, player.Position + Vector(0, 1), Vector.Zero, nil):ToEffect()
							BatteryEffect:GetSprite().Offset = Vector(0, -15)
							break
						end
					end
				end
			end
		end
	end
end
RestoredHearts:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, ComplianceSunLocal.SunClear)