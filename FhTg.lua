-- =====================================================
-- 🚀 SCREEN GUI PRO PICKER & EXTRACTOR (ULTIMATE)
-- =====================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- إنشاء واجهة الأداة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateGuiPicker"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 1000000 -- أعلى من كل شيء في اللعبة

-- إطار التحديد (المربع الذي سيظهر حول الزر الذي تختاره)
local SelectionFrame = Instance.new("Frame")
SelectionFrame.Name = "SelectionFrame"
SelectionFrame.Size = UDim2.new(0, 0, 0, 0)
SelectionFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
SelectionFrame.BackgroundTransparency = 0.7
SelectionFrame.BorderSizePixel = 2
SelectionFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
SelectionFrame.Visible = false
SelectionFrame.Parent = ScreenGui
Instance.new("UIStroke", SelectionFrame).Thickness = 2

-- القائمة الرئيسية
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 180)
MainFrame.Position = UDim2.new(0.5, -125, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "🎯 UI SCREEN EXTRACTOR"
Title.TextColor3 = Color3.white
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = MainFrame

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 25)
Status.Position = UDim2.new(0, 0, 0.8, 0)
Status.Text = "Ready..."
Status.TextColor3 = Color3.fromRGB(0, 255, 200)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Gotham
Status.Parent = MainFrame

-- الأزرار
local SelectBtn = Instance.new("TextButton")
SelectBtn.Size = UDim2.new(0.9, 0, 0, 40)
SelectBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
SelectBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
SelectBtn.Text = "🖱️ Click to Select UI"
SelectBtn.TextColor3 = Color3.white
SelectBtn.Font = Enum.Font.GothamBold
SelectBtn.Parent = MainFrame
Instance.new("UICorner", SelectBtn)

local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0.9, 0, 0, 40)
CopyBtn.Position = UDim2.new(0.05, 0, 0.52, 0)
CopyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
CopyBtn.Text = "📋 Copy Full Data"
CopyBtn.TextColor3 = Color3.white
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.Parent = MainFrame
Instance.new("UICorner", CopyBtn)

-- =====================================================
-- الوظائف البرمجية
-- =====================================================

local isSelecting = false
local lastExtractedData = ""
local highlightedObject = nil

-- وظيفة للحصول على المسار الكامل لأي شيء في الـ UI
local function getFullPath(obj)
    local path = obj.Name
    local parent = obj.Parent
    while parent and parent ~= game do
        path = parent.Name .. "." .. path
        parent = parent.Parent
    end
    return "game." .. path
end

-- وظيفة لاستخراج كل المعلومات
local function extractData(obj)
    local data = "-- [ GUI EXTRACTED REPORT ] --\n"
    data = data .. "Name: " .. obj.Name .. "\n"
    data = data .. "Class: " .. obj.ClassName .. "\n"
    data = data .. "Path: " .. getFullPath(obj) .. "\n\n"
    
    data = data .. "-- [ PROPERTIES ] --\n"
    pcall(function() data = data .. "Size: " .. tostring(obj.Size) .. "\n" end)
    pcall(function() data = data .. "Position: " .. tostring(obj.Position) .. "\n" end)
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        data = data .. "Text: " .. obj.Text .. "\n"
    end

    -- البحث عن السكريبتات داخل هذا الـ UI
    data = data .. "\n-- [ SCRIPTS INSIDE ] --\n"
    local scripts = 0
    for _, v in pairs(obj:GetDescendants()) do
        if v:IsA("LocalScript") or v:IsA("ModuleScript") then
            scripts = scripts + 1
            data = data .. "-- Script: " .. v.Name .. " (" .. v.ClassName .. ")\n"
            local success, source = pcall(function() return v.Source end)
            if success and source ~= "" then
                data = data .. source .. "\n\n"
            else
                data = data .. "-- [Source Locked or Hidden]\n\n"
            end
        end
    end
    if scripts == 0 then data = data .. "No scripts found.\n" end
    
    return data
end

-- تفعيل وضع الاختيار
SelectBtn.MouseButton1Click:Connect(function()
    isSelecting = not isSelecting
    if isSelecting then
        SelectBtn.Text = "🔴 SELECTING... (Click UI)"
        Status.Text = "Move mouse over any UI element"
    else
        SelectBtn.Text = "🖱️ Click to Select UI"
        SelectionFrame.Visible = false
    end
end)

-- تتبع الماوس وتحديد الـ UI
RunService.RenderStepped:Connect(function()
    if isSelecting then
        local mousePos = UserInputService:GetMouseLocation()
        -- البحث عن كائنات GUI تحت الماوس
        local objects = PlayerGui:GetGuiObjectsAtPosition(mousePos.X, mousePos.Y)
        
        local found = nil
        for _, obj in pairs(objects) do
            -- تجاهل واجهة الأداة نفسها
            if not obj:IsDescendantOf(ScreenGui) then
                found = obj
                break
            end
        end
        
        if found then
            highlightedObject = found
            SelectionFrame.Visible = true
            SelectionFrame.Position = found.AbsolutePosition
            SelectionFrame.Size = UDim2.new(0, found.AbsoluteSize.X, 0, found.AbsoluteSize.Y)
        else
            SelectionFrame.Visible = false
        end
    end
end)

-- عند الضغط لاختيار الـ UI
UserInputService.InputBegan:Connect(function(input)
    if isSelecting and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        if highlightedObject then
            lastExtractedData = extractData(highlightedObject)
            Status.Text = "✅ Selected: " .. highlightedObject.Name
            isSelecting = false
            SelectBtn.Text = "🖱️ Click to Select UI"
            SelectionFrame.Visible = false
            print(lastExtractedData)
        end
    end
end)

-- نسخ البيانات
CopyBtn.MouseButton1Click:Connect(function()
    if lastExtractedData ~= "" then
        setclipboard(lastExtractedData)
        Status.Text = "📋 Copied to clipboard!"
    else
        Status.Text = "⚠️ Select UI first!"
    end
end)

print("✅ UI Picker Ready! Only for Screen Elements.")
