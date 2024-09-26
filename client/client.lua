ESX = exports['es_extended']:getSharedObject()

local coPin = nil
local responseDef = nil

local LastFailed = 0
local Timers = 0

function sendNuiEvent(moduleName,eventName, eventData)
    local payload = {
        moduleName = moduleName,
        functionName = eventName,
        argsList = eventData
    }
    SendNUIMessage(payload)
end

RegisterNUICallback('NS-Pin:PinResponse', function(data, cb)
    responseDef = data.success
    if data.escape then
        responseDef = nil
        local sc, err = coroutine.close(coPin)
        coPin = nil
        SetNuiFocus(false, false)
        return
    end
    coroutine.resume(coPin)
    SetNuiFocus(false, false)
    cb(true)
end)

function ConvertMStoSeconds(ms)
    local seconde = 0
    local minute = 0
    local heure = 0
    if ms / 1000 >= 60 then
        seconde = ms / 1000 % 60
        minute = ms / 1000 / 60
        if minute >= 60 then
            heure = minute / 60
            minute = minute % 60
        end
    else
        seconde = ms / 1000
    end
    if heure == 0 then
        if minute == 0 then
            return "Seconde : " .. math.floor(seconde)
        end
        return "Minute : " .. math.floor(minute) .. " Seconde : " .. math.floor(seconde)
    end
    return "Heure : " .. math.floor(heure) .. " Minute : " .. math.floor(minute) .. " Seconde : " .. math.floor(seconde)
end

exports('CreatePIN', function(code, Label, cb)
    if Timers > GetGameTimer() then
        Config.Notification('Vous avez entré un code pin incorrect '..Config.MaxFailed..' fois de suite veuillez attendre encore '..ConvertMStoSeconds(Timers - GetGameTimer()))
        return
    end
    Timers = 0
    sendNuiEvent('NS-Pin', 'SetPinInterface', {code = code, open = true, label = Label})
    SetNuiFocus(true, true)
    coPin = coroutine.create(function()
        if responseDef ~= nil then
            SetNuiFocus(false, false)
            cb(responseDef)
            if not responseDef then
                LastFailed += 1
                if LastFailed >= Config.MaxFailed then
                    TriggerServerEvent('NS-Pin:webhook:logsDiscord', 'Echec code Pin', "Code Pin : "..code, "A entrer un code pin incorrect 3 fois de suite", 'warning')
                    Config.Notification('Vous avez entré un code pin incorrect '..Config.MaxFailed..' fois de suite')
                    Timers = GetGameTimer() + Config.MaxFailedTimer * 10 * 100
                    LastFailed = 0
                else
                    TriggerServerEvent('NS-Pin:webhook:logsDiscord', 'Echec code Pin', "Code Pin : "..code, '', 'error')
                end
            end
            if responseDef then
                TriggerServerEvent('NS-Pin:webhook:logsDiscord', 'Réussite code Pin', "Code Pin : "..code, '', 'success')
                LastFailed = 0
            end
            responseDef = nil
            coroutine.close(coPin)
            coPin = nil
        end
    end)
end)


Citizen.CreateThread(function()
    while not ESX.GetPlayerData().job do
        Citizen.Wait(10)
    end
    Wait(1 * 1000)
    sendNuiEvent('NS-Pin', 'SetColors', {colors = Config.Color})
    sendNuiEvent('NS-Pin', 'SetConfig', {config = Config.Sounds})
    print("^1[NS-Pin]^0 Chargement terminé")
end)