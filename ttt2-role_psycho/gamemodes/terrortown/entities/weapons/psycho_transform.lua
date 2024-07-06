
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
SWEP.Primary.Delay          = GetConVar("ttt2_psy_transform_delay"):GetInt()
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
local psyOriginalModel
function SWEP:PrimaryAttack()
      --update delay in the case it was changed
	  self.Primary.Delay = GetConVar("ttt2_psy_transform_delay"):GetInt()
	  self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	  if not IsValid(self:GetOwner()) then return end
      local transformPitch = math.Rand(5,10)
      local transformYaw = math.Rand(-5,5)
      self:GetOwner():ViewPunch(Angle( transformPitch, transformYaw, 0 ))
	  --check if already psycho
	  if self:GetOwner():HasEquipmentItem("item_psycho") then
		if SERVER then
			--if so, remove psycho items, and change pm
			self:GetOwner():RemoveItem("item_psycho")
			self:GetOwner():RemoveItem("item_ttt_radar")
			self:GetOwner():SetModel(psyOriginalModel)
		end
		--play suit out sound only to client
		if CLIENT then
			self:GetOwner():EmitSound("suitout.wav")
		end
		STATUS:RemoveStatus(self:GetOwner(), "ttt2_psy_dmg_status")
	  else
		if SERVER then
			--give psycho items, and change pm if not psycho
			self:GetOwner():GiveItem("item_psycho")
			self:GetOwner():GiveItem("item_ttt_radar")
			psyOriginalModel = self:GetOwner():GetModel()
			self:GetOwner():SetModel( "models/raincoat.mdl" )
		end
		--play suit up sound only to client
		if CLIENT then
			self:GetOwner():EmitSound("suitup.wav")
		end
		STATUS:AddStatus(self:GetOwner(), "ttt2_psy_dmg_status", false)
	  end
	  STATUS:AddTimedStatus(self:GetOwner(), "ttt2_psy_transform_cooldown", GetConVar("ttt2_psy_transform_delay"):GetInt(), true)
end

--Timed status for cooldown	
if CLIENT then
    hook.Add("Initialize", "ttt2_psy_init", function()
		
		STATUS:RegisterStatus("ttt2_psy_dmg_status", {
			hud = Material("vgui/ttt/icons/dmgup.png"),
			type = "good",
			name = "Psycho Damage Up",
			sidebarDescription = "You have transformed and received a damage up!"
		})
		
		STATUS:RegisterStatus("ttt2_psy_transform_cooldown", {
			hud = Material("vgui/ttt/icons/timer.png"),
			type = "bad",
			name = "Psycho Delay",
			sidebarDescription = "You have transformed/untransformed and the gadget is on cooldown"
		})
	end)
end