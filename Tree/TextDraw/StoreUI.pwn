#define MAX_STROE_BOX_ITEMS MAX_BOX_ITEMS+2
#define MAX_PLAYERSTROE_SHOW_LIST 9

new StoreSellPrevieBox[MAX_PLAYERS][MAX_PLAYERINV_BOX_ITEMS];
new StoreSellPrevieBoxKey[MAX_PLAYERS][MAX_PLAYERINV_BOX_ITEMS][64];
new StoreSellPrevieCount[MAX_PLAYERS];
new StoreSellPreviePage[MAX_PLAYERS];
new StoreSellPrevieRate[MAX_PLAYERS];
new StoreSellClickID[MAX_PLAYERS]= {NONE, ...};
new StoreSellStoreID[MAX_PLAYERS]= {NONE, ...};

new PlayerSellPrevieBox[MAX_PLAYERS][MAX_PLAYERINV_BOX_ITEMS];
new PlayerSellPrevieBoxKey[MAX_PLAYERS][MAX_PLAYERINV_BOX_ITEMS][64];
new PlayerSellPrevieCount[MAX_PLAYERS];
new PlayerSellPreviePage[MAX_PLAYERS];
new PlayerSellPrevieRate[MAX_PLAYERS];
new PlayerSellClickID[MAX_PLAYERS]= {NONE, ...};
new PlayerSellStoreID[MAX_PLAYERS]= {NONE, ...};

new bool:StoreTextDrawShow[MAX_PLAYERS]= {false, ...};
/*****************************************************************************/
new PlayerText:StoreSellBackBottonDraw[MAX_PLAYERS][MAX_PLAYERSTROE_SHOW_LIST];
new PlayerText:StoreSellItemDraw[MAX_PLAYERS][MAX_PLAYERSTROE_SHOW_LIST];
new PlayerText:StoreSellItemNameDraw[MAX_PLAYERS][MAX_PLAYERSTROE_SHOW_LIST];
new PlayerText:StoreSellAmountDraw[MAX_PLAYERS][MAX_PLAYERSTROE_SHOW_LIST];
new PlayerText:StoreSellPriceDraw[MAX_PLAYERS][MAX_PLAYERSTROE_SHOW_LIST];

new PlayerText:PlayerSellBackBottonDraw[MAX_PLAYERS][MAX_PLAYERSTROE_SHOW_LIST];
new PlayerText:PlayerSellItemDraw[MAX_PLAYERS][MAX_PLAYERSTROE_SHOW_LIST];
new PlayerText:PlayerSellItemNameDraw[MAX_PLAYERS][MAX_PLAYERSTROE_SHOW_LIST];
new PlayerText:PlayerSellPercentDraw[MAX_PLAYERS][MAX_PLAYERSTROE_SHOW_LIST];
new PlayerText:PlayerSellAmountDraw[MAX_PLAYERS][MAX_PLAYERSTROE_SHOW_LIST];
new PlayerText:PlayerSellPriceDraw[MAX_PLAYERS][MAX_PLAYERSTROE_SHOW_LIST];

new PlayerText:PlayerSellPageDraw[MAX_PLAYERS]= {PlayerText:INVALID_TEXT_DRAW, ...};
new Text:StoreBackGroundTextDraws[3]= {Text:INVALID_TEXT_DRAW, ...};
/*****************************************************************************/

