if not Encyclopedia then
	return
end

local Wiki = include("lua.mod_compat.encyclopedia.wiki")

local TransformationItems = {
	Isaac.GetItemIdByName("Spun transform"),
	Isaac.GetItemIdByName("Mom transform"),
	Isaac.GetItemIdByName("Guppy transform"),
	Isaac.GetItemIdByName("Fly transform"),
	Isaac.GetItemIdByName("Bob transform"),
	Isaac.GetItemIdByName("Mushroom transform"),
	Isaac.GetItemIdByName("Baby transform"),
	Isaac.GetItemIdByName("Angel transform"),
	Isaac.GetItemIdByName("Devil transform"),
	Isaac.GetItemIdByName("Poop transform"),
	Isaac.GetItemIdByName("Book transform"),
	Isaac.GetItemIdByName("Spider transform"),
}

for _, item in ipairs(TransformationItems) do
	Encyclopedia.AddItem({
		ModName = "Compliance",
		Class = "Compliance",
		ID = item,
		Hide = true,
	})
end

RestoredHearts.Enums.Wiki = Wiki