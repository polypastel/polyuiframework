--[[
	polypastel
--]]

local Connections = {}
local Menu = {}
Menu.__index = Menu

function Menu:OnOpen(menuData)
	Connections["Confirm"] = menuData.Display.Content.Confirm.MouseButton1Click:Connect(function()
		menuData:Toggle()
	end)
end

function Menu:OnClose(menuData)
	for _, v in pairs(Connections) do
		print("t")
		v:Disconnect()
	end
end

return Menu
