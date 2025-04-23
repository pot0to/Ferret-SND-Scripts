Chat = {marker = "ferret_chat_marker"}

function Chat:new(ferret)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

function Chat:send_marker() yield('/echo ' .. self.marker) end

function Chat:has_message(message)
    local chat = GetNodeText("ChatLogPanel_0", 7, 2)
    local index = 0
    local latest = 0
    repeat
        latest = string.find(chat, self.marker, latest + 1, false) or -1
        if latest > 0 then index = latest end
    until latest <= -1

    chat = string.sub(chat, index + 1)

    return string.find(chat, message)
end

function Chat:wait_for_message(message)
    self.ferret:wait_until(function() return self:has_message(message) end);
    -- self:send_marker()
end
