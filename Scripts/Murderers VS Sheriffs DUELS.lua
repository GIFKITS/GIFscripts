if not game:IsLoaded() then game.Loaded:Wait() end

local Services = {
	ReplicatedStorage = game:GetService("ReplicatedStorage"),
	Players = game:GetService("Players"),
	Run = game:GetService("RunService"),
}
local GIFui = loadstring(game:HttpGet("https://raw.githubusercontent.com/GIFKITS/GIFscripts/refs/heads/main/GIF-UI%20Module/GIF-UI"))()
local Window = GIFui:MakeWindow({Title="GIF-UI | Murderers VS Sheriffs DUELS"})

local MainTab = Window:AddTab({Title="Main"})
local CreditsTab = Window:AddTab({Title="Credits"})
Window:SetCurrentTab(MainTab)

local MyPlayer = Services.Players.LocalPlayer

--Function--
function ApplyForAll(Object, MyPlayerToo)
	for _,Player in pairs(Services.Players:GetPlayers()) do
		if not MyPlayerToo and MyPlayer==Player then continue end
		coroutine.wrap(Object)(Player)
	end
end

--Main--

--hitboxes
local HitboxSize = 1
local HitboxConnections = {}
local HitboxesOption = MainTab:AddOption({Title="Rescale Hitboxes",Type="InputCheck",
	On = function(Text)
		table.insert(HitboxConnections,Services.Run.Heartbeat:Connect(function()
			ApplyForAll(function(Player)
				local Character = Player.Character or Player.CharacterAdded:Wait()
				if not Character then return end
				local HumanoidRootPart:BasePart = Character:FindFirstChild("HumanoidRootPart")
				if not HumanoidRootPart then return end
				HumanoidRootPart.Transparency = .8
				HumanoidRootPart.Size = Vector3.one*HitboxSize
				HumanoidRootPart.BrickColor = BrickColor.new("Lime green")
				HumanoidRootPart.Material = Enum.Material.Neon
			end,false)
		end))
	end,
	Off = function(Text)
		for _,Connection in pairs(HitboxConnections) do
			Connection:Disconnect()
		end
		ApplyForAll(function(Player)
			local Character = Player.Character or Player.CharacterAdded:Wait()
			if not Character then return end
			local HumanoidRootPart:BasePart = Character:FindFirstChild("HumanoidRootPart")
			if not HumanoidRootPart then return end
			HumanoidRootPart.Transparency = 1
			HumanoidRootPart.Size = Vector3.new(2,2,1)
			HumanoidRootPart.Color = Color3.fromRGB(127,127,127)
			HumanoidRootPart.Material = Enum.Material.Plastic
		end,false)
	end,
	Changed = function(Text)
		local Number = tonumber(Text)
		HitboxSize = math.abs(Number or 0)
		if HitboxSize==0 then
			HitboxSize = 1
		end
	end,
})

--credits
CreditsTab:MakeSpace()
CreditsTab:AddOption({Title="Made by GIFKITS",Type="Text"})
CreditsTab:AddOption({Title="❤️ Thank You For Using This Script ❤️",Type="Text"})
CreditsTab:AddOption({Title="gif-ui lib",Type="Text"})
