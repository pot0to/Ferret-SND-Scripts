ResearchProgressBar = Object:extend()
function ResearchProgressBar:new(current, required, max)
    self.current = current
    self.required = required
    self.max = max
end
