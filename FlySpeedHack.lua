-- Red GUI Fly Speed Hack Script

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlySpeedHackGui"
ScreenGui.Parent = game.CoreGui

-- Create main frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Position = UDim2.new(0.5, -100, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

-- Create title label
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Fly Speed Hack"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = Frame

-- Create speed label
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0, 80, 0, 25)
SpeedLabel.Position = UDim2.new(0, 10, 0, 40)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed:"
SpeedLabel.TextColor3 = Color3.new(1,1,1)
SpeedLabel.Font = Enum.Font.SourceSans
SpeedLabel.TextSize = 18
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = Frame

-- Create speed textbox
local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(0, 100, 0, 25)
SpeedBox.Position = UDim2.new(0, 80, 0, 40)
SpeedBox.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
SpeedBox.TextColor3 = Color3.new(1,1,1)
SpeedBox.Font = Enum.Font.SourceSans
SpeedBox.TextSize = 18
SpeedBox.Text = "50"
SpeedBox.ClearTextOnFocus = false
SpeedBox.Parent = Frame

-- Create toggle fly button
local FlyButton = Instance.new("TextButton")
FlyButton.Size = UDim2.new(0, 180, 0, 40)
FlyButton.Position = UDim2.new(0, 10, 0, 80)
FlyButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
FlyButton.TextColor3 = Color3.new(1,1,1)
FlyButton.Font = Enum.Font.SourceSansBold
FlyButton.TextSize = 22
FlyButton.Text = "Toggle Fly"
FlyButton.Parent = Frame

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 50
local velocity = Instance.new("BodyVelocity")
velocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
velocity.Velocity = Vector3.new(0,0,0)
velocity.Parent = humanoidRootPart

local function updateSpeed()
	local val = tonumber(SpeedBox.Text)
	if val and val > 0 then
		speed = val
	else
		speed = 50
		SpeedBox.Text = "50"
	end
end

SpeedBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		updateSpeed()
	end
end)

FlyButton.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		FlyButton.Text = "Fly: ON"
	else
		FlyButton.Text = "Fly: OFF"
		velocity.Velocity = Vector3.new(0,0,0)
	end
end)

local function getFlyDirection()
	local direction = Vector3.new(0,0,0)
	if UserInputService:IsKeyDown(Enum.KeyCode.W) then
		direction = direction + workspace.CurrentCamera.CFrame.LookVector
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then
		direction = direction - workspace.CurrentCamera.CFrame.LookVector
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then
		direction = direction - workspace.CurrentCamera.CFrame.RightVector
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then
		direction = direction + workspace.CurrentCamera.CFrame.RightVector
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
		direction = direction + Vector3.new(0,1,0)
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
		direction = direction - Vector3.new(0,1,0)
	end
	return direction.Unit
end

RunService.Heartbeat:Connect(function()
	if flying then
		updateSpeed()
		local dir = getFlyDirection()
		if dir.Magnitude > 0 then
			velocity.Velocity = dir * speed
		else
			velocity.Velocity = Vector3.new(0,0,0)
		end
	else
		velocity.Velocity = Vector3.new(0,0,0)
	end
end)
