-- =====================================================
-- 🧠 TIME-BASED LOGGER
-- =====================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- =====================================================
-- واجهة السكريبت
-- =====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TimeBasedLogger"
ScreenGui.Parent = LocalPlayer.PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 160)
MainFrame.Position = UDim2.new(0.5, -140, 0.3, 0)
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
TitleLabel.Text = "⏳ Time-Based Logger"
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

-- زر Start Logging
local StartBtn = Instance.new("TextButton")
StartBtn.Size = UDim2.new(0.8, 0, 0, 35)
StartBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
StartBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
StartBtn.Text = "▶️ Start Logging"
StartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StartBtn.Font = Enum.Font.GothamBold
StartBtn.TextSize = 14
StartBtn.Parent = MainFrame
Instance.new("UICorner", StartBtn).CornerRadius = UDim.new(0, 8)

-- زر Copy All
local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0.8, 0, 0, 35)
CopyBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
CopyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
CopyBtn.Text = "📋 Copy All Logs"
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextSize = 14
CopyBtn.Parent = MainFrame
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 8)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0, 20)
StatusLabel.Position = UDim2.new(0.05, 0, 0.85, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "🔹 Ready"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11
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
local isLogging = false
local logData = ""
local connections = {}

-- =====================================================
-- وظيفة تسجيل الكائنات الجديدة
-- =====================================================
local function logObject(obj, source)
    if not isLogging then return end
    
    local entry = "\n-- [" .. os.date("%H:%M:%S") .. "] New Object:\n"
    entry = entry .. "-- Name: " .. obj.Name .. "\n"
    entry = entry .. "-- Class: " .. obj.ClassName .. "\n"
    entry = entry .. "-- Path: " .. obj:GetFullName() .. "\n"
    entry = entry .. "-- Parent: " .. obj.Parent.Name .. "\n"
    
    -- لو كان سكريبت، ناخد الكود
    if obj:IsA("LocalScript") or obj:IsA("ModuleScript") or obj:IsA("Script") then
        entry = entry .. "-- Source:\n" .. obj.Source .. "\n"
    end
    
    -- لو كان GUI، نسجل خصائصه
    if obj:IsA("ScreenGui") or obj:IsA("Frame") or obj:IsA("TextButton") or obj:IsA("ImageButton") then
        entry = entry .. "-- Position: " .. tostring(obj.Position) .. "\n"
        entry = entry .. "-- Size: " .. tostring(obj.Size) .. "\n"
        if obj:IsA("TextButton") then
            entry = entry .. "-- Text: " .. (obj.Text or "None") .. "\n"
        end
    end
    
    logData = logData .. entry
    StatusLabel.Text = "📦 Logged: " .. obj.Name
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
end

-- =====================================================
-- بدء المراقبة
-- =====================================================
local function startLogging()
    if isLogging then return end
    isLogging = true
    logData = "-- Log started at: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"
    logData = logData .. "-- =====================================\n"
    
    -- مراقبة الإضافات في Workspace
    local conn1 = workspace.DescendantAdded:Connect(function(obj)
        logObject(obj, "Workspace")
    end)
    table.insert(connections, conn1)
    
    -- مراقبة الإضافات في ReplicatedStorage
    local conn2 = game:GetService("ReplicatedStorage").DescendantAdded:Connect(function(obj)
        logObject(obj, "ReplicatedStorage")
    end)
    table.insert(connections, conn2)
    
    -- مراقبة الإضافات في PlayerGui
    local conn3 = LocalPlayer.PlayerGui.DescendantAdded:Connect(function(obj)
        logObject(obj, "PlayerGui")
    end)
    table.insert(connections, conn3)
    
    -- مراقبة الإضافات في CoreGui
    local conn4 = CoreGui.DescendantAdded:Connect(function(obj)
        logObject(obj, "CoreGui")
    end)
    table.insert(connections, conn4)
    
    -- مراقبة الإضافات في Players
    local conn5 = Players.DescendantAdded:Connect(function(obj)
        logObject(obj, "Players")
    end)
    table.insert(connections, conn5)
    
    StatusLabel.Text = "🟢 Logging Active"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    StartBtn.Text = "⏹️ Stop Logging"
    StartBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    
    print("⏳ Time-Based Logger started!")
end

-- =====================================================
-- إيقاف المراقبة
-- =====================================================
local function stopLogging()
    if not isLogging then return end
    isLogging = false
    
    for _, conn in pairs(connections) do
        pcall(function() conn:Disconnect() end)
    end
    connections = {}
    
    StatusLabel.Text = "🔴 Logging Stopped"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    StartBtn.Text = "▶️ Start Logging"
    StartBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    
    print("⏳ Time-Based Logger stopped!")
end

-- =====================================================
-- الأزرار
-- =====================================================
StartBtn.MouseButton1Click:Connect(function()
    if isLogging then
        stopLogging()
    else
        startLogging()
    end
end)

CopyBtn.MouseButton1Click:Connect(function()
    if logData ~= "" and logData ~= "-- Log started at: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n-- =====================================\n" then
        setclipboard(logData)
        StatusLabel.Text = "📋 Logs copied!"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    else
        StatusLabel.Text = "❌ No logs to copy!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    stopLogging()
    ScreenGui:Destroy()
end)

print("⏳ Time-Based Logger is ready!")
