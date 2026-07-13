-- =====================================================
-- 🧠 EXECUTION MIRROR (استخراج الواجهة بعد التنفيذ)
-- =====================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- =====================================================
-- الواجهة
-- =====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ExecutionMirror"
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

-- شريط العنوان
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 8, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🧠 Execution Mirror"
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 14
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

-- حقل الرابط
local UrlInput = Instance.new("TextBox")
UrlInput.Size = UDim2.new(0.9, 0, 0, 30)
UrlInput.Position = UDim2.new(0.05, 0, 0.15, 0)
UrlInput.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
UrlInput.TextColor3 = Color3.fromRGB(255, 255, 255)
UrlInput.Font = Enum.Font.Gotham
UrlInput.TextSize = 12
UrlInput.PlaceholderText = "Paste script URL..."
UrlInput.Text = ""
UrlInput.Parent = MainFrame
Instance.new("UICorner", UrlInput).CornerRadius = UDim.new(0, 8)

-- زر Execute & Mirror
local ExecBtn = Instance.new("TextButton")
ExecBtn.Size = UDim2.new(0.8, 0, 0, 35)
ExecBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
ExecBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
ExecBtn.Text = "⚡ Execute & Mirror"
ExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecBtn.Font = Enum.Font.GothamBold
ExecBtn.TextSize = 14
ExecBtn.Parent = MainFrame
Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0, 8)

-- زر Copy All
local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0.8, 0, 0, 35)
CopyBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
CopyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
CopyBtn.Text = "📋 Copy Mirrored Code"
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
local mirroredCode = ""

-- =====================================================
-- وظيفة استخراج كل GUI
-- =====================================================
local function mirrorAllGUIs()
    local result = ""
    local guis = {}

    -- جمع كل الـ GUIs من PlayerGui و CoreGui
    for _, gui in pairs(LocalPlayer.PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            table.insert(guis, gui)
        end
    end

    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            table.insert(guis, gui)
        end
    end

    if #guis == 0 then
        return "⚠️ No GUIs found!"
    end

    -- نعكس كل واجهة
    for _, gui in pairs(guis) do
        result = result .. "-- =====================================\n"
        result = result .. "-- GUI: " .. gui.Name .. "\n"
        result = result .. "-- Path: " .. gui:GetFullName() .. "\n"
        result = result .. "-- Class: " .. gui.ClassName .. "\n"
        result = result .. "-- Properties:\n"
        result = result .. "-- Size: " .. tostring(gui.Size) .. "\n"
        result = result .. "-- Position: " .. tostring(gui.Position) .. "\n"
        result = result .. "-- BackgroundColor3: " .. tostring(gui.BackgroundColor3) .. "\n\n"

        -- الأكواد
        local scripts = {}
        for _, obj in pairs(gui:GetDescendants()) do
            if obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
                table.insert(scripts, obj)
            end
        end

        if #scripts > 0 then
            result = result .. "-- Scripts:\n"
            for _, script in pairs(scripts) do
                result = result .. "-- Script: " .. script.Name .. "\n"
                result = result .. "-- Path: " .. script:GetFullName() .. "\n"
                result = result .. script.Source .. "\n\n"
            end
        else
            result = result .. "-- No scripts found.\n"
        end

        -- الأزرار
        local buttons = {}
        for _, obj in pairs(gui:GetDescendants()) do
            if obj:IsA("TextButton") or obj:IsA("ImageButton") then
                table.insert(buttons, obj)
            end
        end

        if #buttons > 0 then
            result = result .. "-- Buttons:\n"
            for _, btn in pairs(buttons) do
                result = result .. "-- " .. btn.Name .. " (Position: " .. tostring(btn.Position) .. ")\n"
            end
        end

        result = result .. "\n"
    end

    return result
end

-- =====================================================
-- الأزرار
-- =====================================================
ExecBtn.MouseButton1Click:Connect(function()
    local url = UrlInput.Text
    if url == "" then
        StatusLabel.Text = "⚠️ Paste URL first!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        return
    end

    StatusLabel.Text = "⏳ Fetching..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

    local success, content = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        StatusLabel.Text = "✅ Code fetched! Executing..."
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

        local func, err = loadstring(content)
        if func then
            task.spawn(function()
                pcall(func)
                -- استخراج الـ GUI بعد التنفيذ
                task.wait(0.5)
                mirroredCode = mirrorAllGUIs()
                StatusLabel.Text = "✅ GUI mirrored! Ready to copy."
                StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
                print("🧠 Mirrored code saved!")
            end)
        else
            StatusLabel.Text = "❌ Loadstring error: " .. tostring(err):sub(1, 30)
            StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
    else
        StatusLabel.Text = "❌ Failed to fetch!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

CopyBtn.MouseButton1Click:Connect(function()
    if mirroredCode ~= "" then
        setclipboard(mirroredCode)
        StatusLabel.Text = "📋 Mirrored code copied!"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    else
        StatusLabel.Text = "❌ No code to copy!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("🧠 Execution Mirror is ready!")
