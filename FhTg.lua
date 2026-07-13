-- =====================================================
-- 🛠 GUI PICKER & EXTRACTOR (FIXED VERSION)
-- =====================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local LocalPlayer = Players.LocalPlayer

-- إنشاء الواجهة الخاصة بالأداة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BetterGuiExtractor"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999 -- لضمان ظهورها فوق كل شيء

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 160)
MainFrame.Position = UDim2.new(0.5, -110, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- تفعيل السحب
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "🛠 GUI EXTRACTOR V2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = MainFrame

-- زر الاختيار
local SelectBtn = Instance.new("TextButton")
SelectBtn.Size = UDim2.new(0.9, 0, 0, 40)
SelectBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
SelectBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
SelectBtn.Text = "🎯 اضغط هنا ثم اختر GUI"
SelectBtn.TextColor3 = Color3.white
SelectBtn.Font = Enum.Font.GothamBold
SelectBtn.Parent = MainFrame
Instance.new("UICorner", SelectBtn)

-- زر النسخ
local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0.9, 0, 0, 40)
CopyBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
CopyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
CopyBtn.Text = "📋 نسخ البيانات المستخرجة"
CopyBtn.TextColor3 = Color3.white
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.Parent = MainFrame
Instance.new("UICorner", CopyBtn)

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 20)
Status.Position = UDim2.new(0, 0, 0.85, 0)
Status.Text = "انتظار الاختيار..."
Status.TextColor3 = Color3.fromRGB(200, 200, 200)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Gotham
Status.TextSize = 12
Status.Parent = MainFrame

-- =====================================================
-- منطق الاستخراج (Extraction Logic)
-- =====================================================
local extractedData = ""
local isSelecting = false

local function getGuiPath(obj)
    local path = obj.Name
    local parent = obj.Parent
    while parent and parent ~= game do
        path = parent.Name .. "." .. path
        parent = parent.Parent
    end
    return path
end

local function extractFullInfo(target)
    local str = "-- [ GUI EXTRACTION REPORT ] --\n"
    str = str .. "Target Name: " .. target.Name .. "\n"
    str = str .. "Class: " .. target.ClassName .. "\n"
    str = str .. "Full Path: game." .. getGuiPath(target) .. "\n\n"
    
    str = str .. "-- [ PROPERTIES ] --\n"
    pcall(function() str = str .. "Position: " .. tostring(target.Position) .. "\n" end)
    pcall(function() str = str .. "Size: " .. tostring(target.Size) .. "\n" end)
    pcall(function() str = str .. "Visible: " .. tostring(target.Visible) .. "\n" end)
    
    -- استخراج السكريبتات
    str = str .. "\n-- [ SCRIPTS FOUND ] --\n"
    local foundScripts = 0
    for _, item in pairs(target:GetDescendants()) do
        if item:IsA("LocalScript") or item:IsA("ModuleScript") then
            foundScripts = foundScripts + 1
            str = str .. "\n-- Script: " .. item.Name .. " (" .. item.ClassName .. ")\n"
            -- ملاحظة: خاصية .Source تعمل فقط في المحاكيات (Executors) القوية
            local success, source = pcall(function() return item.Source end)
            if success and source ~= "" then
                str = str .. source .. "\n"
            else
                str = str .. "-- [Source Hidden or Not Accessible]\n"
            end
        end
    end
    if foundScripts == 0 then str = str .. "No scripts found.\n" end

    -- استخراج الأزرار
    str = str .. "\n-- [ BUTTONS & INTERACTABLES ] --\n"
    for _, item in pairs(target:GetDescendants()) do
        if item:IsA("TextButton") or item:IsA("ImageButton") then
            str = str .. "Button: " .. item.Name .. " | Text: " .. (item:IsA("TextButton") and item.Text or "N/A") .. "\n"
        end
    end
    
    return str
end

-- =====================================================
-- تفعيل الاختيار (Selection Process)
-- =====================================================
SelectBtn.MouseButton1Click:Connect(function()
    isSelecting = true
    Status.Text = "🔴 اضغط الآن على أي مكان في الواجهة!"
    Status.TextColor3 = Color3.fromRGB(255, 100, 100)
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if isSelecting and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        local pos = input.Position
        -- البحث عن كائنات الـ GUI في موقع الضغطة
        local guis = LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(pos.X, pos.Y)
        
        local target = nil
        for _, v in pairs(guis) do
            -- نتأكد أنه لا يختار واجهة الأداة نفسها
            if not v:IsDescendantOf(ScreenGui) then
                target = v
                break
            end
        end
        
        if target then
            -- نحاول الصعود لأعلى حاجب (Frame) أو (ScreenGui) للحصول على المعلومات كاملة
            local root = target
            if root.Parent:IsA("Frame") or root.Parent:IsA("ScrollingFrame") then
                root = root.Parent
            end
            
            extractedData = extractFullInfo(root)
            Status.Text = "✅ تم استخراج: " .. root.Name
            Status.TextColor3 = Color3.fromRGB(0, 255, 0)
            isSelecting = false
            print(extractedData) -- طباعة في الكونسول للتأكيد
        else
            Status.Text = "❌ لم يتم العثور على GUI. حاول مجدداً."
        end
    end
end)

CopyBtn.MouseButton1Click:Connect(function()
    if extractedData ~= "" then
        if setclipboard then
            setclipboard(extractedData)
            Status.Text = "📋 تم النسخ إلى الحافظة!"
        else
            Status.Text = "❌ جهازك لا يدعم النسخ التلقائي."
        end
    else
        Status.Text = "⚠️ اختر GUI أولاً!"
    end
end)

print("✅ GUI Extractor V2 Loaded!")
