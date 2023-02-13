require "Utils.Utils"
require "Entity.ClassMgr"

local Avatar = require "Entity.Avatar"



local function main()

    -- PrintTable(ClassModule.Object, 10, "Object")
    -- PrintTable(AvatarEntity, 10, "AvatarEntity")
    PrintTable(Avatar, 10, "Avatar")

    local avatar = Avatar(12345)
    PrintTable(avatar, 4, "avatar")

    avatar:EnterWorld()
    -- print(avatar._id)
    avatar._id = 10
    PrintTable(avatar, 4, "avatar")

end


main()