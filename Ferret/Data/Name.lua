Name = {}

function Name:new(en)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.en = en
    o.de = en
    o.fr = en
    o.jp = en

    return o
end

function Name:with_de(de)
    self.de = de
    return self
end

function Name:with_fr(fr)
    self.fr = fr
    return self
end

function Name:with_jp(jp)
    self.jp = jp
    return self
end
