new Text:PresonStateTextDraw=Text:INVALID_TEXT_DRAW;
//new PlayerText:PresonStateIcon[MAX_PLAYERS]= {PlayerText:INVALID_TEXT_DRAW, ...};
new PlayerText:PresonStateDry[MAX_PLAYERS][2];
new PlayerText:PresonStateHunger[MAX_PLAYERS][2];
new PlayerText:PresonStateHP[MAX_PLAYERS][2];
new PlayerText:PresonStateStamina[MAX_PLAYERS][2];

new PlayerText:PresonStateInfection[MAX_PLAYERS]= {PlayerText:INVALID_TEXT_DRAW, ...};
new bool:PresonStateInfectionRate[MAX_PLAYERS]= {false, ...};

new bool:PresonStateShow[MAX_PLAYERS]= {false, ...};
/********************************************///导航栏
new Text:NavigationBar[9]= {Text:INVALID_TEXT_DRAW, ...};
new bool:NavigationBarShow[MAX_PLAYERS]= {false, ...};

/******************************************/
new Text:MsgTips[2]= {Text:INVALID_TEXT_DRAW, ...};
new bool:MsgTipsShow[MAX_PLAYERS]= {false, ...};
new Timer:MsgTips[MAX_PLAYERS]={NONE, ...};
/******************************************/
FUNC::ShowPlayerMsgTipsTextDraw(playerid,times)
{
	if(Timer:MsgTips[playerid]==NONE)
	{
		forex(i,sizeof(MsgTips))TextDrawShowForPlayer(playerid, MsgTips[i]);
		Timer:MsgTips[playerid]=SetTimerEx("HidePlayerMsgTipsTextDraw",times,false,"i",playerid);
		MsgTipsShow[playerid]=true;
	}
	return 1;
}
FUNC::HidePlayerMsgTipsTextDraw(playerid)
{
	forex(i,sizeof(MsgTips))TextDrawHideForPlayer(playerid, MsgTips[i]);
	KillTimer(Timer:MsgTips[playerid]);
	Timer:MsgTips[playerid]=NONE;
	MsgTipsShow[playerid]=false;
	return 1;
}
FUNC::FlashPlayerInfection(playerid)
{
    if(PresonStateInfectionRate[playerid]==true)
    {
   		PlayerTextDrawColor(playerid, PresonStateInfection[playerid], -16776961);
   		PlayerTextDrawShow(playerid,PresonStateInfection[playerid]);
        PresonStateInfectionRate[playerid]=false;
    }
    else
    {
        PlayerTextDrawColor(playerid, PresonStateInfection[playerid], -1);
        PlayerTextDrawShow(playerid,PresonStateInfection[playerid]);
        PresonStateInfectionRate[playerid]=true;
    }
	return 1;
}
FUNC::StopPlayerInfection(playerid)
{
    Account[playerid][_Infection]=0;
	formatex128("UPDATE `"MYSQL_DB_ACCOUNT"` SET  `感染`='%i' WHERE  `"MYSQL_DB_ACCOUNT"`.`密匙` ='%s'",Account[playerid][_Infection],Account[playerid][_Key]);
	mysql_query(Account@Handle,string128,false);
    PresonStateInfectionRate[playerid]=false;
    PlayerTextDrawColor(playerid, PresonStateInfection[playerid], -1);
    PlayerTextDrawHide(playerid,PresonStateInfection[playerid]);
	return 1;
}
/******************************************/
FUNC::PresonState_OnPlayerConnect(playerid)
{
    PresonState_OnPlayerDisconnect(playerid);

	PresonStateDry[playerid][0] = CreatePlayerTextDraw(playerid, 507.000000, 27.000000, "LD_SPAC:WHITE");
	PlayerTextDrawFont(playerid, PresonStateDry[playerid][0], 4);
	PlayerTextDrawLetterSize(playerid, PresonStateDry[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PresonStateDry[playerid][0], 103.500000, 12.000000);
	PlayerTextDrawSetOutline(playerid, PresonStateDry[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, PresonStateDry[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, PresonStateDry[playerid][0], 1);
	PlayerTextDrawColor(playerid, PresonStateDry[playerid][0], -8433409);
	PlayerTextDrawBackgroundColor(playerid, PresonStateDry[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, PresonStateDry[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, PresonStateDry[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, PresonStateDry[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, PresonStateDry[playerid][0], 0);

    
/*	PresonStateDry[playerid][0] = CreatePlayerTextDraw(playerid, 513.000000, 41.000000, "_");
	PlayerTextDrawFont(playerid, PresonStateDry[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, PresonStateDry[playerid][0], 0.600000, 1.000000);
	PlayerTextDrawTextSize(playerid, PresonStateDry[playerid][0], 615.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PresonStateDry[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, PresonStateDry[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, PresonStateDry[playerid][0], 1);
	PlayerTextDrawColor(playerid, PresonStateDry[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, PresonStateDry[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, PresonStateDry[playerid][0], 255);
	PlayerTextDrawUseBox(playerid, PresonStateDry[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, PresonStateDry[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, PresonStateDry[playerid][0], 0);*/

/*	PresonStateDry[playerid][1] = CreatePlayerTextDraw(playerid, 517.000000, 41.000000, "LD_SPAC:WHITE");
	PlayerTextDrawFont(playerid, PresonStateDry[playerid][1], 4);
	PlayerTextDrawLetterSize(playerid, PresonStateDry[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PresonStateDry[playerid][1], 98.000000, 9.500000);
	PlayerTextDrawSetOutline(playerid, PresonStateDry[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, PresonStateDry[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, PresonStateDry[playerid][1], 1);
	PlayerTextDrawColor(playerid, PresonStateDry[playerid][1], -8433409);
	PlayerTextDrawBackgroundColor(playerid, PresonStateDry[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, PresonStateDry[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, PresonStateDry[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, PresonStateDry[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, PresonStateDry[playerid][1], 0);*/

	PresonStateDry[playerid][1] = CreatePlayerTextDraw(playerid, 560.000000, 27.000000, "100%");
	PlayerTextDrawFont(playerid, PresonStateDry[playerid][1], 2);
	PlayerTextDrawLetterSize(playerid, PresonStateDry[playerid][1], 0.191666, 1.250000);
	PlayerTextDrawTextSize(playerid, PresonStateDry[playerid][1], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PresonStateDry[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, PresonStateDry[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, PresonStateDry[playerid][1], 2);
	PlayerTextDrawColor(playerid, PresonStateDry[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, PresonStateDry[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, PresonStateDry[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, PresonStateDry[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, PresonStateDry[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, PresonStateDry[playerid][1], 0);

	PresonStateHunger[playerid][0] = CreatePlayerTextDraw(playerid, 507.000000, 45.300000, "LD_SPAC:WHITE");
	PlayerTextDrawFont(playerid, PresonStateHunger[playerid][0], 4);
	PlayerTextDrawLetterSize(playerid, PresonStateHunger[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PresonStateHunger[playerid][0], 103.500000, 12.000000);
	PlayerTextDrawSetOutline(playerid, PresonStateHunger[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, PresonStateHunger[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, PresonStateHunger[playerid][0], 1);
	PlayerTextDrawColor(playerid, PresonStateHunger[playerid][0], 852308735);
	PlayerTextDrawBackgroundColor(playerid, PresonStateHunger[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, PresonStateHunger[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, PresonStateHunger[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, PresonStateHunger[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, PresonStateHunger[playerid][0], 0);

/*	PresonStateHunger[playerid][0] = CreatePlayerTextDraw(playerid, 513.000000, 60.000000, "_");
	PlayerTextDrawFont(playerid, PresonStateHunger[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, PresonStateHunger[playerid][0], 0.600000, 1.000000);
	PlayerTextDrawTextSize(playerid, PresonStateHunger[playerid][0], 615.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PresonStateHunger[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, PresonStateHunger[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, PresonStateHunger[playerid][0], 1);
	PlayerTextDrawColor(playerid, PresonStateHunger[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, PresonStateHunger[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, PresonStateHunger[playerid][0], 255);
	PlayerTextDrawUseBox(playerid, PresonStateHunger[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, PresonStateHunger[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, PresonStateHunger[playerid][0], 0);

	PresonStateHunger[playerid][1] = CreatePlayerTextDraw(playerid, 517.000000, 60.000000, "LD_SPAC:WHITE");
	PlayerTextDrawFont(playerid, PresonStateHunger[playerid][1], 4);
	PlayerTextDrawLetterSize(playerid, PresonStateHunger[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PresonStateHunger[playerid][1], 98.000000, 9.500000);
	PlayerTextDrawSetOutline(playerid, PresonStateHunger[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, PresonStateHunger[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, PresonStateHunger[playerid][1], 1);
	PlayerTextDrawColor(playerid, PresonStateHunger[playerid][1], 852308735);
	PlayerTextDrawBackgroundColor(playerid, PresonStateHunger[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, PresonStateHunger[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, PresonStateHunger[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, PresonStateHunger[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, PresonStateHunger[playerid][1], 0);*/

	PresonStateHunger[playerid][1] = CreatePlayerTextDraw(playerid, 560.000000, 45.300000, "100%");
	PlayerTextDrawFont(playerid, PresonStateHunger[playerid][1], 2);
	PlayerTextDrawLetterSize(playerid, PresonStateHunger[playerid][1], 0.191666, 1.250000);
	PlayerTextDrawTextSize(playerid, PresonStateHunger[playerid][1], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PresonStateHunger[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, PresonStateHunger[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, PresonStateHunger[playerid][1], 2);
	PlayerTextDrawColor(playerid, PresonStateHunger[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, PresonStateHunger[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, PresonStateHunger[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, PresonStateHunger[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, PresonStateHunger[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, PresonStateHunger[playerid][1], 0);

	PresonStateHP[playerid][0] = CreatePlayerTextDraw(playerid, 507.000000, 65.000000, "LD_SPAC:WHITE");
	PlayerTextDrawFont(playerid, PresonStateHP[playerid][0], 4);
	PlayerTextDrawLetterSize(playerid, PresonStateHP[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PresonStateHP[playerid][0], 103.500000, 12.000000);
	PlayerTextDrawSetOutline(playerid, PresonStateHP[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, PresonStateHP[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, PresonStateHP[playerid][0], 1);
	PlayerTextDrawColor(playerid, PresonStateHP[playerid][0], -16776961);
	PlayerTextDrawBackgroundColor(playerid, PresonStateHP[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, PresonStateHP[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, PresonStateHP[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, PresonStateHP[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, PresonStateHP[playerid][0], 0);

/*	PresonStateHP[playerid][0] = CreatePlayerTextDraw(playerid, 513.000000, 79.000000, "_");
	PlayerTextDrawFont(playerid, PresonStateHP[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, PresonStateHP[playerid][0], 0.600000, 1.000000);
	PlayerTextDrawTextSize(playerid, PresonStateHP[playerid][0], 615.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PresonStateHP[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, PresonStateHP[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, PresonStateHP[playerid][0], 1);
	PlayerTextDrawColor(playerid, PresonStateHP[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, PresonStateHP[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, PresonStateHP[playerid][0], 255);
	PlayerTextDrawUseBox(playerid, PresonStateHP[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, PresonStateHP[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, PresonStateHP[playerid][0], 0);

	PresonStateHP[playerid][1] = CreatePlayerTextDraw(playerid, 517.000000, 79.000000, "LD_SPAC:WHITE");
	PlayerTextDrawFont(playerid, PresonStateHP[playerid][1], 4);
	PlayerTextDrawLetterSize(playerid, PresonStateHP[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PresonStateHP[playerid][1], 98.000000, 9.500000);
	PlayerTextDrawSetOutline(playerid, PresonStateHP[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, PresonStateHP[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, PresonStateHP[playerid][1], 1);
	PlayerTextDrawColor(playerid, PresonStateHP[playerid][1], -16776961);
	PlayerTextDrawBackgroundColor(playerid, PresonStateHP[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, PresonStateHP[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, PresonStateHP[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, PresonStateHP[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, PresonStateHP[playerid][1], 0);*/

	PresonStateHP[playerid][1] = CreatePlayerTextDraw(playerid, 560.000000, 65.000000, "100%");
	PlayerTextDrawFont(playerid, PresonStateHP[playerid][1], 2);
	PlayerTextDrawLetterSize(playerid, PresonStateHP[playerid][1], 0.191666, 1.250000);
	PlayerTextDrawTextSize(playerid, PresonStateHP[playerid][1], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PresonStateHP[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, PresonStateHP[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, PresonStateHP[playerid][1], 2);
	PlayerTextDrawColor(playerid, PresonStateHP[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, PresonStateHP[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, PresonStateHP[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, PresonStateHP[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, PresonStateHP[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, PresonStateHP[playerid][1], 0);

	PresonStateStamina[playerid][0] = CreatePlayerTextDraw(playerid, 507.000000, 83.800000, "LD_SPAC:WHITE");
	PlayerTextDrawFont(playerid, PresonStateStamina[playerid][0], 4);
	PlayerTextDrawLetterSize(playerid, PresonStateStamina[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PresonStateStamina[playerid][0], 103.500000, 12.000000);
	PlayerTextDrawSetOutline(playerid, PresonStateStamina[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, PresonStateStamina[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, PresonStateStamina[playerid][0], 1);
	PlayerTextDrawColor(playerid, PresonStateStamina[playerid][0], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, PresonStateStamina[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, PresonStateStamina[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, PresonStateStamina[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, PresonStateStamina[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, PresonStateStamina[playerid][0], 0);

/*	PresonStateStamina[playerid][0] = CreatePlayerTextDraw(playerid, 513.000000, 98.000000, "_");
	PlayerTextDrawFont(playerid, PresonStateStamina[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, PresonStateStamina[playerid][0], 0.600000, 1.000000);
	PlayerTextDrawTextSize(playerid, PresonStateStamina[playerid][0], 615.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PresonStateStamina[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, PresonStateStamina[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, PresonStateStamina[playerid][0], 1);
	PlayerTextDrawColor(playerid, PresonStateStamina[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, PresonStateStamina[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, PresonStateStamina[playerid][0], 255);
	PlayerTextDrawUseBox(playerid, PresonStateStamina[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, PresonStateStamina[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, PresonStateStamina[playerid][0], 0);

	PresonStateStamina[playerid][1] = CreatePlayerTextDraw(playerid, 517.000000, 98.000000, "LD_SPAC:WHITE");
	PlayerTextDrawFont(playerid, PresonStateStamina[playerid][1], 4);
	PlayerTextDrawLetterSize(playerid, PresonStateStamina[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PresonStateStamina[playerid][1], 98.000000, 9.500000);
	PlayerTextDrawSetOutline(playerid, PresonStateStamina[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, PresonStateStamina[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, PresonStateStamina[playerid][1], 1);
	PlayerTextDrawColor(playerid, PresonStateStamina[playerid][1], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, PresonStateStamina[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, PresonStateStamina[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, PresonStateStamina[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, PresonStateStamina[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, PresonStateStamina[playerid][1], 0);*/

	PresonStateStamina[playerid][1] = CreatePlayerTextDraw(playerid, 560.000000, 83.800000, "100%");
	PlayerTextDrawFont(playerid, PresonStateStamina[playerid][1], 2);
	PlayerTextDrawLetterSize(playerid, PresonStateStamina[playerid][1], 0.191666, 1.250000);
	PlayerTextDrawTextSize(playerid, PresonStateStamina[playerid][1], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PresonStateStamina[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, PresonStateStamina[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, PresonStateStamina[playerid][1], 2);
	PlayerTextDrawColor(playerid, PresonStateStamina[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, PresonStateStamina[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, PresonStateStamina[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, PresonStateStamina[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, PresonStateStamina[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, PresonStateStamina[playerid][1], 0);

/*	PresonStateIcon[playerid] = CreatePlayerTextDraw(playerid, 501.000000, 36.000000, "mdl-2002:StatIcon");
	PlayerTextDrawFont(playerid, PresonStateIcon[playerid], 4);
	PlayerTextDrawLetterSize(playerid, PresonStateIcon[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PresonStateIcon[playerid], 19.000000, 76.000000);
	PlayerTextDrawSetOutline(playerid, PresonStateIcon[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PresonStateIcon[playerid], 0);
	PlayerTextDrawAlignment(playerid, PresonStateIcon[playerid], 1);
	PlayerTextDrawColor(playerid, PresonStateIcon[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PresonStateIcon[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PresonStateIcon[playerid], 50);
	PlayerTextDrawUseBox(playerid, PresonStateIcon[playerid], 1);
	PlayerTextDrawSetProportional(playerid, PresonStateIcon[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PresonStateIcon[playerid], 0);*/
	
	PresonStateInfection[playerid] = CreatePlayerTextDraw(playerid, 52.000000, 293.000000, "mdl-2000:infection");
	PlayerTextDrawFont(playerid, PresonStateInfection[playerid], 4);
	PlayerTextDrawLetterSize(playerid, PresonStateInfection[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PresonStateInfection[playerid], 35.000000, 32.000000);
	PlayerTextDrawSetOutline(playerid, PresonStateInfection[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PresonStateInfection[playerid], 0);
	PlayerTextDrawAlignment(playerid, PresonStateInfection[playerid], 1);
	PlayerTextDrawColor(playerid, PresonStateInfection[playerid], -1);//-16776961
	PlayerTextDrawBackgroundColor(playerid, PresonStateInfection[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PresonStateInfection[playerid], 50);
	PlayerTextDrawUseBox(playerid, PresonStateInfection[playerid], 1);
	PlayerTextDrawSetProportional(playerid, PresonStateInfection[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PresonStateInfection[playerid], 0);
	return 1;
}
FUNC::PresonState_OnGameModeInit()
{
    forex(i,MAX_PLAYERS)
    {
	    forex(s,2)
		{
			PresonStateDry[i][s]=PlayerText:INVALID_TEXT_DRAW;
			PresonStateHunger[i][s]=PlayerText:INVALID_TEXT_DRAW;
			PresonStateHP[i][s]=PlayerText:INVALID_TEXT_DRAW;
			PresonStateStamina[i][s]=PlayerText:INVALID_TEXT_DRAW;
		}
//		PresonStateIcon[i]=PlayerText:INVALID_TEXT_DRAW;
		PresonStateInfection[i]=PlayerText:INVALID_TEXT_DRAW;
	}

/*	PresonStateTextDraw = TextDrawCreate(495.000000, 16.000000, "mdl-2002:StateBackGround");
	TextDrawFont(PresonStateTextDraw, 4);
	TextDrawLetterSize(PresonStateTextDraw, 0.600000, 2.000000);
	TextDrawTextSize(PresonStateTextDraw, 128.500000, 103.500000);
	TextDrawSetOutline(PresonStateTextDraw, 1);
	TextDrawSetShadow(PresonStateTextDraw, 0);
	TextDrawAlignment(PresonStateTextDraw, 1);
	TextDrawColor(PresonStateTextDraw, -1);
	TextDrawBackgroundColor(PresonStateTextDraw, 255);
	TextDrawBoxColor(PresonStateTextDraw, 50);
	TextDrawUseBox(PresonStateTextDraw, 1);
	TextDrawSetProportional(PresonStateTextDraw, 1);
	TextDrawSetSelectable(PresonStateTextDraw, 0);*/
	PresonStateTextDraw = TextDrawCreate(466.000000, 12.000000, "mdl-2002:StateBackGround");
	TextDrawFont(PresonStateTextDraw, 4);
	TextDrawLetterSize(PresonStateTextDraw, 0.600000, 2.000000);
	TextDrawTextSize(PresonStateTextDraw, 164.000000, 100.000000);
	TextDrawSetOutline(PresonStateTextDraw, 1);
	TextDrawSetShadow(PresonStateTextDraw, 0);
	TextDrawAlignment(PresonStateTextDraw, 1);
	TextDrawColor(PresonStateTextDraw, -1);
	TextDrawBackgroundColor(PresonStateTextDraw, 255);
	TextDrawBoxColor(PresonStateTextDraw, 50);
	TextDrawUseBox(PresonStateTextDraw, 1);
	TextDrawSetProportional(PresonStateTextDraw, 1);
	TextDrawSetSelectable(PresonStateTextDraw, 0);
	/**********************************************************/
	NavigationBar[0] = TextDrawCreate(225.000000, 115.000000, "mdl-2006:back");//背景
	TextDrawFont(NavigationBar[0], 4);
	TextDrawLetterSize(NavigationBar[0], 0.600000, 2.000000);
	TextDrawTextSize(NavigationBar[0], 183.500000, 220.000000);
	TextDrawSetOutline(NavigationBar[0], 1);
	TextDrawSetShadow(NavigationBar[0], 0);
	TextDrawAlignment(NavigationBar[0], 1);
	TextDrawColor(NavigationBar[0], -1);
	TextDrawBackgroundColor(NavigationBar[0], 255);
	TextDrawBoxColor(NavigationBar[0], 50);
	TextDrawUseBox(NavigationBar[0], 1);
	TextDrawSetProportional(NavigationBar[0], 1);
	TextDrawSetSelectable(NavigationBar[0], 0);

	NavigationBar[1] = TextDrawCreate(343.000000, 156.000000, "mdl-2006:faction");//阵营
	TextDrawFont(NavigationBar[1], 4);
	TextDrawLetterSize(NavigationBar[1], 0.600000, 2.000000);
	TextDrawTextSize(NavigationBar[1], 59.500000, 74.500000);
	TextDrawSetOutline(NavigationBar[1], 1);
	TextDrawSetShadow(NavigationBar[1], 0);
	TextDrawAlignment(NavigationBar[1], 1);
	TextDrawColor(NavigationBar[1], -1);
	TextDrawBackgroundColor(NavigationBar[1], 255);
	TextDrawBoxColor(NavigationBar[1], 50);
	TextDrawUseBox(NavigationBar[1], 1);
	TextDrawSetProportional(NavigationBar[1], 1);
	TextDrawSetSelectable(NavigationBar[1], 1);

	NavigationBar[2] = TextDrawCreate(315.000000, 124.000000, "mdl-2006:domian");//领地
	TextDrawFont(NavigationBar[2], 4);
	TextDrawLetterSize(NavigationBar[2], 0.600000, 2.000000);
	TextDrawTextSize(NavigationBar[2], 62.500000, 73.500000);
	TextDrawSetOutline(NavigationBar[2], 1);
	TextDrawSetShadow(NavigationBar[2], 0);
	TextDrawAlignment(NavigationBar[2], 1);
	TextDrawColor(NavigationBar[2], -1);
	TextDrawBackgroundColor(NavigationBar[2], 255);
	TextDrawBoxColor(NavigationBar[2], 50);
	TextDrawUseBox(NavigationBar[2], 1);
	TextDrawSetProportional(NavigationBar[2], 1);
	TextDrawSetSelectable(NavigationBar[2], 1);

	NavigationBar[3] = TextDrawCreate(257.000000, 124.000000, "mdl-2006:state");//信息
	TextDrawFont(NavigationBar[3], 4);
	TextDrawLetterSize(NavigationBar[3], 0.600000, 2.000000);
	TextDrawTextSize(NavigationBar[3], 61.500000, 73.000000);
	TextDrawSetOutline(NavigationBar[3], 1);
	TextDrawSetShadow(NavigationBar[3], 0);
	TextDrawAlignment(NavigationBar[3], 1);
	TextDrawColor(NavigationBar[3], -1);
	TextDrawBackgroundColor(NavigationBar[3], 255);
	TextDrawBoxColor(NavigationBar[3], 50);
	TextDrawUseBox(NavigationBar[3], 1);
	TextDrawSetProportional(NavigationBar[3], 1);
	TextDrawSetSelectable(NavigationBar[3], 1);

	NavigationBar[4] = TextDrawCreate(232.000000, 156.000000, "mdl-2006:inv");//背包
	TextDrawFont(NavigationBar[4], 4);
	TextDrawLetterSize(NavigationBar[4], 0.600000, 2.000000);
	TextDrawTextSize(NavigationBar[4], 60.000000, 73.000000);
	TextDrawSetOutline(NavigationBar[4], 1);
	TextDrawSetShadow(NavigationBar[4], 0);
	TextDrawAlignment(NavigationBar[4], 1);
	TextDrawColor(NavigationBar[4], -1);
	TextDrawBackgroundColor(NavigationBar[4], 255);
	TextDrawBoxColor(NavigationBar[4], 50);
	TextDrawUseBox(NavigationBar[4], 1);
	TextDrawSetProportional(NavigationBar[4], 1);
	TextDrawSetSelectable(NavigationBar[4],1);

	NavigationBar[5] = TextDrawCreate(232.000000, 225.000000, "mdl-2006:mall");//商城
	TextDrawFont(NavigationBar[5], 4);
	TextDrawLetterSize(NavigationBar[5], 0.600000, 2.000000);
	TextDrawTextSize(NavigationBar[5], 60.000000, 73.000000);
	TextDrawSetOutline(NavigationBar[5], 1);
	TextDrawSetShadow(NavigationBar[5], 0);
	TextDrawAlignment(NavigationBar[5], 1);
	TextDrawColor(NavigationBar[5], -1);
	TextDrawBackgroundColor(NavigationBar[5], 255);
	TextDrawBoxColor(NavigationBar[5], 50);
	TextDrawUseBox(NavigationBar[5], 1);
	TextDrawSetProportional(NavigationBar[5], 1);
	TextDrawSetSelectable(NavigationBar[5], 1);

	NavigationBar[6] = TextDrawCreate(316.000000, 256.000000, "mdl-2006:null1");//待定
	TextDrawFont(NavigationBar[6], 4);
	TextDrawLetterSize(NavigationBar[6], 0.600000, 2.000000);
	TextDrawTextSize(NavigationBar[6], 62.000000, 70.000000);
	TextDrawSetOutline(NavigationBar[6], 1);
	TextDrawSetShadow(NavigationBar[6], 0);
	TextDrawAlignment(NavigationBar[6], 1);
	TextDrawColor(NavigationBar[6], -1);
	TextDrawBackgroundColor(NavigationBar[6], 255);
	TextDrawBoxColor(NavigationBar[6], 50);
	TextDrawUseBox(NavigationBar[5], 1);
	TextDrawSetProportional(NavigationBar[6], 1);
	TextDrawSetSelectable(NavigationBar[6], 1);

	NavigationBar[7] = TextDrawCreate(258.000000, 257.000000, "mdl-2006:null2");
	TextDrawFont(NavigationBar[7], 4);
	TextDrawLetterSize(NavigationBar[7], 0.600000, 2.000000);
	TextDrawTextSize(NavigationBar[7], 61.500000, 69.500000);
	TextDrawSetOutline(NavigationBar[7], 1);
	TextDrawSetShadow(NavigationBar[7], 0);
	TextDrawAlignment(NavigationBar[7], 1);
	TextDrawColor(NavigationBar[7], -1);
	TextDrawBackgroundColor(NavigationBar[7], 255);
	TextDrawBoxColor(NavigationBar[7], 50);
	TextDrawUseBox(NavigationBar[7], 1);
	TextDrawSetProportional(NavigationBar[7], 1);
	TextDrawSetSelectable(NavigationBar[7], 1);

	NavigationBar[8] = TextDrawCreate(343.000000, 224.000000, "mdl-2006:null3");
	TextDrawFont(NavigationBar[8], 4);
	TextDrawLetterSize(NavigationBar[8], 0.600000, 2.000000);
	TextDrawTextSize(NavigationBar[8], 58.500000, 73.000000);
	TextDrawSetOutline(NavigationBar[8], 1);
	TextDrawSetShadow(NavigationBar[8], 0);
	TextDrawAlignment(NavigationBar[8], 1);
	TextDrawColor(NavigationBar[8], -1);
	TextDrawBackgroundColor(NavigationBar[8], 255);
	TextDrawBoxColor(NavigationBar[8], 50);
	TextDrawUseBox(NavigationBar[8], 1);
	TextDrawSetProportional(NavigationBar[8], 1);
	TextDrawSetSelectable(NavigationBar[8], 1);

	MsgTips[0] = TextDrawCreate(-3.000000, 205.000000, "mdl-2008:GetIt");
	TextDrawFont(MsgTips[0], 4);
	TextDrawLetterSize(MsgTips[0], 0.600000, 2.000000);
	TextDrawTextSize(MsgTips[0], 196.000000, 29.500000);
	TextDrawSetOutline(MsgTips[0], 1);
	TextDrawSetShadow(MsgTips[0], 0);
	TextDrawAlignment(MsgTips[0], 1);
	TextDrawColor(MsgTips[0], -1);
	TextDrawBackgroundColor(MsgTips[0], 255);
	TextDrawBoxColor(MsgTips[0], 50);
	TextDrawUseBox(MsgTips[0], 1);
	TextDrawSetProportional(MsgTips[0], 1);
	TextDrawSetSelectable(MsgTips[0], 0);

	MsgTips[1] = TextDrawCreate(85.000000, 209.000000, "C");
	TextDrawFont(MsgTips[1], 2);
	TextDrawLetterSize(MsgTips[1], 0.500000, 2.250001);
	TextDrawTextSize(MsgTips[1], 400.000000, 17.000000);
	TextDrawSetOutline(MsgTips[1], 0);
	TextDrawSetShadow(MsgTips[1], 0);
	TextDrawAlignment(MsgTips[1], 2);
	TextDrawColor(MsgTips[1], -16776961);
	TextDrawBackgroundColor(MsgTips[1], 255);
	TextDrawBoxColor(MsgTips[1], 50);
	TextDrawUseBox(MsgTips[1], 0);
	TextDrawSetProportional(MsgTips[1], 1);
	TextDrawSetSelectable(MsgTips[1], 0);
	return 1;
}
FUNC::ShowPlayerNavigationBarTextDraw(playerid)
{
    HidePlayerNavigationBarTextDraw(playerid);
	forex(i,sizeof(NavigationBar))TextDrawShowForPlayer(playerid,NavigationBar[i]);
    NavigationBarShow[playerid]=true;
	return 1;
}
FUNC::HidePlayerNavigationBarTextDraw(playerid)
{
	forex(i,sizeof(NavigationBar))TextDrawHideForPlayer(playerid,NavigationBar[i]);
    NavigationBarShow[playerid]=false;
	return 1;
}
////////////////////////////////////////////////////////
FUNC::PresonState_OnPlayerDisconnect(playerid)
{
	forex(i,2)
	{
		if(PresonStateDry[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PresonStateDry[playerid][i]);
		PresonStateDry[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(PresonStateHunger[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PresonStateHunger[playerid][i]);
		PresonStateHunger[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(PresonStateHP[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PresonStateHP[playerid][i]);
		PresonStateHP[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(PresonStateStamina[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PresonStateStamina[playerid][i]);
		PresonStateStamina[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
	}
/*	if(PresonStateIcon[playerid]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PresonStateIcon[playerid]);
	PresonStateIcon[playerid]=PlayerText:INVALID_TEXT_DRAW;*/
	if(PresonStateInfection[playerid]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PresonStateInfection[playerid]);
	PresonStateInfection[playerid]=PlayerText:INVALID_TEXT_DRAW;
	return 1;
}
FUNC::ShowPlayerPresonStateTextDraw(playerid)
{
	TextDrawShowForPlayer(playerid,PresonStateTextDraw);
	forex(i,2)
	{
	    PlayerTextDrawShow(playerid,PresonStateDry[playerid][i]);
	    PlayerTextDrawShow(playerid,PresonStateHunger[playerid][i]);
	    PlayerTextDrawShow(playerid,PresonStateHP[playerid][i]);
	    PlayerTextDrawShow(playerid,PresonStateStamina[playerid][i]);
	}
//    PlayerTextDrawShow(playerid,PresonStateIcon[playerid]);
    new Float:Healthex;
	GetPlayerHealth(playerid,Healthex);
    UpdatePlayerHpBar(playerid,Healthex);
    UpdatePlayerDryBar(playerid,Account[playerid][_Dry]);
    UpdatePlayerHungerBar(playerid,Account[playerid][_Hunger]);
    UpdatePlayerStaminaBar(playerid,Account[playerid][_Stamina]);
    PresonStateShow[playerid]=true;
	return 1;
}
FUNC::HidePlayerPresonStateTextDraw(playerid)
{
	TextDrawHideForPlayer(playerid,PresonStateTextDraw);
	forex(i,2)
	{
	    PlayerTextDrawHide(playerid,PresonStateDry[playerid][i]);
	    PlayerTextDrawHide(playerid,PresonStateHunger[playerid][i]);
	    PlayerTextDrawHide(playerid,PresonStateHP[playerid][i]);
	    PlayerTextDrawHide(playerid,PresonStateStamina[playerid][i]);
	}
//	PlayerTextDrawHide(playerid,PresonStateIcon[playerid]);
    PresonStateShow[playerid]=false;
	return 1;
}
FUNC::UpdatePlayerDryBar(playerid,Float:CurrentDry)
{
    if(RealPlayer(playerid))
    {
        if(PresonStateShow[playerid]==true)
        {
		    new Float:Percentage=floatdiv(CurrentDry,floatadd(DEFAULT_MAX_DRY,Addition[playerid][_Dry]));
			if(Percentage>1.0)
			{
				Percentage=1.0;
				Account[playerid][_Dry]=floatadd(DEFAULT_MAX_HUNGER,Addition[playerid][_Dry]);
			}
			if(Percentage<0.0)Percentage=0.0;
			//printf("UpdatePlayerDryBar:%f - %f",CurrentDry,Percentage);
		    PlayerTextDrawTextSize(playerid, PresonStateDry[playerid][0], floatmul(103.500000,Percentage), 12.000000);
		    formatex32("%i%",floatround(floatmul(Percentage,100),floatround_floor));
		    PlayerTextDrawSetString(playerid,PresonStateDry[playerid][1],string32);
			PlayerTextDrawShow(playerid,PresonStateDry[playerid][0]);
			PlayerTextDrawShow(playerid,PresonStateDry[playerid][1]);
		}
	}
	return 1;
}
FUNC::UpdatePlayerStaminaBar(playerid,Float:CurrentStamina)
{
    if(RealPlayer(playerid))
    {
        if(PresonStateShow[playerid]==true)
        {
		    new Float:Percentage=floatdiv(CurrentStamina,floatadd(DEFAULT_MAX_STAMINA,Addition[playerid][_Stamina]));
			if(Percentage>1.0)
			{
				Percentage=1.0;
				Account[playerid][_Stamina]=floatadd(DEFAULT_MAX_STAMINA,Addition[playerid][_Stamina]);
			}
			if(Percentage<0.0)Percentage=0.0;
			//printf("UpdatePlayerStaminaBar:%f - %f",CurrentStamina,Percentage);
		    PlayerTextDrawTextSize(playerid, PresonStateStamina[playerid][0], floatmul(103.500000,Percentage), 12.000000);
		    formatex32("%i%",floatround(floatmul(Percentage,100),floatround_floor));
		    PlayerTextDrawSetString(playerid,PresonStateStamina[playerid][1],string32);
			PlayerTextDrawShow(playerid,PresonStateStamina[playerid][0]);
			PlayerTextDrawShow(playerid,PresonStateStamina[playerid][1]);
		}
	}
	return 1;
}
FUNC::UpdatePlayerHungerBar(playerid,Float:CurrentHunger)
{
    if(RealPlayer(playerid))
    {
        if(PresonStateShow[playerid]==true)
        {
		    new Float:Percentage=floatdiv(CurrentHunger,floatadd(DEFAULT_MAX_HUNGER,Addition[playerid][_Hunger]));
			if(Percentage>1.0)
			{
				Percentage=1.0;
				Account[playerid][_Hunger]=floatadd(DEFAULT_MAX_HUNGER,Addition[playerid][_Hunger]);
			}
			if(Percentage<0.0)Percentage=0.0;
			//printf("UpdatePlayerHungerBar:%f - %f",CurrentHunger,Percentage);
		    PlayerTextDrawTextSize(playerid, PresonStateHunger[playerid][0], floatmul(103.500000,Percentage), 12.000000);
		    formatex32("%i%",floatround(floatmul(Percentage,100),floatround_floor));
		    PlayerTextDrawSetString(playerid,PresonStateHunger[playerid][1],string32);
			PlayerTextDrawShow(playerid,PresonStateHunger[playerid][0]);
			PlayerTextDrawShow(playerid,PresonStateHunger[playerid][1]);
		}
	}
	return 1;
}
FUNC::UpdatePlayerHpBar(playerid,Float:CurrentHp)
{
    if(RealPlayer(playerid))
    {
        if(PresonStateShow[playerid]==true)
        {
		    new Float:Percentage=floatdiv(CurrentHp,floatadd(DEFAULT_MAX_HP,Addition[playerid][_Hp]));
			if(Percentage>1.0)
			{
				Percentage=1.0;
				SetPlayerHealth(playerid,floatadd(DEFAULT_MAX_HP,Addition[playerid][_Hp]));
			}
			if(Percentage<0.0)Percentage=0.0;
			//printf("UpdatePlayerHpBar:%f - %f",CurrentHp,Percentage);
		    PlayerTextDrawTextSize(playerid, PresonStateHP[playerid][0], floatmul(103.500000,Percentage), 12.000000);
		    formatex32("%i%",floatround(floatmul(Percentage,100),floatround_floor));
		    PlayerTextDrawSetString(playerid,PresonStateHP[playerid][1],string32);
			PlayerTextDrawShow(playerid,PresonStateHP[playerid][0]);
			PlayerTextDrawShow(playerid,PresonStateHP[playerid][1]);
		}
	}
	return 1;
}

