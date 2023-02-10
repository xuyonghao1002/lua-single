
PrintTable = function(Targets, Deep, Title)
	if type(Targets) ~= "table" then
		Targets = {Targets}
	end
	Deep = Deep or 1
	local function get_table_str(t, step)
		local s = ""
		for k,v in pairs(t) do
			for i = 1, step do
				s = s.."\t"
			end
			local _type = type(v)

			local k_str = nil
			local v_str = nil
			k_str = tostring(k)
			v_str = tostring(v)
			s = s..k_str.." ("..tostring(type(k))..")"..": "..v_str.." ("..tostring(_type)..")".."\n"
			if type(v) == "table" and step < Deep then
				s = s..get_table_str(v, step + 1)
			end
		end
		return s
	end
	local ret = "PrintTable: "..tostring(Targets).."\n"
	if Title then
		ret = ret .. tostring(Title) .. ':\n'
	end
	if Targets then
		ret = ret..get_table_str(Targets, 1)
	end
	print(ret)
end