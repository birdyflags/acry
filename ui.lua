-- Acrylic UI Library for Roblox
-- Clean design with acrylic blur effects and sidebar navigation

local AcrylicUI = {}
AcrylicUI.__index = AcrylicUI

-- Services
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Default colors and properties
local DEFAULT_SETTINGS = {
	PrimaryColor = Color3.fromRGB(0, 120, 215),
	SecondaryColor = Color3.fromRGB(40, 40, 40),
	BackgroundColor = Color3.fromRGB(30, 30, 30),
	TextColor = Color3.fromRGB(255, 255, 255),
	AccentColor = Color3.fromRGB(0, 180, 255),
	CornerRadius = UDim.new(0, 8),
	Transparency = 0.1,
	BlurSize = 10
}

-- Create acrylic blur effect
local function createAcrylicBlur(parent)
	local blur = Instance.new("BlurEffect")
	blur.Name = "AcrylicBlur"
	blur.Size = DEFAULT_SETTINGS.BlurSize
	blur.Parent = parent
	
	local frame = Instance.new("Frame")
	frame.Name = "AcrylicOverlay"
	frame.BackgroundColor3 = DEFAULT_SETTINGS.BackgroundColor
	frame.BackgroundTransparency = DEFAULT_SETTINGS.Transparency
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BorderSizePixel = 0
	frame.ZIndex = 1
	frame.Parent = parent
	
	return frame, blur
end

-- Create rounded corners
local function applyCorners(instance)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = DEFAULT_SETTINGS.CornerRadius
	corner.Parent = instance
	return corner
end

-- Create gradient stroke
local function createStroke(instance)
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Transparency = 0.8
	stroke.Thickness = 1
	stroke.Parent = instance
	return stroke
end

-- Create text label
local function createTextLabel(parent, text, position, size)
	local label = Instance.new("TextLabel")
	label.Text = text
	label.Font = Enum.Font.GothamSemibold
	label.TextColor3 = DEFAULT_SETTINGS.TextColor
	label.TextSize = 14
	label.BackgroundTransparency = 1
	label.Position = position or UDim2.new(0, 0, 0, 0)
	label.Size = size or UDim2.new(1, 0, 0, 30)
	label.Parent = parent
	return label
end

-- Create icon
local function createIcon(parent, iconName, position)
	local icon = Instance.new("ImageLabel")
	icon.Name = "Icon"
	icon.Image = "rbxassetid://" .. (ICONS[iconName] or ICONS["Default"])
	icon.BackgroundTransparency = 1
	icon.Size = UDim2.new(0, 20, 0, 20)
	icon.Position = position or UDim2.new(0, 10, 0.5, -10)
	icon.Parent = parent
	return icon
end

-- Icon mapping (using Roblox icon asset IDs)
local ICONS = {
	Home = 10709845534,
	Settings = 10734924335,
	User = 10709846268,
	Bell = 10709845872,
	Chart = 10709846052,
	Game = 10709846176,
	Close = 10734926658,
	Minimize = 10734926890,
	Dropdown = 10734927045,
	ToggleOn = 10734927212,
	ToggleOff = 10734927345,
	Slider = 10734927489,
	Default = 10734927623
}

-- Notification system
local NotificationManager = {}
NotificationManager.__index = NotificationManager

function NotificationManager.new(parent)
	local self = setmetatable({}, NotificationManager)
	self.Parent = parent
	self.Notifications = {}
	self.NotificationQueue = {}
	return self
end

