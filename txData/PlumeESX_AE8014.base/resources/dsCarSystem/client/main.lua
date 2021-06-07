--------------------------------------------
--------------------------------------------
--  Script    : dsCarSystem               --
--  Developer : WinMew ดูดมาจาก dyztiny    --
--  และ winmew ก็ขาย สุดท้ายก็หลุด            --
--  Discord  : https://discord.gg/rD6UD4m --
--------------------------------------------
--------------------------------------------

-- State
local currentFuel = 0.0
local cruiseIsOn = false
local seatbeltIsOn = false
local isOutsideVehicle = true
local position, heading, zoneNameFull, streetName, locationText
local isHide = false

AddEventHandler("screenshowEnable", function(isEnable)
    isHide = isEnable
end)

Citizen.CreateThread(function()
    while true do
        local player = GetPlayerPed(-1)
        
        if (IsPedInAnyVehicle(player, false)) then
            position = GetEntityCoords(player)
            heading = Config.Directions[math.floor((GetEntityHeading(player) + 45.0) / 90.0)]
            zoneNameFull = Config.Zones[GetNameOfZone(position.x, position.y, position.z)]
            streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(position.x, position.y, position.z))
            locationText = heading
            locationText = (streetName == "" or streetName == nil) and (locationText) or (locationText .. " | " .. streetName)
            locationText = (zoneNameFull == "" or zoneNameFull == nil) and (locationText) or (locationText .. " | " .. zoneNameFull)
        end
        
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    local currSpeed = 0.0
    local cruiseSpeed = 999.0
    local prevVelocity = {x = 0.0, y = 0.0, z = 0.0}

    while true do
        (function()
            local player = GetPlayerPed(-1)

            -- If Player isn't in a vehicle then do nothing
            if (not IsPedInAnyVehicle(player, false)) then
                cruiseIsOn = false
                seatbeltIsOn = false
                DisplayRadar(false)
                if (not isOutsideVehicle) then
                    isOutsideVehicle = true

                    SendNUIMessage({
                        -- HUD Stuff
                        isShow = not isOutsideVehicle,

                        -- Speed
                        speed = 0,

                        -- Gear
                        gear = 0,
                        maxGear = 0,

                        -- Belt
                        hasBelt = false,
                        beltOn = seatbeltIsOn,

                        -- Cruise
                        hasCruise = false,
                        cruiseStatus = false,

                        -- Light
                        turnLeft = isTurnLeft,
                        turnRight = isTurnRight,

                        -- Vehicle Status
                        carHealth = 0,
                        carFuel = 0,
                        engineStatus = false
                    })
                end

                return
            end

            isOutsideVehicle = false
            local vehicle = GetVehiclePedIsIn(player, false)

			local prevSpeed = currSpeed
            currSpeed = GetEntitySpeed(vehicle)

            -- Check vehicle class if has belt or not
            local vehicleClass = GetVehicleClass(vehicle)
            local hasBelt = isVehicleClassHasBelt(vehicleClass)

            if IsControlJustReleased(0, Config.seatbeltInput) and hasBelt then 
                seatbeltIsOn = not seatbeltIsOn 
            end
            
            if seatbeltIsOn then  
                --TriggerEvent("pNotify:SendNotification", {text ="Locked Seatbelt", type = "success", queue = "belt", timeout = 5000, layout = "centerright"})
            else 
                --TriggerEvent("pNotify:SendNotification", {text = "Unlocked Seatbelt", type = "error", queue = "belt", timeout = 5000, layout = "centerright"}) 
            end

            if not hasBelt then
                seatbeltIsOn = false
            end

            if (not seatbeltIsOn or not hasBelt) then
                -- Eject PED when moving forward, vehicle was going over 45 MPH and acceleration over 100 G's
                local vehIsMovingFwd = GetEntitySpeedVector(vehicle, true).y > 1.0
                local vehAcc = (prevSpeed - currSpeed) / GetFrameTime()
                if (vehIsMovingFwd and (prevSpeed > (Config.seatbeltEjectSpeed/2.237)) and (vehAcc > (Config.seatbeltEjectAccel*9.81))) then
                    SetEntityCoords(player, position.x, position.y, position.z - 0.47, true, true, true)
                    SetEntityVelocity(player, prevVelocity.x, prevVelocity.y, prevVelocity.z)
                    Citizen.Wait(1)
                    SetPedToRagdoll(player, 1000, 1000, 0, 0, 0, 0)
                else
                    -- Update previous velocity for ejecting player
                    prevVelocity = GetEntityVelocity(vehicle)
                end
            else
                -- Disable vehicle exit when seatbelt is on
                DisableControlAction(0, 75)
            end

            local isDriver = (GetPedInVehicleSeat(vehicle, -1) == player)
            if isDriver then
                -- Check if cruise control button pressed, toggle state and set maximum speed appropriately
                if IsControlJustReleased(0, Config.cruiseInput) then
                    cruiseIsOn = not cruiseIsOn
                    cruiseSpeed = currSpeed
                end

                local maxSpeed = cruiseIsOn and cruiseSpeed or GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
                SetEntityMaxSpeed(vehicle, maxSpeed)
            else
                -- Reset cruise control
                cruiseIsOn = false
            end

            local EntityHealth = GetEntityHealth(vehicle)
            if EntityHealth > 1000 then 
                SetEntityHealth(vehicle, 1000)
                EntityHealth = GetEntityHealth(vehicle)
            end
            local vehicleHealth = (EntityHealth / 1000) * 500
            --print(vehicleHealth)
            --SetPlayerVehicleDamageModifier(PlayerId(), 500)
            --SetVehicleEngineHealth(vehicle, (EntityHealth + 0.00) * 1.5)

            local maxSpeed = 100 - ((100 - ((GetVehicleEngineHealth(vehicle) / 1000) * 500)) / 1.5)
            if vehicleHealth <= 30 then 
                SetVehicleMaxSpeed(vehicle, maxSpeed) 
            else 
                SetVehicleMaxSpeed(vehicle, 200.0) 
            end

            if vehicleHealth == 0 then
                SetVehicleEngineOn(vehicle, false, false)
            end
			SendNUIMessage({
                -- HUD Stuff
                isShow = not isOutsideVehicle,

                isHide = isHide,

                -- Speed
                speed = math.floor(currSpeed * 3.6),

                -- Gear
                gear = GetVehicleCurrentGear(vehicle),
                maxGear = GetVehicleHighGear(vehicle),

                -- Belt
                hasBelt = hasBelt,
                beltOn = seatbeltIsOn,

                -- Cruise
                hasCruise = isDriver,
                cruiseStatus = cruiseIsOn,

                -- Vehicle Status
                carHealth = (((GetVehicleEngineHealth(vehicle) / 1000) * 90)),
                carFuel = math.floor(((GetVehicleFuelLevel(vehicle) / 100) * 100)),
                engineStatus = GetIsVehicleEngineRunning(vehicle),

                streetName = locationText
            })

            DisplayRadar((not isOutsideVehicle and not isHide))
        end)()
        Citizen.Wait(isOutsideVehicle and 1000 or 10)
    end
end)