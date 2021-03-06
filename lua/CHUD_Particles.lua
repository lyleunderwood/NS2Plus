local PropCache = { }
local PropValuesCache = { }
local propsRemoved = false
local cinematicsCache = { }
local cinematicsValuesCache = { }
local cinematicsRemoved = false

local BlockedProps = { 	"models/props/veil/veil_hologram_01.model", 
						"models/props/veil/veil_holosign_01_nanogrid.model", 
						"models/props/veil/veil_hologram_01_scanlines.model",
						"models/props/biodome/biodome_bamboo_crown_01_01.model",
						"models/props/biodome/biodome_bamboo_crown_01_02.model",
						"models/props/biodome/biodome_bamboo_crown_01_03.model",
						"models/props/biodome/biodome_bamboo_crown_01_04.model",
						"models/props/biodome/biodome_bamboo_clump_01_01_high.model",
						"models/props/biodome/biodome_bamboo_clump_01_02_high.model",
						"models/props/biodome/biodome_bamboo_clump_01_03_high.model",
						"models/props/biodome/biodome_bamboo_clump_01_04_high.model",
						"models/props/biodome/biodome_bamboo_clump_01_05_high.model",
						"models/props/biodome/biodome_bamboo_clump_01_01_low.model",
						"models/props/biodome/biodome_bamboo_clump_01_02_low.model",
						"models/props/biodome/biodome_bamboo_clump_01_03_low.model",
						"models/props/biodome/biodome_bamboo_clump_01_04_low.model",
						"models/props/biodome/biodome_bamboo_clump_01_05_low.model",
						"models/props/biodome/biodome_waterfall_01.model",
						"models/props/biodome/biodome_grass_01_01.model",
						"models/props/biodome/biodome_grass_01_02.model",
						"models/props/biodome/biodome_grass_01_03.model",
						"models/props/biodome/biodome_grass_01_04.model",
						"models/props/biodome/biodome_grass_02_tile.model",
						"models/props/refinery/refinery_shipping_hologram_animated.model",
						"models/props/descent/descent_hologram_planet_01.model",
						"models/props/descent/descent_hologram_planet_02.model",
						"models/props/descent/descent_hologram_planet_03.model",
						"models/props/descent/descent_hologram_spacestation_01.model"
					}
local blockedCinematics = {	"cinematics/marine/structures/death_large.cinematic",
							"cinematics/marine/structures/death_small.cinematic",
							"cinematics/marine/sentry/death.cinematic",
							"cinematics/marine/infantryportal/death.cinematic",
							"cinematics/alien/cyst/enzymecloud_splash.cinematic",
							"cinematics/death_1p.cinematic",
							"cinematics/alien/death_1p_alien.cinematic",
							"cinematics/marine/commander_arrow.cinematic",
							"cinematics/alien/commander_arrow.cinematic",
							"cinematics/marine/flamethrower/burning_surface.cinematic",
							"cinematics/marine/flamethrower/burning_vertical_surface.cinematic",
							//"cinematics/marine/flamethrower/burn_1p.cinematic",
							"cinematics/marine/flamethrower/burn_big.cinematic",
							"cinematics/marine/flamethrower/burn_huge.cinematic",
							"cinematics/marine/flamethrower/burn_med.cinematic",
							"cinematics/marine/flamethrower/burn_small.cinematic",
							"cinematics/marine/flamethrower/burn_small_continuous.cinematic",
							"cinematics/marine/flamethrower/burn_tiny.cinematic",
							"cinematics/marine/flamethrower/canister_explosion.cinematic",
							"cinematics/marine/flamethrower/flame.cinematic",
							"cinematics/marine/flamethrower/flameout.cinematic",
							"cinematics/marine/flamethrower/flame_1p.cinematic",
							"cinematics/marine/flamethrower/flame_impact3.cinematic",
							"cinematics/marine/flamethrower/flame_residue_1p_part1.cinematic",
							"cinematics/marine/flamethrower/flame_residue_1p_part2.cinematic",
							"cinematics/marine/flamethrower/flame_residue_1p_part3.cinematic",
							//"cinematics/marine/flamethrower/flame_trail_1p_part1.cinematic",
							"cinematics/marine/flamethrower/flame_trail_1p_part2.cinematic",
							"cinematics/marine/flamethrower/flame_trail_1p_part3.cinematic",
							"cinematics/marine/flamethrower/flame_trail_full.cinematic",
							"cinematics/marine/flamethrower/flame_trail_half.cinematic",
							"cinematics/marine/flamethrower/flame_trail_light.cinematic",
							//"cinematics/marine/flamethrower/flame_trail_part1.cinematic",
							"cinematics/marine/flamethrower/flame_trail_part2.cinematic",
							"cinematics/marine/flamethrower/flame_trail_part3.cinematic",
							"cinematics/marine/flamethrower/flame_trail_short.cinematic",
							"cinematics/marine/flamethrower/impact.cinematic",
							"cinematics/marine/flamethrower/pilot.cinematic",
							"cinematics/marine/flamethrower/scorched.cinematic",
							"cinematics/marine/exo/hurt_view.cinematic",
							"cinematics/marine/exo/hurt_severe_view.cinematic",
							"cinematics/marine/heavy/land.cinematic",
							"cinematics/marine/jetpack/impact.cinematic",
							"cinematics/marine/minigun/mm_left_shell.cinematic",
							"cinematics/marine/minigun/mm_shell.cinematic",
							"cinematics/marine/minigun/overheat.cinematic",
							//"cinematics/marine/jetpack/trail_1.cinematic",
							"cinematics/marine/jetpack/trail_2.cinematic",
							"cinematics/marine/jetpack/trail_2.cinematic",
							"cinematics/marine/jetpack/trail_2.cinematic",
							"cinematics/marine/jetpack/trail_3.cinematic",
							"cinematics/alien/fade/shadowstep.cinematic",
							"cinematics/alien/fade/shadowstep_silent.cinematic",
							"cinematics/alien/fade/trail_dark_1.cinematic",
							"cinematics/alien/fade/trail_dark_2.cinematic",
							"cinematics/alien/fade/trail_light_1.cinematic",
							"cinematics/alien/fade/trail_light_2.cinematic",
							"cinematics/alien/fade/blink_view.cinematic",
						}
							
