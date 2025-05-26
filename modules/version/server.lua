-- Thanks ox lib for the version system
-- https://github.com/overextended/ox_lib/blob/master/resource/version/server.lua 

--- Check version of a resource
---@param r string : Repository name
---@return nil
local function check(r)
    local resource = GetInvokingResource() or GetCurrentResourceName()

	local current_version = GetResourceMetadata(resource, 'version', 0)

	if current_version then
		current_version = current_version:match('%d+%.%d+%.%d+')
	end

	if not current_version then return print(("^1Unable to determine current resource version for '%s' ^0"):format(resource)) end

	SetTimeout(1000, function()
		PerformHttpRequest(('https://api.github.com/repos/%s/releases/latest'):format(r), function(status, response)
			if status ~= 200 then return end

			response = json.decode(response)
			if response.prerelease then return end

			local latest_version = response.tag_name:match('%d+%.%d+%.%d+')
			if not latest_version or latest_version == current_version then return end

            local cv = { string.strsplit('.', current_version) }
            local lv = { string.strsplit('.', latest_version) }

            for i = 1, #cv do
                local current, minimum = tonumber(cv[i]), tonumber(lv[i])

                if current ~= minimum then
                    if current < minimum then
                        return warn("\nNew version of "..resource.." available \nCurrent version: "..current_version.."\nLatest version: "..latest_version.." (" .. response.html_url .. ")\nPlease update your resource")
                    else break end
                end
            end
		end, 'GET')
	end)
end

return check