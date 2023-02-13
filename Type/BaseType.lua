local Class = require "Utils.Class".Class
local CommonUtils = require "Utils.CommonUtils"


local TypeBase = Class("TypeBase")
	TypeBase.default = nil
	TypeBase._owner = nil
	TypeBase._attr_info = nil
	TypeBase.IsCustomType = true

	function TypeBase:GetDefault()
		return CommonUtils.DeepCopy(self.default)
	end

	function TypeBase:Init(...)
	end

	function TypeBase:_Init()
	end

	function TypeBase:tostring(value)
		return tostring(value)
	end

	function TypeBase:convert(data)
		if data == nil then
			return data
		end
		return self:load(data)
	end

	function TypeBase:load(value)
		return value
	end

	function TypeBase:save_dump(value)
		return value
	end

	function TypeBase:client_dump(value)
		return value
	end

	function TypeBase:all_dump(value)
		return value
	end

	function TypeBase:SetOwnerInfo(value, owner, attr)
	end



local Int = Class("Int", TypeBase)
	Int.default = 0
	function Int:load(value)
		return math.ceil(tonumber(value))
	end


local BaseTypes = {
	TypeBase = TypeBase,
	Int = Int,
}

return BaseTypes
