new Text:ComTextDraw[3]= {Text:INVALID_TEXT_DRAW, ...};
new bool:ComeTextDrawShow[MAX_PLAYERS]= {false, ...};
new Timer:PlayerComePicturePlay[MAX_PLAYERS]= {NONE, ...};
/****************************************************/
new Text:CitySelectTextDraw[16]= {Text:INVALID_TEXT_DRAW, ...};
new bool:CitySelectTextDrawShow[MAX_PLAYERS]= {false, ...};
/****************************************************/
#define MAX_SKIN_SELECT 4
new PlayerText:PlayerSkinSelectTextDraw[MAX_PLAYERS][MAX_SKIN_SELECT];
new bool:PlayerSkinSelectDrawShow[MAX_PLAYERS]= {false, ...};
new PlayerSkinSelectShowID[MAX_PLAYERS]= {NONE, ...};
new PlayerSkinSelectSex[MAX_PLAYERS]= {0, ...};
new Text:SkinSelectTextDraw[2]= {Text:INVALID_TEXT_DRAW, ...};
//////////////////////////////////////////////////////////////
FUNC::Come_OnPlayerConnect(playerid)
{
	Come_OnPlayerDisconnect(playerid);
/////////////////////////////////////////////////////////////////////////////////Æ¤·ôÑ¡Ôñ
	PlayerSkinSelectTextDraw[playerid][1] = CreatePlayerTextDraw(playerid, 55.000000, 80.000000, "Nowy_TextDraw");
	PlayerTextDrawFont(playerid, PlayerSkinSelectTextDraw[playerid][1], 5);
	PlayerTextDrawLetterSize(playerid, PlayerSkinSelectTextDraw[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerSkinSelectTextDraw[playerid][1], 270.000000, 270.000000);
	PlayerTextDrawSetOutline(playerid, PlayerSkinSelectTextDraw[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, PlayerSkinSelectTextDraw[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, PlayerSkinSelectTextDraw[playerid][1], 1);
	PlayerTextDrawColor(playerid, PlayerSkinSelectTextDraw[playerid][1], -31);
	PlayerTextDrawBackgroundColor(playerid, PlayerSkinSelectTextDraw[playerid][1], 0);
	PlayerTextDrawBoxColor(playerid, PlayerSkinSelectTextDraw[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, PlayerSkinSelectTextDraw[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, PlayerSkinSelectTextDraw[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerSkinSelectTextDraw[playerid][1], 1);
	PlayerTextDrawSetPreviewModel(playerid, PlayerSkinSelectTextDraw[playerid][1], 0);
	PlayerTextDrawSetPreviewRot(playerid, PlayerSkinSelectTextDraw[playerid][1], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, PlayerSkinSelectTextDraw[playerid][1], 1, 1);

	PlayerSkinSelectTextDraw[playerid][0] = CreatePlayerTextDraw(playerid, -22.000000, 118.000000, "Nowy_TextDraw");
	PlayerTextDrawFont(playerid, PlayerSkinSelectTextDraw[playerid][0], 5);
	PlayerTextDrawLetterSize(playerid, PlayerSkinSelectTextDraw[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerSkinSelectTextDraw[playerid][0], 200.000000, 200.000000);
	PlayerTextDrawSetOutline(playerid, PlayerSkinSelectTextDraw[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, PlayerSkinSelectTextDraw[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, PlayerSkinSelectTextDraw[playerid][0], 1);
	PlayerTextDrawColor(playerid, PlayerSkinSelectTextDraw[playerid][0], -56);
	PlayerTextDrawBackgroundColor(playerid, PlayerSkinSelectTextDraw[playerid][0], 0);
	PlayerTextDrawBoxColor(playerid, PlayerSkinSelectTextDraw[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, PlayerSkinSelectTextDraw[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, PlayerSkinSelectTextDraw[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerSkinSelectTextDraw[playerid][0], 0);
	PlayerTextDrawSetPreviewModel(playerid, PlayerSkinSelectTextDraw[playerid][0], 0);
	PlayerTextDrawSetPreviewRot(playerid, PlayerSkinSelectTextDraw[playerid][0], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, PlayerSkinSelectTextDraw[playerid][0], 1, 1);

	PlayerSkinSelectTextDraw[playerid][2] = CreatePlayerTextDraw(playerid, 315.000000, 80.000000, "Nowy_TextDraw");
	PlayerTextDrawFont(playerid, PlayerSkinSelectTextDraw[playerid][2], 5);
	PlayerTextDrawLetterSize(playerid, PlayerSkinSelectTextDraw[playerid][2], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerSkinSelectTextDraw[playerid][2], 270.000000, 270.000000);
	PlayerTextDrawSetOutline(playerid, PlayerSkinSelectTextDraw[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, PlayerSkinSelectTextDraw[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, PlayerSkinSelectTextDraw[playerid][2], 1);
	PlayerTextDrawColor(playerid, PlayerSkinSelectTextDraw[playerid][2], -31);
	PlayerTextDrawBackgroundColor(playerid, PlayerSkinSelectTextDraw[playerid][2], 0);
	PlayerTextDrawBoxColor(playerid, PlayerSkinSelectTextDraw[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, PlayerSkinSelectTextDraw[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, PlayerSkinSelectTextDraw[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerSkinSelectTextDraw[playerid][2], 1);
	PlayerTextDrawSetPreviewModel(playerid, PlayerSkinSelectTextDraw[playerid][2], 0);
	PlayerTextDrawSetPreviewRot(playerid, PlayerSkinSelectTextDraw[playerid][2], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, PlayerSkinSelectTextDraw[playerid][2], 1, 1);

	PlayerSkinSelectTextDraw[playerid][3] = CreatePlayerTextDraw(playerid, 458.000000, 118.000000, "Nowy_TextDraw");
	PlayerTextDrawFont(playerid, PlayerSkinSelectTextDraw[playerid][3], 5);
	PlayerTextDrawLetterSize(playerid, PlayerSkinSelectTextDraw[playerid][3], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerSkinSelectTextDraw[playerid][3], 200.000000, 200.000000);
	PlayerTextDrawSetOutline(playerid, PlayerSkinSelectTextDraw[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, PlayerSkinSelectTextDraw[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, PlayerSkinSelectTextDraw[playerid][3], 1);
	PlayerTextDrawColor(playerid, PlayerSkinSelectTextDraw[playerid][3], -56);
	PlayerTextDrawBackgroundColor(playerid, PlayerSkinSelectTextDraw[playerid][3], 0);
	PlayerTextDrawBoxColor(playerid, PlayerSkinSelectTextDraw[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, PlayerSkinSelectTextDraw[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, PlayerSkinSelectTextDraw[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerSkinSelectTextDraw[playerid][3], 0);
	PlayerTextDrawSetPreviewModel(playerid, PlayerSkinSelectTextDraw[playerid][3], 0);
	PlayerTextDrawSetPreviewRot(playerid, PlayerSkinSelectTextDraw[playerid][3], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, PlayerSkinSelectTextDraw[playerid][3], 1, 1);
/////////////////////////////////////////////////////////////////////////////////
	CitySelectTextDrawShow[playerid]=false;
	return 1;
}
FUNC::Come_OnPlayerDisconnect(playerid)
{
 	if(Timer:PlayerComePicturePlay[playerid]!=NONE)KillTimer(Timer:PlayerComePicturePlay[playerid]);
    Timer:PlayerComePicturePlay[playerid]=NONE;
	ComeTextDrawShow[playerid]=false;

	CitySelectTextDrawShow[playerid]=false;
	/////////////////////////////////////////
	PlayerSkinSelectSex[playerid]=0;
	PlayerSkinSelectDrawShow[playerid]=false;
	PlayerSkinSelectShowID[playerid]=NONE;
	forex(i,MAX_SKIN_SELECT)
	{
		if(PlayerSkinSelectTextDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerSkinSelectTextDraw[playerid][i]);
		PlayerSkinSelectTextDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
	}
	return 1;
}
FUNC::Come_OnPlayerRequestClass(playerid)
{
	TogglePlayerSpectating(playerid,1);
	ShowPlayerComeTextDraw(playerid);
	return 1;
}

FUNC::Come_OnGameModeInit()
{
	forex(i,MAX_PLAYERS)
	{
		forex(s,MAX_SKIN_SELECT)
		{
			PlayerSkinSelectTextDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
		}
	}

	ComTextDraw[0] = TextDrawCreate(-1.000000, -1.000000, "mdl-2002:LoginBackGround");
	TextDrawFont(ComTextDraw[0], 4);
	TextDrawLetterSize(ComTextDraw[0], 0.600000, 2.000000);
	TextDrawTextSize(ComTextDraw[0], 642.000000, 452.500000);
	TextDrawSetOutline(ComTextDraw[0], 2);
	TextDrawSetShadow(ComTextDraw[0], 0);
	TextDrawAlignment(ComTextDraw[0], 1);
	TextDrawColor(ComTextDraw[0], -1);
	TextDrawBackgroundColor(ComTextDraw[0], 255);
	TextDrawBoxColor(ComTextDraw[0], 50);
	TextDrawUseBox(ComTextDraw[0], 1);
	TextDrawSetProportional(ComTextDraw[0], 1);
	TextDrawSetSelectable(ComTextDraw[0], 0);


	ComTextDraw[1] = TextDrawCreate(201.000000, 401.000000, "mdl-2002:RegBotton");
	TextDrawFont(ComTextDraw[1], 4);
	TextDrawLetterSize(ComTextDraw[1], 0.600000, 2.000000);
	TextDrawTextSize(ComTextDraw[1], 94.500000, 31.500000);
	TextDrawSetOutline(ComTextDraw[1], 1);
	TextDrawSetShadow(ComTextDraw[1], 0);
	TextDrawAlignment(ComTextDraw[1], 1);
	TextDrawColor(ComTextDraw[1], -1);
	TextDrawBackgroundColor(ComTextDraw[1], 255);
	TextDrawBoxColor(ComTextDraw[1], 50);
	TextDrawUseBox(ComTextDraw[1], 1);
	TextDrawSetProportional(ComTextDraw[1], 1);
	TextDrawSetSelectable(ComTextDraw[1], 1);

	ComTextDraw[2] = TextDrawCreate(335.000000, 401.000000, "mdl-2002:LoginBotton");
	TextDrawFont(ComTextDraw[2], 4);
	TextDrawLetterSize(ComTextDraw[2], 0.600000, 2.000000);
	TextDrawTextSize(ComTextDraw[2], 94.500000, 31.500000);
	TextDrawSetOutline(ComTextDraw[2], 1);
	TextDrawSetShadow(ComTextDraw[2], 0);
	TextDrawAlignment(ComTextDraw[2], 1);
	TextDrawColor(ComTextDraw[2], -1);
	TextDrawBackgroundColor(ComTextDraw[2], 255);
	TextDrawBoxColor(ComTextDraw[2], 50);
	TextDrawUseBox(ComTextDraw[2], 1);
	TextDrawSetProportional(ComTextDraw[2], 0);
	TextDrawSetSelectable(ComTextDraw[2], 1);

	
    CitySelectTextDraw[0] = TextDrawCreate(149.999954, 73.281517, "mdl-2003:xcamdlg_stretched");
	TextDrawLetterSize(CitySelectTextDraw[0], 0.000000, 0.000000);
	TextDrawTextSize(CitySelectTextDraw[0], 344.000000, 296.000000);
	TextDrawAlignment(CitySelectTextDraw[0], 1);
	TextDrawColor(CitySelectTextDraw[0], -1);
	TextDrawSetShadow(CitySelectTextDraw[0], 0);
	TextDrawSetOutline(CitySelectTextDraw[0], 0);
	TextDrawBackgroundColor(CitySelectTextDraw[0], 255);
	TextDrawFont(CitySelectTextDraw[0], 4);
	TextDrawSetProportional(CitySelectTextDraw[0], 0);
	TextDrawSetShadow(CitySelectTextDraw[0], 0);

	CitySelectTextDraw[1] = TextDrawCreate(320.666351, 110.199989, "samaps:gtasamapbit2");
	TextDrawLetterSize(CitySelectTextDraw[1], 0.000000, 0.000000);
	TextDrawTextSize(CitySelectTextDraw[1], 110.000000, 110.000000);
	TextDrawAlignment(CitySelectTextDraw[1], 1);
	TextDrawColor(CitySelectTextDraw[1], -1);
	TextDrawSetShadow(CitySelectTextDraw[1], 0);
	TextDrawSetOutline(CitySelectTextDraw[1], 0);
	TextDrawBackgroundColor(CitySelectTextDraw[1], 255);
	TextDrawFont(CitySelectTextDraw[1], 4);
	TextDrawSetProportional(CitySelectTextDraw[1], 0);
	TextDrawSetShadow(CitySelectTextDraw[1], 0);

	CitySelectTextDraw[2] = TextDrawCreate(210.666671, 110.199974, "samaps:gtasamapbit1");
	TextDrawLetterSize(CitySelectTextDraw[2], 0.000000, 0.000000);
	TextDrawTextSize(CitySelectTextDraw[2], 110.000000, 110.000000);
	TextDrawAlignment(CitySelectTextDraw[2], 1);
	TextDrawColor(CitySelectTextDraw[2], -1);
	TextDrawSetShadow(CitySelectTextDraw[2], 0);
	TextDrawSetOutline(CitySelectTextDraw[2], 0);
	TextDrawBackgroundColor(CitySelectTextDraw[2], 255);
	TextDrawFont(CitySelectTextDraw[2], 4);
	TextDrawSetProportional(CitySelectTextDraw[2], 0);
	TextDrawSetShadow(CitySelectTextDraw[2], 0);

	CitySelectTextDraw[3] = TextDrawCreate(210.666702, 219.711059, "samaps:gtasamapbit3");
	TextDrawLetterSize(CitySelectTextDraw[3], 0.000000, 0.000000);
	TextDrawTextSize(CitySelectTextDraw[3], 110.000000, 110.000000);
	TextDrawAlignment(CitySelectTextDraw[3], 1);
	TextDrawColor(CitySelectTextDraw[3], -1);
	TextDrawSetShadow(CitySelectTextDraw[3], 0);
	TextDrawSetOutline(CitySelectTextDraw[3], 0);
	TextDrawBackgroundColor(CitySelectTextDraw[3], 255);
	TextDrawFont(CitySelectTextDraw[3], 4);
	TextDrawSetProportional(CitySelectTextDraw[3], 0);
	TextDrawSetShadow(CitySelectTextDraw[3], 0);

	CitySelectTextDraw[4] = TextDrawCreate(320.666442, 219.711105, "samaps:gtasamapbit4");
	TextDrawLetterSize(CitySelectTextDraw[4], 0.000000, 0.000000);
	TextDrawTextSize(CitySelectTextDraw[4], 110.000000, 110.000000);
	TextDrawAlignment(CitySelectTextDraw[4], 1);
	TextDrawColor(CitySelectTextDraw[4], -1);
	TextDrawSetShadow(CitySelectTextDraw[4], 0);
	TextDrawSetOutline(CitySelectTextDraw[4], 0);
	TextDrawBackgroundColor(CitySelectTextDraw[4], 255);
	TextDrawFont(CitySelectTextDraw[4], 4);
	TextDrawSetProportional(CitySelectTextDraw[4], 0);
	TextDrawSetShadow(CitySelectTextDraw[4], 0);

	CitySelectTextDraw[5] = TextDrawCreate(355.333068, 199.800048, "mdl-2002:city_yiya");
	TextDrawLetterSize(CitySelectTextDraw[5], 0.000000, 0.000000);
	TextDrawTextSize(CitySelectTextDraw[5], 42.000000, 20.000000);
	TextDrawAlignment(CitySelectTextDraw[5], 1);
	TextDrawColor(CitySelectTextDraw[5], 65535);
	TextDrawSetShadow(CitySelectTextDraw[5], 0);
	TextDrawSetOutline(CitySelectTextDraw[5], 0);
	TextDrawBackgroundColor(CitySelectTextDraw[5], 255);
	TextDrawFont(CitySelectTextDraw[5], 4);
	TextDrawSetProportional(CitySelectTextDraw[5], 0);
	TextDrawSetShadow(CitySelectTextDraw[5], 0);
	TextDrawSetSelectable(CitySelectTextDraw[5], true);

	CitySelectTextDraw[6] = TextDrawCreate(394.332855, 207.681564, "mdl-2002:city_naluola");
	TextDrawLetterSize(CitySelectTextDraw[6], 0.000000, 0.000000);
	TextDrawTextSize(CitySelectTextDraw[6], 32.000000, 20.000000);
	TextDrawAlignment(CitySelectTextDraw[6], 1);
	TextDrawColor(CitySelectTextDraw[6], 65535);
	TextDrawSetShadow(CitySelectTextDraw[6], 0);
	TextDrawSetOutline(CitySelectTextDraw[6], 0);
	TextDrawBackgroundColor(CitySelectTextDraw[6], 255);
	TextDrawFont(CitySelectTextDraw[6], 4);
	TextDrawSetProportional(CitySelectTextDraw[6], 0);
	TextDrawSetShadow(CitySelectTextDraw[6], 0);
	TextDrawSetSelectable(CitySelectTextDraw[6], true);

	CitySelectTextDraw[7] = TextDrawCreate(230.999526, 303.918609, "mdl-2002:city_getaliya");
	TextDrawLetterSize(CitySelectTextDraw[7], 0.000000, 0.000000);
	TextDrawTextSize(CitySelectTextDraw[7], 32.000000, 21.000000);
	TextDrawAlignment(CitySelectTextDraw[7], 1);
	TextDrawColor(CitySelectTextDraw[7], 65535);
	TextDrawSetShadow(CitySelectTextDraw[7], 0);
	TextDrawSetOutline(CitySelectTextDraw[7], 0);
	TextDrawBackgroundColor(CitySelectTextDraw[7], 255);
	TextDrawFont(CitySelectTextDraw[7], 4);
	TextDrawSetProportional(CitySelectTextDraw[7], 0);
	TextDrawSetShadow(CitySelectTextDraw[7], 0);
	TextDrawSetSelectable(CitySelectTextDraw[7], true);

	CitySelectTextDraw[8] = TextDrawCreate(302.666137, 167.444610, "mdl-2002:city_keerma");
	TextDrawLetterSize(CitySelectTextDraw[8], 0.000000, 0.000000);
	TextDrawTextSize(CitySelectTextDraw[8], 32.000000, 20.000000);
	TextDrawAlignment(CitySelectTextDraw[8], 1);
	TextDrawColor(CitySelectTextDraw[8], 65535);
	TextDrawSetShadow(CitySelectTextDraw[8], 0);
	TextDrawSetOutline(CitySelectTextDraw[8], 0);
	TextDrawBackgroundColor(CitySelectTextDraw[8], 255);
	TextDrawFont(CitySelectTextDraw[8], 4);
	TextDrawSetProportional(CitySelectTextDraw[8], 0);
	TextDrawSetShadow(CitySelectTextDraw[8], 0);
	TextDrawSetSelectable(CitySelectTextDraw[8], true);

	CitySelectTextDraw[9] = TextDrawCreate(314.999816, 213.074066, "mdl-2002:city_jiweini");
	TextDrawLetterSize(CitySelectTextDraw[9], 0.000000, 0.000000);
	TextDrawTextSize(CitySelectTextDraw[9], 32.000000, 20.000000);
	TextDrawAlignment(CitySelectTextDraw[9], 1);
	TextDrawColor(CitySelectTextDraw[9], 65535);
	TextDrawSetShadow(CitySelectTextDraw[9], 0);
	TextDrawSetOutline(CitySelectTextDraw[9], 0);
	TextDrawBackgroundColor(CitySelectTextDraw[9], 255);
	TextDrawFont(CitySelectTextDraw[9], 4);
	TextDrawSetProportional(CitySelectTextDraw[9], 0);
	TextDrawSetShadow(CitySelectTextDraw[9], 0);
	TextDrawSetSelectable(CitySelectTextDraw[9], true);

	CitySelectTextDraw[10] = TextDrawCreate(360.666229, 259.118499, "mdl-2002:city_jiujinshan");
	TextDrawLetterSize(CitySelectTextDraw[10], 0.000000, 0.000000);
	TextDrawTextSize(CitySelectTextDraw[10], 66.000000, 37.000000);
	TextDrawAlignment(CitySelectTextDraw[10], 1);
	TextDrawColor(CitySelectTextDraw[10], -16776961);
	TextDrawSetShadow(CitySelectTextDraw[10], 0);
	TextDrawSetOutline(CitySelectTextDraw[10], 0);
	TextDrawBackgroundColor(CitySelectTextDraw[10], 255);
	TextDrawFont(CitySelectTextDraw[10], 4);
	TextDrawSetProportional(CitySelectTextDraw[10], 0);
	TextDrawSetShadow(CitySelectTextDraw[10], 0);
	TextDrawSetSelectable(CitySelectTextDraw[10], true);

	CitySelectTextDraw[11] = TextDrawCreate(352.666259, 145.044540, "mdl-2002:city_lasiweijiasi");
	TextDrawLetterSize(CitySelectTextDraw[11], 0.000000, 0.000000);
	TextDrawTextSize(CitySelectTextDraw[11], 80.000000, 45.000000);
	TextDrawAlignment(CitySelectTextDraw[11], 1);
	TextDrawColor(CitySelectTextDraw[11], -16776961);
	TextDrawSetShadow(CitySelectTextDraw[11], 0);
	TextDrawSetOutline(CitySelectTextDraw[11], 0);
	TextDrawBackgroundColor(CitySelectTextDraw[11], 255);
	TextDrawFont(CitySelectTextDraw[11], 4);
	TextDrawSetProportional(CitySelectTextDraw[11], 0);
	TextDrawSetShadow(CitySelectTextDraw[11], 0);
	TextDrawSetSelectable(CitySelectTextDraw[11], true);

	CitySelectTextDraw[12] = TextDrawCreate(213.000045, 192.333343, "mdl-2002:city_luoshanji");
	TextDrawLetterSize(CitySelectTextDraw[12], 0.000000, 0.000000);
	TextDrawTextSize(CitySelectTextDraw[12], 69.000000, 35.000000);
	TextDrawAlignment(CitySelectTextDraw[12], 1);
	TextDrawColor(CitySelectTextDraw[12], -1);
	TextDrawSetShadow(CitySelectTextDraw[12], 0);
	TextDrawSetOutline(CitySelectTextDraw[12], 0);
	TextDrawBackgroundColor(CitySelectTextDraw[12], 255);
	TextDrawFont(CitySelectTextDraw[12], 4);
	TextDrawSetProportional(CitySelectTextDraw[12], 0);
	TextDrawSetShadow(CitySelectTextDraw[12], 0);
	TextDrawSetSelectable(CitySelectTextDraw[12], true);

	CitySelectTextDraw[13] = TextDrawCreate(263.666412, 69.133323, "mdl-2003:spawn_tag");
	TextDrawLetterSize(CitySelectTextDraw[13], 0.000000, 0.000000);
	TextDrawTextSize(CitySelectTextDraw[13], 115.000000, 71.000000);
	TextDrawAlignment(CitySelectTextDraw[13], 1);
	TextDrawColor(CitySelectTextDraw[13], -1);
	TextDrawSetShadow(CitySelectTextDraw[13], 0);
	TextDrawSetOutline(CitySelectTextDraw[13], 0);
	TextDrawBackgroundColor(CitySelectTextDraw[13], 255);
	TextDrawFont(CitySelectTextDraw[13], 4);
	TextDrawSetProportional(CitySelectTextDraw[13], 0);
	TextDrawSetShadow(CitySelectTextDraw[13], 0);

	CitySelectTextDraw[14] = TextDrawCreate(332.333099, 334.614654, "mdl-2003:city");
	TextDrawLetterSize(CitySelectTextDraw[14], 0.000000, 0.000000);
	TextDrawTextSize(CitySelectTextDraw[14], 73.000000, 27.000000);
	TextDrawAlignment(CitySelectTextDraw[14], 1);
	TextDrawColor(CitySelectTextDraw[14], -1);
	TextDrawSetShadow(CitySelectTextDraw[14], 0);
	TextDrawSetOutline(CitySelectTextDraw[14], 0);
	TextDrawBackgroundColor(CitySelectTextDraw[14], 255);
	TextDrawFont(CitySelectTextDraw[14], 4);
	TextDrawSetProportional(CitySelectTextDraw[14], 0);
	TextDrawSetShadow(CitySelectTextDraw[14], 0);

	CitySelectTextDraw[15] = TextDrawCreate(255.333312, 334.614654, "mdl-2003:town");
	TextDrawLetterSize(CitySelectTextDraw[15], 0.000000, 0.000000);
	TextDrawTextSize(CitySelectTextDraw[15], 73.000000, 27.000000);
	TextDrawAlignment(CitySelectTextDraw[15], 1);
	TextDrawColor(CitySelectTextDraw[15], -1);
	TextDrawSetShadow(CitySelectTextDraw[15], 0);
	TextDrawSetOutline(CitySelectTextDraw[15], 0);
	TextDrawBackgroundColor(CitySelectTextDraw[15], 255);
	TextDrawFont(CitySelectTextDraw[15], 4);
	TextDrawSetProportional(CitySelectTextDraw[15], 0);
	TextDrawSetShadow(CitySelectTextDraw[15], 0);
	//////////////////////////////////////////////////////////////////////////////
	SkinSelectTextDraw[0] = TextDrawCreate(283.000000, 5.000000, "mdl-2000:Sex");
	TextDrawFont(SkinSelectTextDraw[0], 4);
	TextDrawLetterSize(SkinSelectTextDraw[0], 0.600000, 2.000000);
	TextDrawTextSize(SkinSelectTextDraw[0], 110.500000, 42.500000);
	TextDrawSetOutline(SkinSelectTextDraw[0], 1);
	TextDrawSetShadow(SkinSelectTextDraw[0], 0);
	TextDrawAlignment(SkinSelectTextDraw[0], 1);
	TextDrawColor(SkinSelectTextDraw[0], -16777066);
	TextDrawBackgroundColor(SkinSelectTextDraw[0], 255);
	TextDrawBoxColor(SkinSelectTextDraw[0], 50);
	TextDrawUseBox(SkinSelectTextDraw[0], 1);
	TextDrawSetProportional(SkinSelectTextDraw[0], 1);
	TextDrawSetSelectable(SkinSelectTextDraw[0], 1);

	SkinSelectTextDraw[1] = TextDrawCreate(306.000000, 410.000000, "mdl-2000:Finish");
	TextDrawFont(SkinSelectTextDraw[1], 4);
	TextDrawLetterSize(SkinSelectTextDraw[1], 0.600000, 2.000000);
	TextDrawTextSize(SkinSelectTextDraw[1], 110.500000, 42.500000);
	TextDrawSetOutline(SkinSelectTextDraw[1], 1);
	TextDrawSetShadow(SkinSelectTextDraw[1], 0);
	TextDrawAlignment(SkinSelectTextDraw[1], 1);
	TextDrawColor(SkinSelectTextDraw[1], -106);
	TextDrawBackgroundColor(SkinSelectTextDraw[1], 255);
	TextDrawBoxColor(SkinSelectTextDraw[1], 50);
	TextDrawUseBox(SkinSelectTextDraw[1], 1);
	TextDrawSetProportional(SkinSelectTextDraw[1], 1);
	TextDrawSetSelectable(SkinSelectTextDraw[1], 1);
	return 1;
}

/************************************************************************/
FUNC::ShowPlayerCitySelectTextDraw(playerid)
{
	forex(i,sizeof(CitySelectTextDraw))TextDrawShowForPlayer(playerid,CitySelectTextDraw[i]);
	CitySelectTextDrawShow[playerid]=true;
	return 1;
}
FUNC::HidePlayerCitySelectTextDraw(playerid)
{
	forex(i,sizeof(CitySelectTextDraw))TextDrawHideForPlayer(playerid,CitySelectTextDraw[i]);
	CitySelectTextDrawShow[playerid]=false;
	return 1;
}
/************************************************************************/
FUNC::ShowPlayerComeTextDraw(playerid)
{
    GetPlayerAccountData(playerid);
    HidePlayerComeTextDraw(playerid);
	/*forex(i,sizeof(ComTextDraw))*/
	TextDrawShowForPlayer(playerid,ComTextDraw[0]);
    ComeTextDrawShow[playerid]=true;
	return 1;
}
FUNC::HidePlayerComeTextDraw(playerid)
{
    forex(i,sizeof(ComTextDraw))TextDrawHideForPlayer(playerid,ComTextDraw[i]);
    ComeTextDrawShow[playerid]=false;
	return 1;
}
/*********************************************************************/
FUNC::ShowPlayerSkinSelectTextDraw(playerid,Sex,index)
{
	PlayerSkinSelectSex[playerid]=Sex;//NULL_MODEL
   	if(Sex==0)
   	{
   	    if(index>=sizeof(MaleSkin))
   	    {
   	        PlayerSkinSelectShowID[playerid]=sizeof(MaleSkin)-1;
   	    }
   	    else if(index<0)
   	    {
   	        PlayerSkinSelectShowID[playerid]=0;
   	    }
 	    else PlayerSkinSelectShowID[playerid]=index;
		forex(i,2)
		{
		    new IndexKey=0;
		    IndexKey=PlayerSkinSelectShowID[playerid]-2+i;
			if(IndexKey>=sizeof(MaleSkin)||IndexKey<0)
			{
			    PlayerTextDrawSetPreviewModel(playerid, PlayerSkinSelectTextDraw[playerid][i], NULL_MODEL);
				PlayerTextDrawShow(playerid, PlayerSkinSelectTextDraw[playerid][i]);
            }
			else
			{
				PlayerTextDrawSetPreviewModel(playerid, PlayerSkinSelectTextDraw[playerid][i], MaleSkin[IndexKey][_SkinID]);
				PlayerTextDrawShow(playerid, PlayerSkinSelectTextDraw[playerid][i]);
 			}
 		}
		loop(i,2,4)
		{
		    new IndexKey=-1;
		    IndexKey=PlayerSkinSelectShowID[playerid]+i-1;
			if(IndexKey>=sizeof(MaleSkin)||IndexKey<0)
			{
			    PlayerTextDrawSetPreviewModel(playerid, PlayerSkinSelectTextDraw[playerid][i], NULL_MODEL);
				PlayerTextDrawShow(playerid, PlayerSkinSelectTextDraw[playerid][i]);
            }
			else
			{
				PlayerTextDrawSetPreviewModel(playerid, PlayerSkinSelectTextDraw[playerid][i], MaleSkin[IndexKey][_SkinID]);
				PlayerTextDrawShow(playerid, PlayerSkinSelectTextDraw[playerid][i]);
			}
		}
		SetPlayerSkin(playerid,MaleSkin[PlayerSkinSelectShowID[playerid]][_SkinID]);
   	}
   	else
   	{
   	    if(index>sizeof(FaMaleSkin))
   	    {
   	        PlayerSkinSelectShowID[playerid]=sizeof(FaMaleSkin)-1;
   	    }
   	    else if(index<0)
   	    {
   	        PlayerSkinSelectShowID[playerid]=0;
   	    }
 	    else PlayerSkinSelectShowID[playerid]=index;
		forex(i,2)
		{
		    new IndexKey=0;
		    IndexKey=PlayerSkinSelectShowID[playerid]-2+i;
			if(IndexKey>=sizeof(FaMaleSkin)||IndexKey<0)
			{
			    PlayerTextDrawSetPreviewModel(playerid, PlayerSkinSelectTextDraw[playerid][i], NULL_MODEL);
				PlayerTextDrawShow(playerid, PlayerSkinSelectTextDraw[playerid][i]);
            }
			else
			{
				PlayerTextDrawSetPreviewModel(playerid, PlayerSkinSelectTextDraw[playerid][i], FaMaleSkin[IndexKey][_SkinID]);
				PlayerTextDrawShow(playerid, PlayerSkinSelectTextDraw[playerid][i]);
			}
		}
 		loop(i,2,4)
		{
		    new IndexKey=-1;
		    IndexKey=PlayerSkinSelectShowID[playerid]+i-1;
			if(IndexKey>=sizeof(FaMaleSkin)||IndexKey<0)
			{
			    PlayerTextDrawSetPreviewModel(playerid, PlayerSkinSelectTextDraw[playerid][i], NULL_MODEL);
				PlayerTextDrawShow(playerid, PlayerSkinSelectTextDraw[playerid][i]);
            }
			else
			{
				PlayerTextDrawSetPreviewModel(playerid, PlayerSkinSelectTextDraw[playerid][i], FaMaleSkin[IndexKey][_SkinID]);
				PlayerTextDrawShow(playerid, PlayerSkinSelectTextDraw[playerid][i]);
			}
		}
        SetPlayerSkin(playerid,FaMaleSkin[PlayerSkinSelectShowID[playerid]][_SkinID]);
   	}
	forex(i,MAX_SKIN_SELECT)PlayerTextDrawShow(playerid,PlayerSkinSelectTextDraw[playerid][i]);
	forex(i,2)TextDrawShowForPlayer(playerid,SkinSelectTextDraw[i]);
	PlayerSkinSelectDrawShow[playerid]=true;
	return 1;
}
FUNC::HidePlayerSkinSelectTextDraw(playerid)
{
    PlayerSkinSelectDrawShow[playerid]=false;
    forex(i,2)TextDrawHideForPlayer(playerid,SkinSelectTextDraw[i]);
    forex(i,MAX_SKIN_SELECT)PlayerTextDrawHide(playerid,PlayerSkinSelectTextDraw[playerid][i]);
	return 1;
}

