local ClassModule = require "Utils.Class"
local Class = ClassModule.Class
local BaseType = require "Type.BaseType".BaseType


local CustomType = Class("CustomType", BaseType)
	function CustomType:GetDefault()
		return self()
	end
	function CustomType:SetOwnerInfo(value, owner, attr)
		-- if rawget(owner, "_OnPropChange") or rawget(owner, "_OnPropSet")
		-- 	or rawget(owner, "_OnPropDelete") or rawget(owner, "_OnPropClear") then
		-- 	rawset(value, '_owner', owner)
		-- 	rawset(value, '_attr_info', attr)
		-- end
	end


local CustomAttr = Class("CustomAttr", CustomType)
	function CustomAttr:load(data)
		-- 判断self的类型：类或者实例
		local type = ClassModule.IsClass(self) and self or self.__Class__
		if ClassModule.IsInstance(data, type) then
			return data
		end

		local object = type()
		object.__Dict__.Props = {}
		for key, value in pairs(data) do
			local prop = type.Props[key]
			if prop then
				object.__Dict__.Props[key] = prop:GetTypeInstance(value)
			end
		end
		object:_Init()
		return object
	end

	function CustomAttr:save_dump(value)
		if value == nil then
			return value
		end
		local result = {}
		if not value.__Dict__.Props then
			return result
		end
		local type = value.__Class__
		-- PrintTable(value, 10, "value")
		-- PrintTable(type, 10, "type")
		for _, name in ipairs(value.SaveProps) do
			local attr = value.__Dict__.Props[name]
			local prop = type.Props[name]
			if attr and prop then
				result[name] = prop:GetSaveDump(attr)
			end
		end

		return result
	end

	function CustomAttr:client_dump(value)
		if value == nil then
			return value
		end
		local result = {}
		if not value.__Dict__.Props then
			return result
		end
		local type = value.__Class__
		for _, name in ipairs(value.ClientProps) do
			local attr = value.__Dict__.Props[name]
			local prop = type.Props[name]
			if attr and prop then
				result[name] = prop:GetClientDump(attr)
			end
		end

		return result
	end

	function CustomAttr:all_dump(value)
		if value == nil then
			return value
		end
		local result = {}
		if not value.__Dict__.Props then
			return result
		end
		local type = value.__Class__
		for name, prop in pairs(type.Props) do
			local attr = value.__Dict__.Props[name]
			if attr and prop then
				result[name] = prop:GetAllDump(attr)
			end
		end

		return result
	end


local CustomDict = Class("CustomDict", CustomType)
	CustomDict.KeyType = nil
	CustomDict.ValueType = nil
	function CustomDict:Init(inner, ...)
		self._inner = inner or {}

	end



local CustomTypes = {
	CustomAttr = CustomAttr,
	CustomDict = CustomDict
}

return CustomTypes
