local QBCore = exports['qb-core']:GetCoreObject()
local hostilePeds = {}
local zoneCaptures = {}

RegisterNetEvent('gang_territory:playerEnteredZone')
AddEventHandler('gang_territory:playerEnteredZone', function(zone)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    if not xPlayer then return end

    local playerGang = xPlayer.PlayerData.job.name
    if playerGang == zone.gang then return end

    -- 🔴 ALERTE INVASION
    TriggerClientEvent('gang_territory:startInvasionAlert', -1, Config.InvasionAlert.duration)

    -- 🔊 Alert membres du gang
    for _, id in ipairs(GetPlayers()) do
        local target = QBCore.Functions.GetPlayer(id)
        if target and target.PlayerData.job.name == zone.gang then
            TriggerClientEvent('gang_territory:playInvasionSound', id, zone.gang)
        end
    end

    -- 🌐 Webhook
    if Config.DiscordWebhook ~= "" then
        PerformHttpRequest(Config.DiscordWebhook, function() end, 'POST',
            json.encode({ embeds = {{
                title = "ALERTE INVASION",
                description = string.format("**%s** (%s) entre dans **%s** (gang: **%s**)",
                    GetPlayerName(src), GetPlayerIdentifier(src, 0), zone.name, zone.gang),
                color = 16711680
            }}}), { ['Content-Type'] = 'application/json' })
    end

    -- 📉 Perte de réputation
    if Config.Reputation.enabled then
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(1000)
                local target = QBCore.Functions.GetPlayer(src)
                if not target then break end
                if target.PlayerData.job.name == zone.gang then break end

                local rep = target.PlayerData.metadata['reputation'] or 0
                rep = math.max(Config.Reputation.min, rep - Config.Reputation.lossPerSecond)
                target.Functions.SetMetaData('reputation', rep)
            end
        end)
    end

    -- 👥 Spawn PNJ
    if Config.HostileNPCs.enabled then
        Citizen.SetTimeout(Config.HostileNPCs.spawnDelay, function()
            local pedSrc = GetPlayerPed(src)
            if DoesEntityExist(pedSrc) then
                local peds = {}
                local coords = GetEntityCoords(pedSrc)
                for i = 1, Config.HostileNPCs.count do
                    local offset = vector3(math.random(-10, 10), math.random(-10, 10), 0)
                    local spawnPos = coords + offset

                    RequestModel(Config.HostileNPCs.model)
                    while not HasModelLoaded(Config.HostileNPCs.model) do Citizen.Wait(10) end

                    local ped = CreatePed(26, GetHashKey(Config.HostileNPCs.model), spawnPos.x, spawnPos.y, spawnPos.z, 0.0, true, false)
                    SetEntityInvincible(ped, false)
                    GiveWeaponToPed(ped, GetHashKey(Config.HostileNPCs.weapon), 200, false, true)
                    TaskCombatPed(ped, pedSrc, 0, 16)
                    table.insert(peds, ped)
                end
                hostilePeds[src] = peds
            end
        end)
    end
end)

RegisterNetEvent('gang_territory:playerLeftZone')
AddEventHandler('gang_territory:playerLeftZone', function(zoneId)
    local src = source
    if hostilePeds[src] then
        for _, ped in ipairs(hostilePeds[src]) do
            if DoesEntityExist(ped) then DeleteEntity(ped) end
        end
        hostilePeds[src] = nil
    end
end)

-- Capture de zone
RegisterNetEvent('gang_territory:startCapture')
AddEventHandler('gang_territory:startCapture', function(zoneId)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    if not xPlayer then return end

    local playerGang = xPlayer.PlayerData.job.name
    local zone = nil
    for _, z in ipairs(Config.Zones) do
        if z.id == zoneId then zone = z break end
    end
    if not zone or playerGang == zone.gang then return end

    zone.capturingGang = playerGang
    zone.captureProgress = 0

    QBCore.Functions.Notify(("Attaque sur %s !"):format(zone.name), "error")

    zoneCaptures[zoneId] = Citizen.SetInterval(function()
        if not zone.capturingGang then
            Citizen.ClearInterval(zoneCaptures[zoneId])
            return
        end

        zone.captureProgress = zone.captureProgress + (100 / (Config.Capture.timeToCapture / 1000))
        if zone.captureProgress >= 100 then
            zone.gang = playerGang
            zone.capturingGang = nil
            zone.captureCooldown = os.time() + (Config.Capture.cooldownAfterCapture / 1000)
            QBCore.Functions.Notify(("%s est maintenant contrôlé par %s"):format(zone.name, playerGang), "success")
            Citizen.ClearInterval(zoneCaptures[zoneId])
        end
    end, 1000)
end)