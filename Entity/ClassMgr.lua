local CommonUtils = require "Utils.CommonUtils"
Classes = {}
Types = {}

local ClassMgr = {}

function ClassMgr:RegisterClass(Name, Type)
    if not Classes[Name] then
        Classes[Name] = Type
    end
end

function ClassMgr:GetClass(Name)
    return Classes[Name]
end

function ClassMgr:GetType(Name)
    if Types[Name] ~= nil then
		return Types[Name]
	end

    local BaseTypes = require "Type.BaseType"
    local CustomTypes = {}

	if BaseTypes[Name] ~= nil then
		return BaseTypes[Name]
	elseif CustomTypes[Name] ~= nil then
		return CustomTypes[Name]
	else
		local split_str = CommonUtils.Split(Name, ".")
		local module_name = "Type." .. split_str[1]
		local type_name = split_str[2]
		local module = require(module_name)
		if module ~= nil then
			Types[Name] = module[type_name]
			return Types[Name]
		end
	end
end

return ClassMgr