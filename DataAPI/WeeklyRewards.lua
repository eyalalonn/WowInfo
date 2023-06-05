local _, addon = ...
local WeeklyRewards = addon:NewObject("WeeklyRewards")

local GREAT_VAULT_UNLOCKED_1ST_REWARD_COLOR = "ff14b200"
local GREAT_VAULT_UNLOCKED_2ND_REWARD_COLOR = "ff0091f2"
local GREAT_VAULT_UNLOCKED_3RD_REWARD_COLOR = "ffc745f9"

local function GetGreatVaultProgressString(activityInfo)
    local thresholdString, progressString
    
    if activityInfo.type == Enum.WeeklyRewardChestThresholdType.Raid then
        thresholdString = WEEKLY_REWARDS_THRESHOLD_RAID
    elseif activityInfo.type == Enum.WeeklyRewardChestThresholdType.MythicPlus then
        thresholdString = WEEKLY_REWARDS_THRESHOLD_MYTHIC
    elseif activityInfo.type == Enum.WeeklyRewardChestThresholdType.RankedPvP then
        thresholdString = WEEKLY_REWARDS_THRESHOLD_PVP
    end

    thresholdString = thresholdString:format(activityInfo.threshold)

    if activityInfo.index == 1 and activityInfo.progress > activityInfo.minThreshold then
        thresholdString = WrapTextInColorCode(thresholdString, GREAT_VAULT_UNLOCKED_1ST_REWARD_COLOR)
    elseif activityInfo.index == 2 and activityInfo.progress > activityInfo.minThreshold then
        thresholdString = WrapTextInColorCode(thresholdString, GREAT_VAULT_UNLOCKED_2ND_REWARD_COLOR)
    elseif activityInfo.index == 3 and activityInfo.progress > activityInfo.minThreshold then
        thresholdString = WrapTextInColorCode(thresholdString, GREAT_VAULT_UNLOCKED_3RD_REWARD_COLOR)
    end

    if activityInfo.progress > 0 then
        progressString = WrapTextInColorCode(activityInfo.progress, "ffffffff")
    else
        progressString = activityInfo.progress
    end

    return thresholdString, progressString
end

local function GetActivityInfo(type)
    local activityInfo
    local minThreshold
    for _, currentActivityInfo in ipairs(C_WeeklyRewards.GetActivities(type)) do
        activityInfo = currentActivityInfo
        activityInfo.minThreshold = minThreshold or currentActivityInfo.threshold
        if currentActivityInfo.progress <= currentActivityInfo.threshold then
            break
        end
        minThreshold = currentActivityInfo.threshold
    end
    return activityInfo
end

function WeeklyRewards:GetGreatVaultRaidProgressString()
    return GetGreatVaultProgressString(GetActivityInfo(Enum.WeeklyRewardChestThresholdType.Raid))
end

function WeeklyRewards:GetGreatVaultMythicPlusProgressString()
    return GetGreatVaultProgressString(GetActivityInfo(Enum.WeeklyRewardChestThresholdType.MythicPlus))
end

function WeeklyRewards:GetGreatVaultPvPProgressString()
    return GetGreatVaultProgressString(GetActivityInfo(Enum.WeeklyRewardChestThresholdType.RankedPvP))
end