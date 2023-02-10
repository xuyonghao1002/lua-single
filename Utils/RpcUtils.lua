local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local CommonUtils = require "Utils.CommonUtils"

local RpcUtils = {}

CustomTypeMap = {}

function RpcUtils.GetClass(type_str)
	if CustomTypeMap[type_str] ~= nil then
		return CustomTypeMap[type_str]
	end

	if BaseTypes[type_str] ~= nil then
		return BaseTypes[type_str]
	elseif CustomTypes[type_str] ~= nil then
		return CustomTypes[type_str]
	else
		local split_str = CommonUtils.Split(type_str, ".")
		local module_name = "BluePrints.Client.CustomTypes." .. split_str[1]
		local type_name = split_str[2]
		local module = require(module_name)
		if module ~= nil then
			CustomTypeMap[type_str] = module[type_name]
			return CustomTypeMap[type_str]
		end
	end
end

function RpcUtils.RevertArgs(Args)
	if type(Args) ~= "table" then
		return Args
	end
	if next(Args) == nil then
		return Args
	end
	local Result = {}
	for _, Arg in ipairs(Args) do
		table.insert(Result, RpcUtils.DumpArg(Arg))
	end
	return Result
end

function RpcUtils.DumpArg(Arg)
	if type(Arg) == "table" and Arg.IsCustomType then
		assert(Arg.__type, "error, this custom type has no __type!")
		local ArgDump = {}
		ArgDump.__type = Arg.__type
		ArgDump.value = Arg.all_dump(Arg, Arg)
		return ArgDump
	else
		return Arg
	end
end


function RpcUtils.ConvertArgs(Args)
	if type(Args) ~= "table" then
		return Args
	end
	if next(Args) == nil then
		return Args
	end
	local Result = {}
	for _, Arg in ipairs(Args) do
		table.insert(Result, RpcUtils.LoadArg(Arg))
	end
	return Result
end

function RpcUtils.LoadArg(Arg)
	if type(Arg) == "table" and Arg.__type and Arg.value then
		local Type = RpcUtils.GetClass(Arg.__type)
		if Type then
			return Type.convert(Type, Arg.value)
		end
	else
		return Arg
	end
end

return RpcUtils
