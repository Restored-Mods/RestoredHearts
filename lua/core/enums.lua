local Enums = {}


Enums.Effects = 
				{
					IMMORTAL_HEART_CHARGE = Isaac.GetEntityVariantByName("Immortal Heart Charge"),
					IMMORTAL_HEART_BREAK = Isaac.GetEntityVariantByName("Immortal Heart Break"),
					
				}

Enums.Familiars = 
				{
					IMMORTAL_CLOT =
								{
									Type = Isaac.GetEntityTypeByName("Immortal Baby"),
									Variant = Isaac.GetEntityVariantByName("Immortal Baby"),
									SubType = 0
								},
					SUN_CLOT =
								{
									Type = Isaac.GetEntityTypeByName("Sun Baby"),
									Variant = Isaac.GetEntityVariantByName("Sun Baby"),
									SubType = 0
								},
				}

Enums.Pickups = 
				{
					Hearts = 
							{
								HEART_IMMORTAL = REPENTOGON and Isaac.GetEntitySubTypeByName("Immortal Heart") or 902,
								HEART_SUN = REPENTOGON and Isaac.GetEntitySubTypeByName("Sun Heart") or 910,
								HEART_ILLUSION = REPENTOGON and Isaac.GetEntitySubTypeByName("Illusion Heart") or 9000,
							},
				}

Enums.SFX =
				{
					Hearts =
							{
								IMMORTAL_PICKUP = Isaac.GetSoundIdByName("immortal"),
								IMMORTAL_BREAK = Isaac.GetSoundIdByName("ImmortalHeartBreak"),
								SUN_PICKUP = Isaac.GetSoundIdByName("PickupSun"),
								SUN_BREAK = Isaac.GetSoundIdByName("SunBreak"),
								ILLUSION_PICKUP = Isaac.GetSoundIdByName("PickupIllusion"),
							},
				}

if REPENTOGON then
	Enums.Achievements = {
		ILLUSION_HEART = Isaac.GetAchievementIdByName("Illusion Heart"),
		IMMORTAL_HEART = Isaac.GetAchievementIdByName("Immortal Heart"),
	}
end

RestoredHearts.Enums = Enums