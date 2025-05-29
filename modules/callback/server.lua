local TABLE_UNPACK <const> = table.unpack
local PREFIX <const> = 'at_core:callback'
local AWAIT <const> = Citizen.Await
local PENDING <const> = 0

local callbacks = {}

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
		RegisterNetEvent(PREFIX..':server:request', function(name, requestId, source, data)
			local cb = callbacks[name]
			if cb then
				local result = {cb(source, TABLE_UNPACK(data or {}))}
				TriggerClientEvent(PREFIX..':client:response', source, requestId, result)
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

--- Emit a callback to the client
---@param args table
---@param args.source number|string
---@param args.eventName string
---@param args.args table?
---@param args.timeout number?
---@param args.timedout function?
---@param args.callback function?
local function callClient(args)
	ensure(args, 'table'); ensure(args.source, 'string', 'number'); ensure(args.eventName, 'string'); ensure(args.args, 'table', 'nil'); ensure(args.timeout, 'number', 'nil'); ensure(args.timedout, 'function', 'nil'); ensure(args.callback, 'function', 'nil')
	local source = tonumber(args.source)
	if not source or source < 0 then
		error('(func: callClient) source must be greater than 0')
		return
	end
	local requestId = PREFIX .. ':' .. args.eventName .. ':' .. os.time() .. ':' .. math.random(100000, 999999)
	local prom = promise.new()
	local eventCallback = args.callback
	
	local eventHandler
	eventHandler = RegisterNetEvent(PREFIX..':server:response', function(id, data, src)
		if src ~= source or id ~= requestId then return end
		
		if eventCallback and prom.state == PENDING then 
			eventCallback(TABLE_UNPACK(data or {})) 
		end
		
		prom:resolve(TABLE_UNPACK(data or {}))
		RemoveEventHandler(eventHandler)
	end)
	TriggerClientEvent(PREFIX..':client:request', source, args.eventName, requestId, args.args or {})
	if args.timeout and args.timeout > 0 then
		SetTimeout(args.timeout * 1000, function()
			if prom.state == PENDING then
				if args.timedout then args.timedout() end
				prom:reject('timeout')
				RemoveEventHandler(eventHandler)
			end
		end)
	end
	if not eventCallback then
		local result = AWAIT(prom)
		return result
	end
end

--- Emit a callback to server
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
		error('(func: call) Unregistered server callback: ' .. args.eventName)
		return
	end
	
	local prom = promise.new()
	local result = {cb(args.source or -1, TABLE_UNPACK(args.args or {}))}
	
	if args.callback then
		args.callback(TABLE_UNPACK(result))
	else
		prom:resolve(TABLE_UNPACK(result))
		return AWAIT(prom)
	end
end

return {
    register = register,
    unregister = unregister,
    callClient = callClient,
    call = call
}