
if not game:IsLoaded() then game.Loaded:Wait() end

local Services = {
	Players = game:GetService("Players"),
	Input = game:GetService("UserInputService"),
	Tween = game:GetService("TweenService"),
	Run = game:GetService("RunService"),
}

local GifUI_lib = {
	Elements = {},
	Connections = {},
	--
	MainFont = Enum.Font.Highway,
}

local Player = Services.Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local RealParent = game:FindFirstChild("CoreGui") or PlayerGui
--
local GifUI = Instance.new("ScreenGui", RealParent)
GifUI.Name = "GifUI"
GifUI.IgnoreGuiInset = true
GifUI.ResetOnSpawn = false
GifUI.DisplayOrder = 999999
GifUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Break
function IsRunning()
	return GifUI:IsDescendantOf(RealParent)
end

spawn(function()
	while (IsRunning()) do
		wait()
	end
	--
	for _,Connect in next, GifUI_lib.Connections do
		Connect:Disconnect()
	end
end)

-- Other

function AddConnection(Signal, Function)
	if (not IsRunning()) then return end
	--
	local Connect = Signal:Connect(Function)
	table.insert(GifUI_lib.Connections,Connect)
	--
	return Connect
end

--===============================================

-- Functions
function CreateObject(Name:string, Properties, Children)
	--
	local Object = Instance.new(Name)
	for Property, Value in next, Properties or {} do
		--
		Object[Property] = Value
	end
	--
	for _,Child in next, Children or {} do
		--
		Child.Parent = Object
	end
	--
	return Object
end

function AddElement(Name:string, Function)
	--
	GifUI_lib.Elements[Name] = function(...)
		return Function(...)
	end
end

function MakeElement(Name:string, ...)
	--
	local Element = GifUI_lib.Elements[Name](...)
	return Element
end

function SetProperties(Object, Properties)
	--
	for Property, Value in next, Properties or {} do
		--
		Object[Property] = Value
	end
	return Object
end

function SetChildren(Object, Children)
	--
	for _,Child in next, Children or {} do
		--
		Child.Parent = Object
	end
	return Object
end

function AddClickSound(Button)
	--
	local Sound = Instance.new("Sound",Button)
	Sound.SoundId = "rbxassetid://17208396156"
	--
	AddConnection(Button.MouseButton1Click,function()
		--
		Sound:Play()
	end)
end

--===============================================

-- Elements
AddElement("Frame",function(Color, CornerSize)
	local Object = CreateObject("Frame",{
		--
		BackgroundColor3 = Color or Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
	},{
		CreateObject("UICorner",{
			CornerRadius = UDim.new(CornerSize or 0, 0),
		})
	})
	return Object
end)
--
AddElement("Canvas",function(Color, Transparency, CornerSize)
	local Object = CreateObject("CanvasGroup",{
		--
		BackgroundColor3 = Color or Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = Transparency or 1,
		BorderSizePixel = 0,
	},{
		CreateObject("UICorner",{
			CornerRadius = UDim.new(CornerSize or 0, 0),
		})
	})
	return Object
end)
--
AddElement("Button",function(Color, Transparency, CornerSize)
	local Object = CreateObject("ImageButton",{
		--
		BackgroundColor3 = Color or Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = Transparency or 0,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		ImageTransparency = 1,
	}, {
		CreateObject("UICorner",{
			CornerRadius = UDim.new(CornerSize or 0, 0),
		})
	})
	return Object
end)
--
AddElement("Scroll",function()
	local Object = CreateObject("ScrollingFrame",{
		--
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		--
		BottomImage = "rbxassetid://13993227947",
		MidImage = "rbxassetid://13993227947",
		TopImage = "rbxassetid://13993227947",
		ScrollBarImageTransparency = 0,
		ScrollBarThickness = 1,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(0,0,0,0),
	})
	return Object
end)
--
AddElement("Text",function(Text, TextXAl, Color)
	local Object = CreateObject("TextLabel",{
		--
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		TextColor3 = Color or Color3.fromRGB(255, 255, 255),
		Text = Text or "Text",
		Font = GifUI_lib.MainFont,
		TextScaled = true,
		TextXAlignment = TextXAl or Enum.TextXAlignment.Left,
	})
	return Object
end)
--
AddElement("TextBox",function(Color, Placeholder, CornerSize)
	local Object = CreateObject("TextBox",{
		--
		BackgroundColor3 = Color or Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		--
		PlaceholderColor3 = Color3.fromRGB(180, 180, 180),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Text = "",
		Font = GifUI_lib.MainFont,
		TextScaled = true,
		PlaceholderText = Placeholder or "",
	},{
		CreateObject("UICorner",{
			CornerRadius = UDim.new(CornerSize or 0, 0),
		}),
	})
	return Object
end)
--
AddElement("Image",function(ImageID, Transparency)
	local Object:ImageLabel = CreateObject("ImageLabel",{
		--
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Image = ImageID,
		ImageTransparency = Transparency,
	})
	return Object
end)
--
AddElement("Ratio",function(Aspect)
	local Object = CreateObject("UIAspectRatioConstraint",{
		--
		AspectRatio = Aspect or 1,
		AspectType = Enum.AspectType.FitWithinMaxSize,
		DominantAxis = Enum.DominantAxis.Width,
	})
	return Object
end)
--
AddElement("List",function(Padding)
	local Object = CreateObject("UIListLayout",{
		--
		Padding = UDim.new(Padding or 0, 0),
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
	})
	return Object
end)
--
AddElement("Corner",function(CornerSize)
	local Object = CreateObject("UICorner",{
		--
		CornerRadius = UDim.new(CornerSize or 0, 0),
	})
	return Object
end)

