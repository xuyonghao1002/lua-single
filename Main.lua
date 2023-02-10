require "Utils.Utils"
require "Entity.ClassMgr"
local ClassModule = require "Utils.Class"
local AvatarEntity = require "Entity.Entity".AvatarEntity
local Avatar = require "Entity.Avatar"



local function main()

    PrintTable(ClassModule.Object, 10, "Object")
    PrintTable(AvatarEntity, 10, "AvatarEntity")
    PrintTable(Avatar, 10, "Avatar")

    local avatar = Avatar(12345)
    PrintTable(avatar, 10, "avatar")

    avatar:EnterWorld()
end


main()