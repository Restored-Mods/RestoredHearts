RestoredHearts:AddModCompat("Encyclopedia", function()
	local Wiki = {
		ActOfContrition = {
			{ -- Effects
				{ str = "Effects", fsize = 2, clr = 3, halign = 0 },
				{ str = "+0.7 tears up." },
				{ str = "Grants an Immortal Heart." },
				{ str = "Allows Isaac to take a Deal with the Devil without being locked out of Angel rooms." },
				{ str = "Increases the chance for a deal to appear by 55% if Isaac has taken Red heart damage." },
				{ str = "- Additional 20% is added if no Red Heart was taken against the boss." },
				{ str = "- Both bonuses are applied after the normal penalty." },
			},
		},
	}

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
		if item > 0 then
			Encyclopedia.AddItem({
				ModName = "Compliance",
				Class = "Compliance",
				ID = item,
				Hide = true,
			})
		end
	end
	RestoredHearts.Enums.Wiki = Wiki
end)
