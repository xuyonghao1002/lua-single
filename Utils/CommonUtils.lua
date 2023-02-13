-- local bson = require "bson"

local CommonUtils = {}

function CommonUtils.IsObjId(str)
	if #str == 14 and string.byte(string.sub(str,1,1)) == 0 then
        return true
    end
    return false
end

function CommonUtils.IsObjIdStr(ObjIdStr)
	if string.len(ObjIdStr) ~= 36 then
		return false
	end
	if string.sub(ObjIdStr, 1, 8) ~= "ObjectId" then
		return false
	end
	return true
end

function CommonUtils.ObjId2Str(ObjId)
	-- ObjId是一个长度为14的字符串
    local ret = ""
	if ObjId == nil then
		return ""
	end
	for index=3,#ObjId do
		ret = ret..string.format("%02X",string.byte(string.sub(ObjId,index,index)))
	end
	return "ObjectId(\""..ret.."\")"
end

function CommonUtils.Str2ObjId(ObjIdStr)
	if ObjIdStr == "" then
		return ""
	end
	if not CommonUtils.IsObjIdStr(ObjIdStr) then
		return ""
	end
	-- return bson.str2objectid(string.sub(ObjIdStr,11,34))
end

function CommonUtils.Split(str, reps)
    local Results = {}
    string.gsub(str,'[^'..reps..']+',function ( w )
        table.insert(Results, w)
    end)
    return Results
end

function CommonUtils.DeepCopy(Object)
	local function _copy(object)
		if type(object) ~= "table" then
			return object
		end
		local new_table = {}
		for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
	end
	return _copy(Object)
end

function CommonUtils.Copy(Object)
	local function _copy(object)
		if type(object) ~= "table" then
			return object
		end
		local new_table = {}
		for key, value in pairs(object) do
			new_table[_copy(key)] = _copy(value)
		end
		return new_table
	end
	return _copy(Object)
end

function CommonUtils.IsEqual(array1, array2)
	if #array1 ~= #array2 then
		return false
	end
	for index, value in ipairs(array1) do
		local value2 = array2[index]
		if type(value) ~= type(value2) then
			return false
		end
		if type(value) == "table" then
			if not CommonUtils.IsEqual(value, value2) then
				return false
			end
		else
			if value ~= array2[index] then
				return false
			end
		end
	end

	return true
end

function CommonUtils.AttrValueToString(AttrConfig,Value)
	if not AttrConfig then
		return Value
	end
	if AttrConfig['NumCorrect'] then
		Value=Value*AttrConfig['NumCorrect']
	end
	local percent=''
	if AttrConfig['IsPercent'] then
		Value=Value*100
		percent='%'
	end
	local a,b=math.modf(Value)
    if not  (math.abs(b - 0) < 10e-6 or math.abs(b - 1) < 10e-6) then
        local floor=math.floor(b*10^2+0.5)/10^2
        if floor ~= 0 then
            a= a + floor
        end
	else
		if b>0.5 then
			a=a+1
		end
    end
    local str=tostring(a)
    local k
    while true do
        str,k=string.gsub(str,"^(-?%d+)(%d%d%d)",'%1,%2')
        if k==0 then
            break
        end
    end
	return str..percent
end

function CommonUtils.RandomNumList(M, N, Cnt)
	local Tmp = {}
	for i = M, N do
		table.insert(Tmp, i)
	end
	if Cnt > N - M + 1 then
		return Tmp
	end
	local X = 0
	local T = {}
	while Cnt > 0 do
		X = math.random(1,N - M + 1)
		table.insert(T, Tmp[X])
		table.remove(Tmp, X)
		Cnt = Cnt - 1
		M = M + 1
	end
	return T
end

function CommonUtils.RemoveValue(Target, Value)
	if type(Target) ~= "table" then
		return
	end
	local _index = nil
	for index, value in ipairs(Target) do
		if value == Value then
			_index = index
			break
		end
	end
	if _index then
		table.remove(Target, _index)
	end
end

function CommonUtils.HasValue(Target, Value)
	if type(Target) ~= "table" then
		return false
	end
	for index, value in ipairs(Target) do
		if value == Value then
			return true
		end
	end
	return false
end

