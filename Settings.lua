------------------------------------------
-- Equip Recommended Gear: Settings.lua --
------------------------------------------

-- Initialisation
local appName, app = ...
local api = app.api
local L = app.locales

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		if not EquipRecommendedGear_Settings then EquipRecommendedGear_Settings = {} end
		if not EquipRecommendedGear_Settings["debug"] then EquipRecommendedGear_Settings["debug"] = false end
		if not EquipRecommendedGear_CharSettings then EquipRecommendedGear_CharSettings = {} end

		app:CreateLinkCopiedFrame()
		app:CreateSettings()

		EquipRecommendedGear_CharSettings["includeWeapons"] = false

		-- Midnight cleanup
		if EquipRecommendedGear_Settings["ignoreLemixJewelry"] ~= nil then EquipRecommendedGear_Settings["ignoreLemixJewelry"] = nil end
	end
end)

--------------
-- SETTINGS --
--------------

function app:OpenSettings()
	Settings.OpenToCategory(app.Settings:GetID())
end

-- Settings
function app:CreateSettings()
	local category, layout = Settings.RegisterVerticalLayoutCategory(app.Name)
	Settings.RegisterAddOnCategory(category)
	app.Settings = category

	EquipRecommendedGear_SettingsTextMixin = {}
	function EquipRecommendedGear_SettingsTextMixin:Init(initializer)
		local data = initializer:GetData()
		self.LeftText:SetTextToFit(data.leftText)
		self.MiddleText:SetTextToFit(data.middleText)
		self.RightText:SetTextToFit(data.rightText)
	end

	local data = { leftText = L.SETTINGS_VERSION .. " |cffFFFFFF" .. C_AddOns.GetAddOnMetadata(appName, "Version") }
	local text = layout:AddInitializer(Settings.CreateElementInitializer("EquipRecommendedGear_SettingsText", data))
	function text:GetExtent()
		return 14
	end

	local data = { leftText = L.SETTINGS_SUPPORT_TEXTLONG }
	local text = layout:AddInitializer(Settings.CreateElementInitializer("EquipRecommendedGear_SettingsText", data))
	function text:GetExtent()
		return 28 + select(2, string.gsub(data.leftText, "\n", "")) * 12
	end

	StaticPopupDialogs["EQUIPRECOMMENDEDGEAR_URL"] = {
		text = L.SETTINGS_URL_COPY,
		button1 = CLOSE,
		whileDead = true,
		hasEditBox = true,
		editBoxWidth = 240,
		OnShow = function(dialog, data)
			dialog:ClearAllPoints()
			dialog:SetPoint("CENTER", UIParent)

			local editBox = dialog.GetEditBox and dialog:GetEditBox() or dialog.editBox
			editBox:SetText(data)
			editBox:SetAutoFocus(true)
			editBox:HighlightText()
			editBox:SetScript("OnEditFocusLost", function()
				editBox:SetFocus()
			end)
			editBox:SetScript("OnEscapePressed", function()
				dialog:Hide()
			end)
			editBox:SetScript("OnTextChanged", function()
				editBox:SetText(data)
				editBox:HighlightText()
			end)
			editBox:SetScript("OnKeyUp", function(self, key)
				if (IsControlKeyDown() and (key == "C" or key == "X")) then
					dialog:Hide()
					app.LinkCopiedFrame:Show()
					app.LinkCopiedFrame:SetAlpha(1)
					app.LinkCopiedFrame.animation:Play()
				end
			end)
		end,
		OnHide = function(dialog)
			local editBox = dialog.GetEditBox and dialog:GetEditBox() or dialog.editBox
			editBox:SetScript("OnEditFocusLost", nil)
			editBox:SetScript("OnEscapePressed", nil)
			editBox:SetScript("OnTextChanged", nil)
			editBox:SetScript("OnKeyUp", nil)
			editBox:SetText("")
		end,
	}
	local function onSupportButtonClick()
		StaticPopup_Show("EQUIPRECOMMENDEDGEAR_URL", nil, nil, "https://buymeacoffee.com/Slackluster")
	end
	layout:AddInitializer(CreateSettingsButtonInitializer(L.SETTINGS_SUPPORT_TEXT, L.SETTINGS_SUPPORT_BUTTON, onSupportButtonClick, L.SETTINGS_SUPPORT_DESC, true))

	local function onHelpButtonClick()
		StaticPopup_Show("EQUIPRECOMMENDEDGEAR_URL", nil, nil, "https://discord.gg/hGvF59hstx")
	end
	layout:AddInitializer(CreateSettingsButtonInitializer(L.SETTINGS_HELP_TEXT, L.SETTINGS_HELP_BUTTON, onHelpButtonClick, L.SETTINGS_HELP_DESC, true))

	EquipRecommendedGear_SettingsExpandMixin = CreateFromMixins(SettingsExpandableSectionMixin)

	function EquipRecommendedGear_SettingsExpandMixin:Init(initializer)
		SettingsExpandableSectionMixin.Init(self, initializer)
		self.data = initializer.data
	end

	function EquipRecommendedGear_SettingsExpandMixin:OnExpandedChanged(expanded)
		SettingsInbound.RepairDisplay()
	end

	function EquipRecommendedGear_SettingsExpandMixin:CalculateHeight()
		return 24
	end

	function EquipRecommendedGear_SettingsExpandMixin:OnExpandedChanged(expanded)
		self:EvaluateVisibility(expanded)
		SettingsInbound.RepairDisplay()
	end

	function EquipRecommendedGear_SettingsExpandMixin:EvaluateVisibility(expanded)
		if expanded then
			self.Button.Right:SetAtlas("Options_ListExpand_Right_Expanded", TextureKitConstants.UseAtlasSize)
		else
			self.Button.Right:SetAtlas("Options_ListExpand_Right", TextureKitConstants.UseAtlasSize)
		end
	end

	local function createExpandableSection(layout, name)
		local initializer = CreateFromMixins(SettingsExpandableSectionInitializer)
		local data = { name = name, expanded = false }

		initializer:Init("EquipRecommendedGear_SettingsExpandTemplate", data)
		initializer.GetExtent = ScrollBoxFactoryInitializerMixin.GetExtent

		layout:AddInitializer(initializer)

		return initializer, function()
			return initializer.data.expanded
		end
	end

	local expandInitializer, isExpanded = createExpandableSection(layout, app.IconNew .. L.SETTINGS_KEYSLASH_TITLE)

		local action = "ERG_DOTHETHING"
		local bindingIndex = C_KeyBindings.GetBindingIndex(action)
		local initializer = CreateKeybindingEntryInitializer(bindingIndex, true)
		local keybind = layout:AddInitializer(initializer)
		keybind:AddShownPredicate(isExpanded)

		local data = { leftText = "|cffFFFFFF"
			.. "/erg settings" .. "\n\n"
			.. "/erg debug",
		middleText =
			L.SETTINGS_SLASH_SETTINGS .. "\n\n" ..
			L.SETTINGS_SLASH_DEBUG
		}
		local text = layout:AddInitializer(Settings.CreateElementInitializer("EquipRecommendedGear_SettingsText", data))
		function text:GetExtent()
			return 28 + select(2, string.gsub(data.leftText, "\n", "")) * 12
		end
		text:AddShownPredicate(isExpanded)

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L.GENERAL))

	local cbVariable, cbName, cbTooltip = "runAfterQuest", L.RUN_AFTER_QUEST, L.RUN_AFTER_QUEST_DESC
	local cbSetting = Settings.RegisterAddOnSetting(category, appName.."_"..cbVariable, cbVariable, EquipRecommendedGear_Settings, Settings.VarType.Boolean, cbName, true)

	local ddVariable, ddName, ddTooltip = "chatMessage", L.CHAT_MESSAGE, L.CHAT_MESSAGE_DESC
	local function GetOptions()
		local container = Settings.CreateControlTextContainer()
		container:Add(0, L.MESSAGE_NEVER, L.MESSAGE_NEVER_DESC)
		container:Add(1, L.MESSAGE_UPGRADE, L.MESSAGE_UPGRADE_DESC)
		container:Add(2, L.MESSAGE_ALWAYS, L.MESSAGE_ALWAYS_DESC)
		return container:GetData()
	end
	local ddSetting = Settings.RegisterAddOnSetting(category, appName.."_"..ddVariable, ddVariable, EquipRecommendedGear_Settings, Settings.VarType.Number, ddName, 1)

	local initializer = CreateSettingsCheckboxDropdownInitializer(
		cbSetting, cbName, cbTooltip,
		ddSetting, GetOptions, ddName, ddTooltip)
	layout:AddInitializer(initializer)

	local variable, name, tooltip = "includeWeapons", L.SETTINGS_INCLUDEWEAPONS_TITLE, L.SETTINGS_INCLUDEWEAPONS_TOOLTIP
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, EquipRecommendedGear_CharSettings, Settings.VarType.Boolean, name, false)
	local checkbox = Settings.CreateCheckbox(category, setting, tooltip)
	setting:SetValueChangedCallback(function()
		C_Timer.After(0.5, function()
			if EquipRecommendedGear_CharSettings["includeWeapons"] then
				setting:SetValue(false)
				app:Print("This feature is temporarily disabled, until I can fix its bugs.")
			end
		end)
	end)
