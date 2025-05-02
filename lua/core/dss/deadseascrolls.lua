local DSSModName = "Restored Hearts"

local DSSCoreVersion = 7

local InGame = false

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

local function ChangeUIHeartsAnim(var)
    local animfile = "gfx/ui/ui_remix_hearts"..HeartGfxSuffix(var, true)
                    
    for _, heart in pairs({"HEART_IMMORTAL", "HEART_SUN"}) do
        if CustomHealthAPI.PersistentData.HealthDefinitions[heart] then
            CustomHealthAPI.PersistentData.HealthDefinitions[heart].AnimationFilename = animfile..".anm2"
        end
    end
end

local modMenuName = "Restored Hearts"
-- Those functions were taken from Balance Mod, just to make things easier 
	local BREAK_LINE = {str = "", fsize = 1, nosel = true}

	local function GenerateTooltip(str)
		local endTable = {}
		local currentString = ""
		for w in str:gmatch("%S+") do
			local newString = currentString .. w .. " "
			if newString:len() >= 15 then
				table.insert(endTable, currentString)
				currentString = ""
			end

			currentString = currentString .. w .. " "
		end

		table.insert(endTable, currentString)
		return {strset = endTable}
	end
-- Thanks to catinsurance for those functions

local ogwikidesc = Encyclopedia and Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_ACT_OF_CONTRITION).WikiDesc or nil

local function FitEncyclopediaDesc(desc)
    local WikiDesc = desc
    local newDesc = {}
    for i, tab in ipairs(WikiDesc) do
        newDesc[i] = {}
    
        for j, new_str in ipairs(tab) do
            local text = new_str
            
            for _, subtext in ipairs(Encyclopedia.fitTextToWidth(text.str, text.fsize or 1, 140)) do
                local newtext = {str = subtext, fsize = text.fsize, clr = text.clr, halign = text.halign}
                table.insert(newDesc[i], newtext)
            end
            
            if j == #tab then
                table.insert(newDesc[i], {str = "", fsize = 3})
            elseif tab[j + 1] and tab[j + 1].str ~= "" and text.str ~= "" then
                table.insert(newDesc[i], {str = ""})
            end
        end
    end
    return newDesc
end

local function UpdateActOfContritionEncyclopedia(change)
    if Encyclopedia then
        local wikidesc = ogwikidesc
        if change then
            wikidesc = FitEncyclopediaDesc(RestoredHearts.Enums.Wiki.ActOfContrition)
        end
        Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_ACT_OF_CONTRITION).WikiDesc = wikidesc
    end
end

-- Every MenuProvider function below must have its own implementation in your mod, in order to handle menu save data.
local MenuProvider = {}

function MenuProvider.SaveSaveData()
    RestoredHearts.SaveManager.Save()
end

function MenuProvider.GetPaletteSetting()
    local dssSave = RestoredHearts.SaveManager.GetDeadSeaScrollsSave()
    return dssSave and dssSave.MenuPalette or nil
end

function MenuProvider.SavePaletteSetting(var)
    local dssSave = RestoredHearts.SaveManager.GetDeadSeaScrollsSave()
    dssSave.MenuPalette = var
end

function MenuProvider.GetGamepadToggleSetting()
    local dssSave = RestoredHearts.SaveManager.GetDeadSeaScrollsSave()
    return dssSave and dssSave.GamepadToggle or nil
end

function MenuProvider.SaveGamepadToggleSetting(var)
    local dssSave = RestoredHearts.SaveManager.GetDeadSeaScrollsSave()
    dssSave.GamepadToggle = var
end

function MenuProvider.GetMenuKeybindSetting()
    local dssSave = RestoredHearts.SaveManager.GetDeadSeaScrollsSave()
    return dssSave and dssSave.MenuKeybind or nil
end

function MenuProvider.SaveMenuKeybindSetting(var)
    local dssSave = RestoredHearts.SaveManager.GetDeadSeaScrollsSave()
    dssSave.MenuKeybind = var
end

function MenuProvider.GetMenuHintSetting()
    local dssSave = RestoredHearts.SaveManager.GetDeadSeaScrollsSave()
    return dssSave and dssSave.MenuHint or nil
end

function MenuProvider.SaveMenuHintSetting(var)
    local dssSave = RestoredHearts.SaveManager.GetDeadSeaScrollsSave()
    dssSave.MenuHint = var
end

