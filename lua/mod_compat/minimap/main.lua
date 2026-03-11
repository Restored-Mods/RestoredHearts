--MinimapAPI and Minimap Items Compatibility
RestoredHearts:AddModCompat("MinimapAPI", function()
	local Pickups = Sprite()
	Pickups:Load("gfx/ui/minimapitems/restoreditems_pickups_icons.anm2", true)
	MinimapAPI:AddIcon("SunHeartIcon", Pickups, "CustomIcons", 0)
	MinimapAPI:AddPickup(
		"HeartSun",
		"SunHeartIcon",
		EntityType.ENTITY_PICKUP,
		PickupVariant.PICKUP_HEART,
		RestoredHearts.Enums.Pickups.Hearts.HEART_SUN,
		MinimapAPI.PickupNotCollected,
		"hearts",
		13000
	)
	MinimapAPI:AddIcon("ImmortalHeartIcon", Pickups, "CustomIcons", 1)
	MinimapAPI:AddPickup(
		"HeartImmortal",
		"ImmortalHeartIcon",
		EntityType.ENTITY_PICKUP,
		PickupVariant.PICKUP_HEART,
		RestoredHearts.Enums.Pickups.Hearts.HEART_IMMORTAL,
		MinimapAPI.PickupNotCollected,
		"hearts",
		13000
	)
	MinimapAPI:AddIcon("IllusionHeartIcon", Pickups, "CustomIcons", 2)
	MinimapAPI:AddPickup(
		RestoredHearts.Enums.Pickups.Hearts.HEART_ILLUSION,
		"IllusionHeartIcon",
		EntityType.ENTITY_PICKUP,
		PickupVariant.PICKUP_HEART,
		RestoredHearts.Enums.Pickups.Hearts.HEART_ILLUSION,
		MinimapAPI.PickupNotCollected,
		"hearts",
		13000
	)
end)
