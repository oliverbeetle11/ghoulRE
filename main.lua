movedata = loadstring(game:HttpGet('https://raw.githubusercontent.com/oliverbeetle11/ghoulRE/refs/heads/main/movedata.lua'))()

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local Topbar = Instance.new("Frame", MainFrame)

ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

MainFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
MainFrame.Position = UDim2.new(0.5,0,0.5,0)
MainFrame.Size = UDim2.new(0,150,0,88)
MainFrame.AnchorPoint = Vector2.new(0,-0.5)

Topbar.BackgroundColor3 = Color3.fromRGB(0,0,0)
Topbar.Size = UDim2.new(0,150,0,16)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.new(1,1,1)
local UIStroke = UIStroke:Clone()
UIStroke.Parent = Topbar

local DefaultTextLabel = Instance.new("TextLabel", MainFrame)
DefaultTextLabel.BackgroundTransparency = 1
DefaultTextLabel.Size = UDim2.new(0,75,0,17)
DefaultTextLabel.ZIndex = 5
DefaultTextLabel.TextColor3 = Color3.new(1,1,1)
DefaultTextLabel.TextXAlignment = Enum.TextXAlignment.Left
DefaultTextLabel.TextYAlignment = Enum.TextYAlignment.Top
DefaultTextLabel.TextStrokeTransparency = 0

local Title = DefaultTextLabel:Clone()
local APLabel = DefaultTextLabel:Clone()
local APBindLabel = DefaultTextLabel:Clone()
local PingLabel = DefaultTextLabel:Clone()
local UIBindLabel = DefaultTextLabel:Clone()

Title.Size = UDim2.new(0,150,0,6)

Title.Parent = MainFrame
APLabel.Parent = MainFrame
APBindLabel.Parent = MainFrame
PingLabel.Parent = MainFrame
UIBindLabel.Parent = MainFrame

APLabel.Position = UDim2.new(0,0,0,15)
APBindLabel.Position = UDim2.new(0,0,0,50)
PingLabel.Position = UDim2.new(0,0,0,33)
UIBindLabel.Position = UDim2.new(0,0,0,67)

Title.Text = "beetle's ap"
APLabel.Text = "Autoparry"
APBindLabel.Text = "AP keybind"
PingLabel.Text = "Ping comp."
UIBindLabel.Text = "UI keybind"

DefaultTextLabel:Destroy()

local DefaultUIPadding = Instance.new("UIPadding", Title)
DefaultUIPadding.PaddingLeft = UDim.new(0.1,0)
DefaultUIPadding.PaddingTop = UDim.new(0.2,0)

local UIPadding = DefaultUIPadding:Clone()
UIPadding.Parent = APLabel
local UIPadding = DefaultUIPadding:Clone()
UIPadding.Parent = APBindLabel
local UIPadding = DefaultUIPadding:Clone()
UIPadding.Parent = PingLabel
local UIPadding = DefaultUIPadding:Clone()
UIPadding.Parent = UIBindLabel

DefaultUIPadding.PaddingLeft = UDim.new(0.02,0)

local APButton = Instance.new("TextButton", MainFrame)
local PingButton = Instance.new("TextButton", MainFrame)
local APBind = Instance.new("TextBox", MainFrame)
local UIBind = Instance.new("TextBox", MainFrame)

APButton.BackgroundColor3 = Color3.new(0,0,0)
APButton.BorderColor3 = Color3.new(1,1,1)
APButton.BorderSizePixel = 1
APButton.Position = UDim2.new(0,103,0,21)
APButton.Size = UDim2.new(0,40,0,11)
APButton.Text = "OFF"
APButton.TextColor3 = Color3.new(1,1,1)

PingButton.BackgroundColor3 = Color3.new(0,0,0)
PingButton.BorderColor3 = Color3.new(1,1,1)
PingButton.BorderSizePixel = 1
PingButton.Position = UDim2.new(0,103,0,38)
PingButton.Size = UDim2.new(0,40,0,11)
PingButton.Text = "OFF"
PingButton.TextColor3 = Color3.new(1,1,1)

APBind.BackgroundColor3 = Color3.new(0,0,0)
APBind.BorderColor3 = Color3.new(1,1,1)
APBind.BorderSizePixel = 1
APBind.Position = UDim2.new(0,103,0,56)
APBind.Size = UDim2.new(0,40,0,11)
APBind.TextColor3 = Color3.new(1,1,1)
APBind.PlaceholderText = "P"
APBind.Text = "P"

UIBind.BackgroundColor3 = Color3.new(0,0,0)
UIBind.BorderColor3 = Color3.new(1,1,1)
UIBind.BorderSizePixel = 1
UIBind.Position = UDim2.new(0,103,0,73)
UIBind.Size = UDim2.new(0,40,0,11)
UIBind.TextColor3 = Color3.new(1,1,1)
UIBind.PlaceholderText = "M"
UIBind.Text = "M"

