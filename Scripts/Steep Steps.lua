if not game:IsLoaded() then game.Loaded:Wait() end
local GIFui = loadstring(game:HttpGet("https://raw.githubusercontent.com/GIFKITS/GIFscripts/refs/heads/main/GIF-UI%20Module/GIF-UI.lua"))()

local Services = {
	Players = game:GetService("Players"),
	UserInput = game:GetService("UserInputService"),
	Debris = game:GetService("Debris"),
	Run = game:GetService("RunService"),
}

--
local Window = GIFui:MakeWindow({Title="GIF-UI | Steep Steps"})
--
local PlayerTab = Window:AddTab({Title="Player"})
local CreditsTab = Window:AddTab({Title="Credits"})
Window:SetCurrentTab(PlayerTab)

--Player--
local Player = game.Players.LocalPlayer
local Character:Model
local Humanoid:Humanoid
local HumanoidRoot:BasePart

function UpdatePlayer()
	Character = Player.Character or Player.CharacterAdded:Wait()
	Humanoid = Character:FindFirstChildOfClass("Humanoid") or Character:WaitForChild("Humanoid")
	HumanoidRoot = Character:FindFirstChild("HumanoidRootPart") or Character:WaitForChild("HumanoidRootPart")
end
UpdatePlayer()
Player.CharacterAdded:Connect(function()
	task.wait(.5)
	UpdatePlayer()
end)

--Options--
--humanoid

PlayerTab:AddOption({Title="Jumps",Type="Text"})

local DefJumpPower = 50
local JumpPower = DefJumpPower
local InfJumps = false

local JumpCDtime = .1
local JumpCD = false

local JumpPowerConnection = nil
local JumpConnection = nil

PlayerTab:AddOption({Title="Enable Jumps",Type="Check",
	On = function()
		JumpConnection = Humanoid.Changed:Connect(function(Property)
			if not Humanoid or Property~="Jump" or JumpCD then return end
			if Humanoid.FloorMaterial==Enum.Material.Air and not InfJumps then return end
			
			JumpCD = true

			local Velocity = Instance.new("BodyVelocity",HumanoidRoot)
			Velocity.MaxForce = Vector3.one*math.huge
			Velocity.P = math.huge
			Velocity.Velocity = Vector3.new(0,JumpPower,0)
			Services.Debris:AddItem(Velocity,.001)
			
			task.wait(JumpCDtime)
			JumpCD = false
		end)
	end,
	Off = function()
		JumpConnection:Disconnect()
	end,
})

PlayerTab:AddOption({Title="Infinite Jumps (Don't jump too often!)",Type="Check",
	On = function()
		InfJumps = true
	end,
	Off = function()
		InfJumps = false
	end,
})

local ChangeJumpPower = DefJumpPower
PlayerTab:AddOption({Title="JumpPower",Type="InputCheck",PlaceHolder=tostring(DefJumpPower),
	On = function()
		JumpPowerConnection = Services.Run.RenderStepped:Connect(function()
			JumpPower = ChangeJumpPower
		end)
	end,
	Off = function()
		JumpPowerConnection:Disconnect()
		JumpPower = DefJumpPower
	end,
	Changed = function(Text)
		local Number = tonumber(Text)
		ChangeJumpPower = math.abs(Number or DefJumpPower)
	end,
})

PlayerTab:AddOption({Title="Player Speed",Type="Text"})

local DefWalkSpeed = game.StarterPlayer.CharacterWalkSpeed
local WalkSpeed = DefWalkSpeed
local WalkSpeedConnection = nil

PlayerTab:AddOption({Title="WalkSpeed",Type="InputCheck",PlaceHolder=tostring(DefWalkSpeed),
	On = function()
		WalkSpeedConnection = Services.Run.RenderStepped:Connect(function()
			if not Humanoid then return end
			Humanoid.WalkSpeed = WalkSpeed
		end)
	end,
	Off = function()
		WalkSpeedConnection:Disconnect()
		Humanoid.WalkSpeed = DefWalkSpeed
	end,
	Changed = function(Text)
		local Number = tonumber(Text)
		WalkSpeed = math.abs(Number or DefWalkSpeed)
	end,
})
