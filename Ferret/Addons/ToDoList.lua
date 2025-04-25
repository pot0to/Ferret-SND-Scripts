ToDoList = Object:extend()
function ToDoList:new(ferret)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

function ToDoList:is_ready() return IsAddonReady("_ToDoList") end

function ToDoList:wait_until_ready()
    self.ferret:wait_for_ready_addon("_ToDoList")
end

function ToDoList:get_count() return GetNodeListCount("_ToDoList") end

function ToDoList:get_stellar_mission_scores()
    local pattern = "Current Score: ([%d,]+)%. Gold Star Requirement: ([%d,]+)"
    local function parse_number(str) return tonumber((str:gsub(",", ""))) end

    for i = 1, self:get_count() do
        local node_text = GetNodeText("_ToDoList", i, 1)
        local current_score, gold_star_requirement =
            string.match(node_text, pattern)

        if current_score and gold_star_requirement then
            return parse_number(current_score),
                   parse_number(gold_star_requirement)
        end
    end

    return nil, nil
end
