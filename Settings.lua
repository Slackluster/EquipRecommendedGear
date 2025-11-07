------------------------------------------
-- Equip Recommended Gear: Settings.lua --
------------------------------------------

-- Initialisation
local appName, app = ...
local L = app.locales

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		if not EquipRecommendedGear_Settings then EquipRecommendedGear_Settings = {} end
		if not EquipRecommendedGear_Settings["debug"] then EquipRecommendedGear_Settings["debug"] = false end
		if not EquipRecommendedGear_CharSettings then EquipRecommendedGear_CharSettings = {} end

		app.CreateLinkCopiedFrame()
		app.Settings()
	end
end)

--------------
-- SETTINGS --
--------------

-- Settings
function app.Settings()
	local category, layout = Settings.RegisterVerticalLayoutCategory(app.Name)
	Settings.RegisterAddOnCategory(category)
	app.Category = category

	EquipRecommendedGear_SettingsTextMixin = {}
	function EquipRecommendedGear_SettingsTextMixin:Init(initializer)
		local data = initializer:GetData()
		self.Text:SetTextToFit(data.text)
	end

	local data = {text = L.SETTINGS_SUPPORT_TEXTLONG}
	local text = layout:AddInitializer(Settings.CreateElementInitializer("EquipRecommendedGear_SettingsText", data))
	function text:GetExtent()
		return 28 + select(2, string.gsub(data.text, "\n", "")) * 12
	end

	local function onSupportButtonClick()
		StaticPopupDialogs["EQUIPRECOMMENDEDGEAR_SUPPORT"] = {
			text = L.SETTINGS_SUPPORT_COPY,
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
		}
		StaticPopup_Show("EQUIPRECOMMENDEDGEAR_SUPPORT", nil, nil, "https://buymeacoffee.com/slackluster")
	end
	layout:AddInitializer(CreateSettingsButtonInitializer(L.SETTINGS_SUPPORT_TEXT, L.SETTINGS_SUPPORT_BUTTON, onSupportButtonClick, L.SETTINGS_SUPPORT_DESC, true))

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(C_AddOns.GetAddOnMetadata(appName, "Version")))

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

	local variable, name, tooltip = "ignoreLemixJewelry", L.SETTINGS_IGNORELEMIXJEWELRY_TITLE, L.SETTINGS_IGNORELEMIXJEWELRY_TOOLTIP
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, EquipRecommendedGear_Settings, Settings.VarType.Boolean, name, true)
	local checkbox = Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "includeWeapons", L.SETTINGS_INCLUDEWEAPONS_TITLE, L.SETTINGS_INCLUDEWEAPONS_TOOLTIP
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, EquipRecommendedGear_CharSettings, Settings.VarType.Boolean, name, true)
	local checkbox = Settings.CreateCheckbox(category, setting, tooltip)
	if PlayerGetTimerunningSeasonID() then EquipRecommendedGear_CharSettings["includeWeapons"] = false end
end

function app.CreateLinkCopiedFrame()
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
	string:SetText(L.SETTINGS_SUPPORT_COPIED)

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
