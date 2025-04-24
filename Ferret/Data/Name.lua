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

function Name:get(language)
    if language == 'de' then return self.de end
    if language == 'fr' then return self.fr end
    if language == 'jp' then return self.jp end

    return self.en
end
