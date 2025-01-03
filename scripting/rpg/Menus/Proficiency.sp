stock LoadProficiencyData(client) {
	Handle menu = CreateMenu(LoadProficiencyMenuHandle);
	ClearArray(RPGMenuPosition[client]);

	for (int i = 0; i <= 7; i++) {
		char text[64];
		char theExperienceBar[64];
		char currAmount[20];
		char currTarget[20];

		int CurLevel = GetProficiencyData(client, i);
		int CurExp = GetProficiencyData(client, i, _, 1);
		int CurGoal = GetProficiencyData(client, i, _, 2);
		//new Float:CurPerc = (CurExp * 1.0) / (CurGoal * 1.0);
		if (i == 0) Format(text, sizeof(text), "%T", "pistol proficiency", client);
		else if (i == 1) Format(text, sizeof(text), "%T", "melee proficiency", client);
		else if (i == 2) Format(text, sizeof(text), "%T", "uzi proficiency", client);
		else if (i == 3) Format(text, sizeof(text), "%T", "shotgun proficiency", client);
		else if (i == 4) Format(text, sizeof(text), "%T", "sniper proficiency", client);
		else if (i == 5) Format(text, sizeof(text), "%T", "assault proficiency", client);
		else if (i == 6) Format(text, sizeof(text), "%T", "medic proficiency", client);
		else if (i == 7) Format(text, sizeof(text), "%T", "grenade proficiency", client);
		
		MenuExperienceBar(client, CurExp, CurGoal, theExperienceBar, sizeof(theExperienceBar));

		AddCommasToString(CurExp, currAmount, sizeof(currAmount));
		AddCommasToString(CurGoal, currTarget, sizeof(currTarget));
		Format(text, sizeof(text), "%T", "proficiency info", client, text, CurLevel, currAmount, currTarget, theExperienceBar);
		AddMenuItem(menu, text, text, ITEMDRAW_DISABLED);
	}
	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, client, 0);
}

public LoadProficiencyMenuHandle(Handle menu, MenuAction action, client, slot) {

	if (action == MenuAction_Select) { }
	else if (action == MenuAction_Cancel) {
		if (slot == MenuCancel_ExitBack) BuildMenu(client);
	}
	if (action == MenuAction_End) CloseHandle(menu);
}