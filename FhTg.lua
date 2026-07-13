-- =====================================================
-- 🧠 LAST CLICK EXTRACTOR
-- =====================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- =====================================================
-- واجهة السكريبت
-- =====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LastClickExtractor"
ScreenGui.Parent = LocalPlayer.PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 200)
MainFrame.Position = UDim2.new(0.5, -160, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

-- شريط العنوان (للسحب)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 8, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🖱️ Last Click Extractor"
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 3)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = TitleBar

-- زر الحالة (تشغيل/إيقاف المراقبة)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 30)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
ToggleBtn.Text = "▶️ Start Monitoring"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
ToggleBtn.Parent = MainFrame
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

-- عرض آخر زر
local LastButtonLabel = Instance.new("TextLabel")
LastButtonLabel.Size = UDim2.new(0.9, 0, 0, 20)
LastButtonLabel.Position = UDim2.new(0.05, 0, 0.35, 0)
LastButtonLabel.BackgroundTransparency = 1
LastButtonLabel.Text = "🟡 Last Click: None"
LastButtonLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
LastButtonLabel.Font = Enum.Font.Gotham
LastButtonLabel.TextSize = 11
LastButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
LastButtonLabel.Parent = MainFrame

-- زر استخراج الكود
local ExtractBtn = Instance.new("TextButton")
ExtractBtn.Size = UDim2.new(0.8, 0, 0, 30)
ExtractBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
ExtractBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ExtractBtn.Text = "📥 Extract Code"
ExtractBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExtractBtn.Font = Enum.Font.GothamBold
ExtractBtn.TextSize = 13
ExtractBtn.Parent = MainFrame
Instance.new("UICorner", ExtractBtn).CornerRadius = UDim.new(0, 8)

-- زر نسخ
local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0.8, 0, 0, 30)
CopyBtn.Position = UDim2.new(0.1, 0, 0.68, 0)
CopyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
CopyBtn.Text = "📋 Copy Extracted Code"
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextSize = 13
CopyBtn.Parent = MainFrame
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 8)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0, 18)
StatusLabel.Position = UDim2.new(0.05, 0, 0.88, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "🔹 Ready"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 10
StatusLabel.Parent = MainFrame

-- =====================================================
-- السحب
-- =====================================================
local dragData = {dragging = false, startPos = nil, startMouse = nil}

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragData.dragging = true
        dragData.startPos = MainFrame.Position
        dragData.startMouse = Vector2.new(input.Position.X, input.Position.Y)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragData.dragging then
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - dragData.startMouse
            MainFrame.Position = UDim2.new(0, dragData.startPos.X.Offset + delta.X, 0, dragData.startPos.Y.Offset + delta.Y)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragData.dragging = false
    end
end)

-- =====================================================
-- المتغيرات
-- =====================================================
local isMonitoring = false
local lastClickedButton = nil
local extractedCode = ""
local connections = {}

