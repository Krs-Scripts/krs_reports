ESX = exports["es_extended"]:getSharedObject()

RegisterCommand("report", function(source, args, rawCommand)
    local src = source
  
    local input = lib.inputDialog('Report Player menu', {
        {type = 'number', label = 'ID Player', icon = 'user'},
        {type = 'input', label = 'Reason', icon = 'comment'},
        
    })

    if input then
        local IdGiocatore = tonumber(input[1])
        local motivo = input[2]

        if IdGiocatore == nil then
            TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = "Be sure to include a Player ID.", 6000})
        elseif motivo == nil then
            TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = "Make sure you include a reason.", 6000})
        else
            TriggerServerEvent("krs_reports:SegnalaGiocatori", IdGiocatore, motivo)
        end
    end
end, false)

