-- =====================================================
-- 👆 GUI PICKER & EXTRACTOR
-- =====================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- =====================================================
-- واجهة السكريبت
-- =====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GUIPicker"
ScreenGui.Parent = LocalPlayer.PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0.5, -100, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)

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
TitleLabel.Text = "👆 GUI Picker"
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

-- زر Select
local SelectBtn = Instance.new("TextButton")
SelectBtn.Size = UDim2.new(0.8, 0, 0, 35)
SelectBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
SelectBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
SelectBtn.Text = "👆 Select GUI"
SelectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectBtn.Font = Enum.Font.GothamBold
SelectBtn.TextSize = 14
SelectBtn.Parent = MainFrame
Instance.new("UICorner", SelectBtn).CornerRadius = UDim.new(0, 8)

-- زر Copy All
local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0.8, 0, 0, 35)
CopyBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
CopyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
CopyBtn.Text = "📋 Copy All"
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextSize = 14
CopyBtn.Parent = MainFrame
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 8)

-- نص الحالة
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0, 20)
StatusLabel.Position = UDim2.new(0.05, 0, 0.85, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "🔹 Select a GUI"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11
StatusLabel.Parent = MainFrame

-- =====================================================
-- السحب باللمس
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
local selectedGui = nil
local extractedData = ""

-- =====================================================
-- وظيفة استخراج كل شيء من الواجهة
-- =====================================================
local function extractAll(gui)
    local data = ""
    
    data = data .. "-- GUI: " .. gui.Name .. "\n"
    data = data .. "-- Path: " .. gui:GetFullName() .. "\n"
    data = data .. "-- Class: " .. gui.ClassName .. "\n"
    data = data .. "-- Properties:\n"
    
    -- الخصائص الأساسية
    data = data .. "-- Size: " .. tostring(gui.Size) .. "\n"
    data = data .. "-- Position: " .. tostring(gui.Position) .. "\n"
    data = data .. "-- BackgroundColor3: " .. tostring(gui.BackgroundColor3) .. "\n"
    data = data .. "-- BackgroundTransparency: " .. tostring(gui.BackgroundTransparency) .. "\n"
    data = data .. "\n"
    
    -- الأكواد (LocalScripts و ModuleScripts)
    local scripts = {}
    for _, obj in pairs(gui:GetDescendants()) do
        if obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
            table.insert(scripts, obj)
        end
    end
    
    if #scripts > 0 then
        data = data .. "-- Scripts (" .. #scripts .. "):\n"
        for _, script in pairs(scripts) do
            data = data .. "-- Script: " .. script.Name .. "\n"
            data = data .. "-- Path: " .. script:GetFullName() .. "\n"
            data = data .. script.Source .. "\n\n"
        end
    else
        data = data .. "-- No scripts found in this GUI.\n"
    end
    
    -- الأزرار (TextButton, ImageButton)
    local buttons = {}
    for _, obj in pairs(gui:GetDescendants()) do
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
            table.insert(buttons, obj)
        end
    end
    
    if #buttons > 0 then
        data = data .. "-- Buttons (" .. #buttons .. "):\n"
        for _, btn in pairs(buttons) do
            data = data .. "-- Button: " .. btn.Name .. "\n"
            data = data .. "--   Position: " .. tostring(btn.Position) .. "\n"
            data = data .. "--   Size: " .. tostring(btn.Size) .. "\n"
            data = data .. "--   Text: " .. (btn.Text or "None") .. "\n"
            data = data .. "--   Class: " .. btn.ClassName .. "\n\n"
        end
    else
        data = data .. "-- No buttons found in this GUI.\n"
    end
    
    -- أي كائنات أخرى مهمة
    local others = {}
    for _, obj in pairs(gui:GetDescendants()) do
        if not obj:IsA("LocalScript") and not obj:IsA("ModuleScript") and not obj:IsA("TextButton") and not obj:IsA("ImageButton") then
            table.insert(others, obj)
        end
    end
    
    if #others > 0 then
        data = data .. "-- Other Objects (" .. #others .. "):\n"
        for _, obj in pairs(others) do
            data = data .. "-- " .. obj.Name .. " (" .. obj.ClassName .. ")\n"
        end
    end
    
    return data
end

-- =====================================================
-- زر Select (اختيار الواجهة باللمس)
-- =====================================================
SelectBtn.MouseButton1Click:Connect(function()
    StatusLabel.Text = "👆 Tap on any GUI in the game..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    
    -- ننتظر المستخدم يختار واجهة
    local connection
    connection = Mouse.Button1Down:Connect(function()
        local target = Mouse.Target
        if not target then return end
        
        -- البحث عن الواجهة الأم (ScreenGui)
        local gui = target
        while gui and not gui:IsA("ScreenGui") do
            gui = gui.Parent
        end
        
        if gui and gui:IsA("ScreenGui") and gui ~= ScreenGui then
            selectedGui = gui
            StatusLabel.Text = "✅ Selected: " .. gui.Name
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            
            -- استخراج البيانات فوراً
            extractedData = extractAll(gui)
            print("📥 Extracted data from: " .. gui.Name)
        else
            StatusLabel.Text = "❌ Not a valid GUI. Try again."
            StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
        
        connection:Disconnect()
    end)
end)

-- =====================================================
-- زر Copy All
-- =====================================================
CopyBtn.MouseButton1Click:Connect(function()
    if extractedData ~= "" then
        setclipboard(extractedData)
        StatusLabel.Text = "📋 All data copied!"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    else
        StatusLabel.Text = "❌ No data to copy. Select a GUI first!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- =====================================================
-- إغلاق
-- =====================================================
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("👆 GUI Picker & Extractor is ready!")
