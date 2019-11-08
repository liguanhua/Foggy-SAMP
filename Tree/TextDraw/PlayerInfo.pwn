new Text:PlayerInfoBackTextDraw[2]= {Text:INVALID_TEXT_DRAW, ...};
#define MAX_PLAYERINFO_TEXTDRAWS 5
new PlayerText:PlayerInfoTextDraw[MAX_PLAYERS][MAX_PLAYERINFO_TEXTDRAWS];
new bool:PlayerInfoTextDrawShow[MAX_PLAYERS]= {false, ...};
FUNC::PlayerInfo_OnGameModeInit()
{
	forex(i,MAX_PLAYERS)
	{
		forex(s,MAX_PLAYERINFO_TEXTDRAWS)
		{
			PlayerInfoTextDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
		}
	}
	
	PlayerInfoBackTextDraw[0] = TextDrawCreate(-1.000000, 1.000000, "mdl-2003:glass");
	TextDrawFont(PlayerInfoBackTextDraw[0], 4);
	TextDrawLetterSize(PlayerInfoBackTextDraw[0], 0.600000, 2.000000);
	TextDrawTextSize(PlayerInfoBackTextDraw[0], 645.000000, 455.500000);
	TextDrawSetOutline(PlayerInfoBackTextDraw[0], 1);
	TextDrawSetShadow(PlayerInfoBackTextDraw[0], 0);
	TextDrawAlignment(PlayerInfoBackTextDraw[0], 1);
	TextDrawColor(PlayerInfoBackTextDraw[0], -186);
	TextDrawBackgroundColor(PlayerInfoBackTextDraw[0], 255);
	TextDrawBoxColor(PlayerInfoBackTextDraw[0], 50);
	TextDrawUseBox(PlayerInfoBackTextDraw[0], 1);
	TextDrawSetProportional(PlayerInfoBackTextDraw[0], 1);
	TextDrawSetSelectable(PlayerInfoBackTextDraw[0], 0);

/*	PlayerInfoBackTextDraw[1] = TextDrawCreate(178.000000, 14.000000, "mdl-2003:playerinfoback");
	TextDrawFont(PlayerInfoBackTextDraw[1], 4);
	TextDrawLetterSize(PlayerInfoBackTextDraw[1], 0.600000, 2.000000);
	TextDrawTextSize(PlayerInfoBackTextDraw[1], 283.500000, 391.500000);
	TextDrawSetOutline(PlayerInfoBackTextDraw[1], 1);
	TextDrawSetShadow(PlayerInfoBackTextDraw[1], 0);
	TextDrawAlignment(PlayerInfoBackTextDraw[1], 1);
	TextDrawColor(PlayerInfoBackTextDraw[1], -1);
	TextDrawBackgroundColor(PlayerInfoBackTextDraw[1], 255);
	TextDrawBoxColor(PlayerInfoBackTextDraw[1], 50);
	TextDrawUseBox(PlayerInfoBackTextDraw[1], 1);
	TextDrawSetProportional(PlayerInfoBackTextDraw[1], 1);
	TextDrawSetSelectable(PlayerInfoBackTextDraw[1], 0);*/
	
	PlayerInfoBackTextDraw[1] = TextDrawCreate(106.000000, 53.000000, "mdl-2003:playerinfoback");
	TextDrawFont(PlayerInfoBackTextDraw[1], 4);
	TextDrawLetterSize(PlayerInfoBackTextDraw[1], 0.600000, 2.000000);
	TextDrawTextSize(PlayerInfoBackTextDraw[1], 246.000000, 341.000000);
	TextDrawSetOutline(PlayerInfoBackTextDraw[1], 1);
	TextDrawSetShadow(PlayerInfoBackTextDraw[1], 0);
	TextDrawAlignment(PlayerInfoBackTextDraw[1], 1);
	TextDrawColor(PlayerInfoBackTextDraw[1], -1);
	TextDrawBackgroundColor(PlayerInfoBackTextDraw[1], 255);
	TextDrawBoxColor(PlayerInfoBackTextDraw[1], 50);
	TextDrawUseBox(PlayerInfoBackTextDraw[1], 1);
	TextDrawSetProportional(PlayerInfoBackTextDraw[1], 1);
	TextDrawSetSelectable(PlayerInfoBackTextDraw[1], 0);
	return 1;
}
FUNC::PlayerInfo_OnPlayerDisconnect(playerid)
{
	PlayerInfoTextDrawShow[playerid]=false;
	forex(i,MAX_PLAYERINFO_TEXTDRAWS)
	{
		if(PlayerInfoTextDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerInfoTextDraw[playerid][i]);
		PlayerInfoTextDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
	}
	return 1;
}
FUNC::PlayerInfo_OnPlayerConnect(playerid)
{
    PlayerInfoTextDrawShow[playerid]=false;
	PlayerInfoTextDraw[playerid][0] = CreatePlayerTextDraw(playerid, 229.000000, 145.000000, "100");//ÉÆ¶ñ
	PlayerTextDrawFont(playerid, PlayerInfoTextDraw[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, PlayerInfoTextDraw[playerid][0], 0.370833, 1.950000);
	PlayerTextDrawTextSize(playerid, PlayerInfoTextDraw[playerid][0], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerInfoTextDraw[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, PlayerInfoTextDraw[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, PlayerInfoTextDraw[playerid][0], 2);
	PlayerTextDrawColor(playerid, PlayerInfoTextDraw[playerid][0], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, PlayerInfoTextDraw[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, PlayerInfoTextDraw[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, PlayerInfoTextDraw[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, PlayerInfoTextDraw[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerInfoTextDraw[playerid][0], 0);

	PlayerInfoTextDraw[playerid][1] = CreatePlayerTextDraw(playerid, 229.000000, 166.000000, "100");//É±ÈËÊý
	PlayerTextDrawFont(playerid, PlayerInfoTextDraw[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, PlayerInfoTextDraw[playerid][1], 0.370833, 1.950000);
	PlayerTextDrawTextSize(playerid, PlayerInfoTextDraw[playerid][1], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerInfoTextDraw[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, PlayerInfoTextDraw[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, PlayerInfoTextDraw[playerid][1], 2);
	PlayerTextDrawColor(playerid, PlayerInfoTextDraw[playerid][1], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, PlayerInfoTextDraw[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, PlayerInfoTextDraw[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, PlayerInfoTextDraw[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, PlayerInfoTextDraw[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerInfoTextDraw[playerid][1], 0);

	PlayerInfoTextDraw[playerid][2] = CreatePlayerTextDraw(playerid, 229.000000, 190.000000, "100");//×Óµ¯¿Ç
	PlayerTextDrawFont(playerid, PlayerInfoTextDraw[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, PlayerInfoTextDraw[playerid][2], 0.370833, 1.950000);
	PlayerTextDrawTextSize(playerid, PlayerInfoTextDraw[playerid][2], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerInfoTextDraw[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, PlayerInfoTextDraw[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, PlayerInfoTextDraw[playerid][2], 2);
	PlayerTextDrawColor(playerid, PlayerInfoTextDraw[playerid][2], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, PlayerInfoTextDraw[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, PlayerInfoTextDraw[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, PlayerInfoTextDraw[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, PlayerInfoTextDraw[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerInfoTextDraw[playerid][2], 0);

	PlayerInfoTextDraw[playerid][3] = CreatePlayerTextDraw(playerid, 229.000000, 212.000000, "_");//ÕóÓª
	PlayerTextDrawFont(playerid, PlayerInfoTextDraw[playerid][3], 1);
	PlayerTextDrawLetterSize(playerid, PlayerInfoTextDraw[playerid][3], 0.370833, 1.950000);
	PlayerTextDrawTextSize(playerid, PlayerInfoTextDraw[playerid][3], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerInfoTextDraw[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, PlayerInfoTextDraw[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, PlayerInfoTextDraw[playerid][3], 2);
	PlayerTextDrawColor(playerid, PlayerInfoTextDraw[playerid][3], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, PlayerInfoTextDraw[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, PlayerInfoTextDraw[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, PlayerInfoTextDraw[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, PlayerInfoTextDraw[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerInfoTextDraw[playerid][3], 0);

	PlayerInfoTextDraw[playerid][4] = CreatePlayerTextDraw(playerid, 229.000000, 234.000000, "100");//½±ÅÆ
	PlayerTextDrawFont(playerid, PlayerInfoTextDraw[playerid][4], 1);
	PlayerTextDrawLetterSize(playerid, PlayerInfoTextDraw[playerid][4], 0.370833, 1.950000);
	PlayerTextDrawTextSize(playerid, PlayerInfoTextDraw[playerid][4], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerInfoTextDraw[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, PlayerInfoTextDraw[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, PlayerInfoTextDraw[playerid][4], 2);
	PlayerTextDrawColor(playerid, PlayerInfoTextDraw[playerid][4], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, PlayerInfoTextDraw[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, PlayerInfoTextDraw[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, PlayerInfoTextDraw[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, PlayerInfoTextDraw[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerInfoTextDraw[playerid][4], 0);
/*	PlayerInfoTextDraw[playerid][0] = CreatePlayerTextDraw(playerid, 320.000000, 94.000000, "_");//Ãû×Ö
	PlayerTextDrawFont(playerid, PlayerInfoTextDraw[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, PlayerInfoTextDraw[playerid][0], 0.370833, 1.950000);
	PlayerTextDrawTextSize(playerid, PlayerInfoTextDraw[playerid][0], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerInfoTextDraw[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, PlayerInfoTextDraw[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, PlayerInfoTextDraw[playerid][0], 2);
	PlayerTextDrawColor(playerid, PlayerInfoTextDraw[playerid][0], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, PlayerInfoTextDraw[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, PlayerInfoTextDraw[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, PlayerInfoTextDraw[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, PlayerInfoTextDraw[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerInfoTextDraw[playerid][0], 0);

	PlayerInfoTextDraw[playerid][1] = CreatePlayerTextDraw(playerid, 320.000000, 120.000000, "100");//ÉÆ¶ñ
	PlayerTextDrawFont(playerid, PlayerInfoTextDraw[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, PlayerInfoTextDraw[playerid][1], 0.370833, 1.950000);
	PlayerTextDrawTextSize(playerid, PlayerInfoTextDraw[playerid][1], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerInfoTextDraw[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, PlayerInfoTextDraw[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, PlayerInfoTextDraw[playerid][1], 2);
	PlayerTextDrawColor(playerid, PlayerInfoTextDraw[playerid][1], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, PlayerInfoTextDraw[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, PlayerInfoTextDraw[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, PlayerInfoTextDraw[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, PlayerInfoTextDraw[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerInfoTextDraw[playerid][1], 0);

	PlayerInfoTextDraw[playerid][2] = CreatePlayerTextDraw(playerid, 320.000000, 144.000000, "100");//É±ÈËÊý
	PlayerTextDrawFont(playerid, PlayerInfoTextDraw[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, PlayerInfoTextDraw[playerid][2], 0.370833, 1.950000);
	PlayerTextDrawTextSize(playerid, PlayerInfoTextDraw[playerid][2], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerInfoTextDraw[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, PlayerInfoTextDraw[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, PlayerInfoTextDraw[playerid][2], 2);
	PlayerTextDrawColor(playerid, PlayerInfoTextDraw[playerid][2], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, PlayerInfoTextDraw[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, PlayerInfoTextDraw[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, PlayerInfoTextDraw[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, PlayerInfoTextDraw[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerInfoTextDraw[playerid][2], 0);

	PlayerInfoTextDraw[playerid][3] = CreatePlayerTextDraw(playerid, 320.000000, 170.000000, "100");//×Óµ¯¿Ç
	PlayerTextDrawFont(playerid, PlayerInfoTextDraw[playerid][3], 1);
	PlayerTextDrawLetterSize(playerid, PlayerInfoTextDraw[playerid][3], 0.370833, 1.950000);
	PlayerTextDrawTextSize(playerid, PlayerInfoTextDraw[playerid][3], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerInfoTextDraw[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, PlayerInfoTextDraw[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, PlayerInfoTextDraw[playerid][3], 2);
	PlayerTextDrawColor(playerid, PlayerInfoTextDraw[playerid][3], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, PlayerInfoTextDraw[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, PlayerInfoTextDraw[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, PlayerInfoTextDraw[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, PlayerInfoTextDraw[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerInfoTextDraw[playerid][3], 0);

	PlayerInfoTextDraw[playerid][4] = CreatePlayerTextDraw(playerid, 320.000000, 199.000000, "_");//ÕóÓª
	PlayerTextDrawFont(playerid, PlayerInfoTextDraw[playerid][4], 1);
	PlayerTextDrawLetterSize(playerid, PlayerInfoTextDraw[playerid][4], 0.370833, 1.950000);
	PlayerTextDrawTextSize(playerid, PlayerInfoTextDraw[playerid][4], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerInfoTextDraw[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, PlayerInfoTextDraw[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, PlayerInfoTextDraw[playerid][4], 2);
	PlayerTextDrawColor(playerid, PlayerInfoTextDraw[playerid][4], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, PlayerInfoTextDraw[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, PlayerInfoTextDraw[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, PlayerInfoTextDraw[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, PlayerInfoTextDraw[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerInfoTextDraw[playerid][4], 0);

	PlayerInfoTextDraw[playerid][5] = CreatePlayerTextDraw(playerid, 320.000000, 226.000000, "100");//½±ÅÆ
	PlayerTextDrawFont(playerid, PlayerInfoTextDraw[playerid][5], 1);
	PlayerTextDrawLetterSize(playerid, PlayerInfoTextDraw[playerid][5], 0.370833, 1.950000);
	PlayerTextDrawTextSize(playerid, PlayerInfoTextDraw[playerid][5], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerInfoTextDraw[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, PlayerInfoTextDraw[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, PlayerInfoTextDraw[playerid][5], 2);
	PlayerTextDrawColor(playerid, PlayerInfoTextDraw[playerid][5], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, PlayerInfoTextDraw[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, PlayerInfoTextDraw[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, PlayerInfoTextDraw[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, PlayerInfoTextDraw[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerInfoTextDraw[playerid][5], 0);*/
	return 1;
}
FUNC::ShowPlayerInfoTextDraw(playerid)
{
	TogglePlayerControllable(playerid, 0);
	new Float:xyz[4][2],Float:Angles;
	if(!IsPlayerInAnyVehicle(playerid))
	{
		GetPlayerPos(playerid, xyz[0][0], xyz[1][0], xyz[2][0]);
		GetPlayerPos(playerid, xyz[0][1], xyz[1][1], xyz[2][1]);
		SetPlayerFacingAngle(playerid,0.0);
		GetPointInFront2D(xyz[0][0], xyz[1][0],0.0,3.0,xyz[0][0], xyz[1][0]);
	//	GetPointInFrontOfPlayer(playerid,xyz[0][0], xyz[1][0],2.7);
		SetPlayerCameraPos(playerid,xyz[0][0]+0.71, xyz[1][0],xyz[2][0]-0.1);
		SetPlayerCameraLookAt(playerid,xyz[0][1]+0.71, xyz[1][1], xyz[2][1]-0.1,CAMERA_CUT);
	}
	else
	{
		new vid=GetPlayerVehicleID(playerid);
		GetVehiclePos(vid, xyz[0][0], xyz[1][0], xyz[2][0]);
		GetVehiclePos(vid, xyz[0][1], xyz[1][1], xyz[2][1]);
		GetVehicleZAngle(vid,Angles);
		GetPointInFront2D(xyz[0][0], xyz[1][0],Angles,4.6,xyz[0][0], xyz[1][0]);
	    //GetPointInFrontOfVehicle2D(vid,xyz[0][0], xyz[1][0],4.6);
		SetPlayerCameraPos(playerid,xyz[0][0]+0.3, xyz[1][0],xyz[2][0]+0.3);
		SetPlayerCameraLookAt(playerid,xyz[0][1]+0.3, xyz[1][1], xyz[2][1]+0.3,CAMERA_CUT);
	}
	forex(i,sizeof(PlayerInfoBackTextDraw))TextDrawShowForPlayer(playerid,PlayerInfoBackTextDraw[i]);
	PlayerTextDrawSetString(playerid,PlayerInfoTextDraw[playerid][0],"0");
	PlayerTextDrawSetString(playerid,PlayerInfoTextDraw[playerid][1],"0");
	PlayerTextDrawSetString(playerid,PlayerInfoTextDraw[playerid][2],"0");
	if(PlayerFaction[playerid][_FactionID]!=NONE)format(string32,sizeof(string32),Faction[PlayerFaction[playerid][_FactionID]][_Name]);
	else format(string32,sizeof(string32),"_");
	printf(string32);
	PlayerTextDrawSetString(playerid,PlayerInfoTextDraw[playerid][3],string32);
	PlayerTextDrawSetString(playerid,PlayerInfoTextDraw[playerid][4],"0");
	forex(i,MAX_PLAYERINFO_TEXTDRAWS)PlayerTextDrawShow(playerid, PlayerInfoTextDraw[playerid][i]);
	PlayerInfoTextDrawShow[playerid]=true;
	return 1;
}
FUNC::HidePlayerInfoTextDraw(playerid)
{
	forex(i,sizeof(PlayerInfoBackTextDraw))TextDrawHideForPlayer(playerid,PlayerInfoBackTextDraw[i]);
	forex(i,MAX_PLAYERINFO_TEXTDRAWS)PlayerTextDrawHide(playerid, PlayerInfoTextDraw[playerid][i]);
	PlayerInfoTextDrawShow[playerid]=false;
	TogglePlayerControllable(playerid, 1);
	SetCameraBehindPlayer(playerid);
	return 1;
}



