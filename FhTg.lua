-- =====================================================
-- 🧠 GUI SCANNER & CODE EXTRACTOR
-- =====================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- =====================================================
-- واجهة السكريبت نفسه
-- =====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GUIScanner"
ScreenGui.Parent = LocalPlayer.PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 350)
MainFrame.Position = UDim2.new(0.5, -200, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)

-- شريط العنوان
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🧠 GUI Scanner"
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 3)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Parent = TitleBar

-- حقل اختيار الواجهة
local GuiDropdown = Instance.new("TextBox")
GuiDropdown.Size = UDim2.new(0.9, 0, 0, 35)
GuiDropdown.Position = UDim2.new(0.05, 0, 0.13, 0)
GuiDropdown.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
GuiDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiDropdown.Font = Enum.Font.Gotham
GuiDropdown.TextSize = 13
GuiDropdown.PlaceholderText = "Click 'Scan' to find GUIs..."
GuiDropdown.Text = ""
GuiDropdown.Parent = MainFrame
Instance.new("UICorner", GuiDropdown).CornerRadius = UDim.new(0, 10)

-- زر المسح
local ScanBtn = Instance.new("TextButton")
ScanBtn.Size = UDim2.new(0.45, 0, 0, 35)
ScanBtn.Position = UDim2.new(0.05, 0, 0.28, 0)
ScanBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
ScanBtn.Text = "🔍 Scan GUIs"
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanBtn.Font = Enum.Font.GothamBold
ScanBtn.TextSize = 14
ScanBtn.Parent = MainFrame
Instance.new("UICorner", ScanBtn).CornerRadius = UDim.new(0, 10)

-- زر الاستخراج
local ExtractBtn = Instance.new("TextButton")
ExtractBtn.Size = UDim2.new(0.45, 0, 0, 35)
ExtractBtn.Position = UDim2.new(0.5, 5, 0.28, 0)
ExtractBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
ExtractBtn.Text = "📥 Extract Code"
ExtractBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExtractBtn.Font = Enum.Font.GothamBold
ExtractBtn.TextSize = 14
ExtractBtn.Parent = MainFrame
Instance.new("UICorner", ExtractBtn).CornerRadius = UDim.new(0, 10)

-- زر النسخ
local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0.9, 0, 0, 35)
CopyBtn.Position = UDim2.new(0.05, 0, 0.44, 0)
CopyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
CopyBtn.Text = "📋 Copy Extracted Code"
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextSize = 14
CopyBtn.Parent = MainFrame
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 10)

-- منطقة عرض الكود
local CodeBox = Instance.new("ScrollingFrame")
CodeBox.Size = UDim2.new(0.9, 0, 0, 130)
CodeBox.Position = UDim2.new(0.05, 0, 0.55, 0)
CodeBox.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
CodeBox.ScrollBarThickness = 4
CodeBox.Parent = MainFrame
Instance.new("UICorner", CodeBox).CornerRadius = UDim.new(0, 10)

local CodeLabel = Instance.new("TextLabel")
CodeLabel.Size = UDim2.new(1, -10, 0, 120)
CodeLabel.Position = UDim2.new(0, 5, 0, 5)
CodeLabel.BackgroundTransparency = 1
CodeLabel.Text = "📄 Select a GUI and click Extract..."
CodeLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
CodeLabel.Font = Enum.Font.Gotham
CodeLabel.TextSize = 11
CodeLabel.TextWrapped = true
CodeLabel.TextXAlignment = Enum.TextXAlignment.Left
CodeLabel.TextYAlignment = Enum.TextYAlignment.Top
CodeLabel.Parent = CodeBox

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
local guiList = {}
local extractedCode = ""

-- =====================================================
-- وظائف المسح والاستخراج
-- =====================================================
local function scanGUIs()
    guiList = {}
    local listText = ""

    -- مسح PlayerGui
    for _, gui in pairs(LocalPlayer.PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            table.insert(guiList, gui)
            listText = listText .. "📁 " .. gui.Name .. " (PlayerGui)\n"
        end
    end

    -- مسح CoreGui
    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            table.insert(guiList, gui)
            listText = listText .. "📁 " .. gui.Name .. " (CoreGui)\n"
        end
    end

    if #guiList > 0 then
        GuiDropdown.Text = listText
        GuiDropdown.PlaceholderText = "Select a GUI from the list..."
        return true
    else
        GuiDropdown.Text = "❌ No GUIs found!"
        return false
    end
end

local function extractCode(gui)
    local fullCode = ""
    local scripts = {}

    -- جمع كل الـ LocalScripts و ModuleScripts
    for _, obj in pairs(gui:GetDescendants()) do
        if obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
            table.insert(scripts, obj)
        end
    end

    if #scripts == 0 then
        return "⚠️ No scripts found in this GUI."
    end

    fullCode = "-- GUI: " .. gui.Name .. "\n"
    fullCode = fullCode .. "-- Path: " .. gui:GetFullName() .. "\n\n"

    for _, script in pairs(scripts) do
        fullCode = fullCode .. "-- Script: " .. script.Name .. "\n"
        fullCode = fullCode .. "-- Path: " .. script:GetFullName() .. "\n"
        fullCode = fullCode .. script.Source .. "\n\n"
    end

    -- إضافة معلومات الأزرار
    local buttons = {}
    for _, obj in pairs(gui:GetDescendants()) do
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
            table.insert(buttons, obj)
        end
    end

    if #buttons > 0 then
        fullCode = fullCode .. "-- Buttons:\n"
        for _, btn in pairs(buttons) do
            fullCode = fullCode .. "-- " .. btn.Name .. " (Position: " .. tostring(btn.Position) .. ")\n"
        end
    end

    return fullCode
end

-- =====================================================
-- الأزرار
-- =====================================================
ScanBtn.MouseButton1Click:Connect(function()
    scanGUIs()
    CodeLabel.Text = "📄 " .. #guiList .. " GUIs found. Select one and click Extract."
end)

ExtractBtn.MouseButton1Click:Connect(function()
    -- اختيار أول GUI من القائمة (أو اللي المستخدم اختاره)
    local selectedName = GuiDropdown.Text:match("📁 (.-) ")
    if not selectedName then
        CodeLabel.Text = "❌ No GUI selected! Please scan and choose one."
        return
    end

    local selectedGui = nil
    for _, gui in pairs(guiList) do
        if gui.Name == selectedName then
            selectedGui = gui
            break
        end
    end

    if not selectedGui then
        CodeLabel.Text = "❌ GUI not found!"
        return
    end

    extractedCode = extractCode(selectedGui)
    CodeLabel.Text = extractedCode
    CodeBox.CanvasSize = UDim2.new(0, 0, 0, #extractedCode / 2 + 50)
end)

CopyBtn.MouseButton1Click:Connect(function()
    if extractedCode ~= "" and extractedCode ~= "⚠️ No scripts found in this GUI." then
        setclipboard(extractedCode)
        CodeLabel.Text = "✅ Code copied to clipboard!"
    else
        CodeLabel.Text = "❌ No code to copy! Extract first."
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("🧠 GUI Scanner is ready!")
