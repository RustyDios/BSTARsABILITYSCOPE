You created an XCOM 2 Mod Project!

Created for bstar by RustyDios

Adds a new console command that dumps a units info to the log
Based on code from https://steamcommunity.com/sharedfiles/filedetails/?id=1132188214 Xylth's Debugging Tools

You may want to use the command X2AllowSelectAll to be able to select enemy units
The command from this mod is DumpAbilitiesOfActiveUnit ... it will output to the log.
To aid Navigation in the log you can search for the following tokens;
	BSTARsSCOPE_BEGIN		this will take you to the beginning of each time you used the command
	BSTARsSCOPE_ABILITY		this takse you to the 'next' ability
	BSTARsSCOPE_EFFECTS		take you to the 'next' effects
	BSTARsSCOPE_KILLMAIL	the units kills
	BSTARsSCOPE_STATS		the units current stats
	BSTARsSCOPE_END			the end of a block
	
Added a new command AddLootToActiveUnit (optional bool AndDrop = false, optional bool WithPsi) that will output to the log
	BSTARsSCOPE_Loot		Separate command that rolls for loot , useful for checking a units loot options

Added a new command DumpAppearanceOfActiveUnit
	BSTARsSCOPE_Appearance	List of the units appearance settings, useful for checking what a unit looks like

//Added two new commands for refreshing a units kills/xp from the armory
//	BSTARsSCOPE_XPREFRESH	The unit that was refreshed 

==========================================================
STEAM DESC	https://steamcommunity.com/sharedfiles/filedetails/?id=2128067026
==========================================================
[h1]===== What is it? =====[/h1]
This mod adds an extra debugging tool, mainly for mod developers. 
It is not intended for regular players, but is harmless until invoked through the console.

[h1]===== What does it do? =====[/h1]
Adds a few new console commands that dumps a units info to the log. Can be used mid-tactical and mid-skirmish. 
The code uses the Selected Active Unit.

Mod is LOG heavy. It might slow down the game. It [b]will[/b] bloat your log fill each time a command is used. It will log as much information about the active units abilities, effects, kills, and stats as I could think of.

[h1]===== How does it do it? =====[/h1]

You may want to enable tabbing to ANY unit on the field using [b]X2AllowSelectAll[/b] before these.

The new commands are;
[code]
DumpAbilitiesOfActiveUnit
-- This command lists as much information about the abilities, effects, killmmail and stats as I could think of
[/code]
[code]
DumpAppearanceOfActiveUnit
-- This command lists all the appearance info of the unit
[/code]
[code]
AddLootToActiveUnit(bool AndDrop, bool WithPsi)
-- This command is useful for testing loot options for a unit. 
-- It forces a re-roll for timed/vulture loot, optionally with psi focus loot
-- Also optionally forces the loot to drop, so you don't actually have to kill the unit
[/code]
[h1]===== Compatibility/Issues =====[/h1]
It's a console command, it shouldn't break anything
It has zero overrides
Should be safe to add/remove mid campaign

Not designed for any other version than WOTC, your mileage with other XCOM2 variants may vary

[h1]===== Credits ====[/h1]
HEAVILY based on code found in [url=https://steamcommunity.com/sharedfiles/filedetails/?id=1132188214] Xylth's Debugging Tools [/url]

Permission granted for use by Xylth.

[h1]===== Thankyou To =====[/h1]
Mod created for bstar from the xcom modders discord. Some additional info added at request of SolarNougat.
As always I want to thank the kind and generous people of the discord for continued help and support.
[b]Many thanks[/b] to Xylth for the original code.

~ Enjoy [b]!![/b] and please [url=https://www.buymeacoffee.com/RustyDios] buy me a Cuppa Tea[/url]
===========================================
		[code]
		RefreshSoldierXPAndKills
		RefreshALLSoldierXPAndKills
		-- This command is activated from the armory screen and should reset the xp and kills needed for the current Rank
		[/code]

FULL LIST OF ABILITES OUTPUT
	Template and Fullname
		Ability Template Name
			Local name
			Image
			Charges
			Costs
				FreeCost
				ActionPointCost
					NumPoints
					TypicalWeaponCost
					ConsumeAll
					MoveCost
					AllowedTypes
					DoNotConsumeAllEffects
					DoNotConsumeAllAbilities
				Ammo
					Ammo
					UseLoadedAmmo
					ReturnError
				Charges
					NumCharges
					SharedAbilityCharges
					OnlyOnHit
				ReserveActionPointCost
					NumPoints
					AllowedTypes
			Cooldown
			HitCalc
			MissCalc
			TargetStyles
			Shooter and Target Conditions
				ExcludeEffects and Reason
				RequiredEffects and Reason
			Shooter and Target Effects
			Triggers
				EventObserverClass
				Method
				EventID
				EventFn
				Deferral
				Filter
				OverrideSource
				Priority
			EventListeners
				EventID
				EventFn
				Deferral
				Filter
		Effects
		Killmail
			Total Kills
			Unit Kills
			Unit Kill Count
			Kill Assists
			Rank Kills
			Covert Kills
			Bonus Kills
		Stats
			HP
			AIM
			DEFENSE
			WILL
			DODGE
			MOBILITY
			HACK
			HACK DEFENSE
			PSI OFFENSE
			ARMOUR
			SHIELDS
			FLANK CRIT
			FLANK AIM
			SIGHT RANGE
			DETECTION RADIUS

AND DONE :)

~ Enjoy					
