//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_BSTARsABILITYSCOPE.uc                                    
//           
//  Created by	RustyDios
//	Created on	12/06/20	08:30
//	Updated on	18/09/20	08:00
//
//	Adds a new console command to dump unit info to the log
//    class'BSTARSTacticalCheatManager'.exec.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_BSTARsABILITYSCOPE extends X2DownloadableContentInfo within XComTacticalController;

static event OnLoadedSavedGame(){}

static event InstallNewCampaign(XComGameState StartState){}

//class'XComTacticalCheatManager'.static

exec function DumpAbilitiesOfActiveUnit()
{
	local XComGameState         NewGameState;
	local XComGameState_Unit    Unit;
	local XGUnit				ActiveUnit;

	local XComGameState_Ability AbilityState;
	local StateObjectReference AbilityRef;

	local StateObjectReference EffectRef;
	local XComGameState_Effect EffectState;

	local string KillsInfo;
	local string StatsInfo;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: DumpAbilitiesInfo");

	ActiveUnit = XComTacticalController(GetALocalPlayerController()).GetActiveUnit();

	if (ActiveUnit == none)
	{
		`log("ERROR :: Could not get a unit for object ID :: ABORT " ,, 'BSTARsSCOPE_ERROR');
		return;
	}

    if(ActiveUnit != none)
	{
		Unit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ActiveUnit.ObjectID));
        `log("==============================================================================",,'BSTARsSCOPE_BEGIN');
        `log("======================"@Unit.GetMyTemplateName() @Unit.GetFullName() @"======================================",,'BSTARsSCOPE_BEGIN');
        `log("==============================================================================",,'BSTARsSCOPE_BEGIN');

        foreach Unit.Abilities(AbilityRef)
		{
			AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AbilityRef.ObjectID));
			if (AbilityState != none)
			{
				`log("========================= NEW ABILITY ==========================================",,'BSTARsSCOPE_ABILITY');
				DumpAbilityTemplate(AbilityState.GetMyTemplateName());
				`log("==============================================================================",,'BSTARsSCOPE');
			}   
		}
		`log("================================== END OF ABILITIES ===================================",,'BSTARsSCOPE');
		`log("================================== EFFECTS ===================================",,'BSTARsSCOPE_EFFECTS');

		foreach Unit.AffectedByEffects(EffectRef)
		{
			EffectState = XComGameState_Effect(`XCOMHISTORY.GetGameStateForObjectID(EffectRef.ObjectID));
			if (EffectState != none)
			{
				`log("Effect" @ EffectState.GetX2Effect().EffectName @ "on state object ID" @ EffectState.ObjectID,,'BSTARsSCOPE');
			}
		}
		`log("================================== END OF EFFECTS ===================================",,'BSTARsSCOPE');
		`log("================================== KILLMAILS ===================================",,'BSTARsSCOPE_KILLMAIL');
				KillsInfo  = "\nTotal Kills				:: " $ Unit.GetTotalNumKills();
				KillsInfo $= "\nUnit Kills				:: " $ Unit.GetNumKills();
				KillsInfo $= "\nUnit Kill Count			:: " $ Unit.KillCount;
				KillsInfo $= "\nKillsFromAssists		:: " $ Unit.GetNumKillsFromAssists();
				KillsInfo $= "\nStarting Rank Kills		:: " $ class'X2ExperienceConfig'.static.GetRequiredKills(Unit.StartingRank);
				KillsInfo $= "\nCovert Action Kills		:: " $ Unit.NonTacticalKills;
				KillsInfo $= "\nDeeper Learning Kills	:: " $ Unit.BonusKills;
		`log(KillsInfo,,'BSTARsSCOPE');
		`log("================================== END KILLMAILS ===================================",,'BSTARsSCOPE');
		`log("================================== STATS ===================================",,'BSTARsSCOPE_STATS');
		//intentionally out of alignment here to align in the log
				StatsInfo  ="\nHP				:: " @ Unit.GetCurrentStat(eStat_HP);
				StatsInfo $="\nAIM	 			:: " @ Unit.GetCurrentStat(eStat_Offense);
				StatsInfo $="\nDEFENSE			:: " @ Unit.GetCurrentStat(eStat_Defense);
				StatsInfo $="\nDODGE			:: " @ Unit.GetCurrentStat(eStat_Dodge);
				StatsInfo $="\nMOBILITY		:: " @ Unit.GetCurrentStat(eStat_Mobility);
				StatsInfo $="\nHACK			:: " @ Unit.GetCurrentStat(eStat_Hacking);
				StatsInfo $="\nHACK DEFENSE	:: " @ Unit.GetCurrentStat(eStat_HackDefense);
				Statsinfo $="\nWILL			:: " @ Unit.GetCurrentStat(eStat_Will);
				StatsInfo $="\nPSI OFFENSE		:: " @ Unit.GetCurrentStat(eStat_PsiOffense);
				StatsInfo $="\nARMOUR			:: " @ Unit.GetCurrentStat(eStat_ArmorMitigation) @ " PIPS AT "@ Unit.GetCurrentStat(eStat_ArmorChance) @ " % CHANCE ";
				StatsInfo $="\nSHIELDS	 		:: " @ Unit.GetCurrentStat(eStat_ShieldHP);
				StatsInfo $="\nFLANK CRIT		:: " @ Unit.GetCurrentStat(eStat_FlankingCritChance);
				StatsInfo $="\nFLANK AIM 		:: " @ Unit.GetCurrentStat(eStat_FlankingAimBonus);
				StatsInfo $="\nSIGHT			:: " @ Unit.GetCurrentStat(eStat_SightRadius) @ "METERS "@ Unit.GetCurrentStat(eStat_SightRadius)/1.5 @ "TILES ";
				StatsInfo $="\nDETECTION		:: " @ Unit.GetCurrentStat(eStat_DetectionRadius) @ "METERS "@ Unit.GetCurrentStat(eStat_DetectionRadius)/1.5 @ "TILES ";
		`log( StatsInfo,,'BSTARsSCOPE');
		`log("================================== END STATS ===================================",,'BSTARsSCOPE_STATS');
    }

	SubmitNewGameState(NewGameState);

	`log("============ AND WE ARE FINALLY DONE===================",,'BSTARsSCOPE_END');
	`log("============ BSTARsSCOPE brought to you by RustyDios ===================",,'BSTARsSCOPE_END');
	`log("============ Hope your experience was enjoyable ===================",,'BSTARsSCOPE_END');
}