--===============================================

function GifUI_lib:MakeWindow(WindowConfig)
	if not WindowConfig then warn("ERROR: YOU HAVE NOT ADDED A WINDOW CONFIGURATION!") return end
	--
	local Window = {}

	-- Window Main

	local WindowHandler:CanvasGroup = SetChildren(SetProperties(MakeElement("Canvas",nil,1,0.05),{
		Parent = GifUI,
		--
		Position = UDim2.fromScale(.5,.5),
		Size = UDim2.fromScale(.54,.393),
		AnchorPoint = Vector2.new(.5,.5),
	}),{
		MakeElement("Ratio",1.697)
	})

	local WindowMain = SetProperties(MakeElement("Frame",Color3.fromRGB(30,30,30)),{
		Parent = WindowHandler,
		--
		Position = UDim2.fromScale(.5,.56),
		Size = UDim2.fromScale(1,.88),
		AnchorPoint = Vector2.new(.5,.5),
	})

	-- Top Bar

	local WindowTopBar:Frame = SetProperties(MakeElement("Frame",Color3.fromRGB(20,20,20)),{
		Parent = WindowHandler,
		--
		Position = UDim2.fromScale(.5,0),
		Size = UDim2.fromScale(1,.12),
		AnchorPoint = Vector2.new(.5,0),
	})

	local StoredMouseLocation = nil
	local FramePosition = nil
	local Draggable = false

	AddConnection(WindowTopBar.InputBegan, function(Input)
		if Input.UserInputType~=Enum.UserInputType.MouseButton1 and Input.UserInputType~=Enum.UserInputType.Touch then return end
		--
		Draggable = true
		StoredMouseLocation = Services.Input:GetMouseLocation()
		FramePosition = Vector2.new(WindowHandler.Position.X.Scale,WindowHandler.Position.Y.Scale)
	end)

	AddConnection(WindowTopBar.InputEnded, function(Input)
		if Input.UserInputType~=Enum.UserInputType.MouseButton1 and Input.UserInputType~=Enum.UserInputType.Touch then return end
		--
		Draggable = false
	end)

	AddConnection(Services.Run.RenderStepped, function()
		if not Draggable then return end
		--
		local MouseLocation = Services.Input:GetMouseLocation()
		local NewPosition = FramePosition + ((Vector2.new(MouseLocation.X,MouseLocation.Y) - StoredMouseLocation) / workspace.CurrentCamera.ViewportSize)
		WindowHandler.Position = UDim2.fromScale(NewPosition.X, NewPosition.Y)
	end)

	--

	local Title = SetProperties(MakeElement("Text",WindowConfig.Title or "GIF-UI | Gui"),{
		Parent = WindowTopBar,
		--
		Position = UDim2.fromScale(.025,.5),
		Size = UDim2.fromScale(.664,.5),
		AnchorPoint = Vector2.new(0,.5),
	})

	local TweenTime = .25
	--
	local DestroyButton:ImageButton = SetChildren(SetProperties(MakeElement("Button",Color3.fromRGB(229,64,67),nil,.4),{
		Parent = WindowTopBar,
		--
		Position = UDim2.fromScale(.945,.5),
		Size = UDim2.fromScale(.038,.534),
		AnchorPoint = Vector2.new(0,.5),
	}),{
		MakeElement("Ratio",1)
	})

	AddConnection(DestroyButton.MouseButton1Click, function()
		GifUI.Parent = nil -- Break All Functions ??
	end)

	local HideButton:ImageButton = SetChildren(SetProperties(MakeElement("Button",Color3.fromRGB(150,150,150),nil,.4),{
		Parent = WindowTopBar,
		--
		Position = UDim2.fromScale(.88,.5),
		Size = UDim2.fromScale(.05,.285),
		AnchorPoint = Vector2.new(0,.5),
	}),{
		MakeElement("Ratio",2.5)
	})

	local WindowHidden = false
	local HideDb = false
	AddConnection(HideButton.MouseButton1Click, function()
		if HideDb then return end
		HideDb = true
		--
		if WindowHidden then
			Services.Tween:Create(WindowMain,TweenInfo.new(TweenTime,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Position=UDim2.fromScale(.5,.56)}):Play()
		else
			Services.Tween:Create(WindowMain,TweenInfo.new(TweenTime,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Position=UDim2.fromScale(.5,-.442)}):Play()
		end
		--
		task.wait(TweenTime)
		WindowHidden = not WindowHidden
		HideDb = false
	end)

	-- Tabs Gui

	local Tabs = SetChildren(SetProperties(MakeElement("Scroll"),{
		Parent = WindowMain,
		--
		Position = UDim2.fromScale(0,.5),
		Size = UDim2.fromScale(.25,1),
		AnchorPoint = Vector2.new(0,.5),
		--
		BackgroundColor3 = Color3.fromRGB(20,20,20),
		BackgroundTransparency = 0,
		ScrollBarImageTransparency = 1,
	}),{
		MakeElement("List",-0.03)
	})

	local Tab = SetChildren(SetProperties(MakeElement("Frame"),{
		Parent = script,
		--
		Position = UDim2.fromScale(0,0),
		Size = UDim2.fromScale(1,.225),
		AnchorPoint = Vector2.new(.5,.5),
		--
		BackgroundTransparency = 1,
	}),{
		SetChildren(SetProperties(MakeElement("Button",Color3.fromRGB(30,30,30),0,.3),{
			Position = UDim2.fromScale(.5,.5),
			Size = UDim2.fromScale(.831,.568),
			AnchorPoint = Vector2.new(.5,.5),
		}),{
			SetProperties(MakeElement("Text","Tab",Enum.TextXAlignment.Center),{
				Position = UDim2.fromScale(.5,.5),
				Size = UDim2.fromScale(.5,.5),
				AnchorPoint = Vector2.new(.5,.5),
				--
			})
		})
	})

	--Options Gui

	local Options = SetChildren(SetProperties(MakeElement("Scroll"),{
		Parent = WindowMain,
		--
		Position = UDim2.fromScale(.25,.5),
		Size = UDim2.fromScale(.75,1),
		AnchorPoint = Vector2.new(0,.5),
		--
		ScrollBarImageTransparency = 1,
	}),{
		MakeElement("List",-0.05)
	})

	local Option = SetChildren(SetProperties(MakeElement("Frame"),{
		Parent = script,
		--
		Position = UDim2.fromScale(0,0),
		Size = UDim2.fromScale(1,.291),
		AnchorPoint = Vector2.new(0,0),
		--
		BackgroundTransparency = 1,
	}),{
		SetChildren(SetProperties(MakeElement("Frame",Color3.fromRGB(20,20,20),.3),{
			Position = UDim2.fromScale(.5,.5),
			Size = UDim2.fromScale(.9,.6),
			AnchorPoint = Vector2.new(.5,.5),
			--
			Name = "Main",
		}),{
			SetProperties(MakeElement("Text","Option"),{
				Position = UDim2.fromScale(.023,.5),
				Size = UDim2.fromScale(.8,.5),
				AnchorPoint = Vector2.new(0,.5),
				--
				Name = "Title"
			}),
			SetChildren(SetProperties(MakeElement("Button",Color3.fromRGB(30,30,30),nil,0.3),{
				Position = UDim2.fromScale(.93,.5),
				Size = UDim2.fromScale(.096,.719),
				AnchorPoint = Vector2.new(.5,.5),
				--
				Name = "Button"
			}),{
				MakeElement("Ratio",1),
				SetProperties(MakeElement("Image","rbxassetid://12690727184"),{
					Position = UDim2.fromScale(.5,.5),
					Size = UDim2.fromScale(.6,.6),
					AnchorPoint = Vector2.new(.5,.5),
					--
					Name = "Icon",
					ImageTransparency = 1,
				})
			})
		})
	})

	--=================================================
	--Constructor--

	local ActivateColor = Color3.fromRGB(130, 200, 100)
	local CurrentTab = nil
	--
	local function ChangeCurrentOptions()
		for _,Option in pairs(Options:GetChildren()) do
			if not Option:IsA("Frame") then continue end
			Option.Visible = false
		end
		--
		if not CurrentTab then return end
		for _,Option in pairs(CurrentTab.Options) do
			Option.Option.Visible = true
		end
	end
	local function ChangeCurrentTab(Tab)
		if CurrentTab then
			Services.Tween:Create(CurrentTab.Tab,TweenInfo.new(.2,Enum.EasingStyle.Exponential),{Size=UDim2.fromScale(1,.225)}):Play()
		end
		CurrentTab = Tab
		Services.Tween:Create(CurrentTab.Tab,TweenInfo.new(.2,Enum.EasingStyle.Exponential),{Size=UDim2.fromScale(1.4,.285)}):Play()
		ChangeCurrentOptions()
	end
	--

	ChangeCurrentOptions()
	function Window:SetCurrentTab(Tab)
		ChangeCurrentTab(Tab)
	end

	function Window:AddTab(TabConfigs)
		if not TabConfigs then warn("ERROR: YOU HAVE NOT ADDED A TAB CONFIGURATION!") return end
		--
		local NewTab:Frame = Tab:Clone()
		NewTab.Parent = Tabs
		--
		local Button = NewTab:FindFirstChildOfClass("ImageButton")
		local Title = Button:FindFirstChildOfClass("TextLabel")
		--
		local Tab = {}
		Tab.Tab = NewTab
		Tab.Button = Button
		Tab.Title = Title
		Tab.Options = {}
		--
		Title.Text = TabConfigs.Title or "Tab"
		--
		function Tab:AddOption(OptionConfigs)
			if not OptionConfigs then warn("ERROR: YOU HAVE NOT ADDED A OPTION CONFIGURATION!") return end
			--
			local NewOption = Option:Clone()
			NewOption.Parent = Options
			--
			local Main = NewOption.Main
			local Title = Main.Title
			--
			local Button = Main.Button
			local Check = Button.Icon
			--
			local Option = {}
			Option.Option = NewOption
			Option.Main = Main
			Option.Button = Button
			Option.Title = Title

			Option.Title.Text = OptionConfigs.Title or "Option"

			if CurrentTab~=Tab then Option.Option.Visible = false end
			--
			if OptionConfigs.Type == "Check" then
				--
				local ColorStore = Option.Button.BackgroundColor3
				local Active = false
				AddConnection(Option.Button.MouseButton1Click, function()
					Active = not Active
					--
					if Active then
						OptionConfigs.On()
						Services.Tween:Create(Option.Button,TweenInfo.new(.2),{BackgroundColor3=ActivateColor}):Play()
						Services.Tween:Create(Check,TweenInfo.new(.2),{ImageTransparency=0}):Play()
					else
						OptionConfigs.Off()
						Services.Tween:Create(Option.Button,TweenInfo.new(.2),{BackgroundColor3=ColorStore}):Play()
						Services.Tween:Create(Check,TweenInfo.new(.2),{ImageTransparency=1}):Play()
					end
				end)
				--
			elseif OptionConfigs.Type == "Click" then
				--
				local ColorStore = Option.Button.BackgroundColor3
				Option.Button.Icon.Image = "rbxassetid://12333784627"
				Option.Button.Icon.ImageTransparency = 0
				Option.Button.Icon.Size = UDim2.fromScale(.9,.9)
				--
				AddConnection(Option.Button.MouseButton1Click, function()
					OptionConfigs.Click()
					Services.Tween:Create(Option.Button,TweenInfo.new(.1),{BackgroundColor3=ActivateColor}):Play()
					wait(.2)
					Services.Tween:Create(Option.Button,TweenInfo.new(.2),{BackgroundColor3=ColorStore}):Play()
				end)
				--
			elseif OptionConfigs.Type == "InputCheck" then
				--
				local ColorStore = Option.Button.BackgroundColor3
				local Active = false
				Button.Position = UDim2.fromScale(.64,.5)
				--
				local TextBox:TextBox = SetChildren(SetProperties(MakeElement("TextBox",Color3.fromRGB(30,30,30),OptionConfigs.PlaceHolder,.3),{
					Parent = Option.Main,
					Position = UDim2.fromScale(.841,.5),
					Size = UDim2.fromScale(.273,.719),
					AnchorPoint = Vector2.new(.5,.5),
				}),{
					AddElement("Ratio",2.831),
				})
				--
				AddConnection(Option.Button.MouseButton1Click, function()
					Active = not Active
					--
					if Active then
						OptionConfigs.On(TextBox.Text)
						Services.Tween:Create(Option.Button,TweenInfo.new(.2),{BackgroundColor3=ActivateColor}):Play()
						Services.Tween:Create(Check,TweenInfo.new(.2),{ImageTransparency=0}):Play()
					else
						OptionConfigs.Off(TextBox.Text)
						Services.Tween:Create(Option.Button,TweenInfo.new(.2),{BackgroundColor3=ColorStore}):Play()
						Services.Tween:Create(Check,TweenInfo.new(.2),{ImageTransparency=1}):Play()
					end
				end)
				--
				AddConnection(TextBox.Changed, function(Property)
					if Property~="Text" then return end
					OptionConfigs.Changed(TextBox.Text)
				end)
			elseif OptionConfigs.Type == "InputClick" then
				--
				local ColorStore = Option.Button.BackgroundColor3
				local Active = false
				Button.Position = UDim2.fromScale(.64,.5)
				Option.Button.Icon.Image = "rbxassetid://12333784627"
				Option.Button.Icon.ImageTransparency = 0
				Option.Button.Icon.Size = UDim2.fromScale(.9,.9)
				--
				local TextBox = SetChildren(SetProperties(MakeElement("TextBox",Color3.fromRGB(30,30,30),OptionConfigs.PlaceHolder,.3),{
					Parent = Option.Main,
					Position = UDim2.fromScale(.841,.5),
					Size = UDim2.fromScale(.273,.719),
					AnchorPoint = Vector2.new(.5,.5),
				}),{
					AddElement("Ratio",2.831),
				})
				--
				AddConnection(Option.Button.MouseButton1Click, function()
					OptionConfigs.Click(TextBox.Text)
					Services.Tween:Create(Option.Button,TweenInfo.new(.1),{BackgroundColor3=ActivateColor}):Play()
					wait(.2)
					Services.Tween:Create(Option.Button,TweenInfo.new(.2),{BackgroundColor3=ColorStore}):Play()
				end)
				AddConnection(TextBox.Changed, function(Property)
					if Property~="Text" then return end
					OptionConfigs.Changed(TextBox.Text)
				end)
			elseif OptionConfigs.Type == "Input" then
				--
				Option.Button:Destroy()
				--
				local TextBox:TextBox = SetChildren(SetProperties(MakeElement("TextBox",Color3.fromRGB(30,30,30),OptionConfigs.PlaceHolder,.3),{
					Parent = Option.Main,
					Position = UDim2.fromScale(.841,.5),
					Size = UDim2.fromScale(.273,.719),
					AnchorPoint = Vector2.new(.5,.5),
				}),{
					AddElement("Ratio",2.831),
				})
				--
				TextBox.Changed:Connect(function(Property)
					if Property~="Text" then return end
					OptionConfigs.Changed(TextBox.Text)
				end)
			elseif OptionConfigs.Type == "Text" then
				--
				Option.Title.Parent = Option.Option
				Option.Main:Destroy()
				--
				Option.Title.Position = UDim2.fromScale(.5,.5)
				Option.Title.Size = UDim2.fromScale(.9,.5)
				Option.Title.AnchorPoint = Vector2.new(.5,.5)
				Option.Option.Size = UDim2.fromScale(1,.18)
				--
				Option.Title.TextXAlignment = OptionConfigs.TextX or Enum.TextXAlignment.Center
			end
			--
			table.insert(Tab.Options,Option)
			return Option
		end
		--
		function Tab:MakeSpace()
			local Space = Option:Clone()
			Space.Parent = Options
			Space.Main:Destroy()
			Space.Size = UDim2.fromScale(1,.12)
			table.insert(Tab.Options,{Option=Space})
			return Space
		end
		--
		AddConnection(Button.MouseButton1Click, function()
			--
			ChangeCurrentTab(Tab)
		end)
		--
		return Tab
	end


	-- Return List
	return Window
end

for _,Descendant in pairs(GifUI:GetDescendants()) do
	if not Descendant:IsA("TextButton") or not Descendant:IsA("ImageButton") then continue end
	AddClickSound(Descendant)
end
AddConnection(GifUI.DescendantAdded,function(Descendant)
	if not Descendant:IsA("TextButton") and not Descendant:IsA("ImageButton") then return end
	AddClickSound(Descendant)
end)

--
if RealParent.Name=="CoreGui" then
	print("?? - GIF-UI Lib Successfully Loaded - ??")
	print("Version 1.01")
else
	print("?? - GIF-UI Successfully Loaded In Roblox Studio - ??")
end

return GifUI_lib
