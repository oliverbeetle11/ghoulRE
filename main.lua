local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local movedata = loadstring(game:HttpGet('https://raw.githubusercontent.com/oliverbeetle11/ghoulRE/refs/heads/main/movedata.lua'))()
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/oliverbeetle11/ghoulRE/refs/heads/main/library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local LocalPlayer = Players.LocalPlayer

local Window = Library:CreateWindow({
	Title = 'Veritas Hub | v0.01t',
	Center = true,
	AutoShow = true,
	TabPadding = 8,
	MenuFadeTime = 0.2
})

local Tabs = {
	['Auto Parry'] = Window:AddTab('Auto Parry'),
	['Teleport'] = Window:AddTab('Teleport'),
	Settings = Window:AddTab('Settings'),
}

local TeleportLeftGroupBox = Tabs["Teleport"]:AddLeftGroupbox("Teleport")
local PlayerDropdown = TeleportLeftGroupBox:AddDropdown('PlayerDropdown', {
	SpecialType = 'Player',
	Text = 'Players',

	Callback = function(Value)
		print('[cb] Player dropdown got changed:', Value)
	end
})
local TeleportButton = TeleportLeftGroupBox:AddButton({
	Text = 'Teleport',
	Func = function()
		if Options.PlayerDropdown.Value then
			local Player = Options.PlayerDropdown.Valu
			if Players:FindFirstChild(Player) then
				if Player.Character and LocalPlayer.Character then
					local Time = (LocalPlayer.Character.HumanoidRootPart.Postition - Player.Character.HumanoidRootPart.CFrame.Position).Magnitude / Options.TeleportSpeedSlider.Value
					TweenService:Create(LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Time, Enum.EasingStyle.Linear), {CFrame = Player.Character.HumanoidRootPart.CFrame})
				end
			end
		end
	end,
	DoubleClick = false,
})
TeleportLeftGroupBox:AddSlider('TeleportSpeedSlider', { Text = 'Teleport Speed', Default = 100, Min = 50, Max = 500, Rounding = 0 });

local LeftGroupBox = Tabs['Auto Parry']:AddLeftGroupbox('Auto Parry')

LeftGroupBox:AddToggle('AutoParry', {
	Text = 'Auto Parry',
	Default = false,
})

Toggles.AutoParry:OnChanged(function()
	print('AutoParry changed to:', Toggles.AutoParry.Value)
end)

Toggles.AutoParry:AddKeyPicker('KeyPicker', {
	Default = 'L',
	SyncToggleState = true,

	Mode = 'Toggle',

	Text = 'Auto Parry Toggle',
	NoUI = true,

	Callback = function(Value)
		print('[cb] Keybind clicked!', Value)
	end,

	ChangedCallback = function(New)
		print('[cb] Keybind changed!', New)
	end
})

LeftGroupBox:AddToggle('PingComp', { Text = 'Ping Compensation' });
local Depbox = LeftGroupBox:AddDependencyBox();
Depbox:AddToggle('CustomPing', { Text = 'Custom Ping Variable' });
local SubDepbox = Depbox:AddDependencyBox();
SubDepbox:AddSlider('CustomPingSlider', { Text = 'Custom Ping', Default = 50, Min = 0, Max = 250, Rounding = 0 });

LeftGroupBox:AddToggle('CustomDelay', { Text = 'Custom Delay', Tooltip = 'Use if you experience more ping spikes' });
local DelayDepox = LeftGroupBox:AddDependencyBox();
DelayDepox:AddSlider('CustomDelaySlider', { Text = 'Custom Delay', Default = 50, Min = 0, Max = 250, Rounding = 0 });

Depbox:SetupDependencies({
	{ Toggles.PingComp, true }
});

SubDepbox:SetupDependencies({
	{ Toggles.CustomPing, true }
});

DelayDepox:SetupDependencies({
	{ Toggles.CustomDelay, true }
});

LeftGroupBox:AddDivider()
LeftGroupBox:AddLabel("Additional Modifications")
LeftGroupBox:AddToggle('DirectionCheck', { Text = 'Direction Check', Tooltip = '0.6 recommended' }); -- Add depobox that allows to tweak the cone
local DirectionDepox = LeftGroupBox:AddDependencyBox();
DirectionDepox:AddSlider('DirectionSlider', { Text = 'Direction Cone', Default = 0, Min = 0, Max = 1, Rounding = 2 });

