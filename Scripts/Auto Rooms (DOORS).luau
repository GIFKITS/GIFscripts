-- SERVICES --

local RS = game:GetService("ReplicatedStorage")
local pathfinding = game:GetService("PathfindingService")
local players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local run = game:GetService("RunService")
local virtualUser = game:GetService("VirtualUser")

-- PLAYER --

local player = players.LocalPlayer
local character:Model
local humanoid:Humanoid
local root:BasePart

local function updateCharacter()
	character = player.Character or player.CharacterAdded:Wait()
	humanoid = character:WaitForChild("Humanoid")
	root = character:WaitForChild("HumanoidRootPart")
end
updateCharacter()

-- AUTO WALK --

local path = pathfinding:CreatePath({
	WaypointSpacing = 1,
	AgentCanJump = false,
	AgentRadius = 2,

})

local currentWaypoints = {}
local currentWaypointIndex = 1
local lastUpdated = nil
local lastGoal = nil
local hiding = false

local originalGravity = workspace.Gravity
local autoWalkEnabled = false

local currentRooms:Folder = workspace:WaitForChild("CurrentRooms")
local latestRoom:StringValue = game.ReplicatedStorage:WaitForChild("GameData"):WaitForChild("LatestRoom")
local camLock:RemoteEvent = game.ReplicatedStorage.RemotesFolder.CamLock

local function getLocker() : BasePart
	local locker:BasePart = nil

	for _,prompt in pairs(currentRooms:GetDescendants()) do
		if prompt.Name~="HidePrompt" then continue end
		local part = prompt.Parent

		local hiddenPlayer:ObjectValue = part:FindFirstChild("HiddenPlayer")
		local base:BasePart = part:FindFirstChild("Base")

		if not base or base.Position.Y <= -3 or not hiddenPlayer or hiddenPlayer.Value then continue end
		if not locker then
			locker = base
		else
			local closestDistance = (locker.Position - root.Position).Magnitude
			local newDistance = (root.Position - base.Position).Magnitude
			if newDistance < closestDistance then locker = base end
		end
	end

	return locker
end

local function checkEntities()
	local entity = workspace:FindFirstChild("A60") or workspace:FindFirstChild("A120")
	return entity ~= nil
end

local function getGoal() : BasePart
	if checkEntities() then
		local locker = getLocker()
		if locker then return locker end
	end

	local currentRoom:Model = currentRooms:FindFirstChild(tostring(latestRoom.Value))
	if not currentRoom then return end

	local door1 = currentRoom:FindFirstChild("Door")
	if not door1 then return end

	local door2 = door1:FindFirstChild("Door")
	if not door2 then return end

	return door2
end

local function hide(lockerModel)
	if hiding then return end

	local prompt:ProximityPrompt = lockerModel:FindFirstChild("HidePrompt")
	if not prompt then return end

	local camera = workspace.CurrentCamera
	if camera then
		camera.CFrame = CFrame.new(camera.CFrame.Position, lockerModel:GetPivot().Position)
	end

	fireproximityprompt(prompt)
	hiding = true

	repeat task.wait() until not checkEntities()

	camLock:FireServer()
	hiding = false
	humanoid:MoveTo(root.Position+root.CFrame.LookVector)
end

local collisionList = {
	"HumanoidRootPart",
	"UpperTorso",
	"LowerTorso",
	"Torso",
}

local collide = "Player"
local noCollide = "None"

local function setCollision(enable:boolean)
	for _,part:BasePart in pairs(character:GetChildren()) do
		if not part:IsA("BasePart") then continue end
		part.CollisionGroup = enable and collide or noCollide
	end
end

-- FULLBRIGHT --

local fullbrightEnabled = false

-- ANTI AFK --

local antiAFKenabled = false

-- SPEED BOOST --

local speedBoost = 0

-- LIB --

local GIFui
if run:IsStudio() then
	GIFui = require(RS:FindFirstChild("GIFui"))
else
	GIFui = loadstring(game:HttpGet("https://raw.githubusercontent.com/GIFKITS/gifkits/refs/heads/main/lib/GIFui.luau"))()
end

local window = GIFui:CreateWindow("rooms auto walk")
table.insert(window._conns,player.CharacterAdded:Connect(updateCharacter))

local mainTab = window:CreateTab("Main")
window.CurrentTab = mainTab

mainTab:CreateToggle("Auto Walk (fly)","pass rooms automatically",autoWalkEnabled,function(value)
	autoWalkEnabled = value
	if value then
		workspace.Gravity = 0
	else
		workspace.Gravity = originalGravity
	end
end)

mainTab:CreateToggle("Fullbright","you can see in the dark",fullbrightEnabled,function(value)
	fullbrightEnabled = value
end)

mainTab:CreateToggle("Anti-AFK","you won't be kicked after 20 mins",antiAFKenabled,function(value)
	antiAFKenabled = value
end)

mainTab:CreateInput("Speed Boost","speed up (7-6 recommended)",function(value)
	speedBoost = value or 0
end)

-- CONNECTIONS --

table.insert(window._conns,player.Idled:Connect(function()
	if not antiAFKenabled then return end
	virtualUser:CaptureController()
	virtualUser:ClickButton2(Vector2.new())
end))

table.insert(window._conns,run.RenderStepped:Connect(function(deltaTime)
	character:SetAttribute("SpeedBoost", speedBoost)

	if fullbrightEnabled then
		Lighting.Ambient = Color3.new(1,1,1)
	end

	setCollision(not autoWalkEnabled)

	if autoWalkEnabled and root then
		root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
	end

	if not root or not humanoid or not autoWalkEnabled then return end

	local currentGoal = getGoal()
	if not currentGoal then return end

	local walkTo = currentGoal.Position
	if currentGoal.Parent:FindFirstChild("HidePrompt") then
		walkTo = currentGoal.Position+currentGoal.CFrame.LookVector*2
	end

	local currentTime = os.clock()
	if currentGoal ~= lastGoal or not lastUpdated or (currentTime - lastUpdated > 1.5) then
		lastGoal = currentGoal
		lastUpdated = currentTime
		local success, error = pcall(function()
			path:ComputeAsync(root.Position - Vector3.new(0,2.5,0), walkTo)
		end)
		if success and path.Status == Enum.PathStatus.Success then
			currentWaypoints = path:GetWaypoints()
			currentWaypointIndex = 2
		end
	end

	if currentWaypoints and currentWaypointIndex <= #currentWaypoints and not hiding then
		local waypoint = currentWaypoints[currentWaypointIndex]
		local targetPos = waypoint.Position + Vector3.new(0, 3.5, 0)

		local offset = targetPos - root.Position
		local distance = offset.Magnitude

		if distance < 2 then
			currentWaypointIndex = currentWaypointIndex + 1
			return
		end

		local distanceToGoal = (walkTo - root.Position).Magnitude

		if distanceToGoal < 3 and currentGoal.Parent:FindFirstChild("HidePrompt") then
			hide(currentGoal.Parent)
			return
		end

		local speed = humanoid.WalkSpeed

		local direction = offset.Unit
		local move = direction * speed * deltaTime

		if move.Magnitude > distance then
			move = offset
		end

		local newPos = root.Position + move
		local lookDir = Vector3.new(direction.X, 0, direction.Z)

		if lookDir.Magnitude > 0.001 then
			root.CFrame = CFrame.new(newPos, newPos + lookDir)
		else
			root.CFrame = CFrame.new(newPos, newPos + root.CFrame.LookVector)
		end
	end
end))
