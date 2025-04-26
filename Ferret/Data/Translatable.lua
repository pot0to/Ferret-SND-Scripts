--------------------------------------------------------------------------------
--   DESCRIPTION: Translatable string
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

Translatable = Object:extend()
function Translatable:new(en)
    self.en = en
    self.de = en
    self.fr = en
    self.jp = en
end

function Translatable:with_de(de)
    self.de = de
    return self
end

function Translatable:with_fr(fr)
    self.fr = fr
    return self
end

function Translatable:with_jp(jp)
    self.jp = jp
    return self
end

function Translatable:get()
    if Ferret.language == 'de' then
        return self.de
    end
    if Ferret.language == 'fr' then
        return self.fr
    end
    if Ferret.language == 'jp' then
        return self.jp
    end

    return self.en
end