DirectionDepox:SetupDependencies({
	{ Toggles.DirectionCheck, true }
});

LeftGroupBox:AddToggle('VelocityCheck', { Text = 'Velocity Check' });
LeftGroupBox:AddToggle('AutoFeint', { Text = 'Auto Feint' });

local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
	FrameCounter += 1;

	if (tick() - FrameTimer) >= 1 then
		FPS = FrameCounter;
		FrameTimer = tick();
		FrameCounter = 0;
	end;

	Library:SetWatermark(('Veritas | v0.01t | %s fps | %s ms'):format(
		math.floor(FPS),
		math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
		));
end);

Library:OnUnload(function()
	WatermarkConnection:Disconnect()

	print('Unloaded!')
	Library.Unloaded = true
end)

local MenuGroup = Tabs['Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/Veritas')
SaveManager:BuildConfigSection(Tabs['Settings'])
ThemeManager:ApplyToTab(Tabs['Settings'])
SaveManager:LoadAutoloadConfig()

local function AnimationCheck(character, animationId)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return false end

	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then return false end

	local tracks = animator:GetPlayingAnimationTracks()
	for _, track in ipairs(tracks) do
		if track.Animation.AnimationId == animationId then
			return true
		end
	end

	return false
end

local function DirectionCheck(character1, character2)
	local rootPart1 = character1 and character1:FindFirstChild("HumanoidRootPart")
	local rootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
	if not rootPart1 or not rootPart2 then return false end

	local lookVector1 = rootPart1.CFrame.LookVector
	local lookVector2 = rootPart2.CFrame.LookVector
	local vectorBetween = (rootPart2.Position - rootPart1.Position).unit

	local dotProduct1 = lookVector1:Dot(vectorBetween)
	local dotProduct2 = lookVector2:Dot(-vectorBetween)

	return dotProduct1 > Options.DirectionSlider.Value and dotProduct2 > Options.DirectionSlider.Value
end

local function onCharacterAdded(character)
	if character == LocalPlayer.Character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then return end

	animator.AnimationPlayed:Connect(function(animationTrack)
		if Toggles.AutoParry.Value then
			if movedata[animationTrack.Animation.AnimationId] then
				local move = movedata[animationTrack.Animation.AnimationId]
				if move.Wait and LocalPlayer.Character then
					coroutine.wrap(function()
						local AccumulatedDelay = -0.1
						if Toggles.PingComp.Value and Toggles.CustomPing.Value then
							AccumulatedDelay += Options.CustomPingSlider.Value / 1000
						elseif Toggles.PingComp.Value then
							AccumulatedDelay += LocalPlayer:GetNetworkPing() * 2
						end	
						
						if Toggles.CustomDelay.Value then
							AccumulatedDelay += Options.CustomDelaySlider.Value / 1000
						end
						
						task.wait(move.Wait / 1000 - AccumulatedDelay)

						if Toggles.DirectionCheck.Value then
							if not DirectionCheck(LocalPlayer.Character, character) then return end
						end

						if (LocalPlayer.Character.HumanoidRootPart.CFrame.Position - character.HumanoidRootPart.CFrame.Position).Magnitude <= move.Range and AnimationCheck(character, animationTrack.Animation.AnimationId) then
							game:GetService("ReplicatedStorage").Bridgenet2Main.dataRemoteEvent:FireServer(unpack({{{Module = "Block", Bool = true}, "\5"}}))
							task.wait(0.1)
							game:GetService("ReplicatedStorage").Bridgenet2Main.dataRemoteEvent:FireServer(unpack({{{Module = "Block", Bool = false}, "\5"}}))
						end
					end)()
				end
			end
		end
	end)
end

function onPlayerAdded(player)
	player.CharacterAdded:Connect(onCharacterAdded)
	if player.Character then
		onCharacterAdded(player.Character)
	end
end

for _, player in ipairs(Players:GetPlayers()) do
	if player ~= Players.LocalPlayer then
		onPlayerAdded(player)
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)
