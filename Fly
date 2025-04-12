local Services = {
	UserInput = game:GetService("UserInputService"),
	Players = game:GetService("Players"),
	Run = game:GetService("RunService"),
	Tween = game:GetService("TweenService"),
}

local Player = Services.Players.LocalPlayer
local PlayerGui = Player.PlayerGui
local Camera = workspace.CurrentCamera
--
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRoot:BasePart = Character:FindFirstChild("HumanoidRootPart")
local Humanoid = Character:FindFirstChildOfClass("Humanoid")
--
local Connections = {}
local Connect = nil

local IsFlying = false
local FlyKey = Enum.KeyCode.X
local UnloadKey = Enum.KeyCode.RightAlt
local BaseSpeed = 100
local Speed = BaseSpeed

--Configs--
local Gui = Instance.new("ScreenGui",PlayerGui)
Gui.IgnoreGuiInset = true
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local SpeedChanger = Instance.new("TextBox",Gui)
SpeedChanger.Size = UDim2.fromScale(.189,.033)
SpeedChanger.Position = UDim2.fromScale(.79,.086)
SpeedChanger.PlaceholderColor3 = Color3.fromRGB(150,150,150)
SpeedChanger.TextColor3 = Color3.fromRGB(255,255,255)
SpeedChanger.TextScaled = true
SpeedChanger.Font = Enum.Font.Highway
SpeedChanger.BackgroundColor3 = Color3.fromRGB(0,0,0)
SpeedChanger.BackgroundTransparency = .5
SpeedChanger.BorderSizePixel = 0
SpeedChanger.Text = ""
SpeedChanger.PlaceholderText = "speed: "..tostring(BaseSpeed)
local FlyTip = Instance.new("TextLabel",SpeedChanger)
FlyTip.BackgroundTransparency = 1
FlyTip.Position = UDim2.fromScale(0,-.908)
FlyTip.Size = UDim2.fromScale(1,.908)
FlyTip.TextColor3 = Color3.fromRGB(255,255,255)
FlyTip.TextScaled = true
FlyTip.Font = Enum.Font.Highway
FlyTip.Text = tostring(FlyKey.Name).." - To Fly"
local UnloadTip = Instance.new("TextLabel",SpeedChanger)
UnloadTip.BackgroundTransparency = 1
UnloadTip.Position = UDim2.fromScale(0,-1.847)
UnloadTip.Size = UDim2.fromScale(1,.908)
UnloadTip.TextColor3 = Color3.fromRGB(255,255,255)
UnloadTip.TextScaled = true
UnloadTip.Font = Enum.Font.Highway
UnloadTip.Text = tostring(UnloadKey.Name).." - To Unload"
--

local BodyVelocity = Instance.new("BodyVelocity",Character)
local BodyGyro = Instance.new("BodyGyro",Character)
BodyVelocity.MaxForce = Vector3.one*math.huge
BodyGyro.MaxTorque = Vector3.one*math.huge

function GetDirection()
	if Humanoid.MoveDirection==Vector3.new() then return Vector3.new() end
	--
	local Direction = (Camera.CFrame * CFrame.new((CFrame.new(Camera.CFrame.p, Camera.CFrame.p + Vector3.new(Camera.CFrame.lookVector.x, 0, Camera.CFrame.lookVector.z)):VectorToObjectSpace(Humanoid.MoveDirection)))).p - Camera.CFrame.p
	--
	if Direction==Vector3.new() then return Direction end
	return Direction.Unit
end

Connect = Services.UserInput.InputBegan:Connect(function(InputKey, Event)
	if Event then return end
	
	if InputKey.KeyCode==FlyKey then
		--
		IsFlying = not IsFlying

		if IsFlying then
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
			Humanoid:ChangeState(6)
			BodyVelocity.Parent = HumanoidRoot
			BodyGyro.Parent = HumanoidRoot
		else
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
			Humanoid:ChangeState(8)
			BodyVelocity.Parent = Character
			BodyGyro.Parent = Character

			for _,BodyPart in pairs(Character:GetChildren()) do
				if not BodyPart:IsA("BasePart") then continue end
				BodyPart.CanCollide = true
			end
		end
	elseif InputKey.KeyCode==UnloadKey then
		--
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
		Humanoid:ChangeState(8)

		for _,BodyPart in pairs(Character:GetChildren()) do
			if not BodyPart:IsA("BasePart") then continue end
			BodyPart.CanCollide = true
		end
		
		Gui:Destroy()
		BodyVelocity:Destroy()
		BodyGyro:Destroy()
		
		for _,Connection in pairs(Connections) do
			Connection:Disconnect()
		end
		
		script.Disabled = true
	end
end)
table.insert(Connections,Connect)

Connect = Services.Run.Heartbeat:Connect(function()
	if not IsFlying then return end
	
	Humanoid:ChangeState(6)
	BodyGyro.CFrame = Camera.CFrame
	Services.Tween:Create(BodyVelocity,TweenInfo.new(.3),{Velocity=GetDirection()*Speed}):Play()
	
	for _,BodyPart in pairs(Character:GetChildren()) do
		if not BodyPart:IsA("BasePart") then continue end
		BodyPart.CanCollide = false
	end
end)
table.insert(Connections,Connect)

Connect = SpeedChanger.Changed:Connect(function(Prop)
	if Prop~="Text" then return end
	--
	if tonumber(SpeedChanger.Text) then
		Speed = tonumber(SpeedChanger.Text)
	else
		Speed = BaseSpeed
	end
end)
table.insert(Connections,Connect)

while task.wait() do
	Character = Player.Character or Player.CharacterAdded:Wait()
	HumanoidRoot = Character:FindFirstChild("HumanoidRootPart")
	Humanoid = Character:FindFirstChildOfClass("Humanoid")
end