function MenuProvider.GetMenuBuzzerSetting()
    local dssSave = RestoredHearts.SaveManager.GetDeadSeaScrollsSave()
    return dssSave and dssSave.MenuBuzzer or nil
end

function MenuProvider.SaveMenuBuzzerSetting(var)
    local dssSave = RestoredHearts.SaveManager.GetDeadSeaScrollsSave()
    dssSave.MenuBuzzer = var
end

function MenuProvider.GetMenusNotified()
    local dssSave = RestoredHearts.SaveManager.GetDeadSeaScrollsSave()
    return dssSave and dssSave.MenusNotified or nil
end

function MenuProvider.SaveMenusNotified(var)
    local dssSave = RestoredHearts.SaveManager.GetDeadSeaScrollsSave()
    dssSave.MenusNotified = var
end

function MenuProvider.GetMenusPoppedUp()
    local dssSave = RestoredHearts.SaveManager.GetDeadSeaScrollsSave()
    return dssSave and dssSave.MenusPoppedUp or nil
end

function MenuProvider.SaveMenusPoppedUp(var)
    local dssSave = RestoredHearts.SaveManager.GetDeadSeaScrollsSave()
   dssSave.MenusPoppedUp = var
end

local DSSInitializerFunction = include("lua.core.dss.dssmenucore")

-- This function returns a table that some useful functions and defaults are stored on
local dssmod = DSSInitializerFunction(DSSModName, DSSCoreVersion, MenuProvider)

local function UpdateImGuiMenu(IsDataInitialized)
	if IsDataInitialized then

        if ImGui.ElementExists("restotredHeartSettingsNoWay") then
			ImGui.RemoveElement("restotredHeartSettingsNoWay")
		end

		if not ImGui.ElementExists("RestoredHeartsSettingsHeartsStyle") then
            ImGui.AddCombobox("RestoredHeartsSettingsWindow", "RestoredHeartsSettingsHeartsStyle", "Hearts sprites", function(index, val)
                local var = index + 1
                RestoredHearts:AddDefaultFileSave("HeartStyleRender", var)
                ChangeUIHeartsAnim(var)
            end, {
                "Vanilla",
                "Aladar",
                "Lifebar",
                "Beautiful",
                "Flashy", 
                "Better icons", 
                "Eternal update",
                "Re-color",
                "Sussy",
            },
            0)
        
            ImGui.SetTooltip("RestoredHeartsSettingsHeartsStyle", "Change appearance of hearts")
        end

    
        if not ImGui.ElementExists("RestoredHeartsSettingsActGivesImmortalHearts") then
            ImGui.AddCheckbox("RestoredHeartsSettingsWindow", "RestoredHeartsSettingsActGivesImmortalHearts", "Act of Contrition gives Immortal Heart", function(val)
                UpdateActOfContritionEncyclopedia(val)
                RestoredHearts:AddDefaultFileSave("ActOfContritionImmortal", val)
            end, true)
        
            ImGui.SetTooltip("RestoredHeartsSettingsActGivesImmortalHearts", "Replaces Act of Contrition's eternal heart with\nan Immortal Heart like in Antibirth")
        end
    
    
        for _, str in ipairs({"Immortal", "Sun", "Illusion"}) do
            if ImGui.ElementExists("RestoredHeartsSettings"..str.."Heart") then
                ImGui.AddDragInteger("RestoredHeartsSettingsWindow", "RestoredHeartsSettings"..str.."Heart", str.." Heart", function(val)
                    RestoredHearts:AddDefaultFileSave(str.."HeartSpawnChance", val)
                end, 20, 1, 0, 100)
                ImGui.SetTooltip("RestoredHeartsSettings"..str.."Heart", str.." Heart spawn chance")
            end
        end
    
        if not ImGui.ElementExists("RestoredHeartsSettingsIllusionPlaceBombs") then
            ImGui.AddCheckbox("RestoredHeartsSettingsWindow", "RestoredHeartsSettingsIllusionPlaceBombs", "Can illusions place bombs?", function(val)
                IllusionMod.CanPlaceBomb = val
            end, false)
        end
    
        
    
        if not ImGui.ElementExists("RestoredHeartsSettingsIllusionPerfect") then
            ImGui.AddCheckbox("RestoredHeartsSettingsWindow", "RestoredHeartsSettingsIllusionPerfect", "Create perfect Illusion for modded characters?", function(val)
                IllusionMod.PerfectIllusion = val
            end, false)
        end
    
        ImGui.AddCallback("RestoredHeartsSettingsWindow", ImGuiCallback.Render, function()
            ImGui.UpdateData("RestoredHeartsSettingsHeartsStyle", ImGuiData.Value, RestoredHearts:GetDefaultFileSave("HeartStyleRender") - 1)
            ImGui.UpdateData("RestoredHeartsSettingsActGivesImmortalHearts", ImGuiData.Value, RestoredHearts:GetDefaultFileSave("ActOfContritionImmortal"))
            for _, str in ipairs({"Immortal", "Sun", "Illusion"}) do
                ImGui.UpdateData("RestoredHeartsSettings"..str.."Heart", ImGuiData.Value, RestoredHearts:GetDefaultFileSave(str.."HeartSpawnChance"))
            end
            ImGui.UpdateData("RestoredHeartsSettingsIllusionPlaceBombs", ImGuiData.Value, IllusionMod.CanPlaceBomb)
            ImGui.UpdateData("RestoredHeartsSettingsIllusionPerfect", ImGuiData.Value, IllusionMod.PerfectIllusion)
        end)
	else

		ImGui.RemoveCallback("RestoredHeartsSettingsWindow", ImGuiCallback.Render)

		if ImGui.ElementExists("RestoredHeartsSettingsHeartsStyle") then
			ImGui.RemoveElement("RestoredHeartsSettingsHeartsStyle")
		end

        if ImGui.ElementExists("RestoredHeartsSettingsActGivesImmortalHearts") then
			ImGui.RemoveElement("RestoredHeartsSettingsActGivesImmortalHearts")
		end

        for _, str in ipairs({"Immortal", "Sun", "Illusion"}) do
            if ImGui.ElementExists("RestoredHeartsSettings"..str.."Heart") then
                ImGui.RemoveElement("RestoredHeartsSettings"..str.."Heart")
            end
        end

        if ImGui.ElementExists("RestoredHeartsSettingsIllusionPlaceBombs") then
			ImGui.RemoveElement("RestoredHeartsSettingsIllusionPlaceBombs")
		end

        if ImGui.ElementExists("RestoredHeartsSettingsIllusionPerfect") then
			ImGui.RemoveElement("RestoredHeartsSettingsIllusionPerfect")
		end

        if not ImGui.ElementExists("restotredHeartSettingsNoWay") then
			ImGui.AddText("RestoredHeartsSettingsWindow", "Options will be available after loading the game.", true, "restotredHeartSettingsNoWay")
		end

	end
