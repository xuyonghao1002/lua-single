require "Utils.Utils"
require "Entity.ClassMgr"
local ClassModule = require "Utils.Class"
local AvatarEntity = require "Entity.Entity"
local Avatar = require "Entity.Avatar"

local Box = require "Type.RewardBox".RewardBox


local function test_class()
    PrintTable(ClassModule.Object, 10, "Object")
    PrintTable(AvatarEntity, 10, "AvatarEntity")
    PrintTable(Avatar, 10, "Avatar")
end

local function test_load_dump()
    local avatar = Avatar(12345)
    avatar:EnterWorld()
    avatar.Id = 101
    avatar.CurrentChar:AddLevel()
    avatar.Chars[101] = avatar.Chars:NewChar(101)

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
    avatar.Chars[101] = avatar.Chars:NewChar(101)
    print(avatar.Chars[101].CharId)
    PrintTable(avatar.Chars, 8, "avatar.Chars")
    for key, value in pairs(avatar.Chars) do
        print(key, value)
    end
end

local function test(a,b,c)
    local ret = 1
end

local function getArgs(fun)
    local args = {}

    local hook = function (...)
        local info = debug.getinfo(3)
        if info.name ~= "pcall" then
            return
        end
        for i = 1, math.huge do
            local name, value = debug.getlocal(2, i)
            if name == '(*temporary)' or not name then
                debug.sethook()
                error('')
                return
            end
            args[i] = name
        end
    end

    debug.sethook(hook, "c")
    pcall(fun)

    return table.unpack(args)
end

local function main()
    -- test_load_dump()
    -- test_dict()
    -- PrintTable(debug.getinfo(3), 10)

    print(getArgs(test))
end


main()