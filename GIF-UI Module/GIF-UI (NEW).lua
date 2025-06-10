--[[
GIFui Made By GIFKITS
thank you for using this gui library!
]]--

ver = .2

local GIFui = {
	Connections = {},
	MainFont = Enum.Font.Cartoon,
	--
	Gui = {},
	Templates = {},
	
	OpenKey = Enum.KeyCode.RightControl,
}
local Services = {
	Players = game:GetService("Players"),
	Run = game:GetService("RunService"),
	Input = game:GetService("UserInputService"),
	Tween = game:GetService("TweenService"),
}

GIFui.IsRunning = true
GIFui.Break = function()
	for _,RbxConnection in next, GIFui.Connections or {} do
		RbxConnection:Disconnect()
	end
	GIFui.Connections = {}
	table.clear(GIFui)
	GIFui = {}
end

task.spawn(function()
	repeat task.wait() until not GIFui.IsRunning
	GIFui.Break()
end)

----

function SetProperties(Object,Properties)
	for Property, Value in next, Properties or {} do
		Object[Property] = Value
	end
	return Object
end
function SetChildren(Object,Children)
	for _,Child in next, Children or {} do
		Child.Parent = Object
	end
	return Object
end
--====--
function Create(Name,Properties,Children)
	local Object = Instance.new(tostring(Name))
	SetProperties(Object,Properties)
	SetChildren(Object,Children)
	return Object
end
--====--
function Template(Name, ...)
	return GIFui.Templates[Name](...)
end
function AddTemplate(Name, Function)
	GIFui.Templates[Name] = function(...)
		return Function(...)
	end
end

----

AddTemplate("Canvas", function(Color, Transparency, CornerSize)
	local Object = Create("CanvasGroup",{
		Transparency = Transparency or 0,
		BorderSizePixel = 0,
		BackgroundColor3 = Color or Color3.new(1,1,1),
	},{
		Create("UICorner",{
			CornerRadius = UDim.new(CornerSize or 0,0),
		})
	})
	return Object
end)
AddTemplate("Frame", function(Color, Transparency, CornerSize)
	local Object = Create("Frame",{
		Transparency = Transparency or 0,
		BorderSizePixel = 0,
		BackgroundColor3 = Color or Color3.new(1,1,1),
	},{
		Create("UICorner",{
			CornerRadius = UDim.new(CornerSize or 0,0),
		})
	})
	return Object
end)
AddTemplate("Input", function(Color, Placeholder, CornerSize)
	local Object = Create("TextBox",{
		PlaceholderText = tostring(Placeholder or ""),
		TextColor3 = Color3.new(1,1,1),
		PlaceholderColor3 = Color3.fromRGB(65,65,65),
		TextScaled = true,
		Text = "",
		Font = GIFui.MainFont,
		BorderSizePixel = 0,
		BackgroundColor3 = Color or Color3.new(1,1,1),
	},{
		Create("UICorner",{
			CornerRadius = UDim.new(CornerSize or 0,0),
		})
	})
	return Object
end)

AddTemplate("Button", function(Color, Transparency, CornerSize)
	local Object = Create("TextButton",{
		Transparency = Transparency or 0,
		BorderSizePixel = 0,
		BackgroundColor3 = Color or Color3.new(1,1,1),
		Text = "",
		AutoButtonColor = false,
	},{
		Create("UICorner",{
			CornerRadius = UDim.new(CornerSize or 0,0),
		})
	})
	return Object
end)
AddTemplate("Scroll", function(Color, Transparency)
	local Object = Create("ScrollingFrame",{
		Transparency = Transparency or 1,
		BorderSizePixel = 0,
		BackgroundColor3 = Color or Color3.new(0,0,0),
		ScrollBarImageTransparency = 1,
		CanvasSize = UDim2.fromScale(0,0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
	})
	return Object
end)
AddTemplate("Text", function(Text, Xpos, Color)
	local Object = Create("TextLabel",{
		Text = tostring(Text or ""),
		TextColor3 = Color or Color3.new(1,1,1),
		TextScaled = true,
		BackgroundTransparency = 1,
		Font = GIFui.MainFont,
		TextXAlignment = Xpos or Enum.TextXAlignment.Center
	})
	return Object
end)
AddTemplate("Image", function(Image, Transparency)
	if tonumber(Image) then
		Image = "rbxassetid://"..tostring(Image)
	end
	local Object = Create("ImageLabel",{
		Image = tostring(Image),
		BackgroundTransparency = 1,
		ImageTransparency = Transparency or 0,
	})
	return Object
end)

--Other
AddTemplate("Gradient", function(Color1, Color2)
	local Object = Create("UIGradient",{
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0,Color1 or Color3.new(1,1,1)),
			ColorSequenceKeypoint.new(1,Color2 or Color3.new(1,1,1)),
		},
		Rotation = 90,
	})
	return Object