function NotificationManager:ShowNotification(title, message, duration, notificationType)
	duration = duration or 5
	notificationType = notificationType or "Info"
	
	local notification = Instance.new("Frame")
	notification.Name = "Notification"
	notification.BackgroundColor3 = DEFAULT_SETTINGS.SecondaryColor
	notification.BackgroundTransparency = 0.2
	notification.Size = UDim2.new(0.3, 0, 0, 80)
	notification.Position = UDim2.new(0.7, 0, 0, 10 + (#self.Notifications * 90))
	notification.AnchorPoint = Vector2.new(1, 0)
	notification.ZIndex = 100
	
	applyCorners(notification)
	createStroke(notification)
	
	-- Add acrylic effect
	local acrylic = Instance.new("Frame")
	acrylic.Name = "AcrylicOverlay"
	acrylic.BackgroundColor3 = DEFAULT_SETTINGS.BackgroundColor
	acrylic.BackgroundTransparency = DEFAULT_SETTINGS.Transparency
	acrylic.Size = UDim2.new(1, 0, 1, 0)
	acrylic.BorderSizePixel = 0
	acrylic.ZIndex = 1
	acrylic.Parent = notification
	
	local titleLabel = createTextLabel(notification, title, UDim2.new(0, 10, 0, 10), UDim2.new(1, -40, 0, 20))
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	
	local messageLabel = createTextLabel(notification, message, UDim2.new(0, 10, 0, 35), UDim2.new(1, -10, 0, 40))
	messageLabel.TextXAlignment = Enum.TextXAlignment.Left
	messageLabel.TextWrapped = true
	
	-- Type indicator
	local typeIndicator = Instance.new("Frame")
	typeIndicator.Name = "TypeIndicator"
	typeIndicator.Size = UDim2.new(0, 4, 1, 0)
	typeIndicator.Position = UDim2.new(0, 0, 0, 0)
	typeIndicator.BorderSizePixel = 0
	
	if notificationType == "Success" then
		typeIndicator.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
	elseif notificationType == "Warning" then
		typeIndicator.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
	elseif notificationType == "Error" then
		typeIndicator.BackgroundColor3 = Color3.fromRGB(244, 67, 54)
	else
		typeIndicator.BackgroundColor3 = DEFAULT_SETTINGS.PrimaryColor
	end
	
	typeIndicator.Parent = notification
	
	-- Close button
	local closeBtn = Instance.new("TextButton")
	closeBtn.Name = "CloseButton"
	closeBtn.Text = "×"
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 18
	closeBtn.TextColor3 = DEFAULT_SETTINGS.TextColor
	closeBtn.BackgroundTransparency = 1
	closeBtn.Size = UDim2.new(0, 30, 0, 30)
	closeBtn.Position = UDim2.new(1, -30, 0, 0)
	closeBtn.ZIndex = 2
	closeBtn.Parent = notification
	
	closeBtn.MouseButton1Click:Connect(function()
		self:RemoveNotification(notification)
	end)
	
	notification.Parent = self.Parent
	table.insert(self.Notifications, notification)
	
	-- Auto remove after duration
	task.delay(duration, function()
		if notification.Parent then
			self:RemoveNotification(notification)
		end
	end)
	
	-- Animate entry
	notification.Position = UDim2.new(1.1, 0, 0, 10 + ((#self.Notifications - 1) * 90))
	local tween = TweenService:Create(
		notification,
		TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{Position = UDim2.new(0.7, 0, 0, 10 + ((#self.Notifications - 1) * 90))}
	)
	tween:Play()
	
	return notification
end

function NotificationManager:RemoveNotification(notification)
	local index = table.find(self.Notifications, notification)
	if index then
		table.remove(self.Notifications, index)
		
		-- Animate removal
		local tween = TweenService:Create(
			notification,
			TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{Position = UDim2.new(1.1, 0, 0, notification.Position.Y.Offset)}
		)
		tween:Play()
		
		tween.Completed:Connect(function()
			notification:Destroy()
			self:UpdateNotificationPositions()
		end)
	end
end

function NotificationManager:UpdateNotificationPositions()
	for i, notification in ipairs(self.Notifications) do
		local tween = TweenService:Create(
			notification,
			TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{Position = UDim2.new(0.7, 0, 0, 10 + ((i - 1) * 90))}
		)
		tween:Play()
	end
end

-- Tab System
function AcrylicUI.CreateTabSystem(parent, tabNames, tabIcons)
	local tabSystem = Instance.new("Frame")
	tabSystem.Name = "TabSystem"
	tabSystem.BackgroundTransparency = 1
	tabSystem.Size = UDim2.new(1, 0, 1, 0)
	tabSystem.Parent = parent
	
	-- Sidebar for tabs
	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.BackgroundColor3 = DEFAULT_SETTINGS.SecondaryColor
	sidebar.BackgroundTransparency = 0.2
	sidebar.Size = UDim2.new(0, 200, 1, 0)
	sidebar.Position = UDim2.new(0, 0, 0, 0)
	sidebar.Parent = tabSystem
	
	applyCorners(sidebar)
	createStroke(sidebar)
	
	-- Add acrylic effect to sidebar
	createAcrylicBlur(sidebar)
	
	-- Tab buttons container
	local tabContainer = Instance.new("ScrollingFrame")
	tabContainer.Name = "TabContainer"
	tabContainer.BackgroundTransparency = 1
	tabContainer.Size = UDim2.new(1, 0, 1, -40)
	tabContainer.Position = UDim2.new(0, 0, 0, 40)
	tabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabContainer.ScrollingDirection = Enum.ScrollingDirection.Y
	tabContainer.ScrollBarThickness = 3
	tabContainer.Parent = sidebar
	
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.Padding = UDim.new(0, 5)
	uiListLayout.Parent = tabContainer
	
	-- Content area
	local contentArea = Instance.new("Frame")
	contentArea.Name = "ContentArea"
	contentArea.BackgroundTransparency = 1
	contentArea.Size = UDim2.new(1, -210, 1, 0)
	contentArea.Position = UDim2.new(0, 210, 0, 0)
	contentArea.Parent = tabSystem
	
	-- Tab content frames
	local tabContents = {}
	local tabButtons = {}
	local selectedTab = nil
	
	-- Create tabs
	for i, tabName in ipairs(tabNames) do
		-- Tab button
		local tabButton = Instance.new("TextButton")
		tabButton.Name = tabName .. "Tab"
		tabButton.Text = ""
		tabButton.BackgroundColor3 = DEFAULT_SETTINGS.BackgroundColor
		tabButton.BackgroundTransparency = 0.5
		tabButton.Size = UDim2.new(0.9, 0, 0, 40)
		tabButton.Position = UDim2.new(0.05, 0, 0, 0)
		tabButton.Parent = tabContainer
		
		applyCorners(tabButton)
		
		-- Icon
		local iconId = tabIcons and tabIcons[i] and ICONS[tabIcons[i]] or ICONS.Default
		local icon = Instance.new("ImageLabel")
		icon.Name = "Icon"
		icon.Image = "rbxassetid://" .. tostring(iconId)
		icon.BackgroundTransparency = 1
		icon.Size = UDim2.new(0, 24, 0, 24)
		icon.Position = UDim2.new(0, 15, 0.5, -12)
		icon.Parent = tabButton
		
		-- Tab label
		local label = createTextLabel(tabButton, tabName, UDim2.new(0, 50, 0, 0), UDim2.new(1, -50, 1, 0))
		label.TextXAlignment = Enum.TextXAlignment.Left
		
		-- Tab content frame
		local contentFrame = Instance.new("Frame")
		contentFrame.Name = tabName .. "Content"
		contentFrame.BackgroundTransparency = 1
		contentFrame.Size = UDim2.new(1, 0, 1, 0)
		contentFrame.Visible = false
		contentFrame.Parent = contentArea
		
		tabContents[tabName] = contentFrame
		tabButtons[tabName] = tabButton
		
		-- Select first tab by default
		if i == 1 then
			selectedTab = tabName
			tabButton.BackgroundColor3 = DEFAULT_SETTINGS.PrimaryColor
			tabButton.BackgroundTransparency = 0.3
			contentFrame.Visible = true
		end
		
		-- Tab button click event
		tabButton.MouseButton1Click:Connect(function()
			if selectedTab ~= tabName then
				-- Deselect previous tab
				if selectedTab then
					local prevButton = tabButtons[selectedTab]
					local prevTween = TweenService:Create(
						prevButton,
						TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{BackgroundColor3 = DEFAULT_SETTINGS.BackgroundColor, BackgroundTransparency = 0.5}
					)
					prevTween:Play()
					tabContents[selectedTab].Visible = false
				end
				
				-- Select new tab
				local newTween = TweenService:Create(
					tabButton,
					TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{BackgroundColor3 = DEFAULT_SETTINGS.PrimaryColor, BackgroundTransparency = 0.3}
				)
				newTween:Play()
				tabContents[tabName].Visible = true
				selectedTab = tabName
			end
		end)
	end
	
	-- Update container size
	uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		tabContainer.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
	end)
	
	-- Window controls (minimize/close)
	local windowControls = Instance.new("Frame")
	windowControls.Name = "WindowControls"
	windowControls.BackgroundTransparency = 1
	windowControls.Size = UDim2.new(1, 0, 0, 40)
	windowControls.Position = UDim2.new(0, 0, 0, 0)
	windowControls.Parent = sidebar
	
	-- Close button
	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Text = "×"
	closeButton.Font = Enum.Font.GothamBold
	closeButton.TextSize = 20
	closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
	closeButton.BackgroundTransparency = 1
	closeButton.Size = UDim2.new(0, 40, 1, 0)
	closeButton.Position = UDim2.new(1, -40, 0, 0)
	closeButton.Parent = windowControls
	
	-- Minimize button
	local minimizeButton = Instance.new("TextButton")
	minimizeButton.Name = "MinimizeButton"
	minimizeButton.Text = "−"
	minimizeButton.Font = Enum.Font.GothamBold
	minimizeButton.TextSize = 20
	minimizeButton.TextColor3 = DEFAULT_SETTINGS.TextColor
	minimizeButton.BackgroundTransparency = 1
	minimizeButton.Size = UDim2.new(0, 40, 1, 0)
	minimizeButton.Position = UDim2.new(1, -80, 0, 0)
	minimizeButton.Parent = windowControls
	
	return {
		MainFrame = tabSystem,
		Sidebar = sidebar,
		ContentArea = contentArea,
		TabContents = tabContents,
		CloseButton = closeButton,
		MinimizeButton = minimizeButton
	}
end

-- Button component
function AcrylicUI.CreateButton(parent, text, position, size, hasIcon, iconName)
	local button = Instance.new("TextButton")
	button.Name = "AcrylicButton"
	button.Text = text
	button.Font = Enum.Font.GothamSemibold
	button.TextColor3 = DEFAULT_SETTINGS.TextColor
	button.TextSize = 14
	button.BackgroundColor3 = DEFAULT_SETTINGS.PrimaryColor
	button.BackgroundTransparency = 0.2
	button.Size = size or UDim2.new(0, 120, 0, 40)
	button.Position = position or UDim2.new(0, 0, 0, 0)
	button.Parent = parent
	
	applyCorners(button)
	createStroke(button)
	
	-- Add acrylic effect
	createAcrylicBlur(button)
	
	-- Add icon if specified
	if hasIcon and iconName then
		local icon = createIcon(button, iconName, UDim2.new(0, 10, 0.5, -10))
		button.Text = "  " .. text
	end
	
	-- Hover effect
	button.MouseEnter:Connect(function()
		local tween = TweenService:Create(
			button,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundTransparency = 0.1}
		)
		tween:Play()
	end)
	
	button.MouseLeave:Connect(function()
		local tween = TweenService:Create(
			button,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundTransparency = 0.2}
		)
		tween:Play()
	end)
	
	return button
end

-- Toggle component
function AcrylicUI.CreateToggle(parent, text, position, defaultState)
	local toggleFrame = Instance.new("Frame")
	toggleFrame.Name = "Toggle"
	toggleFrame.BackgroundTransparency = 1
	toggleFrame.Size = UDim2.new(0, 200, 0, 30)
	toggleFrame.Position = position or UDim2.new(0, 0, 0, 0)
	toggleFrame.Parent = parent
	
	local label = createTextLabel(toggleFrame, text, UDim2.new(0, 0, 0, 0), UDim2.new(0.7, 0, 1, 0))
	label.TextXAlignment = Enum.TextXAlignment.Left
	
	local toggleButton = Instance.new("TextButton")
	toggleButton.Name = "ToggleButton"
	toggleButton.Text = ""
	toggleButton.BackgroundColor3 = defaultState and DEFAULT_SETTINGS.PrimaryColor or DEFAULT_SETTINGS.SecondaryColor
	toggleButton.BackgroundTransparency = 0.3
	toggleButton.Size = UDim2.new(0, 50, 0, 25)
	toggleButton.Position = UDim2.new(1, -55, 0.5, -12.5)
	toggleButton.Parent = toggleFrame
	
	applyCorners(toggleButton)
	createStroke(toggleButton)
	
	local toggleKnob = Instance.new("Frame")
	toggleKnob.Name = "ToggleKnob"
	toggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	toggleKnob.BackgroundTransparency = 0
	toggleKnob.Size = UDim2.new(0, 20, 0, 20)
	toggleKnob.Position = defaultState and UDim2.new(1, -25, 0.5, -10) or UDim2.new(0, 5, 0.5, -10)
	toggleKnob.Parent = toggleButton
	
	applyCorners(toggleKnob)
	
	local state = defaultState or false
	
	toggleButton.MouseButton1Click:Connect(function()
		state = not state
		
		if state then
			local tween1 = TweenService:Create(
				toggleKnob,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{Position = UDim2.new(1, -25, 0.5, -10)}
			)
			local tween2 = TweenService:Create(
				toggleButton,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundColor3 = DEFAULT_SETTINGS.PrimaryColor}
			)
			tween1:Play()
			tween2:Play()
		else
			local tween1 = TweenService:Create(
				toggleKnob,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{Position = UDim2.new(0, 5, 0.5, -10)}
			)
			local tween2 = TweenService:Create(
				toggleButton,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundColor3 = DEFAULT_SETTINGS.SecondaryColor}
			)
			tween1:Play()
			tween2:Play()
		end
	end)
	
	return {
		Frame = toggleFrame,
		ToggleButton = toggleButton,
		GetState = function() return state end,
		SetState = function(newState)
			state = newState
			toggleKnob.Position = state and UDim2.new(1, -25, 0.5, -10) or UDim2.new(0, 5, 0.5, -10)
			toggleButton.BackgroundColor3 = state and DEFAULT_SETTINGS.PrimaryColor or DEFAULT_SETTINGS.SecondaryColor
		end
	}
end

-- Slider component
function AcrylicUI.CreateSlider(parent, text, position, minValue, maxValue, defaultValue)
	local sliderFrame = Instance.new("Frame")
	sliderFrame.Name = "Slider"
	sliderFrame.BackgroundTransparency = 1
	sliderFrame.Size = UDim2.new(0, 300, 0, 60)
	sliderFrame.Position = position or UDim2.new(0, 0, 0, 0)
	sliderFrame.Parent = parent
	
	local label = createTextLabel(sliderFrame, text, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 20))
	label.TextXAlignment = Enum.TextXAlignment.Left
	
	local valueLabel = createTextLabel(sliderFrame, tostring(defaultValue or minValue), UDim2.new(1, -40, 0, 0), UDim2.new(0, 40, 0, 20))
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	
	local track = Instance.new("Frame")
	track.Name = "Track"
	track.BackgroundColor3 = DEFAULT_SETTINGS.SecondaryColor
	track.BackgroundTransparency = 0.5
	track.Size = UDim2.new(1, 0, 0, 6)
	track.Position = UDim2.new(0, 0, 0, 35)
	track.Parent = sliderFrame
	
	applyCorners(track)
	
	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.BackgroundColor3 = DEFAULT_SETTINGS.PrimaryColor
	fill.BackgroundTransparency = 0.3
	fill.Size = UDim2.new((defaultValue or minValue - minValue) / (maxValue - minValue), 0, 1, 0)
	fill.Position = UDim2.new(0, 0, 0, 0)
	fill.Parent = track
	
	applyCorners(fill)
	
	local knob = Instance.new("TextButton")
	knob.Name = "Knob"
	knob.Text = ""
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.BackgroundTransparency = 0
	knob.Size = UDim2.new(0, 20, 0, 20)
	knob.Position = UDim2.new((defaultValue or minValue - minValue) / (maxValue - minValue), -10, 0.5, -10)
	knob.Parent = track
	
	applyCorners(knob)
	createStroke(knob)
	
	local value = defaultValue or minValue
	local isDragging = false
	
	local function updateSlider(input)
		local relativeX = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
		relativeX = math.clamp(relativeX, 0, 1)
		
		value = math.floor(minValue + (maxValue - minValue) * relativeX)
		valueLabel.Text = tostring(value)
		
		fill.Size = UDim2.new(relativeX, 0, 1, 0)
		knob.Position = UDim2.new(relativeX, -10, 0.5, -10)
	end
	
	knob.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isDragging = true
		end
	end)
	
	knob.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isDragging = false
		end
	end)
	
	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateSlider(input)
		end
	end)
	
	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			updateSlider(input)
		end
	end)
	
	return {
		Frame = sliderFrame,
		GetValue = function() return value end,
		SetValue = function(newValue)
			value = math.clamp(newValue, minValue, maxValue)
			valueLabel.Text = tostring(value)
			local relativeX = (value - minValue) / (maxValue - minValue)
			fill.Size = UDim2.new(relativeX, 0, 1, 0)
			knob.Position = UDim2.new(relativeX, -10, 0.5, -10)
		end
	}
