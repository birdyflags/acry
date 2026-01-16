--[[
    Modern Glass UI Library
    A premium, clean, and modern UI library for Roblox.
    
    Usage:
    local Library = loadstring(readfile("ModernLibrary.lua"))()
    local Window = Library:CreateWindow({ Name = "Hub Name" })
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local Library = {}

--// Utility Functions
local function Make(class, props, children)
    local inst = Instance.new(class)
    for i, v in pairs(props or {}) do
        inst[i] = v
    end
    for _, child in pairs(children or {}) do
        child.Parent = inst
    end
    return inst
end

local function Tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

--// Theme Configuration
local Theme = {
    Background = Color3.fromRGB(15, 15, 20),
    Sidebar = Color3.fromRGB(20, 20, 25),
    Content = Color3.fromRGB(22, 22, 28),
    Accent = Color3.fromRGB(0, 140, 255), -- Electric Blue default
    Text = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(150, 150, 160),
    Outline = Color3.fromRGB(40, 40, 50),
    Item = Color3.fromRGB(28, 28, 35)
}

--// Protected GUI Parent
local function GetParent()
    local success, gui = pcall(function() return CoreGui end)
    if success then return gui end
    return Players.LocalPlayer:WaitForChild("PlayerGui")
end

--// Main Library Function
function Library:CreateWindow(Settings)
    Settings = Settings or {}
    local Name = Settings.Name or "Modern Hub"
    local Accent = Settings.Accent or Theme.Accent

    -- UI Container
    local ScreenGui = Make("ScreenGui", {
        Name = Name .. "UI",
        Parent = GetParent(),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })

    -- Main Window Frame
    local Main = Make("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 650, 0, 420),
        Position = UDim2.new(0.5, -325, 0.5, -210),
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 0.1, -- Glass feel
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = ScreenGui
    }, {
        Make("UICorner", { CornerRadius = UDim.new(0, 10) }),
        Make("UIStroke", { Color = Theme.Outline, Thickness = 1.2 })
    })

    -- Dragging Logic
    local Dragging, DragInput, DragStart, StartPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)
    Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local delta = input.Position - DragStart
            Tween(Main, TweenInfo.new(0.05), {
                Position = UDim2.new( StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
            })
        end
    end)

    -- Sidebar
    local Sidebar = Make("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 70, 1, 0),
        BackgroundColor3 = Theme.Sidebar,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = Main
    }, {
        Make("UICorner", { CornerRadius = UDim.new(0, 10) }),
        Make("Frame", { -- Hider for right corner
            Size = UDim2.new(0, 10, 1, 0), Position = UDim2.new(1, -10, 0, 0),
            BackgroundColor3 = Theme.Sidebar, BackgroundTransparency = 1, BorderSizePixel = 0
        })
    })

    -- Title Container
    local Initial = Name:sub(1,1):upper() .. Name:sub(2,2):lower() -- First 2 letters
    local TitleLabel = Make("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, 0, 0, 60),
        Position = UDim2.new(0, 0, 0, 10),
        BackgroundTransparency = 1,
        Text = Initial,
        TextColor3 = Accent,
        TextSize = 26,
        Font = Enum.Font.GothamBold,
        Parent = Sidebar
    })

    local TitleFull = Make("TextLabel", {
        Name = "TitleFull",
        Size = UDim2.new(0, 200, 0, 40),
        Position = UDim2.new(0, 85, 0, 18),
        BackgroundTransparency = 1,
        Text = Name,
        TextColor3 = Theme.Text,
        TextSize = 22,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Main
    })

    -- Tab Container
    local TabContainer = Make("ScrollingFrame", {
        Name = "Tabs",
        Size = UDim2.new(1, 0, 1, -80),
        Position = UDim2.new(0, 0, 0, 80),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        Parent = Sidebar
    }, {
        Make("UIListLayout", {
            Padding = UDim.new(0, 12),
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder 
        })
    })

    -- Page Container
    local Pages = Make("Frame", {
        Name = "Pages",
        Size = UDim2.new(1, -90, 1, -70),
        Position = UDim2.new(0, 80, 0, 60),
        BackgroundTransparency = 1,
        Parent = Main
    })

    local WindowObj = { CurTab = nil }

    function WindowObj:Tab(TabName, IconId)
        local Tab = {}
        
        -- Tab Button
        local TabBtn = Make("TextButton", {
            Name = TabName,
            Size = UDim2.new(0, 45, 0, 45),
            BackgroundColor3 = Theme.Sidebar,
            BackgroundTransparency = 1,
            Text = "",
            Parent = TabContainer
        }, {
            Make("UICorner", { CornerRadius = UDim.new(0, 12) }),
            Make("ImageLabel", {
                Name = "Icon",
                Size = UDim2.new(0, 24, 0, 24),
                Position = UDim2.new(0.5, -12, 0.5, -12),
                BackgroundTransparency = 1,
                Image = IconId or "rbxassetid://7733960981", -- Default home icon
                ImageColor3 = Theme.TextDark
            })
        })

        -- Page Frame
        local Page = Make("ScrollingFrame", {
            Name = TabName,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Accent,
            Parent = Pages
        }, {
            Make("UIListLayout", {
                Padding = UDim.new(0, 10),
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                SortOrder = Enum.SortOrder.LayoutOrder 
            }),
            Make("UIPadding", {
                PaddingTop = UDim.new(0, 5), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)
            })
        })

        -- Tab Selection Logic
        TabBtn.MouseButton1Click:Connect(function()
            -- Deselect old
            if WindowObj.CurTab then
                Tween(WindowObj.CurTab.Btn, TweenInfo.new(0.3), { BackgroundTransparency = 1, BackgroundColor3 = Theme.Sidebar })
                Tween(WindowObj.CurTab.Btn.Icon, TweenInfo.new(0.3), { ImageColor3 = Theme.TextDark })
                WindowObj.CurTab.Page.Visible = false
            end
            
            -- Select new
            WindowObj.CurTab = { Btn = TabBtn, Page = Page }
            Tween(TabBtn, TweenInfo.new(0.3), { BackgroundTransparency = 0, BackgroundColor3 = Theme.Content })
            Tween(TabBtn.Icon, TweenInfo.new(0.3), { ImageColor3 = Accent })
            Page.Visible = true
            
            -- Anim page in
            Page.Position = UDim2.new(0, 0, 0, 10)
            Page.BackgroundTransparency = 1
            Tween(Page, TweenInfo.new(0.4, Enum.EasingStyle.Quint), { Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1 })
        end)
        
        -- Select first tab automatically
        if not WindowObj.CurTab then
            WindowObj.CurTab = { Btn = TabBtn, Page = Page }
            TabBtn.BackgroundTransparency = 0
            TabBtn.BackgroundColor3 = Theme.Content
            TabBtn.Icon.ImageColor3 = Accent
            Page.Visible = true
        end

        -- Components
        
        -- SECTION
        function Tab:Section(Text)
            local Section = Make("TextLabel", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                Text = Text,
                TextColor3 = Theme.TextDark,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Page
            }, {
                Make("UIPadding", { PaddingLeft = UDim.new(0, 5) })
            })
            return Section
        end

        -- BUTTON
        function Tab:Button(Text, Callback)
            Callback = Callback or function() end
            
            local BtnFrame = Make("TextButton", {
                Name = "Button",
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = Theme.Item,
                AutoButtonColor = false,
                Text = "",
                Parent = Page
            }, {
                Make("UICorner", { CornerRadius = UDim.new(0, 8) }),
                Make("UIStroke", { Color = Theme.Outline, Thickness = 1 }),
                Make("TextLabel", {
                    Name = "Title",
                    Text = Text,
                    Size = UDim2.new(1, -20, 1, 0),
                    Position = UDim2.new(0, 15, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = Theme.Text,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                }),
                Make("ImageLabel", { -- Arrow
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(1, -30, 0.5, -8),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://6035047886", -- Arrow right
                    ImageColor3 = Theme.TextDark
                })
            })

            BtnFrame.MouseButton1Click:Connect(function()
                -- Visual click effect
                local Ripple = Make("Frame", {
                    Size = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BackgroundColor3 = Color3.new(1,1,1),
                    BackgroundTransparency = 0.8,
                    Parent = BtnFrame
                }, { Make("UICorner", { CornerRadius = UDim.new(1, 0) }) })
                
                Tween(Ripple, TweenInfo.new(0.5), { Size = UDim2.new(1.5, 0, 1.5, 0), BackgroundTransparency = 1 })
                task.delay(0.5, function() Ripple:Destroy() end)
                
                Callback()
            end)

            BtnFrame.MouseEnter:Connect(function()
                Tween(BtnFrame, TweenInfo.new(0.3), { BackgroundColor3 = Color3.fromRGB(35, 35, 42) })
                Tween(BtnFrame.UIStroke, TweenInfo.new(0.3), { Color = Accent })
            end)
            
            BtnFrame.MouseLeave:Connect(function()
                Tween(BtnFrame, TweenInfo.new(0.3), { BackgroundColor3 = Theme.Item })
                Tween(BtnFrame.UIStroke, TweenInfo.new(0.3), { Color = Theme.Outline })
            end)
        end

        -- TOGGLE
        function Tab:Toggle(Text, Default, Callback)
            Default = Default or false
            Callback = Callback or function() end
            local State = Default

            local ToggleFrame = Make("TextButton", {
                Name = "Toggle",
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = Theme.Item,
                AutoButtonColor = false,
                Text = "",
                Parent = Page
            }, {
                Make("UICorner", { CornerRadius = UDim.new(0, 8) }),
                Make("UIStroke", { Color = Theme.Outline, Thickness = 1 }),
                Make("TextLabel", {
                    Text = Text,
                    Size = UDim2.new(1, -70, 1, 0),
                    Position = UDim2.new(0, 15, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = Theme.Text,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            })

            local SwitchInfo = Make("Frame", {
                Size = UDim2.new(0, 40, 0, 22),
                Position = UDim2.new(1, -55, 0.5, -11),
                BackgroundColor3 = State and Accent or Theme.Outline,
                Parent = ToggleFrame
            }, {
                Make("UICorner", { CornerRadius = UDim.new(1, 0) })
            })

            local Knob = Make("Frame", {
                Size = UDim2.new(0, 18, 0, 18),
                Position = State and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
                BackgroundColor3 = Theme.Text,
                Parent = SwitchInfo
            }, { Make("UICorner", { CornerRadius = UDim.new(1, 0) }) })

            local function Update()
                Callback(State)
                Tween(SwitchInfo, TweenInfo.new(0.3), { BackgroundColor3 = State and Accent or Theme.Outline })
                Tween(Knob, TweenInfo.new(0.3), { Position = State and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9) })
                Tween(ToggleFrame.UIStroke, TweenInfo.new(0.3), { Color = State and Accent or Theme.Outline })
            end
            
            -- Initial call
            Callback(State)

            ToggleFrame.MouseButton1Click:Connect(function()
                State = not State
                Update()
            end)
        end

        -- SLIDER
        function Tab:Slider(Text, Min, Max, Default, Callback)
            Default = Default or Min
            Callback = Callback or function() end
            
            local Value = Default
            local Dragging = false

            local SliderFrame = Make("Frame", {
                Name = "Slider",
                Size = UDim2.new(1, 0, 0, 60),
                BackgroundColor3 = Theme.Item,
                Parent = Page
            }, {
                Make("UICorner", { CornerRadius = UDim.new(0, 8) }),
                Make("UIStroke", { Color = Theme.Outline, Thickness = 1 }),
                Make("TextLabel", {
                    Text = Text,
                    Size = UDim2.new(1, -30, 0, 30),
                    Position = UDim2.new(0, 15, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = Theme.Text,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                }),
                Make("TextLabel", {
                    Name = "ValueLabel",
                    Text = tostring(Value),
                    Size = UDim2.new(0, 50, 0, 30),
                    Position = UDim2.new(1, -65, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = Theme.TextDark,
                    Font = Enum.Font.GothamBold,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
            })

            local Bar = Make("Frame", {
                Size = UDim2.new(1, -30, 0, 6),
                Position = UDim2.new(0, 15, 0, 40),
                BackgroundColor3 = Theme.Outline,
                Parent = SliderFrame
            }, { Make("UICorner", { CornerRadius = UDim.new(1, 0) }) })

            local Fill = Make("Frame", {
                Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0),
                BackgroundColor3 = Accent,
                Parent = Bar
            }, { Make("UICorner", { CornerRadius = UDim.new(1, 0) }) })
            
            local Knob = Make("Frame", {
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(1, -7, 0.5, -7),
                BackgroundColor3 = Theme.Text,
                Parent = Fill
            }, { Make("UICorner", { CornerRadius = UDim.new(1, 0) }) })

            local function Update(Input)
                local SizeX = math.clamp((Input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local NewValue = math.floor(Min + ((Max - Min) * SizeX))
                
                if NewValue ~= Value then
                    Value = NewValue
                    Tween(Fill, TweenInfo.new(0.05), { Size = UDim2.new(SizeX, 0, 1, 0) })
                    SliderFrame.ValueLabel.Text = tostring(Value)
                    Callback(Value)
                end
            end

            SliderFrame.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    Update(Input)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(Input)
                if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                    Update(Input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)
        end
        
        -- DROPDOWN (Simple)
        function Tab:Dropdown(Text, Options, Default, Callback)
            Options = Options or {}
            Default = Default or Options[1]
            Callback = Callback or function() end
            
            local Expanded = false
            local Selected = Default
            
            local DropdownFrame = Make("Frame", {
                Name = "Dropdown",
                Size = UDim2.new(1, 0, 0, 42), -- 42 closed
                BackgroundColor3 = Theme.Item,
                ClipsDescendants = true,
                Parent = Page
            }, {
                Make("UICorner", { CornerRadius = UDim.new(0, 8) }),
                Make("UIStroke", { Color = Theme.Outline, Thickness = 1 })
            })
            
            local HeaderBtn = Make("TextButton", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundTransparency = 1,
                Text = "",
                Parent = DropdownFrame
            })
            
            Make("TextLabel", {
                Text = Text,
                Size = UDim2.new(1, -120, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                TextColor3 = Theme.Text,
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = HeaderBtn
            })
            
            local Status = Make("TextLabel", {
                Text = tostring(Selected),
                Size = UDim2.new(0, 100, 1, 0),
                Position = UDim2.new(1, -45, 0, 0),
                BackgroundTransparency = 1,
                TextColor3 = Accent,
                Font = Enum.Font.GothamBold,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Right,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = HeaderBtn
            })
            
            local Icon = Make("ImageLabel", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -30, 0.5, -10),
                BackgroundTransparency = 1,
                Image = "rbxassetid://6031091004", -- Arrow down
                ImageColor3 = Theme.TextDark,
                Parent = HeaderBtn
            })
            
            local Container = Make("Frame", {
               Size = UDim2.new(1, 0, 0, 0),
               Position = UDim2.new(0, 0, 0, 42),
               BackgroundTransparency = 1,
               Parent = DropdownFrame 
            }, {
                Make("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder })
            })
            
            local function Refresh()
                for _, c in pairs(Container:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                
                for _, opt in pairs(Options) do
                    local Item = Make("TextButton", {
                        Size = UDim2.new(1, 0, 0, 30),
                        BackgroundColor3 = Theme.Item,
                        Text = "  " .. tostring(opt),
                        TextColor3 = (opt == Selected) and Accent or Theme.TextDark,
                        Font = Enum.Font.GothamMedium,
                        TextSize = 14,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = Container
                    })
                    
                    Item.MouseButton1Click:Connect(function()
                        Selected = opt
                        Status.Text = tostring(Selected)
                        Callback(Selected)
                        Expanded = false
                        Tween(DropdownFrame, TweenInfo.new(0.3), { Size = UDim2.new(1, 0, 0, 42) })
                        Tween(Icon, TweenInfo.new(0.3), { Rotation = 0 })
                    end)
                end
            end
            
            HeaderBtn.MouseButton1Click:Connect(function()
                Expanded = not Expanded
                if Expanded then
                    Refresh()
                    local ContentSize = (#Options * 30) + 42
                    Tween(DropdownFrame, TweenInfo.new(0.3), { Size = UDim2.new(1, 0, 0, ContentSize) })
                    Tween(Icon, TweenInfo.new(0.3), { Rotation = 180 })
                else
                    Tween(DropdownFrame, TweenInfo.new(0.3), { Size = UDim2.new(1, 0, 0, 42) })
                    Tween(Icon, TweenInfo.new(0.3), { Rotation = 0 })
                end
            end)
        end

        return Tab
    end

    -- Init Animation
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.BackgroundTransparency = 1
    Tween(Main, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 650, 0, 420),
        BackgroundTransparency = 0.1
    })

    return WindowObj
end

return Library
