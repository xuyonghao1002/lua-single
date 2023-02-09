

local TypeMgr = {}

function TypeMgr:RegisterType(Name, Type)
    if not self.Types then
        self.Types = {}
    end
    if not self.Types[Name] then
        self.Types[Name] = Type
    end
end

function TypeMgr:GetType(Name)
    return self.Types[Name]
end

return TypeMgr