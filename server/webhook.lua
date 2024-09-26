local ESX = exports['es_extended']:getSharedObject()

local success_url_webhook = ""
local error_url_webhook = ""
local warning_url_webhook = ""

local icon_url = ''
local logsDiscord = function(header, message, desc, src, webhook_url)
    -- Vérifie si les logs sont activés

    -- Vérifie si la source (joueur) est spécifiée
    if not src then
        return
    end
    local xPlayer = ESX.GetPlayerFromId(src)
    -- Vérifie si le titre du message est spécifié, sinon utilise "Logs" par défaut
    if not header then
        header = "Logs NS-Pin"
    end

    -- Vérifie si le contenu principal du message est spécifié, sinon utilise "Aucun message" par défaut
    if not message then
        message = "Aucun message"
    end

    -- Vérifie si la description est spécifiée, sinon utilise "Aucune description" par défaut
    if not desc then
        desc = "Aucune description"
    end

    -- Crée le message à envoyer au webhook Discord sous forme d'objet JSON
    local message = {
        embeds = {{
            ["color"] = 3092790,
            ["author"] = {
                ["name"] = "Logs NS-Pin",
                ["icon_url"] = icon_url
            },
            ["title"] = "Logs Interaction Code",
            ["fields"] = {
                {
                    ["name"] = "Logs (" .. GetPlayerName(src) .. ")",
                    ["value"] = "Nom RP : " .. xPlayer.getName().. " | ID : " .. src,
                    ["inline"] = true
                },
                {
                    ["name"] = "identifiers",
                    ["value"] = "||" .. table.concat(GetPlayerIdentifiers(src), ", ") .. "||"
                },
                {
                    ["name"] = "Raison",
                    ["value"] = "" .. header .. ""
                },
                {
                    ["name"] = "Message",
                    ["value"] = "" .. message .. ""
                },
                {
                    ["name"] = "Description",
                    ["value"] = "" .. desc .. ""
                },
            },
            ["footer"] = {
                ["text"] = "2024 - "..os.date("%Y").." Nokiki©• "..os.date("%x %X %p"),
                ["icon_url"] = icon_url,
            },
        }},
        avatar_url = icon_url
    }

    -- Envoie le message au webhook Discord via une requête HTTP POST
    PerformHttpRequest(webhook_url, function(err, text, headers) end, 'POST', json.encode(message), { ['Content-Type'] = 'application/json' })
end


RegisterServerEvent('NS-Pin:webhook:logsDiscord', function(header, message, desc, types)
    local src = source
    if types == 'success' then
        logsDiscord(header, message, desc, src, success_url_webhook)
    end
    if types == 'error' then
        logsDiscord(header, message, desc, src, error_url_webhook)
    end
    if types == 'warning' then
        logsDiscord(header, message, desc, src, warning_url_webhook)
    end
end)