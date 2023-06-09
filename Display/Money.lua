if not MainMenuBarBackpackButton:IsVisible() then return end

local _, addon = ...
local Display = addon:NewDisplay("Money")
local Money = addon.Money

local TOTAL_MONEY_LABEL = "Total"
local MONEY_LABEL = "Money:"

Display:RegisterHookScript(MainMenuBarBackpackButton, "OnEnter", function()
    Display:AddEmptyLine()
    Display:AddHighlightLine(MONEY_LABEL)

    Display:AddRightHighlightDoubleLine(Money:GetPlayerMoneyInfo())

    for charDisplayName, moneyString in Money:IterableCharactersMoneyInfo() do
        Display:AddRightHighlightDoubleLine(charDisplayName, moneyString)
    end

    Display:AddEmptyLine()
    Display:AddHighlightDoubleLine(TOTAL_MONEY_LABEL, Money:GetTotalMoneyString())
    Display:AddEmptyLine()

    Display:Show()
end)
