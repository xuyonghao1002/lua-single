require "Utils.Utils"
require "Entity.ClassMgr"
local ClassModule = require "Utils.Class"
local AvatarEntity = require "Entity.Entity"

local Avatar = require "Entity.Avatar"


local function test_class()
    PrintTable(ClassModule.Object, 10, "Object")
    PrintTable(AvatarEntity, 10, "AvatarEntity")
    PrintTable(Avatar, 10, "Avatar")
end

local function test_load_dump()
    local avatar = Avatar(12345)
    avatar:EnterWorld()
    avatar.Id = 101
    print("before", avatar.CurrentChar.Level)
    avatar.CurrentChar:test()
    print("after", avatar.CurrentChar.Level)
    local save_attrs = avatar:GetSaveAttrs()
    PrintTable(save_attrs, 4, "save_attrs")
    local client_attrs = avatar:GetClientAttrs()
    PrintTable(client_attrs, 4, "client_attrs")

    local avatar2 = Avatar(6789)
    avatar2:InitFromDict(client_attrs)
    local save_attrs2 = avatar2:GetSaveAttrs()
    PrintTable(save_attrs2, 4, "save_attrs")
    local client_attrs2 = avatar2:GetClientAttrs()
    PrintTable(client_attrs2, 4, "client_attrs")

end


local function test_dict()
    local avatar = Avatar(1)
    print(avatar.Chars)
    PrintTable(avatar.Chars, 10, "avatar")
end


local function main()
    -- test_load_dump()

    test_dict()
end


main()