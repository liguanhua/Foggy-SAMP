#define MAX_PLAYER_QUICKUSE_SLOT 3
new Text:QuickUseBackGroundTextDraw[3]= {Text:INVALID_TEXT_DRAW, ...};
new Text:QuickUseKeyTextDraw[3]= {Text:INVALID_TEXT_DRAW, ...};
new PlayerText:pQuickUseItemTextDraw[MAX_PLAYERS][MAX_PLAYER_QUICKUSE_SLOT];
new PlayerText:pQuickUseAmountTextDraw[MAX_PLAYERS][MAX_PLAYER_QUICKUSE_SLOT];
new bool:QuickUseShow[MAX_PLAYERS]= {false, ...};
new ClickQuickUseID[MAX_PLAYERS]= {NONE, ...};
/////////////////////////////////////////////////
new Text:BuffTimeBackGroundTextDraw=Text:INVALID_TEXT_DRAW;
new PlayerText:pBuffTimeBarTextDraw[MAX_PLAYERS]= {PlayerText:INVALID_TEXT_DRAW, ...};
new bool:BuffBarShow[MAX_PLAYERS]= {false, ...};

FUNC::ShowPlayerBuffBar(playerid,color)
{
	TextDrawShowForPlayer(playerid,BuffTimeBackGroundTextDraw);
	PlayerTextDrawTextSize(playerid, pBuffTimeBarTextDraw[playerid],0.0,2.000000);
	PlayerTextDrawColor(playerid, pBuffTimeBarTextDraw[playerid], color);
    PlayerTextDrawShow(playerid,pBuffTimeBarTextDraw[playerid]);
    BuffBarShow[playerid]=true;
	return 1;
}
FUNC::HidePlayerBuffBar(playerid)
{
	TextDrawHideForPlayer(playerid,BuffTimeBackGroundTextDraw);
    PlayerTextDrawHide(playerid,pBuffTimeBarTextDraw[playerid]);
    BuffBarShow[playerid]=false;
	return 1;
}
////////////////////////////////////////////////////
FUNC::QuickUse_OnPlayerConnect(playerid)
{
    QuickUseShow[playerid]=false;
    BuffBarShow[playerid]=false;
	pBuffTimeBarTextDraw[playerid] = CreatePlayerTextDraw(playerid, 269.000000, 400.000000, "LD_SPAC:WHITE");
	PlayerTextDrawFont(playerid, pBuffTimeBarTextDraw[playerid], 4);
	PlayerTextDrawLetterSize(playerid, pBuffTimeBarTextDraw[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, pBuffTimeBarTextDraw[playerid], 112.500000, 2.000000);
	PlayerTextDrawSetOutline(playerid, pBuffTimeBarTextDraw[playerid], 1);
	PlayerTextDrawSetShadow(playerid, pBuffTimeBarTextDraw[playerid], 0);
	PlayerTextDrawAlignment(playerid, pBuffTimeBarTextDraw[playerid], 1);
	PlayerTextDrawColor(playerid, pBuffTimeBarTextDraw[playerid], 2094792959);
	PlayerTextDrawBackgroundColor(playerid, pBuffTimeBarTextDraw[playerid], 255);
	PlayerTextDrawBoxColor(playerid, pBuffTimeBarTextDraw[playerid], 50);
	PlayerTextDrawUseBox(playerid, pBuffTimeBarTextDraw[playerid], 1);
	PlayerTextDrawSetProportional(playerid, pBuffTimeBarTextDraw[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, pBuffTimeBarTextDraw[playerid], 0);

	pQuickUseItemTextDraw[playerid][0] = CreatePlayerTextDraw(playerid, 268.000000, 402.000000, "Nowy_TextDraw");
	PlayerTextDrawFont(playerid, pQuickUseItemTextDraw[playerid][0], 5);
	PlayerTextDrawLetterSize(playerid, pQuickUseItemTextDraw[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, pQuickUseItemTextDraw[playerid][0], 40.000000, 46.000000);
	PlayerTextDrawSetOutline(playerid, pQuickUseItemTextDraw[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, pQuickUseItemTextDraw[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, pQuickUseItemTextDraw[playerid][0], 1);
	PlayerTextDrawColor(playerid, pQuickUseItemTextDraw[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, pQuickUseItemTextDraw[playerid][0], 0);
	PlayerTextDrawBoxColor(playerid, pQuickUseItemTextDraw[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, pQuickUseItemTextDraw[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, pQuickUseItemTextDraw[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, pQuickUseItemTextDraw[playerid][0], 0);
	PlayerTextDrawSetPreviewModel(playerid, pQuickUseItemTextDraw[playerid][0], NULL_MODEL);
	PlayerTextDrawSetPreviewRot(playerid, pQuickUseItemTextDraw[playerid][0], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, pQuickUseItemTextDraw[playerid][0], 1, 1);

	pQuickUseItemTextDraw[playerid][1] = CreatePlayerTextDraw(playerid, 306.000000, 402.000000, "Nowy_TextDraw");
	PlayerTextDrawFont(playerid, pQuickUseItemTextDraw[playerid][1], 5);
	PlayerTextDrawLetterSize(playerid, pQuickUseItemTextDraw[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, pQuickUseItemTextDraw[playerid][1], 40.000000, 46.000000);
	PlayerTextDrawSetOutline(playerid, pQuickUseItemTextDraw[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, pQuickUseItemTextDraw[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, pQuickUseItemTextDraw[playerid][1], 1);
	PlayerTextDrawColor(playerid, pQuickUseItemTextDraw[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, pQuickUseItemTextDraw[playerid][1], 23);
	PlayerTextDrawBoxColor(playerid, pQuickUseItemTextDraw[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, pQuickUseItemTextDraw[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, pQuickUseItemTextDraw[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, pQuickUseItemTextDraw[playerid][1], 0);
	PlayerTextDrawSetPreviewModel(playerid, pQuickUseItemTextDraw[playerid][1], NULL_MODEL);
	PlayerTextDrawSetPreviewRot(playerid, pQuickUseItemTextDraw[playerid][1], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, pQuickUseItemTextDraw[playerid][1], 1, 1);

	pQuickUseItemTextDraw[playerid][2] = CreatePlayerTextDraw(playerid, 346.000000, 402.000000, "Nowy_TextDraw");
	PlayerTextDrawFont(playerid, pQuickUseItemTextDraw[playerid][2], 5);
	PlayerTextDrawLetterSize(playerid, pQuickUseItemTextDraw[playerid][2], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, pQuickUseItemTextDraw[playerid][2], 40.000000, 46.000000);
	PlayerTextDrawSetOutline(playerid, pQuickUseItemTextDraw[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, pQuickUseItemTextDraw[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, pQuickUseItemTextDraw[playerid][2], 1);
	PlayerTextDrawColor(playerid, pQuickUseItemTextDraw[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, pQuickUseItemTextDraw[playerid][2], 0);
	PlayerTextDrawBoxColor(playerid, pQuickUseItemTextDraw[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, pQuickUseItemTextDraw[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, pQuickUseItemTextDraw[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, pQuickUseItemTextDraw[playerid][2], 0);
	PlayerTextDrawSetPreviewModel(playerid, pQuickUseItemTextDraw[playerid][2], NULL_MODEL);
	PlayerTextDrawSetPreviewRot(playerid, pQuickUseItemTextDraw[playerid][2], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, pQuickUseItemTextDraw[playerid][2], 1, 1);

	pQuickUseAmountTextDraw[playerid][0] = CreatePlayerTextDraw(playerid, 305.000000, 403.000000, "_");
	PlayerTextDrawFont(playerid, pQuickUseAmountTextDraw[playerid][0], 2);
	PlayerTextDrawLetterSize(playerid, pQuickUseAmountTextDraw[playerid][0], 0.316666, 1.349998);
	PlayerTextDrawTextSize(playerid, pQuickUseAmountTextDraw[playerid][0], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, pQuickUseAmountTextDraw[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, pQuickUseAmountTextDraw[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, pQuickUseAmountTextDraw[playerid][0], 3);
	PlayerTextDrawColor(playerid, pQuickUseAmountTextDraw[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, pQuickUseAmountTextDraw[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, pQuickUseAmountTextDraw[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, pQuickUseAmountTextDraw[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, pQuickUseAmountTextDraw[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, pQuickUseAmountTextDraw[playerid][0], 0);

	pQuickUseAmountTextDraw[playerid][1] = CreatePlayerTextDraw(playerid, 344.000000, 403.000000, "_");
	PlayerTextDrawFont(playerid, pQuickUseAmountTextDraw[playerid][1], 2);
	PlayerTextDrawLetterSize(playerid, pQuickUseAmountTextDraw[playerid][1], 0.316666, 1.349998);
	PlayerTextDrawTextSize(playerid, pQuickUseAmountTextDraw[playerid][1], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, pQuickUseAmountTextDraw[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, pQuickUseAmountTextDraw[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, pQuickUseAmountTextDraw[playerid][1], 3);
	PlayerTextDrawColor(playerid, pQuickUseAmountTextDraw[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, pQuickUseAmountTextDraw[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, pQuickUseAmountTextDraw[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, pQuickUseAmountTextDraw[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, pQuickUseAmountTextDraw[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, pQuickUseAmountTextDraw[playerid][1], 0);

	pQuickUseAmountTextDraw[playerid][2] = CreatePlayerTextDraw(playerid, 383.000000, 403.000000, "_");
	PlayerTextDrawFont(playerid, pQuickUseAmountTextDraw[playerid][2], 2);
	PlayerTextDrawLetterSize(playerid, pQuickUseAmountTextDraw[playerid][2], 0.316666, 1.349998);
	PlayerTextDrawTextSize(playerid, pQuickUseAmountTextDraw[playerid][2], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, pQuickUseAmountTextDraw[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, pQuickUseAmountTextDraw[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, pQuickUseAmountTextDraw[playerid][2], 3);
	PlayerTextDrawColor(playerid, pQuickUseAmountTextDraw[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, pQuickUseAmountTextDraw[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, pQuickUseAmountTextDraw[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, pQuickUseAmountTextDraw[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, pQuickUseAmountTextDraw[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, pQuickUseAmountTextDraw[playerid][2], 0);
	
	ClickQuickUseID[playerid]=NONE;
	return 1;
}
FUNC::QuickUse_OnPlayerDisconnect(playerid)
{
	forex(i,MAX_PLAYER_QUICKUSE_SLOT)
	{
		if(pQuickUseItemTextDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,pQuickUseItemTextDraw[playerid][i]);
		pQuickUseItemTextDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(pQuickUseAmountTextDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,pQuickUseAmountTextDraw[playerid][i]);
		pQuickUseAmountTextDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
	}
	if(pBuffTimeBarTextDraw[playerid]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,pBuffTimeBarTextDraw[playerid]);
	pBuffTimeBarTextDraw[playerid]=PlayerText:INVALID_TEXT_DRAW;
	ClickQuickUseID[playerid]=NONE;
    QuickUseShow[playerid]=false;
    BuffBarShow[playerid]=false;
	return 1;
}
FUNC::QuickUse_OnGameModeInit()
{
	forex(i,MAX_PLAYERS)
	{
		forex(s,MAX_PLAYER_QUICKUSE_SLOT)
		{
		    pQuickUseItemTextDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			pQuickUseAmountTextDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
		}
		pBuffTimeBarTextDraw[i]=PlayerText:INVALID_TEXT_DRAW;
	}
	
	BuffTimeBackGroundTextDraw = TextDrawCreate(325.000000, 401.000000, "_");
	TextDrawFont(BuffTimeBackGroundTextDraw, 1);
	TextDrawLetterSize(BuffTimeBackGroundTextDraw, 0.600000, 0.050000);
	TextDrawTextSize(BuffTimeBackGroundTextDraw, 400.000000, 112.500000);
	TextDrawSetOutline(BuffTimeBackGroundTextDraw, 1);
	TextDrawSetShadow(BuffTimeBackGroundTextDraw, 0);
	TextDrawAlignment(BuffTimeBackGroundTextDraw, 2);
	TextDrawColor(BuffTimeBackGroundTextDraw, -21);
	TextDrawBackgroundColor(BuffTimeBackGroundTextDraw, 255);
	TextDrawBoxColor(BuffTimeBackGroundTextDraw, 1296911766);
	TextDrawUseBox(BuffTimeBackGroundTextDraw, 1);
	TextDrawSetProportional(BuffTimeBackGroundTextDraw, 1);
	TextDrawSetSelectable(BuffTimeBackGroundTextDraw, 0);

	QuickUseBackGroundTextDraw[0] = TextDrawCreate(267.000000, 402.000000, "mdl-2003:inv_item");
	TextDrawFont(QuickUseBackGroundTextDraw[0], 4);
	TextDrawLetterSize(QuickUseBackGroundTextDraw[0], 0.600000, 2.000000);
	TextDrawTextSize(QuickUseBackGroundTextDraw[0], 40.500000, 46.000000);
	TextDrawSetOutline(QuickUseBackGroundTextDraw[0], 1);
	TextDrawSetShadow(QuickUseBackGroundTextDraw[0], 0);
	TextDrawAlignment(QuickUseBackGroundTextDraw[0], 1);
	TextDrawColor(QuickUseBackGroundTextDraw[0], -196);
	TextDrawBackgroundColor(QuickUseBackGroundTextDraw[0], 255);
	TextDrawBoxColor(QuickUseBackGroundTextDraw[0], 50);
	TextDrawUseBox(QuickUseBackGroundTextDraw[0], 1);
	TextDrawSetProportional(QuickUseBackGroundTextDraw[0], 1);
	TextDrawSetSelectable(QuickUseBackGroundTextDraw[0], 1);

	QuickUseBackGroundTextDraw[1] = TextDrawCreate(306.000000, 402.000000, "mdl-2003:inv_item");
	TextDrawFont(QuickUseBackGroundTextDraw[1], 4);
	TextDrawLetterSize(QuickUseBackGroundTextDraw[1], 0.600000, 2.000000);
	TextDrawTextSize(QuickUseBackGroundTextDraw[1], 40.500000, 46.000000);
	TextDrawSetOutline(QuickUseBackGroundTextDraw[1], 1);
	TextDrawSetShadow(QuickUseBackGroundTextDraw[1], 0);
	TextDrawAlignment(QuickUseBackGroundTextDraw[1], 1);
	TextDrawColor(QuickUseBackGroundTextDraw[1], -196);
	TextDrawBackgroundColor(QuickUseBackGroundTextDraw[1], 255);
	TextDrawBoxColor(QuickUseBackGroundTextDraw[1], 50);
	TextDrawUseBox(QuickUseBackGroundTextDraw[1], 1);
	TextDrawSetProportional(QuickUseBackGroundTextDraw[1], 1);
	TextDrawSetSelectable(QuickUseBackGroundTextDraw[1], 1);

	QuickUseBackGroundTextDraw[2] = TextDrawCreate(345.000000, 402.000000, "mdl-2003:inv_item");
	TextDrawFont(QuickUseBackGroundTextDraw[2], 4);
	TextDrawLetterSize(QuickUseBackGroundTextDraw[2], 0.600000, 2.000000);
	TextDrawTextSize(QuickUseBackGroundTextDraw[2], 40.500000, 46.000000);
	TextDrawSetOutline(QuickUseBackGroundTextDraw[2], 1);
	TextDrawSetShadow(QuickUseBackGroundTextDraw[2], 0);
	TextDrawAlignment(QuickUseBackGroundTextDraw[2], 1);
	TextDrawColor(QuickUseBackGroundTextDraw[2], -196);
	TextDrawBackgroundColor(QuickUseBackGroundTextDraw[2], 255);
	TextDrawBoxColor(QuickUseBackGroundTextDraw[2], 50);
	TextDrawUseBox(QuickUseBackGroundTextDraw[2], 1);
	TextDrawSetProportional(QuickUseBackGroundTextDraw[2], 1);
	TextDrawSetSelectable(QuickUseBackGroundTextDraw[2], 1);

	QuickUseKeyTextDraw[0] = TextDrawCreate(270.000000, 438.000000, "ALT+Y");
	TextDrawFont(QuickUseKeyTextDraw[0], 2);
	TextDrawLetterSize(QuickUseKeyTextDraw[0], 0.112498, 0.899998);
	TextDrawTextSize(QuickUseKeyTextDraw[0], 400.000000, 17.000000);
	TextDrawSetOutline(QuickUseKeyTextDraw[0], 0);
	TextDrawSetShadow(QuickUseKeyTextDraw[0], 0);
	TextDrawAlignment(QuickUseKeyTextDraw[0], 1);
	TextDrawColor(QuickUseKeyTextDraw[0], -1);
	TextDrawBackgroundColor(QuickUseKeyTextDraw[0], 255);
	TextDrawBoxColor(QuickUseKeyTextDraw[0], 50);
	TextDrawUseBox(QuickUseKeyTextDraw[0], 0);
	TextDrawSetProportional(QuickUseKeyTextDraw[0], 1);
	TextDrawSetSelectable(QuickUseKeyTextDraw[0], 0);

	QuickUseKeyTextDraw[1] = TextDrawCreate(309.000000, 438.000000, "ALT+N");
	TextDrawFont(QuickUseKeyTextDraw[1], 2);
	TextDrawLetterSize(QuickUseKeyTextDraw[1], 0.112498, 0.899998);
	TextDrawTextSize(QuickUseKeyTextDraw[1], 400.000000, 17.000000);
	TextDrawSetOutline(QuickUseKeyTextDraw[1], 0);
	TextDrawSetShadow(QuickUseKeyTextDraw[1], 0);
	TextDrawAlignment(QuickUseKeyTextDraw[1], 1);
	TextDrawColor(QuickUseKeyTextDraw[1], -1);
	TextDrawBackgroundColor(QuickUseKeyTextDraw[1], 255);
	TextDrawBoxColor(QuickUseKeyTextDraw[1], 50);
	TextDrawUseBox(QuickUseKeyTextDraw[1], 0);
	TextDrawSetProportional(QuickUseKeyTextDraw[1], 1);
	TextDrawSetSelectable(QuickUseKeyTextDraw[1], 0);

	QuickUseKeyTextDraw[2] = TextDrawCreate(348.000000, 438.000000, "ALT+H");
	TextDrawFont(QuickUseKeyTextDraw[2], 2);
	TextDrawLetterSize(QuickUseKeyTextDraw[2], 0.112498, 0.899998);
	TextDrawTextSize(QuickUseKeyTextDraw[2], 400.000000, 17.000000);
	TextDrawSetOutline(QuickUseKeyTextDraw[2], 0);
	TextDrawSetShadow(QuickUseKeyTextDraw[2], 0);
	TextDrawAlignment(QuickUseKeyTextDraw[2], 1);
	TextDrawColor(QuickUseKeyTextDraw[2], -1);
	TextDrawBackgroundColor(QuickUseKeyTextDraw[2], 255);
	TextDrawBoxColor(QuickUseKeyTextDraw[2], 50);
	TextDrawUseBox(QuickUseKeyTextDraw[2], 0);
	TextDrawSetProportional(QuickUseKeyTextDraw[2], 1);
	TextDrawSetSelectable(QuickUseKeyTextDraw[2], 0);
	return 1;
}
FUNC::ShowPlayerQuickUseTextDraw(playerid)
{
    if(QuickUseShow[playerid]==true)return 1;
    HidePlayerQuickUseTextDraw(playerid);
	forex(i,MAX_PLAYER_QUICKUSE_SLOT)
	{
	    TextDrawShowForPlayer(playerid,QuickUseBackGroundTextDraw[i]);
		TextDrawShowForPlayer(playerid,QuickUseKeyTextDraw[i]);
	}
	foreach(new i:PlayerInv[playerid])
	{
		if(PlayerInv[playerid][i][_QuickShow]!=NONE)
		{
		    PlayerTextDrawSetPreviewModel(playerid, pQuickUseItemTextDraw[playerid][PlayerInv[playerid][i][_QuickShow]], Item[PlayerInv[playerid][i][_ItemID]][_Model]);
            formatex32("%i",PlayerInv[playerid][i][_Amounts]);
			PlayerTextDrawSetString(playerid,pQuickUseAmountTextDraw[playerid][PlayerInv[playerid][i][_QuickShow]],string32);
            PlayerTextDrawShow(playerid, pQuickUseItemTextDraw[playerid][PlayerInv[playerid][i][_QuickShow]]);
            PlayerTextDrawShow(playerid, pQuickUseAmountTextDraw[playerid][PlayerInv[playerid][i][_QuickShow]]);
		}
	}
    QuickUseShow[playerid]=true;
	return 1;
}
FUNC::HidePlayerQuickUseTextDraw(playerid)
{
	forex(i,MAX_PLAYER_QUICKUSE_SLOT)
	{
	    TextDrawHideForPlayer(playerid,QuickUseBackGroundTextDraw[i]);
		TextDrawHideForPlayer(playerid,QuickUseKeyTextDraw[i]);
		PlayerTextDrawHide(playerid, pQuickUseItemTextDraw[playerid][i]);
		PlayerTextDrawHide(playerid, pQuickUseAmountTextDraw[playerid][i]);
	}
    QuickUseShow[playerid]=false;
	return 1;
}
FUNC::UpdatePlayerQuickSlotAmount(playerid,Slot,Amount)
{
    if(QuickUseShow[playerid]==true)
    {
        formatex32("%i",Amount);
		PlayerTextDrawSetString(playerid,pQuickUseAmountTextDraw[playerid][Slot],string32);
		PlayerTextDrawShow(playerid, pQuickUseAmountTextDraw[playerid][Slot]);
    }
	return 1;
}
FUNC::GetPlayerQuickSlotInvID(playerid,Slot)
{
	foreach(new i:PlayerInv[playerid])
	{
		if(PlayerInv[playerid][i][_QuickShow]!=NONE)
		{
			if(PlayerInv[playerid][i][_QuickShow]==Slot)return i;
		}
	}
	return NONE;
}
FUNC::UpdatePlayerQuickSlot(playerid,Slot,Invid)
{
    if(QuickUseShow[playerid]==true)
    {
        if(Slot==NONE)
        {
 			forex(i,MAX_PLAYER_QUICKUSE_SLOT)
			{
			    PlayerTextDrawSetPreviewModel(playerid, pQuickUseItemTextDraw[playerid][i],NULL_MODEL);
				PlayerTextDrawSetString(playerid,pQuickUseAmountTextDraw[playerid][i],"_");
		        PlayerTextDrawShow(playerid, pQuickUseItemTextDraw[playerid][i]);
		        PlayerTextDrawShow(playerid, pQuickUseAmountTextDraw[playerid][i]);
			}
			foreach(new i:PlayerInv[playerid])
			{
				if(PlayerInv[playerid][i][_QuickShow]!=NONE)
				{
				    PlayerTextDrawSetPreviewModel(playerid, pQuickUseItemTextDraw[playerid][PlayerInv[playerid][i][_QuickShow]], Item[PlayerInv[playerid][i][_ItemID]][_Model]);
		            formatex32("%i",PlayerInv[playerid][i][_Amounts]);
					PlayerTextDrawSetString(playerid,pQuickUseAmountTextDraw[playerid][PlayerInv[playerid][i][_QuickShow]],string32);
		            PlayerTextDrawShow(playerid, pQuickUseItemTextDraw[playerid][PlayerInv[playerid][i][_QuickShow]]);
		            PlayerTextDrawShow(playerid, pQuickUseAmountTextDraw[playerid][PlayerInv[playerid][i][_QuickShow]]);
				}
			}
			return 1;
        }
		if(Invid==NONE)
		{
			new bool:UpdateQuickUse=false;
			foreach(new i:PlayerInv[playerid])
			{
				if(PlayerInv[playerid][i][_QuickShow]!=NONE)
				{
	   				if(PlayerInv[playerid][i][_QuickShow]==Slot)
				    {
	       				PlayerInv[playerid][i][_QuickShow]=NONE;
				    	formatex256("UPDATE `"MYSQL_DB_INVENTORY"` SET  `快捷位` =  '%i' WHERE  `"MYSQL_DB_INVENTORY"`.`背包密匙` ='%s'",PlayerInv[playerid][i][_QuickShow],PlayerInv[playerid][i][_InvKey]);
						mysql_query(Account@Handle,string256,false);
						UpdateQuickUse=true;
	 				}
				}
			}
			if(UpdateQuickUse==true)
			{
			    PlayerTextDrawSetPreviewModel(playerid, pQuickUseItemTextDraw[playerid][Slot],NULL_MODEL);
				PlayerTextDrawSetString(playerid,pQuickUseAmountTextDraw[playerid][Slot],"_");
		        PlayerTextDrawShow(playerid, pQuickUseItemTextDraw[playerid][Slot]);
		        PlayerTextDrawShow(playerid, pQuickUseAmountTextDraw[playerid][Slot]);
	        }
		}
		else
		{
			foreach(new i:PlayerInv[playerid])
			{
				if(PlayerInv[playerid][i][_QuickShow]!=NONE)
				{
				    if(PlayerInv[playerid][i][_QuickShow]==Slot)
				    {
				        PlayerInv[playerid][i][_QuickShow]=NONE;
				    	formatex256("UPDATE `"MYSQL_DB_INVENTORY"` SET  `快捷位` =  '%i' WHERE  `"MYSQL_DB_INVENTORY"`.`背包密匙` ='%s'",PlayerInv[playerid][i][_QuickShow],PlayerInv[playerid][i][_InvKey]);
						mysql_query(Account@Handle,string256,false);
				    }
				}
			}
			PlayerInv[playerid][Invid][_QuickShow]=Slot;
			formatex256("UPDATE `"MYSQL_DB_INVENTORY"` SET  `快捷位` =  '%i' WHERE  `"MYSQL_DB_INVENTORY"`.`背包密匙` ='%s'",PlayerInv[playerid][Invid][_QuickShow],PlayerInv[playerid][Invid][_InvKey]);
			mysql_query(Account@Handle,string256,false);
			forex(i,MAX_PLAYER_QUICKUSE_SLOT)
			{
			    PlayerTextDrawSetPreviewModel(playerid, pQuickUseItemTextDraw[playerid][i],NULL_MODEL);
				PlayerTextDrawSetString(playerid,pQuickUseAmountTextDraw[playerid][i],"_");
		        PlayerTextDrawShow(playerid, pQuickUseItemTextDraw[playerid][i]);
		        PlayerTextDrawShow(playerid, pQuickUseAmountTextDraw[playerid][i]);
			}
			foreach(new i:PlayerInv[playerid])
			{
				if(PlayerInv[playerid][i][_QuickShow]!=NONE)
				{
				    PlayerTextDrawSetPreviewModel(playerid, pQuickUseItemTextDraw[playerid][PlayerInv[playerid][i][_QuickShow]], Item[PlayerInv[playerid][i][_ItemID]][_Model]);
		            formatex32("%i",PlayerInv[playerid][i][_Amounts]);
					PlayerTextDrawSetString(playerid,pQuickUseAmountTextDraw[playerid][PlayerInv[playerid][i][_QuickShow]],string32);
		            PlayerTextDrawShow(playerid, pQuickUseItemTextDraw[playerid][PlayerInv[playerid][i][_QuickShow]]);
		            PlayerTextDrawShow(playerid, pQuickUseAmountTextDraw[playerid][PlayerInv[playerid][i][_QuickShow]]);
				}
			}
		}
	}
	return 1;
}
/*********************************************/

