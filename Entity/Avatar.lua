
-- local AvatarAttr = require "AvatarAtrr"
local TypeMgr = require "Entity.TypeMgr"

local Avatar = {}

-- Avatar._implement = "BluePrints.Client.Implements.Avatar"

-- Avatar.__classname = "Avatar"

function Avatar:test()
    print("Avatar test")
end

-- Avatar:AssembleComponents()
-- Avatar:FormatProperties()

TypeMgr:RegisterType("Avatar", Avatar)
return Avatar