local replacedCinematics = {"cinematics/alien/mucousmembrane.cinematic",
							"cinematics/alien/cyst/enzymecloud_large.cinematic",
							"cinematics/alien/nutrientmist.cinematic",
							"cinematics/alien/nutrientmist_hive.cinematic",
							"cinematics/alien/nutrientmist_onos.cinematic",
							"cinematics/alien/nutrientmist_structure.cinematic",
							"cinematics/marine/spawn_item.cinematic",
							"cinematics/common/resnode.cinematic",
							"cinematics/marine/minigun/muzzle_flash.cinematic",
							"cinematics/marine/structures/hurt_severe.cinematic",
							"cinematics/marine/structures/hurt_small_severe.cinematic",
							"cinematics/marine/structures/hurt.cinematic",
							"cinematics/marine/structures/hurt_small.cinematic",
							"cinematics/marine/infantryportal/spin.cinematic",
							"cinematics/alien/fade/blink_in_silent.cinematic",
							"cinematics/alien/fade/blink_out_silent.cinematic",
							"cinematics/alien/tracer_residue.cinematic",
						}

mapCinematicNames = {	"cinematics/environment/biodome/flying_papers.cinematic",
						"cinematics/environment/biodome/leaves_folliage_01.cinematic",
						"cinematics/environment/biodome/mosquitos_glow.cinematic",
						"cinematics/environment/biodome/sand_storm.cinematic",
						"cinematics/environment/biodome/sprinklers_top_long.cinematic",
						"cinematics/environment/biodome/sprinklers_top_long_narrow.cinematic",
						"cinematics/environment/biodome/waterfall_basemist.cinematic",
						"cinematics/environment/descent/descent_club_holo_ball.cinematic",
						"cinematics/environment/descent/descent_droid.cinematic",
						"cinematics/environment/descent/descent_energyflow_lightflash.cinematic",
						"cinematics/environment/dust_motes.cinematic",
						"cinematics/environment/eclipse/search_light.cinematic",
						"cinematics/environment/eclipse/skyline.cinematic",
						"cinematics/environment/eclipse/skyline_endless.cinematic",
						"cinematics/environment/emergency_light_flash.cinematic",
						"cinematics/environment/fire_light_flicker.cinematic",
						"cinematics/environment/fire_small.cinematic",
						"cinematics/environment/fire_small_sidebarrel.cinematic",
						"cinematics/environment/fire_tiny.cinematic",
						"cinematics/environment/halo_aqua_large.cinematic",
						"cinematics/environment/halo_blue_large.cinematic",
						"cinematics/environment/halo_orange_large.cinematic",
						"cinematics/environment/light_c12_ambientflicker.cinematic",
						"cinematics/environment/light_c12_downflicker.cinematic",
						"cinematics/environment/light_repair_downflicker.cinematic",
						"cinematics/environment/lightrays_blue.cinematic",
						"cinematics/environment/lightrays_orange.cinematic",
						"cinematics/environment/sparks.cinematic",
						"cinematics/environment/sparks_loop_3s.cinematic",
						"cinematics/environment/steam.cinematic",
						"cinematics/environment/steam_ambiant.cinematic",
						"cinematics/environment/steam_rise.cinematic",
						"cinematics/environment/steamjet_ceiling.cinematic",
						"cinematics/environment/steamjet_ceiling_burst_4s.cinematic",
						"cinematics/environment/steamjet_large_soft.cinematic",
						"cinematics/environment/steamjet_wall.cinematic",
						"cinematics/environment/tram_skybox_tram1.cinematic",
						"cinematics/environment/tram_skybox_tram2.cinematic",
						"cinematics/environment/tram_skybox_tram3.cinematic",
						"cinematics/environment/water_bubbles_01.cinematic",
						"cinematics/environment/water_drip.cinematic",
						"cinematics/environment/water_drips_rapid.cinematic",
						"cinematics/environment/waterfall_basemist.cinematic",
						"cinematics/environment/waterfall_emerge.cinematic",
						"cinematics/environment/waterfall_fine.cinematic",
						"cinematics/environment/waterfall_large_basemist.cinematic"
					}
							