end

-- Dropdown component
function AcrylicUI.CreateDropdown(parent, text, position, options, multiSelect)
	local dropdownFrame = Instance.new("Frame")
	dropdownFrame.Name = "Dropdown"
	dropdownFrame.BackgroundTransparency = 1
	dropdownFrame.Size = UDim2.new(0, 200, 0, 30)
	dropdownFrame.Position = position or UDim2.new(0, 0, 0, 0)
	dropdownFrame.ClipsDescendants = true
	dropdownFrame.Parent = parent
	
	local mainButton = Instance.new("TextButton")
	mainButton.Name = "MainButton"
	mainButton.Text = text
	mainButton.Font = Enum.Font.GothamSemibold
	mainButton.TextColor3 = DEFAULT_SETTINGS.TextColor
	mainButton.TextSize = 14
	mainButton.TextXAlignment = Enum.TextXAlignment.Left
	mainButton.BackgroundColor3 = DEFAULT_SETTINGS.SecondaryColor
	mainButton.BackgroundTransparency = 0.3
	mainButton.Size = UDim2.new(1, 0, 0, 30)
	mainButton.Position = UDim2.new(0, 0, 0, 0)
	mainButton.Parent = dropdownFrame
	
	applyCorners(mainButton)
	createStroke(mainButton)
	
	-- Dropdown icon
	local icon = Instance.new("ImageLabel")
	icon.Name = "DropdownIcon"
	icon.Image = "rbxassetid://" .. tostring(ICONS.Dropdown)
	icon.BackgroundTransparency = 1
	icon.Size = UDim2.new(0, 20, 0, 20)
	icon.Position = UDim2.new(1, -25, 0.5, -10)
	icon.Parent = mainButton
	
	local optionsFrame = Instance.new("Frame")
	optionsFrame.Name = "Options"
	optionsFrame.BackgroundColor3 = DEFAULT_SETTINGS.SecondaryColor
	optionsFrame.BackgroundTransparency = 0.2
	optionsFrame.Size = UDim2.new(1, 0, 0, 0)
	optionsFrame.Position = UDim2.new(0, 0, 0, 35)
	optionsFrame.Visible = false
	optionsFrame.Parent = dropdownFrame
	
	applyCorners(optionsFrame)
	createStroke(optionsFrame)
	
	-- Add acrylic effect
	createAcrylicBlur(optionsFrame)
	
	local optionsLayout = Instance.new("UIListLayout")
	optionsLayout.Padding = UDim.new(0, 2)
	optionsLayout.Parent = optionsFrame
	
	local selectedOptions = {}
	local isOpen = false
	
	local function updateButtonText()
		if multiSelect then
			local selectedCount = 0
			for _, selected in pairs(selectedOptions) do
				if selected then selectedCount = selectedCount + 1 end
			end
			
			if selectedCount == 0 then
				mainButton.Text = text
			elseif selectedCount == 1 then
				for option, selected in pairs(selectedOptions) do
					if selected then
						mainButton.Text = option
						break
					end
				end
			else
				mainButton.Text = text .. " (" .. selectedCount .. " selected)"
			end
		end
	end
	
	-- Create option buttons
	for _, option in ipairs(options) do
		local optionButton = Instance.new("TextButton")
		optionButton.Name = option .. "Option"
		optionButton.Text = option
		optionButton.Font = Enum.Font.GothamSemibold
		optionButton.TextColor3 = DEFAULT_SETTINGS.TextColor
		optionButton.TextSize = 14
		optionButton.TextXAlignment = Enum.TextXAlignment.Left
		optionButton.BackgroundColor3 = DEFAULT_SETTINGS.BackgroundColor
		optionButton.BackgroundTransparency = 0.5
		optionButton.Size = UDim2.new(1, -10, 0, 30)
		optionButton.Position = UDim2.new(0, 5, 0, 0)
		optionButton.Parent = optionsFrame
		
		applyCorners(optionButton)
		
		-- Selection indicator for multi-select
		local indicator = Instance.new("Frame")
		indicator.Name = "SelectionIndicator"
		indicator.BackgroundColor3 = DEFAULT_SETTINGS.PrimaryColor
		indicator.BackgroundTransparency = 0.7
		indicator.Size = UDim2.new(1, 0, 1, 0)
		indicator.Position = UDim2.new(0, 0, 0, 0)
		indicator.Visible = false
		indicator.Parent = optionButton
		
		applyCorners(indicator)
		
		optionButton.MouseButton1Click:Connect(function()
			if multiSelect then
				selectedOptions[option] = not selectedOptions[option]
				indicator.Visible = selectedOptions[option]
				updateButtonText()
			else
				selectedOptions = {[option] = true}
				mainButton.Text = option
				-- Close dropdown
				isOpen = false
				optionsFrame.Visible = false
				dropdownFrame.Size = UDim2.new(0, 200, 0, 30)
				
				local tween = TweenService:Create(
					icon,
					TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{Rotation = 0}
				)
				tween:Play()
			end
		end)
	end
	
	-- Update options frame size
	optionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		optionsFrame.Size = UDim2.new(1, 0, 0, optionsLayout.AbsoluteContentSize.Y)
	end)
	
	mainButton.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		optionsFrame.Visible = isOpen
		
		if isOpen then
			dropdownFrame.Size = UDim2.new(0, 200, 0, 35 + optionsLayout.AbsoluteContentSize.Y)
			local tween = TweenService:Create(
				icon,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{Rotation = 180}
			)
			tween:Play()
		else
			dropdownFrame.Size = UDim2.new(0, 200, 0, 30)
			local tween = TweenService:Create(
				icon,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{Rotation = 0}
			)
			tween:Play()
		end
	end)
	
	return {
		Frame = dropdownFrame,
		GetSelected = function()
			if multiSelect then
				local selected = {}
				for option, isSelected in pairs(selectedOptions) do
					if isSelected then table.insert(selected, option) end
				end
				return selected
			else
				for option, isSelected in pairs(selectedOptions) do
					if isSelected then return option end
				end
				return nil
			end
		end,
		SetSelected = function(selection)
			if multiSelect then
				selectedOptions = {}
				for _, option in ipairs(selection) do
					selectedOptions[option] = true
				end
				
				-- Update indicators
				for _, child in ipairs(optionsFrame:GetChildren()) do
					if child:IsA("TextButton") then
						local indicator = child:FindFirstChild("SelectionIndicator")
						if indicator then
							indicator.Visible = selectedOptions[child.Text] or false
						end
					end
				end
				updateButtonText()
			else
				if selection and table.find(options, selection) then
					selectedOptions = {[selection] = true}
					mainButton.Text = selection
				end
			end
		end
	}
