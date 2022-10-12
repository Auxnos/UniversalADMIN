local library = {}; do
	local gui = gui:Clone()
	gui.Parent = syn and game:GetService("CoreGui") or game:GetService("Players").LocalPlayer.PlayerGui
	gui.Enabled = false
	local tb = gui.Topbar
	local UIS = game:GetService("UserInputService")
	local OwOLibrary = {}
	function library:Set(tble)
		gui.Enabled = true;
		tb.Icon.Image = tble.Icon and string.format("rbxassetid://%s",tble.Icon) or "";
		delay(0.5,function()
			if tb.Icon.Image=="rbxassetid://0" or tb.Icon.Image=="" then
				tb.Label.Size,tb.Label.Position = UDim2.new(0.2,0,1,0),UDim2.new(0,0,0,0)
			end
		end)
		tb.Label.Text = tble.Name
		return OwOLibrary
	end
	local library = OwOLibrary
	function drag (Frame)
		local dragToggle = nil
		local dragSpeed = 0.23
		local dragInput = nil
		local dragStart = nil
		local dragPos = nil
		local startPos = nil
		local function updateInput(input)
			local Delta = input.Position - dragStart
			Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
		end
		Frame.InputBegan:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and UIS:GetFocusedTextBox() == nil then
				dragToggle = true
				dragStart = input.Position
				startPos = Frame.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragToggle = false
					end
				end)
			end
		end)
		Frame.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)
		game:GetService("UserInputService").InputChanged:Connect(function(input)
			if input == dragInput and dragToggle then
				updateInput(input)
			end
		end)
	end
	drag(gui.Topbar)
	local Templates = {
		SideButton = gui.Topbar.Base.Side.TemplateButton:Clone();
		ListTemplate = gui.Topbar.Base.Main.List:Clone(),
	}
	tb.Bar.Hide.TextButton.MouseButton1Down:Connect(function()
		if tb.Base.Visible then
			game:GetService("TweenService"):Create(tb.Bar.Hide.Hide,TweenInfo.new(0.1),{Rotation = 0}):Play()
		else
			game:GetService("TweenService"):Create(tb.Bar.Hide.Hide,TweenInfo.new(0.1),{Rotation = 180}):Play()
		end
		tb.Base.Visible = not tb.Base.Visible
	end)
	gui.Topbar.Base.Main.List:Destroy()
	gui.Topbar.Base.Side.TemplateButton:Destroy()
	local Created = 0
	local Lists = {}
	function library:CreateTab(text)
		Created += 1
		local SelfLibrary = {}
		local CreatedIndex = Created
		local Template = Templates.SideButton:Clone()
		Template.Parent = gui.Topbar.Base.Side;
		Template.Text = text
		Template.MouseButton1Down:Connect(function()
			for Name,List in next, Lists do
				if List.Main ~= text then
					List.List.Visible = false
				else
					List.List.Visible = true
				end
			end
		end)
		function SelfLibrary:AddSection(Name)
			local SectionLibrary = {}
			local List = Templates.ListTemplate:Clone()
			List.Parent = gui.Topbar.Base.Main
			if CreatedIndex == 1 then
				List.Visible = true
			else
				List.Visible = false
			end
			local Button = List.List.Button:Clone()
			List.List.Button:Destroy()
			List.List.Label.Text = Name
			function SectionLibrary:NewButton(name, toggled, func)
				local ButtonLibrary = {};
				ButtonLibrary.Enabled = toggled or false
				local Button = Button:Clone()
				Button.Parent = List.List
				Button.Text = name
				local Pressed = function(enabled)
					local enabled = typeof(enabled) == "boolean" and enabled or nil
					ButtonLibrary.Enabled = enabled or (not ButtonLibrary.Enabled)
					if ButtonLibrary.Enabled then
						Button.ToggleOff.Visible = false
						Button.ToggleOn.Visible = true
					else
						Button.ToggleOff.Visible = true
						Button.ToggleOn.Visible = false
					end
					func(ButtonLibrary.Enabled)
				end
				Button.MouseButton1Down:Connect(Pressed)
				function ButtonLibrary:Set(enabled)
					Pressed()
				end
				local toggledO = true
				function ButtonLibrary:Hide(t)
					toggledO = t and t or not toggledO
				end
				task.spawn(function()
					while task.wait(.1) do
						if not toggledO then
							Button.ToggleOff.Visible = false
							Button.ToggleOn.Visible = false
						end
					end
				end)
				return ButtonLibrary
			end
			function SectionLibrary:NewLabel(name)
				local TextLibrary = {};
				local Text = Button:Clone()
				Text.Parent = List.List
				Text.Text = name 
				Text.Active = false
				Text.ToggleOff:Destroy();
				Text.ToggleOn:Destroy();
				function TextLibrary:Set(text)
					Text.Text = text
				end
				return TextLibrary
			end
			SelfLibrary.Section = List
			Lists[Name] = {List = List, Main = text}
			return SectionLibrary
		end
		return SelfLibrary
	end
end
local Players = setmetatable(game:GetService("Players"):GetPlayers(), {})
return Library
