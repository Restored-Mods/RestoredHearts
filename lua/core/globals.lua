RestoredHearts.Game = Game()
RestoredHearts.Level = function()
	return RestoredHearts.Game:GetLevel()
end
RestoredHearts.Room = function()
	return RestoredHearts.Game:GetRoom()
end

RestoredHearts:AddDefaultFileSave("HeartStyleRender", 1)
RestoredHearts:AddDefaultFileSave("IllusionHeartSpawnChance", 20)
RestoredHearts:AddDefaultFileSave("SunHeartSpawnChance", 20)
RestoredHearts:AddDefaultFileSave("ImmortalHeartSpawnChance", 20)
RestoredHearts:AddDefaultFileSave("ActOfContritionImmortal", false)

RestoredHearts.SaveManager.Utility.AddDefaultRunData(RestoredHearts.SaveManager.DefaultSaveKeys.GLOBAL, {CustomHealthAPI = "", IllusionData = {}})

RestoredHearts.RNG = RNG()

RestoredHearts:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
	RestoredHearts.RNG:SetSeed(RestoredHearts.Game:GetSeeds():GetStartSeed())
end)

RestoredHearts:AddCallback(RestoredHearts.SaveManager.SaveCallbacks.PRE_DATA_SAVE, function(_, data)
	local newData = {
		game = {
			run = {
				IllusionData = IllusionMod.GetSaveData()
			}
		}
	}
	return RestoredHearts.SaveManager.Utility.PatchSaveFile(newData, data)
end)

RestoredHearts:AddCallback(RestoredHearts.SaveManager.SaveCallbacks.POST_DATA_LOAD, function(_, data, luaMod)
	if not luaMod then
        IllusionMod.LoadSaveData(data.game.run.IllusionData)
	end
end)