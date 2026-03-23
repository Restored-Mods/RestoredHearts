local IllusionModLocal = {} --For local functions, so other mods don't have access to these
local Helpers = RestoredHearts.Helpers
local sfx = SFXManager()

function IllusionModLocal:preIllusionHeartPickup(pickup, collider)
	local player = collider:ToPlayer()
	if player then
		if
			pickup.Variant == PickupVariant.PICKUP_HEART
			and pickup.SubType == RestoredHearts.Enums.Pickups.Hearts.HEART_ILLUSION
			and not player.Parent
		then
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
	if
		RestoredHearts:GetDefaultFileSave("IllusionHeartSpawnChance") > 0
		and TSIL.Random.GetRandom(pickup.InitSeed)
			>= (1 - RestoredHearts:GetDefaultFileSave("IllusionHeartSpawnChance") / 100)
	then
		pickup:Morph(
			pickup.Type,
			PickupVariant.PICKUP_HEART,
			RestoredHearts.Enums.Pickups.Hearts.HEART_ILLUSION,
			true,
			true
		)
	end
end
RestoredHearts:AddCallback(
	TSIL.Enums.CustomCallback.POST_PICKUP_INIT_FIRST,
	IllusionModLocal.PreGoldenSpawn,
	{ PickupVariant.PICKUP_HEART, HeartSubType.HEART_GOLDEN }
)

---@param pickup EntityPickup
function IllusionModLocal:PreIllusionSpawn(pickup)
	if
		RestoredHearts:GetDefaultFileSave("IllusionHeartSpawnChance") <= 0
	then
		pickup:Morph(
			pickup.Type,
			PickupVariant.PICKUP_HEART,
			HeartSubType.HEART_GOLDEN,
			true,
			true
		)
	end
end
RestoredHearts:AddPriorityCallback(
	TSIL.Enums.CustomCallback.POST_PICKUP_INIT_FIRST,
	1,
	IllusionModLocal.PreIllusionSpawn,
	{ PickupVariant.PICKUP_HEART, RestoredHearts.Enums.Pickups.Hearts.HEART_ILLUSION }
)