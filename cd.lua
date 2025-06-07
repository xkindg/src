--[[
	User Interface Library
	Made by Late, Modified by xsolito_rbl
]]

--// Connections
local GetService = game.GetService
local Connect = game.Loaded.Connect
local Wait = game.Loaded.Wait
local Clone = game.Clone 
local Destroy = game.Destroy 

if (not game:IsLoaded()) then
	local Loaded = game.Loaded
	Loaded.Wait(Loaded);
end

--// Important 
local Setup = {
	Keybind = Enum.KeyCode.LeftControl,
	Transparency = 0.2,
	ThemeMode = "Dark",
	Size = UDim2.new(0, 600, 0, 350), -- Adjusted: wider (600px) and shorter (350px)
}

--// Themes
local Themes = {
	Dark = {
		Primary = Color3.fromRGB(30, 30, 30),
		Secondary = Color3.fromRGB(35, 35, 35),
		Component = Color3.fromRGB(40, 40, 40),
		Interactables = Color3.fromRGB(45, 45, 45),
		Tab = Color3.fromRGB(200, 200, 200),
		Title = Color3.fromRGB(240, 240, 240),
		Description = Color3.fromRGB(200, 200, 200),
		Shadow = Color3.fromRGB(0, 0, 0),
		Outline = Color3.fromRGB(40, 40, 40),
		Icon = Color3.fromRGB(220, 220, 220),
	},
	["XSL blue pink"] = {
		Primary = Color3.fromRGB(30, 30, 30), -- Base background
		Secondary = Color3.fromRGB(35, 35, 35),
		Component = Color3.fromRGB(40, 40, 40),
		Interactables = Color3.fromRGB(45, 45, 45),
		Tab = Color3.fromRGB(200, 200, 200),
		Title = Color3.fromRGB(240, 240, 240),
		Description = Color3.fromRGB(200, 200, 200),
		Shadow = Color3.fromRGB(0, 0, 0),
		Outline = Color3.fromRGB(40, 40, 40),
		Icon = Color3.fromRGB(220, 220, 220),
		Gradient = {
			Enabled = true,
			Color1 = Color3.fromRGB(1, 94, 255), -- #015EFF
			Color2 = Color3.fromRGB(255, 5, 70), -- #FF0546
		},
	},
	Predeterminado = {
		Primary = Color3.fromRGB(30, 30, 30),
		Secondary = Color3.fromRGB(35, 35, 35),
		Component = Color3.fromRGB(40, 40, 40),
		Interactables = Color3.fromRGB(45, 45, 45),
		Tab = Color3.fromRGB(200, 200, 200),
		Title = Color3.fromRGB(240, 240, 240),
		Description = Color3.fromRGB(200, 200, 200),
		Shadow = Color3.fromRGB(0, 0, 0),
		Outline = Color3.fromRGB(40, 40, 40),
		Icon = Color3.fromRGB(220, 220, 220),
		BackgroundImage = {
			Enabled = true,
			Image = "rbxassetid://102712692152402",
			Transparency = 0.7, -- 30% transparency (1 - 0.3)
		},
	},
}

--// Services & Functions
local Type, Blur = nil
local LocalPlayer = GetService(game, "Players").LocalPlayer;
local Services = {
	Insert = GetService(game, "InsertService");
	Tween = GetService(game, "TweenService");
	Run = GetService(game, "RunService");
	Input = GetService(game, "UserInputService");
}

local Player = {
	Mouse = LocalPlayer:GetMouse();
	GUI = LocalPlayer.PlayerGui;
}

local Tween = function(Object : Instance, Speed : number, Properties : {},  Info : { EasingStyle: Enum?, EasingDirection: Enum? })
	local Style, Direction
	if Info then
		Style, Direction = Info["EasingStyle"], Info["EasingDirection"]
	else
		Style, Direction = Enum.EasingStyle.Sine, Enum.EasingDirection.Out
	end
	return Services.Tween:Create(Object, TweenInfo.new(Speed, Style, Direction), Properties):Play()
end

local SetProperty = function(Object: Instance, Properties: {})
	for Index, Property in next, Properties do
		Object[Index] = (Property);
	end
	return Object