exec function DumpAbilityTemplate(name DataName)
{
	local X2AbilityTemplate Template;
	local X2AbilityCost Cost;
	local X2Condition Condition;
	local X2Effect Effect;
	local X2AbilityTrigger Trigger;
	local AbilityEventListener EventListener;

	Template = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(DataName);

	`Log("===" @ Template @ "===" @ Template.DataName @ "===",,'BSTARsSCOPE');
	`Log("LocalName:" @ Template.LocFriendlyName,,'BSTARsSCOPE');
	`Log("Image:" @ Template.IconImage ,,'BSTARsSCOPE');

	`Log("AbilityCharges:" @ Template.AbilityCharges,,'BSTARsSCOPE');
	foreach Template.AbilityCosts(Cost)
	{
		`Log("AbilityCosts:" @ Cost @ " (" $ Cost.class $ ")",,'BSTARsSCOPE');
		DumpCost(Cost);
	}

	`Log("AbilityCooldown:" @ Template.AbilityCooldown,,'BSTARsSCOPE');
	`Log("AbilityToHitCalc:" @ Template.AbilityToHitCalc,,'BSTARsSCOPE');
	`Log("AbilityToHitOwnerOnMissCalc:" @ Template.AbilityToHitOwnerOnMissCalc,,'BSTARsSCOPE');

	`Log("AbilityTargetStyle:" @ Template.AbilityTargetStyle,,'BSTARsSCOPE');
	`Log("AbilityMultiTargetStyle:" @ Template.AbilityMultiTargetStyle,,'BSTARsSCOPE');
	`Log("AbilityPassiveAOEStyle:" @ Template.AbilityPassiveAOEStyle,,'BSTARsSCOPE');

	foreach Template.AbilityShooterConditions(Condition)
	{
		`Log("AbilityShooterConditions:" @ Condition @ " (" $ Condition.class $ ")",,'BSTARsSCOPE');
		DumpCondition(Condition);
	}
	foreach Template.AbilityTargetConditions(Condition)
	{
		`Log("AbilityTargetConditions:" @ Condition @ " (" $ Condition.class $ ")",,'BSTARsSCOPE');
		DumpCondition(Condition);
	}
	foreach Template.AbilityMultiTargetConditions(Condition)
	{
		`Log("AbilityMultiTargetConditions:" @ Condition @ " (" $ Condition.class $ ")",,'BSTARsSCOPE');
		DumpCondition(Condition);
	}

	foreach Template.AbilityTargetEffects(Effect)
	{
		`Log("AbilityTargetEffects:" @ Effect @ " (" $ Effect.class $ ")",,'BSTARsSCOPE');
		DumpEffect(Effect);
	}
	foreach Template.AbilityMultiTargetEffects(Effect)
	{
		`Log("AbilityMultiTargetEffects:" @ Effect @ " (" $ Effect.class $ ")",,'BSTARsSCOPE');
		DumpEffect(Effect);
	}
	foreach Template.AbilityShooterEffects(Effect)
	{
		`Log("AbilityShooterEffects:" @ Effect @ " (" $ Effect.class $ ")",,'BSTARsSCOPE');
		DumpEffect(Effect);
	}

	foreach Template.AbilityTriggers(Trigger)
	{
		`Log("AbilityTriggers:" @ Trigger @ " (" $ Trigger.class $ ")",,'BSTARsSCOPE');
		DumpTrigger(Trigger);
	}
	
	foreach Template.AbilityEventListeners(EventListener)
	{
		`Log("AbilityEventListeners:",,'BSTARsSCOPE');
		`Log("  EventID:" @ EventListener.EventID,,'BSTARsSCOPE');
		`Log("  EventFn:" @ EventListener.EventFn,,'BSTARsSCOPE');
		`Log("  Deferral:" @ EventListener.Deferral,,'BSTARsSCOPE');
		`Log("  Filter:" @ EventListener.Filter,,'BSTARsSCOPE');
	}
}

static function DumpCost(X2AbilityCost Cost)
{
	local X2AbilityCost_ActionPoints ActionPointsCost;
	local X2AbilityCost_Ammo AmmoCost;
	local X2AbilityCost_Charges ChargesCost;
	local X2AbilityCost_ReserveActionPoints ReserveActionPointsCost;
	local name OtherName;

	`Log("  bFreeCost:" @ Cost.bFreeCost,,'BSTARsSCOPE');

	ActionPointsCost = X2AbilityCost_ActionPoints(Cost);
	if (ActionPointsCost != none)
	{
		`Log("  iNumPoints:" @ ActionPointsCost.iNumPoints,,'BSTARsSCOPE');
		`Log("  bAddWeaponTypicalCost:" @ ActionPointsCost.bAddWeaponTypicalCost,,'BSTARsSCOPE');
		`Log("  bConsumeAllPoints:" @ ActionPointsCost.bConsumeAllPoints,,'BSTARsSCOPE');
		`Log("  bMoveCost:" @ ActionPointsCost.bMoveCost,,'BSTARsSCOPE');
		foreach ActionPointsCost.AllowedTypes(OtherName)
			`Log("  AllowedType:" @ OtherName,,'BSTARsSCOPE');
		foreach ActionPointsCost.DoNotConsumeAllEffects(OtherName)
			`Log("  DoNotConsumeAllEffect:" @ OtherName,,'BSTARsSCOPE');
		foreach ActionPointsCost.DoNotConsumeAllSoldierAbilities(OtherName)
			`Log("  DoNotConsumeAllSoldierAbilities:" @ OtherName,,'BSTARsSCOPE');
	}

	AmmoCost = X2AbilityCost_Ammo(Cost);
	if (AmmoCost != none)
	{
		`Log("  iAmmo:" @ AmmoCost.iAmmo,,'BSTARsSCOPE');
		`Log("  UseLoadedAmmo:" @ AmmoCost.UseLoadedAmmo,,'BSTARsSCOPE');
		`Log("  bReturnChargesError:" @ AmmoCost.bReturnChargesError,,'BSTARsSCOPE');
	}

	ChargesCost = X2AbilityCost_Charges(Cost);
	if (ChargesCost != none)
	{
		`Log("  NumCharges:" @ ChargesCost.NumCharges,,'BSTARsSCOPE');
		foreach ChargesCost.SharedAbilityCharges(OtherName)
			`log("  SharedAbilityCharges:" @ OtherName,,'BSTARsSCOPE');
		`Log("  bOnlyOnHit:" @ ChargesCost.bOnlyOnHit,,'BSTARsSCOPE');
	}

	ReserveActionPointsCost = X2AbilityCost_ReserveActionPoints(Cost);
	if (ReserveActionPointsCost != none)
	{
		`Log("  iNumPoints:" @ ReserveActionPointsCost.iNumPoints,,'BSTARsSCOPE');
		foreach ReserveActionPointsCost.AllowedTypes(OtherName)
			`Log("  AllowedType:" @ OtherName,,'BSTARsSCOPE');
	}
}

static function DumpCondition(X2Condition Condition)
{
	local X2Condition_UnitEffects UnitEffectsCondition;
	local EffectReason Effect;

	UnitEffectsCondition = X2Condition_UnitEffects(Condition);
	if (UnitEffectsCondition != none)
	{
		foreach UnitEffectsCondition.ExcludeEffects(Effect)
		{
			`Log("  ExcludeEffects:" @ Effect.EffectName $ "," @ Effect.Reason,,'BSTARsSCOPE');
		}
		foreach UnitEffectsCondition.RequireEffects(Effect)
		{
			`Log("  RequiredEffects:" @ Effect.EffectName $ "," @ Effect.Reason,,'BSTARsSCOPE');
		}
	}
}

static function DumpEffect(X2Effect Effect)
{

}

static function DumpTrigger(X2AbilityTrigger Trigger)
{
	local X2AbilityTrigger_Event EventTrigger;
	local X2AbilityTrigger_EventListener EventListenerTrigger;

	EventTrigger = X2AbilityTrigger_Event(Trigger);
	if (EventTrigger != none)
	{
		`Log("  EventObserverClass:" @ EventTrigger.EventObserverClass,,'BSTARsSCOPE');
		`Log("  MethodName:" @ EventTrigger.MethodName,,'BSTARsSCOPE');
	}

	EventListenerTrigger = X2AbilityTrigger_EventListener(Trigger);
	if (EventListenerTrigger != none)
	{
		`Log("  EventID:" @ EventListenerTrigger.ListenerData.EventID,,'BSTARsSCOPE');
		`Log("  EventFn:" @ EventListenerTrigger.ListenerData.EventFn,,'BSTARsSCOPE');
		`Log("  Deferral:" @ EventListenerTrigger.ListenerData.Deferral,,'BSTARsSCOPE');
		`Log("  Filter:" @ EventListenerTrigger.ListenerData.Filter,,'BSTARsSCOPE');
		`Log("  OverrideListenerSource:" @ EventListenerTrigger.ListenerData.OverrideListenerSource,,'BSTARsSCOPE');
		`Log("  Priority:" @ EventListenerTrigger.ListenerData.Priority,,'BSTARsSCOPE');	
	}
}

//=====================================================================

exec function AddLootToActiveUnit(optional bool AndDrop = false, optional bool WithPsi = false)
{
	local XComGameState			NewGameState;
	local XComGameState_Unit	NewUnitState;
	local XComGameState_Unit	Unit;
	local XGUnit				ActiveUnit;

	local array<XComGameState_Item> Items;
	local X2LootTableManager LootManager;

	LootManager = class'X2LootTableManager'.static.GetLootTableManager();

	ActiveUnit = XComTacticalController(GetALocalPlayerController()).GetActiveUnit();

	//Unit = GetClosestUnitToCursor(true, false);
	if (ActiveUnit == none)
	{
		`log("ERROR :: Could not get a unit for object ID :: ABORT " ,, 'BSTARsSCOPE_Loot');
		return;
	}

	if(ActiveUnit != none)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: Give Timed Loot on Unit ");

		Unit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ActiveUnit.ObjectID));

        `log("==============================================================================",,'BSTARsSCOPE_Loot');
        `log("======================"@Unit.GetMyTemplateName() @Unit.GetFullName() @"======================================",,'BSTARsSCOPE_Loot');
        `log("==============================================================================",,'BSTARsSCOPE_Loot');

		NewUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', Unit.ObjectID));
		NewUnitState.RollForTimedLoot();
		SubmitNewGameState(NewGameState);

		if (WithPsi)
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: Give Timed Psi Loot on Unit ");
			NewUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', Unit.ObjectID));
			NewUnitState.RollForSpecialLoot();
			SubmitNewGameState(NewGameState);
		}

        `log("==============================================================================",,'BSTARsSCOPE_Loot');
        `log("===="@LootManager.LootResultsToString(NewUnitState.PendingLoot) @"====",,'BSTARsSCOPE_Loot');
        `log("==============================================================================",,'BSTARsSCOPE_Loot');

		if (AndDrop)
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: Drop Timed Loot on Unit ");
			NewUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', Unit.ObjectID));

			Items = NewUnitState.GetAllItemsInSlot(eInvSlot_Backpack, NewGameState);

			class'XComGameState_LootDrop'.static.CreateLootDrop(NewGameState, Items, self, false);

			NewUnitState.MakeAvailableLoot(NewGameState);

			SubmitNewGameState(NewGameState);

	        `log("=========== Pending Loot was Forced To Drop =============================",,'BSTARsSCOPE_Loot');

		}

        `log("==============================================================================",,'BSTARsSCOPE_Loot');
	}
}

