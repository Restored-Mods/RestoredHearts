--MinimapAPI and Minimap Items Compatibility
if not MinimapAPI then return end

local Pickups = Sprite()
Pickups:Load("gfx/ui/minimapitems/restoreditems_pickups_icons.anm2", true)
MinimapAPI:AddIcon("SunHeartIcon", Pickups, "CustomIcons", 0)
MinimapAPI:AddPickup(RestoredHearts.Enums.Pickups.Hearts.HEART_SUN, "SunHeartIcon", EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, RestoredHearts.Enums.Pickups.Hearts.HEART_SUN, MinimapAPI.PickupNotCollected, "hearts", 13000)
MinimapAPI:AddIcon("ImmortalHeartIcon", Pickups, "CustomIcons", 1)
MinimapAPI:AddPickup(RestoredHearts.Enums.Pickups.Hearts.HEART_IMMORTAL, "ImmortalHeartIcon", EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, RestoredHearts.Enums.Pickups.Hearts.HEART_IMMORTAL, MinimapAPI.PickupNotCollected, "hearts", 13000)
MinimapAPI:AddIcon("IllusionHeartIcon", Pickups, "CustomIcons", 2)
MinimapAPI:AddPickup(RestoredHearts.Enums.Pickups.Hearts.HEART_ILLUSION, "IllusionHeartIcon", EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, RestoredHearts.Enums.Pickups.Hearts.HEART_ILLUSION, MinimapAPI.PickupNotCollected, "hearts", 13000)