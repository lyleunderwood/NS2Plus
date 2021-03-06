local updateCheckInterval = CHUDServerOptions["modupdatercheckinterval"].currentValue*60
local lastTimeChecked = Shared.GetTime() - updateCheckInterval
local mapChangeNeeded = false
local modsTable = {}
local DisableUpdater = false

Server.RemoveTag("CHUD_MCR")

// Don't use this updater if the server is already using the Shine one
if Shine and Shine:IsExtensionEnabled( "workshopupdater" ) then
	Shared.Message("[NS2+] Shine workshop updater is enabled. Disabling NS2+ mod updater.")
	DisableUpdater = true
else
	DisableUpdater = CHUDServerOptions["modupdater"].currentValue == false
	local modUpdStr = ConditionalValue(DisableUpdater, "Disabled", "Enabled")
	Shared.Message("[NS2+] Mod updater is: " .. modUpdStr)
end

function CHUDParseModInfo(modInfo)
	if modInfo then
		local response = modInfo["response"]
		if response["result"] == 1 then
			for _, res in pairs(response["publishedfiledetails"]) do
				if res["result"] == 1 and not mapChangeNeeded then
					if modsTable[res["publishedfileid"]] and modsTable[res["publishedfileid"]] ~= res["time_updated"] then
						Server.AddTag("CHUD_MCR")
						mapChangeNeeded = true
						// Repeat the mod update message
						updateCheckInterval = CHUDServerOptions["modupdaterreminderinterval"].currentValue*60
						if not DisableUpdater then
							SendCHUDMessage("Detected mod update. New players won't be able to join until map change.")
						end
					end
					
					modsTable[res["publishedfileid"]] = res["time_updated"]
				end
			end
		end
	end
end

function CHUDModUpdater()
	// Update values as soon as they are changed by console commands
	DisableUpdater = CHUDServerOptions["modupdater"].currentValue == false
	
	// Change the check interval and reset the last time checked
	if not mapChangeNeeded and updateCheckInterval ~= CHUDServerOptions["modupdatercheckinterval"].currentValue*60 then
		updateCheckInterval = CHUDServerOptions["modupdatercheckinterval"].currentValue*60
		lastTimeChecked = Shared.GetTime()
	end
	
	// Change the reminder interval (only needed if it's already reminding)
	if mapChangeNeeded and updateCheckInterval ~= CHUDServerOptions["modupdaterreminderinterval"].currentValue*60 then
		updateCheckInterval = CHUDServerOptions["modupdaterreminderinterval"].currentValue*60
		lastTimeChecked = Shared.GetTime()
	end

	if mapChangeNeeded and Server.GetNumPlayers() == 0 and not DisableUpdater then
		SendCHUDMessage("The server is empty. Changing map.")
		MapCycle_ChangeMap( Shared.GetMapName() )
	end

	// Even if the updater is disabled, keep running so it can notify players of outdated mods in the server browser
	if lastTimeChecked < Shared.GetTime() - updateCheckInterval then
		lastTimeChecked = Shared.GetTime()
		
		if mapChangeNeeded then
			// If we set the reminder to 0, don't show this message anymore.
			if updateCheckInterval > 0 and not DisableUpdater then
				SendCHUDMessage("Detected mod update. New players won't be able to join until map change.")
			end
		else	
			local params = {}
			params["itemcount"] = Server.GetNumActiveMods()
			for modNum = 1, Server.GetNumActiveMods() do
				params["publishedfileids[" .. modNum-1 .. "]"] = tonumber("0x" .. Server.GetActiveModId(modNum))
			end

			if params["itemcount"] > 0 then
				Shared.SendHTTPRequest("http://api.steampowered.com/ISteamRemoteStorage/GetPublishedFileDetails/v1/", "POST", params, function(result) CHUDParseModInfo(json.decode(result)) end)
			end
		end
	end
end

Event.Hook("UpdateServer", CHUDModUpdater)