
Types = {}


local ClassMgr = {}

function ClassMgr:RegisterClass(Name, Type)
    if not Types[Name] then
        Types[Name] = Type
    end
end

function ClassMgr:GetClass(Name)
    return Types[Name]
end

return ClassMgr