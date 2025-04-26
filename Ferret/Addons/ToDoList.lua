--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for Quest list (Not Journal)
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

local ToDoList = Addon:extend()
function ToDoList:new(ferret)
    ToDoList.super.new(self, "_ToDoList")
end

function ToDoList:get_count() return GetNodeListCount(self.key) end

function ToDoList:get_stellar_mission_scores()
    local pattern = "Current Score: ([%d,]+)%. Gold Star Requirement: ([%d,]+)"
    local function parse_number(str) return tonumber((str:gsub(",", ""))) end

    for i = 1, self:get_count() do
        local node_text = GetNodeText(self.key, i, 1)
        local current_score, gold_star_requirement =
            string.match(node_text, pattern)

        if current_score and gold_star_requirement then
            return parse_number(current_score),
                   parse_number(gold_star_requirement)
        end
    end

    return nil, nil
end

return ToDoList()
