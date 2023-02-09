local ClassMeta = {}
local InstanceMeta = {}
local ClassModule = {}

local function Deque()
    local self = { }
    self._Items = { }
    self._Front = 0
    self._Back = 0
    function self:PushFront(Item)
        if Item == nil then
            error('cannot push nil onto the deque')
        end
        self._Front = self._Front - 1
        self._Items[self._Front] = Item
    end
    function self:PopFront()
        local Item = self._Items[self._Front]
        self._Items[self._Front] = nil
        if Item then
            self._Front = self._Front + 1
        end
        return Item
    end
    function self:PushBack(Item)
        if Item == nil then
        error('cannot push nil onto the deque')
        end
        self._Items[self._Back] = Item
        self._Back = self._Back + 1
    end
    function self:PopBack()
        local Item = self._Items[self._Back-1]
        self._Items[self._Back-1] = nil
        if Item then
            self._Back = self._Back - 1
        end
        return Item
    end
    function self:Size()
        return self._Back - self._Front
    end
    function self:Items()
        return pairs(self._Items)
    end
    function self:Empty()
        return not (next(self._Items) and true or false)
    end
    return self
end

local function Class(super)
	local Base = super
    if not Base then
        Base = ClassModule.Object
    end

	local MroVec = {}
	local MroSet = {}
	local NewClass = {}
	local Q = Deque()
    Q:PushBack(Base)

	table.insert(MroVec, NewClass)
	while not Q:Empty() do
		local FrontItem = Q:PopFront()
		for _, Item in ipairs(FrontItem.__Base__) do
			Q:PushBack(Item)
		end
		if not MroSet[FrontItem] then
			MroSet[FrontItem] = FrontItem
			table.insert(MroVec, FrontItem)
		end
	end
	NewClass.__Name__ = nil
	NewClass.__Base__ = Base
	NewClass.__Mro__ = MroVec
	NewClass.__Dict__ = {}
	NewClass.__Class__ = {__Dict__={}, __Mro__={}}

	setmetatable(NewClass, ClassMeta)
	return NewClass
end




-- ClassModule


return Class
