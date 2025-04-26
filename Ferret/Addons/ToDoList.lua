--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for Quest list (Not Journal)
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

local ToDoList = Addon:extend()
function ToDoList:new()
    ToDoList.super.new(self, '_ToDoList')
end

function ToDoList:get_count()
    return GetNodeListCount(self.key)
end

function ToDoList:get_stellar_mission_scores()
    local pattern = Translatable('Current Score: ([%d,]+)%. Gold Star Requirement: ([%d,]+)')
        :with_de('Aktuell: ([%d%.]+) / Gold: ([%d%.]+)')
        :with_fr('Évaluation : ([%d%s]+) / Rang or : ([%d%s]+)')
        :with_jp('現在の評価値: ([%d,]+) / ゴールドグレード条件: ([%d,]+)')

    for i = 1, self:get_count() do
        local node_text = GetNodeText(self.key, i, 1)
        local current_score, gold_star_requirement = string.match(node_text, pattern:get())

        if current_score and gold_star_requirement then
            return Ferret:parse_number(current_score), Ferret:parse_number(gold_star_requirement)
        end
    end

    return nil, nil
end

return ToDoList()
