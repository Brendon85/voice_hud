local microphoneEnabled   = true
local isCurrentlySpeaking = false
local voiceDistance = 0
local runLoop 		= true
local voiceModes = {}

local Config = {
	MeterText = " m",
	MicOffText = "Mic Off",
	VoiceRanges = {3, 8, 15, 32}
}

RegisterNetEvent('pma-voice:radioActive')
AddEventHandler('pma-voice:radioActive', function(isActive)
	microphoneEnabled = isActive
end)

AddEventHandler('pma-voice:setTalkingMode', function(newTalkingRange)
	voiceDistance = newTalkingRange
end)

exports('StatusSetTalking', function(talking)
	isCurrentlySpeaking = talking
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local talkingStatus = MumbleIsPlayerTalking(PlayerId())
		if isCurrentlySpeaking ~= talkingStatus then
			isCurrentlySpeaking = talkingStatus
		end
	end
end)

TriggerEvent("pma-voice:settingsCallback", function(settings)
	local voiceTable = settings.voiceModes
	for i = 1, #voiceTable do
		voiceModes[i] = voiceTable[i][1]
	end
end)

Citizen.CreateThread(function()
	voiceDistance = voiceDistance or nil

	while true do
		Citizen.Wait(100)

		if runLoop then
			local voiceRangeText = Config.MicOffText
			if microphoneEnabled and voiceDistance and Config.VoiceRanges[voiceDistance] then
				voiceRangeText = Config.VoiceRanges[voiceDistance] .. Config.MeterText
		
			end

			SendNUIMessage({
				action = "updateStatusHud",
				show = not IsRadarHidden(),
				voiceRange = voiceRangeText,
				micEnabled = microphoneEnabled
			})

			if not IsRadarHidden() then
				SendNUIMessage({
					action     = "updatespeech",
					speaking   = isCurrentlySpeaking,
					micEnabled = microphoneEnabled
				})
			end
		end
	end
end)

RegisterNetEvent("voice_hud:client:enableHud")
AddEventHandler("voice_hud:client:enableHud", function()
	runLoop = true
	SendNUIMessage({ show = runLoop })
end)

RegisterNetEvent("voice_hud:client:disableHud")
AddEventHandler("voice_hud:client:disableHud", function()
	runLoop = false
	SendNUIMessage({ show = runLoop })
end)

