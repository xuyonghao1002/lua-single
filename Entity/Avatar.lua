local Class = require "Utils.Class".Class
local AvatarEntity = require "Entity.Entity".AvatarEntity
local AssembleComponents = require "Utils.Assemble".AssembleComponents
local FormatProperties = require "Utils.Assemble".FormatProperties

local Avatar = Class("Avatar", AvatarEntity)

Avatar.__Props__= "Entity.AvatarAttr"

Avatar.__Component__ = {
    "Entity.Components.CharMgr"
}

function Avatar:Init(EntityId)
    self:Super().Init(self, EntityId)
end

function Avatar:OnBecomePlayer()
    self:Super().OnBecomePlayer(self)
    print("Avatar OnBecomePlayer", self.Count)
end

function Avatar:EnterWorld()
    print("Avatar EnterWorld")
end

function Avatar:GetSaveAttrs()
    if not self.SaveProps then
        return {}
    end
    local result = {}
    if not self.__Dict__.Props then
        return result
    end
    local type = self.__Class__
    for _, name in ipairs(self.SaveProps) do
        local attr = self.__Dict__.Props[name]
        local prop = type.Props[name]
        if attr and prop then
            result[name] = prop:GetSaveDump(attr)
        end
    end
    return result
end

function Avatar:GetClientAttrs()
    if not self.ClientProps then
        return {}
    end
    local result = {}
    if not self.__Dict__.Props then
        return result
    end
    local type = self.__Class__
    for _, name in ipairs(self.ClientProps) do
        local attr = self.__Dict__.Props[name]
        local prop = type.Props[name]
        if attr and prop then
            result[name] = prop:GetClientDump(attr)
        end
    end
    return result
end

function Avatar:InitFromDict(attrs)
    local type = self.__Class__
    if not type.__Dict__.Props then
        return
    end
    self.__Dict__.Props = {}
    for name, value in pairs(attrs) do
        local prop = type.__Dict__.Props[name]
        if prop then
            self.__Dict__.Props[name] = prop:GetTypeInstance(value)
        end
    end
end

AssembleComponents(Avatar)
FormatProperties(Avatar)
return Avatar