function CommonUtils.GetFixLocation(UObject, Loc, LocationExtraZ, StartZ, EndZ, TraceType)
	TraceType = TraceType or Const.FixTraceChannel.TraceCreatureHit
	local NewLoc = Loc
	-- 杨兴东说这里有trace先注释
	-- if (Info.ActorType=="Monster") then
	--     NewLoc = self:RandomPointInCircle(NewLoc,0,1600,0,360)
	-- end
	for _, Offsets in pairs(Const.SummonOffset) do
		local x = Offsets[1]
		local y = Offsets[2]
		local HitResult = FHitResult()
		local _NewLoc = FVector(Loc.X + x, Loc.Y + y, Loc.Z)
		local bHit = UE4.UKismetSystemLibrary.LineTraceSingle(UObject, _NewLoc + FVector(0, 0, StartZ or 0), _NewLoc + FVector(0, 0, EndZ or -500),
				Const.FixTraceChannel[TraceType], false, TArray(AActor), 0, HitResult, true,
				UE4.FLinearColor(math.random(0,1), math.random(0,1), math.random(0,1), 1), UE4.FLinearColor(math.random(0,1), math.random(0,1), math.random(0,1), 1),50)
		if bHit then
			-- 不在墙里
			if HitResult.ImpactPoint ~= _NewLoc then
				NewLoc = HitResult.ImpactPoint
				break
			end
		end
	end
	NewLoc = FVector(NewLoc.X, NewLoc.Y, NewLoc.Z + (LocationExtraZ or 50))
	return NewLoc
end

function CommonUtils.GetCapFixLocation(Character, Loc, LocationExtraZ, StartZ, EndZ, TraceType)
	TraceType = TraceType or Const.FixTraceChannel.TraceCreatureHit
	local NewLoc = Loc
	local OriginCapsuleRadius = Character.CapsuleComponent:GetUnscaledCapsuleRadius()
	local OriginHalfHeight = Character.CapsuleComponent:GetUnscaledCapsuleHalfHeight()
	for _, Offsets in pairs(Const.SummonOffset) do
		local x = Offsets[1]
		local y = Offsets[2]
		local HitResult = FHitResult()
		local _NewLoc = FVector(Loc.X + x, Loc.Y + y, Loc.Z)
		local bHit = UE4.UKismetSystemLibrary.CapsuleTraceSingle(Character, _NewLoc + FVector(0, 0, StartZ or 0), _NewLoc + FVector(0, 0, EndZ or -500),
				OriginCapsuleRadius, OriginHalfHeight,
				Const.FixTraceChannel[TraceType], false, nil, 0, HitResult, true, UE4.FLinearColor(1, 0, 0, 1),UE4.FLinearColor(0, 1, 0, 1),5)
		if bHit then
			-- 不在墙里
			if HitResult.Location ~= _NewLoc then
				NewLoc = HitResult.Location
				break
			end
		end
	end
	NewLoc = FVector(NewLoc.X, NewLoc.Y, NewLoc.Z + (LocationExtraZ or 50))
	return NewLoc
end

function CommonUtils.GetDeviceTypeByPlatformName(WorldContextObject)
	--- 传WorldContextObject的话可以通过编辑器下改PreviewDevices来切换平台
	local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(WorldContextObject)
	if (PlatformName == "IOS" or PlatformName == "Android") then
		return "Mobile"
	elseif (PlatformName == "Mac" or PlatformName == "Windows" ) then
		return "PC"
	end
end

function CommonUtils.Shuffle(T)
	local Count = #T
	while Count > 1 do
		local n = math.random(1, Count - 1)
		if T[n] ~= nil then
			T[Count], T[n] = T[n], T[Count]
			Count = Count - 1
		end
	end
end

function CommonUtils.Bind(t, f)
	return function (...)
		return f(t, ...)
	end
end

-- 数组取交集
function CommonUtils.Intersection_Table(T1, T2)
	local TempResult = {}
	for _, Target in pairs(T1) do
		TempResult[Target] = 1
	end
	local Results = {}
	for _, Target in pairs(T2) do
		if TempResult[Target] then
			table.insert(Results, Target)
		end
	end
	return Results
end

function CommonUtils.VectorToTable(Vector)
	return {
		X = Vector.X,
		Y = Vector.Y,
		Z = Vector.Z,
	}
end

function CommonUtils.TableToVector(VectorTable)
	return FVector(VectorTable.X, VectorTable.Y, VectorTable.Z)
end

function CommonUtils.NewEmptyProxy()
	local _EmptyProxy = {}
	setmetatable(_EmptyProxy, {
		__call = function()
			return nil
		end,
		__index = function()
			return _EmptyProxy
		end,
		__newindex = function()
			return nil
		end,
	})
	return _EmptyProxy
end

CommonUtils.EmptyProxy = CommonUtils.NewEmptyProxy()

return CommonUtils
