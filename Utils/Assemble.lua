
local function AssembleComponents(M, _components, for_reload)
	local NameToFuncTable = {}
	for name, value in pairs(M.__Dict__) do
		if type(value) == "function" then
			if NameToFuncTable[name] == nil then
				NameToFuncTable[name] = {}
			end
			table.insert(NameToFuncTable[name], value)
		end
	end

	local components
	if _components then
		components = _components
	else
		components = rawget(M, "__Component__")
	end
	if type(components) == "table" then
		for _, component_name in ipairs(components) do
			if for_reload then
				package.loaded[component_name] = nil
			end
			local component = require(component_name)
			for name, value in pairs(component) do
				if type(value) == "function" then
					if NameToFuncTable[name] == nil then
						NameToFuncTable[name] = {}
					end
					table.insert(NameToFuncTable[name], value)
				end
			end
		end
	end

	for name, func_t in pairs(NameToFuncTable) do
		if #func_t == 1 then
			-- rawset(M, name, func_t[1])
			M[name] = func_t[1]
		else
			local function wrapper(...)
				for _, func in ipairs(func_t) do
					func(...)
				end
			end
			-- rawset(M, name, _wrapper)
			M[name] = wrapper
		end
	end
end


local function FormatProperties(M)
	local props = {}
	local save_props = {}
	local client_props = {}
	local getters = {}

	local implement_name = rawget(M, "__Props__")
	local implement = nil
	if type(implement_name) == "table" then
		implement = implement_name
	else
		implement = require(implement_name)
	end

	for name, prop in pairs(implement) do
		if prop.is_prop then
			prop:SetName(name)

			props[name] = prop
			if prop.save then
				table.insert(save_props, name)
			end
			if prop.client then
				table.insert(client_props, name)
			end
		elseif prop.is_getter then
			getters[name] = prop
		end
	end

	M["Props"] = props
	M["SaveProps"] = save_props
	M["ClientProps"] = client_props
	M["Getters"] = getters

	rawset(M, "__Props__", nil)
end

return {
	AssembleComponents = AssembleComponents,
	FormatProperties = FormatProperties,
}