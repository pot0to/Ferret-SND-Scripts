--------------------------------------------------------------------------------
--   DESCRIPTION: Semantic versioning objecty
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

Version = Object:extend()
function Version:new(major, minor, patch)
    self.major = major
    self.minor = minor
    self.patch = patch
end

function Version:to_string()
    return string.format('v%d.%d.%d', self.major, self.minor, self.patch)
end
