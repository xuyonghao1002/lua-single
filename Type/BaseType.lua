local class = require "NetworkEngine.Class"
local CommonUtils = require "Utils.CommonUtils"


local TypeBase = class()
	TypeBase.default = nil
	TypeBase._owner = nil
	TypeBase._attr_info = nil
	TypeBase.IsCustomType = true
	function TypeBase:New(...)
		local obj = self:_New()
		if obj and rawget(obj, "Init") then
			obj:Init(...)
		end
		return obj
	end

	function TypeBase:GetDefault()
		return CommonUtils.DeepCopy(self.default)
	end

	function TypeBase:Init(...)
	end

	function TypeBase:_Init()
	end

	function TypeBase.tostring(value)
		return tostring(value)
	end

	function TypeBase.convert(_type, data)
		if data == nil then
			return data
		end
		return _type.load(_type, data)
	end

	function TypeBase.load(_type, value)
		return value
	end

	function TypeBase.save_dump(_type, value)
		return value
	end

	function TypeBase.client_dump(_type, value)
		return value
	end

	function TypeBase.all_dump(_type, value)
		return value
	end

	function TypeBase.SetOwnerInfo(value, owner, attr)
	end


local ObjId = class({TypeBase})
	ObjId.default = nil
	function ObjId.load(_type, value)
		-- 客户端和服务端对ObjId的load不一样
		-- server要从str类型load成ObjId
		-- client直接接受server传过来的ObjId，并返回ObjId
		if value == nil then
			return value
		end
		if GWorld:IsSkynetServer() then
			if type(value) == "string" and CommonUtils.IsObjId(value) then
				return value
			end
			return GWorld.IdManager.Str2ObjId(value)
		else
			return value
		end
	end

	function ObjId.tostring(value)
		return CommonUtils.ObjId2Str(value)
	end

local Str = class({TypeBase})
	Str.default = ""
	function Str.load(_type, value)
		return tostring(value)
	end

local Int = class({TypeBase})
	Int.default = 0
	function Int.load(_type, value)
		return math.ceil(tonumber(value))
	end

local Float = class({TypeBase})
	Float.default = 0
	function Float.load(_type, value)
		return tonumber(value)
	end

local Bool = class({TypeBase})
	Bool.default = false
	function Bool.load(_type, value)
		return value == true
	end


local List = class({TypeBase})
	List.default = {}
	function List.load(_type, value)
		if type(value) == "table" then
			return value
		end
	end

local Dict = class({TypeBase})
	Dict.default = {}
	function Dict.load(_type, value)
		if type(value) == "table" then
			return value
		end
	end

local BaseTypes = {
	TypeBase = TypeBase,
	ObjId = ObjId,
	Str = Str,
	Int = Int,
	Float = Float,
	Bool = Bool,
	List = List,
	Dict = Dict,
}

return BaseTypes