-- =====================================================
-- وظيفة جمع أكواد الزر
-- =====================================================
local function getButtonCode(button)
    if not button then return "⚠️ No button selected!" end
    
    local result = "-- =====================================\n"
    result = result .. "-- Button: " .. button.Name .. "\n"
    result = result .. "-- Path: " .. button:GetFullName() .. "\n"
    result = result .. "-- Class: " .. button.ClassName .. "\n\n"
    
    -- الخصائص
    result = result .. "-- Properties:\n"
    result = result .. "-- Position: " .. tostring(button.Position) .. "\n"
    result = result .. "-- Size: " .. tostring(button.Size) .. "\n"
    if button:IsA("TextButton") then
        result = result .. "-- Text: " .. (button.Text or "None") .. "\n"
    end
    result = result .. "\n"
    
    -- الأكواد جوا الزر
    local scripts = {}
    for _, obj in pairs(button:GetDescendants()) do
        if obj:IsA("LocalScript") or obj:IsA("Script") or obj:IsA("ModuleScript") then
            table.insert(scripts, obj)
        end
    end
    
    if #scripts > 0 then
        result = result .. "-- Scripts Inside Button:\n"
        for _, script in pairs(scripts) do
            result = result .. "-- Script: " .. script.Name .. "\n"
            result = result .. "-- Path: " .. script:GetFullName() .. "\n"
            result = result .. script.Source .. "\n\n"
        end
    else
        result = result .. "-- No scripts found inside the button.\n"
    end
    
    -- البحث عن أكواد في الأب
    local parent = button.Parent
    local parentScripts = {}
    for _, obj in pairs(parent:GetChildren()) do
        if obj:IsA("LocalScript") or obj:IsA("Script") or obj:IsA("ModuleScript") then
            table.insert(parentScripts, obj)
        end
    end
    
    if #parentScripts > 0 then
        result = result .. "-- Scripts in Parent (" .. parent.Name .. "):\n"
        for _, script in pairs(parentScripts) do
            result = result .. "-- Script: " .. script.Name .. "\n"
            result = result .. "-- Path: " .. script:GetFullName() .. "\n"
            result = result .. script.Source .. "\n\n"
        end
    end
    
    return result
end

-- =====================================================
-- مراقبة الضغط على الأزرار
-- =====================================================
local function startMonitoring()
    if isMonitoring then return end
    isMonitoring = true
    
    -- مراقبة أزرار اللعبة
    local function onButtonClick(button)
        if not button then return end
        -- نتأكد إنه مش زر من السكريبت نفسه
        local isSelf = false
        local parent = button.Parent
        while parent do
            if parent == ScreenGui then
                isSelf = true
                break
            end
            parent = parent.Parent
        end
        
        if not isSelf then
            lastClickedButton = button
            LastButtonLabel.Text = "🟢 Last Click: " .. button.Name
            LastButtonLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            StatusLabel.Text = "✅ Click captured: " .. button.Name
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            print("🖱️ Clicked: " .. button:GetFullName())
        end
    end
    
    -- ربط بالـ Mouse
    local conn = Mouse.Button1Down:Connect(function()
        local target = Mouse.Target
        if target then
            -- البحث عن الزر (أو أي كائن قابل للضغط)
            local button = target
            while button and not button:IsA("TextButton") and not button:IsA("ImageButton") do
                button = button.Parent
            end
            if button then
                onButtonClick(button)
            end
        end
    end)
    table.insert(connections, conn)
    
    ToggleBtn.Text = "⏹️ Stop Monitoring"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    StatusLabel.Text = "🟢 Monitoring Active"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    print("🖱️ Last Click Extractor started!")
end

local function stopMonitoring()
    if not isMonitoring then return end
    isMonitoring = false
    
    for _, conn in pairs(connections) do
        pcall(function() conn:Disconnect() end)
    end
    connections = {}
    
    ToggleBtn.Text = "▶️ Start Monitoring"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    StatusLabel.Text = "🔴 Monitoring Stopped"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    print("🖱️ Last Click Extractor stopped!")
end

-- =====================================================
-- الأزرار
-- =====================================================
ToggleBtn.MouseButton1Click:Connect(function()
    if isMonitoring then
        stopMonitoring()
    else
        startMonitoring()
    end
end)

ExtractBtn.MouseButton1Click:Connect(function()
    if lastClickedButton then
        extractedCode = getButtonCode(lastClickedButton)
        StatusLabel.Text = "✅ Code extracted from: " .. lastClickedButton.Name
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        print("📥 Extracted code from: " .. lastClickedButton.Name)
    else
        StatusLabel.Text = "❌ No button clicked yet!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

CopyBtn.MouseButton1Click:Connect(function()
    if extractedCode ~= "" then
        setclipboard(extractedCode)
        StatusLabel.Text = "📋 Code copied!"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    else
        StatusLabel.Text = "❌ No code to copy!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    stopMonitoring()
    ScreenGui:Destroy()
end)

print("🖱️ Last Click Extractor is ready!")
