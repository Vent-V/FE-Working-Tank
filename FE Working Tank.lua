
local RS = game:GetService('ReplicatedStorage')
local TFE = RS:FindFirstChild('TankFireEvent')
if not TFE then
	TFE = Instance.new('RemoteEvent')
	TFE.Name = 'TankFireEvent'
	TFE.Parent = RS
end

local function TankFired(player, action, parts, v1,v2,v3,v4,v5)
	if not action then return end
	
	if action == 'RotateTurret' then
		local elevation = v1
		local rotation = v2
		parts.MantletBase.MainGunWeld.C1 = CFrame.new(0,0,0) * CFrame.fromEulerAnglesXYZ(0, elevation, 0);
		parts.TurretRing2.TurretRingWeld.C1 = CFrame.new(0,0,0.8) * CFrame.fromEulerAnglesXYZ(0, 0, rotation); 
	elseif action == 'Fire' then
		local currRound = v1
		local APAmmo = v2
		local HEAmmo = v3
		local tankStats = v4
		if currRound.Value == "AP" and APAmmo.Value <= 0 then return end
		if currRound.Value == "HE" and HEAmmo.Value <= 0 then return end
			
		if currRound.Value == "AP" then
			APAmmo.Value = APAmmo.Value - 1;
		else
			HEAmmo.Value = HEAmmo.Value - 1;
		end
		
		local fireScript = tankStats["Fire" .. currRound.Value]:clone();
		fireScript.Parent = parts;
		fireScript.Disabled = false;
	elseif action == 'FireMinigun' then
		local tankStats = v1
		local MGDamage = v2
		local tool = v3
		local rayPart = Instance.new("Part")
		rayPart.Name			= "MG Ray"
		rayPart.Transparency	= .5
		rayPart.Anchored		= true
		rayPart.CanCollide		= false
		rayPart.TopSurface		= Enum.SurfaceType.Smooth
		rayPart.BottomSurface	= Enum.SurfaceType.Smooth
		rayPart.formFactor		= Enum.FormFactor.Custom
		rayPart.BrickColor		= BrickColor.new("Bright yellow")
		rayPart.Reflectance		= 0
		rayPart.Material = Enum.Material.SmoothPlastic
		
		local MGAmmo = tankStats.MGAmmo;
		if MGAmmo.Value <= 0 then
			return false;
		end;
		
		local machineGun = parts.Parent.Gun.Coax
		local machineGun2 = parts.Parent.Gun:FindFirstChild('Coax2')
		
		local PL				= Instance.new("PointLight")
		PL.Parent				= machineGun
		PL.Brightness			= 50
		PL.Color				= Color3.new(255, 255, 0)
		PL.Range				= 15
		PL.Shadows				= true
		
		MGAmmo.Value = MGAmmo.Value - 1;
		machineGun.Sound:Play();
		
		local offset = (parts.Parent.Gun.Muzzle.CFrame * CFrame.new(math.random(-5,5)/5,100,math.random(-5,5)/5).p
						- parts.Parent.Gun.Muzzle.Position).unit * 999;
		local ray = Ray.new(machineGun.Position, offset);
		
		local hit, position = workspace:FindPartOnRay(ray, parts.Parent);
		if hit and hit.Parent and hit.Parent:FindFirstChild('Humanoid') then -- Leaderboard Supported
			if tool.Parent.Parent:FindFirstChild('leaderstats') then
				local player = game.Players:GetPlayerFromCharacter(hit.Parent);
				local DriverKOs = tool.Parent.Parent.leaderstats:findFirstChild("KOs")
				local humanoid = hit.Parent.Humanoid
				if player and humanoid then
					--if player.TeamColor ~= game.Players.LocalPlayer.TeamColor or not player.Team or not game.Players.LocalPlayer.Team then --Not a teammate
						if humanoid.Health > 0 then
							humanoid:takeDamage(MGDamage);
							if humanoid.Health <=0 then
								DriverKOs.Value = DriverKOs.Value + 1
							end
						end
					--end
				elseif humanoid then
					humanoid:takeDamage(MGDamage)
				end	
			else
				local humanoid = hit.Parent.Humanoid
				humanoid:takeDamage(MGDamage)
			end
		end
		local distance = (position - machineGun.Position).magnitude;
		
		local rayPart	= rayPart:clone();
		rayPart.Size	= Vector3.new(.2, distance, .2);
		rayPart.CFrame	= CFrame.new(position, machineGun.Position)
							* CFrame.new(0, 0, -distance/2)
							* CFrame.Angles(math.rad(90),0,0);
		rayPart.Parent	= workspace;
		game:GetService('Debris'):AddItem(rayPart, .03)
		game:GetService('Debris'):AddItem(PL, .03)
		
		local MGFlash =	parts.Parent.Gun.Coax.GUI:clone()
		MGFlash.Flash.Rotation = math.random(0,360)
	   	MGFlash.Enabled = true
		game:GetService('Debris'):AddItem(MGFlash,.01)
		
		if machineGun2 then
			local PL				= Instance.new("PointLight")
			PL.Parent				= machineGun2
			PL.Brightness			= 50
			PL.Color				= Color3.new(255, 255, 0)
			PL.Range				= 15
			PL.Shadows				= true
			
			MGAmmo.Value = MGAmmo.Value - 1;
			machineGun2.Sound:Play();
			
			local offset = (parts.Parent.Gun.Muzzle.CFrame * CFrame.new(math.random(-5,5)/5,100,math.random(-5,5)/5).p
							- parts.Parent.Gun.Muzzle.Position).unit * 999;
			local ray = Ray.new(machineGun2.Position, offset);
			
			local hit, position = workspace:FindPartOnRay(ray, parts.Parent);
			if hit and hit.Parent and hit.Parent:FindFirstChild('Humanoid') then -- Leaderboard Supported
				if tool.Parent.Parent:FindFirstChild('leaderstats') then
					local player = game.Players:GetPlayerFromCharacter(hit.Parent);
					local DriverKOs = tool.Parent.Parent.leaderstats:findFirstChild("KOs")
					local humanoid = hit.Parent.Humanoid
					if player and humanoid then
						--if player.TeamColor ~= game.Players.LocalPlayer.TeamColor or not player.Team or not game.Players.LocalPlayer.Team then --Not a teammate
							if humanoid.Health > 0 then
								humanoid:takeDamage(MGDamage);
								if humanoid.Health <=0 then
									DriverKOs.Value = DriverKOs.Value + 1
								end
							end
						--end
					elseif humanoid then
						humanoid:takeDamage(MGDamage)
					end	
				else
					local humanoid = hit.Parent.Humanoid
					humanoid:takeDamage(MGDamage)
				end
			end
			local distance = (position - machineGun2.Position).magnitude;
			
			local rayPart	= rayPart:clone();
			rayPart.Size	= Vector3.new(.2, distance, .2);
			rayPart.CFrame	= CFrame.new(position, machineGun2.Position)
								* CFrame.new(0, 0, -distance/2)
								* CFrame.Angles(math.rad(90),0,0);
			rayPart.Parent	= workspace;
			game:GetService('Debris'):AddItem(rayPart, .03)
			game:GetService('Debris'):AddItem(PL, .03)
			
			local MGFlash =	parts.Parent.Gun.Coax2.GUI:clone()
			MGFlash.Flash.Rotation = math.random(0,360)
			MGFlash.Parent = parts.Parent.Gun.HullMG
		   	MGFlash.Enabled = true
			game:GetService('Debris'):AddItem(MGFlash,.01)
		end
	end
end














TFE.OnServerEvent:Connect(TankFired)