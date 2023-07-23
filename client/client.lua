ESX = exports["es_extended"]:getSharedObject()

RegisterCommand("report", function(source, args, rawCommand)
    local src = source
  
    local input = lib.inputDialog('Menu Segnala Giocatore', {
        {type = 'number', label = 'ID Giocatori', icon = 'user'},
        {type = 'input', label = 'Motivazione', icon = 'comment'},
        
    })

    if input then
        local IdGiocatore = tonumber(input[1])
        local motivo = input[2]

        if IdGiocatore == nil then
            TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = "Assicurati di includere un ID.", 6000})
        elseif motivo == nil then
            TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = "Assicurati di includere un motivo.", 6000})
        else
            TriggerServerEvent("krs_reports:SegnalaGiocatori", IdGiocatore, motivo)
        end
    end
end, false)

