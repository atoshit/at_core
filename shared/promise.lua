---@namespace core.promise
---@class Promise
---@field private p promise.promise

---@param func function
---@return Promise
local function Async(func)
    local p = promise.new()
    CreateThread(function()
        func(function(value)
            p:resolve(value)
        end, function(err)
            p:reject(err)
        end)
    end)
    return p
end

---@param func function
---@return table
local function PromiseNew(func)
    local p = Async(func)
    return setmetatable({}, {
        __index = {
            Then = function(self, fulfilled)
                p = p:next(fulfilled)
                return self
            end,
            Catch = function(self, rejected)
                p = p:next(nil, rejected)
                return self
            end
        }
    })
end

core.promise = {
    Async = Async,
    New = PromiseNew
}