end

local function InitImGuiMenu()
    if not ImGui.ElementExists("RestoredMods") then
        ImGui.CreateMenu("RestoredMods", "Restored Mods")
    end

    if not ImGui.ElementExists("RestoredHeartsMenu") then   
        ImGui.AddElement("RestoredMods", "RestoredHeartsMenu", ImGuiElement.Menu, "Restored Hearts")
    end
   
    if not ImGui.ElementExists("RestoredHeartsSettingsWindow") then
        ImGui.CreateWindow("RestoredHeartsSettingsWindow", "Restored Hearts settings")
    end

    if not ImGui.ElementExists("RestoredHeartsSettings") then
        ImGui.AddElement("RestoredHeartsMenu", "RestoredHeartsSettings", ImGuiElement.MenuItem, "\u{f013} Settings")
    end

    ImGui.LinkWindowToElement("RestoredHeartsSettingsWindow", "RestoredHeartsSettings")

    ImGui.SetWindowSize("RestoredHeartsSettingsWindow", 600, 420)
    
end




-- Creating a menu like any other DSS menu is a simple process.
-- You need a "Directory", which defines all of the pages ("items") that can be accessed on your menu, and a "DirectoryKey", which defines the state of the menu.
local restoredheartssdirectory = {
    -- The keys in this table are used to determine button destinations.
    main = {
        -- "title" is the big line of text that shows up at the top of the page!
        title = 'restored hearts',

        -- "buttons" is a list of objects that will be displayed on this page. The meat of the menu!
        buttons = {
            -- The simplest button has just a "str" tag, which just displays a line of text.
            
            -- The "action" tag can do one of three pre-defined actions:
            --- "resume" closes the menu, like the resume game button on the pause menu. Generally a good idea to have a button for this on your main page!
            --- "back" backs out to the previous menu item, as if you had sent the menu back input
            --- "openmenu" opens a different dss menu, using the "menu" tag of the button as the name
            {str = 'resume game', action = 'resume'},

            -- The "dest" option, if specified, means that pressing the button will send you to that page of your menu.
            -- If using the "openmenu" action, "dest" will pick which item of that menu you are sent to.
            {str = 'settings', dest = 'settings'},
            -- A few default buttons are provided in the table returned from DSSInitializerFunction.
            -- They're buttons that handle generic menu features, like changelogs, palette, and the menu opening keybind
            -- They'll only be visible in your menu if your menu is the only mod menu active; otherwise, they'll show up in the outermost Dead Sea Scrolls menu that lets you pick which mod menu to open.
            -- This one leads to the changelogs menu, which contains changelogs defined by all mods.
            dssmod.changelogsButton,

        },

        -- A tooltip can be set either on an item or a button, and will display in the corner of the menu while a button is selected or the item is visible with no tooltip selected from a button.
        -- The object returned from DSSInitializerFunction contains a default tooltip that describes how to open the menu, at "menuOpenToolTip"
        -- It's generally a good idea to use that one as a default!
        tooltip = dssmod.menuOpenToolTip
    },
    heartsoptions = {
        title = 'hearts options',
        buttons = {
           
        },
    },
    settings = {
        title = 'settings',
        buttons = {
            {str = '', nosel = true},
            {str = 'hearts options', nosel = true, fzise = 2},
            {
                str = 'hearts sprites',

                -- The "choices" tag on a button allows you to create a multiple-choice setting
                
                choices = {
                    "vanilla",
                    "aladar",
                    "lifebar",
                    "beautiful",
                    "flashy", 
                    "better icons", 
                    "eternal update",
                    "re-color",
                    "sussy",
                },
                -- The "setting" tag determines the default setting, by list index. EG "1" here will result in the default setting being "choice a"
                setting = 1,

                -- "variable" is used as a key to story your setting; just set it to something unique for each setting!
                variable = 'HeartStyleRender',
                
                -- When the menu is opened, "load" will be called on all settings-buttons
                -- The "load" function for a button should return what its current setting should be
                -- This generally means looking at your mod's save data, and returning whatever setting you have stored
                load = function()
                    return RestoredHearts:GetDefaultFileSave("HeartStyleRender") or 1
                end,

                -- When the menu is closed, "store" will be called on all settings-buttons
                -- The "store" function for a button should save the button's setting (passed in as the first argument) to save data!
                store = function(var)
                    RestoredHearts:AddDefaultFileSave("HeartStyleRender", var)
                    ChangeUIHeartsAnim(var)
                end,

                -- A simple way to define tooltips is using the "strset" tag, where each string in the table is another line of the tooltip
                tooltip = {strset = {'change', 'appearance', 'of hearts'}}
            },
            {str = '', nosel = true},
            {
                strset = {'act of contrition', 'gives immortal heart'},
                fsize = 2,
                -- The "choices" tag on a button allows you to create a multiple-choice setting
                
                choices = {
                    "on",
                    "off",
                },
                -- The "setting" tag determines the default setting, by list index. EG "1" here will result in the default setting being "choice a"
                setting = 1,

                -- "variable" is used as a key to story your setting; just set it to something unique for each setting!
                variable = 'ActOfContritionGivesImmortalHearts',
                
                -- When the menu is opened, "load" will be called on all settings-buttons
                -- The "load" function for a button should return what its current setting should be
                -- This generally means looking at your mod's save data, and returning whatever setting you have stored
                load = function()
                    return RestoredHearts:GetDefaultFileSave("ActOfContritionImmortal") and 1 or 2
                end,

                -- When the menu is closed, "store" will be called on all settings-buttons
                -- The "store" function for a button should save the button's setting (passed in as the first argument) to save data!
                store = function(var)
                    RestoredHearts:AddDefaultFileSave("ActOfContritionImmortal", var == 1)
                    UpdateActOfContritionEncyclopedia(var == 1)
                end,

                -- A simple way to define tooltips is using the "strset" tag, where each string in the table is another line of the tooltip
                tooltip = {strset = {"replaces act", "of contrition's", "eternal heart", "with an", "immortal", "heart", "like in", "antibirth"}}
            },
            {str = '', nosel = true},
            {
                strset = {'immortal hearts','spawn chance'},
                fsize = 2,

                -- If "min" and "max" are set without "slider", you've got yourself a number option!
                -- It will allow you to scroll through the entire range of numbers from "min" to "max", incrementing by "increment"
                min = 0,
                max = 100,
                increment = 1,

                -- You can also specify a prefix or suffix that will be applied to the number, which is especially useful for percentages!
                --pref = 'hi! ',
                suf = '%',

                setting = 20,

                variable = "ImmortalHeartSpawnChance",

                load = function()
                    return RestoredHearts:GetDefaultFileSave("ImmortalHeartSpawnChance") or 20
                end,
                store = function(newOption)
                    RestoredHearts:AddDefaultFileSave("ImmortalHeartSpawnChance", newOption)
                end,

                tooltip = {strset = {'how often', 'immortal hearts', 'can spawn?'}},
            },
            {str = '', nosel = true},
            {
                strset = {'sun hearts','spawn chance'},
                fsize = 2,

                -- If "min" and "max" are set without "slider", you've got yourself a number option!
                -- It will allow you to scroll through the entire range of numbers from "min" to "max", incrementing by "increment"
                min = 0,
                max = 100,
                increment = 1,

                -- You can also specify a prefix or suffix that will be applied to the number, which is especially useful for percentages!
                --pref = 'hi! ',
                suf = '%',

                setting = 20,

                variable = "SunHeartSpawnChance",

                load = function()
                    return RestoredHearts:GetDefaultFileSave("SunHeartSpawnChance") or 20
                end,
                store = function(newOption)
                    RestoredHearts:AddDefaultFileSave("SunHeartSpawnChance", newOption)
                end,

                tooltip = {strset = {'how often', 'sun hearts', 'can spawn?'}},
            },
            {str = '', nosel = true},
            {
                strset = {'illusion hearts','spawn chance'},
                fsize = 2,

                -- If "min" and "max" are set without "slider", you've got yourself a number option!
                -- It will allow you to scroll through the entire range of numbers from "min" to "max", incrementing by "increment"
                min = 0,
                max = 100,
                increment = 1,

                -- You can also specify a prefix or suffix that will be applied to the number, which is especially useful for percentages!
                --pref = 'hi! ',
                suf = '%',

                setting = 20,

                variable = "IllusionHeartSpawnChance",

                load = function()
                    return RestoredHearts:GetDefaultFileSave("ImmortalHeartSpawnChance") or 20
                end,
                store = function(newOption)
                    RestoredHearts:AddDefaultFileSave("IllusionHeartSpawnChance", newOption)
                end,

                tooltip = {strset = {'how often', 'illusion hearts', 'can spawn?'}},
            },
            {str = '', nosel = true},
            {
                strset = {'illusions can', 'place bombs'},
                fsize = 2,
                choices = {'no', 'yes'},
                setting = 1,
                variable = 'IllusionClonesPlaceBombs',

                load = function ()
                    return IllusionMod.CanPlaceBomb and 2 or 1
                end,

                store = function(newOption)
                    IllusionMod.CanPlaceBomb = newOption == 2
                end,

                tooltip = {strset = {'can illusions', 'place bombs?'}}
            },
            {str = '', nosel = true},
            {
                str = 'perfect illusion',
                fsize = 2,
                choices = {'no', 'yes'},
                setting = 1,
                variable = 'PerfectIllusion',

                load = function ()
                    return IllusionMod.PerfectIllusion and 2 or 1
                end,

                store = function(newOption)
                    IllusionMod.PerfectIllusion = newOption == 2
                end,

                tooltip = {strset = {'create perfect', 'illusions for', 'modded', 'characters?'}}
            },
            {str = '', nosel = true},
            {
                -- Creating gaps in your page can be done simply by inserting a blank button.
                -- The "nosel" tag will make it impossible to select, so it'll be skipped over when traversing the menu, while still rendering!
                str = '',
                fsize = 2,
                nosel = true
            },
            dssmod.gamepadToggleButton,
            dssmod.menuKeybindButton,
            dssmod.paletteButton,
            dssmod.menuHintButton,
            dssmod.menuBuzzerButton,
        }
    },
}