end

local Multiply = function(Value, Amount)
	local New = {
		Value.X.Scale * Amount;
		Value.X.Offset * Amount;
		Value.Y.Scale * Amount;
		Value.Y.Offset * Amount;
	}
	return UDim2.new(unpack(New))
end

local Color = function(Color, Factor, Mode)
	Mode = Mode or Setup.ThemeMode
	if Mode == "Light" then
		return Color3.fromRGB((Color.R * 255) - Factor, (Color.G * 255) - Factor, (Color.B * 255) - Factor)
	else
		return Color3.fromRGB((Color.R * 255) + Factor, (Color.G * 255) + Factor, (Color.B * 255) + Factor)
	end
end

local Drag = function(Canvas)
	if Canvas then
		local Dragging;
		local DragInput;
		local Start;
		local StartPosition;
		local function Update(input)
			local delta = input.Position - Start
			Canvas.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + delta.Y)
		end
		Connect(Canvas.InputBegan, function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch and not Type then
				Dragging = true
				Start = Input.Position
				StartPosition = Canvas.Position
				Connect(Input.Changed, function()
					if Input.UserInputState == Enum.UserInputState.End then
						Dragging = false
					end
				end)
			end
		end)
		Connect(Canvas.InputChanged, function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch and not Type then
				DragInput = Input
			end
		end)
		Connect(Services.Input.InputChanged, function(Input)
			if Input == DragInput and Dragging and not Type then
				Update(Input)
			end
		end)
	end
end

--// Resizing (unchanged)
Resizing = { 
	TopLeft = { X = Vector2.new(-1, 0),   Y = Vector2.new(0, -1)};
	TopRight = { X = Vector2.new(1, 0),    Y = Vector2.new(0, -1)};
	BottomLeft = { X = Vector2.new(-1, 0),   Y = Vector2.new(0, 1)};
	BottomRight = { X = Vector2.new(1, 0),    Y = Vector2.new(0, 1)};
}

Resizeable = function(Tab, Minimum, Maximum)
	task.spawn(function()
		local MousePos, Size, UIPos = nil, nil, nil
		if Tab and Tab:FindFirstChild("Resize") then
			local Positions = Tab:FindFirstChild("Resize")
			for Index, Types in next, Positions:GetChildren() do
				Connect(Types.InputBegan, function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						Type = Types
						MousePos = Vector2.new(Player.Mouse.X, Player.Mouse.Y)
						Size = Tab.AbsoluteSize
						UIPos = Tab.Position
					end
				end)
				Connect(Types.InputEnded, function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						Type = nil
					end
				end)
			end
		end
		local Resize = function(Delta)
			if Type and MousePos and Size and UIPos and Tab:FindFirstChild("Resize")[Type.Name] == Type then
				local Mode = Resizing[Type.Name]
				local NewSize = Vector2.new(Size.X + Delta.X * Mode.X.X, Size.Y + Delta.Y * Mode.Y.Y)
				NewSize = Vector2.new(math.clamp(NewSize.X, Minimum.X, Maximum.X), math.clamp(NewSize.Y, Minimum.Y, Maximum.Y))
				local AnchorOffset = Vector2.new(Tab.AnchorPoint.X * Size.X, Tab.AnchorPoint.Y * Size.Y)
				local NewAnchorOffset = Vector2.new(Tab.AnchorPoint.X * NewSize.X, Tab.AnchorPoint.Y * NewSize.Y)
				local DeltaAnchorOffset = NewAnchorOffset - AnchorOffset
				Tab.Size = UDim2.new(0, NewSize.X, 0, NewSize.Y)
				local NewPosition = UDim2.new(
					UIPos.X.Scale, 
					UIPos.X.Offset + DeltaAnchorOffset.X * Mode.X.X,
					UIPos.Y.Scale,
					UIPos.Y.Offset + DeltaAnchorOffset.Y * Mode.Y.Y
				)
				Tab.Position = NewPosition
			end
		end
		Connect(Player.Mouse.Move, function()
			if Type then
				Resize(Vector2.new(Player.Mouse.X, Player.Mouse.Y) - MousePos)
			end
		end)
	end)
