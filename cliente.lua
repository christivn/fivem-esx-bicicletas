----------- [ Configuración ] -----------

local precio = 25
local puntos = {
    {x=-582.42 ,y=319.22 ,z=84.85},
    {x=-570.1 ,y=323.52 ,z=84.49}
}

----------------------------------------

ESX = nil
local tieneBicicleta = false
local matriculaBici = nil

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		while ESX == nil do
		    TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		    Citizen.Wait(0)
		end

		for i, punto in ipairs(puntos) do
		    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
		    DrawMarker(38, punto.x, punto.y, punto.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 59, 169, 219, 50, false, true, 2, nil, nil, false)
		    DrawMarker(27, punto.x, punto.y, punto.z-1, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 2.0, 2.0, 2.0, 59, 169, 219, 50, false, true, 2, nil, nil, false)

		    if IsPedInAnyVehicle(PlayerPedId(), false) and matriculaBici==nil then
			local matriculaGenerada = math.random(0,99999)
			local bici = GetVehiclePedIsIn(PlayerPedId(), false)
			ESX.Game.SetVehicleProperties(bici, { plate = matriculaGenerada })
			matriculaBici = ESX.Game.GetVehicleProperties(bici).plate
		    end

		    if GetDistanceBetweenCoords(punto.x, punto.y, punto.z-1, x, y, z) < 1.5 and tieneBicicleta==false then
			Draw3DText( punto.x, punto.y, punto.z, 2, "Pulsa ~b~E ~w~para alquilar una bicicleta por ~b~"..precio.."€")
			if IsControlJustPressed(1,38) then
			    spawn_bicicleta()
			    TriggerServerEvent("bicicletas:cobrar")
			    ESX.ShowNotification("Has alquilado una bicicleta por ~g~"..precio.."€")
			end

		    elseif GetDistanceBetweenCoords(punto.x, punto.y, punto.z-1, x, y, z) < 1.5 and tieneBicicleta==true then
			Draw3DText( punto.x, punto.y, punto.z, 2, "Pulsa ~b~E ~w~para devolver la bicicleta")
			if IsControlJustPressed(1,38) then
			    local bici = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			    local biciData = ESX.Game.GetVehicleProperties(bici)

			    if biciData.plate==matriculaBici then
				TriggerServerEvent("bicicletas:entregar")
				ESX.Game.DeleteVehicle(bici)
				tieneBicicleta=false
				matriculaBici = nil
				ESX.ShowNotification("Has entregado la bicicleta, y se te a devuelto ~g~"..math.ceil(precio/2).."€")
			    else
				ESX.ShowNotification("~r~Esta no es la bicicleta que alquilastes")
			    end

			end
		    end

		end

    end
end)


function spawn_bicicleta() 
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	TriggerEvent('esx:spawnVehicle', "bmx")
	DoScreenFadeIn(2000)
	tieneBicicleta = true
end


function Draw3DText(x, y, z, scl_factor, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) - 0.15
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov * scl_factor
    if onScreen then
        SetTextScale(0.0, scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