local restoredheartssdirectorykey = {
    Item = restoredheartssdirectory.main, -- This is the initial item of the menu, generally you want to set it to your main item
    Main = 'main', -- The main item of the menu is the item that gets opened first when opening your mod's menu.

    -- These are default state variables for the menu; they're important to have in here, but you don't need to change them at all.
    Idle = false,
    MaskAlpha = 1,
    Settings = {},
    SettingsChanged = false,
    Path = {},
}

--#region AgentCucco pause manager for DSS

local function DeleteParticles()
    for _, ember in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.FALLING_EMBER, -1)) do
        if ember:Exists() then
            ember:Remove()
        end
    end
    if REPENTANCE then
        for _, rain in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.RAIN_DROP, -1)) do
            if rain:Exists() then
                rain:Remove()
            end
        end
    end
end

local OldTimer
local OldTimerBossRush
local OldTimerHush
local OverwrittenPause = false
local AddedPauseCallback = false
local function OverridePause(self, player, hook, action)
	if not AddedPauseCallback then return nil end

	if OverwrittenPause then
		OverwrittenPause = false
		AddedPauseCallback = false
		return
	end

	if action == ButtonAction.ACTION_SHOOTRIGHT then
		OverwrittenPause = true
		DeleteParticles()
		return true
	end