FUNC::ShowPlayerStoreTextDraw(playerid,storeid)
{
    HidePlayerPresonStateTextDraw(playerid);
    HidePlayerNavigationBarTextDraw(playerid);
    HideWeaponHudTextDrawForPlayer(playerid);
    HidePlayerSpeedo(playerid);
    HidePlayerQuickUseTextDraw(playerid);
    
    forex(i,sizeof(StoreBackGroundTextDraws))TextDrawShowForPlayer(playerid,StoreBackGroundTextDraws[i]);
    UpdatePlayerSellPage(playerid,storeid,1);
    UpdateStoreSellPage(playerid,storeid,1);
    StoreTextDrawShow[playerid]=true;
    SelectTextDrawEx(playerid,0x408080C8);
    ClearChat(playerid);
    SCM(playerid,-1,"双击购买或出售,ESC关闭页面");
	return 1;
}
FUNC::HidePlayerStoreTextDraw(playerid)
{
    if(StoreSellClickID[playerid]!=NONE)
	{
		PlayerTextDrawColor(playerid, StoreSellBackBottonDraw[playerid][StoreSellClickID[playerid]], 2094792749);
        PlayerTextDrawShow(playerid, StoreSellBackBottonDraw[playerid][StoreSellClickID[playerid]]);
	}
    if(PlayerSellClickID[playerid]!=NONE)
	{
		PlayerTextDrawColor(playerid, PlayerSellBackBottonDraw[playerid][PlayerSellClickID[playerid]], 2094792749);
        PlayerTextDrawShow(playerid, PlayerSellBackBottonDraw[playerid][PlayerSellClickID[playerid]]);
	}
	forex(i,MAX_PLAYERSTROE_SHOW_LIST)
    {
		PlayerTextDrawHide(playerid, StoreSellBackBottonDraw[playerid][i]);
		PlayerTextDrawHide(playerid, StoreSellItemDraw[playerid][i]);
		PlayerTextDrawHide(playerid, StoreSellItemNameDraw[playerid][i]);
		PlayerTextDrawHide(playerid, StoreSellAmountDraw[playerid][i]);
		PlayerTextDrawHide(playerid, StoreSellPriceDraw[playerid][i]);
    
		PlayerTextDrawHide(playerid, PlayerSellBackBottonDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerSellItemDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerSellItemNameDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerSellPercentDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerSellAmountDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerSellPriceDraw[playerid][i]);
    }
    PlayerTextDrawHide(playerid, PlayerSellPageDraw[playerid]);
    forex(i,sizeof(StoreBackGroundTextDraws))TextDrawHideForPlayer(playerid,StoreBackGroundTextDraws[i]);
	StoreTextDrawShow[playerid]=false;
	SetCameraBehindPlayer(playerid);
 	ShowPlayerPresonStateTextDraw(playerid);
  	if(IsPlayerInAnyVehicle(playerid))ShowPlayerSpeedo(playerid);
  	OnPlayerWeaponChange(playerid,GetPlayerWeapon(playerid),GetPlayerWeapon(playerid));
  	ShowPlayerQuickUseTextDraw(playerid);
	return 1;
}
FUNC::UpdatePlayerSellPage(playerid,storeid,pages)//更新显示玩家出售
{
	forex(i,MAX_PLAYERSTROE_SHOW_LIST)
	{
		PlayerTextDrawHide(playerid, PlayerSellBackBottonDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerSellItemDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerSellItemNameDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerSellPercentDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerSellAmountDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerSellPriceDraw[playerid][i]);
	}
	PlayerTextDrawHide(playerid, PlayerSellPageDraw[playerid]);
	new index=0,PlayerSellAmout=0;
    PlayerSellPrevieRate[playerid]=0;
    PlayerSellPrevieCount[playerid]=1;
    PlayerSellClickID[playerid]=NONE;
    PlayerSellStoreID[playerid]=storeid;
	new	Project_ID[MAX_PLAYER_INV_SLOTS],Top_Info[MAX_PLAYER_INV_SLOTS],Current_TopLine=Iter_Count(PlayerInv[playerid]);
	foreach(new i:PlayerInv[playerid])
    {
        HighestTopList(i,PlayerInv[playerid][i][_GetTime],Project_ID, Top_Info, Current_TopLine);
    }
    forex(i,Current_TopLine)
	{
	    if(PlayerSellAmout<MAX_PLAYERINV_BOX_ITEMS-2)
	    {
			PlayerSellPrevieBox[playerid][PlayerSellPrevieCount[playerid]]=Project_ID[i];
			format(PlayerSellPrevieBoxKey[playerid][PlayerSellPrevieCount[playerid]],64,"");
			format(PlayerSellPrevieBoxKey[playerid][PlayerSellPrevieCount[playerid]],64,PlayerInv[playerid][Project_ID[i]][_InvKey]);
   			PlayerSellPrevieCount[playerid]++;
   			PlayerSellAmout++;
	    }
	}
	if(pages<1)pages=1;
	if(pages>floatround((PlayerSellPrevieCount[playerid]-1)/float(MAX_PLAYERSTROE_SHOW_LIST),floatround_ceil))pages=floatround((PlayerSellPrevieCount[playerid]-1)/float(MAX_PLAYERSTROE_SHOW_LIST),floatround_ceil);
    PlayerSellPreviePage[playerid]=pages;
    pages=(pages-1)*MAX_PLAYERSTROE_SHOW_LIST;
    if(pages<=0)pages=1;else pages++;
    new Strings[32];
    loop(i,pages,pages+MAX_PLAYERSTROE_SHOW_LIST)
	{
	    index=PlayerSellPrevieBox[playerid][i];
	    if(i<PlayerSellPrevieCount[playerid])
		{
		    PlayerTextDrawSetPreviewModel(playerid, PlayerSellItemDraw[playerid][PlayerSellPrevieRate[playerid]], Item[PlayerInv[playerid][index][_ItemID]][_Model]);
			PlayerTextDrawSetString(playerid,PlayerSellItemNameDraw[playerid][PlayerSellPrevieRate[playerid]],Item[PlayerInv[playerid][index][_ItemID]][_NameTXD]);
            if(Item[PlayerInv[playerid][index][_ItemID]][_Durable]==1)
            {
				format(Strings,sizeof(Strings),"%0.1f%",PlayerInv[playerid][index][_Durable]);
				PlayerTextDrawSetString(playerid,PlayerSellPercentDraw[playerid][PlayerSellPrevieRate[playerid]],Strings);
			}
			format(Strings,sizeof(Strings),"%i",PlayerInv[playerid][index][_Amounts]);
			PlayerTextDrawSetString(playerid,PlayerSellAmountDraw[playerid][PlayerSellPrevieRate[playerid]],Strings);
            format(Strings,sizeof(Strings),"$%i",Item[PlayerInv[playerid][index][_ItemID]][_SellPrice]);
			PlayerTextDrawSetString(playerid,PlayerSellPriceDraw[playerid][PlayerSellPrevieRate[playerid]],Strings);

			PlayerTextDrawShow(playerid, PlayerSellBackBottonDraw[playerid][PlayerSellPrevieRate[playerid]]);
			PlayerTextDrawShow(playerid, PlayerSellItemDraw[playerid][PlayerSellPrevieRate[playerid]]);
			PlayerTextDrawShow(playerid, PlayerSellItemNameDraw[playerid][PlayerSellPrevieRate[playerid]]);
			PlayerTextDrawShow(playerid, PlayerSellAmountDraw[playerid][PlayerSellPrevieRate[playerid]]);
			if(Item[PlayerInv[playerid][index][_ItemID]][_Durable]==1)PlayerTextDrawShow(playerid, PlayerSellPercentDraw[playerid][PlayerSellPrevieRate[playerid]]);
			PlayerTextDrawShow(playerid, PlayerSellAmountDraw[playerid][PlayerSellPrevieRate[playerid]]);
			PlayerTextDrawShow(playerid, PlayerSellPriceDraw[playerid][PlayerSellPrevieRate[playerid]]);
		    PlayerSellPrevieRate[playerid]++;
		}
	    else break;
	}
	format(Strings,sizeof(Strings),"%02d/%02d",PlayerSellPreviePage[playerid],floatround((PlayerSellPrevieCount[playerid]-1)/float(MAX_PLAYERSTROE_SHOW_LIST),floatround_ceil));
    PlayerTextDrawSetString(playerid,PlayerSellPageDraw[playerid],Strings);
	PlayerTextDrawShow(playerid, PlayerSellPageDraw[playerid]);
	return 1;
}
FUNC::UpdateStoreSellPage(playerid,storeid,pages)//更新显示商店售品
{
	forex(i,MAX_PLAYERSTROE_SHOW_LIST)
	{
		PlayerTextDrawHide(playerid, StoreSellBackBottonDraw[playerid][i]);
		PlayerTextDrawHide(playerid, StoreSellItemDraw[playerid][i]);
		PlayerTextDrawHide(playerid, StoreSellItemNameDraw[playerid][i]);
		PlayerTextDrawHide(playerid, StoreSellAmountDraw[playerid][i]);
		PlayerTextDrawHide(playerid, StoreSellPriceDraw[playerid][i]);
	}
	new index=0,StoreSellAmout=0;
    StoreSellPrevieRate[playerid]=0;
    StoreSellPrevieCount[playerid]=1;
    StoreSellClickID[playerid]=NONE;
    StoreSellStoreID[playerid]=storeid;
	foreach(new i:StoreSells[storeid])
    {
		StoreSellPrevieBox[playerid][StoreSellPrevieCount[playerid]]=i;
		format(StoreSellPrevieBoxKey[playerid][StoreSellPrevieCount[playerid]],64,StoreSells[storeid][i][_Key]);
 		StoreSellPrevieCount[playerid]++;
   		StoreSellAmout++;
    }
	if(pages<1)pages=1;
	if(pages>floatround((StoreSellPrevieCount[playerid]-1)/float(MAX_PLAYERSTROE_SHOW_LIST),floatround_ceil))pages=floatround((StoreSellPrevieCount[playerid]-1)/float(MAX_PLAYERSTROE_SHOW_LIST),floatround_ceil);
    StoreSellPreviePage[playerid]=pages;
    pages=(pages-1)*MAX_PLAYERSTROE_SHOW_LIST;
    if(pages<=0)pages=1;else pages++;
    new Strings[32];
    loop(i,pages,pages+MAX_PLAYERSTROE_SHOW_LIST)
	{
	    index=StoreSellPrevieBox[playerid][i];
	    if(i<StoreSellPrevieCount[playerid])
		{
		    PlayerTextDrawSetPreviewModel(playerid, StoreSellItemDraw[playerid][StoreSellPrevieRate[playerid]],Item[StoreSells[storeid][index][_ItemID]][_Model]);
			PlayerTextDrawSetString(playerid,StoreSellItemNameDraw[playerid][StoreSellPrevieRate[playerid]],Item[StoreSells[storeid][index][_ItemID]][_NameTXD]);
            format(Strings,sizeof(Strings),"%i",StoreSells[storeid][index][_Amount]);
			PlayerTextDrawSetString(playerid,StoreSellAmountDraw[playerid][StoreSellPrevieRate[playerid]],Strings);
			format(Strings,sizeof(Strings),"$%i",StoreSells[storeid][index][_Price]);
			PlayerTextDrawSetString(playerid,StoreSellPriceDraw[playerid][StoreSellPrevieRate[playerid]],Strings);

			PlayerTextDrawShow(playerid, StoreSellBackBottonDraw[playerid][StoreSellPrevieRate[playerid]]);
			PlayerTextDrawShow(playerid, StoreSellItemDraw[playerid][StoreSellPrevieRate[playerid]]);
			PlayerTextDrawShow(playerid, StoreSellItemNameDraw[playerid][StoreSellPrevieRate[playerid]]);
			PlayerTextDrawShow(playerid, StoreSellPriceDraw[playerid][StoreSellPrevieRate[playerid]]);
			PlayerTextDrawShow(playerid, StoreSellAmountDraw[playerid][StoreSellPrevieRate[playerid]]);

		    StoreSellPrevieRate[playerid]++;
		}
	    else break;
	}
	return 1;
}
/*****************************************************************************/
FUNC::StoreDraw_OnPlayerConnect(playerid)
{
	StoreDraw_OnPlayerDisconnect(playerid);
	forex(i,MAX_PLAYERSTROE_SHOW_LIST)
	{
		StoreSellBackBottonDraw[playerid][i] = CreatePlayerTextDraw(playerid, 19.000000, 70.000000+(i*36), "LD_SPAC:WHITE");
		PlayerTextDrawFont(playerid, StoreSellBackBottonDraw[playerid][i], 4);
		PlayerTextDrawLetterSize(playerid, StoreSellBackBottonDraw[playerid][i], 0.600000, 2.000000);
		PlayerTextDrawTextSize(playerid, StoreSellBackBottonDraw[playerid][i], 214.500000, 35.500000);
		PlayerTextDrawSetOutline(playerid, StoreSellBackBottonDraw[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, StoreSellBackBottonDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, StoreSellBackBottonDraw[playerid][i], 1);
		PlayerTextDrawColor(playerid, StoreSellBackBottonDraw[playerid][i], 2094792749);
		PlayerTextDrawBackgroundColor(playerid, StoreSellBackBottonDraw[playerid][i], 174);
		PlayerTextDrawBoxColor(playerid, StoreSellBackBottonDraw[playerid][i], 0);
		PlayerTextDrawUseBox(playerid, StoreSellBackBottonDraw[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, StoreSellBackBottonDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, StoreSellBackBottonDraw[playerid][i], 1);
		
		StoreSellItemDraw[playerid][i] = CreatePlayerTextDraw(playerid, 7.000000, 68.000000+(i*36), "Nowy_TextDraw");
		PlayerTextDrawFont(playerid, StoreSellItemDraw[playerid][i], 5);
		PlayerTextDrawLetterSize(playerid, StoreSellItemDraw[playerid][i], 0.600000, 2.000000);
		PlayerTextDrawTextSize(playerid, StoreSellItemDraw[playerid][i], 52.500000, 36.000000);
		PlayerTextDrawSetOutline(playerid, StoreSellItemDraw[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, StoreSellItemDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, StoreSellItemDraw[playerid][i], 1);
		PlayerTextDrawColor(playerid, StoreSellItemDraw[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, StoreSellItemDraw[playerid][i], 0);
		PlayerTextDrawBoxColor(playerid, StoreSellItemDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, StoreSellItemDraw[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, StoreSellItemDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, StoreSellItemDraw[playerid][i], 0);
		PlayerTextDrawSetPreviewModel(playerid, StoreSellItemDraw[playerid][i], 0);
		PlayerTextDrawSetPreviewRot(playerid, StoreSellItemDraw[playerid][i], -10.000000, 0.000000, -20.000000, 1.000000);
		PlayerTextDrawSetPreviewVehCol(playerid, StoreSellItemDraw[playerid][i], 1, 1);

		StoreSellItemNameDraw[playerid][i] = CreatePlayerTextDraw(playerid, 47.000000, 75.000000+(i*36), "_");
		PlayerTextDrawFont(playerid, StoreSellItemNameDraw[playerid][i], 4);
		PlayerTextDrawLetterSize(playerid, StoreSellItemNameDraw[playerid][i], 0.600000, 2.000000);
		PlayerTextDrawTextSize(playerid, StoreSellItemNameDraw[playerid][i], 85.000000, 25.000000);
		PlayerTextDrawSetOutline(playerid, StoreSellItemNameDraw[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, StoreSellItemNameDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, StoreSellItemNameDraw[playerid][i], 1);
		PlayerTextDrawColor(playerid, StoreSellItemNameDraw[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, StoreSellItemNameDraw[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, StoreSellItemNameDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, StoreSellItemNameDraw[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, StoreSellItemNameDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, StoreSellItemNameDraw[playerid][i], 0);

		StoreSellAmountDraw[playerid][i] = CreatePlayerTextDraw(playerid, 213.000000, 81.000000+(i*36), "_");
		PlayerTextDrawFont(playerid, StoreSellAmountDraw[playerid][i], 2);
		PlayerTextDrawLetterSize(playerid, StoreSellAmountDraw[playerid][i], 0.229166, 1.200000);
		PlayerTextDrawTextSize(playerid, StoreSellAmountDraw[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, StoreSellAmountDraw[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, StoreSellAmountDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, StoreSellAmountDraw[playerid][i], 2);
		PlayerTextDrawColor(playerid, StoreSellAmountDraw[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, StoreSellAmountDraw[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, StoreSellAmountDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, StoreSellAmountDraw[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, StoreSellAmountDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, StoreSellAmountDraw[playerid][i], 0);

		StoreSellPriceDraw[playerid][i] = CreatePlayerTextDraw(playerid, 167.000000, 81.000000+(i*36), "_");
		PlayerTextDrawFont(playerid, StoreSellPriceDraw[playerid][i], 2);
		PlayerTextDrawLetterSize(playerid, StoreSellPriceDraw[playerid][i], 0.229166, 1.200000);
		PlayerTextDrawTextSize(playerid, StoreSellPriceDraw[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, StoreSellPriceDraw[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, StoreSellPriceDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, StoreSellPriceDraw[playerid][i], 2);
		PlayerTextDrawColor(playerid, StoreSellPriceDraw[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, StoreSellPriceDraw[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, StoreSellPriceDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, StoreSellPriceDraw[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, StoreSellPriceDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, StoreSellPriceDraw[playerid][i], 0);
//////////////////////////////////////////////////////////////////////
		PlayerSellBackBottonDraw[playerid][i] = CreatePlayerTextDraw(playerid, 297.000000, 70.000000+(i*34), "LD_SPAC:WHITE");
		PlayerTextDrawFont(playerid, PlayerSellBackBottonDraw[playerid][i], 4);
		PlayerTextDrawLetterSize(playerid, PlayerSellBackBottonDraw[playerid][i], 0.600000, 2.000000);
		PlayerTextDrawTextSize(playerid, PlayerSellBackBottonDraw[playerid][i], 290.000000, 33.000000);
		PlayerTextDrawSetOutline(playerid, PlayerSellBackBottonDraw[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, PlayerSellBackBottonDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, PlayerSellBackBottonDraw[playerid][i], 1);
		PlayerTextDrawColor(playerid, PlayerSellBackBottonDraw[playerid][i], 2094792749);
		PlayerTextDrawBackgroundColor(playerid, PlayerSellBackBottonDraw[playerid][i], 174);
		PlayerTextDrawBoxColor(playerid, PlayerSellBackBottonDraw[playerid][i], 0);
		PlayerTextDrawUseBox(playerid, PlayerSellBackBottonDraw[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, PlayerSellBackBottonDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, PlayerSellBackBottonDraw[playerid][i], 1);

		PlayerSellItemDraw[playerid][i] = CreatePlayerTextDraw(playerid, 285.000000, 68.000000+(i*34), "Nowy_TextDraw");
		PlayerTextDrawFont(playerid, PlayerSellItemDraw[playerid][i], 5);
		PlayerTextDrawLetterSize(playerid, PlayerSellItemDraw[playerid][i], 0.600000, 2.000000);
		PlayerTextDrawTextSize(playerid, PlayerSellItemDraw[playerid][i], 52.500000, 36.000000);
		PlayerTextDrawSetOutline(playerid, PlayerSellItemDraw[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, PlayerSellItemDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, PlayerSellItemDraw[playerid][i], 1);
		PlayerTextDrawColor(playerid, PlayerSellItemDraw[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, PlayerSellItemDraw[playerid][i], 0);
		PlayerTextDrawBoxColor(playerid, PlayerSellItemDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, PlayerSellItemDraw[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, PlayerSellItemDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, PlayerSellItemDraw[playerid][i], 0);
		PlayerTextDrawSetPreviewModel(playerid, PlayerSellItemDraw[playerid][i], 0);
		PlayerTextDrawSetPreviewRot(playerid, PlayerSellItemDraw[playerid][i], -10.000000, 0.000000, -20.000000, 1.000000);
		PlayerTextDrawSetPreviewVehCol(playerid, PlayerSellItemDraw[playerid][i], 1, 1);
		
		PlayerSellItemNameDraw[playerid][i] = CreatePlayerTextDraw(playerid, 325.000000, 74.000000+(i*34), "_");
		PlayerTextDrawFont(playerid, PlayerSellItemNameDraw[playerid][i], 4);
		PlayerTextDrawLetterSize(playerid, PlayerSellItemNameDraw[playerid][i], 0.600000, 2.000000);
		PlayerTextDrawTextSize(playerid, PlayerSellItemNameDraw[playerid][i], 85.000000, 25.000000);
		PlayerTextDrawSetOutline(playerid, PlayerSellItemNameDraw[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, PlayerSellItemNameDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, PlayerSellItemNameDraw[playerid][i], 1);
		PlayerTextDrawColor(playerid, PlayerSellItemNameDraw[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, PlayerSellItemNameDraw[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, PlayerSellItemNameDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, PlayerSellItemNameDraw[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, PlayerSellItemNameDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, PlayerSellItemNameDraw[playerid][i], 0);

		PlayerSellAmountDraw[playerid][i] = CreatePlayerTextDraw(playerid, 455.000000, 81.000000+(i*34), "_");
		PlayerTextDrawFont(playerid, PlayerSellAmountDraw[playerid][i], 2);
		PlayerTextDrawLetterSize(playerid, PlayerSellAmountDraw[playerid][i], 0.229166, 1.200000);
		PlayerTextDrawTextSize(playerid, PlayerSellAmountDraw[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, PlayerSellAmountDraw[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, PlayerSellAmountDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, PlayerSellAmountDraw[playerid][i], 2);
		PlayerTextDrawColor(playerid, PlayerSellAmountDraw[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, PlayerSellAmountDraw[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, PlayerSellAmountDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, PlayerSellAmountDraw[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, PlayerSellAmountDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, PlayerSellAmountDraw[playerid][i], 0);

		PlayerSellPercentDraw[playerid][i] = CreatePlayerTextDraw(playerid, 498.000000, 81.000000+(i*34), "_");
		PlayerTextDrawFont(playerid, PlayerSellPercentDraw[playerid][i], 2);
		PlayerTextDrawLetterSize(playerid, PlayerSellPercentDraw[playerid][i], 0.229166, 1.200000);
		PlayerTextDrawTextSize(playerid, PlayerSellPercentDraw[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, PlayerSellPercentDraw[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, PlayerSellPercentDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, PlayerSellPercentDraw[playerid][i], 2);
		PlayerTextDrawColor(playerid, PlayerSellPercentDraw[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, PlayerSellPercentDraw[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, PlayerSellPercentDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, PlayerSellPercentDraw[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, PlayerSellPercentDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, PlayerSellPercentDraw[playerid][i], 0);

		PlayerSellPriceDraw[playerid][i] = CreatePlayerTextDraw(playerid, 554.000000, 81.000000+(i*34), "_");
		PlayerTextDrawFont(playerid, PlayerSellPriceDraw[playerid][i], 2);
		PlayerTextDrawLetterSize(playerid, PlayerSellPriceDraw[playerid][i], 0.229166, 1.200000);
		PlayerTextDrawTextSize(playerid, PlayerSellPriceDraw[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, PlayerSellPriceDraw[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, PlayerSellPriceDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, PlayerSellPriceDraw[playerid][i], 2);
		PlayerTextDrawColor(playerid, PlayerSellPriceDraw[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, PlayerSellPriceDraw[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, PlayerSellPriceDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, PlayerSellPriceDraw[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, PlayerSellPriceDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, PlayerSellPriceDraw[playerid][i], 0);
	}

	PlayerSellPageDraw[playerid] = CreatePlayerTextDraw(playerid, 448.000000, 383.000000, "_");
	PlayerTextDrawFont(playerid, PlayerSellPageDraw[playerid], 2);
	PlayerTextDrawLetterSize(playerid, PlayerSellPageDraw[playerid], 0.312500, 1.399999);
	PlayerTextDrawTextSize(playerid, PlayerSellPageDraw[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerSellPageDraw[playerid], 0);
	PlayerTextDrawSetShadow(playerid, PlayerSellPageDraw[playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerSellPageDraw[playerid], 2);
	PlayerTextDrawColor(playerid, PlayerSellPageDraw[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerSellPageDraw[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerSellPageDraw[playerid], 50);
	PlayerTextDrawUseBox(playerid, PlayerSellPageDraw[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PlayerSellPageDraw[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerSellPageDraw[playerid], 0);
	StoreTextDrawShow[playerid]=false;
	return 1;
}
FUNC::StoreDraw_OnPlayerDisconnect(playerid)
{
    forex(i,MAX_PLAYERSTROE_SHOW_LIST)
    {
        if(StoreSellBackBottonDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,StoreSellBackBottonDraw[playerid][i]);
		StoreSellBackBottonDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(StoreSellItemDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,StoreSellItemDraw[playerid][i]);
		StoreSellItemDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(StoreSellItemNameDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,StoreSellItemNameDraw[playerid][i]);
		StoreSellItemNameDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(StoreSellAmountDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,StoreSellAmountDraw[playerid][i]);
		StoreSellAmountDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(StoreSellPriceDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,StoreSellPriceDraw[playerid][i]);
		StoreSellPriceDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;

        if(PlayerSellBackBottonDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerSellBackBottonDraw[playerid][i]);
		PlayerSellBackBottonDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(PlayerSellItemDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerSellItemDraw[playerid][i]);
		PlayerSellItemDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(PlayerSellItemNameDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerSellItemNameDraw[playerid][i]);
		PlayerSellItemNameDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(PlayerSellPercentDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerSellPercentDraw[playerid][i]);
		PlayerSellPercentDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(PlayerSellAmountDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerSellAmountDraw[playerid][i]);
		PlayerSellAmountDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(PlayerSellPriceDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerSellPriceDraw[playerid][i]);
		PlayerSellPriceDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
    }
	if(PlayerSellPageDraw[playerid]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerSellPageDraw[playerid]);
	PlayerSellPageDraw[playerid]=PlayerText:INVALID_TEXT_DRAW;
	StoreTextDrawShow[playerid]=false;
	return 1;
}
FUNC::StoreDraw_OnGameModeInit()
{
	forex(i,MAX_PLAYERS)
	{
	    forex(s,MAX_PLAYERSTROE_SHOW_LIST)
	    {
			StoreSellBackBottonDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			StoreSellItemDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			StoreSellItemNameDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			StoreSellAmountDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			StoreSellPriceDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;

			PlayerSellBackBottonDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			PlayerSellItemDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			PlayerSellItemNameDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			PlayerSellPercentDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			PlayerSellAmountDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			PlayerSellPriceDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
	    }
	    PlayerSellPageDraw[i]=PlayerText:INVALID_TEXT_DRAW;
		StoreTextDrawShow[i]=false;
	}
	StoreBackGroundTextDraws[0] = TextDrawCreate(5.000000, 4.000000, "mdl-2003:storeback");
	TextDrawFont(StoreBackGroundTextDraws[0], 4);
	TextDrawLetterSize(StoreBackGroundTextDraws[0], 0.600000, 2.000000);
	TextDrawTextSize(StoreBackGroundTextDraws[0], 637.500000, 412.500000);
	TextDrawSetOutline(StoreBackGroundTextDraws[0], 1);
	TextDrawSetShadow(StoreBackGroundTextDraws[0], 0);
	TextDrawAlignment(StoreBackGroundTextDraws[0], 1);
	TextDrawColor(StoreBackGroundTextDraws[0], -1);
	TextDrawBackgroundColor(StoreBackGroundTextDraws[0], 255);
	TextDrawBoxColor(StoreBackGroundTextDraws[0], 50);
	TextDrawUseBox(StoreBackGroundTextDraws[0], 1);
	TextDrawSetProportional(StoreBackGroundTextDraws[0], 1);
	TextDrawSetSelectable(StoreBackGroundTextDraws[0], 0);
	
	StoreBackGroundTextDraws[1] = TextDrawCreate(413.000000, 384.000000, "mdl-2000:left");
	TextDrawFont(StoreBackGroundTextDraws[1], 4);
	TextDrawLetterSize(StoreBackGroundTextDraws[1], 0.600000, 2.000000);
	TextDrawTextSize(StoreBackGroundTextDraws[1], 11.000000, 12.500000);
	TextDrawSetOutline(StoreBackGroundTextDraws[1], 1);
	TextDrawSetShadow(StoreBackGroundTextDraws[1], 0);
	TextDrawAlignment(StoreBackGroundTextDraws[1], 1);
	TextDrawColor(StoreBackGroundTextDraws[1], -1);
	TextDrawBackgroundColor(StoreBackGroundTextDraws[1], 255);
	TextDrawBoxColor(StoreBackGroundTextDraws[1], 50);
	TextDrawUseBox(StoreBackGroundTextDraws[1], 1);
	TextDrawSetProportional(StoreBackGroundTextDraws[1], 1);
	TextDrawSetSelectable(StoreBackGroundTextDraws[1], 1);

	StoreBackGroundTextDraws[2] = TextDrawCreate(473.000000, 384.000000, "mdl-2000:right");
	TextDrawFont(StoreBackGroundTextDraws[2], 4);
	TextDrawLetterSize(StoreBackGroundTextDraws[2], 0.600000, 2.000000);
	TextDrawTextSize(StoreBackGroundTextDraws[2], 11.000000, 12.500000);
	TextDrawSetOutline(StoreBackGroundTextDraws[2], 1);
	TextDrawSetShadow(StoreBackGroundTextDraws[2], 0);
	TextDrawAlignment(StoreBackGroundTextDraws[2], 1);
	TextDrawColor(StoreBackGroundTextDraws[2], -1);
	TextDrawBackgroundColor(StoreBackGroundTextDraws[2], 255);
	TextDrawBoxColor(StoreBackGroundTextDraws[2], 50);
	TextDrawUseBox(StoreBackGroundTextDraws[2], 1);
	TextDrawSetProportional(StoreBackGroundTextDraws[2], 1);
	TextDrawSetSelectable(StoreBackGroundTextDraws[2], 1);
	return 1;
}

