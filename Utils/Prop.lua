local CommonUtils = require "Utils.CommonUtils"
local RpcUtils = require "Utils.RpcUtils"
local class = require "NetworkEngine.Class"


local Prop = class()

	function Prop:New(type_str, options, default, ...)
		local obj = self:_New()
		if obj then
			obj:Init(type_str, options, default, ...)
		end
		return obj
	end

	function Prop:Init(type_str, options, default, ...)
		self.is_prop = true

		if type(type_str) == "string" then
			self.type_str = type_str
			self:ParseType(type_str)
		elseif type(type_str) == "table" then
			self.type = type_str
		end

		self:ParseOptions(options)
		if default then
			self.value = CommonUtils.DeepCopy(default)
		else
			self.value = self.type:GetDefault()
		end
	end

	function Prop:ParseType(type_str)
		self.type = RpcUtils.GetClass(type_str)
	end

	function Prop:ParseOptions(options)
		self.save = false
		self.client = false
		for k,v in pairs(CommonUtils.Split(options, " ")) do
			rawset(self, v, true)
		end
	end

	function Prop:SetName(name)
		self.name = name
		self.set_notifier = "_OnSet"..name
		self.change_notifier = "_OnChange"..name
	end

	function Prop:Set(value)
		self.value = self.type.convert(self.type, value)
	end


local Getter = class()

	function Getter:New(attr, name)
		local obj = self:_New()
		if obj then
			obj:Init(attr, name)
		end
		return obj
	end

	function Getter:Init(attr, name)
		self.is_getter = true
		self.attr = attr
		self.name = name
	end



local prop = {}

	prop.prop = function(type_str, options, default)
		return Prop:New(type_str, options, default)
	end

	prop.getter = function (attr, name)
		return Getter:New(attr, name)
	end

return prop

