local ClassMgr = require "Entity.ClassMgr"


local ClassMeta = {}
local InstanceMeta = {}
local DictInstanceMeta = {}
local ClassModule = {}


local function Deque()
	local self = {}
	self._Items = {}
	self._Front = 0
	self._Back = 0
	function self:PushFront(Item)
		if Item == nil then
			error('cannot push nil onto the deque')
		end
		self._Front = self._Front - 1
		self._Items[self._Front] = Item
	end
	function self:PopFront()
		local Item = self._Items[self._Front]
		self._Items[self._Front] = nil
		if Item then
			self._Front = self._Front + 1
		end
		return Item
	end
	function self:PushBack(Item)
		if Item == nil then
		error('cannot push nil onto the deque')
		end
		self._Items[self._Back] = Item
		self._Back = self._Back + 1
	end
	function self:PopBack()
		local Item = self._Items[self._Back-1]
		self._Items[self._Back-1] = nil
		if Item then
			self._Back = self._Back - 1
		end
		return Item
	end
	function self:Size()
		return self._Back - self._Front
	end
	function self:Items()
		return pairs(self._Items)
	end
	function self:Empty()
		return not (next(self._Items) and true or false)
	end
	return self
end

local function Class(Name, Super)
	local Base = Super
	if not Base and Name ~= "Object" then
		Base = ClassModule.Object
	end

	local MroVec = {}
	local MroSet = {}
	local NewClass = {}
	local Q = Deque()
	if Base then
		Q:PushBack(Base.__Name__)
	end

	table.insert(MroVec, Name)
	while not Q:Empty() do
		local FrontClassName = Q:PopFront()
		local class = ClassMgr:GetClass(FrontClassName)
		if class and class.__Base__ then
			Q:PushBack(class.__Base__)
		end
		if not MroSet[FrontClassName] then
			MroSet[FrontClassName] = FrontClassName
			table.insert(MroVec, FrontClassName)
		end
	end
	NewClass.__Name__ = Name
	if Base then
		NewClass.__Base__ = Base.__Name__
	end
	NewClass.__Mro__ = MroVec
	NewClass.__Class__ = {__Dict__ = {}, __Mro__ = {}}
	NewClass.__Dict__ = {}

	setmetatable(NewClass, ClassMeta)
	ClassMgr:RegisterClass(Name, NewClass)
	return NewClass
end

local function IsClass(c)
	return getmetatable(c) == ClassMeta
end

local function Resolve(obj, key)
	local value = obj.__Dict__[key]
	if value == nil then
		value = obj.__Class__.__Dict__[key]
	end
	if value then
		return value
	end
	local Mro = nil
	if IsClass(obj) then
		Mro = obj.__Mro__
	else
		Mro = obj.__Class__.__Mro__
	end
	for _, ClassName in ipairs(Mro) do
		local class = ClassMgr:GetClass(ClassName)
		if class then
			value = class.__Dict__[key]
			if value then
				return value
			end
		end
	end
	return nil
end

local function IsInstance(obj, class)
	if not obj.__Class__ then
		return false
	end
	if not obj.__Class__.__Mro__ then
		return false
	end
	for _, c in ipairs(obj.__Class__.__Mro__) do
		if c == class.__Name__ then
			return true
		end
	end
	return false
end

local function GetAttr(obj, key)
	return Resolve(obj, key)
end

local function SetAttr(obj, key, value)
	obj.__Dict__[key] = value
end

local function ClassName(A)
	return IsClass(A) and A.__Name__ or A.__Class__.__Name__
end

local function Mro(A)
	return A.__Mro__
end


--------------------------------------------------------------------------------
-- Class metatable
--------------------------------------------------------------------------------
function ClassMeta:__call(...)
	local obj = {
		__Name__ = self.__Name__,
		__Base__ = self.__Base__,
		__Class__ = self,
		__Dict__ = {},
	}
	setmetatable(obj, InstanceMeta)
	if GetAttr(obj, 'Init') then
		GetAttr(obj, 'Init')(obj, ...)
	end
	return obj
end
function ClassMeta:__index(key)
	return Resolve(self, key)
end
function ClassMeta:__newindex(key, value)
	if string.sub(key, 1, 2) == "__" and string.sub(key, -2, -1) == "__" then
		rawset(self, key, value)
		return
	end
	self.__Dict__[key] = value
end


--------------------------------------------------------------------------------
-- Instance metatable
--------------------------------------------------------------------------------
function InstanceMeta:__index(key)
	local result = nil
	if self.__Dict__.Props then
		result = self.__Dict__.Props[key]
		if result then
			return result
		end
	end
	if self.__Class__.__Dict__.Props then
		local prop = self.__Class__.__Dict__.Props[key]
		if prop then
			if not self.__Dict__.Props then
				self.__Dict__.Props = {}
			end
			self.__Dict__.Props[key] = prop:GetDefault()
			return self.__Dict__.Props[key]
		end
	end
	return Resolve(self, key)
end
function InstanceMeta:__newindex(key, value)
	if self.__Class__.__Dict__.Props then
		local prop = self.__Class__.__Dict__.Props[key]
		if prop then
			if not self.__Dict__.Props then
				self.__Dict__.Props = {}
			end
			self.__Dict__.Props[key] = prop:GetTypeInstance(value)
			return
		end
	end
	self.__Dict__[key] = value
end


--------------------------------------------------------------------------------
-- Instance metatable
--------------------------------------------------------------------------------
function DictInstanceMeta:__index(key)
	local result = nil
	if self.__Dict__._inner then
		result = self.__Dict__._inner[key]
		if result then
			return result
		end
	end
	return Resolve(self, key)
end
function DictInstanceMeta:__newindex(key,  value)
	local KeyType = self.KeyType
	local ValueType = self.ValueType
	self.__Dict__._inner[KeyType:convert(key)] = ValueType:convert(value)
end
local function DictNext(table, key)
	return next(table._inner, key)
end
function DictInstanceMeta:__pairs(key)
	return DictNext, self, key
end


--------------------------------------------------------------------------------
-- Object Class definition
--------------------------------------------------------------------------------
local Object = Class('Object')
function Object:Super()
	local super = self.__Base__
	if super then
		return ClassMgr:GetClass(super)
	end
	return nil
end


--------------------------------------------------------------------------------
-- Class module definition
--------------------------------------------------------------------------------
ClassModule.Class = Class
ClassModule.IsClass = IsClass
ClassModule.IsInstance = IsInstance
ClassModule.GetAttr = GetAttr
ClassModule.SetAttr = SetAttr
ClassModule.ClassName = ClassName
ClassModule.Mro = Mro
ClassModule.ClassMeta = ClassMeta
ClassModule.InstanceMeta = InstanceMeta
ClassModule.DictInstanceMeta = DictInstanceMeta
ClassModule.Object = Object


return ClassModule
