local ClassModule = require "Utils.Class"
local Class = ClassModule.Class
local BaseTypes = require "Type.BaseTypes"
local CustomTypes = require "Type.CustomTypes"
local prop = require "Utils.Prop"
local FormatProperties = require "Utils.Assemble".FormatProperties


local Char = Class("Char", CustomTypes.CustomAttr)
	Char.__Props__ = {
		-- 角色id
		CharId = prop.prop("Int", "client save"),
		-- 经验
		Exp = prop.prop("Int", "client save"),
		-- 等级
		Level = prop.prop("Int", "client save", 1),
	}

	function Char:Init(CharId)
		if not CharId then
			return
		end
		self.CharId = CharId
	end

    function Char:AddLevel()
        print("Char AddLevel")
        self.Level = self.Level + 1
    end

	FormatProperties(Char)


local CharDict = Class("CharDict", CustomTypes.CustomDict)
	CharDict.KeyType = BaseTypes.Int
	CharDict.ValueType = Char

	function CharDict:NewChar(CharId)
		return Char(CharId)
	end


return {Char = Char, CharDict = CharDict}
