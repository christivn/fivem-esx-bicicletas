local precio = 25

ESX = nil
TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

RegisterServerEvent("bicicletas:cobrar")
AddEventHandler("bicicletas:cobrar", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local banco = xPlayer.getAccount("bank").money

    if banco==nil or banco<precio then
		TriggerClientEvent('bicicletas:cobroResultado', _source, "error", "No tienes suficiente dinero en el banco")
	else
		xPlayer.removeAccountMoney("bank", precio)
		TriggerClientEvent('bicicletas:cobroResultado', _source, "success", "Has alquilado una bicicleta")
	end
end)

RegisterServerEvent("bicicletas:entregar")
AddEventHandler("bicicletas:entregar", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addAccountMoney("bank", precio/2)
end)
