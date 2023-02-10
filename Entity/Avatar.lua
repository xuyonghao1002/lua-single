local Class = require "Utils.Class".Class
local AvatarEntity = require "Entity.Entity".AvatarEntity

local Avatar = Class("Avatar", AvatarEntity)

function Avatar:__init__(EntityId)
    self:Super().__init__(self, EntityId)
end

function Avatar:OnBecomePlayer()
    self:Super().OnBecomePlayer(self)
    print("Avatar OnBecomePlayer", self.Count)
end



return Avatar
