new Text:StrongBoxGroundTextDraws=Text:INVALID_TEXT_DRAW;
new Text:StrongBoxLockTextDraws[5]= {Text:INVALID_TEXT_DRAW, ...};

#define MAX_STRONG_BOX_ITEMS MAX_BOX_ITEMS+2
#define MAX_STRONGBOX_SHOW_LIST 30

new StrongBoxPrevieBox[MAX_PLAYERS][MAX_STRONG_BOX_ITEMS];
new StrongBoxPrevieBoxKey[MAX_PLAYERS][MAX_STRONG_BOX_ITEMS][64];
new StrongBoxPrevieCount[MAX_PLAYERS];
new StrongBoxPreviePage[MAX_PLAYERS];
new StrongBoxPrevieRate[MAX_PLAYERS];
new StrongBoxClickID[MAX_PLAYERS]= {NONE, ...};
new StrongBoxBoxID[MAX_PLAYERS]= {NONE, ...};
new bool:StrongBoxTextDrawShow[MAX_PLAYERS]= {false, ...};
/*****************************************************************************/
new PlayerText:StrongBoxBackBottonDraw[MAX_PLAYERS][MAX_STRONGBOX_SHOW_LIST];
new PlayerText:StrongBoxItemDraw[MAX_PLAYERS][MAX_STRONGBOX_SHOW_LIST];
new PlayerText:StrongBoxAmountDraw[MAX_PLAYERS][MAX_STRONGBOX_SHOW_LIST];
new PlayerText:StrongBoxDurableDraw[MAX_PLAYERS][MAX_STRONGBOX_SHOW_LIST];
new PlayerText:StrongBoxIDDraw[MAX_PLAYERS]= {PlayerText:INVALID_TEXT_DRAW, ...};
/*****************************************************************************/
FUNC::ShowPlayerStrongBoxTextDraw(playerid,index)
{
    if(CraftItem[CraftBulid[index][_CraftItemID]][_Type]!=CRAFT_TPYE_COFFER)return SCM(playerid,-1,"只有保险箱类型建筑可以显示仓库");
	TextDrawShowForPlayer(playerid,StrongBoxGroundTextDraws);
    UpdateStrongBoxPage(playerid,index,1);
    StrongBoxTextDrawShow[playerid]=true;
    SelectTextDrawEx(playerid,0x408080C8);
	return 1;
}
FUNC::HidePlayerStrongBoxTextDraw(playerid)
{
	if(StrongBoxClickID[playerid]!=NONE)
	{
		PlayerTextDrawColor(playerid, StrongBoxBackBottonDraw[playerid][StrongBoxClickID[playerid]], -256);
		PlayerTextDrawShow(playerid, StrongBoxBackBottonDraw[playerid][StrongBoxClickID[playerid]]);
	}
	TextDrawHideForPlayer(playerid,StrongBoxGroundTextDraws);
    forex(i,sizeof(StrongBoxLockTextDraws))TextDrawHideForPlayer(playerid,StrongBoxLockTextDraws[i]);
	forex(i,MAX_STRONGBOX_SHOW_LIST)
	{
		PlayerTextDrawHide(playerid, StrongBoxBackBottonDraw[playerid][i]);
		PlayerTextDrawHide(playerid, StrongBoxItemDraw[playerid][i]);
		PlayerTextDrawHide(playerid, StrongBoxAmountDraw[playerid][i]);
		PlayerTextDrawHide(playerid, StrongBoxDurableDraw[playerid][i]);
	}
	PlayerTextDrawHide(playerid, StrongBoxIDDraw[playerid]);
   	StrongBoxTextDrawShow[playerid]=false;
	return 1;
}
FUNC::UpdateStrongBoxPage(playerid,bulidid,pages)//更新显示箱子
{
	forex(i,MAX_STRONGBOX_SHOW_LIST)
	{
		PlayerTextDrawHide(playerid, StrongBoxBackBottonDraw[playerid][i]);
		PlayerTextDrawHide(playerid, StrongBoxItemDraw[playerid][i]);
		PlayerTextDrawHide(playerid, StrongBoxAmountDraw[playerid][i]);
		PlayerTextDrawHide(playerid, StrongBoxDurableDraw[playerid][i]);
	}
	PlayerTextDrawHide(playerid, StrongBoxIDDraw[playerid]);
    forex(i,sizeof(StrongBoxLockTextDraws))TextDrawHideForPlayer(playerid,StrongBoxLockTextDraws[i]);
    loop(i,CraftBulid[bulidid][_CcapacityLevel],sizeof(StrongBoxLockTextDraws))TextDrawShowForPlayer(playerid,StrongBoxLockTextDraws[i]);
    formatex32("ID:%04d",bulidid);
	PlayerTextDrawSetString(playerid,StrongBoxIDDraw[playerid],string32);
	PlayerTextDrawShow(playerid, StrongBoxIDDraw[playerid]);
	new index=0,StrongBoxAmout=0;
    StrongBoxPrevieRate[playerid]=0;
    StrongBoxPrevieCount[playerid]=1;
    StrongBoxClickID[playerid]=NONE;
    StrongBoxBoxID[playerid]=bulidid;
	foreach(new i:CraftBulidInv)
    {
        if(isequal(CraftBulidInv[i][_CraftBulidKey],CraftBulid[bulidid][_Key],false))
        {
            if(StrongBoxAmout<=(CraftBulid[bulidid][_CcapacityLevel]+1)*6)
            {
				StrongBoxPrevieBox[playerid][StrongBoxPrevieCount[playerid]]=i;
				format(StrongBoxPrevieBoxKey[playerid][StrongBoxPrevieCount[playerid]],64,CraftBulidInv[i][_Key]);
		 		StrongBoxPrevieCount[playerid]++;
		   		StrongBoxAmout++;
				//printf("%s - %i",CraftBulidInv[i][_ItemKey],CraftBulidInv[i][_Amounts]);
	   		}
   		}
    }
	if(pages<1)pages=1;
	if(pages>floatround((StrongBoxPrevieCount[playerid]-1)/float(MAX_STRONGBOX_SHOW_LIST),floatround_ceil))pages=floatround((StrongBoxPrevieCount[playerid]-1)/float(MAX_STRONGBOX_SHOW_LIST),floatround_ceil);
    StrongBoxPreviePage[playerid]=pages;
    pages=(pages-1)*MAX_STRONGBOX_SHOW_LIST;
    if(pages<=0)pages=1;else pages++;
    new Strings[32];
    loop(i,pages,pages+MAX_STRONGBOX_SHOW_LIST)
	{
	    index=StrongBoxPrevieBox[playerid][i];
	    if(i<StrongBoxPrevieCount[playerid])
		{

		    PlayerTextDrawSetPreviewModel(playerid, StrongBoxItemDraw[playerid][StrongBoxPrevieRate[playerid]],Item[CraftBulidInv[index][_ItemID]][_Model]);
            format(Strings,sizeof(Strings),"%i",CraftBulidInv[index][_Amounts]);
            PlayerTextDrawSetString(playerid,StrongBoxAmountDraw[playerid][StrongBoxPrevieRate[playerid]],Strings);
		    if(Item[CraftBulidInv[index][_ItemID]][_Durable]==1)
		    {
				format(Strings,sizeof(Strings),"%0.1f%",CraftBulidInv[index][_Durable]);
				PlayerTextDrawSetString(playerid,StrongBoxDurableDraw[playerid][StrongBoxPrevieRate[playerid]],Strings);
		    }
			PlayerTextDrawShow(playerid, StrongBoxBackBottonDraw[playerid][StrongBoxPrevieRate[playerid]]);
			PlayerTextDrawShow(playerid, StrongBoxItemDraw[playerid][StrongBoxPrevieRate[playerid]]);
			PlayerTextDrawShow(playerid, StrongBoxAmountDraw[playerid][StrongBoxPrevieRate[playerid]]);
			if(Item[CraftBulidInv[index][_ItemID]][_Durable]==1)PlayerTextDrawShow(playerid, StrongBoxDurableDraw[playerid][StrongBoxPrevieRate[playerid]]);

		    StrongBoxPrevieRate[playerid]++;
		}
	    else break;
	}
	return 1;
}
FUNC::StrongBoxUI_OnPlayerDisconnect(playerid)
{
    forex(i,MAX_STRONGBOX_SHOW_LIST)
    {
        if(StrongBoxBackBottonDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,StrongBoxBackBottonDraw[playerid][i]);
		StrongBoxBackBottonDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(StrongBoxItemDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,StrongBoxItemDraw[playerid][i]);
		StrongBoxItemDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(StrongBoxAmountDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,StrongBoxAmountDraw[playerid][i]);
		StrongBoxAmountDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(StrongBoxDurableDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,StrongBoxDurableDraw[playerid][i]);
		StrongBoxDurableDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
    }
	if(StrongBoxIDDraw[playerid]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,StrongBoxIDDraw[playerid]);
	StrongBoxIDDraw[playerid]=PlayerText:INVALID_TEXT_DRAW;
	StrongBoxTextDrawShow[playerid]=false;
	return 1;
}
FUNC::StrongBoxUI_OnPlayerConnect(playerid)
{
	StrongBoxUI_OnPlayerDisconnect(playerid);
	new BreakLine=0,NowLine=0;
	forex(i,MAX_STRONGBOX_SHOW_LIST)
	{
	    if(BreakLine>=6)
		{
			NowLine++;
			BreakLine=0;
		}
		StrongBoxBackBottonDraw[playerid][i] = CreatePlayerTextDraw(playerid, 192.500000+((i-NowLine*6)*44), 121.000000+(NowLine*44), "LD_SPAC:WHITE");
		PlayerTextDrawFont(playerid,StrongBoxBackBottonDraw[playerid][i], 4);
		PlayerTextDrawLetterSize(playerid,StrongBoxBackBottonDraw[playerid][i], 0.600000, 2.000000);
		PlayerTextDrawTextSize(playerid,StrongBoxBackBottonDraw[playerid][i], 36.000000, 35.500000);
		PlayerTextDrawSetOutline(playerid,StrongBoxBackBottonDraw[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid,StrongBoxBackBottonDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid,StrongBoxBackBottonDraw[playerid][i], 1);
		PlayerTextDrawColor(playerid,StrongBoxBackBottonDraw[playerid][i], -256);
		PlayerTextDrawBackgroundColor(playerid,StrongBoxBackBottonDraw[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid,StrongBoxBackBottonDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid,StrongBoxBackBottonDraw[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid,StrongBoxBackBottonDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid,StrongBoxBackBottonDraw[playerid][i], 1);
		
		StrongBoxItemDraw[playerid][i] = CreatePlayerTextDraw(playerid, 190.500000+((i-NowLine*6)*44), 118.000000+(NowLine*44), "Nowy_TextDraw");
		PlayerTextDrawFont(playerid, StrongBoxItemDraw[playerid][i], 5);
		PlayerTextDrawLetterSize(playerid, StrongBoxItemDraw[playerid][i], 0.600000, 2.000000);
		PlayerTextDrawTextSize(playerid, StrongBoxItemDraw[playerid][i], 39.000000, 39.500000);
		PlayerTextDrawSetOutline(playerid, StrongBoxItemDraw[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, StrongBoxItemDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, StrongBoxItemDraw[playerid][i], 1);
		PlayerTextDrawColor(playerid, StrongBoxItemDraw[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, StrongBoxItemDraw[playerid][i], 0);
		PlayerTextDrawBoxColor(playerid, StrongBoxItemDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, StrongBoxItemDraw[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, StrongBoxItemDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, StrongBoxItemDraw[playerid][i], 0);
		PlayerTextDrawSetPreviewModel(playerid, StrongBoxItemDraw[playerid][i], 0);
		PlayerTextDrawSetPreviewRot(playerid, StrongBoxItemDraw[playerid][i], -10.000000, 0.000000, -20.000000, 1.000000);
		PlayerTextDrawSetPreviewVehCol(playerid, StrongBoxItemDraw[playerid][i], 1, 1);
		
		StrongBoxAmountDraw[playerid][i] = CreatePlayerTextDraw(playerid, 227.000000+((i-NowLine*6)*44), 118.000000+(NowLine*44), "_");
		PlayerTextDrawFont(playerid, StrongBoxAmountDraw[playerid][i], 2);
		PlayerTextDrawLetterSize(playerid, StrongBoxAmountDraw[playerid][i], 0.275000, 1.100000);
		PlayerTextDrawTextSize(playerid, StrongBoxAmountDraw[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, StrongBoxAmountDraw[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, StrongBoxAmountDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, StrongBoxAmountDraw[playerid][i], 3);
		PlayerTextDrawColor(playerid, StrongBoxAmountDraw[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, StrongBoxAmountDraw[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, StrongBoxAmountDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, StrongBoxAmountDraw[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, StrongBoxAmountDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, StrongBoxAmountDraw[playerid][i], 0);

		StrongBoxDurableDraw[playerid][i] = CreatePlayerTextDraw(playerid, 227.000000+((i-NowLine*6)*44), 147.000000+(NowLine*44), "_");
		PlayerTextDrawFont(playerid, StrongBoxDurableDraw[playerid][i], 2);
		PlayerTextDrawLetterSize(playerid, StrongBoxDurableDraw[playerid][i], 0.129166, 0.899999);
		PlayerTextDrawTextSize(playerid, StrongBoxDurableDraw[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, StrongBoxDurableDraw[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, StrongBoxDurableDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, StrongBoxDurableDraw[playerid][i], 3);
		PlayerTextDrawColor(playerid, StrongBoxDurableDraw[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, StrongBoxDurableDraw[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, StrongBoxDurableDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, StrongBoxDurableDraw[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, StrongBoxDurableDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, StrongBoxDurableDraw[playerid][i], 0);
		BreakLine++;
	}
	StrongBoxIDDraw[playerid] = CreatePlayerTextDraw(playerid, 453.000000, 87.000000, "_");
	PlayerTextDrawFont(playerid, StrongBoxIDDraw[playerid], 2);
	PlayerTextDrawLetterSize(playerid, StrongBoxIDDraw[playerid], 0.337500, 2.049999);
	PlayerTextDrawTextSize(playerid, StrongBoxIDDraw[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, StrongBoxIDDraw[playerid], 1);
	PlayerTextDrawSetShadow(playerid, StrongBoxIDDraw[playerid], 0);
	PlayerTextDrawAlignment(playerid, StrongBoxIDDraw[playerid], 3);
	PlayerTextDrawColor(playerid, StrongBoxIDDraw[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, StrongBoxIDDraw[playerid], 255);
	PlayerTextDrawBoxColor(playerid, StrongBoxIDDraw[playerid], 50);
	PlayerTextDrawUseBox(playerid, StrongBoxIDDraw[playerid], 0);
	PlayerTextDrawSetProportional(playerid, StrongBoxIDDraw[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, StrongBoxIDDraw[playerid], 0);
	return 1;
}
FUNC::StrongBoxUI_OnGameModeInit()
{
	forex(i,MAX_PLAYERS)
	{
	    forex(s,MAX_STRONGBOX_SHOW_LIST)
	    {
			StrongBoxBackBottonDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			StrongBoxItemDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			StrongBoxAmountDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			StrongBoxDurableDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
	    }
	    StrongBoxIDDraw[i]=PlayerText:INVALID_TEXT_DRAW;
		StrongBoxTextDrawShow[i]=false;
	}
	StrongBoxGroundTextDraws = TextDrawCreate(170.000000, 52.000000, "mdl-2003:strongbox");
	TextDrawFont(StrongBoxGroundTextDraws, 4);
	TextDrawLetterSize(StrongBoxGroundTextDraws, 0.600000, 2.000000);
	TextDrawTextSize(StrongBoxGroundTextDraws, 302.000000, 300.500000);
	TextDrawSetOutline(StrongBoxGroundTextDraws, 1);
	TextDrawSetShadow(StrongBoxGroundTextDraws, 0);
	TextDrawAlignment(StrongBoxGroundTextDraws, 1);
	TextDrawColor(StrongBoxGroundTextDraws, -1);
	TextDrawBackgroundColor(StrongBoxGroundTextDraws, 255);
	TextDrawBoxColor(StrongBoxGroundTextDraws, 50);
	TextDrawUseBox(StrongBoxGroundTextDraws, 1);
	TextDrawSetProportional(StrongBoxGroundTextDraws, 1);
	TextDrawSetSelectable(StrongBoxGroundTextDraws, 0);

	forex(i,5)
	{
		StrongBoxLockTextDraws[i] = TextDrawCreate(190.000000, 120.000000+(i*43), "mdl-2003:strongbox_lock");
		TextDrawFont(StrongBoxLockTextDraws[i], 4);
		TextDrawLetterSize(StrongBoxLockTextDraws[i], 0.600000, 2.000000);
		TextDrawTextSize(StrongBoxLockTextDraws[i], 260.500000, 40.500000);
		TextDrawSetOutline(StrongBoxLockTextDraws[i], 1);
		TextDrawSetShadow(StrongBoxLockTextDraws[i], 0);
		TextDrawAlignment(StrongBoxLockTextDraws[i], 1);
		TextDrawColor(StrongBoxLockTextDraws[i], -1);
		TextDrawBackgroundColor(StrongBoxLockTextDraws[i], 255);
		TextDrawBoxColor(StrongBoxLockTextDraws[i], 50);
		TextDrawUseBox(StrongBoxLockTextDraws[i], 1);
		TextDrawSetProportional(StrongBoxLockTextDraws[i], 1);
		TextDrawSetSelectable(StrongBoxLockTextDraws[i], 1);
	}
	return 1;
}
