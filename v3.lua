local PainUI = {}
PainUI.__index = PainUI
PainUI.Version = "v3"

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
if not Player then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    Player = Players.LocalPlayer
end

local function getSafeGuiParent()
    if gethui then
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
    end
    local ok, coreGui = pcall(function()
        return game:GetService("CoreGui")
    end)
    if ok and coreGui then
        local canAccess, _ = pcall(function() return coreGui.Name end)
        if canAccess then
            local test = Instance.new("Folder")
            local parentOk, _ = pcall(function() test.Parent = coreGui end)
            pcall(function() test:Destroy() end)
            if parentOk then
                return coreGui
            end
        end
    end
    return Player:WaitForChild("PlayerGui")
end

local Theme = {
    Background = Color3.fromRGB(12, 12, 12),
    Sidebar = Color3.fromRGB(15, 15, 15),
    SidebarActive = Color3.fromRGB(30, 30, 30),
    Card = Color3.fromRGB(20, 20, 20),
    CardHeader = Color3.fromRGB(22, 22, 22),
    CardBorder = Color3.fromRGB(34, 34, 34),
    Accent = Color3.fromRGB(245, 125, 30),
    AccentDark = Color3.fromRGB(195, 95, 18),
    AccentGlow = Color3.fromRGB(255, 155, 45),
    Text = Color3.fromRGB(220, 220, 220),
    TextDim = Color3.fromRGB(135, 135, 135),
    TextDark = Color3.fromRGB(80, 80, 80),
    ToggleOff = Color3.fromRGB(48, 48, 48),
    ToggleKnob = Color3.fromRGB(255, 255, 255),
    SliderTrack = Color3.fromRGB(45, 45, 45),
    SliderFill = Color3.fromRGB(245, 125, 30),
    DropdownBg = Color3.fromRGB(26, 26, 26),
    BottomDock = Color3.fromRGB(18, 18, 18),
    Separator = Color3.fromRGB(34, 34, 34),
    InputBg = Color3.fromRGB(26, 26, 26),
    Success = Color3.fromRGB(46, 204, 113),
    Warning = Color3.fromRGB(241, 196, 15),
    Error = Color3.fromRGB(231, 76, 60),
    Info = Color3.fromRGB(52, 152, 219),
}

local IconMap = {
    aimbot = "rbxassetid://10709818534",
    crosshair = "rbxassetid://10709818534",
    target = "rbxassetid://10734977012",
    fov = "rbxassetid://10734977012",
    visuals = "rbxassetid://10723346959",
    eye = "rbxassetid://10723346959",
    chams = "rbxassetid://10723346959",
    movement = "rbxassetid://10709790202",
    walk = "rbxassetid://10709790202",
    player = "rbxassetid://10747373176",
    players = "rbxassetid://10747373176",
    users = "rbxassetid://10747373176",
    team = "rbxassetid://10747373176",
    scripts = "rbxassetid://10709810463",
    code = "rbxassetid://10709810463",
    configs = "rbxassetid://10723387563",
    folder = "rbxassetid://10723387563",
    misc = "rbxassetid://10709810948",
    zap = "rbxassetid://10709810948",
    settings = "rbxassetid://10734950309",
    gear = "rbxassetid://10734950309",
    prediction = "rbxassetid://10709790202",
    wave = "rbxassetid://10709790202",
    search = "rbxassetid://10734883986",
    down = "rbxassetid://10709790948",
    check = "rbxassetid://10709790644",
    warning = "rbxassetid://10709790537",
    close = "rbxassetid://10709790429",
    info = "rbxassetid://10723346959"
}

local function GetIconAsset(icon)
    if not icon or icon == '' then return '' end
    if string.sub(icon, 1, 13) == 'rbxassetid://' then
        return icon
    end
    local lower = string.lower(icon)
    if IconMap[lower] then
        return IconMap[lower]
    end
    return ''
end

local AnimConfig = {
    Fast = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Medium = TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Slow = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    Spring = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    Smooth = TweenInfo.new(0.22, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
}

local function Tween(obj, info, props)
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

local function CreateInstance(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    for _, child in ipairs(children or {}) do
        child.Parent = inst
    end
    return inst
end

local function AddCorner(parent, radius)
    return CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
        Parent = parent
    })
end

local function AddStroke(parent, color, thickness, transparency)
    return CreateInstance("UIStroke", {
        Color = color or Theme.CardBorder,
        Thickness = thickness or 1,
        Transparency = transparency or 0.6,
        Parent = parent
    })
end

local function AddPadding(parent, t, b, l, r)
    return CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, t or 8),
        PaddingBottom = UDim.new(0, b or 8),
        PaddingLeft = UDim.new(0, l or 10),
        PaddingRight = UDim.new(0, r or 10),
        Parent = parent
    })
end

local function Ripple(button)
    local ripple = CreateInstance("Frame", {
        Name = "Ripple",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.85,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 0, 0),
        Parent = button
    })
    AddCorner(ripple, 999)

    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    Tween(ripple, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1
    }).Completed:Connect(function()
        ripple:Destroy()
    end)
end

local GlobalNotifContainer = nil

local function EnsureGlobalNotif(guiParent)
    if GlobalNotifContainer and GlobalNotifContainer.Parent then
        return GlobalNotifContainer
    end

    local notifGui = guiParent:FindFirstChild("PainUI_Notifications")
    if not notifGui then
        notifGui = CreateInstance("ScreenGui", {
            Name = "PainUI_Notifications",
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            IgnoreGuiInset = true,
            Parent = guiParent
        })
    end

    GlobalNotifContainer = CreateInstance("Frame", {
        Name = "NotificationContainer",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 270, 1, -20),
        Position = UDim2.new(1, -280, 0, 10),
        Parent = notifGui
    })

    CreateInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = GlobalNotifContainer
    })

    return GlobalNotifContainer
end

function PainUI:Notify(configOrTitle, message, duration, notifType)
    local title = "Notification"
    local dur = 3
    local nType = "Info"

    if type(configOrTitle) == "table" then
        title = configOrTitle.Title or title
        message = configOrTitle.Message or configOrTitle.Content or ""
        dur = configOrTitle.Duration or dur
        nType = configOrTitle.Type or nType
    else
        title = configOrTitle or title
        message = message or ""
        dur = duration or dur
        nType = notifType or nType
    end

    local container = EnsureGlobalNotif(getSafeGuiParent())

    local typeColor = Theme.Accent
    local iconAsset = IconMap.info
    if nType == "Success" then
        typeColor = Theme.Success
        iconAsset = IconMap.check
    elseif nType == "Warning" then
        typeColor = Theme.Warning
        iconAsset = IconMap.warning
    elseif nType == "Error" then
        typeColor = Theme.Error
        iconAsset = IconMap.close
    end

    local Notif = CreateInstance("Frame", {
        Name = "Notif",
        BackgroundColor3 = Theme.Card,
        Size = UDim2.new(1, 0, 0, 60),
        ClipsDescendants = true,
        Parent = container
    })
    AddCorner(Notif, 8)
    AddStroke(Notif, typeColor, 1, 0.4)

    CreateInstance("Frame", {
        Name = "AccentBar",
        BackgroundColor3 = typeColor,
        Size = UDim2.new(0, 4, 1, 0),
        BorderSizePixel = 0,
        Parent = Notif
    })

    CreateInstance("ImageLabel", {
        Name = "Icon",
        Image = iconAsset,
        ImageColor3 = typeColor,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 14, 0, 10),
        Parent = Notif
    })

    CreateInstance("TextLabel", {
        Name = "Title",
        Text = title,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -40, 0, 20),
        Position = UDim2.new(0, 36, 0, 8),
        Parent = Notif
    })

    CreateInstance("TextLabel", {
        Name = "Message",
        Text = message,
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextColor3 = Theme.TextDim,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -24, 0, 24),
        Position = UDim2.new(0, 14, 0, 28),
        Parent = Notif
    })

    Notif.Position = UDim2.new(1, 60, 0, 0)
    Tween(Notif, AnimConfig.Bounce, {Position = UDim2.new(0, 0, 0, 0)})

    task.delay(dur, function()
        if Notif and Notif.Parent then
            local t = Tween(Notif, AnimConfig.Medium, {
                Position = UDim2.new(1, 60, 0, 0),
                BackgroundTransparency = 1
            })
            t.Completed:Connect(function()
                Notif:Destroy()
            end)
        end
    end)
end

