
if SERVER then
	AddCSLuaFile()	
end

SWEP.HoldType               = "normal"

if CLIENT then
   SWEP.PrintName           = "Psycho Transformer"
   SWEP.Slot                = 8
   SWEP.ViewModelFlip       = false
   SWEP.ViewModelFOV        = 90
   SWEP.DrawCrosshair       = false
	
   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = ""
   };

   SWEP.Icon                = "vgui/ttt/icon_pat"
   SWEP.IconLetter          = "j"

   function SWEP:Initialize()
		self:AddTTT2HUDHelp("Transform and Untransform into the psycho.")
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
SWEP.Primary.Delay          = 5
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
      self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	  if not IsValid(self:GetOwner()) then return end
      local coughPitch = math.Rand(5,10)
      local coughYaw = math.Rand(-5,5)
      self:GetOwner():ViewPunch(Angle( coughPitch, coughYaw, 0 ))
	  --check if already psycho
	  if self:GetOwner():HasEquipmentItem("item_psycho") then
	     --Remove items
		 --swap pm to original
		if SERVER then
			self:GetOwner():RemoveItem("item_psycho")
			self:GetOwner():RemoveItem("item_ttt_radar")
			self:GetOwner():SetModel(psyOriginalModel)
		end
	  else
		--if they aren't
		--give items
		--swap pm to crazy one
		if SERVER then
			self:GetOwner():GiveItem("item_psycho")
			self:GetOwner():GiveItem("item_ttt_radar")
			psyOriginalModel = self:GetOwner():GetModel()
			self:GetOwner():SetModel( "models/raincoat.mdl" )
		end
	  end
end


 -- -- give new alien model
	-- ply:SetModel( "models/player/raincoat.mdl" )