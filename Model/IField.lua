IField = {}

function IField:new()
    local obj = {}

    function obj:Init()
    end

    function obj:Tick()
    end

    function obj:Move()
    end

    function obj:Mix()
    end

    function obj:Dump()
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end