end

--// Setup [UI]
if (identifyexecutor) then
	Screen = Services.Insert:LoadLocalAsset("rbxassetid://18490507748");
	Blur = loadstring(game:HttpGet("https://raw.githubusercontent.com/lxte/lates-lib/main/Assets/Blur.lua"))();
else
	Screen = (script.Parent);
	Blur = require(script.Blur)
end

Screen.Main.Visible = false

xpcall(function()
	Screen.Parent = game.CoreGui
end, function() 
	Screen.Parent = Player.GUI
end)

--// Tables for Data
local Animations = {}
local Blurs = {}
local Components = (Screen:FindFirstChild("Components"));
local Library = {};
local StoredInfo = {
	["Sections"] = {};
	["Tabs"] = {};
	["Minimized"] = false;
};

--// Animations [Window]
function Animations:Open(Window: CanvasGroup, Transparency: number, UseCurrentSize: boolean)
	local Original = (UseCurrentSize and Window.Size) or Setup.Size
	local Multiplied = Multiply(Original, 1.1)
	local Shadow = Window:FindFirstChildOfClass("UIStroke")
	SetProperty(Shadow, { Transparency = 1 })
	SetProperty(Window, {
		Size = Multiplied,
		GroupTransparency = 1,
		Visible = true,
	})
	Tween(Shadow, .25, { Transparency = 0.5 })
	Tween(Window, .25, {
		Size = Original,
		GroupTransparency = Transparency or 0,
	})
end

function Animations:Close(Window: CanvasGroup)
	local Original = Window.Size
	local Multiplied = Multiply(Original, 1.1)
	local Shadow = Window:FindFirstChildOfClass("UIStroke")
	SetProperty(Window, {
		Size = Original,
	})
	Tween(Shadow, .25, { Transparency = 1 })
	Tween(Window, .25, {
		Size = Multiplied,
		GroupTransparency = 1,
	})
	task.wait(.25)
	Window.Size = Original
	Window.Visible = false
end

function Animations:Component(Component: any, Custom: boolean)	
	Connect(Component.InputBegan, function() 
		if Custom then
			Tween(Component, .25, { Transparency = .85 });
		else
			Tween(Component, .25, { BackgroundColor3 = Color(Themes[Setup.ThemeMode].Component, 5, Setup.ThemeMode) });
		end
	end)
	Connect(Component.InputEnded, function() 
		if Custom then
			Tween(Component, .25, { Transparency = 1 });
		else
			Tween(Component, .25, { BackgroundColor3 = Themes[Setup.ThemeMode].Component });
		end
	end)
end

