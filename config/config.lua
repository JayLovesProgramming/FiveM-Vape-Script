

Config = {
	-- The key used to take a hit of the vape (51) "E" by default
	TakeAHitButton = 51,
	-- The ey used to reset to the resting vape position (58)"G" by default
	ResetVapeButton = 58,
	-- The amount of time (millisseconds) you will need to hold the button in order to vape
	HowLongShouldYouHoldTheButton = 250,
	-- Size of the clouds that the vape produces (0.5 by default)
	SmokeSize = 0.5,
	-- The chance of your vape blowing up (A very very low chance by default)
	FailureOdds = 10594, -- 10594 = 0.0001% chance
	-- The amount of time (millisseconds) the player has to wait before the can hit the vape again (4000 by default)
	VapeCoolDownTime = 4000,
	-- The amount of time (millisseconds) the smoke/clouds from the vape will linger in the air (2800 by default)
	VapeHangTime = 2800,
	-- Whether or not you want ace permissions to be enabled
	-- // false = Everyone Can vape
	-- // if VapePermission = true then set PermissionsGroup below
	VapePermission = false,
	-- Ace permissions group to allow access. **REQUIRED IF YOU HAVE PERMISSIONS ENABLED**
	PermissionsGroup = "ADD_ACE_GROUP_HERE",
	-- If permissions are enabled you can set the denied access message here. **REQUIRED IF YOU HAVE PERMISSIONS ENABLED**
	InsufficientMessage = "You do not have permission to do this",
	-- This is only used if something is broken. It enables commands to test the script
	-- // COMMAND 1 : /testvapesound
	-- // COMMAND 2 : /testvapeexplosion
	Debug = false,
	-- The Transparency of the help text when it starts. (0) by default. Just leave this alone...
	HelpTextStartingAlpha = 0,
	-- Hold long in (ms) will the help message appear for. (20000) by default.
	-- Tip draw text that is shown above the players head for HelpTextLength
	HoldEtoTakeAHitText = "~w~Hold ~b~E~w~ to take a hit from the vape",
	HoldGtoResetVape = "~w~Hold ~b~G~wc~ to reset the vape",
	-- Size of the text drawn above the players head (0.38 by default)
	VapeDrawTextScaleAboveHead = 0.38,
}