local ClassModule = require "Utils.Class"
local Class = ClassModule.Class
local BaseTypes = require "Type.BaseTypes"
local CustomTypes = require "Type.CustomTypes"
local prop = require "Utils.Prop"
local FormatProperties = require "Utils.Assemble".FormatProperties



local RewardBox = Class("RewardBox", CustomTypes.CustomAttr)
	RewardBox.__Props__ = {
		-- 材料
		Resources = prop.prop("CustomTypes.Int2IntDict", "client save"),
		-- 角色
		Chars = prop.prop("CustomTypes.Int2IntDict", "client save"),
		-- 武器
		Weapons = prop.prop("CustomTypes.Int2IntDict", "client save"),
		-- Mod
		Mods = prop.prop("CustomTypes.Int2IntDict", "client save"),
		-- 皮肤
		Skins = prop.prop("CustomTypes.Int2IntDict", "client save"),
		-- 掉落物
		Drops = prop.prop("CustomTypes.Int2IntDict", "client save"),
		-- 经验
		Exps = prop.prop("CustomTypes.Int2IntDict", "client save"),
	}

    function RewardBox:AddChar(CharId, Count)
		self.Chars:SetDefault(CharId, 0)
		self.Chars[CharId] = self.Chars[CharId] + Count
	end

    FormatProperties(RewardBox)

return {RewardBox = RewardBox}