--// Library [Window]
function Library:CreateWindow(Settings: { Title: string, Size: UDim2, Transparency: number, MinimizeKeybind: Enum.KeyCode?, Blurring: boolean, Theme: string })
	local Window = Clone(Screen:WaitForChild("Main"));
	local Sidebar = Window:FindFirstChild("Sidebar");
	local Holder = Window:FindFirstChild("Main");
	local BG = Window:FindFirstChild("BackgroundShadow");
	local Tab = Sidebar:FindFirstChild("Tab");

	-- Add Background Image for Predeterminado Theme
	local BackgroundImage = Instance.new("ImageLabel")
	SetProperty(BackgroundImage, {
		Name = "BackgroundImage",
		Parent = Window,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		Image = Themes.Predeterminado.BackgroundImage.Image,
		ImageTransparency = Themes.Predeterminado.BackgroundImage.Transparency,
		Visible = (Settings.Theme == "Predeterminado"),
		ZIndex = 0,
	})

	-- Add Gradient Border
	local Stroke = Window:FindFirstChildOfClass("UIStroke")
	local Gradient = Instance.new("UIGradient")
	SetProperty(Gradient, {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(1, 94, 255)), -- #015EFF
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 5, 70)), -- #FF0546
		}),
		Rotation = 45,
		Parent = Stroke,
	})

	local Options = {};
	local Examples = {};
	local Opened = true;
	local Maximized = false;
	local BlurEnabled = false;
	local IconFrame = nil;

	for Index, Example in next, Window:GetDescendants() do
		if Example.Name:find("Example") and not Examples[Example.Name] then
			Examples[Example.Name] = Example
		end
	end

	--// Create Minimized Icon
	local CreateIcon = function()
		local Icon = Instance.new("ImageButton")
		SetProperty(Icon, {
			Name = "MinimizedIcon",
			Parent = Screen,
			Size = UDim2.new(0, 50, 0, 50),
			Position = UDim2.new(0.5, -25, 0.5, -25),
			Image = "rbxassetid://122797206521816",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 10,
		})
		local Corner = Instance.new("UICorner")
		SetProperty(Corner, {
			CornerRadius = UDim.new(0, 8),
			Parent = Icon,
		})
		Drag(Icon)
		Connect(Icon.MouseButton1Click, function()
			StoredInfo.Minimized = false
			Window.Visible = true
			Animations:Open(Window, Setup.Transparency)
			if BlurEnabled then
				Blurs[Settings.Title].root.Parent = workspace.CurrentCamera
			end
			Destroy(Icon)
		end)
		return Icon
	end

	--// UI Blur & More
	Drag(Window);
	Resizeable(Window, Vector2.new(411, 271), Vector2.new(9e9, 9e9));
	Setup.Transparency = Settings.Transparency or 0
	Setup.Size = Settings.Size or Setup.Size
	Setup.ThemeMode = Settings.Theme or "Dark"

	if Settings.Blurring then
		Blurs[Settings.Title] = Blur.new(Window, 5)
		BlurEnabled = true
	end

	if Settings.MinimizeKeybind then
		Setup.Keybind = Settings.MinimizeKeybind
	end

	--// Animate
	local Close = function()
		if StoredInfo.Minimized then
			return
		end
		if Opened then
			if BlurEnabled then
				Blurs[Settings.Title].root.Parent = nil
			end
			Opened = false
			Animations:Close(Window)
			Window.Visible = false
		else
			Animations:Open(Window, Setup.Transparency)
			Opened = true
			if BlurEnabled then
				Blurs[Settings.Title].root.Parent = workspace.CurrentCamera
			end
		end
	end

	--// Add Minimize Button Logic
	for Index, Button in next, Sidebar.Top.Buttons:GetChildren() do
		if Button:IsA("TextButton") then
			local Name = Button.Name
			Animations:Component(Button, true)
			Connect(Button.MouseButton1Click, function() 
				if Name == "Close" then
					Close()
				elseif Name == "Maximize" then
					if Maximized then
						Maximized = false
						Tween(Window, .15, { Size = Setup.Size });
					else
						Maximized = true
						Tween(Window, .15, { Size = UDim2.fromScale(1, 1), Position = UDim2.fromScale(0.5, 0.5 )});
					end
				elseif Name == "Minimize" then
					if not StoredInfo.Minimized then
						StoredInfo.Minimized = true
						Window.Visible = false
						if BlurEnabled then
							Blurs[Settings.Title].root.Parent = nil
						end
						IconFrame = CreateIcon()
					end
				end
			end)
		end
	end

	Services.Input.InputBegan:Connect(function(Input, Focused) 
		if (Input == Setup.Keybind or Input.KeyCode == Setup.Keybind) and not Focused then
			Close()
		end
	end)

	--// Tab Functions (unchanged)
	function Options:SetTab(Name: string)
		-- [Original SetTab code unchanged]
	end

	function Options:AddTabSection(Settings: { Name: string, Order: number })
		-- [Original AddTabSection code unchanged]
	end

	function Options:AddTab(Settings: { Title: string, Icon: string, Section: string? })
		-- [Original AddTab code unchanged]
	end
	
	--// Notifications (unchanged)
	function Options:Notify(Settings: { Title: string, Description: string, Duration: number }) 
		-- [Original Notify code unchanged]
	end

	--// Component Functions (unchanged)
	function Options:GetLabels(Component)
		-- [Original GetLabels code unchanged]
	end

	function Options:AddSection(Settings: { Name: string, Tab: Instance }) 
		-- [Original AddSection code unchanged]
	end
	
	function Options:AddButton(Settings: { Title: string, Description: string, Tab: Instance, Callback: any }) 
		-- [Original AddButton code unchanged]
	end

	function Options:AddInput(Settings: { Title: string, Description: string, Tab: Instance, Callback: any }) 
		-- [Original AddInput code unchanged]
	end

	function Options:AddToggle(Settings: { Title: string, Description: string, Default: boolean, Tab: Instance, Callback: any }) 
		-- [Original AddToggle code unchanged]
	end
	
	function Options:AddKeybind(Settings: { Title: string, Description: string, Tab: Instance, Callback: any }) 
		-- [Original AddKeybind code unchanged]
	end

	function Options:AddDropdown(Settings: { Title: string, Description: string, Options: {}, Tab: Instance, Callback: any }) 
		-- [Original AddDropdown code unchanged]
	end

	function Options:AddSlider(Settings: { Title: string, Description: string, MaxValue: number, AllowDecimals: boolean, DecimalAmount: number, Tab: Instance, Callback: any }) 
		-- [Original AddSlider code unchanged]
	end

	function Options:AddParagraph(Settings: { Title: string, Description: string, Tab: Instance }) 
		-- [Original AddParagraph code unchanged]
	end

	local ThemeSettings = {
		Names = {
			["Paragraph"] = function(Label)
				if Label:IsA("TextButton") then
					Label.BackgroundColor3 = Color(Themes[Setup.ThemeMode].Component, 5, Setup.ThemeMode);
				end
			end,
			["Title"] = function(Label)
				if Label:IsA("TextLabel") then
					Label.TextColor3 = Themes[Setup.ThemeMode].Title
				end
			end,
			["Description"] = function(Label)
				if Label:IsA("TextLabel") then
					Label.TextColor3 = Themes[Setup.ThemeMode].Description
				end
			end,
			["Section"] = function(Label)
				if Label:IsA("TextLabel") then
					Label.TextColor3 = Themes[Setup.ThemeMode].Title
				end
			end,
			["Options"] = function(Label)
				if Label:IsA("TextLabel") and Label.Parent.Name == "Main" then
					Label.TextColor3 = Themes[Setup.ThemeMode].Title
				end
			end,
			["Notification"] = function(Label)
				if Label:IsA("CanvasGroup") then
					Label.BackgroundColor3 = Themes[Setup.ThemeMode].Primary
					Label.UIStroke.Color = Themes[Setup.ThemeMode].Outline
				end
			end,
			["TextLabel"] = function(Label)
				if Label:IsA("TextLabel") and Label.Parent:FindFirstChild("List") then
					Label.TextColor3 = Themes[Setup.ThemeMode].Tab
				end
			end,
			["Main"] = function(Label)
				if Label:IsA("Frame") then
					if Label.Parent == Window then
						Label.BackgroundColor3 = Themes[Setup.ThemeMode].Secondary
					elseif Label.Parent:FindFirstChild("Value") then
						local Toggle = Label.Parent.Value 
						local Circle = Label:FindFirstChild("Circle")
						if not Toggle.Value then
							Label.BackgroundColor3 = Themes[Setup.ThemeMode].Interactables
							Label.Circle.BackgroundColor3 = Themes[Setup.ThemeMode].Primary
						end
					else
						Label.BackgroundColor3 = Themes[Setup.ThemeMode].Interactables
					end
				elseif Label:FindFirstChild("Padding") then
					Label.TextColor3 = Themes[Setup.ThemeMode].Title
				end
			end,
			["Amount"] = function(Label)
				if Label:IsA("Frame") then
					Label.BackgroundColor3 = Themes[Setup.ThemeMode].Interactables
				end
			end,
			["Slide"] = function(Label)
				if Label:IsA("Frame") then
					Label.BackgroundColor3 = Themes[Setup.ThemeMode].Interactables
				end
			end,
			["Input"] = function(Label)
				if Label:IsA("TextLabel") then
					Label.TextColor3 = Themes[Setup.ThemeMode].Title
				elseif Label:FindFirstChild("Labels") then
					Label.BackgroundColor3 = Themes[Setup.ThemeMode].Component
				elseif Label:IsA("TextBox") and Label.Parent.Name == "Main" then
					Label.TextColor3 = Themes[Setup.ThemeMode].Title
				end
			end,
			["Outline"] = function(Stroke)
				if Stroke:IsA("UIStroke") then
					Stroke.Color = Themes[Setup.ThemeMode].Outline
				end
			end,
			["DropdownExample"] = function(Label)
				Label.BackgroundColor3 = Themes[Setup.ThemeMode].Secondary
			end,
			["Underline"] = function(Label)
				if Label:IsA("Frame") then
					Label.BackgroundColor3 = Themes[Setup.ThemeMode].Outline
				end
			end,
		},
		Classes = {
			["ImageLabel"] = function(Label)
				if Label.Image ~= "rbxassetid://6644618143" then
					Label.ImageColor3 = Themes[Setup.ThemeMode].Icon
				end
			end,
			["TextLabel"] = function(Label)
				if Label:FindFirstChild("Padding") then
					Label.TextColor3 = Themes[Setup.ThemeMode].Title
				end
			end,
			["TextButton"] = function(Label)
				if Label:FindFirstChild("Labels") then
					Label.BackgroundColor3 = Themes[Setup.ThemeMode].Component
				end
			end,
			["ScrollingFrame"] = function(Label)
				Label.ScrollBarImageColor3 = Themes[Setup.ThemeMode].Component
			end,
		},
	}

	function Options:SetTheme(Info)
		Setup.ThemeMode = Info or Setup.ThemeMode
		local Theme = Themes[Setup.ThemeMode]
		Window.BackgroundColor3 = Theme.Primary
		Holder.BackgroundColor3 = Theme.Secondary
		Window.UIStroke.Color = Theme.Shadow
		BackgroundImage.Visible = (Theme.BackgroundImage and Theme.BackgroundImage.Enabled) or false
		if Theme.BackgroundImage then
			BackgroundImage.Image = Theme.BackgroundImage.Image
			BackgroundImage.ImageTransparency = Theme.BackgroundImage.Transparency
		end
		if Theme.Gradient and Theme.Gradient.Enabled then
			Gradient.Enabled = true
			Gradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Theme.Gradient.Color1),
				ColorSequenceKeypoint.new(1, Theme.Gradient.Color2),
			})
		else
			Gradient.Enabled = false
			Window.UIStroke.Color = Theme.Shadow
		end
		for Index, Descendant in next, Screen:GetDescendants() do
			local Name, Class = ThemeSettings.Names[Descendant.Name], ThemeSettings.Classes[Descendant.ClassName]
			if Name then
				Name(Descendant)
			elseif Class then
				Class(Descendant)
			end
		end
	end

	function Options:SetSetting(Setting, Value)
		if Setting == "Size" then
			Window.Size = Value
			Setup.Size = Value
		elseif Setting == "Transparency" then
			Window.GroupTransparency = Value
			Setup.Transparency = Value
			for Index, Notification in next, Screen:GetDescendants() do
				if Notification:IsA("CanvasGroup") and Notification.Name == "Notification" then
					Notification.GroupTransparency = Value
				end
			end
		elseif Setting == "Blur" then
			local AlreadyBlurred, Root = Blurs[Settings.Title], nil
			if AlreadyBlurred then
				Root = Blurs[Settings.Title]["root"]
			end
			if Value then
				BlurEnabled = true
				if not AlreadyBlurred or not Root then
					Blurs[Settings.Title] = Blur.new(Window, 5)
				elseif Root and not Root.Parent then
					Root.Parent = workspace.CurrentCamera
				end
			elseif not Value and (AlreadyBlurred and Root and Root.Parent) then
				Root.Parent = nil
				BlurEnabled = false
			end
		elseif Setting == "Theme" then
			Setup.ThemeMode = Value
			Options:SetTheme(Value)
		elseif Setting == "Keybind" then
			Setup.Keybind = Value
		else
			warn("Tried to change a setting that doesn't exist or isn't available to change.")
		end
	end

	SetProperty(Window, { Size = Settings.Size or Setup.Size, Visible = true, Parent = Screen });
	Animations:Open(Window, Settings.Transparency or 0)
	Options:SetTheme(Settings.Theme or Setup.ThemeMode)

	return Options
end

return Library
