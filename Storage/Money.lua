if not MainMenuBarBackpackButton:IsVisible() then return end

local _, addon = ...
local Storage, DB = addon:NewStorage("Money")
local Character = addon.Character

local defaults = {
    profile = {
        hideConnectedRealmsNames = true,
        showAllCharacters = false,
        minMoneyAmount = 0
    }
}

function Storage:OnConfig()
    DB = self:RegisterDB(defaults)

    if not addon.DB.global.Money then
        addon.DB.global.Money = {}
    end

    local englishFaction = UnitFactionGroup("player")

    if not addon.DB.global.Money[englishFaction] or type(addon.DB.global.Money[englishFaction]) ~= "table" then
        addon.DB.global.Money[englishFaction] = {}
    end

    DB.__data = addon.DB.global.Money[englishFaction]
end

function Storage:UpdateForCharacter(character, money)
    DB.__data[character] = money
end

function Storage:IterableMoneyInfo()
    return pairs(DB.__data)
end

function Storage:Reset()
    for key, value in pairs(addon.DB.global.Money) do
        if type(value) ~= "table" then
            addon.DB.global.Money[key] = nil
        end
    end

    for character in self:IterableMoneyInfo() do
        self:UpdateForCharacter(character, nil)
    end

    self:UpdateForCharacter(Character:GetFullName(), GetMoney())

    Storage:TriggerEvent("WOWINFO_MONEY_DB_RESET")
end

function Storage:SetMinMoneyAmount(value)
    DB.profile.minMoneyAmount = tonumber(value)
end

function Storage:GetMinMoneyAmount()
    return DB.profile.minMoneyAmount or 0
end

function Storage:IsConnectedRealmsNamesHidden()
    return DB.profile.hideConnectedRealmsNames
end

function Storage:ToggleConnectedRealmsNames()
    DB.profile.hideConnectedRealmsNames = not DB.profile.hideConnectedRealmsNames
end

function Storage:CanShowAllCharacters()
    return DB.profile.showAllCharacters
end

function Storage:ToggleShowAllCharacters()
    DB.profile.showAllCharacters = not DB.profile.showAllCharacters
end