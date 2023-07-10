local _, addon = ...
local Professions = addon:NewObject("Professions")

local PROFESIONS_LABEL_FORMAT = "%s - %s"
local PROFESIONS_INDICES_MAP = {}

function Professions:IterableProfessionInfo()
    local prof1, prof2, arch, fish, cook = GetProfessions()
    PROFESIONS_INDICES_MAP[1] = prof1 or -1
    PROFESIONS_INDICES_MAP[2] = prof2 or -1
    PROFESIONS_INDICES_MAP[3] = arch or -1
    PROFESIONS_INDICES_MAP[4] = fish or -1
    PROFESIONS_INDICES_MAP[5] = cook or -1
    local i = 0
    local n = #PROFESIONS_INDICES_MAP
    return function()
        i = i + 1
        while i <= n do
            local index = PROFESIONS_INDICES_MAP[i]
            if index > -1 then
                local skillTitle, skillRankString
                local name, texture, rank, maxRank, _, _, _, rankModifier, _, _, skillLineName = GetProfessionInfo(index)

                if skillLineName then
                    skillTitle = skillLineName
                else
                    for j=1, #PROFESSION_RANKS do
                        local value, title = PROFESSION_RANKS[j][1], PROFESSION_RANKS[j][2]
                        if maxRank < value then break end
                        skillTitle = title
                    end
                end

                if rankModifier > 0 then
                    skillRankString = TRADESKILL_RANK_WITH_MODIFIER:format(rank, rankModifier, maxRank)
                else
                    skillRankString = TRADESKILL_RANK:format(rank, maxRank)
                end

                return PROFESIONS_LABEL_FORMAT:format(name, skillTitle), texture, skillRankString
            end
            i = i + 1
        end
    end
end