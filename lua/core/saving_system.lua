function RestoredHearts:GameSave()
	return RestoredHearts.SaveManager.GetPersistentSave()
end

function RestoredHearts:RunSave(ent, noHourglass, allowSoulSave)
    return RestoredHearts.SaveManager.GetRunSave(ent, noHourglass, allowSoulSave)
end

function RestoredHearts:FloorSave(ent, noHourglass, allowSoulSave)
    return RestoredHearts.SaveManager.GetFloorSave(ent, noHourglass, allowSoulSave)
end

function RestoredHearts:RoomSave(ent, noHourglass, gridIndex, allowSoulSave)
    return RestoredHearts.SaveManager.GetRoomSave(ent, noHourglass, gridIndex, allowSoulSave)
end

function RestoredHearts:AddDefaultFileSave(key, value)
    RestoredHearts.SaveManager.DEFAULT_SAVE.file.other[key] = value
end

function RestoredHearts:GetDefaultFileSave(key)
    if RestoredHearts.SaveManager.Utility.IsDataInitialized() then
        return RestoredHearts.SaveManager.DEFAULT_SAVE.file.other[key]
    end
end