end

-- Notification bell with counter
function AcrylicUI.CreateNotificationBell(parent, position, notificationManager)
	local bellFrame = Instance.new("Frame")
	bellFrame.Name = "NotificationBell"
	bellFrame.BackgroundTransparency = 1
	bellFrame.Size = UDim2.new(0, 40, 0, 40)
	bellFrame.Position = position or UDim2.new(0, 0, 0, 0)
	bellFrame.Parent = parent
	
	local bellButton = Instance.new("TextButton")
	bellButton.Name = "BellButton"
	bellButton.Text = ""
	bellButton.BackgroundColor3 = DEFAULT_SETTINGS.SecondaryColor
	bellButton.BackgroundTransparency = 0.3
	bellButton.Size = UDim2.new(1, 0, 1, 0)
	bellButton.Position = UDim2.new(0, 0, 0, 0)
	bellButton.Parent = bellFrame
	
	applyCorners(bellButton)
	createStroke(bellButton)
	
	local bellIcon = Instance.new("ImageLabel")
	bellIcon.Name = "BellIcon"
	bellIcon.Image = "rbxassetid://" .. tostring(ICONS.Bell)
	bellIcon.BackgroundTransparency = 1
	bellIcon.Size = UDim2.new(0, 24, 0, 24)
	bellIcon.Position = UDim2.new(0.5, -12, 0.5, -12)
	bellIcon.Parent = bellButton
	
	local notificationCount = Instance.new("TextLabel")
	notificationCount.Name = "NotificationCount"
	notificationCount.Text = "0"
	notificationCount.Font = Enum.Font.GothamBold
	notificationCount.TextColor3 = Color3.fromRGB(255, 255, 255)
	notificationCount.TextSize = 12
	notificationCount.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
	notificationCount.BackgroundTransparency = 0
	notificationCount.Size = UDim2.new(0, 18, 0, 18)
	notificationCount.Position = UDim2.new(1, -9, 0, -5)
	notificationCount.Parent = bellButton
	notificationCount.Visible = false
	
	applyCorners(notificationCount)
	
	bellButton.MouseButton1Click:Connect(function()
		if notificationManager then
			notificationManager:ShowNotification(
				"Notifications",
				"You have " .. notificationCount.Text .. " new notifications",
				3,
				"Info"
			)
		end
	end)
	
	return {
		Frame = bellFrame,
		SetCount = function(count)
			if count > 0 then
				notificationCount.Text = tostring(count)
				notificationCount.Visible = true
			else
				notificationCount.Visible = false
			end
		end
	}
