local CB = at.LoadModule('callback')

CB.register({
    eventName = 'at_core:loadPlayer',
    eventCallback = function(source)
        at.CreatePlayer(source, {rank = "admin"})

        local player = at.GetPlayer(source)

        if not player then return end

        return {
            coords = false,
            skin = {}
        }
    end
})