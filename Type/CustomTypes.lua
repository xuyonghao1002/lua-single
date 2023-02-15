local ClassModule = require "Utils.Class"
local Class = ClassModule.Class
local BaseTypes = require "Type.BaseTypes"
local BaseType = BaseTypes.BaseType


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
		assert(BaseTypes[self.KeyType.__Name__])
		self._inner = inner or {}
		setmetatable(self, ClassModule.DictInstanceMeta)
	end

	function CustomDict:SetDefault(key, value)
		key = self.KeyType:convert(key)
		if self._inner[key] then
			return self._inner[key]
		end
		self._inner[key] = self.ValueType:convert(value)
	end

	function CustomDict:load(data)
		local type = ClassModule.IsClass(self) and self or self.__Class__
		if ClassModule.IsInstance(data, type) then
			return data
		end
		local items = {}
		for key, value in pairs(data) do
			items[type.KeyType:convert(key)] = type.ValueType:convert(value)
		end
		return type(items)
	end

	function CustomDict:save_dump(data)
		if data == nil then
			return data
		end
		local result = {}
		local type = data.__Class__
		for key, value in pairs(data) do
			result[tostring(type.KeyType:save_dump(key))] = type.ValueType:save_dump(value)
		end
		return result
	end

	function CustomDict:client_dump(data)
		if data == nil then
			return data
		end
		local result = {}
		local type = data.__Class__
		for key, value in pairs(data) do
			result[tostring(type.KeyType:client_dump(key))] = type.ValueType:client_dump(value)
		end
		return result
	end

	function CustomDict:all_dump(data)
		if data == nil then
			return data
		end
		local result = {}
		local type = data.__Class__
		for key, value in pairs(data) do
			result[tostring(type.KeyType:all_dump(key))] = type.ValueType:all_dump(value)
		end
		return result
	end

local Int2IntDict = Class("Int2IntDict", CustomDict)
	Int2IntDict.KeyType = BaseTypes.Int
	Int2IntDict.ValueType = BaseTypes.Int


local CustomTypes = {
	CustomAttr = CustomAttr,
	CustomDict = CustomDict,
	Int2IntDict = Int2IntDict,
}

return CustomTypes
