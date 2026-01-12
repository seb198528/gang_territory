local isInMenu = false
local currentZoneData = nil

RegisterNetEvent('gang_territory:openMenu')
AddEventHandler('gang_territory:openMenu', function(zoneData)
    if not zoneData then
        QBCore.Functions.Notify("Aucune zone à proximité", "error")
        return
    end

    currentZoneData = zoneData
    isInMenu = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "OPEN_MENU",
        zone = zoneData
    })
end)

RegisterNUICallback('closeMenu', function(_, cb)
    isInMenu = false
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('startCapture', function(_, cb)
    if currentZoneData then
        TriggerServerEvent('gang_territory:startCapture', currentZoneData.id)
    end
    cb('started')
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isInMenu and IsControlJustPressed(0, 209) then -- ÉCHAP
            SetNuiFocus(false, false)
            isInMenu = false
        end
    end
end)