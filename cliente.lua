----------- [ Configuración ] -----------

local precio = 25
local puntos = {
    {x=74.11 ,y=-106.39 ,z=58.19},
    {x=74.82 ,y=-93.53 ,z=58.15},
    {x=71.55 ,y=-98.83 ,z=58.15}
}

----------------------------------------

ESX = nil
local tieneBicicleta = false

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
            
            if GetDistanceBetweenCoords(punto.x, punto.y, punto.z-1, x, y, z) < 1.5 and tieneBicicleta==false then
                Draw3DText( punto.x, punto.y, punto.z, 2, "Pulsa ~b~E ~w~para alquilar una bicicleta por ~b~"..precio.."€")
                if IsControlJustPressed(1,38) then
                    spawn_bicicleta()
                    TriggerServerEvent("bicicletas:cobrar")
                end
            elseif GetDistanceBetweenCoords(punto.x, punto.y, punto.z-1, x, y, z) < 1.5 and tieneBicicleta==true then
                Draw3DText( punto.x, punto.y, punto.z, 2, "Pulsa ~b~E ~w~para devolver la bicicleta")
                if IsControlJustPressed(1,38) then
                    TriggerEvent('esx:deleteVehicle', "bmx")
                    TriggerServerEvent("bicicletas:entregar")
                    tieneBicicleta=false
                end
            end

        end

    end
end)


function spawn_bicicleta() 
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	TriggerEvent('esx:spawnVehicle', "bmx")
    tieneBicicleta = true;
	DoScreenFadeIn(2000) 
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