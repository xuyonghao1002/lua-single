local ClassModule = require "Utils.Class"
local Class = ClassModule.Class
local IsClass = ClassModule.IsClass
local CommonUtils = require "Utils.CommonUtils"


local BaseType = Class("BaseType")
	BaseType.default = nil
	BaseType._owner = nil
	BaseType._attr_info = nil
	BaseType.IsCustomType = true

	function BaseType:GetDefault()
		return CommonUtils.DeepCopy(self.default)
	end

	function BaseType:Init(...)
	end

	function BaseType:_Init(...)
	end

	function BaseType:tostring(value)
		return tostring(value)
	end

	function BaseType:GetTypeName()
		return self.__Name__
	end

	function BaseType:convert(data)
		if data == nil then
			return data
		end
		return self:load(data)
	end

	function BaseType:load(value)
		return value
	end

	function BaseType:save_dump(value)
		return value
	end

	function BaseType:client_dump(value)
		return value
	end

	function BaseType:all_dump(value)
		return value
	end

	function BaseType:SetOwnerInfo(value, owner, attr)
	end



local Int = Class("Int", BaseType)
	Int.default = 0
	function Int:load(value)
		return math.ceil(tonumber(value))
	end


local BaseTypes = {
	BaseType = BaseType,
	Int = Int,
}

return BaseTypes
