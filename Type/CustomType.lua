local class = require "NetworkEngine.Class"
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CommonUtils = require "Utils.CommonUtils"


local CustomType = class({BaseTypes.TypeBase})
	function CustomType:GetDefault()
		return self:_New()
	end
	function CustomType.SetOwnerInfo(value, owner, attr)
		-- GWorld.logger.debug("SetOwnerInfo", attr.name, value.__classname, value)
		if rawget(owner, "_OnPropChange") or rawget(owner, "_OnPropSet")
			or rawget(owner, "_OnPropDelete") or rawget(owner, "_OnPropClear") then
			rawset(value, '_owner', owner)
			rawset(value, '_attr_info', attr)
		end
	end


local CustomAttr = class({CustomType})
	CustomAttr.__classname = "CustomAttr"
	function CustomAttr.load(_type, data)
		if _type.__classname == rawget(data, "__classname") then
			return data
		end

		local object = _type:_New()
		for key, value in pairs(data) do
			local attr = rawget(object, "Props")[key]
			if attr then
				attr:Set(value)
			end
		end
		object:_Init()
		return object
	end

	function CustomAttr.save_dump(_type, value)
		if value == nil then
			return value
		end
		local result = {}
		for _, prop_name in ipairs(value._SaveProps) do
			local attr = value.Props[prop_name]
			if attr then
				result[attr.name] = attr.type.save_dump(attr.type, attr.value)
			end
		end

		return result
	end

	function CustomAttr.client_dump(_type, value)
		if value == nil then
			return value
		end
		local result = {}
		for _, prop_name in ipairs(value._ClientProps) do
			local attr = value.Props[prop_name]
			if attr then
				result[attr.name] = attr.type.client_dump(attr.type, attr.value)
			end
		end

		return result
	end

	function CustomAttr.all_dump(_type, value)
		if value == nil then
			return value
		end
		local result = {}
		for prop_name, attr in pairs(value.Props) do
			if attr then
				result[attr.name] = attr.type.all_dump(attr.type, attr.value)
			end
		end

		return result
	end


local function DictNext(mytable, key)
	return next(mytable._inner, key)
end

local CustomDict = class({CustomType})
	CustomDict.__classname = "CustomDict"
	CustomDict.KeyType = nil
	CustomDict.ValueType = nil
	function CustomDict:New(inner, ...)
		local obj = self:_New()
		obj._inner = inner or {}
		setmetatable(obj, {
			__index = function (mytable, key)
				return rawget(mytable._inner, key)
			end,
			__newindex = function (mytable, key, value)
				local _key = mytable.KeyType.convert(mytable.KeyType, key)
				local _value = mytable.ValueType.convert(mytable.ValueType, value)
				rawset(mytable._inner, _key, _value)
				-- 同步客户端此更改
				if mytable._owner and rawget(mytable._owner, "_OnPropSet") then
					mytable._owner:_OnPropSet(mytable._attr_info, key, value)
				end
			end,
			__pairs = function (mytable, key)
				return DictNext, mytable, key
			end
		})
		if obj and rawget(obj, "Init") then
			obj:Init(...)
		end
		return obj
	end

	function CustomDict:GetDefault()
		return self:New()
	end

	function CustomDict:Get(key, _value)
		local value = rawget(self._inner, key)
		if value then
			return value
		else
			return _value
		end
	end

	function CustomDict:SetDefault(key, value)
		local CurrentValue = rawget(self._inner, key)
		if CurrentValue then
			return CurrentValue
		end
		local _key = self.KeyType.convert(self.KeyType, key)
		local _value = self.ValueType.convert(self.ValueType, value)
		rawset(self._inner, _key, _value)
	end

	function CustomDict:Keys()
		local result = {}
		for key, value in pairs(self._inner) do
			table.insert(result, key)
		end
		return result
	end

	function CustomDict:Length()
		local length = 0
		for key, value in pairs(self._inner) do
			length = length + 1
		end
		return length
	end

	function CustomDict:AddValue(key, value)
		local _key = self.KeyType.convert(self.KeyType, key)
		local _value = self.ValueType.convert(self.ValueType, value)
		rawset(self._inner, _key, _value)
	end

	function CustomDict:Clear()
		self._inner = {}
	end

	function CustomDict.load(_type, data)
		if _type.__classname == rawget(data, "__classname") then
			return data
		end

		local items = {}
		for key, value in pairs(data) do
			items[_type.KeyType.convert(_type.KeyType, key)] = _type.ValueType.convert(_type.ValueType, value)
		end
		return _type:New(items)
	end

	function CustomDict.save_dump(_type, data)
		if data == nil then
			return data
		end
		local result = {}
		for key, value in pairs(data) do
			if type(key) == "string" and CommonUtils.IsObjId(key) then
				result[CommonUtils.ObjId2Str(key)] = _type.ValueType.save_dump(_type.ValueType, value)
			else
				result[tostring(_type.KeyType.save_dump(_type.KeyType, key))] = _type.ValueType.save_dump(_type.ValueType, value)
			end
		end
		return result
	end

	function CustomDict.client_dump(_type, data)
		if data == nil then
			return data
		end
		local result = {}
		for key, value in pairs(data) do
			if type(key) == "string" and CommonUtils.IsObjId(key) then
				result[key] = _type.ValueType.client_dump(_type.ValueType, value)
			else
				result[tostring(_type.KeyType.client_dump(_type.KeyType, key))] = _type.ValueType.client_dump(_type.ValueType, value)
			end
		end
		return result
	end

	function CustomDict.all_dump(_type, data)
		if data == nil then
			return data
		end
		local result = {}
		for key, value in pairs(data) do
			if type(key) == "string" and CommonUtils.IsObjId(key) then
				result[key] = _type.ValueType.all_dump(_type.ValueType, value)
			else
				result[tostring(_type.KeyType.all_dump(_type.KeyType, key))] = _type.ValueType.all_dump(_type.ValueType, value)
			end
		end
		return result
	end


