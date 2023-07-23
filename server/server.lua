ESX = exports["es_extended"]:getSharedObject()

CreateThread(function()
    print("KRS   KRS   KRSKRSKRS    KRSKRSKRS")
    print("KRS   KRS   KRS     KRS  KRS   KRS")
    print("KRS  KRS    KRS     KRS  KRS")
    print("KRSKRS      KRSKRSKRS    KRSKRSKRS")
    print("KRS   KRS   KRS    KRS         KRS")
    print("KRS    KRS  KRS    KRS   KRS   KRS")
    print("KRS    KRS  KRS     KRS  KRSKRSKRS")
    print('^8krs_reports initialized^0')
end)


RegisterNetEvent("krs_reports:SegnalaGiocatori")
AddEventHandler("krs_reports:SegnalaGiocatori", function(IdGiocatore, motivo)
    local src = source
    local name = GetPlayerName(src)
    local IdSteamDiscord = ExtractIdentifiers(IdGiocatore)
    local steam = IdSteamDiscord.steam:gsub("steam:", "")
    local steamDec = tostring(tonumber(steam, 16))
    steam = "https://steamcommunity.com/profiles/" .. steamDec
    local gameLicense = IdSteamDiscord.license
    local discord = IdSteamDiscord.discord

    if IdGiocatore == nil or motivo == nil then
        return
    end

    if GetPlayerIdentifiers(IdGiocatore)[1] == nil then
        TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = "Il giocatore segnalato non è online.", 6000})
        return
    end
    TriggerClientEvent('ox_lib:notify', src, {type = 'success', description = "Grazie per aver inviato una segnalazione! Il personale sarà da te a breve.", 6000})

    local players = GetAllPlayers()
    for i = 1, #players do
        if IsPlayerAceAllowed(players[i], "krs_reports.view") then
            TriggerClientEvent('esx:showNotification', players[i], "Player [" .. IdGiocatore .. "] [" .. GetPlayerName(IdGiocatore) .. "] è stato segnalato by: [" .. src .. "] " .. name .. " for: " .. motivo)
        end
    end

    sendToDisc(
        "Player [" .. IdGiocatore .. "] [" .. GetPlayerName(IdGiocatore) .. "] è stato segnalato..",
        "**Motivo**: ``" .. motivo .. "``" ..
            "\n**Game License:** ``" .. gameLicense ..
            "``\n**Discord UID:** ``" .. discord:gsub('discord:', '') ..
            "``\n**Discord-Tag:** <@!" .. discord:gsub('discord:', '') .. ">" ..
            "\n**Steam:** " .. steam,
        "Reported by: [" .. src .. "] " .. name
    )
end)


-- Functions
function sendToDisc(title, msg, fmsg)
    local embed = {
        {
            ["color"] = 1027569,
            ["title"] = "**".. title .."**",
            ["description"] = msg,
            ["footer"] = {
                ["text"] = fmsg,
                ["icon_url"] = "https://media.discordapp.net/attachments/1052910824865402892/1129370368969285632/Krs-logo.png",
            },
        }
    }
    PerformHttpRequest(Krs.DiscordWebhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

function GetAllPlayers()
    local players = {}

    for _, i in ipairs(GetPlayers()) do
        table.insert(players, i)    
    end

    return players
end


function ExtractIdentifiers(src)
    -- Inizializza una tabella vuota per contenere gli identificatori
    local identifiers = {
        steam = "",     -- Identificatore di Steam
        ip = "",        -- Indirizzo IP
        discord = "",   -- Identificatore di Discord
        license = "",   -- Licenza del gioco
    }

    -- Loop attraverso gli identificatori del giocatore e li assegna alla corrispondente voce nella tabella 'identifiers'
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        -- Verifica il tipo di identificatore e lo assegna alla voce corrispondente nella tabella
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        end
    end

    -- Restituisce la tabella contenente gli identificatori del giocatore organizzati per tipo
    return identifiers
end