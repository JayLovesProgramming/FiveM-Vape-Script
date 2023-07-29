-- [Jay Script's] --

--Variables
local IsPlayerAbleToVape = false
local FadeIn = false
local FadeOut = false
local DisplayText = false
TriggerEvent('chat:addSuggestion', '/vape', "Start vaping by using the command", "/vape <start/stop>")

-- Starts vaping action
RegisterNetEvent("JayScripts:StartVaping")
AddEventHandler("JayScripts:StartVaping", function(source)
	local ped = PlayerPedId()
	if DoesEntityExist(ped) and not IsEntityDead(ped) then
		if IsPedOnFoot(ped) then
			if IsPlayerAbleToVape == false then
				StartVaping()
				Notify("~c~You've ~g~started ~c~using your vape.")
			else
				Notify("~r~You are already holding your vape.")
			end
		else
			Notify("~r~You can not do this in a vehicle.")
		end
	else
		Notify("~r~You can not do this if you are dead.")
	end
end)

-- Ensures vaping action
RegisterNetEvent("JayScripts:VapeAnimFix")
AddEventHandler("JayScripts:VapeAnimFix", function(source)
	local ped = PlayerPedId()
	local ad = "anim@heists@humane_labs@finale@keycards"
	local anim = "ped_a_enter_loop"
	while not HasAnimDictLoaded(ad) do
		RequestAnimDict(ad)
	  	Wait(1)
	end
	TaskPlayAnim(ped, ad, anim, 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)
end)

-- Stops vaping action
RegisterNetEvent("JayScripts:StopVaping")
AddEventHandler("JayScripts:StopVaping", function(source)
	if IsPlayerAbleToVape == true then
		PlayerIsUnableToVape()
		DisplayText = false
		Notify("~c~You've ~r~stopped ~c~using your vape.")
	else
		Notify("~r~You're not holding your vape.")
	end
end)

-- Explosion Logic
RegisterNetEvent("JayScripts:ExplosionVape")
AddEventHandler("JayScripts:ExplosionVape", function()
	if IsPlayerAbleToVape then
		local ped = PlayerPedId()
		local PedPos = GetEntityCoords(ped)
		local ad = "mp_player_inteat@burger"
		local anim = "mp_player_int_eat_burger"
		if DoesEntityExist(ped) and not IsEntityDead(ped) then
			while not HasAnimDictLoaded(ad) do
			  	Wait(1)
				RequestAnimDict(ad)
			end
			local VapeFailure = math.random(1,Config.FailureOdds)
			if VapeFailure == 1 then
				TaskPlayAnim(ped, ad, anim, 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)
				PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
				Wait(250)
				AddExplosion(PedPos.x, PedPos.y, PedPos.z+1.00, 34, 0.00, true, false, 1.00)
				ApplyDamageToPed(ped, 200, false)
				TriggerServerEvent("JayScripts:Failure", 0)
			else
				TaskPlayAnim(ped, ad, anim, 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)
				PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
			  		Wait(950)
				TriggerServerEvent("JayScripts:StartSmokeSv", PedToNet(ped))
			  		Wait(Config.VapeHangTime-1000)
				TriggerEvent("JayScripts:VapeAnimFix", 0)
			end
		end
	else
		Notify("~r~You must be holding your vape to do this.")
	end
end)

-- Location of where the smoke comes out
p_smoke_location = {20279}
-- The smoke/clouds particle
p_smoke_particle = "exp_grd_bzgas_smoke"
-- The smoke/clouds particle dictionary
p_smoke_particle_asset = "core" 

-- Start smoking client event/callback
RegisterNetEvent("JayScripts:StartSmokeCl")
AddEventHandler("JayScripts:StartSmokeCl", function(c_ped)
	for _,bones in pairs(p_smoke_location) do
		if DoesEntityExist(NetToPed(c_ped)) and not IsEntityDead(NetToPed(c_ped)) then
			createdSmoke = UseParticleFxAssetNextCall(p_smoke_particle_asset)
			createdPart = StartParticleFxLoopedOnEntityBone(p_smoke_particle, NetToPed(c_ped), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(NetToPed(c_ped), bones), Config.SmokeSize, 0.0, 0.0, 0.0)
			Wait(Config.VapeHangTime)
			--Wait(250)
			while DoesParticleFxLoopedExist(createdSmoke) do
				StopParticleFxLooped(createdSmoke, 1)
			  Wait(0)
			end
			while DoesParticleFxLoopedExist(createdPart) do
				StopParticleFxLooped(createdPart, 1)
			  Wait(0)
			end
			while DoesParticleFxLoopedExist(p_smoke_particle) do
				StopParticleFxLooped(p_smoke_particle, 1)
			  Wait(0)
			end
			while DoesParticleFxLoopedExist(p_smoke_particle_asset) do
				StopParticleFxLooped(p_smoke_particle_asset, 1)
			  Wait(0)
			end
			Wait(Config.VapeHangTime*3)
			RemoveParticleFxFromEntity(NetToPed(c_ped))
			break
		end
	end
end)

-- Thread 1 // Main thread
CreateThread(function()
	while true do
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped, true) then
			PlayerIsEnteringVehicle()
		end
		if IsPlayerAbleToVape then
			if IsControlPressed(0, Config.TakeAHitButton) then
			  Wait(Config.HowLongShouldYouHoldTheButto)
				if IsControlPressed(0, Config.TakeAHitButton) then
					TriggerEvent("JayScripts:ExplosionVape", 0)
				end
			  Wait(Config.VapeCoolDownTime)
			end
			if IsControlPressed(0, Config.ResetVapeButton) then
			  Wait(Config.HowLongShouldYouHoldTheButto)
				if IsControlPressed(0, Config.ResetVapeButton) then
					TriggerEvent("JayScripts:VapeAnimFix", 0)
				end
			  Wait(1000)
			end
		end
	  Wait(1)
	end
end)
-- Draw Text on screen
function Draw3DTextOnScreen(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	  if onScreen then
		  SetTextScale(Config.VapeDrawTextScaleAboveHead, Config.VapeDrawTextScaleAboveHead)
		  SetTextFont(0)
		  SetTextProportional(1)
		  SetTextColour(255, 255, 255, Config.HelpTextStartingAlpha)
		  SetTextDropshadow(0, 0, 0, 0, 55)
		  SetTextEdge(2, 0, 0, 0, 150)
		  SetTextDropShadow()
		  SetTextOutline()
		  SetTextEntry("STRING")
		  SetTextCentre(1)
		  AddTextComponentString(text)
		  DrawText(_x,_y)
	  end
  end
-- Thread 2 // Draw text thread
CreateThread(function()
	while true do
		if IsPlayerAbleToVape then
			if DisplayText then
				local ped = PlayerPedId()
				local pedPos = GetEntityCoords(ped)
				Draw3DTextOnScreen(pedPos.x, pedPos.y, pedPos.z+1.20, Config.HoldEtoTakeAHitText)
				Draw3DTextOnScreen(pedPos.x, pedPos.y, pedPos.z+1.08, Config.HoldGtoResetVape)
			end
		end
	  Wait(1)
	end
end)

-- Function 1 // to check if not already vaping
function StartVaping()
	IsPlayerAbleToVape = true
	local ped = PlayerPedId()
	local ad = "anim@heists@humane_labs@finale@keycards"
	local anim = "ped_a_enter_loop"
	DisplayText = true
	while not HasAnimDictLoaded(ad) do
		RequestAnimDict(ad)
	  Wait(1)
	end
	TaskPlayAnim(ped, ad, anim, 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)
	local x,y,z = table.unpack(GetEntityCoords(ped))
	local prop_name = "ba_prop_battle_vape_01"
	VapeMod = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	AttachEntityToEntity(VapeMod, ped, GetPedBoneIndex(ped, 18905), 0.08, -0.00, 0.03, -150.0, 90.0, -10.0, true, true, false, true, 1, true)
end

-- Function 2 // to check if player is entering a vehicle
function PlayerIsEnteringVehicle()
	IsPlayerAbleToVape = false
	local ped = PlayerPedId()
	local ad = "anim@heists@humane_labs@finale@keycards"
	DeleteObject(VapeMod)
	TaskPlayAnim(ped, ad, "exit", 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)
end

-- Function 3 // cancels everything if unable to vape
function PlayerIsUnableToVape()
	IsPlayerAbleToVape = false
	local ped = PlayerPedId()
	DeleteObject(VapeMod)
	ClearPedTasksImmediately(ped)
	ClearPedSecondaryTask(ped)
end

-- These are only enabled if the debug is true
if Config.Debug then 
	RegisterCommand("testvapesound", function(source, rawCommand)
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		Notify("Play sound???")
	end)
	RegisterCommand("testvapeexplosion", function(source, rawCommand)
		local ped = PlayerPedId()
		local PedPos = GetEntityCoords(ped)
		AddExplosion(PedPos.x, PedPos.y, PedPos.z+1.00, 34, 0.00, true, false, 1.00)
		Notify("Play explosion???")
	end)
end