end

-- Create main window
function AcrylicUI.CreateWindow(title, size, position)
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "AcrylicUI"
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	
	local mainWindow = Instance.new("Frame")
	mainWindow.Name = "MainWindow"
	mainWindow.BackgroundColor3 = DEFAULT_SETTINGS.BackgroundColor
	mainWindow.BackgroundTransparency = 0.2
	mainWindow.Size = size or UDim2.new(0, 800, 0, 500)
	mainWindow.Position = position or UDim2.new(0.5, -400, 0.5, -250)
	mainWindow.AnchorPoint = Vector2.new(0.5, 0.5)
	mainWindow.Parent = screenGui
	
	applyCorners(mainWindow)
	createStroke(mainWindow)
	
	-- Add acrylic blur effect
	local blur = Instance.new("BlurEffect")
	blur.Name = "AcrylicBlur"
	blur.Size = DEFAULT_SETTINGS.BlurSize
	blur.Parent = mainWindow
	
	-- Title bar
	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.BackgroundColor3 = DEFAULT_SETTINGS.SecondaryColor
	titleBar.BackgroundTransparency = 0.3
	titleBar.Size = UDim2.new(1, 0, 0, 40)
	titleBar.Position = UDim2.new(0, 0, 0, 0)
	titleBar.Parent = mainWindow
	
	applyCorners(titleBar)
	
	local titleLabel = createTextLabel(titleBar, title, UDim2.new(0, 15, 0, 0), UDim2.new(0.5, 0, 1, 0))
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 16
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	
	-- Make window draggable
	local dragInput
	local dragStart
	local startPos
	
	local function update(input)
		local delta = input.Position - dragStart
		mainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	
	titleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragStart = input.Position
			startPos = mainWindow.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragInput = nil
				end
			end)
		end
	end)
	
	titleBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	
	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == dragInput then
			update(input)
		end
	end)
	
	-- Content area
	local contentArea = Instance.new("Frame")
	contentArea.Name = "ContentArea"
	contentArea.BackgroundTransparency = 1
	contentArea.Size = UDim2.new(1, 0, 1, -40)
	contentArea.Position = UDim2.new(0, 0, 0, 40)
	contentArea.Parent = mainWindow
	
	-- Create notification manager
	local notificationManager = NotificationManager.new(screenGui)
	
	return {
		ScreenGui = screenGui,
		MainWindow = mainWindow,
		ContentArea = contentArea,
		NotificationManager = notificationManager,
		TitleBar = titleBar
	}
