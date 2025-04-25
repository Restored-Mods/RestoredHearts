local localversion = 1.2
local name = "Immortal Hearts API"

local function load()
	ComplianceImmortal = RegisterMod(name, 1)
	ComplianceImmortal.Version = localversion
    ComplianceImmortal.Loaded = false

    local sounds = {
        IMMORTAL_PICKUP = Isaac.GetSoundIdByName("ImmortalHeartPickup"),
        IMMORTAL_BREAK = Isaac.GetSoundIdByName("ImmortalHeartBreak")
    }

    local effects = {
        IMMORTAL_HEART_CHARGE = Isaac.GetEntityVariantByName("Immortal Heart Charge"),
        IMMORTAL_HEART_BREAK = Isaac.GetEntityVariantByName("Immortal Heart Break"),
    }

    function ComplianceImmortal.GetImmortalHeartsNum(player)
        if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
            player = player:GetSubPlayer()
        end
        return player ~= nil and CustomHealthAPI.Library.GetHPOfKey(player, "HEART_IMMORTAL") or 0
    end
    
    function ComplianceImmortal.GetImmortalHearts(player)
        return ComplianceImmortal.GetImmortalHeartsNum(player)
    end
    
    function ComplianceImmortal.AddImmortalHearts(player, hp)
        CustomHealthAPI.Library.AddHealth(player, "HEART_IMMORTAL", hp)
    end
    
    function ComplianceImmortal.CanPickImmortalHearts(player)
        return CustomHealthAPI.Library.CanPickKey(player, "HEART_IMMORTAL")
    end
    
    function ComplianceImmortal.HealImmortalHeart(player) -- returns true if successful
        if ComplianceImmortal.GetImmortalHeartsNum(player) > 0 and ComplianceImmortal.GetImmortalHeartsNum(player) % 2 ~= 0 then
            local ImmortalEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, effects.IMMORTAL_HEART_CHARGE, 0, player.Position + Vector(0, 1), Vector.Zero, nil):ToEffect()
            ImmortalEffect:GetSprite().Offset = Vector(0, -22)
            SFXManager():Play(sounds.IMMORTAL_PICKUP, 1, 0)
            ComplianceImmortal.AddImmortalHearts(player, 1)
            return true
        end
        return false
    end

    function ComplianceImmortal.ImmortalHeartBreak(position)
        SFXManager():Play(sounds.IMMORTAL_BREAK, 1, 0)
        local shatterSPR = Isaac.Spawn(EntityType.ENTITY_EFFECT, effects.IMMORTAL_HEART_BREAK, 0, position + Vector(0, 1), Vector.Zero, nil):ToEffect():GetSprite()
        shatterSPR.PlaybackSpeed = 2
    end

    local function ModReset()
        ComplianceImmortal.Loaded = false
    end
    ComplianceImmortal:AddCallback(ModCallbacks.MC_PRE_MOD_UNLOAD, ModReset)

    local function ImmortalHeartIFrames(_, player, damage, flags, source, cd)
		if player:GetData().ImmortalHeartDamage then
			player = player:ToPlayer()
			local cd = 20
			player:ResetDamageCooldown()
			player:SetMinDamageCooldown(cd)
			if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B or player:GetPlayerType() == PlayerType.PLAYER_ESAU
			or player:GetPlayerType() == PlayerType.PLAYER_JACOB then
				player:GetOtherTwin():ResetDamageCooldown()
				player:GetOtherTwin():SetMinDamageCooldown(cd)
			end
			player:GetData().ImmortalHeartDamage = nil
		end
	end
    if REPENTOGON then
	    ComplianceImmortal:AddCallback(ModCallbacks.MC_POST_TAKE_DMG, ImmortalHeartIFrames, EntityType.ENTITY_PLAYER)
    else
        ComplianceImmortal:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ImmortalHeartIFrames)
    end

    local function ImmortalHeal()
        for i = 0, Game():GetNumPlayers() - 1 do
            ComplianceImmortal.HealImmortalHeart(Isaac.GetPlayer(i))
        end
    end
    ComplianceImmortal:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, ImmortalHeal)

	print("[".. ComplianceImmortal.Name .."]", "is loaded. Version "..ComplianceImmortal.Version)
	ComplianceImmortal.Loaded = true
end

if not CustomHealthAPI then
    print("[".. name .."]", " couldn't be loaded. Missing CustomHealthAPI.")
else
    if ComplianceImmortal then
        if ComplianceImmortal.Version < localversion or not ComplianceImmortal.Loaded then
            if not ComplianceImmortal.Loaded then
                print("Reloading [".. ComplianceImmortal.Name .."]")
            else
                print("[".. ComplianceImmortal.Name .."]", " found old script V" .. ComplianceImmortal.Version .. ", found new script V" .. localversion .. ". replacing...")
            end
            ComplianceImmortal = nil
            load()
        end
    elseif not ComplianceImmortal then
        load()
    end
end