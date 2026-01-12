local QBCore = exports['qb-core']:GetCoreObject()
local activeZones = {}
local isUnderAttack = false

function isInCircle(pos, center, radius, minZ, maxZ)
    local dist2D = #(vector2(pos.x, pos.y) - vector2(center.x, center.y))
    return dist2D <= radius and pos.z >= minZ and pos.z <= maxZ
end

function isInRectangle(pos, x1, y1, x2, y2, minZ, maxZ)
    local inX = pos.x >= math.min(x1, x2) and pos.x <= math.max(x1, x2)
    local inY = pos.y >= math.min(y1, y2) and pos.y <= math.max(y1, y2)
    return inX and inY and pos.z >= minZ and pos.z <= maxZ
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)

        for _, zone in ipairs(Config.Zones) do
            local inZone = false
            if zone.type == "circle" then
                inZone = isInCircle(playerPos, zone.center, zone.radius, zone.minZ, zone.maxZ)
            else
                inZone = isInRectangle(playerPos, zone.coords.x1, zone.coords.y1, zone.coords.x2, zone.coords.y2, zone.minZ, zone.maxZ)
            end

            local key = zone.id
            if inZone and not activeZones[key] then
                activeZones[key] = true
                TriggerServerEvent('gang_territory:playerEnteredZone', zone)
            end

            if not inZone and activeZones[key] then
                activeZones[key] = nil
                TriggerServerEvent('gang_territory:playerLeftZone', zone.id)
            end
        end
    end
end)

-- Ouvrir le menu F6
RegisterCommand('gangmenu', function()
    TriggerEvent('gang_territory:openMenu')
end, false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 168) then -- F6
            TriggerEvent('gang_territory:openMenu')
        end
    end
end)