end)
AddTemplate("Ratio", function(Aspect)
	local Object = Create("UIAspectRatioConstraint",{
		AspectRatio = Aspect or 1,
	})
	return Object
end)
AddTemplate("List", function(Xpos, Ypos, Padding)
	local Object = Create("UIListLayout",{
		Padding = UDim.new(Padding or 0,0),
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Xpos or Enum.HorizontalAlignment.Center,
		VerticalAlignment = Ypos or Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder,
	})
	return Object
end)

--Player--
local Player = Services.Players.LocalPlayer
local PlayerGui = Player.PlayerGui

--====--

local InterfaceParent = game:FindFirstChild("CoreGui") or PlayerGui
local GIFui_interface = Instance.new("ScreenGui", InterfaceParent)
GIFui_interface.Name = "GIFui".." - v"..tostring(ver)
GIFui_interface.IgnoreGuiInset = true
GIFui_interface.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GIFui_interface.ResetOnSpawn = false
GIFui_interface.DisplayOrder = 9e6

function GIFui.MakeWindow(WindowTitle:string)
	local Window = {
		Options = {},
		Tabs = {},
		Connections = {},
		--
		CurrentTab = nil,
	}
	
	--
	local WindowHandler = SetChildren(SetProperties(Template("Canvas",nil,1,.05),{
		Name = "Window",
		Parent = GIFui_interface,
		Size = UDim2.fromScale(.545,.5),
		Position = UDim2.fromScale(.5,.5),
		AnchorPoint = Vector2.new(.5,.5),
	}),{
		Template("Ratio",1.505),
	})
	--
	local WindowMain = SetProperties(Template("Canvas",nil,1),{
		Parent = WindowHandler,
		Size = UDim2.fromScale(1,.9),
		Position = UDim2.fromScale(.5,.1),
		AnchorPoint = Vector2.new(.5,0),
	})
	local Background = SetChildren(SetProperties(Template("Frame",Color3.fromRGB(40,40,40),0),{
		Parent = WindowMain,
		Size = UDim2.fromScale(1,1),
		Position = UDim2.fromScale(.5,.5),
		AnchorPoint = Vector2.new(.5,.5),
	}),{
		Template("Gradient",Color3.fromRGB(209,209,209),Color3.fromRGB(89,89,89)),
	})
	
	local WindowTop = SetChildren(SetProperties(Template("Canvas",Color3.fromRGB(23,23,23)),{
		Parent = WindowHandler,
		Size = UDim2.fromScale(1,.1),
		Position = UDim2.fromScale(.5,0),
		AnchorPoint = Vector2.new(.5,0),
	}),{
		SetProperties(Template("Text", WindowTitle),{
			Size = UDim2.fromScale(.6,.6),
			Position = UDim2.fromScale(.5,.5),
			AnchorPoint = Vector2.new(.5,.5),
		})
	})
	--
	local TopButtonsHandler = SetChildren(SetProperties(Template("Frame",nil,1),{
		Parent = WindowTop,
		Size = UDim2.fromScale(.121,1),
		Position = UDim2.fromScale(1,.5),
		AnchorPoint = Vector2.new(1,.5),
	}),{
		SetProperties(Template("List",nil,Enum.VerticalAlignment.Center,.1),{
			FillDirection = Enum.FillDirection.Horizontal,
		}),
	})
	
	local HideButton = SetChildren(SetProperties(Template("Button",Color3.fromRGB(60,60,60),nil,.4),{
		Parent = TopButtonsHandler,
		Size = UDim2.fromScale(.32,.582),
		Position = UDim2.fromScale(0,0),
		AnchorPoint = Vector2.new(0,0),
	}),{
		Template("Gradient",Color3.new(1,1,1),Color3.fromRGB(162,162,162)),
		SetProperties(Template("Image","91869606000407"),{
			Name = "Icon",
			Size = UDim2.fromScale(.5,.8),
			Position = UDim2.fromScale(0.5,.5),
			AnchorPoint = Vector2.new(.5,.5),
		}),
	})
	local CloseButton = SetChildren(SetProperties(Template("Button",Color3.fromRGB(60,60,60),nil,.4),{
		Parent = TopButtonsHandler,
		Size = UDim2.fromScale(.32,.582),
		Position = UDim2.fromScale(0,0),
		AnchorPoint = Vector2.new(0,0),
	}),{
		Template("Gradient",Color3.new(1,1,1),Color3.fromRGB(162,162,162)),
		SetProperties(Template("Image","111103280193031"),{
			Name = "Icon",
			Size = UDim2.fromScale(1,1),
			Position = UDim2.fromScale(0.5,.5),
			AnchorPoint = Vector2.new(.5,.5),
		}),
	})
	
	--
	local TabsHandler = SetChildren(SetProperties(Template("Scroll",Color3.new(0,0,0),.7),{
		Parent = WindowMain,
		Size = UDim2.fromScale(.25,1),
		Position = UDim2.fromScale(0,0),
		AnchorPoint = Vector2.new(0,0),
	}),{
		Template("List"),
	})
	local OptionsHandler = SetChildren(SetProperties(Template("Scroll"),{
		Parent = WindowMain,
		Size = UDim2.fromScale(.75,1),
		Position = UDim2.fromScale(.25,.5),
		AnchorPoint = Vector2.new(0,.5),
	}),{
		Template("List"),
	})
	--
	local AssetsFolder = Create("Folder",{Name="Assets",Parent=WindowHandler})
	
	local Tab = SetChildren(SetProperties(Template("Frame",nil,1),{
		Parent = AssetsFolder,
		Name = "Tab",
		Size = UDim2.fromScale(.9,.15),
		Position = UDim2.fromScale(0,0),
		AnchorPoint = Vector2.new(.5,0),
		Visible = false,
	}),{
		SetChildren(SetProperties(Template("Button",Color3.fromRGB(60,60,60),nil,1),{
			Name = "Button",
			Size = UDim2.fromScale(.8,.6),
			Position = UDim2.fromScale(.5,.5),
			AnchorPoint = Vector2.new(.5,.5),
		}),{
			Template("Gradient",Color3.new(1,1,1),Color3.fromRGB(162,162,162)),
			SetProperties(Template("Text","Tab"),{
				Name = "Title",
				Size = UDim2.fromScale(.8,.65),
				Position = UDim2.fromScale(.5,.5),
				AnchorPoint = Vector2.new(.5,.5),
			})
		})
	})
	--options--
	local CheckOption = SetChildren(SetProperties(Template("Frame",nil,1),{
		Parent = AssetsFolder,
		Name = "CheckOption",
		Size = UDim2.fromScale(.9,.2),
		Position = UDim2.fromScale(0,0),
		AnchorPoint = Vector2.new(.5,.5),
		Visible = false,
	}),{
		SetChildren(SetProperties(Template("Canvas",Color3.fromRGB(60,60,60),nil,1),{
			Name = "Handler",
			Size = UDim2.fromScale(1,.7),
			Position = UDim2.fromScale(.5,.5),
			AnchorPoint = Vector2.new(.5,.5),
		}),{
			Template("Gradient",Color3.new(1,1,1),Color3.fromRGB(162,162,162)),
			SetChildren(SetProperties(Template("Frame",nil,1),{
				Name = "TitleHandler",
				Size = UDim2.fromScale(.8,.9),
				Position = UDim2.fromScale(.05,.5),
				AnchorPoint = Vector2.new(0,.5),
			}),{
				Template("List",Enum.HorizontalAlignment.Left,Enum.VerticalAlignment.Center),
				SetProperties(Template("Text","Option",Enum.TextXAlignment.Left),{
					Name = "Title",
					Size = UDim2.fromScale(.8,.5),
					Position = UDim2.fromScale(0,0),
					AnchorPoint = Vector2.new(0,0),
				}),
				SetProperties(Template("Text","check swich option",Enum.TextXAlignment.Left,Color3.fromRGB(150,150,150)),{
					Name = "Tip",
					Size = UDim2.fromScale(.8,.4),
					Position = UDim2.fromScale(0,0),
					AnchorPoint = Vector2.new(0,0),
				}),
			}),
			SetChildren(SetProperties(Template("Button",Color3.fromRGB(40,40,40),nil,1),{
				Name = "Button",
				Size = UDim2.fromScale(.1,.8),
				Position = UDim2.fromScale(0.99,.5),
				AnchorPoint = Vector2.new(1,.5),
			}),{
				Template("Gradient",Color3.new(1,1,1),Color3.fromRGB(162,162,162)),
				SetProperties(Template("Image","12690727184",1),{
					Name = "Icon",
					Size = UDim2.fromScale(.6,.6),
					Position = UDim2.fromScale(0.5,.5),
					AnchorPoint = Vector2.new(.5,.5),
				})
			})
		})
	})
	
	local ClickOption = SetChildren(SetProperties(Template("Frame",nil,1),{
		Parent = AssetsFolder,
		Name = "ClickOption",
		Size = UDim2.fromScale(.9,.2),
		Position = UDim2.fromScale(0,0),
		AnchorPoint = Vector2.new(.5,.5),
		Visible = false,
	}),{
		SetChildren(SetProperties(Template("Canvas",Color3.fromRGB(60,60,60),nil,1),{
			Name = "Handler",
			Size = UDim2.fromScale(1,.7),
			Position = UDim2.fromScale(.5,.5),
			AnchorPoint = Vector2.new(.5,.5),
		}),{
			Template("Gradient",Color3.new(1,1,1),Color3.fromRGB(162,162,162)),
			SetChildren(SetProperties(Template("Frame",nil,1),{
				Name = "TitleHandler",
				Size = UDim2.fromScale(.8,.9),
				Position = UDim2.fromScale(.05,.5),
				AnchorPoint = Vector2.new(0,.5),
			}),{
				Template("List",Enum.HorizontalAlignment.Left,Enum.VerticalAlignment.Center),
				SetProperties(Template("Text","Option",Enum.TextXAlignment.Left),{
					Name = "Title",
					Size = UDim2.fromScale(.8,.5),
					Position = UDim2.fromScale(0,0),
					AnchorPoint = Vector2.new(0,0),
				}),
				SetProperties(Template("Text","just click",Enum.TextXAlignment.Left,Color3.fromRGB(150,150,150)),{
					Name = "Tip",
					Size = UDim2.fromScale(.8,.4),
					Position = UDim2.fromScale(0,0),
					AnchorPoint = Vector2.new(0,0),
				}),
			}),
			SetChildren(SetProperties(Template("Button",Color3.fromRGB(40,40,40),nil,1),{
				Name = "Button",
				Size = UDim2.fromScale(.1,.8),
				Position = UDim2.fromScale(0.99,.5),
				AnchorPoint = Vector2.new(1,.5),
			}),{
				Template("Gradient",Color3.new(1,1,1),Color3.fromRGB(162,162,162)),
				SetProperties(Template("Image","12333784627"),{
					Name = "Icon",
					Size = UDim2.fromScale(.8,.8),
					Position = UDim2.fromScale(0.5,.5),
					AnchorPoint = Vector2.new(.5,.5),
				})
			})
		})
	})
	
	local InputOption = SetChildren(SetProperties(Template("Frame",nil,1),{
		Parent = AssetsFolder,
		Name = "InputOption",
		Size = UDim2.fromScale(.9,.2),
		Position = UDim2.fromScale(0,0),
		AnchorPoint = Vector2.new(.5,.5),
		Visible = false,
	}),{
		SetChildren(SetProperties(Template("Canvas",Color3.fromRGB(60,60,60),nil,1),{
			Name = "Handler",
			Size = UDim2.fromScale(1,.7),
			Position = UDim2.fromScale(.5,.5),
			AnchorPoint = Vector2.new(.5,.5),
		}),{
			Template("Gradient",Color3.new(1,1,1),Color3.fromRGB(162,162,162)),
			SetChildren(SetProperties(Template("Frame",nil,1),{
				Name = "TitleHandler",
				Size = UDim2.fromScale(.8,.9),
				Position = UDim2.fromScale(.05,.5),
				AnchorPoint = Vector2.new(0,.5),
			}),{
				Template("List",Enum.HorizontalAlignment.Left,Enum.VerticalAlignment.Center),
				SetProperties(Template("Text","Option",Enum.TextXAlignment.Left),{
					Name = "Title",
					Size = UDim2.fromScale(.8,.5),
					Position = UDim2.fromScale(0,0),
					AnchorPoint = Vector2.new(0,0),
				}),
				SetProperties(Template("Text","just click",Enum.TextXAlignment.Left,Color3.fromRGB(150,150,150)),{
					Name = "Tip",
					Size = UDim2.fromScale(.8,.4),
					Position = UDim2.fromScale(0,0),
					AnchorPoint = Vector2.new(0,0),
				}),
			}),
			SetChildren(SetProperties(Template("Input",Color3.fromRGB(40,40,40),"Input",1),{
				Name = "Button",
				Size = UDim2.fromScale(.38,.6),
				Position = UDim2.fromScale(0.975,.5),
				AnchorPoint = Vector2.new(1,.5),
			}),{
				Template("Gradient",Color3.new(1,1,1),Color3.fromRGB(162,162,162))
			})
		})
	})
	
	--MAIN--
	function Window:Destroy()
		for _,RbxConnection in next, self.Connections or {} do
			RbxConnection:Disconnect()
		end
		WindowHandler:Destroy()
		table.clear(self)
	end
	function Window:AddConnection(RbxSignal, Function)
		local RbxConnection = RbxSignal:Connect(Function)
		table.insert(self.Connections, RbxConnection)
		return RbxConnection
	end
	--close and hide window
	function Window:Hide()
		Services.Tween:Create(WindowMain,TweenInfo.new(.25,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Position=UDim2.fromScale(.5,-.9)}):Play()
	end
	function Window:Show()
		Services.Tween:Create(WindowMain,TweenInfo.new(.25,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Position=UDim2.fromScale(.5,.1)}):Play()
	end
	function Window:Close()
		WindowHandler.Visible = false
	end
	function Window:Open()
		WindowHandler.Visible = true
	end
	
	local IsHide = false
	local OpenTrigger = nil
	Window:AddConnection(HideButton.MouseButton1Click, function()
		IsHide = not IsHide
		if IsHide then
			Window:Hide()
		else
			Window:Show()
		end
	end)
	Window:AddConnection(CloseButton.MouseButton1Click, function()
		Window:Close()
		OpenTrigger = Window:AddConnection(Services.Input.InputBegan, function(Input, Event)
			if Event or Input.KeyCode~=GIFui.OpenKey then return end
			Window:Open()
			OpenTrigger:Disconnect()
		end)
	end)
	--dragg window
	local StoredMouseLocation = nil
	local FramePosition = nil
	local Draggable = false
	
	Window:AddConnection(WindowTop.InputBegan, function(Input)
		if Input.UserInputType~=Enum.UserInputType.MouseButton1 and Input.UserInputType~=Enum.UserInputType.Touch then return end
		--
		Draggable = true
		StoredMouseLocation = Services.Input:GetMouseLocation()
		FramePosition = Vector2.new(WindowHandler.Position.X.Scale,WindowHandler.Position.Y.Scale)
	end)
	
	Window:AddConnection(WindowTop.InputEnded, function(Input)
		if Input.UserInputType~=Enum.UserInputType.MouseButton1 and Input.UserInputType~=Enum.UserInputType.Touch then return end
		--
		Draggable = false
	end)
	
	Window:AddConnection(Services.Run.Heartbeat, function()
		if not Draggable then return end
		--
		local MouseLocation = Services.Input:GetMouseLocation()
		local NewPosition = FramePosition + ((Vector2.new(MouseLocation.X,MouseLocation.Y) - StoredMouseLocation) / workspace.CurrentCamera.ViewportSize)
		WindowHandler.Position = UDim2.fromScale(NewPosition.X, NewPosition.Y)
	end)
	
	--Tabs And Options--
	
	function Window:MakeTab(TabTitle)
		local TabMain = Tab:Clone()
		TabMain.Visible = true
		TabMain.Parent = TabsHandler
		local Button = TabMain.Button
		local Title = Button.Title
		Title.Text = tostring(TabTitle)
		
		local NewTab = {
			Build = {
				Base = TabMain,
				Button = Button,
				Title = Title,
			},
			Elements = {},
		}
		
		local function Activate()
			for _,OtherElement in pairs(OptionsHandler:GetChildren()) do
				if not OtherElement:IsA("GuiBase") then continue end
				OtherElement.Visible = false
			end
			for _,MyElement in pairs(NewTab.Elements) do
				if not MyElement["Build"] then continue end
				if not MyElement.Build["Base"] then continue end
				MyElement.Build.Base.Visible = true
			end
		end
		
		Window:AddConnection(Button.MouseButton1Click, function()
			self.CurrentTab = NewTab
		end)
		local TweenTime = .2
		Window:AddConnection(Services.Run.RenderStepped, function()
			if self.CurrentTab~=NewTab then return end
			Activate()
			Services.Tween:Create(NewTab.Build.Base,TweenInfo.new(TweenTime/2),{Size=UDim2.fromScale(1.1,.2)}):Play()
			Services.Tween:Create(NewTab.Build.Title,TweenInfo.new(TweenTime/2),{TextColor3=Color3.fromRGB(115, 255, 83)}):Play()
			repeat wait() until self.CurrentTab~=NewTab
			Services.Tween:Create(NewTab.Build.Base,TweenInfo.new(TweenTime/2),{Size=UDim2.fromScale(.9,.15)}):Play()
			Services.Tween:Create(NewTab.Build.Title,TweenInfo.new(TweenTime/2),{TextColor3=Color3.new(1,1,1)}):Play()
		end)
		
		--Options
		
		local function GetOption(Type)
			local Options = {
				["Check"] = CheckOption,
				["Click"] = ClickOption,
				["Input"] = InputOption,
			}
			return Options[Type]:Clone()
		end

		function NewTab:MakeOption(OptionConfigs)
			local OptionMain = GetOption(OptionConfigs.Type)
			OptionMain.Parent = OptionsHandler
			local Handler = OptionMain.Handler
			local Button:TextBox = Handler.Button
			local Title = Handler.TitleHandler.Title
			local Tip = Handler.TitleHandler.Tip

			local NewOption = {
				Build = {
					Base = OptionMain,
					Handler = Handler,
					Button = Button,
					Title = Title,
					Tip = Tip,
				},
				Type = OptionConfigs.Type,
			}
			Title.Text = tostring(OptionConfigs.Title or "Option")
			if OptionConfigs.Tip then
				Tip.Text = tostring(OptionConfigs.Tip)
			else
				Tip.Visible = false
			end
			table.insert(self.Elements,NewOption)
			
			local Block = SetProperties(Template("Frame",Color3.new(0,0,0),1),{
				Parent = NewOption.Build.Handler,
				Size = UDim2.fromScale(1,1),
				Position = UDim2.fromScale(.5,.5),
				AnchorPoint = Vector2.new(.5,.5),
			})
			
			--Types--
			
			if OptionConfigs.Type=="Check" then
				NewOption.Avtive = false
				
				local function Activate()
					if NewOption.Avtive then
						if OptionConfigs.CallBack.On then
							OptionConfigs.CallBack.On()
						end
						Services.Tween:Create(Button,TweenInfo.new(TweenTime),{BackgroundColor3=Color3.fromRGB(115, 255, 83)}):Play()
						Services.Tween:Create(Title,TweenInfo.new(TweenTime),{TextColor3=Color3.fromRGB(115, 255, 83)}):Play()
					else
						if OptionConfigs.CallBack.Off then
							OptionConfigs.CallBack.Off()
						end
						Services.Tween:Create(Button,TweenInfo.new(TweenTime),{BackgroundColor3=Color3.fromRGB(40, 40, 40)}):Play()
						Services.Tween:Create(Title,TweenInfo.new(TweenTime),{TextColor3=Color3.new(1, 1, 1)}):Play()
					end
				end
				
				Window:AddConnection(Button.MouseButton1Click, function()
					NewOption.Avtive = not NewOption.Avtive
					Activate()
				end)
				
				function NewOption:Activate()
					if NewOption.Avtive then return end
					NewOption.Avtive = true
					Activate()
				end
				function NewOption:Deactivate()
					if not NewOption.Avtive then return end
					NewOption.Avtive = false
					Activate()
				end
				--
			elseif OptionConfigs.Type=="Click" then
				local function Activate()
					if OptionConfigs.CallBack.Click then
						OptionConfigs.CallBack.Click()
					end
					Services.Tween:Create(Button,TweenInfo.new(TweenTime/2),{BackgroundColor3=Color3.fromRGB(115, 255, 83)}):Play()
					Services.Tween:Create(Title,TweenInfo.new(TweenTime),{TextColor3=Color3.fromRGB(115, 255, 83)}):Play()
					task.wait(TweenTime/2)
					Services.Tween:Create(Button,TweenInfo.new(TweenTime),{BackgroundColor3=Color3.fromRGB(40, 40, 40)}):Play()
					Services.Tween:Create(Title,TweenInfo.new(TweenTime),{TextColor3=Color3.new(1, 1, 1)}):Play()
				end

				Window:AddConnection(Button.MouseButton1Click, function()
					Activate()
				end)

				function NewOption:Activate()
					Activate()
				end
				--
			elseif OptionConfigs.Type=="Input" then
				local function Activate()
					if OptionConfigs.CallBack.Changed then
						OptionConfigs.CallBack.Changed(tostring(Button.Text))
					end
					Services.Tween:Create(Button,TweenInfo.new(TweenTime/2),{BackgroundColor3=Color3.fromRGB(115, 255, 83)}):Play()
					Services.Tween:Create(Title,TweenInfo.new(TweenTime),{TextColor3=Color3.fromRGB(115, 255, 83)}):Play()
					Services.Tween:Create(Button,TweenInfo.new(TweenTime),{PlaceholderColor3=Color3.fromRGB(115+25, 255+25, 83+25)}):Play()
					task.wait(TweenTime/2)
					Services.Tween:Create(Button,TweenInfo.new(TweenTime),{BackgroundColor3=Color3.fromRGB(40, 40, 40)}):Play()
					Services.Tween:Create(Title,TweenInfo.new(TweenTime),{TextColor3=Color3.new(1, 1, 1)}):Play()
					Services.Tween:Create(Button,TweenInfo.new(TweenTime),{PlaceholderColor3=Color3.fromRGB(65, 65, 65)}):Play()
				end
				
				Window:AddConnection(Button.Changed, function(Property)
					if Property~="Text" then return end
					Activate()
				end)

				function NewOption:Activate()
					Activate()
				end
				function NewOption:SetText(Text:string)
					Button.Text = tostring(Text or "")
				end
			end

			--Block--
			
			function NewOption:Block()
				Button.Interactable = false
				Services.Tween:Create(Block,TweenInfo.new(TweenTime),{BackgroundTransparency=.4}):Play()
			end
			function NewOption:UnBlock()
				Button.Interactable = true
				Services.Tween:Create(Block,TweenInfo.new(TweenTime),{BackgroundTransparency=1}):Play()
			end
			
			--

			return NewOption
		end
		
		function NewTab:AddTitle(Text, PosX, Color)
			local NewTitle = {
				Build = {
					Base = SetProperties(Template("Text","Title", PosX or Enum.TextXAlignment.Left),{
						Size = UDim2.fromScale(.9,.1),
						Position = UDim2.fromScale(0,0),
						AnchorPoint = Vector2.new(0,0),
						Visible = false,
					})
				},
				Text = tostring(Text or ""),
			}
			NewTitle.Build.Base.Text = NewTitle.Text
			NewTitle.Build.Base.TextColor3 = Color or Color3.new(1,1,1)
			NewTitle.Build.Base.Parent = OptionsHandler
			--
			table.insert(self.Elements, NewTitle)
			return NewTitle
		end
		
		function NewTab:AddSpace()
			local NewSpace = {
				Build = {
					Base = SetProperties(Template("Frame",nil,1),{
						Size = UDim2.fromScale(1,.1),
						Position = UDim2.fromScale(0,0),
						AnchorPoint = Vector2.new(0,0),
						Visible = false,
					})
				}
			}
			NewSpace.Build.Base.Parent = OptionsHandler
			--
			table.insert(self.Elements, NewSpace)
			return NewSpace
		end
		
		return NewTab
	end
	
	----
	
	return Window
end

return GIFui