local DragConnection
Topbar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local OriginalFramePosition = MainFrame.AbsolutePosition
		local MouseX, MouseY = Mouse.X, Mouse.Y
		DragConnection = RunService.Heartbeat:Connect(function(dt)
			MainFrame.Position = UDim2.new(0,OriginalFramePosition.X - MouseX + Mouse.X,0,OriginalFramePosition.Y - MouseY + Mouse.Y + 44)
		end)
	end
end)

Topbar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		DragConnection:Disconnect()
	end
end)

local APKeycode = Enum.KeyCode.P
local UIKeycode = Enum.KeyCode.M

local AutoParryEnabled = false
local PingCompensation = false

local Ping = LocalPlayer:GetNetworkPing() * 2000

local elapsedTime = 0
local PingConnection = RunService.Heartbeat:Connect(function(dt)
	elapsedTime += dt
	if elapsedTime // 3 then
		elapsedTime -= 3
		Ping = LocalPlayer:GetNetworkPing() * 2000
	end
end)

APButton.MouseButton1Click:Connect(function()
	AutoParryEnabled = not AutoParryEnabled
	if AutoParryEnabled then
		APButton.BackgroundColor3 = Color3.new(1,1,1)
		APButton.TextColor3 = Color3.new(0,0,0)
		APButton.Text = "ON"
	else
		APButton.BackgroundColor3 = Color3.new(0,0,0)
		APButton.TextColor3 = Color3.new(1,1,1)
		APButton.Text = "OFF"
	end
end)

PingButton.MouseButton1Click:Connect(function()
	PingCompensation = not PingCompensation
	if PingCompensation then
		PingButton.BackgroundColor3 = Color3.new(1,1,1)
		PingButton.TextColor3 = Color3.new(0,0,0)
		PingButton.Text = "ON"
	else
		PingButton.BackgroundColor3 = Color3.new(0,0,0)
		PingButton.TextColor3 = Color3.new(1,1,1)
		PingButton.Text = "OFF"
	end
end)

UserInputService.InputBegan:Connect(function(input, GPE)
	if not GPE then
		if input.KeyCode == APKeycode then
			AutoParryEnabled = not AutoParryEnabled
			if AutoParryEnabled then
				APButton.BackgroundColor3 = Color3.new(1,1,1)
				APButton.TextColor3 = Color3.new(0,0,0)
				APButton.Text = "ON"
			else
				APButton.BackgroundColor3 = Color3.new(0,0,0)
				APButton.TextColor3 = Color3.new(1,1,1)
				APButton.Text = "OFF"
			end
		elseif input.KeyCode == UIKeycode then
			ScreenGui.Enabled = not ScreenGui.Enabled
		end
	end
end)

APBind.FocusLost:Connect(function(enterPressed, input)
	if enterPressed then
		local success, response = pcall(function()
			if Enum.KeyCode[string.upper(APBind.Text)] then
				APKeycode = Enum.KeyCode[string.upper(APBind.Text)]
				APBind.PlaceholderText = string.upper(APBind.Text)
				APBind.Text = string.upper(APBind.Text)
			end
		end)
		
		if not success then
			APBind.Text = APBind.PlaceholderText
		end
	else
		APBind.Text = APBind.PlaceholderText
	end
end)

UIBind.FocusLost:Connect(function(enterPressed, input)
	if enterPressed then
		local success, response = pcall(function()
			if Enum.KeyCode[string.upper(UIBind.Text)] then
				UIKeycode = Enum.KeyCode[string.upper(UIBind.Text)]
				UIBind.PlaceholderText = string.upper(UIBind.Text)
				UIBind.Text = string.upper(UIBind.Text)
			end
		end)

		if not success then
			UIBind.Text = UIBind.PlaceholderText
		end
	else
		UIBind.Text = UIBind.PlaceholderText
	end
end)

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

	return dotProduct1 > 0.5 and dotProduct2 > 0.5
end

local function onCharacterAdded(character)
	if character == LocalPlayer.Character then return end
	
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then return end

	animator.AnimationPlayed:Connect(function(animationTrack)
		if AutoParryEnabled then
			if movedata[animationTrack.Animation.AnimationId] then
				local move = movedata[animationTrack.Animation.AnimationId]
				if move.Wait and LocalPlayer.Character then
					coroutine.wrap(function()
						task.wait(move.Wait / 1000 - (PingCompensation and (math.abs(Ping - 25)/1000) or 0) + 0.1)
						if (LocalPlayer.Character.HumanoidRootPart.CFrame.Position - character.HumanoidRootPart.CFrame.Position).Magnitude <= move.Range and DirectionCheck(LocalPlayer.Character, character) and AnimationCheck(character, animationTrack.Animation.AnimationId) then
							local args = {
								[1] = {
									[1] = {
										["Module"] = "Block",
										["Bool"] = true
									},
									[2] = "\5"
								}
							}
							game:GetService("ReplicatedStorage").Bridgenet2Main.dataRemoteEvent:FireServer(unpack(args))
							task.wait(0.1)
							local args = {
								[1] = {
									[1] = {
										["Module"] = "Block",
										["Bool"] = false
									},
									[2] = "\5"
								}
							}
							game:GetService("ReplicatedStorage").Bridgenet2Main.dataRemoteEvent:FireServer(unpack(args))
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
