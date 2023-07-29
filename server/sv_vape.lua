-- [Jay Script's] --
-- Checks for permission only if set to true in the config
if Config.VapePermission == true then
	RegisterCommand("vape", function(source, args, rawCommand)
		if IsPlayerAceAllowed(source, Config.PermissionsGroup) then
			if (tostring(args[1]) == "start") then
				TriggerClientEvent("JayScripts:StartVaping", source, 0)
			elseif (tostring(args[1]) == "stop") then
				TriggerClientEvent("JayScripts:StopVaping", source, 0)
			elseif (tostring(args[1])) ~= nil then
				TriggerClientEvent("chatMessage", source, "^1 Vaping: Error, Wrong Command must use /vape <start/stop>")
			end
			if Config.Debug then
				if (tostring(args[1]) == "fix") then
					TriggerClientEvent("JayScripts:VapeAnimFix", source, 0)
				elseif (tostring(args[1]) == "drag") then
					TriggerClientEvent("JayScripts:ExplosionVape", source, 0)
				end
			end
		else
			TriggerClientEvent("chatMessage", source, Config.InsufficientMessage)
		end
	end)
else

-- Command to use the vape itself
RegisterCommand("vape", function(source, args, rawCommand)
		if (tostring(args[1]) == "start") then
			TriggerClientEvent("JayScripts:StartVaping", source, 0)
		elseif (tostring(args[1]) == "stop") then
			TriggerClientEvent("JayScripts:StopVaping", source, 0)
		elseif (tostring(args[1])) ~= nil then
			TriggerClientEvent("JayScripts:Notify", source, "~r~Vape error ~w~please use /vape start/stop")
			-- Notify(source, {"Vape Error, Wrong Command must use /vape <start/stop>"})
		end
		if Config.Debug then
			if (tostring(args[1]) == "fix") then
				TriggerClientEvent("JayScripts:VapeAnimFix", source, 0)
			elseif (tostring(args[1]) == "drag") then
				TriggerClientEvent("JayScripts:ExplosionVape", source, 0)
			end
		end
	end)
end

-- Handles failure/explosion of the vape
RegisterNetEvent("JayScripts:Failure")
AddEventHandler("JayScripts:Failure", function()
	source = source
	PlayersName = GetPlayerName(source)
	TriggerClientEvent("chatMessage", -1, " ^3>>> ^2Well, it seems that ^4@"..PlayersName.."^2's vape has exploded in their face, The odds of that are ^31 ^2in ^310,594")
end)

-- Starts smoking the vape
RegisterServerEvent("JayScripts:StartSmokeSv")
AddEventHandler("JayScripts:StartSmokeSv", function(entity)
	TriggerClientEvent("JayScripts:StartSmokeCl", -1, entity)
end)