end
RestoredHearts:AddCallback(ModCallbacks.MC_INPUT_ACTION, OverridePause, InputHook.IS_ACTION_PRESSED)

local function FreezeGame(unfreeze)
	if unfreeze then
		OldTimer = nil
        OldTimerBossRush = nil
        OldTimerHush = nil
        if not AddedPauseCallback then
			AddedPauseCallback = true
		end
	else
		if not OldTimer then
			OldTimer = Game().TimeCounter
		end
        if not OldTimerBossRush then
            OldTimerBossRush = Game().BossRushParTime
		end
        if not OldTimerHush then
			OldTimerHush = Game().BlueWombParTime
		end
		
        Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_PAUSE, UseFlag.USE_NOANIM)
		
		Game().TimeCounter = OldTimer
		Game().BossRushParTime = OldTimerBossRush
		Game().BlueWombParTime = OldTimerHush
        DeleteParticles()
	end
end

local function RunRestoredHeartsDSSMenu(tbl)
    FreezeGame()
    dssmod.runMenu(tbl)
end

local function CloseRestoredHeartsDSSMenu(tbl, fullClose, noAnimate)
    FreezeGame(true)
    dssmod.closeMenu(tbl, fullClose, noAnimate)
end
--#endregion

DeadSeaScrollsMenu.AddMenu(modMenuName, {
    -- The Run, Close, and Open functions define the core loop of your menu
    -- Once your menu is opened, all the work is shifted off to your mod running these functions, so each mod can have its own independently functioning menu.
    -- The DSSInitializerFunction returns a table with defaults defined for each function, as "runMenu", "openMenu", and "closeMenu"
    -- Using these defaults will get you the same menu you see in Bertran and most other mods that use DSS
    -- But, if you did want a completely custom menu, this would be the way to do it!
    
    -- This function runs every render frame while your menu is open, it handles everything! Drawing, inputs, etc.
    Run = RunRestoredHeartsDSSMenu,
    -- This function runs when the menu is opened, and generally initializes the menu.
    Open = dssmod.openMenu,
    -- This function runs when the menu is closed, and generally handles storing of save data / general shut down.
    Close = CloseRestoredHeartsDSSMenu,

    Directory = restoredheartssdirectory,
    DirectoryKey = restoredheartssdirectorykey
})

if REPENTOGON then
    InitImGuiMenu()
    UpdateImGuiMenu(false)
    local function UpdateImGuiOnRender()
		if not Isaac.IsInGame() and InGame then
			UpdateImGuiMenu(false)
			InGame = false
		elseif Isaac.IsInGame() and not InGame then
			UpdateImGuiMenu(true)
			InGame = true
		end
	end
	RestoredHearts:AddPriorityCallback(ModCallbacks.MC_POST_RENDER, CallbackPriority.LATE, UpdateImGuiOnRender)
	RestoredHearts:AddPriorityCallback(ModCallbacks.MC_MAIN_MENU_RENDER, CallbackPriority.LATE, UpdateImGuiOnRender)
end

RestoredHearts:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.LATE + 10, function()
    UpdateActOfContritionEncyclopedia(RestoredHearts:GetDefaultFileSave("ActOfContritionImmortal"))
    ChangeUIHeartsAnim(RestoredHearts:GetDefaultFileSave("HeartStyleRender"))
end)

include("lua.core.dss.changelog")
-- There are a lot more features that DSS supports not covered here, like sprite insertion and scroller menus, that you'll have to look at other mods for reference to use.
-- But, this should be everything you need to create a simple menu for configuration or other simple use cases!