end

-- Example usage function
function AcrylicUI.ShowExample()
	-- Create main window
	local window = AcrylicUI.CreateWindow("Acrylic UI Library", UDim2.new(0, 900, 0, 600))
	
	-- Create tab system
	local tabSystem = AcrylicUI.CreateTabSystem(
		window.ContentArea,
		{"Home", "Settings", "Profile", "Statistics", "Game"},
		{"Home", "Settings", "User", "Chart", "Game"}
	)
	
	-- Add components to tabs
	-- Home tab
	local homeTab = tabSystem.TabContents["Home"]
	
	-- Create buttons
	AcrylicUI.CreateButton(homeTab, "Primary Button", UDim2.new(0.05, 0, 0.05, 0), UDim2.new(0, 150, 0, 40))
	AcrylicUI.CreateButton(homeTab, "With Icon", UDim2.new(0.05, 0, 0.15, 0), UDim2.new(0, 150, 0, 40), true, "Home")
	
	-- Create toggles
	AcrylicUI.CreateToggle(homeTab, "Enable Feature", UDim2.new(0.05, 0, 0.3, 0), true)
	AcrylicUI.CreateToggle(homeTab, "Dark Mode", UDim2.new(0.05, 0, 0.4, 0), false)
	
	-- Create sliders
	AcrylicUI.CreateSlider(homeTab, "Volume", UDim2.new(0.05, 0, 0.55, 0), 0, 100, 75)
	AcrylicUI.CreateSlider(homeTab, "Brightness", UDim2.new(0.05, 0, 0.75, 0), 0, 100, 50)
	
	-- Settings tab
	local settingsTab = tabSystem.TabContents["Settings"]
	
	-- Create dropdowns
	local dropdown = AcrylicUI.CreateDropdown(
		settingsTab,
		"Select Quality",
		UDim2.new(0.05, 0, 0.1, 0),
		{"Low", "Medium", "High", "Ultra"},
		false
	)
	
	local multiDropdown = AcrylicUI.CreateDropdown(
		settingsTab,
		"Select Features",
		UDim2.new(0.05, 0, 0.25, 0),
		{"Shadows", "Reflections", "Anti-Aliasing", "Bloom", "Motion Blur"},
		true
	)
	
	-- Create notification bell
	local notificationBell = AcrylicUI.CreateNotificationBell(
		tabSystem.Sidebar,
		UDim2.new(0, 10, 0, 50),
		window.NotificationManager
	)
	
	-- Set notification count
	notificationBell.SetCount(3)
	
	-- Test notification button
	local testNotifyBtn = AcrylicUI.CreateButton(
		settingsTab,
		"Test Notification",
		UDim2.new(0.05, 0, 0.5, 0),
		UDim2.new(0, 180, 0, 40)
	)
	
	testNotifyBtn.MouseButton1Click:Connect(function()
		window.NotificationManager:ShowNotification(
			"Test Notification",
			"This is a test notification from the Acrylic UI Library!",
			5,
			"Success"
		)
	end)
	
	-- Close button functionality
	tabSystem.CloseButton.MouseButton1Click:Connect(function()
		window.ScreenGui:Destroy()
	end)
	
	-- Minimize button functionality
	local isMinimized = false
	local originalSize = window.MainWindow.Size
	local minimizedSize = UDim2.new(0, 200, 0, 40)
	
	tabSystem.MinimizeButton.MouseButton1Click:Connect(function()
		isMinimized = not isMinimized
		
		if isMinimized then
			-- Minimize to just title bar
			tabSystem.MainFrame.Visible = false
			window.MainWindow.Size = minimizedSize
		else
			-- Restore
			tabSystem.MainFrame.Visible = true
			window.MainWindow.Size = originalSize
		end
	end)
	
	return window
end

return AcrylicUI
