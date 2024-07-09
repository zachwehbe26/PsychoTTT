
if SERVER then
	AddCSLuaFile()	
end

SWEP.HoldType               = "normal"

if CLIENT then
   SWEP.PrintName           = "psycho_gadget"
   SWEP.Slot                = 8
   SWEP.ViewModelFlip       = false
   SWEP.ViewModelFOV        = 90
   SWEP.DrawCrosshair       = false
	
   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = ""
   };

   SWEP.Icon                = "vgui/ttt/icon_psy"
   SWEP.IconLetter          = "j"

   function SWEP:Initialize()
		self:AddTTT2HUDHelp("Transform and untransform into the psycho.")
	end
end

SWEP.Base                   = "weapon_tttbase"

SWEP.UseHands               = true
SWEP.ViewModel              = "models/weapons/c_arms.mdl"
SWEP.WorldModel             = ""

SWEP.Primary.Damage         = 0
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Delay          = 0
SWEP.Primary.Ammo           = "none"

SWEP.Kind                   = WEAPON_CLASS
SWEP.AllowDrop              = false -- Is the player able to drop the swep

SWEP.IsSilent               = false

-- Pull out faster than standard guns
SWEP.DeploySpeed            = 2

--Removes the SWEP on death or drop
function SWEP:OnDrop()
	self:Remove()
end

-- Override original primary attack
-- Only transform when cooldown is off. User can return back to normal at anytime cooldown or not
local psyOriginalModel
function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	if not IsValid(self:GetOwner()) then return end
	if not timer.Exists("ttt2_transform_cooldown_timer") and not self:GetOwner():HasEquipmentItem("item_psycho") then
		--punch the users camera for cinematic effect
		local transformPitch = math.Rand(5,10)
		local transformYaw = math.Rand(-5,5)
		self:GetOwner():ViewPunch(Angle( transformPitch, transformYaw, 0 ))
		if SERVER then
			--give user all psycho items and switch pm
			self:GetOwner():GiveItem("item_psycho")
			self:GetOwner():GiveItem("item_ttt_radar")
			psyOriginalModel = self:GetOwner():GetModel()
			self:GetOwner():SetModel( "models/raincoat.mdl" )
			--toggle disguiser on
			self:GetOwner():SetNWBool("disguised", true)
		end
		--play suit up sound only to client
		if CLIENT then
			self:GetOwner():EmitSound("suitup.wav")
		end
		STATUS:AddStatus(self:GetOwner(), "ttt2_psy_dmg_status", false)
		--start cooldowns for when the user transforms again
		STATUS:AddTimedStatus(self:GetOwner(), "ttt2_psy_transform_cooldown", GetConVar("ttt2_psy_transform_delay"):GetInt(), true)
		timer.Create("ttt2_transform_cooldown_timer",GetConVar("ttt2_psy_transform_delay"):GetInt(), 1, function() end)
	elseif self:GetOwner():HasEquipmentItem("item_psycho") then
		local transformPitch = math.Rand(5,10)
		local transformYaw = math.Rand(-5,5)
		self:GetOwner():ViewPunch(Angle( transformPitch, transformYaw, 0 ))
		if SERVER then
			self:GetOwner():RemoveItem("item_psycho")
			self:GetOwner():RemoveItem("item_ttt_radar")
			self:GetOwner():SetModel(psyOriginalModel)
			--toggle disguiser off
			self:GetOwner():SetNWBool("disguised", false)
		end
		--play suit out sound only to client
		if CLIENT then
			self:GetOwner():EmitSound("suitout.wav")
		end
		STATUS:RemoveStatus(self:GetOwner(), "ttt2_psy_dmg_status")
	end
end

if CLIENT then
	--Timed status for cooldown	
    hook.Add("Initialize", "ttt2_psy_init", function()
		
		STATUS:RegisterStatus("ttt2_psy_dmg_status", {
			hud = Material("vgui/ttt/icons/dmgup.png"),
			type = "good",
			name = "Psycho Damage Up",
			sidebarDescription = "status_psy_dmg_bonus"
		})
		
		STATUS:RegisterStatus("ttt2_psy_transform_cooldown", {
			hud = Material("vgui/ttt/icons/timer.png"),
			type = "bad",
			name = "Psycho Delay",
			sidebarDescription = "status_psy_transform_cooldown"
		})
	end)
	--Remove timers on round end and start
	hook.Add("TTTBeginRound", "remove_timers_on_prepare", function()
		timer.Remove("ttt2_transform_cooldown_timer")
		STATUS:RemoveStatus("ttt2_psy_transform_cooldown")
	end)
	hook.Add("TTTEndRound", "remove_timers_on_prepare", function()
		timer.Remove("ttt2_transform_cooldown_timer")
		STATUS:RemoveStatus("ttt2_psy_transform_cooldown")
	end)
end

