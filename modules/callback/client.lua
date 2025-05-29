--[[
    https://github.com/atoshit/at_core

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Atoshi <https://github.com/atoshit>
]]

local SERVER_ID <const> = GetPlayerServerId(PlayerId())
print('SERVER_ID: '.. SERVER_ID, type(SERVER_ID))
local PREFIX <const> = 'at_core:callback'
local TABLE_UNPACK <const> = table.unpack
local AWAIT <const> = Citizen.Await
local PENDING <const> = 0

local callbacks = {}
local requestsAwaitingResponse = {}

---@param obj any
---@param typeof string
---@param opt_typeof string?
---@param errMessage string?
local function ensure(obj, typeof, opt_typeof, errMessage)
	local objtype = type(obj)
	local di = debug.getinfo(2)
	local errMessage = errMessage or (opt_typeof == nil and (di.name .. ' expected %s, but got %s') or (di.name .. ' expected %s or %s, but got %s'))
	if typeof ~= 'function' then
		if objtype ~= typeof and objtype ~= opt_typeof then
			error((errMessage):format(typeof, (opt_typeof == nil and objtype or opt_typeof), objtype))
		end
	else
		if objtype == 'table' and not rawget(obj, '__cfx_functionReference') then
			error((errMessage):format(typeof, (opt_typeof == nil and objtype or opt_typeof), objtype))
		end
	end
end

--- Register a callback
---@param args table
---@param args.eventName string
---@param args.eventCallback function
local function register(args)
    ensure(args, 'table'); ensure(args.eventName, 'string'); ensure(args.eventCallback, 'function')
		
	local eventName = args.eventName
	local eventCallback = args.eventCallback
	
	callbacks[eventName] = eventCallback
	
	if not callbacks.__initialized then
		RegisterNetEvent(PREFIX..':client:request', function(name, requestId, data)
			local cb = callbacks[name]
			if cb then
				local result = {cb(TABLE_UNPACK(data or {}))}
				TriggerServerEvent(PREFIX..':server:response', requestId, result, SERVER_ID)
			end
		end)
		callbacks.__initialized = true
	end
	
	return eventName
end

--- Unregister a callback
---@param eventName string
local function unregister(eventName)
	callbacks[eventName] = nil
end

--- Emit a callback to the server
---@param args table
---@param args.eventName string
---@param args.args table?
---@param args.timeout number?
---@param args.timedout function?
---@param args.callback function?
local function callServer(args)
    ensure(args, 'table'); ensure(args.eventName, 'string'); ensure(args.args, 'table', 'nil'); ensure(args.timeout, 'number', 'nil'); ensure(args.timedout, 'function', 'nil'); ensure(args.callback, 'function', 'nil')
		
	local requestId = PREFIX .. ':' .. args.eventName .. ':' .. GetGameTimer() .. ':' .. math.random(100000, 999999)
	local prom = promise.new()
	local eventCallback = args.callback
	
	if not requestsAwaitingResponse.__initialized then
		RegisterNetEvent(PREFIX..':client:response', function(id, data)
			local request = requestsAwaitingResponse[id]
			if not request then return end
			
			if request.callback and request.promise.state == PENDING then 
				request.callback(TABLE_UNPACK(data or {})) 
			end
			
			request.promise:resolve(TABLE_UNPACK(data or {}))
			requestsAwaitingResponse[id] = nil
		end)
		requestsAwaitingResponse.__initialized = true
	end
	
	requestsAwaitingResponse[requestId] = {
		promise = prom,
		callback = eventCallback,
		time = GetGameTimer()
	}

	TriggerServerEvent(PREFIX..':server:request', args.eventName, requestId, SERVER_ID, args.args or {})

	if args.timeout and args.timeout > 0 then
		SetTimeout(args.timeout * 1000, function()
			local request = requestsAwaitingResponse[requestId]
			if request and request.promise.state == PENDING then
				if args.timedout then args.timedout() end
				request.promise:reject('timeout')
				requestsAwaitingResponse[requestId] = nil
			end
		end)
	end

	if not eventCallback then
		local result = AWAIT(prom)
		return result
	end
end

--- Emit a callback to the client
---@param args table
---@param args.eventName string
---@param args.args table?
---@param args.timeout number?
---@param args.timedout function?
---@param args.callback function?
local function call(args)
    ensure(args, 'table'); ensure(args.eventName, 'string'); ensure(args.args, 'table', 'nil'); ensure(args.timeout, 'number', 'nil'); ensure(args.timedout, 'function', 'nil'); ensure(args.callback, 'function', 'nil')

	local cb = callbacks[args.eventName]
	if not cb then
		error('(func: call) Unregistered client callback: ' .. args.eventName)
		return
	end
	
	local prom = promise.new()
	local result = {cb(TABLE_UNPACK(args.args or {}))}
	
	if args.callback then
		args.callback(TABLE_UNPACK(result))
	else
		prom:resolve(TABLE_UNPACK(result))
		return AWAIT(prom)
	end
end

CreateThread(function()
    while true do
        Wait(30000) 
        local currentTime = GetGameTimer()
        for id, request in pairs(requestsAwaitingResponse) do
            if id ~= "__initialized" and currentTime - request.time > 60000 then 
                if request.promise.state == PENDING then
                    request.promise:reject('timeout')
                end
                requestsAwaitingResponse[id] = nil
            end
        end
    end
end)

return {
    register = register,
    unregister = unregister,
    callServer = callServer,
    call = call
}