local Helpers = {}

local function RemoveStoreCreditFromPlayer(player) -- Partially from FF
	local t0 = player:GetTrinket(0)
	local t1 = player:GetTrinket(1)
	
	if t0 & TrinketType.TRINKET_ID_MASK == TrinketType.TRINKET_STORE_CREDIT then
		player:TryRemoveTrinket(TrinketType.TRINKET_STORE_CREDIT)
		return
	elseif t1 & TrinketType.TRINKET_ID_MASK == TrinketType.TRINKET_STORE_CREDIT then
		player:TryRemoveTrinket(TrinketType.TRINKET_STORE_CREDIT)
		return
	end
	if REPENTOGON then
		player:TryRemoveSmeltedTrinket(TrinketType.TRINKET_STORE_CREDIT)
	else
		local numStoreCredits = player:GetTrinketMultiplier(TrinketType.TRINKET_STORE_CREDIT)
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
			numStoreCredits = numStoreCredits - 1
		end
		
		if numStoreCredits >= 2 then
			player:TryRemoveTrinket(TrinketType.TRINKET_STORE_CREDIT + TrinketType.TRINKET_GOLDEN_FLAG)
		else
			player:TryRemoveTrinket(TrinketType.TRINKET_STORE_CREDIT)
		end
	end
end

local function TryRemoveStoreCredit(player)
	if Game():GetRoom():GetType() == RoomType.ROOM_SHOP then
		if player:HasTrinket(TrinketType.TRINKET_STORE_CREDIT) then
			RemoveStoreCreditFromPlayer(player)
		else
			for _,player in ipairs(Helpers.Filter(Helpers.GetPlayers(), function(_, player) return player:HasTrinket(TrinketType.TRINKET_STORE_CREDIT) end)) do
				RemoveStoreCreditFromPlayer(player)
				return
			end
		end
	end
end

function Helpers.IsLost(player)
    if REPENTOGON then
		return player:GetHealthType() == HealthType.NO_HEALTH and player:GetPlayerType() ~= PlayerType.PLAYER_THESOUL_B
	end
	for _,pType in ipairs({PlayerType.PLAYER_THELOST, PlayerType.PLAYER_THELOST_B}) do
		if Helpers.IsPlayerType(player, pType) then
			return true
		end
	end
	return false
end

function Helpers.IsGhost(player)
    return player:GetEffects():HasNullEffect(NullItemID.ID_LOST_CURSE) or player:GetPlayerType() == PlayerType.PLAYER_JACOB2_B or Helpers.IsLost(player)
end

function Helpers.CanCollectCustomShopPickup(player, pickup)
	if pickup:IsShopItem() and (pickup.Price > 0 and player:GetNumCoins() < pickup.Price or not player:IsExtraAnimationFinished())
	or pickup.Wait > 0 then
		return false
	end
	return true
end

function Helpers.CollectCustomPickup(player,pickup)
	if not Helpers.CanCollectCustomShopPickup(player, pickup) then
		return pickup:IsShopItem()
	end
	if not pickup:IsShopItem() then
		pickup:GetSprite():Play("Collect")
		pickup:Die()
	else
		if pickup.Price >= 0 or pickup.Price == PickupPrice.PRICE_FREE or pickup.Price == PickupPrice.PRICE_SPIKES then
			if pickup.Price == PickupPrice.PRICE_SPIKES and not Helpers.IsGhost(player) then
				local tookDamage = player:TakeDamage(2.0, 268435584, EntityRef(nil), 30)
				if not tookDamage then
					return pickup:IsShopItem()
				end
			end
			if pickup.Price >= 0 then
				player:AddCoins(-pickup.Price)
			end
			CustomHealthAPI.Library.TriggerRestock(pickup)
			TryRemoveStoreCredit(player)
			pickup:Remove()
			player:AnimatePickup(pickup:GetSprite(), true)
		end
	end
	if pickup.OptionsPickupIndex ~= 0 then
		local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
		for _, entity in ipairs(pickups) do
			if entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and
			(entity.Index ~= pickup.Index or entity.InitSeed ~= pickup.InitSeed)
			then
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, nil)
				entity:Remove()
			end
		end
	end
	return nil
end

function Helpers.IsPlayerType(player, type)
	return player:GetPlayerType() == type
end

---@param player EntityPlayer
function Helpers.AddCharge(player, amount, slot, force)
	slot = slot or ActiveSlot.SLOT_PRIMARY
	force = force or false
	if REPENTOGON then
		player:AddActiveCharge(amount, slot, true, false, force)
	else
		local charges = Helpers.GetCharge(player, slot)
		local itemConfig = Isaac.GetItemConfig():GetCollectible(player:GetActiveItem(slot))
		player:SetActiveCharge(math.min(charges + amount, itemConfig.MaxCharges * Helpers.BatteryChargeMult(player)), slot)
		Game():GetHUD():FlashChargeBar(player, slot)
	end
end
--self explanatory
function Helpers.GetCharge(player,slot)
	return player:GetActiveCharge(slot) + player:GetBatteryCharge(slot)
end

function Helpers.BatteryChargeMult(player)
	return player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY) and 2 or 1
end

function Helpers.GetUnchargedSlot(player,slot)
	local charge = Helpers.GetCharge(player, slot)
	local battery = Helpers.BatteryChargeMult(player)
	local item = Isaac.GetItemConfig():GetCollectible(player:GetActiveItem(slot))
	if player:GetActiveItem(slot) == CollectibleType.COLLECTIBLE_ALABASTER_BOX then
		if charge < item.MaxCharges then
			return slot
		end
	elseif player:GetActiveItem(slot) > 0 and charge < item.MaxCharges * battery and player:GetActiveItem(slot) ~= CollectibleType.COLLECTIBLE_ERASER then
		return slot
	elseif slot < ActiveSlot.SLOT_POCKET then
		slot = Helpers.GetUnchargedSlot(player,slot + 1)
		return slot
	end
	return nil
end

-----------------------------------
--Helper Functions (thanks piber)--
-----------------------------------

---@param ignoreCoopBabies? boolean 
---@return EntityPlayer[]
function Helpers.GetPlayers(ignoreCoopBabies)
	local players
	if REPENTOGON then
		players = PlayerManager.GetPlayers()
	else
		players = {}
		for _,player in ipairs(Isaac.FindByType(EntityType.ENTITY_PLAYER)) do
			table.insert(players, player:ToPlayer())
		end
	end
	
	return Helpers.Filter(players, function(_, player)
		return player.Variant == 0 or ignoreCoopBabies == false
	end)
end


---@param entity Entity
---@return table | nil?
function Helpers.GetData(entity)
	if entity and entity.GetData then
		local data = entity:GetData()
		if not data.RestoredHearts then
			data.RestoredHearts = {}
		end
		return data.RestoredHearts
	end
	return nil
end

--filters a table given a predicate
function Helpers.Filter(toFilter, predicate)
	local filtered = {}

	for index, value in pairs(toFilter) do
		if predicate(index, value) then
			filtered[#filtered+1] = value
		end
	end

	return filtered
end

RestoredHearts.Helpers = Helpers

return Helpers