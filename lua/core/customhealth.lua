local sfx = SFXManager()

if CustomHealthAPI and CustomHealthAPI.Library and CustomHealthAPI.Library.UnregisterCallbacks then
    CustomHealthAPI.Library.UnregisterCallbacks("RestoredHearts")
end

CustomHealthAPI.Library.RegisterSoulHealth(
    "HEART_IMMORTAL",
    {
        AnimationFilename = "gfx/ui/ui_remix_hearts.anm2",
        AnimationName = {"ImmortalHeartHalf", "ImmortalHeartFull"},
        SortOrder = 150,
        AddPriority = 175,
        HealFlashRO = 240/255, 
        HealFlashGO = 240/255,
        HealFlashBO = 240/255,
        MaxHP = 2,
        PrioritizeHealing = true,
        PickupEntities = {
            {ID = EntityType.ENTITY_PICKUP, Var = PickupVariant.PICKUP_HEART, Sub = RestoredHearts.Enums.Pickups.Hearts.HEART_IMMORTAL}
        },
        SumptoriumSubType = 20,  -- immortal heart clot
        SumptoriumSplatColor = Color(1.00, 1.00, 1.00, 1.00, 214/255, 228/255, 1.00),
        SumptoriumTrailColor = Color(1.00, 1.00, 1.00, 1.00, 214/255, 228/255, 1.00),
        SumptoriumCollectSoundSettings = {
            ID = SoundEffect.SOUND_MEAT_IMPACTS,
            Volume = 1.0,
            FrameDelay = 0,
            Loop = false,
            Pitch = 1.0,
            Pan = 0
        }
    }
)

CustomHealthAPI.Library.RegisterSoulHealth(
    "HEART_SUN",
    {
        AnimationFilename = "gfx/ui/ui_remix_hearts.anm2",
        AnimationName = {"SunHeartFull"},
        SortOrder = 100,
        AddPriority = 125,
        HealFlashRO = 240/255, 
        HealFlashGO = 240/255,
        HealFlashBO = 240/255,
        MaxHP = 1,
        PrioritizeHealing = false,
        PickupEntities = {
            {ID = EntityType.ENTITY_PICKUP, Var = PickupVariant.PICKUP_HEART, Sub = RestoredHearts.Enums.Pickups.Hearts.HEART_SUN}
        },
        SumptoriumSubType = 30,  -- sun heart clot
        SumptoriumSplatColor = Color(1.00, 1.00, 1.00, 1.00, 1.00, 213/255, 0.00),
        SumptoriumTrailColor = Color(1.00, 1.00, 1.00, 1.00, 1.00, 213/255, 0.00),
        SumptoriumCollectSoundSettings = {
            ID = SoundEffect.SOUND_MEAT_IMPACTS,
            Volume = 1.0,
            FrameDelay = 0,
            Loop = false,
            Pitch = 1.0,
            Pan = 0
        }
    }
)

local function HeartGfxSuffix(var, hud)
    local suf = ""
    if var == 2 then
        suf = "_aladar"
    end
    if var == 3 then
        suf = "_peas"
    end
    if var == 4 and hud then
        suf = "_beautiful"
    end
    if var == 5 then
        suf = "_flashy"
    end
    if var == 6 then
        suf = "_bettericons"
    end
    if var == 7 and hud then
        suf = "_eternalupdate"
    end
    if var == 8 then
        suf = "_duxi"
    end
    if var == 9 and not hud then
        suf = "_sussy"
    end
    return suf
end

local function SpriteChange(_, entity)
	if entity.SubType == RestoredHearts.Enums.Pickups.Hearts.HEART_SUN
	or entity.SubType == RestoredHearts.Enums.Pickups.Hearts.HEART_ILLUSION
	or entity.SubType == RestoredHearts.Enums.Pickups.Hearts.HEART_IMMORTAL then
		local sprite = entity:GetSprite()
		local spritename = "gfx/items/pick ups/pickup_001_remix_heart"
		local style = RestoredHearts:GetDefaultFileSave("HeartStyleRender")
		spritename = spritename..HeartGfxSuffix(style)..".png"
		
		sprite:ReplaceSpritesheet(0,spritename)
		sprite:LoadGraphics()
	end
end
RestoredHearts:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, SpriteChange, PickupVariant.PICKUP_HEART)