function PainUI:CreateWindow(options)
    local config = {}
    if type(options) == "string" then
        config.Title = options
    elseif type(options) == "table" then
        config = options
    end

    local titleText = config.Title or "pain v3"
    local subTitleText = config.SubTitle or ""
    local toggleKey = config.ToggleKey or Enum.KeyCode.RightControl
    local windowSize = config.Size or UDim2.new(0, 780, 0, 520)
    local guiParent = config.Parent or getSafeGuiParent()

    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil
    Window.Visible = true
    Window.Connections = {}
    Window.AllElements = {}
    Window.SearchIndex = {}

    local existingGui = guiParent:FindFirstChild("PainUI")
    if existingGui then
        existingGui:Destroy()
    end

    local ScreenGui = CreateInstance("ScreenGui", {
        Name = "PainUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        Parent = guiParent
    })

    local MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = Theme.Background,
        Size = windowSize,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = false,
        Parent = ScreenGui
    })
    AddCorner(MainFrame, 12)
    AddStroke(MainFrame, Theme.CardBorder, 1, 0.5)

    MainFrame.Size = UDim2.new(0, windowSize.X.Offset, 0, 0)
    MainFrame.BackgroundTransparency = 1
    task.defer(function()
        Tween(MainFrame, AnimConfig.Bounce, {
            Size = windowSize,
            BackgroundTransparency = 0
        })
    end)

    local TopBar = CreateInstance("Frame", {
        Name = "TopBar",
        BackgroundColor3 = Theme.Background,
        Size = UDim2.new(1, 0, 0, 48),
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    AddCorner(TopBar, 12)

    CreateInstance("Frame", {
        Name = "TopBarFix",
        BackgroundColor3 = Theme.Background,
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        BorderSizePixel = 0,
        Parent = TopBar
    })

    local TitleContainer = CreateInstance("Frame", {
        Name = "TitleContainer",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 320, 1, 0),
        Position = UDim2.new(0, 18, 0, 0),
        Parent = TopBar
    })

    CreateInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = TitleContainer
    })

    CreateInstance("TextLabel", {
        Name = "Title",
        Text = titleText,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        LayoutOrder = 1,
        Parent = TitleContainer
    })

    if subTitleText ~= "" then
        CreateInstance("TextLabel", {
            Name = "SubTitle",
            Text = subTitleText,
            Font = Enum.Font.GothamMedium,
            TextSize = 11,
            TextColor3 = Theme.Accent,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            LayoutOrder = 2,
            Parent = TitleContainer
        })
    end

    local SearchBox = CreateInstance("TextBox", {
        Name = "SearchBox",
        PlaceholderText = "Search features...",
        PlaceholderColor3 = Theme.TextDark,
        Text = "",
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextColor3 = Theme.Text,
        BackgroundColor3 = Theme.Card,
        Size = UDim2.new(0, 0, 0, 30),
        Position = UDim2.new(1, -56, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        ClipsDescendants = true,
        Visible = false,
        Parent = TopBar
    })
    AddCorner(SearchBox, 8)
    AddStroke(SearchBox, Theme.CardBorder, 1)
    AddPadding(SearchBox, 0, 0, 10, 10)

    local SearchBtn = CreateInstance("TextButton", {
        Name = "Search",
        Text = "",
        BackgroundColor3 = Theme.Card,
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(1, -16, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        AutoButtonColor = false,
        Parent = TopBar
    })
    AddCorner(SearchBtn, 8)
    AddStroke(SearchBtn, Theme.CardBorder, 1)

    local SearchIcon = CreateInstance("ImageLabel", {
        Name = "Icon",
        Image = IconMap.search,
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 15, 0, 15),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Active = false,
        Parent = SearchBtn
    })

    local SearchDropdown = CreateInstance("ScrollingFrame", {
        Name = "SearchDropdown",
        BackgroundColor3 = Theme.Card,
        Size = UDim2.new(0, 240, 0, 0),
        Position = UDim2.new(1, -16, 0, 46),
        AnchorPoint = Vector2.new(1, 0),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent,
        ScrollBarImageTransparency = 0.5,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 500,
        Parent = MainFrame
    })
    AddCorner(SearchDropdown, 8)
    AddStroke(SearchDropdown, Theme.CardBorder, 1)

    local SearchDropLayout = CreateInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = SearchDropdown
    })
    AddPadding(SearchDropdown, 6, 6, 6, 6)

    local function updateSearchResults()
        local query = SearchBox.Text:lower()
        for _, child in ipairs(SearchDropdown:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end

        if query == "" then
            SearchDropdown.Visible = false
            Tween(SearchDropdown, AnimConfig.Fast, {Size = UDim2.new(0, 240, 0, 0)})
            return
        end

        local matches = {}
        for _, item in ipairs(Window.SearchIndex) do
            if string.find(item.Name:lower(), query) then
                table.insert(matches, item)
            end
        end

        if #matches == 0 then
            SearchDropdown.Visible = true
            local EmptyLabel = CreateInstance("TextLabel", {
                Name = "Empty",
                Text = "No results found",
                Font = Enum.Font.GothamMedium,
                TextSize = 11,
                TextColor3 = Theme.TextDark,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 28),
                ZIndex = 501,
                Parent = SearchDropdown
            })
            Tween(SearchDropdown, AnimConfig.Fast, {Size = UDim2.new(0, 240, 0, 40)})
            return
        end

        SearchDropdown.Visible = true
        local totalH = math.min(#matches * 32 + 12, 190)
        Tween(SearchDropdown, AnimConfig.Fast, {Size = UDim2.new(0, 240, 0, totalH)})

        for i, item in ipairs(matches) do
            local ItemBtn = CreateInstance("TextButton", {
                Name = "Result_" .. i,
                BackgroundColor3 = Theme.InputBg,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 26),
                AutoButtonColor = false,
                Text = "",
                ZIndex = 501,
                LayoutOrder = i,
                Parent = SearchDropdown
            })
            AddCorner(ItemBtn, 6)

            local NameLabel = CreateInstance("TextLabel", {
                Name = "Name",
                Text = item.Name,
                Font = Enum.Font.GothamMedium,
                TextSize = 11,
                TextColor3 = Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -70, 1, 0),
                Position = UDim2.new(0, 8, 0, 0),
                Active = false,
                ZIndex = 502,
                Parent = ItemBtn
            })

            local PathLabel = CreateInstance("TextLabel", {
                Name = "Path",
                Text = (item.Page and item.Page.Name) or (item.Tab and item.Tab.Name) or "",
                Font = Enum.Font.GothamBold,
                TextSize = 9,
                TextColor3 = Theme.Accent,
                TextXAlignment = Enum.TextXAlignment.Right,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 60, 1, 0),
                Position = UDim2.new(1, -8, 0, 0),
                AnchorPoint = Vector2.new(1, 0),
                Active = false,
                ZIndex = 502,
                Parent = ItemBtn
            })

            ItemBtn.MouseEnter:Connect(function()
                Tween(ItemBtn, AnimConfig.Fast, {BackgroundTransparency = 0.5, BackgroundColor3 = Theme.SidebarActive})
            end)
            ItemBtn.MouseLeave:Connect(function()
                Tween(ItemBtn, AnimConfig.Fast, {BackgroundTransparency = 1})
            end)

            ItemBtn.MouseButton1Click:Connect(function()
                if item.Tab and item.Tab.Select then
                    item.Tab.Select()
                end
                if item.Page and item.Page.Select then
                    item.Page.Select()
                end

                if item.Row then
                    task.defer(function()
                        Tween(item.Row, AnimConfig.Fast, {BackgroundTransparency = 0.6, BackgroundColor3 = Theme.AccentDark}).Completed:Connect(function()
                            task.delay(0.4, function()
                                Tween(item.Row, AnimConfig.Medium, {BackgroundTransparency = 1})
                            end)
                        end)
                    end)
                end

                SearchBox.Text = ""
                SearchDropdown.Visible = false
                Tween(SearchDropdown, AnimConfig.Fast, {Size = UDim2.new(0, 240, 0, 0)})
            end)
        end
    end

    local searchOpen = false
    SearchBtn.MouseButton1Click:Connect(function()
        searchOpen = not searchOpen
        if searchOpen then
            SearchBox.Visible = true
            Tween(SearchBox, AnimConfig.Fast, {Size = UDim2.new(0, 160, 0, 30)})
            SearchBox:CaptureFocus()
            Tween(SearchIcon, AnimConfig.Fast, {ImageColor3 = Theme.Accent})
        else
            SearchBox.Text = ""
            Tween(SearchBox, AnimConfig.Fast, {Size = UDim2.new(0, 0, 0, 30)}).Completed:Connect(function()
                if not searchOpen then SearchBox.Visible = false end
            end)
            Tween(SearchIcon, AnimConfig.Fast, {ImageColor3 = Color3.fromRGB(255, 255, 255)})
            SearchDropdown.Visible = false
            Tween(SearchDropdown, AnimConfig.Fast, {Size = UDim2.new(0, 240, 0, 0)})
        end
    end)

    SearchBox:GetPropertyChangedSignal("Text"):Connect(updateSearchResults)

    SearchBtn.MouseEnter:Connect(function()
        Tween(SearchBtn, AnimConfig.Fast, {BackgroundColor3 = Theme.SidebarActive})
    end)
    SearchBtn.MouseLeave:Connect(function()
        Tween(SearchBtn, AnimConfig.Fast, {BackgroundColor3 = Theme.Card})
    end)

    local Sidebar = CreateInstance("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = Theme.Sidebar,
        Size = UDim2.new(0, 52, 1, -48),
        Position = UDim2.new(0, 0, 0, 48),
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = MainFrame
    })
    AddCorner(Sidebar, 12)

    CreateInstance("Frame", {
        Name = "SidebarTopFix",
        BackgroundColor3 = Theme.Sidebar,
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = Sidebar
    })

    CreateInstance("Frame", {
        Name = "SidebarRightFix",
        BackgroundColor3 = Theme.Sidebar,
        Size = UDim2.new(0, 14, 1, -14),
        Position = UDim2.new(1, -14, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = Sidebar
    })

    local SidebarIndicator = CreateInstance("Frame", {
        Name = "Indicator",
        BackgroundColor3 = Theme.Accent,
        Size = UDim2.new(0, 36, 0, 36),
        Position = UDim2.new(0.5, 0, 0, 8),
        AnchorPoint = Vector2.new(0.5, 0),
        ZIndex = 2,
        Parent = Sidebar
    })
    AddCorner(SidebarIndicator, 18)

    local SidebarButtonsHolder = CreateInstance("Frame", {
        Name = "Buttons",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -56),
        Position = UDim2.new(0, 0, 0, 8),
        ZIndex = 3,
        Parent = Sidebar
    })

    CreateInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = SidebarButtonsHolder
    })

    local AvatarContainer = CreateInstance("Frame", {
        Name = "AvatarContainer",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 34, 0, 34),
        Position = UDim2.new(0.5, 0, 1, -12),
        AnchorPoint = Vector2.new(0.5, 1),
        ZIndex = 3,
        Parent = Sidebar
    })

    local AvatarImage = CreateInstance("ImageLabel", {
        Name = "Avatar",
        BackgroundColor3 = Theme.Card,
        BackgroundTransparency = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = AvatarContainer
    })
    AddCorner(AvatarImage, 17)
    AddStroke(AvatarImage, Theme.CardBorder, 1)

    task.spawn(function()
        pcall(function()
            local thumb = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
            if thumb and AvatarImage and AvatarImage.Parent then
                AvatarImage.Image = thumb
            end
        end)
    end)

    local ContentArea = CreateInstance("Frame", {
        Name = "ContentArea",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -52, 1, -88),
        Position = UDim2.new(0, 52, 0, 48),
        ClipsDescendants = true,
        Parent = MainFrame
    })

    local BottomDock = CreateInstance("Frame", {
        Name = "BottomDock",
        BackgroundColor3 = Theme.BottomDock,
        Size = UDim2.new(0, 0, 0, 34),
        Position = UDim2.new(0.5, 26, 1, -10),
        AnchorPoint = Vector2.new(0.5, 1),
        AutomaticSize = Enum.AutomaticSize.X,
        Parent = MainFrame
    })
    AddCorner(BottomDock, 17)
    AddStroke(BottomDock, Theme.CardBorder, 1)
    AddPadding(BottomDock, 3, 3, 5, 5)

    CreateInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = BottomDock
    })

    local dragging = false
    local dragStart, startPos

    local dragConn1 = TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    table.insert(Window.Connections, dragConn1)

    local dragConn2 = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    table.insert(Window.Connections, dragConn2)

    local dragConn3 = UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    table.insert(Window.Connections, dragConn3)

    function Window:Toggle(state)
        if state ~= nil then
            Window.Visible = state
        else
            Window.Visible = not Window.Visible
        end

        if Window.Visible then
            MainFrame.Visible = true
            Tween(MainFrame, AnimConfig.Bounce, {
                Size = windowSize,
                BackgroundTransparency = 0
            })
        else
            local t = Tween(MainFrame, AnimConfig.Medium, {
                Size = UDim2.new(0, windowSize.X.Offset, 0, 0),
                BackgroundTransparency = 1
            })
            t.Completed:Connect(function()
                if not Window.Visible then
                    MainFrame.Visible = false
                end
            end)
        end
    end

    local toggleConn = UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == toggleKey then
            Window:Toggle()
        end
    end)
    table.insert(Window.Connections, toggleConn)

    local totalTabs = 0
    local sidebarTabs = {}

    function Window:CreateTab(tabName, tabIcon)
        totalTabs = totalTabs + 1
        local myTabIndex = totalTabs
        local Tab = {}
        Tab.Name = tabName:lower()
        Tab.Pages = {}
        Tab.ActivePage = nil
        Tab.LayoutOrder = myTabIndex

        local iconAsset = GetIconAsset(tabIcon or tabName)

        local SidebarBtn = CreateInstance("TextButton", {
            Name = "Tab_" .. tabName,
            Text = "",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 36, 0, 36),
            LayoutOrder = myTabIndex,
            ZIndex = 3,
            AutoButtonColor = false,
            Parent = SidebarButtonsHolder
        })
        AddCorner(SidebarBtn, 18)

        local SidebarIcon = CreateInstance("ImageLabel", {
            Name = "Icon",
            Image = iconAsset,
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ZIndex = 4,
            Active = false,
            Parent = SidebarBtn
        })

        local function refreshDock()
            for _, child in ipairs(BottomDock:GetChildren()) do
                if child:IsA("TextButton") then
                    child.Visible = false
                end
            end

            for _, p in ipairs(Tab.Pages) do
                if p.DockPill then
                    p.DockPill.Visible = true
                    if p == Tab.ActivePage then
                        p.DockLabel.Visible = true
                        p.DockPill.AutomaticSize = Enum.AutomaticSize.X
                        Tween(p.DockPill, AnimConfig.Fast, {Size = UDim2.new(0, 0, 0, 28), BackgroundTransparency = 0.85, BackgroundColor3 = Theme.AccentDark})
                        Tween(p.DockStroke, AnimConfig.Fast, {Transparency = 0.3})
                        Tween(p.DockIcon, AnimConfig.Fast, {ImageColor3 = Theme.Accent})
                    else
                        p.DockLabel.Visible = false
                        p.DockPill.AutomaticSize = Enum.AutomaticSize.None
                        Tween(p.DockPill, AnimConfig.Fast, {Size = UDim2.new(0, 28, 0, 28), BackgroundTransparency = 1})
                        Tween(p.DockStroke, AnimConfig.Fast, {Transparency = 1})
                        Tween(p.DockIcon, AnimConfig.Fast, {ImageColor3 = Color3.fromRGB(255, 255, 255)})
                    end
                end
            end
        end

        local function selectTab()
            for _, item in ipairs(sidebarTabs) do
                for _, page in ipairs(item.Tab.Pages) do
                    if page.PageFrame then page.PageFrame.Visible = false end
                end
            end

            local targetY = (myTabIndex - 1) * 42
            Tween(SidebarIndicator, AnimConfig.Bounce, {
                Position = UDim2.new(0.5, 0, 0, 8 + targetY)
            })

            Window.ActiveTab = Tab

            if Tab.ActivePage and Tab.ActivePage.PageFrame then
                Tab.ActivePage.PageFrame.Visible = true
            elseif #Tab.Pages > 0 then
                Tab.Pages[1].Select()
            end

            refreshDock()
        end

        Tab.Select = selectTab
        SidebarBtn.MouseButton1Click:Connect(selectTab)
        table.insert(sidebarTabs, {Btn = SidebarBtn, Icon = SidebarIcon, Tab = Tab, Order = myTabIndex})

        function Tab:CreatePage(pageName, pageIcon)
            local pageIndex = #Tab.Pages + 1
            local Page = {}
            Page.Name = pageName:lower()
            Page.Sections = {}
            Page.Order = pageIndex
            Page.Tab = Tab

            local pIconAsset = GetIconAsset(pageIcon or pageName)

            local PageFrame = CreateInstance("ScrollingFrame", {
                Name = "Page_" .. tabName .. "_" .. pageName,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollBarThickness = 3,
                ScrollBarImageColor3 = Theme.Accent,
                ScrollBarImageTransparency = 0.5,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                Visible = false,
                ClipsDescendants = true,
                Parent = ContentArea
            })
            AddPadding(PageFrame, 6, 8, 0, 0)

            local ColumnsContainer = CreateInstance("Frame", {
                Name = "Columns",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -28, 0, 0),
                Position = UDim2.new(0, 14, 0, 6),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = PageFrame
            })

            local LeftColumn = CreateInstance("Frame", {
                Name = "Left",
                BackgroundTransparency = 1,
                Size = UDim2.new(0.5, -8, 0, 0),
                Position = UDim2.new(0, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = ColumnsContainer
            })

            CreateInstance("UIListLayout", {
                FillDirection = Enum.FillDirection.Vertical,
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = LeftColumn
            })

            local RightColumn = CreateInstance("Frame", {
                Name = "Right",
                BackgroundTransparency = 1,
                Size = UDim2.new(0.5, -8, 0, 0),
                Position = UDim2.new(0.5, 8, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = ColumnsContainer
            })

            CreateInstance("UIListLayout", {
                FillDirection = Enum.FillDirection.Vertical,
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = RightColumn
            })

            local DockPill = CreateInstance("TextButton", {
                Name = "Dock_" .. tabName .. "_" .. pageName,
                BackgroundColor3 = Theme.BottomDock,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 28, 0, 28),
                AutomaticSize = Enum.AutomaticSize.None,
                LayoutOrder = pageIndex,
                AutoButtonColor = false,
                Text = "",
                Visible = false,
                Parent = BottomDock
            })
            AddCorner(DockPill, 14)
            local DockStroke = AddStroke(DockPill, Theme.Accent, 1, 1)

            CreateInstance("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0, 5),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = DockPill
            })
            AddPadding(DockPill, 0, 0, 7, 7)

            local DockIcon = CreateInstance("ImageLabel", {
                Name = "Icon",
                Image = pIconAsset,
                ImageColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 15, 0, 15),
                Active = false,
                LayoutOrder = 1,
                Parent = DockPill
            })

            local DockLabel = CreateInstance("TextLabel", {
                Name = "Label",
                Text = pageName:lower(),
                Font = Enum.Font.GothamBold,
                TextSize = 11,
                TextColor3 = Theme.Accent,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 0, 0, 16),
                AutomaticSize = Enum.AutomaticSize.X,
                Visible = false,
                Active = false,
                LayoutOrder = 2,
                Parent = DockPill
            })

            Page.PageFrame = PageFrame
            Page.DockPill = DockPill
            Page.DockStroke = DockStroke
            Page.DockIcon = DockIcon
            Page.DockLabel = DockLabel

            function Page.Select()
                for _, otherPage in ipairs(Tab.Pages) do
                    if otherPage.PageFrame then
                        otherPage.PageFrame.Visible = false
                    end
                end

                PageFrame.Visible = true
                Tab.ActivePage = Page

                refreshDock()

                for _, sec in ipairs(Page.Sections) do
                    if sec.Frame then
                        sec.Frame.BackgroundTransparency = 1
                        sec.Frame.Position = sec.Frame.Position + UDim2.new(0, 0, 0, 10)
                        task.delay(sec.AnimDelay or 0, function()
                            if sec.Frame then
                                Tween(sec.Frame, AnimConfig.Medium, {
                                    BackgroundTransparency = 0,
                                    Position = sec.OrigPos
                                })
                            end
                        end)
                    end
                end
            end

            DockPill.MouseButton1Click:Connect(Page.Select)

            local sectionIndex = 0

            function Page:CreateSection(name, side, sectionIcon)
                sectionIndex = sectionIndex + 1
                local Section = {}
                Section.Elements = {}

                local parentColumn = (side == "right") and RightColumn or LeftColumn

                local Card = CreateInstance("Frame", {
                    Name = "Section_" .. name,
                    BackgroundColor3 = Theme.Card,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    LayoutOrder = sectionIndex,
                    ClipsDescendants = false,
                    Parent = parentColumn
                })
                AddCorner(Card, 10)
                AddStroke(Card, Theme.CardBorder, 1)

                CreateInstance("UIListLayout", {
                    FillDirection = Enum.FillDirection.Vertical,
                    Padding = UDim.new(0, 0),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = Card
                })

                Section.Frame = Card
                Section.OrigPos = Card.Position
                Section.AnimDelay = sectionIndex * 0.03

                local Header = CreateInstance("Frame", {
                    Name = "Header",
                    BackgroundColor3 = Theme.CardHeader,
                    Size = UDim2.new(1, 0, 0, 26),
                    BorderSizePixel = 0,
                    LayoutOrder = 1,
                    Parent = Card
                })
                AddCorner(Header, 10)

                CreateInstance("Frame", {
                    Name = "HeaderFix",
                    BackgroundColor3 = Theme.CardHeader,
                    Size = UDim2.new(1, 0, 0, 8),
                    Position = UDim2.new(0, 0, 1, -8),
                    BorderSizePixel = 0,
                    Parent = Header
                })

                CreateInstance("Frame", {
                    Name = "HeaderSep",
                    BackgroundColor3 = Theme.Separator,
                    BackgroundTransparency = 0.5,
                    Size = UDim2.new(1, 0, 0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    Parent = Header
                })

                CreateInstance("TextLabel", {
                    Name = "Label",
                    Text = name:lower(),
                    Font = Enum.Font.GothamBold,
                    TextSize = 12,
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -40, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    Parent = Header
                })

                local secIconAsset = GetIconAsset(sectionIcon or name)
                if secIconAsset ~= "" then
                    CreateInstance("ImageLabel", {
                        Name = "Icon",
                        Image = secIconAsset,
                        ImageColor3 = Theme.Accent,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 15, 0, 15),
                        Position = UDim2.new(1, -24, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        Parent = Header
                    })
                end

                local ElementsContainer = CreateInstance("Frame", {
                    Name = "Elements",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    LayoutOrder = 2,
                    ClipsDescendants = false,
                    Parent = Card
                })

                CreateInstance("UIListLayout", {
                    FillDirection = Enum.FillDirection.Vertical,
                    Padding = UDim.new(0, 0),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = ElementsContainer
                })
                AddPadding(ElementsContainer, 2, 6, 0, 0)

                table.insert(Page.Sections, Section)

                function Section:CreateToggle(labelText, default, callback, keybindOpt)
                    local toggled = default or false
                    callback = callback or function() end
                    local elementIndex = #Section.Elements + 1

                    local boundKey = nil
                    if typeof(keybindOpt) == "EnumItem" then
                        boundKey = keybindOpt
                    end
                    local hasDots = (keybindOpt ~= nil and keybindOpt ~= false)
                    local listening = false

                    local Row = CreateInstance("Frame", {
                        Name = "Toggle_" .. labelText,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 26),
                        LayoutOrder = elementIndex,
                        Parent = ElementsContainer
                    })
                    AddCorner(Row, 6)

                    local Label = CreateInstance("TextLabel", {
                        Name = "Label",
                        Text = labelText,
                        Font = Enum.Font.GothamMedium,
                        TextSize = 11,
                        TextColor3 = toggled and Theme.Text or Theme.TextDim,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -84, 1, 0),
                        Position = UDim2.new(0, 12, 0, 0),
                        Parent = Row
                    })

                    local DotsBtn = nil
                    if hasDots then
                        DotsBtn = CreateInstance("TextButton", {
                            Name = "Dots",
                            Text = boundKey and ("[" .. boundKey.Name .. "]") or "...",
                            Font = Enum.Font.GothamBold,
                            TextSize = boundKey and 10 or 9,
                            TextColor3 = boundKey and Theme.AccentGlow or Theme.Accent,
                            BackgroundTransparency = 1,
                            Size = UDim2.new(0, boundKey and 34 or 18, 1, 0),
                            Position = UDim2.new(1, -54, 0, 0),
                            AnchorPoint = Vector2.new(1, 0),
                            AutoButtonColor = false,
                            ZIndex = 6,
                            Parent = Row
                        })

                        DotsBtn.MouseButton1Click:Connect(function()
                            listening = true
                            DotsBtn.Text = "..."
                            DotsBtn.TextColor3 = Theme.AccentGlow
                        end)
                    end

                    local ToggleTrack = CreateInstance("Frame", {
                        Name = "Track",
                        BackgroundColor3 = toggled and Theme.Accent or Theme.ToggleOff,
                        Size = UDim2.new(0, 36, 0, 18),
                        Position = UDim2.new(1, -12, 0.5, 0),
                        AnchorPoint = Vector2.new(1, 0.5),
                        Parent = Row
                    })
                    AddCorner(ToggleTrack, 9)

                    local Knob = CreateInstance("Frame", {
                        Name = "Knob",
                        BackgroundColor3 = Theme.ToggleKnob,
                        Size = UDim2.new(0, 14, 0, 14),
                        Position = toggled and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        Parent = ToggleTrack
                    })
                    AddCorner(Knob, 7)

                    local Glow = CreateInstance("Frame", {
                        Name = "Glow",
                        BackgroundColor3 = Theme.Accent,
                        BackgroundTransparency = toggled and 0.65 or 1,
                        Size = UDim2.new(1, 6, 1, 6),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        ZIndex = -1,
                        Parent = ToggleTrack
                    })
                    AddCorner(Glow, 11)

                    local ToggleBtn = CreateInstance("TextButton", {
                        Name = "ToggleBtn",
                        Text = "",
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, hasDots and -60 or 0, 1, 0),
                        Position = UDim2.new(0, 0, 0, 0),
                        ZIndex = 5,
                        Parent = Row
                    })

                    local function applyState(animate)
                        if animate then
                            Tween(ToggleTrack, AnimConfig.Smooth, {
                                BackgroundColor3 = toggled and Theme.Accent or Theme.ToggleOff
                            })
                            Tween(Knob, AnimConfig.Bounce, {
                                Position = toggled and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                            })
                            Tween(Label, AnimConfig.Fast, {
                                TextColor3 = toggled and Theme.Text or Theme.TextDim
                            })
                            Tween(Glow, AnimConfig.Medium, {
                                BackgroundTransparency = toggled and 0.65 or 1
                            })
                        else
                            ToggleTrack.BackgroundColor3 = toggled and Theme.Accent or Theme.ToggleOff
                            Knob.Position = toggled and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                            Label.TextColor3 = toggled and Theme.Text or Theme.TextDim
                            Glow.BackgroundTransparency = toggled and 0.65 or 1
                        end
                    end

                    ToggleBtn.MouseButton1Click:Connect(function()
                        toggled = not toggled
                        applyState(true)
                        callback(toggled)
                    end)

                    local kbConn = UserInputService.InputBegan:Connect(function(input, processed)
                        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                            listening = false
                            if input.KeyCode == Enum.KeyCode.Escape then
                                boundKey = nil
                                if DotsBtn then
                                    DotsBtn.Text = "..."
                                    DotsBtn.TextColor3 = Theme.Accent
                                    DotsBtn.Size = UDim2.new(0, 18, 1, 0)
                                end
                            else
                                boundKey = input.KeyCode
                                if DotsBtn then
                                    DotsBtn.Text = "[" .. boundKey.Name .. "]"
                                    DotsBtn.TextColor3 = Theme.AccentGlow
                                    DotsBtn.Size = UDim2.new(0, 34, 1, 0)
                                end
                            end
                        elseif not listening and not processed and boundKey and input.UserInputType == Enum.UserInputType.Keyboard then
                            if input.KeyCode == boundKey then
                                toggled = not toggled
                                applyState(true)
                                callback(toggled)
                            end
                        end
                    end)
                    table.insert(Window.Connections, kbConn)

                    ToggleBtn.MouseEnter:Connect(function()
                        Tween(Row, AnimConfig.Fast, {BackgroundTransparency = 0.95})
                    end)
                    ToggleBtn.MouseLeave:Connect(function()
                        Tween(Row, AnimConfig.Fast, {BackgroundTransparency = 1})
                    end)

                    local toggleObj = {
                        Set = function(_, val)
                            toggled = val
                            applyState(true)
                            callback(toggled)
                        end,
                        Get = function() return toggled end,
                        SetKey = function(_, k)
                            boundKey = k
                            if DotsBtn then
                                if k then
                                    DotsBtn.Text = "[" .. k.Name .. "]"
                                    DotsBtn.Size = UDim2.new(0, 34, 1, 0)
                                else
                                    DotsBtn.Text = "..."
                                    DotsBtn.Size = UDim2.new(0, 18, 1, 0)
                                end
                            end
                        end,
                        Row = Row,
                        Name = labelText
                    }

                    table.insert(Section.Elements, toggleObj)
                    table.insert(Window.AllElements, toggleObj)
                    table.insert(Window.SearchIndex, {Name = labelText, Tab = Tab, Page = Page, Section = Section, Row = Row})
                    return toggleObj
                end

                function Section:CreateSlider(labelText, min, max, default, suffix, callback)
                    callback = callback or function() end
                    suffix = suffix or ""
                    local value = default or min
                    local elementIndex = #Section.Elements + 1

                    local Row = CreateInstance("Frame", {
                        Name = "Slider_" .. labelText,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 26),
                        LayoutOrder = elementIndex,
                        Parent = ElementsContainer
                    })
                    AddCorner(Row, 6)

                    local Label = CreateInstance("TextLabel", {
                        Name = "Label",
                        Text = labelText,
                        Font = Enum.Font.GothamMedium,
                        TextSize = 11,
                        TextColor3 = Theme.TextDim,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 105, 1, 0),
                        Position = UDim2.new(0, 12, 0, 0),
                        Parent = Row
                    })

                    local ValueLabel = CreateInstance("TextLabel", {
                        Name = "Value",
                        Text = tostring(math.floor(value)) .. (suffix ~= "" and (" " .. suffix) or ""),
                        Font = Enum.Font.GothamBold,
                        TextSize = 11,
                        TextColor3 = Theme.Text,
                        TextXAlignment = Enum.TextXAlignment.Right,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 50, 1, 0),
                        Position = UDim2.new(1, -12, 0, 0),
                        AnchorPoint = Vector2.new(1, 0),
                        Parent = Row
                    })

                    local SliderTrack = CreateInstance("Frame", {
                        Name = "Track",
                        BackgroundColor3 = Theme.SliderTrack,
                        Size = UDim2.new(1, -185, 0, 4),
                        Position = UDim2.new(0, 120, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        Parent = Row
                    })
                    AddCorner(SliderTrack, 2)

                    local pct = math.clamp((value - min) / (max - min), 0, 1)
                    local SliderFill = CreateInstance("Frame", {
                        Name = "Fill",
                        BackgroundColor3 = Theme.SliderFill,
                        Size = UDim2.new(pct, 0, 1, 0),
                        BorderSizePixel = 0,
                        Parent = SliderTrack
                    })
                    AddCorner(SliderFill, 2)

                    local SliderKnob = CreateInstance("Frame", {
                        Name = "Knob",
                        BackgroundColor3 = Theme.ToggleKnob,
                        Size = UDim2.new(0, 12, 0, 12),
                        Position = UDim2.new(pct, 0, 0.5, 0),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        ZIndex = 3,
                        Parent = SliderTrack
                    })
                    AddCorner(SliderKnob, 6)

                    local sliderDragging = false

                    local SliderInput = CreateInstance("TextButton", {
                        Name = "Input",
                        Text = "",
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 14),
                        Position = UDim2.new(0, 0, 0, -7),
                        ZIndex = 5,
                        Parent = SliderTrack
                    })

                    local function updateSlider(input)
                        local trackPos = SliderTrack.AbsolutePosition.X
                        local trackSize = SliderTrack.AbsoluteSize.X
                        local relX = math.clamp((input.Position.X - trackPos) / trackSize, 0, 1)

                        value = math.floor(min + (max - min) * relX)
                        pct = (value - min) / (max - min)

                        Tween(SliderFill, AnimConfig.Fast, {Size = UDim2.new(pct, 0, 1, 0)})
                        Tween(SliderKnob, AnimConfig.Fast, {Position = UDim2.new(pct, 0, 0.5, 0)})
                        ValueLabel.Text = tostring(value) .. (suffix ~= "" and (" " .. suffix) or "")

                        callback(value)
                    end

                    SliderInput.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            sliderDragging = true
                            Tween(SliderKnob, AnimConfig.Bounce, {Size = UDim2.new(0, 14, 0, 14)})
                            updateSlider(input)
                        end
                    end)

                    local sEndConn = UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            if sliderDragging then
                                sliderDragging = false
                                Tween(SliderKnob, AnimConfig.Bounce, {Size = UDim2.new(0, 12, 0, 12)})
                            end
                        end
                    end)
                    table.insert(Window.Connections, sEndConn)

                    local sChangeConn = UserInputService.InputChanged:Connect(function(input)
                        if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                            updateSlider(input)
                        end
                    end)
                    table.insert(Window.Connections, sChangeConn)

                    local sliderObj = {
                        Set = function(_, val)
                            value = math.clamp(val, min, max)
                            pct = (value - min) / (max - min)
                            Tween(SliderFill, AnimConfig.Fast, {Size = UDim2.new(pct, 0, 1, 0)})
                            Tween(SliderKnob, AnimConfig.Fast, {Position = UDim2.new(pct, 0, 0.5, 0)})
                            ValueLabel.Text = tostring(math.floor(value)) .. (suffix ~= "" and (" " .. suffix) or "")
                            callback(value)
                        end,
                        Get = function() return value end,
                        Row = Row,
                        Name = labelText
                    }

                    table.insert(Section.Elements, sliderObj)
                    table.insert(Window.AllElements, sliderObj)
                    table.insert(Window.SearchIndex, {Name = labelText, Tab = Tab, Page = Page, Section = Section, Row = Row})
                    return sliderObj
                end

                function Section:CreateDropdown(labelText, options, default, callback)
                    options = options or {}
                    callback = callback or function() end
                    local selected = default or options[1] or ""
                    local opened = false
                    local elementIndex = #Section.Elements + 1

                    local Row = CreateInstance("Frame", {
                        Name = "Dropdown_" .. labelText,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 26),
                        LayoutOrder = elementIndex,
                        ClipsDescendants = false,
                        Parent = ElementsContainer
                    })
                    AddCorner(Row, 6)

                    local Label = CreateInstance("TextLabel", {
                        Name = "Label",
                        Text = labelText,
                        Font = Enum.Font.GothamMedium,
                        TextSize = 11,
                        TextColor3 = Theme.TextDim,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0.45, 0, 0, 30),
                        Position = UDim2.new(0, 12, 0, 0),
                        Parent = Row
                    })

                    local DropBtn = CreateInstance("TextButton", {
                        Name = "DropBtn",
                        BackgroundColor3 = Theme.InputBg,
                        Size = UDim2.new(0, 95, 0, 22),
                        Position = UDim2.new(1, -12, 0, 4),
                        AnchorPoint = Vector2.new(1, 0),
                        AutoButtonColor = false,
                        Text = "",
                        Parent = Row
                    })
                    AddCorner(DropBtn, 5)
                    AddStroke(DropBtn, Theme.Separator, 1)

                    local DropLabel = CreateInstance("TextLabel", {
                        Name = "SelLabel",
                        Text = selected,
                        Font = Enum.Font.GothamMedium,
                        TextSize = 11,
                        TextColor3 = Theme.Text,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -22, 1, 0),
                        Position = UDim2.new(0, 8, 0, 0),
                        Parent = DropBtn
                    })

                    local DropArrow = CreateInstance("ImageLabel", {
                        Name = "Arrow",
                        Image = IconMap.down,
                        ImageColor3 = Theme.TextDim,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 12, 0, 12),
                        Position = UDim2.new(1, -16, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        Parent = DropBtn
                    })

                    local DropOptions = CreateInstance("Frame", {
                        Name = "Options",
                        BackgroundColor3 = Theme.DropdownBg,
                        Size = UDim2.new(0, 95, 0, 0),
                        Position = UDim2.new(1, -12, 0, 28),
                        AnchorPoint = Vector2.new(1, 0),
                        ClipsDescendants = true,
                        Visible = false,
                        ZIndex = 20,
                        Parent = Row
                    })
                    AddCorner(DropOptions, 5)
                    AddStroke(DropOptions, Theme.Separator, 1)

                    CreateInstance("UIListLayout", {
                        FillDirection = Enum.FillDirection.Vertical,
                        Padding = UDim.new(0, 0),
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Parent = DropOptions
                    })
                    AddPadding(DropOptions, 3, 3, 0, 0)

                    local optionButtons = {}

                    local function rebuildOptions(opts)
                        for _, child in ipairs(DropOptions:GetChildren()) do
                            if child:IsA("TextButton") then child:Destroy() end
                        end
                        optionButtons = {}

                        for i, opt in ipairs(opts) do
                            local OptBtn = CreateInstance("TextButton", {
                                Name = "Opt_" .. opt,
                                Text = opt,
                                Font = Enum.Font.GothamMedium,
                                TextSize = 10,
                                TextColor3 = (opt == selected) and Theme.Accent or Theme.TextDim,
                                TextXAlignment = Enum.TextXAlignment.Left,
                                BackgroundColor3 = Theme.DropdownBg,
                                BackgroundTransparency = 1,
                                AutoButtonColor = false,
                                Size = UDim2.new(1, 0, 0, 22),
                                LayoutOrder = i,
                                ZIndex = 21,
                                Parent = DropOptions
                            })
                            AddPadding(OptBtn, 0, 0, 8, 8)
                            AddCorner(OptBtn, 4)

                            OptBtn.MouseEnter:Connect(function()
                                Tween(OptBtn, AnimConfig.Fast, {
                                    BackgroundTransparency = 0.5,
                                    TextColor3 = Theme.AccentGlow
                                })
                            end)
                            OptBtn.MouseLeave:Connect(function()
                                Tween(OptBtn, AnimConfig.Fast, {
                                    BackgroundTransparency = 1,
                                    TextColor3 = (opt == selected) and Theme.Accent or Theme.TextDim
                                })
                            end)

                            OptBtn.MouseButton1Click:Connect(function()
                                selected = opt
                                DropLabel.Text = opt

                                for _, ob in ipairs(optionButtons) do
                                    Tween(ob.Btn, AnimConfig.Fast, {
                                        TextColor3 = (ob.Name == opt) and Theme.Accent or Theme.TextDim
                                    })
                                end

                                opened = false
                                local t = Tween(DropOptions, AnimConfig.Fast, {Size = UDim2.new(0, 95, 0, 0)})
                                Tween(Row, AnimConfig.Fast, {Size = UDim2.new(1, 0, 0, 26)})
                                t.Completed:Connect(function()
                                    if not opened then DropOptions.Visible = false end
                                end)
                                Tween(DropArrow, AnimConfig.Fast, {Rotation = 0})

                                callback(opt)
                            end)

                            table.insert(optionButtons, {Btn = OptBtn, Name = opt})
                        end
                    end

                    rebuildOptions(options)

                    DropBtn.MouseButton1Click:Connect(function()
                        opened = not opened
                        if opened then
                            DropOptions.Visible = true
                            local totalHeight = #options * 22 + 6
                            Tween(Row, AnimConfig.Fast, {Size = UDim2.new(1, 0, 0, 26 + totalHeight)})
                            Tween(DropOptions, AnimConfig.Medium, {Size = UDim2.new(0, 95, 0, totalHeight)})
                            Tween(DropArrow, AnimConfig.Fast, {Rotation = 180})
                        else
                            local t = Tween(DropOptions, AnimConfig.Fast, {Size = UDim2.new(0, 95, 0, 0)})
                            Tween(Row, AnimConfig.Fast, {Size = UDim2.new(1, 0, 0, 26)})
                            t.Completed:Connect(function()
                                if not opened then DropOptions.Visible = false end
                            end)
                            Tween(DropArrow, AnimConfig.Fast, {Rotation = 0})
                        end
                    end)

                    DropBtn.MouseEnter:Connect(function()
                        Tween(DropBtn, AnimConfig.Fast, {BackgroundColor3 = Theme.SidebarActive})
                    end)
                    DropBtn.MouseLeave:Connect(function()
                        Tween(DropBtn, AnimConfig.Fast, {BackgroundColor3 = Theme.InputBg})
                    end)

                    local dropObj = {
                        Set = function(_, val)
                            selected = val
                            DropLabel.Text = val
                            for _, ob in ipairs(optionButtons) do
                                Tween(ob.Btn, AnimConfig.Fast, {
                                    TextColor3 = (ob.Name == val) and Theme.Accent or Theme.TextDim
                                })
                            end
                            callback(val)
                        end,
                        Get = function() return selected end,
                        Refresh = function(_, newOpts, keepSelection)
                            options = newOpts or {}
                            if not keepSelection or not table.find(options, selected) then
                                selected = options[1] or ""
                                DropLabel.Text = selected
                            end
                            rebuildOptions(options)
                        end,
                        Row = Row,
                        Name = labelText
                    }

                    table.insert(Section.Elements, dropObj)
                    table.insert(Window.AllElements, dropObj)
                    table.insert(Window.SearchIndex, {Name = labelText, Tab = Tab, Page = Page, Section = Section, Row = Row})
                    return dropObj
                end

                function Section:CreateKeybind(labelText, defaultKey, callback)
                    callback = callback or function() end
                    local currentKey = defaultKey or Enum.KeyCode.Unknown
                    local listening = false
                    local elementIndex = #Section.Elements + 1

                    local Row = CreateInstance("Frame", {
                        Name = "Keybind_" .. labelText,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 26),
                        LayoutOrder = elementIndex,
                        Parent = ElementsContainer
                    })
                    AddCorner(Row, 6)

                    local Label = CreateInstance("TextLabel", {
                        Name = "Label",
                        Text = labelText,
                        Font = Enum.Font.GothamMedium,
                        TextSize = 11,
                        TextColor3 = Theme.TextDim,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0.5, 0, 1, 0),
                        Position = UDim2.new(0, 12, 0, 0),
                        Parent = Row
                    })

                    local KeyBtn = CreateInstance("TextButton", {
                        Name = "KeyBtn",
                        Text = (currentKey ~= Enum.KeyCode.Unknown) and currentKey.Name or "None",
                        Font = Enum.Font.GothamMedium,
                        TextSize = 10,
                        TextColor3 = Theme.Text,
                        BackgroundColor3 = Theme.InputBg,
                        AutoButtonColor = false,
                        Size = UDim2.new(0, 65, 0, 22),
                        Position = UDim2.new(1, -12, 0.5, 0),
                        AnchorPoint = Vector2.new(1, 0.5),
                        Parent = Row
                    })
                    AddCorner(KeyBtn, 5)
                    AddStroke(KeyBtn, Theme.Separator, 1)

                    KeyBtn.MouseButton1Click:Connect(function()
                        listening = true
                        KeyBtn.Text = "..."
                        Tween(KeyBtn, AnimConfig.Fast, {BackgroundColor3 = Theme.AccentDark})
                    end)

                    local kbConn = UserInputService.InputBegan:Connect(function(input, processed)
                        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                            listening = false
                            if input.KeyCode == Enum.KeyCode.Escape then
                                currentKey = Enum.KeyCode.Unknown
                                KeyBtn.Text = "None"
                            else
                                currentKey = input.KeyCode
                                KeyBtn.Text = currentKey.Name
                            end
                            Tween(KeyBtn, AnimConfig.Fast, {BackgroundColor3 = Theme.InputBg})
                        elseif not listening and not processed and input.UserInputType == Enum.UserInputType.Keyboard then
                            if currentKey ~= Enum.KeyCode.Unknown and input.KeyCode == currentKey then
                                callback(currentKey)
                            end
                        end
                    end)
                    table.insert(Window.Connections, kbConn)

                    local keybindObj = {
                        Set = function(_, val)
                            currentKey = val
                            KeyBtn.Text = (val and val ~= Enum.KeyCode.Unknown) and val.Name or "None"
                        end,
                        Get = function() return currentKey end,
                        Row = Row,
                        Name = labelText
                    }

                    table.insert(Section.Elements, keybindObj)
                    table.insert(Window.AllElements, keybindObj)
                    table.insert(Window.SearchIndex, {Name = labelText, Tab = Tab, Page = Page, Section = Section, Row = Row})
                    return keybindObj
                end

                function Section:CreateButton(labelText, callback)
                    callback = callback or function() end
                    local elementIndex = #Section.Elements + 1

                    local Row = CreateInstance("Frame", {
                        Name = "Button_" .. labelText,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 32),
                        LayoutOrder = elementIndex,
                        Parent = ElementsContainer
                    })
                    AddCorner(Row, 6)

                    local Btn = CreateInstance("TextButton", {
                        Name = "Btn",
                        Text = labelText,
                        Font = Enum.Font.GothamMedium,
                        TextSize = 11,
                        TextColor3 = Theme.Text,
                        BackgroundColor3 = Theme.InputBg,
                        AutoButtonColor = false,
                        Size = UDim2.new(1, -24, 0, 24),
                        Position = UDim2.new(0, 12, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        ClipsDescendants = true,
                        Parent = Row
                    })
                    AddCorner(Btn, 5)
                    AddStroke(Btn, Theme.Separator, 1)

                    Btn.MouseButton1Click:Connect(function()
                        Ripple(Btn)
                        Tween(Btn, TweenInfo.new(0.08), {BackgroundColor3 = Theme.AccentDark})
                        task.delay(0.12, function()
                            Tween(Btn, AnimConfig.Fast, {BackgroundColor3 = Theme.InputBg})
                        end)
                        callback()
                    end)

                    Btn.MouseEnter:Connect(function()
                        Tween(Btn, AnimConfig.Fast, {BackgroundColor3 = Theme.SidebarActive, TextColor3 = Theme.AccentGlow})
                    end)
                    Btn.MouseLeave:Connect(function()
                        Tween(Btn, AnimConfig.Fast, {BackgroundColor3 = Theme.InputBg, TextColor3 = Theme.Text})
                    end)

                    local btnObj = {
                        Fire = function() callback() end,
                        SetText = function(_, t) Btn.Text = t end,
                        Row = Row,
                        Name = labelText
                    }

                    table.insert(Section.Elements, btnObj)
                    table.insert(Window.AllElements, btnObj)
                    table.insert(Window.SearchIndex, {Name = labelText, Tab = Tab, Page = Page, Section = Section, Row = Row})
                    return btnObj
                end

                function Section:CreateInput(labelText, placeholder, default, callback)
                    callback = callback or function() end
                    local elementIndex = #Section.Elements + 1

                    local Row = CreateInstance("Frame", {
                        Name = "Input_" .. labelText,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 26),
                        LayoutOrder = elementIndex,
                        Parent = ElementsContainer
                    })
                    AddCorner(Row, 6)

                    local Label = CreateInstance("TextLabel", {
                        Name = "Label",
                        Text = labelText,
                        Font = Enum.Font.GothamMedium,
                        TextSize = 11,
                        TextColor3 = Theme.TextDim,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0.45, 0, 1, 0),
                        Position = UDim2.new(0, 12, 0, 0),
                        Parent = Row
                    })

                    local InputBox = CreateInstance("TextBox", {
                        Name = "InputBox",
                        Text = default or "",
                        PlaceholderText = placeholder or "...",
                        PlaceholderColor3 = Theme.TextDark,
                        Font = Enum.Font.GothamMedium,
                        TextSize = 11,
                        TextColor3 = Theme.Text,
                        BackgroundColor3 = Theme.InputBg,
                        Size = UDim2.new(0, 95, 0, 22),
                        Position = UDim2.new(1, -12, 0.5, 0),
                        AnchorPoint = Vector2.new(1, 0.5),
                        ClearTextOnFocus = false,
                        Parent = Row
                    })
                    AddCorner(InputBox, 5)
                    AddStroke(InputBox, Theme.Separator, 1)
                    AddPadding(InputBox, 0, 0, 6, 6)

                    InputBox.Focused:Connect(function()
                        Tween(InputBox, AnimConfig.Fast, {BackgroundColor3 = Theme.SidebarActive})
                    end)
                    InputBox.FocusLost:Connect(function(enterPressed)
                        Tween(InputBox, AnimConfig.Fast, {BackgroundColor3 = Theme.InputBg})
                        callback(InputBox.Text, enterPressed)
                    end)

                    local inputObj = {
                        Set = function(_, val)
                            InputBox.Text = val
                            callback(val, true)
                        end,
                        Get = function() return InputBox.Text end,
                        Row = Row,
                        Name = labelText
                    }

                    table.insert(Section.Elements, inputObj)
                    table.insert(Window.AllElements, inputObj)
                    table.insert(Window.SearchIndex, {Name = labelText, Tab = Tab, Page = Page, Section = Section, Row = Row})
                    return inputObj
                end

                function Section:CreateColorPicker(labelText, default, callback)
                    callback = callback or function() end
                    local currentColor = default or Theme.Accent
                    local elementIndex = #Section.Elements + 1
                    local opened = false

                    local Row = CreateInstance("Frame", {
                        Name = "ColorPicker_" .. labelText,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 26),
                        LayoutOrder = elementIndex,
                        ClipsDescendants = false,
                        Parent = ElementsContainer
                    })
                    AddCorner(Row, 6)

                    local Label = CreateInstance("TextLabel", {
                        Name = "Label",
                        Text = labelText,
                        Font = Enum.Font.GothamMedium,
                        TextSize = 11,
                        TextColor3 = Theme.TextDim,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0.5, 0, 0, 30),
                        Position = UDim2.new(0, 12, 0, 0),
                        Parent = Row
                    })

                    local ColorPreview = CreateInstance("TextButton", {
                        Name = "Preview",
                        Text = "",
                        BackgroundColor3 = currentColor,
                        Size = UDim2.new(0, 30, 0, 18),
                        Position = UDim2.new(1, -12, 0, 6),
                        AnchorPoint = Vector2.new(1, 0),
                        AutoButtonColor = false,
                        Parent = Row
                    })
                    AddCorner(ColorPreview, 4)
                    AddStroke(ColorPreview, Theme.Separator, 1)

                    local PaletteFrame = CreateInstance("Frame", {
                        Name = "Palette",
                        BackgroundColor3 = Theme.DropdownBg,
                        Size = UDim2.new(0, 136, 0, 0),
                        Position = UDim2.new(1, -12, 0, 28),
                        AnchorPoint = Vector2.new(1, 0),
                        ClipsDescendants = true,
                        Visible = false,
                        ZIndex = 20,
                        Parent = Row
                    })
                    AddCorner(PaletteFrame, 5)
                    AddStroke(PaletteFrame, Theme.Separator, 1)

                    CreateInstance("UIGridLayout", {
                        CellPadding = UDim2.new(0, 4, 0, 4),
                        CellSize = UDim2.new(0, 22, 0, 22),
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Parent = PaletteFrame
                    })
                    AddPadding(PaletteFrame, 5, 5, 5, 5)

                    local presetColors = {
                        Color3.fromRGB(245, 125, 30),
                        Color3.fromRGB(231, 76, 60),
                        Color3.fromRGB(46, 204, 113),
                        Color3.fromRGB(52, 152, 219),
                        Color3.fromRGB(155, 89, 182),
                        Color3.fromRGB(241, 196, 15),
                        Color3.fromRGB(26, 188, 156),
                        Color3.fromRGB(236, 240, 241),
                        Color3.fromRGB(149, 165, 166),
                        Color3.fromRGB(52, 73, 94),
                    }

                    for i, col in ipairs(presetColors) do
                        local Swatch = CreateInstance("TextButton", {
                            Name = "Swatch_" .. i,
                            Text = "",
                            BackgroundColor3 = col,
                            AutoButtonColor = false,
                            ZIndex = 21,
                            Parent = PaletteFrame
                        })
                        AddCorner(Swatch, 3)

                        Swatch.MouseButton1Click:Connect(function()
                            currentColor = col
                            Tween(ColorPreview, AnimConfig.Smooth, {BackgroundColor3 = currentColor})
                            callback(currentColor)
                        end)
                    end

                    ColorPreview.MouseButton1Click:Connect(function()
                        opened = not opened
                        if opened then
                            PaletteFrame.Visible = true
                            Tween(Row, AnimConfig.Fast, {Size = UDim2.new(1, 0, 0, 94)})
                            Tween(PaletteFrame, AnimConfig.Medium, {Size = UDim2.new(0, 136, 0, 60)})
                        else
                            local t = Tween(PaletteFrame, AnimConfig.Fast, {Size = UDim2.new(0, 136, 0, 0)})
                            Tween(Row, AnimConfig.Fast, {Size = UDim2.new(1, 0, 0, 26)})
                            t.Completed:Connect(function()
                                if not opened then PaletteFrame.Visible = false end
                            end)
                        end
                    end)

                    local cpObj = {
                        Set = function(_, val)
                            currentColor = val
                            Tween(ColorPreview, AnimConfig.Smooth, {BackgroundColor3 = val})
                            callback(val)
                        end,
                        Get = function() return currentColor end,
                        Row = Row,
                        Name = labelText
                    }

                    table.insert(Section.Elements, cpObj)
                    table.insert(Window.AllElements, cpObj)
                    table.insert(Window.SearchIndex, {Name = labelText, Tab = Tab, Page = Page, Section = Section, Row = Row})
                    return cpObj
                end

                function Section:CreateParagraph(pTitle, pContent)
                    local elementIndex = #Section.Elements + 1

                    local Row = CreateInstance("Frame", {
                        Name = "Paragraph_" .. pTitle,
                        BackgroundColor3 = Theme.InputBg,
                        BackgroundTransparency = 0.5,
                        Size = UDim2.new(1, -24, 0, 0),
                        Position = UDim2.new(0, 12, 0, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        LayoutOrder = elementIndex,
                        Parent = ElementsContainer
                    })
                    AddCorner(Row, 6)
                    AddStroke(Row, Theme.Separator, 1)
                    AddPadding(Row, 6, 6, 8, 8)

                    CreateInstance("UIListLayout", {
                        FillDirection = Enum.FillDirection.Vertical,
                        Padding = UDim.new(0, 3),
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Parent = Row
                    })

                    local PTitleLabel = CreateInstance("TextLabel", {
                        Name = "PTitle",
                        Text = pTitle,
                        Font = Enum.Font.GothamBold,
                        TextSize = 11,
                        TextColor3 = Theme.Text,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 15),
                        LayoutOrder = 1,
                        Parent = Row
                    })

                    local ContentLabel = CreateInstance("TextLabel", {
                        Name = "PContent",
                        Text = pContent or "",
                        Font = Enum.Font.GothamMedium,
                        TextSize = 10,
                        TextColor3 = Theme.TextDim,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextWrapped = true,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        LayoutOrder = 2,
                        Parent = Row
                    })

                    local paraObj = {
                        Set = function(_, newTitle, newContent)
                            if newTitle then PTitleLabel.Text = newTitle end
                            if newContent then ContentLabel.Text = newContent end
                        end,
                        Row = Row,
                        Name = pTitle
                    }

                    table.insert(Section.Elements, paraObj)
                    table.insert(Window.AllElements, paraObj)
                    table.insert(Window.SearchIndex, {Name = pTitle, Tab = Tab, Page = Page, Section = Section, Row = Row})
                    return paraObj
                end

                function Section:CreateLabel(text)
                    local elementIndex = #Section.Elements + 1

                    local Row = CreateInstance("Frame", {
                        Name = "Label_" .. text,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 24),
                        LayoutOrder = elementIndex,
                        Parent = ElementsContainer
                    })
                    AddCorner(Row, 6)

                    local Label = CreateInstance("TextLabel", {
                        Name = "Label",
                        Text = text,
                        Font = Enum.Font.GothamMedium,
                        TextSize = 11,
                        TextColor3 = Theme.TextDark,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -24, 1, 0),
                        Position = UDim2.new(0, 12, 0, 0),
                        Parent = Row
                    })

                    local labelObj = {
                        Set = function(_, val) Label.Text = val end,
                        Row = Row,
                        Name = text
                    }

                    table.insert(Section.Elements, labelObj)
                    table.insert(Window.AllElements, labelObj)
                    table.insert(Window.SearchIndex, {Name = text, Tab = Tab, Page = Page, Section = Section, Row = Row})
                    return labelObj
                end

                function Section:CreateSeparator()
                    local elementIndex = #Section.Elements + 1

                    local Row = CreateInstance("Frame", {
                        Name = "Sep",
                        BackgroundColor3 = Theme.Separator,
                        BackgroundTransparency = 0.5,
                        Size = UDim2.new(1, -24, 0, 1),
                        Position = UDim2.new(0, 12, 0, 0),
                        LayoutOrder = elementIndex,
                        BorderSizePixel = 0,
                        Parent = ElementsContainer
                    })

                    local sepObj = {Row = Row}
                    table.insert(Section.Elements, sepObj)
                    return sepObj
                end

                return Section
            end

            table.insert(Tab.Pages, Page)

            if #Tab.Pages == 1 then
                Tab.ActivePage = Page
                if Tab == Window.ActiveTab or myTabIndex == 1 then
                    Page.Select()
                end
            end

            return Page
        end

        function Tab:CreateSection(name, side, sectionIcon)
            local targetPage = Tab.ActivePage
            if not targetPage then
                targetPage = Tab:CreatePage(tabName, tabIcon)
            end
            return targetPage:CreateSection(name, side, sectionIcon)
        end

        return Tab
    end

    function Window:Notify(titleOrConfig, message, duration, nType)
        PainUI:Notify(titleOrConfig, message, duration, nType)
    end

    function Window:Destroy()
        for _, conn in ipairs(Window.Connections) do
            if conn and conn.Disconnect then
                pcall(function() conn:Disconnect() end)
            end
        end
        Window.Connections = {}

        local t = Tween(MainFrame, AnimConfig.Medium, {
            Size = UDim2.new(0, windowSize.X.Offset, 0, 0),
            BackgroundTransparency = 1
        })
        t.Completed:Connect(function()
            ScreenGui:Destroy()
        end)
    end

    return Window
end

pcall(function()
    if getgenv then
        getgenv().PainUI = PainUI
    end
end)

return PainUI