//=====================================================================

exec function DumpAppearanceOfActiveUnit()
{
	local XComGameState         NewGameState;
	local XComGameState_Unit    Unit;
	local XGUnit				ActiveUnit;

	local string AppearanceInfo;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: DumpAppearanceInfo");

	ActiveUnit = XComTacticalController(GetALocalPlayerController()).GetActiveUnit();

	if (ActiveUnit == none)
	{
		`log("ERROR :: Could not get a unit for object ID :: ABORT " ,, 'BSTARsSCOPE_ERROR');
		return;
	}

    if(ActiveUnit != none)
	{
		Unit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ActiveUnit.ObjectID));

        `log("==============================================================================",,'BSTARsSCOPE_Appearance');
        `log("======================"@Unit.GetMyTemplateName() @Unit.GetFullName() @"======================================",,'BSTARsSCOPE_Appearance');
        `log("====================================== APPEARANCE =========================",,'BSTARsSCOPE_Appearance');
        `log("==============================================================================",,'BSTARsSCOPE_Appearance');
		//yes it's out of alignment here so it shows up in alignment in vscode for inspection
		AppearanceInfo $= "\n - - - - -	- - - - - - - - - - - - - - - - - - - - - - - - - - -	";
		AppearanceInfo  = "\n nmPawn 				::	" @ Unit.kAppearance.nmPawn;
		AppearanceInfo $= "\n iGender				::	" @ Unit.kAppearance.iGender;
		AppearanceInfo $= "\n iRace					::	" @ Unit.kAppearance.iRace;
		AppearanceInfo $= "\n iSkinColor				::	" @ Unit.kAppearance.iSkinColor;
		AppearanceInfo $= "\n nmFlag					::	" @ Unit.kAppearance.nmFlag;
		AppearanceInfo $= "\n - - - - -	- - - - - - - - - - - - - - - - - - - - - - - - - - -	";
		AppearanceInfo $= "\n iVoice					::	" @ Unit.kAppearance.iVoice;
		AppearanceInfo $= "\n nmVoice				::	" @ Unit.kAppearance.nmVoice;
		AppearanceInfo $= "\n nmLanguage				::	" @ Unit.kAppearance.nmLanguage;
		AppearanceInfo $= "\n iAttitude				::	" @ Unit.kAppearance.iAttitude;
		AppearanceInfo $= "\n - - - - -	- - - - - - - - - - - - - - - - - - - - - - - - - - -	";
		AppearanceInfo $= "\n nmHead					::	" @ Unit.kAppearance.nmHead;
		AppearanceInfo $= "\n nmHaircut				::	" @ Unit.kAppearance.nmHaircut;
		AppearanceInfo $= "\n iHairColor				::	" @ Unit.kAppearance.iHairColor;
		AppearanceInfo $= "\n iFacialHair			::	" @ Unit.kAppearance.iFacialHair;
		AppearanceInfo $= "\n nmBeard				::	" @ Unit.kAppearance.nmBeard;
		AppearanceInfo $= "\n nmEye					::	" @ Unit.kAppearance.nmEye;
		AppearanceInfo $= "\n iEyeColor				::	" @ Unit.kAppearance.iEyeColor;
		AppearanceInfo $= "\n nmFacePaint			::	" @ Unit.kAppearance.nmFacePaint;
		AppearanceInfo $= "\n nmTeeth				::	" @ Unit.kAppearance.nmTeeth;
		AppearanceInfo $= "\n nmScars				::	" @ Unit.kAppearance.nmScars;
		AppearanceInfo $= "\n - - - - -	- - - - - - - - - - - - - - - - - - - - - - - - - - -	";
		AppearanceInfo $= "\n nmHelmet				::	" @ Unit.kAppearance.nmHelmet;
		AppearanceInfo $= "\n nmFacePropUpper		::	" @ Unit.kAppearance.nmFacePropUpper;
		AppearanceInfo $= "\n nmFacePropLower		::	" @ Unit.kAppearance.nmFacePropLower;
		AppearanceInfo $= "\n - - - - -	- - - - - - - - - - - - - - - - - - - - - - - - - - -	";
		AppearanceInfo $= "\n nmTorso				::	" @ Unit.kAppearance.nmTorso;
		AppearanceInfo $= "\n nmTorso_Underlay		::	" @ Unit.kAppearance.nmTorso_Underlay;
		AppearanceInfo $= "\n nmTorso_Deco			::	" @ Unit.kAppearance.nmTorsoDeco;
		AppearanceInfo $= "\n nmArms					::	" @ Unit.kAppearance.nmArms;
		AppearanceInfo $= "\n nmArms_Underlay		::	" @ Unit.kAppearance.nmArms_Underlay;
		AppearanceInfo $= "\n nmLeftArm				::	" @ Unit.kAppearance.nmLeftArm;
		AppearanceInfo $= "\n nmArmShoulderL			::	" @ Unit.kAppearance.nmLeftArmDeco;
		AppearanceInfo $= "\n nmTattoo_LeftArm		::	" @ Unit.kAppearance.nmTattoo_LeftArm;
		AppearanceInfo $= "\n nmRightArm				::	" @ Unit.kAppearance.nmRightArm;
		AppearanceInfo $= "\n nmArmShoulderR			::	" @ Unit.kAppearance.nmRightArmDeco;
		AppearanceInfo $= "\n nmTattoo_RightArm		::	" @ Unit.kAppearance.nmTattoo_RightArm;
		AppearanceInfo $= "\n nmLegs					::	" @ Unit.kAppearance.nmLegs;
		AppearanceInfo $= "\n nmLegs_Underlay		::	" @ Unit.kAppearance.nmLegs_Underlay;
		AppearanceInfo $= "\n nmThighs				::	" @ Unit.kAppearance.nmThighs;
		AppearanceInfo $= "\n nmShins				::	" @ Unit.kAppearance.nmShins;
		AppearanceInfo $= "\n - - - - -	- - - - - - - - - - - - - - - - - - - - - - - - - - -	";
		AppearanceInfo $= "\n iArmorDeco				::	" @ Unit.kAppearance.iArmorDeco;
		AppearanceInfo $= "\n nmPatterns				::	" @ Unit.kAppearance.nmPatterns;
		AppearanceInfo $= "\n Weapon Pattern			::	" @ Unit.kAppearance.nmWeaponPattern;
		AppearanceInfo $= "\n iTattooTint			::	" @ Unit.kAppearance.iTattooTint;
		AppearanceInfo $= "\n iArmorTint				::	" @ Unit.kAppearance.iArmorTint;
		AppearanceInfo $= "\n iArmorTintSecondary	::	" @ Unit.kAppearance.iArmorTintSecondary;
		AppearanceInfo $= "\n iWeaponTint			::	" @ Unit.kAppearance.iWeaponTint;
		AppearanceInfo $= "\n - - - - -	- - - - - - - - - - - - - - - - - - - - - - - - - - -	";
		`log( AppearanceInfo,,'BSTARsSCOPE_Appearance');
		`log("================================== END APPEARANCE ===================================",,'BSTARsSCOPE_Appearance');
	}

	SubmitNewGameState(NewGameState);
}
/*
exec function RefreshSoldierXPAndKills()
{
	local XComGameStateHistory				History;
	local UIArmory							Armory;
	local StateObjectReference				UnitRef;
	local XComGameState_Unit				UnitState;
	local XComGameState						NewGameState;
	local XComGameState_HeadquartersXCom	XComHQ;
	local int								Rank, iXP;
	

	History = `XCOMHISTORY;

	Armory = UIArmory(`SCREENSTACK.GetFirstInstanceOf(class'UIArmory'));
	if (Armory == none)
	{
		return;
	}

	UnitRef = Armory.GetUnitRef();
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
	if (UnitState == none)
	{
		return;
	}
	
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Refresh Kills and XP");
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));

	Rank = UnitState.GetRank();

	iXP = UnitState.GetXPValue();
	iXP -= class'X2ExperienceConfig'.static.GetRequiredXp(Rank);

	UnitState.SetXPForRank(Rank);
		//function SetXPForRank(int SoldierRank)
		//{
		//	m_iXp = class'X2ExperienceConfig'.static.GetRequiredXp(SoldierRank);
		//}

	UnitState.SetKillsForRank(Rank);
		//function SetKillsForRank(int SoldierRank)
		//{
		//	NonTacticalKills = max(class'X2ExperienceConfig'.static.GetRequiredKills(SoldierRank) - GetTotalNumKills(false), 0);
		//}

	UnitState.KillCount = SetBaseNumKills(UnitState, Rank);
		// see below

	// Restore any partial XP the soldier had
	if (iXP > 0)
	{
		UnitState.AddXp(iXP);
	}
	
	SubmitNewGameState(NewGameState);
	
	// Update the Armory Screen if open
	Armory.PopulateData();

    `log("====="@UnitState.GetFullName() @" :: Rank ::" @UnitState.GetRank() @" :: XP ::" @UnitState.GetXPValue() @" :: NumKills :: " @UnitState.KillCount @"=====",,'BSTARsSCOPE_XPREFRESH');

}

exec function RefreshALLSoldierXPAndKills()
{
	local XComGameStateHistory				History;
	local UIArmory							Armory;
	local array<XComGameState_Unit>			Soldiers;
	local XComGameState_Unit				UnitState;
	local XComGameState						NewGameState;
	local XComGameState_HeadquartersXCom	XComHQ;
	local int								Rank, iXP;
	

	History = `XCOMHISTORY;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Refresh Kills and XP");
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));

	Soldiers = XComHQ.GetSoldiers();
	foreach Soldiers(UnitState)
	{
		Rank = UnitState.GetRank();

		// If the UnitState is a rookie, skip
		if (Rank == 0)
			continue;
	
		UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));

		iXP = UnitState.GetXPValue();
		iXP -= class'X2ExperienceConfig'.static.GetRequiredXp(Rank);

		UnitState.SetXPForRank(Rank);
		UnitState.SetKillsForRank(Rank);
		UnitState.KillCount = SetBaseNumKills(UnitState, Rank);

		// Restore any partial XP the soldier had
		if (iXP > 0)
		{
			UnitState.AddXp(iXP);
		}

    `log("====="@UnitState.GetFullName() @" :: Rank ::" @UnitState.GetRank() @" :: XP ::" @UnitState.GetXPValue() @" :: NumKills :: " @UnitState.KillCount @"=====",,'BSTARsSCOPE_XPREFRESH');
	}

	SubmitNewGameState(NewGameState);

	// Update the Armory Screen if open
	Armory = UIArmory(`SCREENSTACK.GetFirstInstanceOf(class'UIArmory'));
	if (Armory != none)
	{
		Armory.PopulateData();
	}

}

function int SetBaseNumKills(XComGameState_Unit UnitState, int Rank)
{
	local int NumKills;

	NumKills = Round(UnitState.KillCount);

	// Increase kills for WetWork bonus if appropriate - DEPRECATED
	//NumKills += Round(UnitState.WetWorkKills * class'X2ExperienceConfig'.default.NumKillsBonus);

	// Add in bonus kills
	NumKills += Round(UnitState.BonusKills);

	//  Add number of kills from assists
	NumKills += UnitState.GetNumKillsFromAssists();

	// Add required kills of Rank
	NumKills += class'X2ExperienceConfig'.static.GetRequiredKills(Rank);

	return NumKills;
}
*/
//====================================================================================
//	HELPER Funcs - Submit GS copied from Musashi code
//====================================================================================


//helper function to submit new game states        
protected static function SubmitNewGameState(out XComGameState NewGameState)
{
    local X2TacticalGameRuleset		TacticalRules;
    local XComGameStateHistory		History;
 
    if (NewGameState.GetNumGameStateObjects() > 0)
    {
        TacticalRules = `TACTICALRULES;
        TacticalRules.SubmitGameState(NewGameState);
    }
    else
    {
        History = `XCOMHISTORY;
        History.CleanupPendingGameState(NewGameState);
    }
}