CustomHealthAPI.Library.AddCallback("RestoredHearts", CustomHealthAPI.Enums.Callbacks.POST_HEALTH_DAMAGED, 0, function(player, flags, key, hpDamaged, wasDepleted, wasLastDamaged)
	if key == "HEART_SUN" then
		if wasDepleted then
			sfx:Play(RestoredHearts.Enums.SFX.Hearts.SUN_BREAK, 1, 0)
			local shatterSPR = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, 0, player.Position + Vector(0, 0), Vector.Zero, nil):ToEffect():GetSprite()
			shatterSPR:Play("Yellow",true)
			shatterSPR.Offset = Vector(0, -15)
		end
	end
    if key == "HEART_IMMORTAL" then
		if wasDepleted then
			ComplianceImmortal.ImmortalHeartBreak(player.Position)
		else
			player:GetData().ImmortalHeartDamage = true
		end
	end
end)

CustomHealthAPI.Library.AddCallback("RestoredHearts", CustomHealthAPI.Enums.Callbacks.PRE_HEALTH_DAMAGED, 0, function(player, flags, key, hpDamaged, otherKey, otherHPDamaged, amountToRemove)
	if otherKey == "HEART_IMMORTAL" then
		return 1
	end
end)

CustomHealthAPI.Library.AddCallback("RestoredHearts", CustomHealthAPI.Enums.Callbacks.PRE_RENDER_HEART, 0, function(player, index, hp, redHP, filename, animname, color, offset)
	local data = IllusionMod.GetData(player)
	if data.IsIllusion and not player:IsDead() then
		local var = RestoredHearts:GetDefaultFileSave("HeartStyleRender")
		local animfile = "gfx/ui/ui_remix_hearts"..HeartGfxSuffix(var, true)
		return {AnimationName = "IllusionHeartFull", AnimationFilename = animfile..".anm2"}
	end
end)

CustomHealthAPI.Library.AddCallback("RestoredHearts", CustomHealthAPI.Enums.Callbacks.ON_SAVE, 0, function(save, isSaving)
    if isSaving then
        local chapiSave = RestoredHearts:RunSave()
        chapiSave.CustomHealthAPI = save
    end
end)

CustomHealthAPI.Library.AddCallback("RestoredHearts", CustomHealthAPI.Enums.Callbacks.ON_LOAD, 0, function()
    local chapiSave = RestoredHearts:RunSave()
    if chapiSave.CustomHealthAPI ~= nil and chapiSave.CustomHealthAPI ~= "" then
        return chapiSave.CustomHealthAPI
    end
end)

CustomHealthAPI.Library.AddCallback("RestoredHearts", CustomHealthAPI.Enums.Callbacks.PRE_SUMPTORIUM_CLOT_INIT, 0, function(familiar, key)
    if key == "HEART_IMMORTAL" then
        local player = familiar.Player
        if player then
            if  ComplianceImmortal.GetImmortalHeartsNum(player) % 2 == 0 then
                ComplianceImmortal.ImmortalHeartBreak(player.Position)
            end
            local clot
            for _, s_clot in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 20)) do
                s_clot = s_clot:ToFamiliar()
                if GetPtrHash(s_clot.Player) == GetPtrHash(player) and GetPtrHash(familiar) ~= GetPtrHash(s_clot) then
                    clot = s_clot
                    break
                end
            end
            if clot ~= nil and clot.InitSeed ~= familiar.InitSeed then
                local clotData = clot:GetData()
                clotData.RC_HP = clotData.RC_HP + 1
                local ImmortalEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, ComplianceImmortal.Effects.IMMORTAL_HEART_CHARGE, 0, clot.Position + Vector(0, 1), Vector.Zero, nil):ToEffect()
                ImmortalEffect:GetSprite().Offset = Vector(0, -10)
                familiar:Remove()
                return true
            end
        end
    end
end)

local function StaticClotHP(_, clot)
	if clot.SubType == 20 or clot.SubType == 30 then
		local clotData = clot:GetData()
		if (clotData.RC_HP == nil) then
			clotData.RC_HP = clot.HitPoints
		else
			local damageTaken = clotData.RC_HP - clot.HitPoints
			if (damageTaken > 0.19 and damageTaken < 0.21) then
				clot.HitPoints = clot.HitPoints + damageTaken
			elseif (damageTaken > 1.19 and damageTaken < 1.21) then
				clot.HitPoints = clot.HitPoints - 1.0
			else
				clotData.RC_HP = clot.HitPoints
			end
		end
	end
end
RestoredHearts:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, StaticClotHP, FamiliarVariant.BLOOD_BABY)