// Precache all the new cinematics
PrecacheAsset("chud_cinematics/blank.cinematic")
for i, cinematic in pairs(replacedCinematics) do
	PrecacheAsset(cinematic)
end

local originalSetCinematic
originalSetCinematic = Class_ReplaceMethod( "Cinematic", "SetCinematic", 
	function(self, cinematicName)
		//Print(cinematicName)
		if Client.fullyLoaded then
			if CHUDGetOption("particles") then
				if table.contains(replacedCinematics, cinematicName) then
					originalSetCinematic(self, "chud_" .. cinematicName)
				elseif table.contains(blockedCinematics, cinematicName) then
					originalSetCinematic(self, "chud_cinematics/blank.cinematic")
				// Easier than doing this in like 10 folders
				elseif string.find(cinematicName, "ricochetMinigun.cinematic") then
					originalSetCinematic(self, string.gsub(cinematicName, "ricochetMinigun.cinematic", "ricochet.cinematic"))
				else
					originalSetCinematic(self, cinematicName)
				end
			else
				originalSetCinematic(self, cinematicName)
			end
		else
			originalSetCinematic(self, cinematicName)
		end
	end
)

function CacheCinematics(className, groupName, values)
	if className == "cinematic" and table.contains(mapCinematicNames, values.cinematicName) then
		table.insert(cinematicsCache, Client.cinematics[#Client.cinematics])
		if not Client.fullyLoaded then
			table.insert(cinematicsValuesCache, {className = className, groupName = groupName, values = values})
		end
		table.remove(Client.cinematics, #Client.cinematics)
	end
end

function CreateCinematic(className, groupName, values)
	if className == "cinematic" then
	
		local cinematic = Client.CreateCinematic(RenderScene.Zone_Default)
		
		cinematic:SetCinematic(values.cinematicName)
		cinematic:SetCoords(values.angles:GetCoords(values.origin))
		
		local repeatStyle = Cinematic.Repeat_None
		
		if values.repeatStyle == 0 then
			repeatStyle = Cinematic.Repeat_Loop
		elseif values.repeatStyle == 1 then
			repeatStyle = Cinematic.Repeat_Loop
		elseif values.repeatStyle == 2 then
			repeatStyle = Cinematic.Repeat_Endless
		end
				
		cinematic:SetRepeatStyle(repeatStyle)
		
		cinematic.commanderInvisible = values.commanderInvisible
		cinematic.className = className
		cinematic.coords = coords
		
		if className == "cinematic" and table.contains(mapCinematicNames, values.cinematicName) then
			table.insert(cinematicsCache, cinematic)
		end
	end
end

local originalSetCommanderPropState = SetCommanderPropState
function SetCommanderPropState(isComm)
	originalSetCommanderPropState(isComm)
	if PropCache ~= nil then
		for index, propPair in ipairs(PropCache) do
			local prop = propPair[1]
			if prop.commAlpha < 1 then
				prop:SetIsVisible(not isComm)
			end
		end
	end
end

local originalLoadMapEntity = LoadMapEntity
function LoadMapEntity(className, groupName, values)
	local success = originalLoadMapEntity(className, groupName, values)
	if success then
		if className == "prop_static" and table.contains(BlockedProps, values.model) then
			table.insert(PropCache, Client.propList[#Client.propList])
			if not Client.fullyLoaded then
				table.insert(PropValuesCache, {className = className, groupName = groupName, values = values})
			end
			table.remove(Client.propList, #Client.propList)
		end
	end
	return success
end

function RemovePropDynamics()
	for _, entity in ientitylist(Shared.GetEntitiesWithClassname("PropDynamic")) do
		if table.contains (BlockedProps, entity:GetModelName()) and not CHUDGetOption("mapparticles") then
			entity:SetModel(nil)
		end
	end
end
		
function SetCHUDCinematics()
	if not CHUDGetOption("mapparticles") then
		if cinematicsCache ~= nil then
			for index, cinematic in ipairs(cinematicsCache) do
				Client.DestroyCinematic(cinematic)
			end
			cinematicsCache = { }
			cinematicsRemoved = true
		end
		if PropCache ~= nil then
			for index, models in ipairs(PropCache) do
				Client.DestroyRenderModel(models[1])
				Shared.DestroyCollisionObject(models[2])
			end
			PropCache = { }
			propsRemoved = true
		end
	else
		if cinematicsRemoved then
			for i, cinematic in pairs(cinematicsValuesCache) do
				CreateCinematic(cinematic.className, cinematic.groupName, cinematic.values)
			end
		end
		if propsRemoved then
			for i, prop in pairs(PropValuesCache) do
				LoadMapEntity(prop.className, prop.groupName, prop.values)
			end
		end		
	end
end

Event.Hook("UpdateClient", RemovePropDynamics)
Event.Hook("MapLoadEntity", CacheCinematics)