if not EID then return end
-- Mod Icon (TODO)
EID:setModIndicatorName("Restored Hearts")
local iconSprite = Sprite()
iconSprite:Load("gfx/eid_restored_icon.anm2", true)
--EID:addIcon("Restored Items Icon", "Icon", 0, 10, 9, 1, 1, iconSprite)
--EID:setModIndicatorIcon("Restored Items Icons")
EID:addIcon("ImmortalHeart", "Icon", 0, 10, 9, 1, 1, iconSprite)
EID:addIcon("SunHeart", "Icon", 1, 10, 9, 1, 1, iconSprite)
EID:addIcon("IllusionHeart", "Icon", 2, 10, 9, 1, 1, iconSprite)


local function ActOfContritionConditions(descObj)
    return descObj.ObjType == 5 and descObj.ObjVariant == 100 and descObj.ObjSubType == CollectibleType.COLLECTIBLE_ACT_OF_CONTRITION and RestoredHearts:GetDefaultFileSave("ActOfContritionImmortal")
end

local function ActOfContritionModifierCallback(descObj)
    descObj.Description = descObj.Description:gsub("Eternal", "Immortal")
    descObj.Description = descObj.Description:gsub("вечное", "бессмертное")
    descObj.Description = descObj.Description:gsub("eterno", "inmortales")
    descObj.Description = descObj.Description:gsub("Eterno", "imortais")
    descObj.Description = descObj.Description:gsub("永恒之心", "不朽之心")
    return descObj
end

EID:addDescriptionModifier("Immortal Act of Contrition Modifier", ActOfContritionConditions, ActOfContritionModifierCallback)

local function AncientRevelationConditions(descObj)
    return RestoredCollection and descObj.ObjType == 5 and descObj.ObjVariant == 100 and descObj.ObjSubType == RestoredCollection.Enums.CollectibleType.COLLECTIBLE_ANCIENT_REVELATION
end

local function AncientRevelationModifierCallback(descObj)
    descObj.Description = descObj.Description:gsub("Soul", "Immortal")
    descObj.Description = descObj.Description:gsub("синих", "бессмертных")
    if EID:getLanguage() == "spa" then
        descObj.Description = descObj.Description:gsub("de alma", "inmortales")
    else
        descObj.Description = descObj.Description:gsub("de alma", "imortais")
    end
    descObj.Description = descObj.Description:gsub("魂心", "不朽之心")
    return descObj
end

EID:addDescriptionModifier("Immortal Ancient Revelation Modifier", AncientRevelationConditions, AncientRevelationModifierCallback)