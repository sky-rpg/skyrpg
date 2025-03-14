stock CallRoundIsOver() {
	if (!b_IsRoundIsOver) {
		char pct[4];
		Format(pct, sizeof(pct), "%");
		b_IsRoundIsOver					= true;
		if (b_IsActiveRound) b_IsActiveRound = false;
		int pEnt = -1;
		char pText[2][64];
		char text[64];
		int pSize = GetArraySize(persistentCirculation);
		for (int i = 0; i < pSize; i++) {
			GetArrayString(persistentCirculation, i, text, sizeof(text));
			ExplodeString(text, ":", pText, 2, 64);
			pEnt = StringToInt(pText[0]);
			if (IsValidEntityEx(pEnt)) RemoveEntity(pEnt);//AcceptEntityInput(pEnt, "Kill");
		}
		ClearArray(persistentCirculation);
		for (int i = 1; i <= MaxClients; i++) {
			if (!IsLegitimateClient(i)) continue;
			bTimersRunning[i] = false;
			ClearArray(playerLootOnGround[i]);
			ClearArray(playerLootOnGroundId[i]);

			ClearArray(CommonInfected[i]);
			ClearArray(SpecialCommon[i]);
			ClearArray(WitchDamage[i]);
			ClearArray(InfectedHealth[i]);
		}
		SetSurvivorsAliveHostname();
		int Seconds			= GetTime() - RoundTime;
		iTotalCampaignTime += Seconds;
		int Minutes			= 0;
		char thisRoundTime[64];
		numberOfCommonsKilledThisCampaign += numberOfCommonsKilledThisRound;
		numberOfSupersKilledThisCampaign += numberOfSupersKilledThisRound;
		numberOfWitchesKilledThisCampaign += numberOfWitchesKilledThisRound;
		numberOfSpecialsKilledThisCampaign += numberOfSpecialsKilledThisRound;
		numberOfTanksKilledThisCampaign += numberOfTanksKilledThisRound;
		if (CurrentMapPosition != 1) {
			while (Seconds >= 60) {
				Minutes++;
				Seconds -= 60;
			}
			Format(thisRoundTime, sizeof(thisRoundTime), "{G}%d {O}min(s), {G}%d {O}sec(s)", Minutes, Seconds);
			int totalInfectedKilledThisRound = numberOfCommonsKilledThisRound + numberOfSupersKilledThisRound + numberOfWitchesKilledThisRound + numberOfSpecialsKilledThisRound + numberOfTanksKilledThisRound;
			char totalInfectedKilled[10];
			AddCommasToString(totalInfectedKilledThisRound, totalInfectedKilled, sizeof(totalInfectedKilled));
			char commonsKilledThisRound[10];
			AddCommasToString(numberOfCommonsKilledThisRound, commonsKilledThisRound, sizeof(commonsKilledThisRound));
			char supersKilledThisRound[10];
			AddCommasToString(numberOfSupersKilledThisRound, supersKilledThisRound, sizeof(supersKilledThisRound));
			char witchesKilledThisRound[10];
			AddCommasToString(numberOfWitchesKilledThisRound, witchesKilledThisRound, sizeof(witchesKilledThisRound));
			char specialsKilledThisRound[10];
			AddCommasToString(numberOfSpecialsKilledThisRound, specialsKilledThisRound, sizeof(specialsKilledThisRound));
			char tanksKilledThisRound[10];
			AddCommasToString(numberOfTanksKilledThisRound, tanksKilledThisRound, sizeof(tanksKilledThisRound));

			char roundStatistics[512];
			Format(roundStatistics, sizeof(roundStatistics), "%t", "round statistics", commonsKilledThisRound, supersKilledThisRound, witchesKilledThisRound, specialsKilledThisRound, tanksKilledThisRound, thisRoundTime, totalInfectedKilled);
			for (int i = 1; i <= MaxClients; i++) {
				if (!IsLegitimateClient(i)) continue;
				Client_PrintToChat(i, true, roundStatistics);
			}
		}
		else {
			while (iTotalCampaignTime >= 60) {
				Minutes++;
				iTotalCampaignTime -= 60;
			}
			Format(thisRoundTime, sizeof(thisRoundTime), "{G}%d {O}min(s), {G}%d {O}sec(s)", Minutes, iTotalCampaignTime);
			int totalInfectedKilledThisCampaign = numberOfCommonsKilledThisCampaign + numberOfSupersKilledThisCampaign + numberOfWitchesKilledThisCampaign + numberOfSpecialsKilledThisCampaign + numberOfTanksKilledThisCampaign;
			char totalInfectedKilledCampaign[10];
			AddCommasToString(totalInfectedKilledThisCampaign, totalInfectedKilledCampaign, sizeof(totalInfectedKilledCampaign));
			char commonsKilledThisCampaign[10];
			AddCommasToString(numberOfCommonsKilledThisCampaign, commonsKilledThisCampaign, sizeof(commonsKilledThisCampaign));
			char supersKilledThisCampaign[10];
			AddCommasToString(numberOfSupersKilledThisCampaign, supersKilledThisCampaign, sizeof(supersKilledThisCampaign));
			char witchesKilledThisCampaign[10];
			AddCommasToString(numberOfWitchesKilledThisCampaign, witchesKilledThisCampaign, sizeof(witchesKilledThisCampaign));
			char specialsKilledThisCampaign[10];
			AddCommasToString(numberOfSpecialsKilledThisCampaign, specialsKilledThisCampaign, sizeof(specialsKilledThisCampaign));
			char tanksKilledThisCampaign[10];
			AddCommasToString(numberOfTanksKilledThisCampaign, tanksKilledThisCampaign, sizeof(tanksKilledThisCampaign));

			char campaignStatistics[512];
			Format(campaignStatistics, sizeof(campaignStatistics), "%t", "campaign statistics", commonsKilledThisCampaign, supersKilledThisCampaign, witchesKilledThisCampaign, specialsKilledThisCampaign, tanksKilledThisCampaign, thisRoundTime, totalInfectedKilledCampaign);
			for (int i = 1; i <= MaxClients; i++) {
				if (!IsLegitimateClient(i)) continue;
				Client_PrintToChat(i, true, campaignStatistics);
			}

			if (CurrentMapPosition == 1 && iResetPlayerLevelOnNewCampaign == 1) {
				char tquery[2048];
				//SQL_EscapeString(hDatabase, Hostname, tquery, sizeof(tquery));
				Format(tquery, sizeof(tquery), "UPDATE `%s` SET `exp` = '0', `expov` = '0', `level` = '%d' WHERE (`steam_id` LIKE '%s%s%s');", TheDBPrefix, iPlayerStartingLevel, pct, serverKey, pct);
				int client = FindAnyClient();
				SQL_TQuery(hDatabase, QueryResults1, tquery, client);

				if (iDeleteUnequippedGearOnNewCampaign == 1) {
					for (int i = 1; i <= MaxClients; i++) {
						if (!IsLegitimateClient(i)) continue;
						ExperienceLevel[i] = 0;
						ExperienceOverall[i] = 0;
						PlayerLevel[i] = iPlayerStartingLevel;
						for (int ii = 0; ii < GetArraySize(myAugmentInfo[i]); ii++) {
							int isEquipped = GetArrayCell(myAugmentInfo[i], ii, 3);
							if (isEquipped >= 0) continue;

							char currentIDCode[64];
							GetArrayString(myAugmentIDCodes[i], ii, currentIDCode, sizeof(currentIDCode));

							Format(tquery, sizeof(tquery), "DELETE FROM `%s_loot` WHERE `itemid` = '%s';", TheDBPrefix, currentIDCode);
							SQL_TQuery(hDatabase, QueryResults, tquery, i);

							RemoveFromArray(myAugmentIDCodes[i], ii);
							RemoveFromArray(myAugmentCategories[i], ii);
							RemoveFromArray(myAugmentOwners[i], ii);
							RemoveFromArray(myAugmentInfo[i], ii);
							RemoveFromArray(myAugmentTargetEffects[i], ii);
							RemoveFromArray(myAugmentActivatorEffects[i], ii);
							RemoveFromArray(myAugmentSavedProfiles[i], ii);
							ii--;
						}
					}
				}
				if (iDeleteAttributeLevelsOnNewCampaign == 1) {
					for (int i = 1; i <= MaxClients; i++) {
						if (!IsLegitimateClient(i)) continue;
						ClearArray(attributeData[i]);
						ResizeArray(attributeData[i], 6);
						for (int ii = ATTRIBUTE_CONSTITUTION; ii <= ATTRIBUTE_LUCK; ii++) {
							AddAttributeExperience(i, ii, 0, true);
						}
					}
					Format(tquery, sizeof(tquery), "UPDATE `%s` SET `con` = '0', `agi` = '0', `res` = '0', `tec` = '0', `end` = '0', `luc` = '0' WHERE (`steam_id` LIKE '%s%s%s');", TheDBPrefix, pct, serverKey, pct);
					SQL_TQuery(hDatabase, QueryResults1, tquery, client);
				}
			}
		}
		ClearArray(damageOfSpecialInfected);
		ClearArray(damageOfWitch);
		ClearArray(damageOfCommonInfected);
		ClearArray(ActiveTankRocks);
		if (!b_IsMissionFailed) {
			//InfectedLevel = HumanSurvivorLevels();
			if (!IsSurvivalMode) {
				int livingSurvs = LivingSurvivors();
				float fExperienceBonus = 0.0;
				if (livingSurvs > 1) {
					fExperienceBonus = fCoopSurvBon * (livingSurvs-1);
				}
				else if (TotalHumanSurvivors() == 1) {
					fExperienceBonus = fCoopSoloSurvBon;
				}
				//RoundExperienceMultiplier[i] += FinSurvBon;
				if (b_IsRescueVehicleArrived) {
					fExperienceBonus += FinSurvBon;
				}

				for (int i = 1; i <= MaxClients; i++) {
					if (IsLegitimateClient(i)) {
						ImmuneToAllDamage[i] = false;
						iThreatLevel[i] = 0;
						bIsInCombat[i] = false;
						fSlowSpeed[i] = 1.0;
						if (CurrentMapPosition == 1 && iResetPlayerLevelOnNewCampaign == 1) {
							if (!IsFakeClient(i)) PlayerLevel[i] = iPlayerStartingLevel;
							else PlayerLevel[i] = iBotPlayerStartingLevel;
							ExperienceLevel[i] = 0;
							ExperienceOverall[i] = 0;
						}
						if (myCurrentTeam[i] != TEAM_SURVIVOR || !IsPlayerAlive(i)) continue;
						if (handicapLevel[i] < 0) {
							handicapLevel[i] = 0;
						}
						if (iHandicapLevelsAreScoreBased != 1 && handicapLevel[i]+1 > handicapLevelAllowed[i]) {
							handicapLevelAllowed[i] = handicapLevel[i]+1;
							PrintToChat(i, "\x04Handicap \x05%d \x03unlocked.", handicapLevelAllowed[i]);
						}

						if (Rating[i] < 0 && CurrentMapPosition != 1) VerifyMinimumRating(i);
						if (RoundExperienceMultiplier[i] < 0.0) RoundExperienceMultiplier[i] = 0.0;
						if (fExperienceBonus > 0.0) {
							float scoreMult = GetScoreMultiplier(i);
							float lootMult = 0.0;
							if (b_IsRescueVehicleArrived) {
								fExperienceBonus += FinSurvBon;
								lootMult = (scoreMult * fFinaleSurvivalLootFindBonus);
							}
							else lootMult = (scoreMult * fRoundSurvivalLootFindBonus);
							if (scoreMult > 0.0) {
								scoreMult *= fExperienceBonus;
								RoundExperienceMultiplier[i] += scoreMult;
								clientLootFindBonus[i] += lootMult;
								PrintToChat(i, "%T", "living survivors experience bonus", i, orange, blue, orange, white, blue, scoreMult * 100.0, white, pct, orange);
								PrintToChat(i, "%T", "living survivors loot find bonus", i, orange, blue, green, lootMult * 100.0, white, pct);
								if (bHasDonorPrivileges[i] && fDonatorSurvBonIncrease > 0.0) {
									// donators receive a survival xp bonus to speed up their potential xp earnings.
									scoreMult *= fDonatorSurvBonIncrease;
									lootMult *= fDonatorLootBonusIncrease;

									RoundExperienceMultiplier[i] += scoreMult;
									clientLootFindBonus[i] += lootMult;
									PrintToChat(i, "%T", "living survivors experience bonus (donator)", i, orange, blue, orange, white, blue, scoreMult * 100.0, white, pct, orange);
									PrintToChat(i, "%T", "living survivors loot find bonus (donator)", i, orange, blue, green, lootMult * 100.0, white, pct);
								}
							}
						}
						//else PrintToChat(i, "no round bonus applied.");
						if (CurrentMapPosition != 1 || iResetPlayerLevelOnNewCampaign != 1) AwardExperience(i, _, _, true);
					}
				}
			}
		}
		int humanSurvivorsInGame = TotalHumanSurvivors();
		// only save data on round end if there is at least 1 human on the survivor team.
		// rounds will constantly loop if the survivor team is all bots.
		if (humanSurvivorsInGame > 0) {
			for (int i = 1; i <= MaxClients; i++) {
				if (!IsLegitimateClient(i) || GetClientTeam(i) == TEAM_SPECTATOR) continue;
				if (IsFakeClient(i) && GetClientTeam(i) == TEAM_INFECTED) continue;	// infected bots are skipped.
				//ToggleTank(i, true);
				if (b_IsMissionFailed) {
					if (myCurrentTeam[i] == TEAM_SURVIVOR) {
						RoundExperienceMultiplier[i] = 0.0;
						if (IsPlayerAlive(i)) CheckForRatingLossOnDeath(i);
					}
					bIsGiveProfileItems[i] = false;
				}
				SavePlayerData(i);
			}
		}
		//CreateTimer(1.0, Timer_SaveAndClear, _, TIMER_FLAG_NO_MAPCHANGE);
		b_IsCheckpointDoorStartOpened	= false;
		RemoveImmunities(-1);
		ClearArray(LoggedUsers);		// when a round ends, logged users are removed.
		b_IsActiveRound = false;
		MapRoundsPlayed++;
		ClearArray(WitchList);
		ClearArray(EntityOnFire);
		ClearArray(CommonInfectedQueue);
		ClearArray(SuperCommonQueue);
		ClearArray(StaggeredTargets);
		ClearArray(SpecialAmmoData);
		ClearArray(CommonAffixes);
		ClearArray(EffectOverTime);
		ClearArray(TimeOfEffectOverTime);
		if (b_IsMissionFailed && StrContains(TheCurrentMap, "zerowarn", false) != -1) {
			// need to force-teleport players here on new spawn: 4087.998291 11974.557617 -269.968750
			CreateTimer(5.0, Timer_ResetMap, _, TIMER_FLAG_NO_MAPCHANGE);
		}
		else if (StrContains(TheCurrentMap, "helms", false) != -1) {
			CreateTimer(3.0, Timer_ResetMap, _, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}