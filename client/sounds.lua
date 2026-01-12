-- Jouer son d'alerte
function PlayGangSound(gang)
    local soundFile = Config.GangSounds[gang]
    if soundFile then
        SendNUIMessage({
            action = "PLAY_SOUND",
            file = soundFile
        })
    end
end

RegisterNetEvent('gang_territory:playInvasionSound')
AddEventHandler('gang_territory:playInvasionSound', function(gang)
    PlayGangSound(gang)
end)

-- ALERTE VISUELLE CLIGNOTANTE
RegisterNetEvent('gang_territory:flashScreen')
AddEventHandler('gang_territory:flashScreen', function(duration)
    if not Config.InvasionAlert.enabled then return end

    local endTime = GetGameTimer() + (duration or Config.InvasionAlert.duration)
    local interval = Config.InvasionAlert.flashInterval
    local r, g, b = unpack(Config.InvasionAlert.flashColor)
    local alpha = 180

    Citizen.CreateThread(function()
        while GetGameTimer() < endTime do
            Citizen.Wait(interval)
            DrawRect(0.5, 0.5, 2.0, 2.0, r, g, b, alpha)
            Citizen.Wait(100)
            DrawRect(0.5, 0.5, 2.0, 2.0, 0, 0, 0, 0)
        end
    end)
end)

RegisterNetEvent('gang_territory:startInvasionAlert')
AddEventHandler('gang_territory:startInvasionAlert', function(duration)
    TriggerEvent('gang_territory:flashScreen', duration)
end)