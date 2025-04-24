RestoredHearts.Game = Game()
RestoredHearts.Level = function()
	return RestoredHearts.Game:GetLevel()
end
RestoredHearts.Room = function()
	return RestoredHearts.Game:GetRoom()
end

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

RestoredHearts:AddCallback(RestoredHearts.SaveManager.SaveCallbacks.PRE_DATA_LOAD, function(_, data, luaMod)
	if not luaMod then
        local settings = {
			["HeartStyleRender"] = 1,
			["IllusionHeartSpawnChance"] = 20,
			["SunHeartSpawnChance"] = 20,
			["ImmortalHeartSpawnChance"] = 20,
			["ActOfContritionImmortal"] = false,
			["IllusionCanPlaceBomb"] = IllusionMod.CanPlaceBomb,
			["IllusionInstaDeath"] = IllusionMod.InstaDeath,
			["IllusionPerfectIllusion"] = IllusionMod.PerfectIllusion,
		}
		for k,v in pairs(settings) do
			if data.file.other[k] == nil then
				data.file.other[k] = v
			end
		end
		return data
	end
end)

RestoredHearts:AddCallback(RestoredHearts.SaveManager.SaveCallbacks.POST_DATA_LOAD, function(_, data, luaMod)
	if not luaMod then
        IllusionMod.LoadSaveData(data.game.run.IllusionData)
		IllusionMod.CanPlaceBomb = data.file.other.IllusionCanPlaceBomb
		IllusionMod.InstaDeath = data.file.other.IllusionInstaDeath
		IllusionMod.PerfectIllusion = data.file.other.IllusionPerfectIllusion
	end
end)