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

AssembleComponents(Avatar)
FormatProperties(Avatar)
return Avatar