end

function app:CreateLinkCopiedFrame()
	app.LinkCopiedFrame= CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	app.LinkCopiedFrame:SetPoint("CENTER")
	app.LinkCopiedFrame:SetFrameStrata("TOOLTIP")
	app.LinkCopiedFrame:SetHeight(1)
	app.LinkCopiedFrame:SetWidth(1)
	app.LinkCopiedFrame:Hide()

	local string = app.LinkCopiedFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	string:SetPoint("CENTER", app.LinkCopiedFrame, "CENTER", 0, 0)
	string:SetPoint("TOP", app.LinkCopiedFrame, "TOP", 0, 0)
	string:SetJustifyH("CENTER")
	string:SetText(app.IconReady .. " " .. L.SETTINGS_URL_COPIED)

	app.LinkCopiedFrame.animation = app.LinkCopiedFrame:CreateAnimationGroup()
	local fadeOut = app.LinkCopiedFrame.animation:CreateAnimation("Alpha")
	fadeOut:SetFromAlpha(1)
	fadeOut:SetToAlpha(0)
	fadeOut:SetDuration(1)
	fadeOut:SetStartDelay(1)
	fadeOut:SetSmoothing("IN_OUT")
	app.LinkCopiedFrame.animation:SetToFinalAlpha(true)
	app.LinkCopiedFrame.animation:SetScript("OnFinished", function()
		app.LinkCopiedFrame:Hide()
	end)
end
