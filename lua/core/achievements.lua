if not REPENTOGON then return end

local Achievements = {}
local pgd = Isaac.GetPersistentGameData()

function Achievements:ExtraAchievementsCheck()
    local achs = RestoredHearts.Enums.Achievements
    for id, achievement in pairs(achs) do
        if not pgd:Unlocked(achievement) then
            pgd:TryUnlock(achievement)
        end
    end
end
RestoredHearts:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, Achievements.ExtraAchievementsCheck)