local CustomList = class({CustomDict})
	CustomList.__classname = "CustomList"
	CustomList.KeyType = BaseTypes.Int
	CustomList.ValueType = nil

	function CustomList:Length()
		return #self._inner
	end

	function CustomList:HasValue(value)
		local _value = self.ValueType.convert(self.ValueType, value)
		for index, item in ipairs(self._inner) do
			if item == _value then
				return true
			end
		end
		return false
	end

	function CustomList:Append(value)
		local _value = self.ValueType.convert(self.ValueType, value)
		table.insert(self._inner, _value)
		if self._owner and rawget(self._owner, "_OnPropSet") then
			local key = #self._inner
			self._owner:_OnPropSet(self._attr_info, key, value)
		end
	end

	function CustomList:Remove(value)
		local _value = self.ValueType.convert(self.ValueType, value)
		local Pos = nil
		for index, item in ipairs(self._inner) do
			if item == _value then
				Pos = index
				break
			end
		end
		if Pos then
			table.remove(self._inner, Pos)
			return true
		end
		return false
	end

	function CustomList.load(_type, data)
		if _type.__classname == rawget(data, "__classname") then
			return data
		end
		local items = {}
		for index, value in ipairs(data) do
			table.insert(items, _type.ValueType.convert(_type.ValueType, value))
		end
		return _type:New(items)
	end

	function CustomList.save_dump(_type, data)
		if data == nil then
			return data
		end
		local result = {}
		for index, value in ipairs(data) do
			table.insert(result, _type.ValueType.save_dump(_type.ValueType, value))
		end
		return result
	end

	function CustomList.client_dump(_type, data)
		if data == nil then
			return data
		end
		local result = {}
		for index, value in ipairs(data) do
			table.insert(result, _type.ValueType.client_dump(_type.ValueType, value))
		end
		return result
	end

	function CustomList.all_dump(_type, data)
		if data == nil then
			return data
		end
		local result = {}
		for index, value in ipairs(data) do
			table.insert(result, _type.ValueType.all_dump(_type.ValueType, value))
		end
		return result
	end


-- Common List
local IntList = class({CustomList})
	IntList.__classname = "IntList"
	IntList.__type = "CustomTypes.IntList"
	IntList.ValueType = BaseTypes.Int

local FloatList = class({CustomList})
	FloatList.__classname = "FloatList"
	FloatList.__type = "CustomTypes.FloatList"
	FloatList.ValueType = BaseTypes.Float

local ObjectIdList = class({CustomList})
	ObjectIdList.__classname = "ObjectIdList"
	ObjectIdList.ValueType = BaseTypes.ObjId


-- Common Dict
local Int2IntDict = class({CustomDict})
	Int2IntDict.__classname = "Int2IntDict"
	Int2IntDict.KeyType = BaseTypes.Int
	Int2IntDict.ValueType = BaseTypes.Int

local Int2ObjIdDict = class({CustomDict})
	Int2ObjIdDict.__classname = "Int2ObjIdDict"
	Int2ObjIdDict.KeyType = BaseTypes.Int
	Int2ObjIdDict.ValueType = BaseTypes.ObjId

local Int2IntListDict = class({CustomDict})
	Int2IntListDict.__classname = "Int2IntListDict"
	Int2IntListDict.KeyType = BaseTypes.Int
	Int2IntListDict.ValueType = BaseTypes.List




local CustomTypes = {
	CustomAttr = CustomAttr,
	CustomDict = CustomDict,
	CustomList = CustomList,
	IntList = IntList,
	FloatList = FloatList,
	ObjectIdList = ObjectIdList,
	Int2IntDict = Int2IntDict,
	Int2ObjIdDict = Int2ObjIdDict,
	Int2IntListDict = Int2IntListDict
}

return CustomTypes
