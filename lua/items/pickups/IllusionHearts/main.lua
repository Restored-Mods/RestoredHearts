local IllusionModLocal = {} --For local functions, so other mods don't have access to these
local sfx = SFXManager()

function IllusionModLocal:preIllusionHeartPickup(pickup, collider)
	local player = collider:ToPlayer()
	if player then
		if pickup.Variant == PickupVariant.PICKUP_HEART and pickup.SubType == RestoredHearts.Enums.Pickups.Hearts.HEART_ILLUSION and not player.Parent then
			pickup.Velocity = Vector.Zero
			pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			pickup:GetSprite():Play("Collect", true)
			pickup:Die()
			IllusionMod:addIllusion(player, true)
			sfx:Play(RestoredHearts.Enums.SFX.Hearts.ILLUSION_PICKUP, 1, 0, false)
			return true
		end
	end
end
RestoredHearts:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, IllusionModLocal.preIllusionHeartPickup)

---@param pickup EntityPickup
function IllusionModLocal:PreGoldenSpawn(pickup)
	if TSIL.Random.GetRandom(pickup.InitSeed) >= (1 - RestoredHearts:GetDefaultFileSave("IllusionHeartSpawnChance") / 100)
	and pickup.SubType == HeartSubType.HEART_GOLDEN then
		pickup:Morph(pickup.Type, PickupVariant.PICKUP_HEART, RestoredHearts.Enums.Pickups.Hearts.HEART_ILLUSION, true, true)
	end
end
RestoredHearts:AddCallback(TSIL.Enums.CustomCallback.POST_PICKUP_INIT_FIRST, IllusionModLocal.PreGoldenSpawn, PickupVariant.PICKUP_HEART)