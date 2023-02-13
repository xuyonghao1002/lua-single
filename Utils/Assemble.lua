
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


PropIndex = function (T, key)
	local attr = rawget(T, "Props")[key]
	if attr then
		attr.type.SetOwnerInfo(attr.value, T, attr)
		return attr.value
	end
	attr = rawget(T, "Getters")[key]
	if attr then
		local _attr = rawget(T, attr.attr)
		if type(_attr) == "table" then
			return _attr[attr.name]
		elseif type(_attr) == "function" then
			return _attr(T)[attr.name]
		end
	end
end

PropNewIndex = function (T, key, value)
	local attr = rawget(T, "Props")[key]
	if attr then
		local _value = attr.type.convert(attr.type, value)
		attr.type.SetOwnerInfo(_value, T, attr)
		attr.value = _value
		if rawget(T, "_OnPropChange") then
			T:_OnPropChange(attr, value)
		end
	else
		rawset(T, key, value)
	end
end

PropMetaTable = {
	__index = PropIndex,
	__newindex = PropNewIndex
}


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

	for name, attr in pairs(implement) do
		if attr.is_prop then
			attr:SetName(name)

			props[name] = attr
			if attr.save then
				table.insert(save_props, name)
			end
			if attr.client then
				table.insert(client_props, name)
			end
		elseif attr.is_getter then
			getters[name] = attr
		end
	end

	M["Props"] = props
	M["SaveProps"] = save_props
	M["ClientProps"] = client_props
	M["Getters"] = getters
end

return {
	AssembleComponents = AssembleComponents,
	FormatProperties = FormatProperties,
}