Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")

vRPgun = {}
vRP = Proxy.getInterface("vRP")
GUNserver = Tunnel.getInterface("vrp_license")
Tunnel.bindInterface("vrp_license",vRPgun)
Proxy.addInterface("vrp_license",vRPgun)
cfg = module("vrp_license", "cfg/dmv")
lang = module("vrp_license", "cfg/lang/"..cfg.lang)

DTutOpen = false
license = false


start_pos = {}

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function DrawMissionText2(m_text, showtime)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

function LocalPed()
	return GetPlayerPed(-1)
end

function Chat(debugg)
    TriggerEvent("chatMessage", '', { 0, 0x99, 255 }, tostring(debugg))
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

function vRPgun.payFirearmsLicense()
	drawNotification(lang.client.buy_success)
	GUNserver.setLicense()
	TestDone = true
	EndTestTasks()
end

---------------------------------- DMV PED ----------------------------------

Citizen.CreateThread(function()

  RequestModel(GetHashKey("a_m_y_business_01"))
  while not HasModelLoaded(GetHashKey("a_m_y_business_01")) do
    Wait(1)
  end

  RequestAnimDict("mini@strip_club@idles@bouncer@base")
  while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
    Wait(1)
  end

 	    -- Spawn the DMV Ped
  for _, item in pairs(cfg.dmv.peds) do
    dmvmainped =  CreatePed(item.type, item.hash, item.x, item.y, item.z, item.h, false, true)
    SetEntityHeading(dmvmainped, item.h)
    FreezeEntityPosition(dmvmainped, true)
	SetEntityInvincible(dmvmainped, true)
	SetBlockingOfNonTemporaryEvents(dmvmainped, true)
    TaskPlayAnim(dmvmainped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
    end
end)

local talktodmvped = true
--DMV Ped interaction
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local pos = GetEntityCoords(GetPlayerPed(-1), false)
		for k,v in pairs(cfg.dmv.peds) do
			if(Vdist(v.x, v.y, v.z, pos.x, pos.y, pos.z) < 3.0)then
				DisplayHelpText(lang.client.interact)
				if(IsControlJustReleased(1, 38))then
						if talktodmvped then
						    Citizen.Wait(500)
							GUNMenu()
							Menu.hidden = false
							talktodmvped = false
						else
							talktodmvped = true
						end
				end
				Menu.renderGUI(cfg.dmv.menu)
			end
		end
	end
end)

------------
------------ DRAW MENUS
------------
function GUNMenu()
	ClearMenu()
	Menu.addButton(lang.client.menu.obtain,"GunLicenseMenu",nil)
    Menu.addButton(lang.client.menu.mclose,"CloseMenu",nil) 
end

function GunLicenseMenu()
    ClearMenu()
	Menu.addButton(lang.client.menu.practical,"payFirearmsLicense",nil)
    Menu.addButton(lang.client.menu.mreturn,"GUNMenu",nil) 
end

function CloseMenu()
		Menu.hidden = true
end

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(true, true)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

----------------
----------------blip
----------------



Citizen.CreateThread(function()
  for k,v in pairs(cfg.dmv.peds) do
	local blip = AddBlipForCoord(v.x,v.y,v.z)
	SetBlipSprite(blip,cfg.dmv.blip.id)
	SetBlipColour(blip,cfg.dmv.blip.colour)
	SetBlipScale(blip,cfg.dmv.blip.size)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(cfg.dmv.blip.title)
	EndTextCommandSetBlipName(blip)
	SetBlipAsShortRange(blip,true)
	SetBlipAsMissionCreatorBlip(blip,true)
  end
end)