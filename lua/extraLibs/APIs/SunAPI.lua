local localversion = 1.1
local name = "Sun Hearts API"

local function Log(str)
	print(str)
	Isaac.DebugString(str)
end

local function load()
	ComplianceSun = RegisterMod(name, 1)
	ComplianceSun.Version = localversion
	ComplianceSun.Loaded = false

	function ComplianceSun.GetSunHeartsNum(player)
		if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
			player = player:GetSubPlayer()
		end
		return player ~= nil and CustomHealthAPI.Library.GetHPOfKey(player, "HEART_SUN") or 0
	end

	function ComplianceSun.AddSunHearts(player, hp)
		CustomHealthAPI.Library.AddHealth(player, "HEART_SUN", hp)
	end

	function ComplianceSun.CanPickSunHearts(player)
		return CustomHealthAPI.Library.CanPickKey(player, "HEART_SUN")
	end

	function ComplianceSun:ModReset()
		ComplianceSun.Loaded = false
	end
	ComplianceSun:AddCallback(ModCallbacks.MC_PRE_MOD_UNLOAD, ComplianceSun.ModReset)

	function ComplianceSun:ModLoad()
		if not ComplianceSun.Loaded then
			Log("[" .. ComplianceSun.Name .. "] is loaded. Version " .. ComplianceSun.Version)
			ComplianceSun.Loaded = true
		end
	end
	ComplianceSun:AddCallback(
		REPENTOGON and ModCallbacks.MC_POST_MODS_LOADED or ModCallbacks.MC_POST_GAME_STARTED,
		ComplianceSun.ModLoad
	)
end

if not CustomHealthAPI then
	Log("[" .. name .. "] couldn't be loaded. Missing CustomHealthAPI.")
else
	if ComplianceSun then
		if ComplianceSun.Version < localversion or not ComplianceSun.Loaded then
			if not ComplianceSun.Loaded then
				Log("[" .. ComplianceSun.Name .. "] Reloading...")
			else
				Log(
					"["
						.. ComplianceSun.Name
						.. "] Found old script V"
						.. ComplianceSun.Version
						.. ". Replacing with V"
						.. localversion
				)
			end
			ComplianceSun = nil
			load()
			ComplianceSun:ModLoad()
		end
	elseif not ComplianceSun then
		load()
		ComplianceSun:ModLoad()
	end
end
