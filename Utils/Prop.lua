local CommonUtils = require "Utils.CommonUtils"
local Class = require "Utils.Class".Class
local IsInstance = require "Utils.Class".IsInstance
local ClassMgr = require "Entity.ClassMgr"

local Prop = Class("Prop")

	function Prop:Init(type_str, options, default, ...)
		self.is_prop = true

		if type(type_str) == "string" then
			self.type_str = type_str
			self:ParseType(type_str)
		end

		self:ParseOptions(options)
		if default then
			self.default = default
		end
	end

	function Prop:ParseType(type_str)
		local class = ClassMgr:GetType(type_str)
		if class then
			self.type = self.type_str
			self.type_str = nil
		end
	end

	function Prop:ParseOptions(options)
		self.save = false
		self.client = false
		for k, v in pairs(CommonUtils.Split(options, " ")) do
			self[v] = true
		end
	end

	function Prop:SetName(name)
		self.name = name
		self.set_notifier = "_OnSet"..name
		self.change_notifier = "_OnChange"..name
	end

	function Prop:GetDefault()
		if self.default then
			return self.default
		end
		local type = ClassMgr:GetType(self.type)
		return type:GetDefault()
	end

	function Prop:GetTypeInstance(value)
		-- 得到类型的实例 load
		local type = ClassMgr:GetType(self.type)
		return type:convert(value)
	end

	function Prop:GetSaveDump(value)
		local type = ClassMgr:GetType(self.type)
		return type:save_dump(value)
	end

	function Prop:GetClientDump(value)
		local type = ClassMgr:GetType(self.type)
		return type:client_dump(value)
	end

	function Prop:GetAllDump(value)
		local type = ClassMgr:GetType(self.type)
		return type:all_dump(value)
	end




local prop = {}

	prop.prop = function(type_str, options, default)
		return Prop(type_str, options, default)
	end


return prop

