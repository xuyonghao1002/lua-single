local Class = require "Utils.Class".Class

local Entity = {}

local AvatarEntity = Class("AvatarEntity")

function AvatarEntity:__init__(EntityId)
    self.EntityId = EntityId
    self.CallbackFuncs = {}
end

function AvatarEntity:BecomePlayer()
    self:OnBecomePlayer()
end

function AvatarEntity:OnBecomePlayer()
    print("AvatarEntity OnBecomePlayer")
end

function AvatarEntity:SetServer(Server)
    self.Server = Server
end

function AvatarEntity:Destroy()
    print("AvatarEntity Destroy")
end




Entity.AvatarEntity = AvatarEntity

return Entity