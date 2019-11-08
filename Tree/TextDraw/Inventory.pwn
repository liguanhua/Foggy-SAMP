#define MAX_PLAYERINV_BOX_ITEMS MAX_BOX_ITEMS+2
#define MAX_PLAYERINV_SHOW_LIST 8

new PlayerInvPrevieBox[MAX_PLAYERS][MAX_PLAYERINV_BOX_ITEMS];
new PlayerInvPrevieBoxKey[MAX_PLAYERS][MAX_PLAYERINV_BOX_ITEMS][64];
new PlayerInvPrevieCount[MAX_PLAYERS];
new PlayerInvPreviePage[MAX_PLAYERS];
new PlayerInvPrevieRate[MAX_PLAYERS];
new PlayerInvPrevieSortType[MAX_PLAYERS];

new PlayerNearPrevieBox[MAX_PLAYERS][MAX_PLAYERINV_BOX_ITEMS];
new PlayerNearPrevieBoxKey[MAX_PLAYERS][MAX_PLAYERINV_BOX_ITEMS][64];
new PlayerNearPrevieCount[MAX_PLAYERS];
new PlayerNearPreviePage[MAX_PLAYERS];
new PlayerNearPrevieRate[MAX_PLAYERS];

enum
{
    INV_CLICK_NONE,
    INV_CLICK_SAME,
    INV_CLICK_NOT_TYPE,
    INV_CLICK_NOT_ID,
    INV_CLICK_NOT_ALL
}
enum
{
    INV_CLICK_TYPE_NONE,
    INV_CLICK_TYPE_NEAR,
    INV_CLICK_TYPE_BAG,
    INV_CLICK_TYPE_EQUIP,
    INV_CLICK_TYPE_WEAPON
}
new PlayerInvClickType[MAX_PLAYERS]= {INV_CLICK_TYPE_NONE, ...};
new PlayerInvClickID[MAX_PLAYERS]= {NONE, ...};


new Text:InventoryTextDraw[28]= {Text:INVALID_TEXT_DRAW, ...};
new bool:InventoryTextDrawShow[MAX_PLAYERS]= {false, ...};

new PlayerText:PlayerInvBackBottonDraw[MAX_PLAYERS][MAX_PLAYERINV_SHOW_LIST];
new PlayerText:PlayerInvItemDraw[MAX_PLAYERS][MAX_PLAYERINV_SHOW_LIST];
new PlayerText:PlayerInvItemNameDraw[MAX_PLAYERS][MAX_PLAYERINV_SHOW_LIST];
new PlayerText:PlayerInvPercentDraw[MAX_PLAYERS][MAX_PLAYERINV_SHOW_LIST];
new PlayerText:PlayerInvAmountDraw[MAX_PLAYERS][MAX_PLAYERINV_SHOW_LIST];

new PlayerText:PlayerNearBackBottonDraw[MAX_PLAYERS][MAX_PLAYERINV_SHOW_LIST];
new PlayerText:PlayerNearItemDraw[MAX_PLAYERS][MAX_PLAYERINV_SHOW_LIST];
new PlayerText:PlayerNearItemNameDraw[MAX_PLAYERS][MAX_PLAYERINV_SHOW_LIST];
new PlayerText:PlayerNearPercentDraw[MAX_PLAYERS][MAX_PLAYERINV_SHOW_LIST];
new PlayerText:PlayerNearAmountDraw[MAX_PLAYERS][MAX_PLAYERINV_SHOW_LIST];

new PlayerText:PlayerEquipItemDraw[MAX_PLAYERS][MAX_PLAYER_EQUIPS];
new PlayerText:PlayerEquipPercentDraw[MAX_PLAYERS][MAX_PLAYER_EQUIPS];
new PlayerText:PlayerEquipBackBottonDraw[MAX_PLAYERS][MAX_PLAYER_EQUIPS];

new PlayerText:PlayerWeaponItemDraw[MAX_PLAYERS][MAX_PLAYER_WEAPONS];
new PlayerText:PlayerWeaponPercentDraw[MAX_PLAYERS][MAX_PLAYER_WEAPONS];
new PlayerText:PlayerWeaponNameDraw[MAX_PLAYERS][MAX_PLAYER_WEAPONS];
new PlayerText:PlayerWeaponBackBottonDraw[MAX_PLAYERS][MAX_PLAYER_WEAPONS];

new PlayerText:PlayerCapacityProgressDraw[MAX_PLAYERS];
new PlayerText:PlayerNearPageDraw[MAX_PLAYERS];
new PlayerText:PlayerInvPageDraw[MAX_PLAYERS];
/***************************************************************/
#define MAX_ZOMBIE_TEXTDRAWS 5
#define MAX_PLAYER_ZOMBIE_TEXTDRAWS 5
#define MAX_PLAYERINV_BOX_ITEMS MAX_BOX_ITEMS+2
new Text:ZombieBagTextDraws[MAX_ZOMBIE_TEXTDRAWS]= {Text:INVALID_TEXT_DRAW, ...};
new PlayerText:PlayerZombieBagBackDraws[MAX_PLAYERS][MAX_PLAYER_ZOMBIE_TEXTDRAWS];
new PlayerText:PlayerZombieBagModelDraws[MAX_PLAYERS][MAX_PLAYER_ZOMBIE_TEXTDRAWS];
new PlayerText:PlayerZombieBagNameDraws[MAX_PLAYERS][MAX_PLAYER_ZOMBIE_TEXTDRAWS];
new PlayerText:PlayerZombieBagAmountDraws[MAX_PLAYERS][MAX_PLAYER_ZOMBIE_TEXTDRAWS];
new PlayerText:PlayerZombieBagPercentDraws[MAX_PLAYERS][MAX_PLAYER_ZOMBIE_TEXTDRAWS];
new PlayerText:PlayerZombieBagPageDraws[MAX_PLAYERS];

new PlayerZombieBagPrevieBox[MAX_PLAYERS][MAX_PLAYERINV_BOX_ITEMS];
new PlayerZombieBagPrevieBoxKey[MAX_PLAYERS][MAX_PLAYERINV_BOX_ITEMS][64];
new PlayerZombieBagPrevieCount[MAX_PLAYERS];
new PlayerZombieBagPreviePage[MAX_PLAYERS];
new PlayerZombieBagPrevieRate[MAX_PLAYERS];
new PlayerZombieBagClickID[MAX_PLAYERS];
new PlayerZombieBagZombieID[MAX_PLAYERS];

new bool:PlayerZombieBagTextDrawShow[MAX_PLAYERS]= {false, ...};
/***************************************************************/

FUNC::GetLastClickInvType(playerid,newclickid,newclicktype)//对比上次背包界面点击
{
	if(PlayerInvClickType[playerid]==INV_CLICK_TYPE_NONE&&PlayerInvClickID[playerid]==NONE)return INV_CLICK_NONE;
	if(PlayerInvClickType[playerid]==newclicktype&&PlayerInvClickID[playerid]==newclickid)return INV_CLICK_SAME;
	if(PlayerInvClickType[playerid]!=newclicktype&&PlayerInvClickID[playerid]==newclickid)return INV_CLICK_NOT_TYPE;
	if(PlayerInvClickType[playerid]==newclicktype&&PlayerInvClickID[playerid]!=newclickid)return INV_CLICK_NOT_ID;
	if(PlayerInvClickType[playerid]!=newclicktype&&PlayerInvClickID[playerid]!=newclickid)return INV_CLICK_NOT_ALL;
	return INV_CLICK_NONE;
}


FUNC::UpdatePlayerWeapon(playerid)//更新显示武器GUI
{
	forex(i,MAX_PLAYER_WEAPONS)
	{
		PlayerTextDrawHide(playerid, PlayerWeaponItemDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerWeaponPercentDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerWeaponNameDraw[playerid][i]);
	}
	new Strings[64];
	foreach(new i:PlayerWeapon[playerid])
 	{
		PlayerTextDrawSetPreviewModel(playerid, PlayerWeaponItemDraw[playerid][i], Item[PlayerWeapon[playerid][i][_ItemID]][_Model]);
        format(Strings,sizeof(Strings),"%0.1f%",PlayerWeapon[playerid][i][_Durable]);
		PlayerTextDrawSetString(playerid, PlayerWeaponPercentDraw[playerid][i],Strings);
        format(Strings,sizeof(Strings),"%s",Item[PlayerWeapon[playerid][i][_ItemID]][_NameTXD]);
		PlayerTextDrawSetString(playerid, PlayerWeaponNameDraw[playerid][i],Strings);
		PlayerTextDrawShow(playerid, PlayerWeaponBackBottonDraw[playerid][i]);
		PlayerTextDrawShow(playerid, PlayerWeaponItemDraw[playerid][i]);
		PlayerTextDrawShow(playerid, PlayerWeaponPercentDraw[playerid][i]);
		PlayerTextDrawShow(playerid, PlayerWeaponNameDraw[playerid][i]);
  	}
	return 1;
}
FUNC::UpdatePlayerEquip(playerid)//更新显示装备GUI
{
	forex(i,MAX_PLAYER_EQUIPS)
	{
		PlayerTextDrawHide(playerid, PlayerEquipItemDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerEquipPercentDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerEquipBackBottonDraw[playerid][i]);
	}
	new Strings[32];
	forex(i,MAX_PLAYER_EQUIPS)
	{
	    PlayerTextDrawSetSelectable(playerid, PlayerEquipBackBottonDraw[playerid][i], 0);
		PlayerTextDrawShow(playerid, PlayerEquipBackBottonDraw[playerid][i]);
    }
	foreach(new i:PlayerEquip[playerid])
 	{
 		PlayerTextDrawSetPreviewModel(playerid, PlayerEquipItemDraw[playerid][i], Item[PlayerEquip[playerid][i][_ItemID]][_Model]);
        format(Strings,sizeof(Strings),"%0.1f%",PlayerEquip[playerid][i][_Durable]);
		PlayerTextDrawSetString(playerid, PlayerEquipPercentDraw[playerid][i],Strings);
		PlayerTextDrawSetSelectable(playerid, PlayerEquipBackBottonDraw[playerid][i], 1);
		PlayerTextDrawShow(playerid, PlayerEquipBackBottonDraw[playerid][i]);
 		PlayerTextDrawShow(playerid, PlayerEquipItemDraw[playerid][i]);
		PlayerTextDrawShow(playerid, PlayerEquipPercentDraw[playerid][i]);
 	}
	return 1;
}
FUNC::UpdatePlayerInvPage(playerid,pages,sorttype)//更新显示库存GUI
{
	forex(i,MAX_PLAYERINV_SHOW_LIST)
	{
		PlayerTextDrawHide(playerid, PlayerInvBackBottonDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerInvItemDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerInvItemNameDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerInvPercentDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerInvAmountDraw[playerid][i]);
	}
	PlayerTextDrawHide(playerid, PlayerCapacityProgressDraw[playerid]);
	PlayerTextDrawHide(playerid, PlayerInvPageDraw[playerid]);
	new index=0,PlayerInvAmout=0;
    PlayerInvPrevieRate[playerid]=0;
    PlayerInvPrevieCount[playerid]=1;
    PlayerInvClickID[playerid]=NONE;
    PlayerInvPrevieSortType[playerid]=sorttype;
	new	Project_ID[MAX_PLAYER_INV_SLOTS],Top_Info[MAX_PLAYER_INV_SLOTS],Current_TopLine=Iter_Count(PlayerInv[playerid]);
	if(sorttype==0)
	{
		foreach(new i:PlayerInv[playerid])
	    {
	        HighestTopList(i,PlayerInv[playerid][i][_ItemID],Project_ID, Top_Info, Current_TopLine);
	    }
    }
    else
    {
		foreach(new i:PlayerInv[playerid])
	    {
	        HighestTopList(i,PlayerInv[playerid][i][_GetTime],Project_ID, Top_Info, Current_TopLine);
	    }
    }
    forex(i,Current_TopLine)
	{
	    if(PlayerInvAmout<MAX_PLAYERINV_BOX_ITEMS-2)
	    {
			PlayerInvPrevieBox[playerid][PlayerInvPrevieCount[playerid]]=Project_ID[i];
			format(PlayerInvPrevieBoxKey[playerid][PlayerInvPrevieCount[playerid]],64,"");
			format(PlayerInvPrevieBoxKey[playerid][PlayerInvPrevieCount[playerid]],64,PlayerInv[playerid][Project_ID[i]][_InvKey]);
   			PlayerInvPrevieCount[playerid]++;
   			PlayerInvAmout++;
	    }
	}
	if(pages<1)pages=1;
	if(pages>floatround((PlayerInvPrevieCount[playerid]-1)/float(MAX_PLAYERINV_SHOW_LIST),floatround_ceil))pages=floatround((PlayerInvPrevieCount[playerid]-1)/float(MAX_PLAYERINV_SHOW_LIST),floatround_ceil);
    PlayerInvPreviePage[playerid]=pages;
    pages=(pages-1)*MAX_PLAYERINV_SHOW_LIST;
    if(pages<=0)pages=1;else pages++;
    new Strings[32];
    loop(i,pages,pages+MAX_PLAYERINV_SHOW_LIST)
	{
	    index=PlayerInvPrevieBox[playerid][i];
	    if(i<PlayerInvPrevieCount[playerid])
		{
		    PlayerTextDrawSetPreviewModel(playerid, PlayerInvItemDraw[playerid][PlayerInvPrevieRate[playerid]], Item[PlayerInv[playerid][index][_ItemID]][_Model]);
			PlayerTextDrawSetString(playerid,PlayerInvItemNameDraw[playerid][PlayerInvPrevieRate[playerid]],Item[PlayerInv[playerid][index][_ItemID]][_NameTXD]);
            if(Item[PlayerInv[playerid][index][_ItemID]][_Durable]==1)
            {
				format(Strings,sizeof(Strings),"%0.1f%",PlayerInv[playerid][index][_Durable]);
				PlayerTextDrawSetString(playerid,PlayerInvPercentDraw[playerid][PlayerInvPrevieRate[playerid]],Strings);
			}
			format(Strings,sizeof(Strings),"%i",PlayerInv[playerid][index][_Amounts]);
			PlayerTextDrawSetString(playerid,PlayerInvAmountDraw[playerid][PlayerInvPrevieRate[playerid]],Strings);
			PlayerTextDrawShow(playerid, PlayerInvBackBottonDraw[playerid][PlayerInvPrevieRate[playerid]]);
			PlayerTextDrawShow(playerid, PlayerInvItemDraw[playerid][PlayerInvPrevieRate[playerid]]);
			PlayerTextDrawShow(playerid, PlayerInvItemNameDraw[playerid][PlayerInvPrevieRate[playerid]]);
			if(Item[PlayerInv[playerid][index][_ItemID]][_Durable]==1)PlayerTextDrawShow(playerid, PlayerInvPercentDraw[playerid][PlayerInvPrevieRate[playerid]]);
			PlayerTextDrawShow(playerid, PlayerInvAmountDraw[playerid][PlayerInvPrevieRate[playerid]]);
		    PlayerInvPrevieRate[playerid]++;
		}
	    else break;
	}
	
	new Float:Percentage=floatdiv(GetPlayerCurrentCapacity(playerid),GetPlayerMaxCapacity(playerid));
	if(Percentage>1.0)Percentage=1.0;
	PlayerTextDrawTextSize(playerid, PlayerCapacityProgressDraw[playerid], 1.000000, 122.000000*Percentage);
	PlayerTextDrawShow(playerid, PlayerCapacityProgressDraw[playerid]);
	format(Strings,sizeof(Strings),"%02d/%02d",PlayerInvPreviePage[playerid],floatround((PlayerInvPrevieCount[playerid]-1)/float(MAX_PLAYERINV_SHOW_LIST),floatround_ceil));
    PlayerTextDrawSetString(playerid,PlayerInvPageDraw[playerid],Strings);
	PlayerTextDrawShow(playerid, PlayerInvPageDraw[playerid]);
	return 1;
}
/*new PlayerText:PlayerNearBackBottonDraw[MAX_PLAYERS][MAX_PLAYERINV_SHOW_LIST];
new PlayerText:PlayerNearItemDraw[MAX_PLAYERS][MAX_PLAYERINV_SHOW_LIST];
new PlayerText:PlayerNearItemNameDraw[MAX_PLAYERS][MAX_PLAYERINV_SHOW_LIST];
new PlayerText:PlayerNearPercentDraw[MAX_PLAYERS][MAX_PLAYERINV_SHOW_LIST];
new PlayerText:PlayerNearAmountDraw[MAX_PLAYERS][MAX_PLAYERINV_SHOW_LIST];*/

FUNC::UpdatePlayerNearPage(playerid,pages)//更新显示附近GUI
{
	forex(i,MAX_PLAYERINV_SHOW_LIST)
	{
		PlayerTextDrawHide(playerid, PlayerNearBackBottonDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerNearItemDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerNearItemNameDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerNearPercentDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerNearAmountDraw[playerid][i]);
	}
	PlayerTextDrawHide(playerid, PlayerNearPageDraw[playerid]);
	new index=0,PlayerNearAmout=0;
    PlayerNearPrevieRate[playerid]=0;
    PlayerNearPrevieCount[playerid]=1;
    PlayerInvClickID[playerid]=NONE;
	//new	Project_ID[MAX_PICKUP],Float:Top_Info[MAX_PICKUP],Current_TopLine=Iter_Count(PickUp),Counts=0;
	//new Float:PlayerPos[3];
	//GetPlayerPos(playerid,PlayerPos[0],PlayerPos[1],PlayerPos[2]);
	//new Float:Distance;
	foreach(new i:PickUp)
	{
    	if(IsPlayerInRangeOfPoint(playerid,3.0,PickUp[i][_X],PickUp[i][_Y],PickUp[i][_Z]))
        {
			PlayerNearPrevieBox[playerid][PlayerNearPrevieCount[playerid]]=i;
			format(PlayerNearPrevieBoxKey[playerid][PlayerNearPrevieCount[playerid]],64,PickUp[i][_Key]);
   			PlayerNearPrevieCount[playerid]++;
   			PlayerNearAmout++;
        }
	}
	/*foreach(new i:PickUp)
    {
    	if(IsPlayerInRangeOfPoint(playerid,3.0,PickUp[i][_X],PickUp[i][_Y],PickUp[i][_Z]))
        {
	    	Distance=GetDistanceBetweenPoints3D(PlayerPos[0],PlayerPos[1],PlayerPos[2],PickUp[i][_X],PickUp[i][_Y],PickUp[i][_Z]);
			if(Distance<3.0)
			{
				HighestTopListFloat(i,Distance,Project_ID, Top_Info, Current_TopLine);
				Counts++;
			}
		}
    }
	for(new i=Counts-1;i>=0;i--)
	{
	    if(PlayerNearAmout<MAX_PLAYERINV_BOX_ITEMS-2)
	    {
			PlayerNearPrevieBox[playerid][PlayerNearPrevieCount[playerid]]=Project_ID[i];
			format(PlayerNearPrevieBoxKey[playerid][PlayerNearPrevieCount[playerid]],64,PickUp[Project_ID[i]][_Key]);
   			PlayerNearPrevieCount[playerid]++;
   			PlayerNearAmout++;
	    }
	}*/
	if(pages<1)pages=1;
	if(pages>floatround((PlayerNearPrevieCount[playerid]-1)/float(MAX_PLAYERINV_SHOW_LIST),floatround_ceil))pages=floatround((PlayerNearPrevieCount[playerid]-1)/float(MAX_PLAYERINV_SHOW_LIST),floatround_ceil);
    PlayerNearPreviePage[playerid]=pages;
    pages=(pages-1)*MAX_PLAYERINV_SHOW_LIST;
    if(pages<=0)pages=1;else pages++;
    new Strings[32];
    loop(i,pages,pages+MAX_PLAYERINV_SHOW_LIST)
	{
	    index=PlayerNearPrevieBox[playerid][i];
	    if(i<PlayerNearPrevieCount[playerid])
		{
		    PlayerTextDrawSetPreviewModel(playerid, PlayerNearItemDraw[playerid][PlayerNearPrevieRate[playerid]], Item[PickUp[index][_ItemID]][_Model]);
			PlayerTextDrawSetString(playerid,PlayerNearItemNameDraw[playerid][PlayerNearPrevieRate[playerid]],Item[PickUp[index][_ItemID]][_NameTXD]);
            if(Item[PickUp[index][_ItemID]][_Durable]==1)
            {
				format(Strings,sizeof(Strings),"%0.1f%",PickUp[index][_Durable]);
				PlayerTextDrawSetString(playerid,PlayerNearPercentDraw[playerid][PlayerNearPrevieRate[playerid]],Strings);
			}
			format(Strings,sizeof(Strings),"%i",PickUp[index][_Amounts]);
			PlayerTextDrawSetString(playerid,PlayerNearAmountDraw[playerid][PlayerNearPrevieRate[playerid]],Strings);
			PlayerTextDrawShow(playerid, PlayerNearBackBottonDraw[playerid][PlayerNearPrevieRate[playerid]]);
			PlayerTextDrawShow(playerid, PlayerNearItemDraw[playerid][PlayerNearPrevieRate[playerid]]);
			PlayerTextDrawShow(playerid, PlayerNearItemNameDraw[playerid][PlayerNearPrevieRate[playerid]]);
			if(Item[PickUp[index][_ItemID]][_Durable]==1)PlayerTextDrawShow(playerid, PlayerNearPercentDraw[playerid][PlayerNearPrevieRate[playerid]]);
			PlayerTextDrawShow(playerid, PlayerNearAmountDraw[playerid][PlayerNearPrevieRate[playerid]]);
		    PlayerNearPrevieRate[playerid]++;
		}
	    else break;
	}

	format(Strings,sizeof(Strings),"%02d/%02d",PlayerNearPreviePage[playerid],floatround((PlayerNearPrevieCount[playerid]-1)/float(MAX_PLAYERINV_SHOW_LIST),floatround_ceil));
    PlayerTextDrawSetString(playerid,PlayerNearPageDraw[playerid],Strings);
	PlayerTextDrawShow(playerid, PlayerNearPageDraw[playerid]);
	return 1;
}
/*
#define MAX_ZOMBIE_TEXTDRAWS 5
#define MAX_PLAYER_ZOMBIE_TEXTDRAWS 5
new Text:ZombieBagTextDraws[MAX_ZOMBIE_TEXTDRAWS]= {Text:INVALID_TEXT_DRAW, ...};
new PlayerText:PlayerZombieBagBackDraws[MAX_PLAYERS][MAX_PLAYER_ZOMBIE_TEXTDRAWS];
new PlayerText:PlayerZombieBagModelDraws[MAX_PLAYERS][MAX_PLAYER_ZOMBIE_TEXTDRAWS];
new PlayerText:PlayerZombieBagNameDraws[MAX_PLAYERS][MAX_PLAYER_ZOMBIE_TEXTDRAWS];
new PlayerText:PlayerZombieBagAmountDraws[MAX_PLAYERS][MAX_PLAYER_ZOMBIE_TEXTDRAWS];
new PlayerText:PlayerZombieBagPercentDraws[MAX_PLAYERS][MAX_PLAYER_ZOMBIE_TEXTDRAWS];
new PlayerText:PlayerZombieBagPageDraws[MAX_PLAYERS];*/
FUNC::Inv_OnPlayerConnect(playerid)
{
	forex(i,MAX_PLAYER_ZOMBIE_TEXTDRAWS)
	{
		PlayerZombieBagBackDraws[playerid][i] = CreatePlayerTextDraw(playerid, 123.000000, floatadd(114.000000,floatmul(i,44)), "LD_SPAC:WHITE");
		PlayerTextDrawFont(playerid, PlayerZombieBagBackDraws[playerid][i], 4);
		PlayerTextDrawLetterSize(playerid, PlayerZombieBagBackDraws[playerid][i], 0.600000, 2.000000);
		PlayerTextDrawTextSize(playerid, PlayerZombieBagBackDraws[playerid][i], 133.000000, 43.000000);
		PlayerTextDrawSetOutline(playerid, PlayerZombieBagBackDraws[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, PlayerZombieBagBackDraws[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, PlayerZombieBagBackDraws[playerid][i], 1);
		PlayerTextDrawColor(playerid, PlayerZombieBagBackDraws[playerid][i], -256);
		PlayerTextDrawBackgroundColor(playerid, PlayerZombieBagBackDraws[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, PlayerZombieBagBackDraws[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, PlayerZombieBagBackDraws[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, PlayerZombieBagBackDraws[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, PlayerZombieBagBackDraws[playerid][i], 1);

		PlayerZombieBagModelDraws[playerid][i] = CreatePlayerTextDraw(playerid, 122.000000, floatadd(114.000000,floatmul(i,44)), "-2400");
		PlayerTextDrawFont(playerid, PlayerZombieBagModelDraws[playerid][i], 5);
		PlayerTextDrawLetterSize(playerid, PlayerZombieBagModelDraws[playerid][i], 0.600000, 2.000000);
		PlayerTextDrawTextSize(playerid, PlayerZombieBagModelDraws[playerid][i], 43.000000, 43.000000);
		PlayerTextDrawSetOutline(playerid, PlayerZombieBagModelDraws[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, PlayerZombieBagModelDraws[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, PlayerZombieBagModelDraws[playerid][i], 1);
		PlayerTextDrawColor(playerid, PlayerZombieBagModelDraws[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, PlayerZombieBagModelDraws[playerid][i], 0);
		PlayerTextDrawBoxColor(playerid, PlayerZombieBagModelDraws[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, PlayerZombieBagModelDraws[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, PlayerZombieBagModelDraws[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, PlayerZombieBagModelDraws[playerid][i], 0);
		PlayerTextDrawSetPreviewModel(playerid, PlayerZombieBagModelDraws[playerid][i], -2600);
		PlayerTextDrawSetPreviewRot(playerid, PlayerZombieBagModelDraws[playerid][i], 0.000000, 0.000000, 0.000000, 0.750000);
		PlayerTextDrawSetPreviewVehCol(playerid, PlayerZombieBagModelDraws[playerid][i], 1, 1);
		
		PlayerZombieBagNameDraws[playerid][i] = CreatePlayerTextDraw(playerid, 165.000000, floatadd(122.000000,floatmul(i,44)), "mdl-2007:yanjing0");
		PlayerTextDrawFont(playerid, PlayerZombieBagNameDraws[playerid][i], 4);
		PlayerTextDrawLetterSize(playerid, PlayerZombieBagNameDraws[playerid][i], 0.600000, 2.000000);
		PlayerTextDrawTextSize(playerid, PlayerZombieBagNameDraws[playerid][i], 85.500000, 26.000000);
		PlayerTextDrawSetOutline(playerid, PlayerZombieBagNameDraws[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, PlayerZombieBagNameDraws[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, PlayerZombieBagNameDraws[playerid][i], 1);
		PlayerTextDrawColor(playerid, PlayerZombieBagNameDraws[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, PlayerZombieBagNameDraws[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, PlayerZombieBagNameDraws[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, PlayerZombieBagNameDraws[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, PlayerZombieBagNameDraws[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, PlayerZombieBagNameDraws[playerid][i], 0);
		
		PlayerZombieBagPercentDraws[playerid][i] = CreatePlayerTextDraw(playerid, 160.000000, floatadd(146.000000,floatmul(i,44)), "100%");
		PlayerTextDrawFont(playerid, PlayerZombieBagPercentDraws[playerid][i], 2);
		PlayerTextDrawLetterSize(playerid, PlayerZombieBagPercentDraws[playerid][i], 0.174998, 1.250000);
		PlayerTextDrawTextSize(playerid, PlayerZombieBagPercentDraws[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, PlayerZombieBagPercentDraws[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, PlayerZombieBagPercentDraws[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, PlayerZombieBagPercentDraws[playerid][i], 3);
		PlayerTextDrawColor(playerid, PlayerZombieBagPercentDraws[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, PlayerZombieBagPercentDraws[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, PlayerZombieBagPercentDraws[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, PlayerZombieBagPercentDraws[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, PlayerZombieBagPercentDraws[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, PlayerZombieBagPercentDraws[playerid][i], 0);

		PlayerZombieBagAmountDraws[playerid][i] = CreatePlayerTextDraw(playerid, 247.500000, floatadd(126.000000,floatmul(i,44)), "10");
		PlayerTextDrawFont(playerid, PlayerZombieBagAmountDraws[playerid][i], 2);
		PlayerTextDrawLetterSize(playerid, PlayerZombieBagAmountDraws[playerid][i], 0.309165, 1.700001);
		PlayerTextDrawTextSize(playerid, PlayerZombieBagAmountDraws[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, PlayerZombieBagAmountDraws[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, PlayerZombieBagAmountDraws[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, PlayerZombieBagAmountDraws[playerid][i], 3);
		PlayerTextDrawColor(playerid, PlayerZombieBagAmountDraws[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, PlayerZombieBagAmountDraws[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, PlayerZombieBagAmountDraws[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, PlayerZombieBagAmountDraws[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, PlayerZombieBagAmountDraws[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, PlayerZombieBagAmountDraws[playerid][i], 0);
	}

	PlayerZombieBagPageDraws[playerid] = CreatePlayerTextDraw(playerid, 188.000000, 336.000000, "00/00");
	PlayerTextDrawFont(playerid, PlayerZombieBagPageDraws[playerid], 2);
	PlayerTextDrawLetterSize(playerid, PlayerZombieBagPageDraws[playerid], 0.208333, 1.299999);
	PlayerTextDrawTextSize(playerid, PlayerZombieBagPageDraws[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerZombieBagPageDraws[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PlayerZombieBagPageDraws[playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerZombieBagPageDraws[playerid], 2);
	PlayerTextDrawColor(playerid, PlayerZombieBagPageDraws[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerZombieBagPageDraws[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerZombieBagPageDraws[playerid], 50);
	PlayerTextDrawUseBox(playerid, PlayerZombieBagPageDraws[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PlayerZombieBagPageDraws[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerZombieBagPageDraws[playerid], 0);

	forex(i,MAX_PLAYERINV_SHOW_LIST)
	{
	    PlayerInvBackBottonDraw[playerid][i]=CreatePlayerTextDraw(playerid, 119.000000, 65.000000+(i*42), "LD_SPAC:WHITE");
		PlayerTextDrawFont(playerid, PlayerInvBackBottonDraw[playerid][i], 4);
		PlayerTextDrawLetterSize(playerid, PlayerInvBackBottonDraw[playerid][i], 0.600000, 2.000000);
		PlayerTextDrawTextSize(playerid, PlayerInvBackBottonDraw[playerid][i], 99.500000, 41.000000);
		PlayerTextDrawSetOutline(playerid, PlayerInvBackBottonDraw[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, PlayerInvBackBottonDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, PlayerInvBackBottonDraw[playerid][i], 1);
		PlayerTextDrawColor(playerid, PlayerInvBackBottonDraw[playerid][i], -156);
		PlayerTextDrawBackgroundColor(playerid, PlayerInvBackBottonDraw[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, PlayerInvBackBottonDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, PlayerInvBackBottonDraw[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, PlayerInvBackBottonDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, PlayerInvBackBottonDraw[playerid][i], 1);
		
		PlayerInvItemDraw[playerid][i] = CreatePlayerTextDraw(playerid, 115.000000, 65.000000+(i*42), "Nowy_TextDraw");
		PlayerTextDrawFont(playerid, PlayerInvItemDraw[playerid][i], 5);
		PlayerTextDrawLetterSize(playerid, PlayerInvItemDraw[playerid][i], 0.600000, 2.000000);
		PlayerTextDrawTextSize(playerid, PlayerInvItemDraw[playerid][i], 38.000000, 38.000000);
		PlayerTextDrawSetOutline(playerid, PlayerInvItemDraw[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, PlayerInvItemDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, PlayerInvItemDraw[playerid][i], 1);
		PlayerTextDrawColor(playerid, PlayerInvItemDraw[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, PlayerInvItemDraw[playerid][i], 0);
		PlayerTextDrawBoxColor(playerid, PlayerInvItemDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, PlayerInvItemDraw[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, PlayerInvItemDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, PlayerInvItemDraw[playerid][i], 0);
		PlayerTextDrawSetPreviewModel(playerid, PlayerInvItemDraw[playerid][i], -2301);
		PlayerTextDrawSetPreviewRot(playerid, PlayerInvItemDraw[playerid][i], 0.000000, 0.000000, 0.000000, 0.750000);
		PlayerTextDrawSetPreviewVehCol(playerid, PlayerInvItemDraw[playerid][i], 1, 1);
		
		PlayerInvItemNameDraw[playerid][i] = CreatePlayerTextDraw(playerid, 153.000000, 76.000000+(i*42), "mdl-2000:Inv_2");
		PlayerTextDrawFont(playerid, PlayerInvItemNameDraw[playerid][i], 4);
		PlayerTextDrawLetterSize(playerid, PlayerInvItemNameDraw[playerid][i], 0.600000, 2.000000);
		PlayerTextDrawTextSize(playerid, PlayerInvItemNameDraw[playerid][i], 55.000000, 23.000000);
		PlayerTextDrawSetOutline(playerid, PlayerInvItemNameDraw[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, PlayerInvItemNameDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, PlayerInvItemNameDraw[playerid][i], 1);
		PlayerTextDrawColor(playerid, PlayerInvItemNameDraw[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, PlayerInvItemNameDraw[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, PlayerInvItemNameDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, PlayerInvItemNameDraw[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, PlayerInvItemNameDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, PlayerInvItemNameDraw[playerid][i], 0);
		
		PlayerInvPercentDraw[playerid][i] = CreatePlayerTextDraw(playerid, 150.000000, 97.000000+(i*42), "100%");
		PlayerTextDrawFont(playerid, PlayerInvPercentDraw[playerid][i], 2);
		PlayerTextDrawLetterSize(playerid, PlayerInvPercentDraw[playerid][i], 0.166666, 0.949998);
		PlayerTextDrawTextSize(playerid, PlayerInvPercentDraw[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, PlayerInvPercentDraw[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, PlayerInvPercentDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, PlayerInvPercentDraw[playerid][i], 3);
		PlayerTextDrawColor(playerid, PlayerInvPercentDraw[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, PlayerInvPercentDraw[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, PlayerInvPercentDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, PlayerInvPercentDraw[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, PlayerInvPercentDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, PlayerInvPercentDraw[playerid][i], 0);

		PlayerInvAmountDraw[playerid][i] = CreatePlayerTextDraw(playerid, 212.000000, 79.000000+(i*42), "1");
		PlayerTextDrawFont(playerid, PlayerInvAmountDraw[playerid][i], 2);
		PlayerTextDrawLetterSize(playerid, PlayerInvAmountDraw[playerid][i], 0.333332, 1.649996);
		PlayerTextDrawTextSize(playerid, PlayerInvAmountDraw[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, PlayerInvAmountDraw[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, PlayerInvAmountDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, PlayerInvAmountDraw[playerid][i], 3);
		PlayerTextDrawColor(playerid, PlayerInvAmountDraw[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, PlayerInvAmountDraw[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, PlayerInvAmountDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, PlayerInvAmountDraw[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, PlayerInvAmountDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, PlayerInvAmountDraw[playerid][i], 0);
		//////////////////////////////////////////////////////////////////////////////////
		PlayerNearBackBottonDraw[playerid][i] = CreatePlayerTextDraw(playerid, 12.000000, 65.000000+(i*42), "LD_SPAC:WHITE");
		PlayerTextDrawFont(playerid, PlayerNearBackBottonDraw[playerid][i], 4);
		PlayerTextDrawLetterSize(playerid, PlayerNearBackBottonDraw[playerid][i], 0.600000, 2.000000);
		PlayerTextDrawTextSize(playerid, PlayerNearBackBottonDraw[playerid][i], 99.500000, 41.000000);
		PlayerTextDrawSetOutline(playerid, PlayerNearBackBottonDraw[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, PlayerNearBackBottonDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, PlayerNearBackBottonDraw[playerid][i], 1);
		PlayerTextDrawColor(playerid, PlayerNearBackBottonDraw[playerid][i], -156);
		PlayerTextDrawBackgroundColor(playerid, PlayerNearBackBottonDraw[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, PlayerNearBackBottonDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, PlayerNearBackBottonDraw[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, PlayerNearBackBottonDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, PlayerNearBackBottonDraw[playerid][i], 1);
		
		PlayerNearItemDraw[playerid][i] = CreatePlayerTextDraw(playerid, 8.000000, 65.000000+(i*42), "Nowy_TextDraw");
		PlayerTextDrawFont(playerid, PlayerNearItemDraw[playerid][i], 5);
		PlayerTextDrawLetterSize(playerid, PlayerNearItemDraw[playerid][i], 0.600000, 2.000000);
		PlayerTextDrawTextSize(playerid, PlayerNearItemDraw[playerid][i], 38.000000, 38.000000);
		PlayerTextDrawSetOutline(playerid, PlayerNearItemDraw[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, PlayerNearItemDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, PlayerNearItemDraw[playerid][i], 1);
		PlayerTextDrawColor(playerid, PlayerNearItemDraw[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, PlayerNearItemDraw[playerid][i], 0);
		PlayerTextDrawBoxColor(playerid, PlayerNearItemDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, PlayerNearItemDraw[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, PlayerNearItemDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, PlayerNearItemDraw[playerid][i], 0);
		PlayerTextDrawSetPreviewModel(playerid, PlayerNearItemDraw[playerid][i], -2301);
		PlayerTextDrawSetPreviewRot(playerid, PlayerNearItemDraw[playerid][i], 0.000000, 0.000000, 0.000000, 0.750000);
		PlayerTextDrawSetPreviewVehCol(playerid, PlayerNearItemDraw[playerid][i], 1, 1);
		
		PlayerNearItemNameDraw[playerid][i] = CreatePlayerTextDraw(playerid, 47.000000, 76.000000+(i*42), "mdl-2000:Inv_2");
		PlayerTextDrawFont(playerid, PlayerNearItemNameDraw[playerid][i], 4);
		PlayerTextDrawLetterSize(playerid, PlayerNearItemNameDraw[playerid][i], 0.600000, 2.000000);
		PlayerTextDrawTextSize(playerid, PlayerNearItemNameDraw[playerid][i], 55.000000, 23.000000);
		PlayerTextDrawSetOutline(playerid, PlayerNearItemNameDraw[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, PlayerNearItemNameDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, PlayerNearItemNameDraw[playerid][i], 1);
		PlayerTextDrawColor(playerid, PlayerNearItemNameDraw[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, PlayerNearItemNameDraw[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, PlayerNearItemNameDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, PlayerNearItemNameDraw[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, PlayerNearItemNameDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, PlayerNearItemNameDraw[playerid][i], 0);
		
		PlayerNearPercentDraw[playerid][i] = CreatePlayerTextDraw(playerid, 42.000000, 97.000000+(i*42), "100%");
		PlayerTextDrawFont(playerid, PlayerNearPercentDraw[playerid][i], 2);
		PlayerTextDrawLetterSize(playerid, PlayerNearPercentDraw[playerid][i], 0.166666, 0.949998);
		PlayerTextDrawTextSize(playerid, PlayerNearPercentDraw[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, PlayerNearPercentDraw[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, PlayerNearPercentDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, PlayerNearPercentDraw[playerid][i], 3);
		PlayerTextDrawColor(playerid, PlayerNearPercentDraw[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, PlayerNearPercentDraw[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, PlayerNearPercentDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, PlayerNearPercentDraw[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, PlayerNearPercentDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, PlayerNearPercentDraw[playerid][i], 0);

		PlayerNearAmountDraw[playerid][i] = CreatePlayerTextDraw(playerid, 103.000000, 79.000000+(i*42), "1");
		PlayerTextDrawFont(playerid, PlayerNearAmountDraw[playerid][i], 2);
		PlayerTextDrawLetterSize(playerid, PlayerNearAmountDraw[playerid][i], 0.333332, 1.649996);
		PlayerTextDrawTextSize(playerid, PlayerNearAmountDraw[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, PlayerNearAmountDraw[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, PlayerNearAmountDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, PlayerNearAmountDraw[playerid][i], 3);
		PlayerTextDrawColor(playerid, PlayerNearAmountDraw[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, PlayerNearAmountDraw[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, PlayerNearAmountDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, PlayerNearAmountDraw[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, PlayerNearAmountDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, PlayerNearAmountDraw[playerid][i], 0);
	}
	///////////////////////////////////////////////////////////////////////////////
	PlayerEquipBackBottonDraw[playerid][0] = CreatePlayerTextDraw(playerid, 235.000000, 63.000000, "mdl-2003:inv_item");//bodyslot0
	PlayerTextDrawFont(playerid, PlayerEquipBackBottonDraw[playerid][0], 4);
	PlayerTextDrawLetterSize(playerid, PlayerEquipBackBottonDraw[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerEquipBackBottonDraw[playerid][0], 36.000000, 41.500000);
	PlayerTextDrawSetOutline(playerid, PlayerEquipBackBottonDraw[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, PlayerEquipBackBottonDraw[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, PlayerEquipBackBottonDraw[playerid][0], 1);
	PlayerTextDrawColor(playerid, PlayerEquipBackBottonDraw[playerid][0], -156);
	PlayerTextDrawBackgroundColor(playerid, PlayerEquipBackBottonDraw[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, PlayerEquipBackBottonDraw[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, PlayerEquipBackBottonDraw[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, PlayerEquipBackBottonDraw[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerEquipBackBottonDraw[playerid][0], 1);

	PlayerEquipBackBottonDraw[playerid][1] = CreatePlayerTextDraw(playerid, 235.000000, 144.000000, "mdl-2003:inv_item");//bodyslot1
	PlayerTextDrawFont(playerid, PlayerEquipBackBottonDraw[playerid][1], 4);
	PlayerTextDrawLetterSize(playerid, PlayerEquipBackBottonDraw[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerEquipBackBottonDraw[playerid][1], 36.000000, 41.500000);
	PlayerTextDrawSetOutline(playerid, PlayerEquipBackBottonDraw[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, PlayerEquipBackBottonDraw[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, PlayerEquipBackBottonDraw[playerid][1], 1);
	PlayerTextDrawColor(playerid, PlayerEquipBackBottonDraw[playerid][1], -156);
	PlayerTextDrawBackgroundColor(playerid, PlayerEquipBackBottonDraw[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, PlayerEquipBackBottonDraw[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, PlayerEquipBackBottonDraw[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, PlayerEquipBackBottonDraw[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerEquipBackBottonDraw[playerid][1], 1);

	PlayerEquipBackBottonDraw[playerid][2] = CreatePlayerTextDraw(playerid, 235.000000, 187.000000, "mdl-2003:inv_item");//bodyslot2
	PlayerTextDrawFont(playerid, PlayerEquipBackBottonDraw[playerid][2], 4);
	PlayerTextDrawLetterSize(playerid, PlayerEquipBackBottonDraw[playerid][2], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerEquipBackBottonDraw[playerid][2], 36.000000, 41.500000);
	PlayerTextDrawSetOutline(playerid, PlayerEquipBackBottonDraw[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, PlayerEquipBackBottonDraw[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, PlayerEquipBackBottonDraw[playerid][2], 1);
	PlayerTextDrawColor(playerid, PlayerEquipBackBottonDraw[playerid][2], -156);
	PlayerTextDrawBackgroundColor(playerid, PlayerEquipBackBottonDraw[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, PlayerEquipBackBottonDraw[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, PlayerEquipBackBottonDraw[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, PlayerEquipBackBottonDraw[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerEquipBackBottonDraw[playerid][2], 1);

	PlayerEquipBackBottonDraw[playerid][3] = CreatePlayerTextDraw(playerid, 235.000000, 230.000000, "mdl-2003:inv_item");//bodyslot3
	PlayerTextDrawFont(playerid, PlayerEquipBackBottonDraw[playerid][3], 4);
	PlayerTextDrawLetterSize(playerid, PlayerEquipBackBottonDraw[playerid][3], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerEquipBackBottonDraw[playerid][3], 36.000000, 41.500000);
	PlayerTextDrawSetOutline(playerid, PlayerEquipBackBottonDraw[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, PlayerEquipBackBottonDraw[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, PlayerEquipBackBottonDraw[playerid][3], 1);
	PlayerTextDrawColor(playerid, PlayerEquipBackBottonDraw[playerid][3], -156);
	PlayerTextDrawBackgroundColor(playerid, PlayerEquipBackBottonDraw[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, PlayerEquipBackBottonDraw[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, PlayerEquipBackBottonDraw[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, PlayerEquipBackBottonDraw[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerEquipBackBottonDraw[playerid][3], 1);

	PlayerEquipBackBottonDraw[playerid][4] = CreatePlayerTextDraw(playerid, 373.000000, 63.000000, "mdl-2003:inv_item");//bodyslot4
	PlayerTextDrawFont(playerid, PlayerEquipBackBottonDraw[playerid][4], 4);
	PlayerTextDrawLetterSize(playerid, PlayerEquipBackBottonDraw[playerid][4], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerEquipBackBottonDraw[playerid][4], 36.000000, 41.500000);
	PlayerTextDrawSetOutline(playerid, PlayerEquipBackBottonDraw[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, PlayerEquipBackBottonDraw[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, PlayerEquipBackBottonDraw[playerid][4], 1);
	PlayerTextDrawColor(playerid, PlayerEquipBackBottonDraw[playerid][4], -156);
	PlayerTextDrawBackgroundColor(playerid, PlayerEquipBackBottonDraw[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, PlayerEquipBackBottonDraw[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, PlayerEquipBackBottonDraw[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, PlayerEquipBackBottonDraw[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerEquipBackBottonDraw[playerid][4], 1);

	PlayerEquipBackBottonDraw[playerid][5] = CreatePlayerTextDraw(playerid, 373.000000, 106.000000, "mdl-2003:inv_item");//bodyslot5
	PlayerTextDrawFont(playerid, PlayerEquipBackBottonDraw[playerid][5], 4);
	PlayerTextDrawLetterSize(playerid, PlayerEquipBackBottonDraw[playerid][5], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerEquipBackBottonDraw[playerid][5], 36.000000, 41.500000);
	PlayerTextDrawSetOutline(playerid, PlayerEquipBackBottonDraw[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, PlayerEquipBackBottonDraw[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, PlayerEquipBackBottonDraw[playerid][5], 1);
	PlayerTextDrawColor(playerid, PlayerEquipBackBottonDraw[playerid][5], -156);
	PlayerTextDrawBackgroundColor(playerid, PlayerEquipBackBottonDraw[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, PlayerEquipBackBottonDraw[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, PlayerEquipBackBottonDraw[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, PlayerEquipBackBottonDraw[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerEquipBackBottonDraw[playerid][5], 1);

/*	PlayerEquipBackBottonDraw[playerid][6] = CreatePlayerTextDraw(playerid, 373.000000, 149.000000, "mdl-2003:inv_item");//bodyslot6
	PlayerTextDrawFont(playerid, PlayerEquipBackBottonDraw[playerid][6], 4);
	PlayerTextDrawLetterSize(playerid, PlayerEquipBackBottonDraw[playerid][6], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerEquipBackBottonDraw[playerid][6], 36.000000, 41.500000);
	PlayerTextDrawSetOutline(playerid, PlayerEquipBackBottonDraw[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, PlayerEquipBackBottonDraw[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, PlayerEquipBackBottonDraw[playerid][6], 1);
	PlayerTextDrawColor(playerid, PlayerEquipBackBottonDraw[playerid][6], -156);
	PlayerTextDrawBackgroundColor(playerid, PlayerEquipBackBottonDraw[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, PlayerEquipBackBottonDraw[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, PlayerEquipBackBottonDraw[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, PlayerEquipBackBottonDraw[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerEquipBackBottonDraw[playerid][6], 1);*/
	
	PlayerEquipItemDraw[playerid][0] = CreatePlayerTextDraw(playerid, 234.000000, 63.000000, "Nowy_TextDraw");
	PlayerTextDrawFont(playerid, PlayerEquipItemDraw[playerid][0], 5);
	PlayerTextDrawLetterSize(playerid, PlayerEquipItemDraw[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerEquipItemDraw[playerid][0], 38.000000, 38.000000);
	PlayerTextDrawSetOutline(playerid, PlayerEquipItemDraw[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, PlayerEquipItemDraw[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, PlayerEquipItemDraw[playerid][0], 1);
	PlayerTextDrawColor(playerid, PlayerEquipItemDraw[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerEquipItemDraw[playerid][0], 0);
	PlayerTextDrawBoxColor(playerid, PlayerEquipItemDraw[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, PlayerEquipItemDraw[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, PlayerEquipItemDraw[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerEquipItemDraw[playerid][0], 0);
	PlayerTextDrawSetPreviewModel(playerid, PlayerEquipItemDraw[playerid][0], -2301);
	PlayerTextDrawSetPreviewRot(playerid, PlayerEquipItemDraw[playerid][0], 0.000000, 0.000000, 0.000000, 0.750000);
	PlayerTextDrawSetPreviewVehCol(playerid, PlayerEquipItemDraw[playerid][0], 1, 1);

	PlayerEquipItemDraw[playerid][1] = CreatePlayerTextDraw(playerid, 234.000000, 144.000000, "Nowy_TextDraw");
	PlayerTextDrawFont(playerid, PlayerEquipItemDraw[playerid][1], 5);
	PlayerTextDrawLetterSize(playerid, PlayerEquipItemDraw[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerEquipItemDraw[playerid][1], 38.000000, 38.000000);
	PlayerTextDrawSetOutline(playerid, PlayerEquipItemDraw[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, PlayerEquipItemDraw[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, PlayerEquipItemDraw[playerid][1], 1);
	PlayerTextDrawColor(playerid, PlayerEquipItemDraw[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerEquipItemDraw[playerid][1], 0);
	PlayerTextDrawBoxColor(playerid, PlayerEquipItemDraw[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, PlayerEquipItemDraw[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, PlayerEquipItemDraw[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerEquipItemDraw[playerid][1], 0);
	PlayerTextDrawSetPreviewModel(playerid, PlayerEquipItemDraw[playerid][1], -2301);
	PlayerTextDrawSetPreviewRot(playerid, PlayerEquipItemDraw[playerid][1], 0.000000, 0.000000, 0.000000, 0.750000);
	PlayerTextDrawSetPreviewVehCol(playerid, PlayerEquipItemDraw[playerid][1], 1, 1);

	PlayerEquipItemDraw[playerid][2] = CreatePlayerTextDraw(playerid, 234.000000, 187.000000, "Nowy_TextDraw");
	PlayerTextDrawFont(playerid, PlayerEquipItemDraw[playerid][2], 5);
	PlayerTextDrawLetterSize(playerid, PlayerEquipItemDraw[playerid][2], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerEquipItemDraw[playerid][2], 38.000000, 38.000000);
	PlayerTextDrawSetOutline(playerid, PlayerEquipItemDraw[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, PlayerEquipItemDraw[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, PlayerEquipItemDraw[playerid][2], 1);
	PlayerTextDrawColor(playerid, PlayerEquipItemDraw[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerEquipItemDraw[playerid][2], 0);
	PlayerTextDrawBoxColor(playerid, PlayerEquipItemDraw[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, PlayerEquipItemDraw[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, PlayerEquipItemDraw[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerEquipItemDraw[playerid][2], 0);
	PlayerTextDrawSetPreviewModel(playerid, PlayerEquipItemDraw[playerid][2], -2301);
	PlayerTextDrawSetPreviewRot(playerid, PlayerEquipItemDraw[playerid][2], 0.000000, 0.000000, 0.000000, 0.750000);
	PlayerTextDrawSetPreviewVehCol(playerid, PlayerEquipItemDraw[playerid][2], 1, 1);

	PlayerEquipItemDraw[playerid][3] = CreatePlayerTextDraw(playerid, 234.000000, 230.000000, "Nowy_TextDraw");
	PlayerTextDrawFont(playerid, PlayerEquipItemDraw[playerid][3], 5);
	PlayerTextDrawLetterSize(playerid, PlayerEquipItemDraw[playerid][3], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerEquipItemDraw[playerid][3], 38.000000, 38.000000);
	PlayerTextDrawSetOutline(playerid, PlayerEquipItemDraw[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, PlayerEquipItemDraw[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, PlayerEquipItemDraw[playerid][3], 1);
	PlayerTextDrawColor(playerid, PlayerEquipItemDraw[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerEquipItemDraw[playerid][3], 0);
	PlayerTextDrawBoxColor(playerid, PlayerEquipItemDraw[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, PlayerEquipItemDraw[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, PlayerEquipItemDraw[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerEquipItemDraw[playerid][3], 0);
	PlayerTextDrawSetPreviewModel(playerid, PlayerEquipItemDraw[playerid][3], -2301);
	PlayerTextDrawSetPreviewRot(playerid, PlayerEquipItemDraw[playerid][3], 0.000000, 0.000000, 0.000000, 0.750000);
	PlayerTextDrawSetPreviewVehCol(playerid, PlayerEquipItemDraw[playerid][3], 1, 1);

	PlayerEquipItemDraw[playerid][4] = CreatePlayerTextDraw(playerid, 372.000000, 63.000000, "Nowy_TextDraw");
	PlayerTextDrawFont(playerid, PlayerEquipItemDraw[playerid][4], 5);
	PlayerTextDrawLetterSize(playerid, PlayerEquipItemDraw[playerid][4], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerEquipItemDraw[playerid][4], 38.000000, 38.000000);
	PlayerTextDrawSetOutline(playerid, PlayerEquipItemDraw[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, PlayerEquipItemDraw[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, PlayerEquipItemDraw[playerid][4], 1);
	PlayerTextDrawColor(playerid, PlayerEquipItemDraw[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerEquipItemDraw[playerid][4], 0);
	PlayerTextDrawBoxColor(playerid, PlayerEquipItemDraw[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, PlayerEquipItemDraw[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, PlayerEquipItemDraw[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerEquipItemDraw[playerid][4], 0);
	PlayerTextDrawSetPreviewModel(playerid, PlayerEquipItemDraw[playerid][4], -2301);
	PlayerTextDrawSetPreviewRot(playerid, PlayerEquipItemDraw[playerid][4], 0.000000, 0.000000, 0.000000, 0.750000);
	PlayerTextDrawSetPreviewVehCol(playerid, PlayerEquipItemDraw[playerid][4], 1, 1);

	PlayerEquipItemDraw[playerid][5] = CreatePlayerTextDraw(playerid, 372.000000, 106.000000, "Nowy_TextDraw");
	PlayerTextDrawFont(playerid, PlayerEquipItemDraw[playerid][5], 5);
	PlayerTextDrawLetterSize(playerid, PlayerEquipItemDraw[playerid][5], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerEquipItemDraw[playerid][5], 38.000000, 38.000000);
	PlayerTextDrawSetOutline(playerid, PlayerEquipItemDraw[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, PlayerEquipItemDraw[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, PlayerEquipItemDraw[playerid][5], 1);
	PlayerTextDrawColor(playerid, PlayerEquipItemDraw[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerEquipItemDraw[playerid][5], 0);
	PlayerTextDrawBoxColor(playerid, PlayerEquipItemDraw[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, PlayerEquipItemDraw[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, PlayerEquipItemDraw[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerEquipItemDraw[playerid][5], 0);
	PlayerTextDrawSetPreviewModel(playerid, PlayerEquipItemDraw[playerid][5], -2301);
	PlayerTextDrawSetPreviewRot(playerid, PlayerEquipItemDraw[playerid][5], 0.000000, 0.000000, 0.000000, 0.750000);
	PlayerTextDrawSetPreviewVehCol(playerid, PlayerEquipItemDraw[playerid][5], 1, 1);

/*	PlayerEquipItemDraw[playerid][6] = CreatePlayerTextDraw(playerid, 372.000000, 149.000000, "Nowy_TextDraw");
	PlayerTextDrawFont(playerid, PlayerEquipItemDraw[playerid][6], 5);
	PlayerTextDrawLetterSize(playerid, PlayerEquipItemDraw[playerid][6], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerEquipItemDraw[playerid][6] ,38.000000, 38.000000);
	PlayerTextDrawSetOutline(playerid, PlayerEquipItemDraw[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, PlayerEquipItemDraw[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, PlayerEquipItemDraw[playerid][6], 1);
	PlayerTextDrawColor(playerid, PlayerEquipItemDraw[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerEquipItemDraw[playerid][6], 0);
	PlayerTextDrawBoxColor(playerid, PlayerEquipItemDraw[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, PlayerEquipItemDraw[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, PlayerEquipItemDraw[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerEquipItemDraw[playerid][6], 0);
	PlayerTextDrawSetPreviewModel(playerid, PlayerEquipItemDraw[playerid][6], -2301);
	PlayerTextDrawSetPreviewRot(playerid,PlayerEquipItemDraw[playerid][6], 0.000000, 0.000000, 0.000000, 0.750000);
	PlayerTextDrawSetPreviewVehCol(playerid, PlayerEquipItemDraw[playerid][6], 1, 1);*/
/************************************************************************************************/
	PlayerEquipPercentDraw[playerid][0] = CreatePlayerTextDraw(playerid, 268.000000, 94.000000, "100%");
	PlayerTextDrawFont(playerid, PlayerEquipPercentDraw[playerid][0], 2);
	PlayerTextDrawLetterSize(playerid, PlayerEquipPercentDraw[playerid][0], 0.166666, 0.949998);
	PlayerTextDrawTextSize(playerid, PlayerEquipPercentDraw[playerid][0], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerEquipPercentDraw[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, PlayerEquipPercentDraw[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, PlayerEquipPercentDraw[playerid][0], 3);
	PlayerTextDrawColor(playerid, PlayerEquipPercentDraw[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerEquipPercentDraw[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, PlayerEquipPercentDraw[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, PlayerEquipPercentDraw[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, PlayerEquipPercentDraw[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerEquipPercentDraw[playerid][0], 0);

	PlayerEquipPercentDraw[playerid][1] = CreatePlayerTextDraw(playerid, 268.000000, 175.000000, "100%");
	PlayerTextDrawFont(playerid, PlayerEquipPercentDraw[playerid][1], 2);
	PlayerTextDrawLetterSize(playerid, PlayerEquipPercentDraw[playerid][1], 0.166666, 0.949998);
	PlayerTextDrawTextSize(playerid, PlayerEquipPercentDraw[playerid][1], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerEquipPercentDraw[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, PlayerEquipPercentDraw[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, PlayerEquipPercentDraw[playerid][1], 3);
	PlayerTextDrawColor(playerid, PlayerEquipPercentDraw[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerEquipPercentDraw[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, PlayerEquipPercentDraw[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, PlayerEquipPercentDraw[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, PlayerEquipPercentDraw[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerEquipPercentDraw[playerid][1], 0);

	PlayerEquipPercentDraw[playerid][2] = CreatePlayerTextDraw(playerid, 268.000000, 218.000000, "100%");
	PlayerTextDrawFont(playerid, PlayerEquipPercentDraw[playerid][2], 2);
	PlayerTextDrawLetterSize(playerid, PlayerEquipPercentDraw[playerid][2], 0.166666, 0.949998);
	PlayerTextDrawTextSize(playerid, PlayerEquipPercentDraw[playerid][2], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerEquipPercentDraw[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, PlayerEquipPercentDraw[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, PlayerEquipPercentDraw[playerid][2], 3);
	PlayerTextDrawColor(playerid, PlayerEquipPercentDraw[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerEquipPercentDraw[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, PlayerEquipPercentDraw[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, PlayerEquipPercentDraw[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, PlayerEquipPercentDraw[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerEquipPercentDraw[playerid][2], 0);

	PlayerEquipPercentDraw[playerid][3] = CreatePlayerTextDraw(playerid, 268.000000, 255.000000, "100%");
	PlayerTextDrawFont(playerid, PlayerEquipPercentDraw[playerid][3], 2);
	PlayerTextDrawLetterSize(playerid, PlayerEquipPercentDraw[playerid][3], 0.166666, 0.949998);
	PlayerTextDrawTextSize(playerid, PlayerEquipPercentDraw[playerid][3], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerEquipPercentDraw[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, PlayerEquipPercentDraw[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, PlayerEquipPercentDraw[playerid][3], 3);
	PlayerTextDrawColor(playerid, PlayerEquipPercentDraw[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerEquipPercentDraw[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, PlayerEquipPercentDraw[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, PlayerEquipPercentDraw[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, PlayerEquipPercentDraw[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerEquipPercentDraw[playerid][3], 0);

	PlayerEquipPercentDraw[playerid][4] = CreatePlayerTextDraw(playerid, 406.000000, 94.000000, "100%");
	PlayerTextDrawFont(playerid, PlayerEquipPercentDraw[playerid][4], 2);
	PlayerTextDrawLetterSize(playerid, PlayerEquipPercentDraw[playerid][4], 0.166666, 0.949998);
	PlayerTextDrawTextSize(playerid, PlayerEquipPercentDraw[playerid][4], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerEquipPercentDraw[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, PlayerEquipPercentDraw[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, PlayerEquipPercentDraw[playerid][4], 3);
	PlayerTextDrawColor(playerid, PlayerEquipPercentDraw[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerEquipPercentDraw[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, PlayerEquipPercentDraw[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, PlayerEquipPercentDraw[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, PlayerEquipPercentDraw[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerEquipPercentDraw[playerid][4], 0);

	PlayerEquipPercentDraw[playerid][5] = CreatePlayerTextDraw(playerid, 406.000000, 137.000000, "100%");
	PlayerTextDrawFont(playerid, PlayerEquipPercentDraw[playerid][5], 2);
	PlayerTextDrawLetterSize(playerid, PlayerEquipPercentDraw[playerid][5], 0.166666, 0.949998);
	PlayerTextDrawTextSize(playerid, PlayerEquipPercentDraw[playerid][5], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerEquipPercentDraw[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, PlayerEquipPercentDraw[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, PlayerEquipPercentDraw[playerid][5], 3);
	PlayerTextDrawColor(playerid, PlayerEquipPercentDraw[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerEquipPercentDraw[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, PlayerEquipPercentDraw[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, PlayerEquipPercentDraw[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, PlayerEquipPercentDraw[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerEquipPercentDraw[playerid][5], 0);

/*	PlayerEquipPercentDraw[playerid][6] = CreatePlayerTextDraw(playerid, 406.000000, 180.000000, "100%");
	PlayerTextDrawFont(playerid, PlayerEquipPercentDraw[playerid][6], 2);
	PlayerTextDrawLetterSize(playerid, PlayerEquipPercentDraw[playerid][6], 0.166666, 0.949998);
	PlayerTextDrawTextSize(playerid, PlayerEquipPercentDraw[playerid][6], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerEquipPercentDraw[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, PlayerEquipPercentDraw[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, PlayerEquipPercentDraw[playerid][6], 3);
	PlayerTextDrawColor(playerid, PlayerEquipPercentDraw[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerEquipPercentDraw[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, PlayerEquipPercentDraw[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, PlayerEquipPercentDraw[playerid][6], 0);
	PlayerTextDrawSetProportional(playerid, PlayerEquipPercentDraw[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerEquipPercentDraw[playerid][6], 0);*/
///////////////////////////////////////////////////////////////////////////////
	PlayerWeaponBackBottonDraw[playerid][0] = CreatePlayerTextDraw(playerid,430.000000, 65.000000, "LD_SPAC:WHITE");//武器0背景按钮
	PlayerTextDrawFont(playerid,PlayerWeaponBackBottonDraw[playerid][0], 4);
	PlayerTextDrawLetterSize(playerid,PlayerWeaponBackBottonDraw[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid,PlayerWeaponBackBottonDraw[playerid][0], 197.500000, 81.500000);
	PlayerTextDrawSetOutline(playerid,PlayerWeaponBackBottonDraw[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid,PlayerWeaponBackBottonDraw[playerid][0], 0);
	PlayerTextDrawAlignment(playerid,PlayerWeaponBackBottonDraw[playerid][0], 1);
	PlayerTextDrawColor(playerid,PlayerWeaponBackBottonDraw[playerid][0], -256);
	PlayerTextDrawBackgroundColor(playerid,PlayerWeaponBackBottonDraw[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid,PlayerWeaponBackBottonDraw[playerid][0], 50);
	PlayerTextDrawUseBox(playerid,PlayerWeaponBackBottonDraw[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid,PlayerWeaponBackBottonDraw[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid,PlayerWeaponBackBottonDraw[playerid][0], 1);

	PlayerWeaponBackBottonDraw[playerid][1] = CreatePlayerTextDraw(playerid,430.000000, 150.000000, "LD_SPAC:WHITE");//武器1背景按钮
	PlayerTextDrawFont(playerid,PlayerWeaponBackBottonDraw[playerid][1], 4);
	PlayerTextDrawLetterSize(playerid,PlayerWeaponBackBottonDraw[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid,PlayerWeaponBackBottonDraw[playerid][1], 197.500000, 81.500000);
	PlayerTextDrawSetOutline(playerid,PlayerWeaponBackBottonDraw[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid,PlayerWeaponBackBottonDraw[playerid][1], 0);
	PlayerTextDrawAlignment(playerid,PlayerWeaponBackBottonDraw[playerid][1], 1);
	PlayerTextDrawColor(playerid,PlayerWeaponBackBottonDraw[playerid][1], -256);
	PlayerTextDrawBackgroundColor(playerid,PlayerWeaponBackBottonDraw[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid,PlayerWeaponBackBottonDraw[playerid][1], 50);
	PlayerTextDrawUseBox(playerid,PlayerWeaponBackBottonDraw[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid,PlayerWeaponBackBottonDraw[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid,PlayerWeaponBackBottonDraw[playerid][1], 1);

	PlayerWeaponBackBottonDraw[playerid][2] = CreatePlayerTextDraw(playerid,430.000000, 235.000000, "LD_SPAC:WHITE");//武器2背景按钮
	PlayerTextDrawFont(playerid,PlayerWeaponBackBottonDraw[playerid][2], 4);
	PlayerTextDrawLetterSize(playerid,PlayerWeaponBackBottonDraw[playerid][2], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid,PlayerWeaponBackBottonDraw[playerid][2], 197.500000, 81.500000);
	PlayerTextDrawSetOutline(playerid,PlayerWeaponBackBottonDraw[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid,PlayerWeaponBackBottonDraw[playerid][2], 0);
	PlayerTextDrawAlignment(playerid,PlayerWeaponBackBottonDraw[playerid][2], 1);
	PlayerTextDrawColor(playerid,PlayerWeaponBackBottonDraw[playerid][2], -256);
	PlayerTextDrawBackgroundColor(playerid,PlayerWeaponBackBottonDraw[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid,PlayerWeaponBackBottonDraw[playerid][2], 50);
	PlayerTextDrawUseBox(playerid,PlayerWeaponBackBottonDraw[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid,PlayerWeaponBackBottonDraw[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid,PlayerWeaponBackBottonDraw[playerid][2], 1);

	PlayerWeaponBackBottonDraw[playerid][3] = CreatePlayerTextDraw(playerid,430.000000, 319.000000, "LD_SPAC:WHITE");//武器3背景按钮
	PlayerTextDrawFont(playerid,PlayerWeaponBackBottonDraw[playerid][3], 4);
	PlayerTextDrawLetterSize(playerid,PlayerWeaponBackBottonDraw[playerid][3], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid,PlayerWeaponBackBottonDraw[playerid][3], 97.000000, 81.500000);
	PlayerTextDrawSetOutline(playerid,PlayerWeaponBackBottonDraw[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid,PlayerWeaponBackBottonDraw[playerid][3], 0);
	PlayerTextDrawAlignment(playerid,PlayerWeaponBackBottonDraw[playerid][3], 1);
	PlayerTextDrawColor(playerid,PlayerWeaponBackBottonDraw[playerid][3], -256);
	PlayerTextDrawBackgroundColor(playerid,PlayerWeaponBackBottonDraw[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid,PlayerWeaponBackBottonDraw[playerid][3], 50);
	PlayerTextDrawUseBox(playerid,PlayerWeaponBackBottonDraw[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid,PlayerWeaponBackBottonDraw[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid,PlayerWeaponBackBottonDraw[playerid][3], 1);

	PlayerWeaponBackBottonDraw[playerid][4] = CreatePlayerTextDraw(playerid,530.000000, 319.000000, "LD_SPAC:WHITE");//武器4背景按钮
	PlayerTextDrawFont(playerid,PlayerWeaponBackBottonDraw[playerid][4], 4);
	PlayerTextDrawLetterSize(playerid,PlayerWeaponBackBottonDraw[playerid][4], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid,PlayerWeaponBackBottonDraw[playerid][4], 97.000000, 81.500000);
	PlayerTextDrawSetOutline(playerid,PlayerWeaponBackBottonDraw[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid,PlayerWeaponBackBottonDraw[playerid][4], 0);
	PlayerTextDrawAlignment(playerid,PlayerWeaponBackBottonDraw[playerid][4], 1);
	PlayerTextDrawColor(playerid,PlayerWeaponBackBottonDraw[playerid][4], -256);
	PlayerTextDrawBackgroundColor(playerid,PlayerWeaponBackBottonDraw[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid,PlayerWeaponBackBottonDraw[playerid][4], 50);
	PlayerTextDrawUseBox(playerid,PlayerWeaponBackBottonDraw[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid,PlayerWeaponBackBottonDraw[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid,PlayerWeaponBackBottonDraw[playerid][4], 1);

	PlayerWeaponItemDraw[playerid][0] = CreatePlayerTextDraw(playerid, 456.000000, 21.000000, "Nowy_TextDraw");
	PlayerTextDrawFont(playerid, PlayerWeaponItemDraw[playerid][0], 5);
	PlayerTextDrawLetterSize(playerid, PlayerWeaponItemDraw[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerWeaponItemDraw[playerid][0], 200.000000, 200.000000);
	PlayerTextDrawSetOutline(playerid, PlayerWeaponItemDraw[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, PlayerWeaponItemDraw[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, PlayerWeaponItemDraw[playerid][0], 1);
	PlayerTextDrawColor(playerid, PlayerWeaponItemDraw[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerWeaponItemDraw[playerid][0], 0);
	PlayerTextDrawBoxColor(playerid, PlayerWeaponItemDraw[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, PlayerWeaponItemDraw[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, PlayerWeaponItemDraw[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerWeaponItemDraw[playerid][0], 0);
	PlayerTextDrawSetPreviewModel(playerid, PlayerWeaponItemDraw[playerid][0], 358);
	PlayerTextDrawSetPreviewRot(playerid, PlayerWeaponItemDraw[playerid][0], 0.000000, 0.000000, 0.000000, 2.389997);
	PlayerTextDrawSetPreviewVehCol(playerid, PlayerWeaponItemDraw[playerid][0], 1, 1);

	PlayerWeaponItemDraw[playerid][1] = CreatePlayerTextDraw(playerid, 456.000000, 101.000000, "Nowy_TextDraw");
	PlayerTextDrawFont(playerid, PlayerWeaponItemDraw[playerid][1], 5);
	PlayerTextDrawLetterSize(playerid, PlayerWeaponItemDraw[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerWeaponItemDraw[playerid][1], 200.000000, 200.000000);
	PlayerTextDrawSetOutline(playerid, PlayerWeaponItemDraw[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, PlayerWeaponItemDraw[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, PlayerWeaponItemDraw[playerid][1], 1);
	PlayerTextDrawColor(playerid, PlayerWeaponItemDraw[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerWeaponItemDraw[playerid][1], 0);
	PlayerTextDrawBoxColor(playerid, PlayerWeaponItemDraw[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, PlayerWeaponItemDraw[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, PlayerWeaponItemDraw[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerWeaponItemDraw[playerid][1], 0);
	PlayerTextDrawSetPreviewModel(playerid, PlayerWeaponItemDraw[playerid][1], 356);
	PlayerTextDrawSetPreviewRot(playerid, PlayerWeaponItemDraw[playerid][1], 0.000000, 0.000000, 0.000000, 2.389997);
	PlayerTextDrawSetPreviewVehCol(playerid, PlayerWeaponItemDraw[playerid][1], 1, 1);

	PlayerWeaponItemDraw[playerid][2] = CreatePlayerTextDraw(playerid, 456.000000, 181.000000, "Nowy_TextDraw");
	PlayerTextDrawFont(playerid, PlayerWeaponItemDraw[playerid][2], 5);
	PlayerTextDrawLetterSize(playerid, PlayerWeaponItemDraw[playerid][2], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerWeaponItemDraw[playerid][2], 200.000000, 200.000000);
	PlayerTextDrawSetOutline(playerid, PlayerWeaponItemDraw[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, PlayerWeaponItemDraw[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, PlayerWeaponItemDraw[playerid][2], 1);
	PlayerTextDrawColor(playerid, PlayerWeaponItemDraw[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerWeaponItemDraw[playerid][2], 0);
	PlayerTextDrawBoxColor(playerid, PlayerWeaponItemDraw[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, PlayerWeaponItemDraw[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, PlayerWeaponItemDraw[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerWeaponItemDraw[playerid][2], 0);
	PlayerTextDrawSetPreviewModel(playerid, PlayerWeaponItemDraw[playerid][2], 353);
	PlayerTextDrawSetPreviewRot(playerid, PlayerWeaponItemDraw[playerid][2], 0.000000, 0.000000, 0.000000, 2.389997);
	PlayerTextDrawSetPreviewVehCol(playerid, PlayerWeaponItemDraw[playerid][2], 1, 1);

	PlayerWeaponItemDraw[playerid][3] = CreatePlayerTextDraw(playerid, 399.000000, 261.000000, "Nowy_TextDraw");
	PlayerTextDrawFont(playerid, PlayerWeaponItemDraw[playerid][3], 5);
	PlayerTextDrawLetterSize(playerid, PlayerWeaponItemDraw[playerid][3], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerWeaponItemDraw[playerid][3], 200.000000, 200.000000);
	PlayerTextDrawSetOutline(playerid, PlayerWeaponItemDraw[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, PlayerWeaponItemDraw[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, PlayerWeaponItemDraw[playerid][3], 1);
	PlayerTextDrawColor(playerid, PlayerWeaponItemDraw[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerWeaponItemDraw[playerid][3], 0);
	PlayerTextDrawBoxColor(playerid, PlayerWeaponItemDraw[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, PlayerWeaponItemDraw[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, PlayerWeaponItemDraw[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerWeaponItemDraw[playerid][3], 0);
	PlayerTextDrawSetPreviewModel(playerid, PlayerWeaponItemDraw[playerid][3], 348);
	PlayerTextDrawSetPreviewRot(playerid, PlayerWeaponItemDraw[playerid][3], 0.000000, 0.000000, 0.000000, 2.389997);
	PlayerTextDrawSetPreviewVehCol(playerid, PlayerWeaponItemDraw[playerid][3], 1, 1);

	PlayerWeaponItemDraw[playerid][4] = CreatePlayerTextDraw(playerid, 491.000000, 261.000000, "Nowy_TextDraw");
	PlayerTextDrawFont(playerid, PlayerWeaponItemDraw[playerid][4], 5);
	PlayerTextDrawLetterSize(playerid, PlayerWeaponItemDraw[playerid][4], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerWeaponItemDraw[playerid][4], 200.000000, 200.000000);
	PlayerTextDrawSetOutline(playerid, PlayerWeaponItemDraw[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, PlayerWeaponItemDraw[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, PlayerWeaponItemDraw[playerid][4], 1);
	PlayerTextDrawColor(playerid, PlayerWeaponItemDraw[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerWeaponItemDraw[playerid][4], 0);
	PlayerTextDrawBoxColor(playerid, PlayerWeaponItemDraw[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, PlayerWeaponItemDraw[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, PlayerWeaponItemDraw[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerWeaponItemDraw[playerid][4], 0);
	PlayerTextDrawSetPreviewModel(playerid, PlayerWeaponItemDraw[playerid][4], 342);
	PlayerTextDrawSetPreviewRot(playerid, PlayerWeaponItemDraw[playerid][4], 0.000000, 0.000000, 0.000000, 2.389997);
	PlayerTextDrawSetPreviewVehCol(playerid, PlayerWeaponItemDraw[playerid][4], 1, 1);
	/****************************************************************************/
	PlayerWeaponPercentDraw[playerid][0] = CreatePlayerTextDraw(playerid, 627.000000, 135.000000, "100%");
	PlayerTextDrawFont(playerid, PlayerWeaponPercentDraw[playerid][0], 2);
	PlayerTextDrawLetterSize(playerid, PlayerWeaponPercentDraw[playerid][0], 0.191661, 1.249997);
	PlayerTextDrawTextSize(playerid, PlayerWeaponPercentDraw[playerid][0], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerWeaponPercentDraw[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, PlayerWeaponPercentDraw[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, PlayerWeaponPercentDraw[playerid][0], 3);
	PlayerTextDrawColor(playerid, PlayerWeaponPercentDraw[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerWeaponPercentDraw[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, PlayerWeaponPercentDraw[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, PlayerWeaponPercentDraw[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, PlayerWeaponPercentDraw[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerWeaponPercentDraw[playerid][0], 0);

	PlayerWeaponPercentDraw[playerid][1] = CreatePlayerTextDraw(playerid, 627.000000, 220.000000, "100%");
	PlayerTextDrawFont(playerid, PlayerWeaponPercentDraw[playerid][1], 2);
	PlayerTextDrawLetterSize(playerid, PlayerWeaponPercentDraw[playerid][1], 0.191661, 1.249997);
	PlayerTextDrawTextSize(playerid, PlayerWeaponPercentDraw[playerid][1], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerWeaponPercentDraw[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, PlayerWeaponPercentDraw[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, PlayerWeaponPercentDraw[playerid][1], 3);
	PlayerTextDrawColor(playerid, PlayerWeaponPercentDraw[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerWeaponPercentDraw[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, PlayerWeaponPercentDraw[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, PlayerWeaponPercentDraw[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, PlayerWeaponPercentDraw[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerWeaponPercentDraw[playerid][1], 0);

	PlayerWeaponPercentDraw[playerid][2] = CreatePlayerTextDraw(playerid, 627.000000, 304.000000, "100%");
	PlayerTextDrawFont(playerid, PlayerWeaponPercentDraw[playerid][2], 2);
	PlayerTextDrawLetterSize(playerid, PlayerWeaponPercentDraw[playerid][2], 0.191661, 1.249997);
	PlayerTextDrawTextSize(playerid, PlayerWeaponPercentDraw[playerid][2], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerWeaponPercentDraw[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, PlayerWeaponPercentDraw[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, PlayerWeaponPercentDraw[playerid][2], 3);
	PlayerTextDrawColor(playerid, PlayerWeaponPercentDraw[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerWeaponPercentDraw[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, PlayerWeaponPercentDraw[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, PlayerWeaponPercentDraw[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, PlayerWeaponPercentDraw[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerWeaponPercentDraw[playerid][2], 0);

	PlayerWeaponPercentDraw[playerid][3] = CreatePlayerTextDraw(playerid, 525.000000, 387.000000, "100%");
	PlayerTextDrawFont(playerid, PlayerWeaponPercentDraw[playerid][3], 2);
	PlayerTextDrawLetterSize(playerid, PlayerWeaponPercentDraw[playerid][3], 0.191661, 1.249997);
	PlayerTextDrawTextSize(playerid, PlayerWeaponPercentDraw[playerid][3], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerWeaponPercentDraw[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, PlayerWeaponPercentDraw[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, PlayerWeaponPercentDraw[playerid][3], 3);
	PlayerTextDrawColor(playerid, PlayerWeaponPercentDraw[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerWeaponPercentDraw[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, PlayerWeaponPercentDraw[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, PlayerWeaponPercentDraw[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, PlayerWeaponPercentDraw[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerWeaponPercentDraw[playerid][3], 0);
	
	PlayerWeaponPercentDraw[playerid][4] = CreatePlayerTextDraw(playerid, 627.000000, 387.000000, "100%");
	PlayerTextDrawFont(playerid, PlayerWeaponPercentDraw[playerid][4], 2);
	PlayerTextDrawLetterSize(playerid, PlayerWeaponPercentDraw[playerid][4], 0.191661, 1.249997);
	PlayerTextDrawTextSize(playerid, PlayerWeaponPercentDraw[playerid][4], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerWeaponPercentDraw[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, PlayerWeaponPercentDraw[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, PlayerWeaponPercentDraw[playerid][4], 3);
	PlayerTextDrawColor(playerid, PlayerWeaponPercentDraw[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerWeaponPercentDraw[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, PlayerWeaponPercentDraw[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, PlayerWeaponPercentDraw[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, PlayerWeaponPercentDraw[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerWeaponPercentDraw[playerid][4], 0);
	/*******************************************************************************/
	PlayerWeaponNameDraw[playerid][0] = CreatePlayerTextDraw(playerid, 446.000000, 61.000000, "mdl-2000:Inv_2");
	PlayerTextDrawFont(playerid, PlayerWeaponNameDraw[playerid][0], 4);
	PlayerTextDrawLetterSize(playerid, PlayerWeaponNameDraw[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerWeaponNameDraw[playerid][0], 55.000000, 23.000000);
	PlayerTextDrawSetOutline(playerid, PlayerWeaponNameDraw[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, PlayerWeaponNameDraw[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, PlayerWeaponNameDraw[playerid][0], 1);
	PlayerTextDrawColor(playerid, PlayerWeaponNameDraw[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerWeaponNameDraw[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, PlayerWeaponNameDraw[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, PlayerWeaponNameDraw[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, PlayerWeaponNameDraw[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerWeaponNameDraw[playerid][0], 0);

	PlayerWeaponNameDraw[playerid][1] = CreatePlayerTextDraw(playerid, 446.000000, 145.000000, "mdl-2000:Inv_2");
	PlayerTextDrawFont(playerid, PlayerWeaponNameDraw[playerid][1], 4);
	PlayerTextDrawLetterSize(playerid, PlayerWeaponNameDraw[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerWeaponNameDraw[playerid][1], 55.000000, 23.000000);
	PlayerTextDrawSetOutline(playerid, PlayerWeaponNameDraw[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, PlayerWeaponNameDraw[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, PlayerWeaponNameDraw[playerid][1], 1);
	PlayerTextDrawColor(playerid, PlayerWeaponNameDraw[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerWeaponNameDraw[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, PlayerWeaponNameDraw[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, PlayerWeaponNameDraw[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, PlayerWeaponNameDraw[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerWeaponNameDraw[playerid][1], 0);

	PlayerWeaponNameDraw[playerid][2] = CreatePlayerTextDraw(playerid, 446.000000, 231.000000, "mdl-2000:Inv_2");
	PlayerTextDrawFont(playerid, PlayerWeaponNameDraw[playerid][2], 4);
	PlayerTextDrawLetterSize(playerid, PlayerWeaponNameDraw[playerid][2], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerWeaponNameDraw[playerid][2], 55.000000, 23.000000);
	PlayerTextDrawSetOutline(playerid, PlayerWeaponNameDraw[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, PlayerWeaponNameDraw[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, PlayerWeaponNameDraw[playerid][2], 1);
	PlayerTextDrawColor(playerid, PlayerWeaponNameDraw[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerWeaponNameDraw[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, PlayerWeaponNameDraw[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, PlayerWeaponNameDraw[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, PlayerWeaponNameDraw[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerWeaponNameDraw[playerid][2], 0);

	PlayerWeaponNameDraw[playerid][3] = CreatePlayerTextDraw(playerid, 446.000000, 316.000000, "mdl-2000:Inv_2");
	PlayerTextDrawFont(playerid, PlayerWeaponNameDraw[playerid][3], 4);
	PlayerTextDrawLetterSize(playerid, PlayerWeaponNameDraw[playerid][3], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerWeaponNameDraw[playerid][3], 55.000000, 23.000000);
	PlayerTextDrawSetOutline(playerid, PlayerWeaponNameDraw[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, PlayerWeaponNameDraw[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, PlayerWeaponNameDraw[playerid][3], 1);
	PlayerTextDrawColor(playerid, PlayerWeaponNameDraw[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerWeaponNameDraw[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, PlayerWeaponNameDraw[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, PlayerWeaponNameDraw[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, PlayerWeaponNameDraw[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerWeaponNameDraw[playerid][3], 0);

	PlayerWeaponNameDraw[playerid][4] = CreatePlayerTextDraw(playerid, 547.000000, 316.000000, "mdl-2000:Inv_2");
	PlayerTextDrawFont(playerid, PlayerWeaponNameDraw[playerid][4], 4);
	PlayerTextDrawLetterSize(playerid, PlayerWeaponNameDraw[playerid][4], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerWeaponNameDraw[playerid][4], 55.000000, 23.000000);
	PlayerTextDrawSetOutline(playerid, PlayerWeaponNameDraw[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, PlayerWeaponNameDraw[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, PlayerWeaponNameDraw[playerid][4], 1);
	PlayerTextDrawColor(playerid, PlayerWeaponNameDraw[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerWeaponNameDraw[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, PlayerWeaponNameDraw[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, PlayerWeaponNameDraw[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, PlayerWeaponNameDraw[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerWeaponNameDraw[playerid][4], 0);
	/***************************************************************/
	PlayerCapacityProgressDraw[playerid] = CreatePlayerTextDraw(playerid, 223.000000, 177.000000, "LD_SPAC:WHITE");
	PlayerTextDrawFont(playerid, PlayerCapacityProgressDraw[playerid], 4);
	PlayerTextDrawLetterSize(playerid, PlayerCapacityProgressDraw[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerCapacityProgressDraw[playerid], 1.000000, 122.000000);
	PlayerTextDrawSetOutline(playerid, PlayerCapacityProgressDraw[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PlayerCapacityProgressDraw[playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerCapacityProgressDraw[playerid], 1);
	PlayerTextDrawColor(playerid, PlayerCapacityProgressDraw[playerid], 1296911786);
	PlayerTextDrawBackgroundColor(playerid, PlayerCapacityProgressDraw[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerCapacityProgressDraw[playerid], 50);
	PlayerTextDrawUseBox(playerid, PlayerCapacityProgressDraw[playerid], 1);
	PlayerTextDrawSetProportional(playerid, PlayerCapacityProgressDraw[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerCapacityProgressDraw[playerid], 0);

	PlayerInvPageDraw[playerid] = CreatePlayerTextDraw(playerid, 205.000000, 52.000000, "1/2");
	PlayerTextDrawFont(playerid, PlayerInvPageDraw[playerid], 2);
	PlayerTextDrawLetterSize(playerid, PlayerInvPageDraw[playerid], 0.145830, 1.099995);
	PlayerTextDrawTextSize(playerid, PlayerInvPageDraw[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerInvPageDraw[playerid], 0);
	PlayerTextDrawSetShadow(playerid, PlayerInvPageDraw[playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerInvPageDraw[playerid], 2);
	PlayerTextDrawColor(playerid, PlayerInvPageDraw[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerInvPageDraw[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerInvPageDraw[playerid], 50);
	PlayerTextDrawUseBox(playerid, PlayerInvPageDraw[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PlayerInvPageDraw[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerInvPageDraw[playerid], 0);

	PlayerNearPageDraw[playerid] = CreatePlayerTextDraw(playerid, 97.000000, 52.000000, "1/2");
	PlayerTextDrawFont(playerid, PlayerNearPageDraw[playerid], 2);
	PlayerTextDrawLetterSize(playerid, PlayerNearPageDraw[playerid], 0.145830, 1.099995);
	PlayerTextDrawTextSize(playerid, PlayerNearPageDraw[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerNearPageDraw[playerid], 0);
	PlayerTextDrawSetShadow(playerid, PlayerNearPageDraw[playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerNearPageDraw[playerid], 2);
	PlayerTextDrawColor(playerid, PlayerNearPageDraw[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerNearPageDraw[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerNearPageDraw[playerid], 50);
	PlayerTextDrawUseBox(playerid, PlayerNearPageDraw[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PlayerNearPageDraw[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerNearPageDraw[playerid], 0);
	return 1;
}
FUNC::Inv_OnPlayerDisconnect(playerid)
{
    forex(i,MAX_PLAYER_ZOMBIE_TEXTDRAWS)
    {
        if(PlayerZombieBagBackDraws[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerZombieBagBackDraws[playerid][i]);
		PlayerZombieBagBackDraws[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(PlayerZombieBagModelDraws[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerZombieBagModelDraws[playerid][i]);
		PlayerZombieBagModelDraws[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(PlayerZombieBagNameDraws[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerZombieBagNameDraws[playerid][i]);
		PlayerZombieBagNameDraws[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(PlayerZombieBagAmountDraws[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerZombieBagAmountDraws[playerid][i]);
		PlayerZombieBagAmountDraws[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(PlayerZombieBagPercentDraws[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerZombieBagPercentDraws[playerid][i]);
		PlayerZombieBagPercentDraws[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
    }
	if(PlayerZombieBagPageDraws[playerid]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerZombieBagPageDraws[playerid]);
    PlayerZombieBagPageDraws[playerid]=PlayerText:INVALID_TEXT_DRAW;

    forex(i,MAX_PLAYERINV_SHOW_LIST)
    {
		if(PlayerInvBackBottonDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerInvBackBottonDraw[playerid][i]);
		PlayerInvBackBottonDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(PlayerInvItemDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerInvItemDraw[playerid][i]);
		PlayerInvItemDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(PlayerInvItemNameDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerInvItemNameDraw[playerid][i]);
		PlayerInvItemNameDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(PlayerInvPercentDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerInvPercentDraw[playerid][i]);
		PlayerInvPercentDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(PlayerInvAmountDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerInvAmountDraw[playerid][i]);
		PlayerInvAmountDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;

		if(PlayerNearBackBottonDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerNearBackBottonDraw[playerid][i]);
		PlayerNearBackBottonDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(PlayerNearItemDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerNearItemDraw[playerid][i]);
		PlayerNearItemDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(PlayerNearItemNameDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerNearItemNameDraw[playerid][i]);
		PlayerNearItemNameDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(PlayerNearPercentDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerNearPercentDraw[playerid][i]);
		PlayerNearPercentDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(PlayerNearAmountDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerNearAmountDraw[playerid][i]);
		PlayerNearAmountDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
    }
    forex(i,MAX_PLAYER_EQUIPS)
    {
		if(PlayerEquipItemDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerEquipItemDraw[playerid][i]);
		PlayerEquipItemDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(PlayerEquipPercentDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerEquipPercentDraw[playerid][i]);
		PlayerEquipPercentDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(PlayerEquipBackBottonDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerEquipBackBottonDraw[playerid][i]);
        PlayerEquipBackBottonDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
	}
	forex(i,MAX_PLAYER_WEAPONS)
	{
		if(PlayerWeaponItemDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerWeaponItemDraw[playerid][i]);
		PlayerWeaponItemDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(PlayerWeaponPercentDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerWeaponPercentDraw[playerid][i]);
		PlayerWeaponPercentDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(PlayerWeaponNameDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerWeaponNameDraw[playerid][i]);
		PlayerWeaponNameDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
	}
	if(PlayerCapacityProgressDraw[playerid]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerCapacityProgressDraw[playerid]);
	PlayerCapacityProgressDraw[playerid]=PlayerText:INVALID_TEXT_DRAW;
	if(PlayerNearPageDraw[playerid]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerNearPageDraw[playerid]);
	PlayerNearPageDraw[playerid]=PlayerText:INVALID_TEXT_DRAW;
	if(PlayerInvPageDraw[playerid]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PlayerInvPageDraw[playerid]);
	PlayerInvPageDraw[playerid]=PlayerText:INVALID_TEXT_DRAW;
	return 1;
}
FUNC::ShowPlayerInventoryTextDraw(playerid)
{
    HidePlayerPresonStateTextDraw(playerid);
    HidePlayerNavigationBarTextDraw(playerid);
    HideWeaponHudTextDrawForPlayer(playerid);
    HidePlayerSpeedo(playerid);
    HidePlayerStrongBoxTextDraw(playerid);
	TogglePlayerControllable(playerid, 0);
	new Float:xyz[4][2],Float:Angles;
	if(!IsPlayerInAnyVehicle(playerid))
	{
		GetPlayerPos(playerid, xyz[0][0], xyz[1][0], xyz[2][0]);
		GetPlayerPos(playerid, xyz[0][1], xyz[1][1], xyz[2][1]);
		GetPlayerFacingAngle(playerid,Angles);
		GetPointInFront2D(xyz[0][0], xyz[1][0],Angles,3.0,xyz[0][0], xyz[1][0]);
		//GetPointInFrontOfPlayer(playerid,xyz[0][0], xyz[1][0],3.0);
		SetPlayerCameraPos(playerid,xyz[0][0], xyz[1][0],xyz[2][0]-0.1);
		SetPlayerCameraLookAt(playerid,xyz[0][1], xyz[1][1], xyz[2][1]-0.1,CAMERA_CUT);
	}
	else
	{
		new vid=GetPlayerVehicleID(playerid);
		GetVehiclePos(vid, xyz[0][0], xyz[1][0], xyz[2][0]);
		GetVehiclePos(vid, xyz[0][1], xyz[1][1], xyz[2][1]);
		GetVehicleZAngle(vid,Angles);
		GetPointInFront2D(xyz[0][0], xyz[1][0],Angles,5.0,xyz[0][0], xyz[1][0]);
	    //GetPointInFrontOfVehicle2D(vid,xyz[0][0], xyz[1][0],5.0);
		SetPlayerCameraPos(playerid,xyz[0][0], xyz[1][0],xyz[2][0]+0.3);
		SetPlayerCameraLookAt(playerid,xyz[0][1], xyz[1][1], xyz[2][1]+0.3,CAMERA_CUT);
	}
	forex(i,sizeof(InventoryTextDraw))TextDrawShowForPlayer(playerid,InventoryTextDraw[i]);
	UpdatePlayerInvPage(playerid,1,PlayerInvPrevieSortType[playerid]);
	UpdatePlayerNearPage(playerid,1);
	UpdatePlayerEquip(playerid);
	UpdatePlayerWeapon(playerid);
	PlayerTextDrawShow(playerid, PlayerNearPageDraw[playerid]);

	InventoryTextDrawShow[playerid]=true;
	SelectTextDrawEx(playerid,0x408080C8);
	return 1;
}
FUNC::HidePlayerInventoryTextDraw(playerid)
{
	forex(i,MAX_PLAYERINV_SHOW_LIST)
	{
		PlayerTextDrawHide(playerid, PlayerInvBackBottonDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerInvItemDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerInvItemNameDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerInvPercentDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerInvAmountDraw[playerid][i]);

		PlayerTextDrawHide(playerid, PlayerNearBackBottonDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerNearItemDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerNearItemNameDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerNearPercentDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerNearAmountDraw[playerid][i]);
	}
	forex(i,MAX_PLAYER_EQUIPS)
	{
		PlayerTextDrawHide(playerid, PlayerEquipItemDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerEquipPercentDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerEquipBackBottonDraw[playerid][i]);
	}
	forex(i,5)
	{
		PlayerTextDrawHide(playerid, PlayerWeaponItemDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerWeaponPercentDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerWeaponNameDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerWeaponBackBottonDraw[playerid][i]);
	}
	PlayerTextDrawHide(playerid, PlayerCapacityProgressDraw[playerid]);
	PlayerTextDrawHide(playerid, PlayerNearPageDraw[playerid]);
	PlayerTextDrawHide(playerid, PlayerInvPageDraw[playerid]);

	forex(i,sizeof(InventoryTextDraw))TextDrawHideForPlayer(playerid,InventoryTextDraw[i]);
	InventoryTextDrawShow[playerid]=false;
	TogglePlayerControllable(playerid, 1);
	SetCameraBehindPlayer(playerid);
 	ShowPlayerPresonStateTextDraw(playerid);
  	if(IsPlayerInAnyVehicle(playerid))ShowPlayerSpeedo(playerid);
  	OnPlayerWeaponChange(playerid,GetPlayerWeapon(playerid),GetPlayerWeapon(playerid));
	return 1;
}
FUNC::Inv_OnGameModeInit()
{
	forex(i,MAX_PLAYERS)
	{
	    forex(s,MAX_PLAYER_ZOMBIE_TEXTDRAWS)
	    {
			PlayerZombieBagBackDraws[i][s]=PlayerText:INVALID_TEXT_DRAW;
			PlayerZombieBagModelDraws[i][s]=PlayerText:INVALID_TEXT_DRAW;
			PlayerZombieBagNameDraws[i][s]=PlayerText:INVALID_TEXT_DRAW;
			PlayerZombieBagAmountDraws[i][s]=PlayerText:INVALID_TEXT_DRAW;
			PlayerZombieBagPercentDraws[i][s]=PlayerText:INVALID_TEXT_DRAW;
	    }
	    PlayerZombieBagPageDraws[i]=PlayerText:INVALID_TEXT_DRAW;
	    
	    forex(s,MAX_PLAYERINV_SHOW_LIST)
	    {
			PlayerInvBackBottonDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			PlayerInvItemDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			PlayerInvItemNameDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			PlayerInvPercentDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			PlayerInvAmountDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			PlayerNearBackBottonDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			PlayerNearItemDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			PlayerNearItemNameDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			PlayerNearPercentDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			PlayerNearAmountDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
	    }
	    forex(s,MAX_PLAYER_EQUIPS)
	    {
			PlayerEquipItemDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			PlayerEquipPercentDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			PlayerEquipBackBottonDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
		}
		forex(s,MAX_PLAYER_WEAPONS)
		{
			PlayerWeaponItemDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			PlayerWeaponPercentDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			PlayerWeaponNameDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			PlayerWeaponBackBottonDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
		}
		PlayerCapacityProgressDraw[i]=PlayerText:INVALID_TEXT_DRAW;
		PlayerNearPageDraw[i]=PlayerText:INVALID_TEXT_DRAW;
		PlayerInvPageDraw[i]=PlayerText:INVALID_TEXT_DRAW;
	}

	InventoryTextDraw[0] = TextDrawCreate(-3.000000, -1.000000, "mdl-2003:glass");//背景
	TextDrawFont(InventoryTextDraw[0], 4);
	TextDrawLetterSize(InventoryTextDraw[0], 0.600000, 2.000000);
	TextDrawTextSize(InventoryTextDraw[0], 649.000000, 452.000000);
	TextDrawSetOutline(InventoryTextDraw[0], 1);
	TextDrawSetShadow(InventoryTextDraw[0], 0);
	TextDrawAlignment(InventoryTextDraw[0], 1);
	TextDrawColor(InventoryTextDraw[0], -186);
	TextDrawBackgroundColor(InventoryTextDraw[0], 255);
	TextDrawBoxColor(InventoryTextDraw[0], 50);
	TextDrawUseBox(InventoryTextDraw[0], 1);
	TextDrawSetProportional(InventoryTextDraw[0], 1);
	TextDrawSetSelectable(InventoryTextDraw[0], 0);

	InventoryTextDraw[1] = TextDrawCreate(5.000000, 2.000000, "mdl-2000:inv_near");//附近文字
	TextDrawFont(InventoryTextDraw[1], 4);
	TextDrawLetterSize(InventoryTextDraw[1], 0.600000, 2.000000);
	TextDrawTextSize(InventoryTextDraw[1], 133.500000, 41.500000);
	TextDrawSetOutline(InventoryTextDraw[1], 1);
	TextDrawSetShadow(InventoryTextDraw[1], 0);
	TextDrawAlignment(InventoryTextDraw[1], 1);
	TextDrawColor(InventoryTextDraw[1], -1);
	TextDrawBackgroundColor(InventoryTextDraw[1], 255);
	TextDrawBoxColor(InventoryTextDraw[1], 50);
	TextDrawUseBox(InventoryTextDraw[1], 1);
	TextDrawSetProportional(InventoryTextDraw[1], 1);
	TextDrawSetSelectable(InventoryTextDraw[1], 0);

	InventoryTextDraw[2] = TextDrawCreate(8.000000, 40.000000, "mdl-2000:inv_ground");//地面文字
	TextDrawFont(InventoryTextDraw[2], 4);
	TextDrawLetterSize(InventoryTextDraw[2], 0.600000, 2.000000);
	TextDrawTextSize(InventoryTextDraw[2], 73.000000, 26.000000);
	TextDrawSetOutline(InventoryTextDraw[2], 1);
	TextDrawSetShadow(InventoryTextDraw[2], 0);
	TextDrawAlignment(InventoryTextDraw[2], 1);
	TextDrawColor(InventoryTextDraw[2], -1);
	TextDrawBackgroundColor(InventoryTextDraw[2], 255);
	TextDrawBoxColor(InventoryTextDraw[2], 50);
	TextDrawUseBox(InventoryTextDraw[2], 1);
	TextDrawSetProportional(InventoryTextDraw[2], 1);
	TextDrawSetSelectable(InventoryTextDraw[2], 0);

	InventoryTextDraw[3] = TextDrawCreate(115.000000, 65.000000, "LD_SPAC:WHITE");//线条1
	TextDrawFont(InventoryTextDraw[3], 4);
	TextDrawLetterSize(InventoryTextDraw[3], 0.600000, 2.000000);
	TextDrawTextSize(InventoryTextDraw[3], 0.500000, 335.000000);
	TextDrawSetOutline(InventoryTextDraw[3], 1);
	TextDrawSetShadow(InventoryTextDraw[3], 0);
	TextDrawAlignment(InventoryTextDraw[3], 1);
	TextDrawColor(InventoryTextDraw[3], -156);
	TextDrawBackgroundColor(InventoryTextDraw[3], 255);
	TextDrawBoxColor(InventoryTextDraw[3], 50);
	TextDrawUseBox(InventoryTextDraw[3], 1);
	TextDrawSetProportional(InventoryTextDraw[3], 1);
	TextDrawSetSelectable(InventoryTextDraw[3], 0);

	InventoryTextDraw[4] = TextDrawCreate(222.000000, 176.000000, "LD_SPAC:WHITE");//线条2
	TextDrawFont(InventoryTextDraw[4], 4);
	TextDrawLetterSize(InventoryTextDraw[4], 0.600000, 2.000000);
	TextDrawTextSize(InventoryTextDraw[4], 3.000000, 124.000000);
	TextDrawSetOutline(InventoryTextDraw[4], 1);
	TextDrawSetShadow(InventoryTextDraw[4], 0);
	TextDrawAlignment(InventoryTextDraw[4], 1);
	TextDrawColor(InventoryTextDraw[4], -86);
	TextDrawBackgroundColor(InventoryTextDraw[4], 255);
	TextDrawBoxColor(InventoryTextDraw[4], 50);
	TextDrawUseBox(InventoryTextDraw[4], 1);
	TextDrawSetProportional(InventoryTextDraw[4], 1);
	TextDrawSetSelectable(InventoryTextDraw[4], 0);

	InventoryTextDraw[5] = TextDrawCreate(114.000000, 46.000000, "mdl-2000:inv_sort");//排序方式文字
	TextDrawFont(InventoryTextDraw[5], 4);
	TextDrawLetterSize(InventoryTextDraw[5], 0.600000, 2.000000);
	TextDrawTextSize(InventoryTextDraw[5], 43.500000, 19.500000);
	TextDrawSetOutline(InventoryTextDraw[5], 1);
	TextDrawSetShadow(InventoryTextDraw[5], 0);
	TextDrawAlignment(InventoryTextDraw[5], 1);
	TextDrawColor(InventoryTextDraw[5], -1);
	TextDrawBackgroundColor(InventoryTextDraw[5], 255);
	TextDrawBoxColor(InventoryTextDraw[5], 50);
	TextDrawUseBox(InventoryTextDraw[5], 1);
	TextDrawSetProportional(InventoryTextDraw[5], 1);
	TextDrawSetSelectable(InventoryTextDraw[5], 0);

	InventoryTextDraw[6] = TextDrawCreate(151.000000, 50.000000, "LD_SPAC:WHITE");//类型选项背景
	TextDrawFont(InventoryTextDraw[6], 4);
	TextDrawLetterSize(InventoryTextDraw[6], 0.600000, 2.000000);
	TextDrawTextSize(InventoryTextDraw[6], 18.500000, 13.000000);
	TextDrawSetOutline(InventoryTextDraw[6], 1);
	TextDrawSetShadow(InventoryTextDraw[6], 0);
	TextDrawAlignment(InventoryTextDraw[6], 1);
	TextDrawColor(InventoryTextDraw[6], -156);
	TextDrawBackgroundColor(InventoryTextDraw[6], 255);
	TextDrawBoxColor(InventoryTextDraw[6], 50);
	TextDrawUseBox(InventoryTextDraw[6], 1);
	TextDrawSetProportional(InventoryTextDraw[6], 1);
	TextDrawSetSelectable(InventoryTextDraw[6], 1);

	InventoryTextDraw[7] = TextDrawCreate(170.000000, 50.000000, "LD_SPAC:WHITE");//时间选项背景
	TextDrawFont(InventoryTextDraw[7], 4);
	TextDrawLetterSize(InventoryTextDraw[7], 0.600000, 2.000000);
	TextDrawTextSize(InventoryTextDraw[7], 18.500000, 13.000000);
	TextDrawSetOutline(InventoryTextDraw[7], 1);
	TextDrawSetShadow(InventoryTextDraw[7], 0);
	TextDrawAlignment(InventoryTextDraw[7], 1);
	TextDrawColor(InventoryTextDraw[7], -156);
	TextDrawBackgroundColor(InventoryTextDraw[7], 255);
	TextDrawBoxColor(InventoryTextDraw[7], 50);
	TextDrawUseBox(InventoryTextDraw[7], 1);
	TextDrawSetProportional(InventoryTextDraw[7], 1);
	TextDrawSetSelectable(InventoryTextDraw[7], 1);

	InventoryTextDraw[8] = TextDrawCreate(151.000000, 46.000000, "mdl-2000:inv_type");//类型选项文字
	TextDrawFont(InventoryTextDraw[8], 4);
	TextDrawLetterSize(InventoryTextDraw[8], 0.600000, 2.000000);
	TextDrawTextSize(InventoryTextDraw[8], 43.500000, 19.500000);
	TextDrawSetOutline(InventoryTextDraw[8], 1);
	TextDrawSetShadow(InventoryTextDraw[8], 0);
	TextDrawAlignment(InventoryTextDraw[8], 1);
	TextDrawColor(InventoryTextDraw[8], -1);
	TextDrawBackgroundColor(InventoryTextDraw[8], 255);
	TextDrawBoxColor(InventoryTextDraw[8], 50);
	TextDrawUseBox(InventoryTextDraw[8], 1);
	TextDrawSetProportional(InventoryTextDraw[8], 1);
	TextDrawSetSelectable(InventoryTextDraw[8], 0);

	InventoryTextDraw[9] = TextDrawCreate(170.000000, 46.000000, "mdl-2000:inv_time");//时间选项文字
	TextDrawFont(InventoryTextDraw[9], 4);
	TextDrawLetterSize(InventoryTextDraw[9], 0.600000, 2.000000);
	TextDrawTextSize(InventoryTextDraw[9], 43.500000, 19.500000);
	TextDrawSetOutline(InventoryTextDraw[9], 1);
	TextDrawSetShadow(InventoryTextDraw[9], 0);
	TextDrawAlignment(InventoryTextDraw[9], 1);
	TextDrawColor(InventoryTextDraw[9], -1);
	TextDrawBackgroundColor(InventoryTextDraw[9], 255);
	TextDrawBoxColor(InventoryTextDraw[9], 50);
	TextDrawUseBox(InventoryTextDraw[9], 1);
	TextDrawSetProportional(InventoryTextDraw[9], 1);
	TextDrawSetSelectable(InventoryTextDraw[9], 0);

	InventoryTextDraw[10] = TextDrawCreate(430.000000, 148.000000, "LD_SPAC:WHITE");//线条3
	TextDrawFont(InventoryTextDraw[10], 4);
	TextDrawLetterSize(InventoryTextDraw[10], 0.600000, 2.000000);
	TextDrawTextSize(InventoryTextDraw[10], 197.500000, 0.500000);
	TextDrawSetOutline(InventoryTextDraw[10], 1);
	TextDrawSetShadow(InventoryTextDraw[10], 0);
	TextDrawAlignment(InventoryTextDraw[10], 1);
	TextDrawColor(InventoryTextDraw[10], -56);
	TextDrawBackgroundColor(InventoryTextDraw[10], 255);
	TextDrawBoxColor(InventoryTextDraw[10], 50);
	TextDrawUseBox(InventoryTextDraw[10], 1);
	TextDrawSetProportional(InventoryTextDraw[10], 1);
	TextDrawSetSelectable(InventoryTextDraw[10], 0);

	InventoryTextDraw[11] = TextDrawCreate(429.000000, 64.000000, "mdl-2003:inv_item");//武器数字背景0
	TextDrawFont(InventoryTextDraw[11], 4);
	TextDrawLetterSize(InventoryTextDraw[11], 0.600000, 2.000000);
	TextDrawTextSize(InventoryTextDraw[11], 15.000000, 18.000000);
	TextDrawSetOutline(InventoryTextDraw[11], 1);
	TextDrawSetShadow(InventoryTextDraw[11], 0);
	TextDrawAlignment(InventoryTextDraw[11], 1);
	TextDrawColor(InventoryTextDraw[11], -56);
	TextDrawBackgroundColor(InventoryTextDraw[11], 255);
	TextDrawBoxColor(InventoryTextDraw[11], 50);
	TextDrawUseBox(InventoryTextDraw[11], 1);
	TextDrawSetProportional(InventoryTextDraw[11], 1);
	TextDrawSetSelectable(InventoryTextDraw[11], 0);

	InventoryTextDraw[12] = TextDrawCreate(429.000000, 149.000000, "mdl-2003:inv_item");//武器数字背景1
	TextDrawFont(InventoryTextDraw[12], 4);
	TextDrawLetterSize(InventoryTextDraw[12], 0.600000, 2.000000);
	TextDrawTextSize(InventoryTextDraw[12], 15.000000, 18.000000);
	TextDrawSetOutline(InventoryTextDraw[12], 1);
	TextDrawSetShadow(InventoryTextDraw[12], 0);
	TextDrawAlignment(InventoryTextDraw[12], 1);
	TextDrawColor(InventoryTextDraw[12], -56);
	TextDrawBackgroundColor(InventoryTextDraw[12], 255);
	TextDrawBoxColor(InventoryTextDraw[12], 50);
	TextDrawUseBox(InventoryTextDraw[12], 1);
	TextDrawSetProportional(InventoryTextDraw[12], 1);
	TextDrawSetSelectable(InventoryTextDraw[12], 0);

	InventoryTextDraw[13] = TextDrawCreate(429.000000, 234.000000, "mdl-2003:inv_item");//武器数字背景2
	TextDrawFont(InventoryTextDraw[13], 4);
	TextDrawLetterSize(InventoryTextDraw[13], 0.600000, 2.000000);
	TextDrawTextSize(InventoryTextDraw[13], 15.000000, 18.000000);
	TextDrawSetOutline(InventoryTextDraw[13], 1);
	TextDrawSetShadow(InventoryTextDraw[13], 0);
	TextDrawAlignment(InventoryTextDraw[13], 1);
	TextDrawColor(InventoryTextDraw[13], -56);
	TextDrawBackgroundColor(InventoryTextDraw[13], 255);
	TextDrawBoxColor(InventoryTextDraw[13], 50);
	TextDrawUseBox(InventoryTextDraw[13], 1);
	TextDrawSetProportional(InventoryTextDraw[13], 1);
	TextDrawSetSelectable(InventoryTextDraw[13], 0);

	InventoryTextDraw[14] = TextDrawCreate(429.000000, 319.000000, "mdl-2003:inv_item");//武器数字背景3
	TextDrawFont(InventoryTextDraw[14], 4);
	TextDrawLetterSize(InventoryTextDraw[14], 0.600000, 2.000000);
	TextDrawTextSize(InventoryTextDraw[14], 15.000000, 18.000000);
	TextDrawSetOutline(InventoryTextDraw[14], 1);
	TextDrawSetShadow(InventoryTextDraw[14], 0);
	TextDrawAlignment(InventoryTextDraw[14], 1);
	TextDrawColor(InventoryTextDraw[14], -56);
	TextDrawBackgroundColor(InventoryTextDraw[14], 255);
	TextDrawBoxColor(InventoryTextDraw[14], 50);
	TextDrawUseBox(InventoryTextDraw[14], 1);
	TextDrawSetProportional(InventoryTextDraw[14], 1);
	TextDrawSetSelectable(InventoryTextDraw[14], 0);

	InventoryTextDraw[15] = TextDrawCreate(529.000000, 319.000000, "mdl-2003:inv_item");//武器数字背景4
	TextDrawFont(InventoryTextDraw[15], 4);
	TextDrawLetterSize(InventoryTextDraw[15], 0.600000, 2.000000);
	TextDrawTextSize(InventoryTextDraw[15], 15.000000, 18.000000);
	TextDrawSetOutline(InventoryTextDraw[15], 1);
	TextDrawSetShadow(InventoryTextDraw[15], 0);
	TextDrawAlignment(InventoryTextDraw[15], 1);
	TextDrawColor(InventoryTextDraw[15], -56);
	TextDrawBackgroundColor(InventoryTextDraw[15], 255);
	TextDrawBoxColor(InventoryTextDraw[15], 50);
	TextDrawUseBox(InventoryTextDraw[15], 1);
	TextDrawSetProportional(InventoryTextDraw[15], 1);
	TextDrawSetSelectable(InventoryTextDraw[15], 0);

	InventoryTextDraw[16] = TextDrawCreate(437.000000, 64.000000, "1");//武器数字0
	TextDrawFont(InventoryTextDraw[16], 2);
	TextDrawLetterSize(InventoryTextDraw[16], 0.383332, 1.899996);
	TextDrawTextSize(InventoryTextDraw[16], 400.000000, 17.000000);
	TextDrawSetOutline(InventoryTextDraw[16], 0);
	TextDrawSetShadow(InventoryTextDraw[16], 0);
	TextDrawAlignment(InventoryTextDraw[16], 2);
	TextDrawColor(InventoryTextDraw[16], -1);
	TextDrawBackgroundColor(InventoryTextDraw[16], 255);
	TextDrawBoxColor(InventoryTextDraw[16], 50);
	TextDrawUseBox(InventoryTextDraw[16], 0);
	TextDrawSetProportional(InventoryTextDraw[16], 1);
	TextDrawSetSelectable(InventoryTextDraw[16], 0);

	InventoryTextDraw[17] = TextDrawCreate(437.000000, 148.000000, "2");//武器数字1
	TextDrawFont(InventoryTextDraw[17], 2);
	TextDrawLetterSize(InventoryTextDraw[17], 0.383332, 1.899996);
	TextDrawTextSize(InventoryTextDraw[17], 400.000000, 17.000000);
	TextDrawSetOutline(InventoryTextDraw[17], 0);
	TextDrawSetShadow(InventoryTextDraw[17], 0);
	TextDrawAlignment(InventoryTextDraw[17], 2);
	TextDrawColor(InventoryTextDraw[17], -1);
	TextDrawBackgroundColor(InventoryTextDraw[17], 255);
	TextDrawBoxColor(InventoryTextDraw[17], 50);
	TextDrawUseBox(InventoryTextDraw[17], 0);
	TextDrawSetProportional(InventoryTextDraw[17], 1);
	TextDrawSetSelectable(InventoryTextDraw[17], 0);

	InventoryTextDraw[18] = TextDrawCreate(437.000000, 233.000000, "3");//武器数字2
	TextDrawFont(InventoryTextDraw[18], 2);
	TextDrawLetterSize(InventoryTextDraw[18], 0.383332, 1.899996);
	TextDrawTextSize(InventoryTextDraw[18], 400.000000, 17.000000);
	TextDrawSetOutline(InventoryTextDraw[18], 0);
	TextDrawSetShadow(InventoryTextDraw[18], 0);
	TextDrawAlignment(InventoryTextDraw[18], 2);
	TextDrawColor(InventoryTextDraw[18], -1);
	TextDrawBackgroundColor(InventoryTextDraw[18], 255);
	TextDrawBoxColor(InventoryTextDraw[18], 50);
	TextDrawUseBox(InventoryTextDraw[18], 0);
	TextDrawSetProportional(InventoryTextDraw[18], 1);
	TextDrawSetSelectable(InventoryTextDraw[18], 0);

	InventoryTextDraw[19] = TextDrawCreate(437.000000, 318.000000, "4");//武器数字3
	TextDrawFont(InventoryTextDraw[19], 2);
	TextDrawLetterSize(InventoryTextDraw[19], 0.383332, 1.899996);
	TextDrawTextSize(InventoryTextDraw[19], 400.000000, 17.000000);
	TextDrawSetOutline(InventoryTextDraw[19], 0);
	TextDrawSetShadow(InventoryTextDraw[19], 0);
	TextDrawAlignment(InventoryTextDraw[19], 2);
	TextDrawColor(InventoryTextDraw[19], -1);
	TextDrawBackgroundColor(InventoryTextDraw[19], 255);
	TextDrawBoxColor(InventoryTextDraw[19], 50);
	TextDrawUseBox(InventoryTextDraw[19], 0);
	TextDrawSetProportional(InventoryTextDraw[19], 1);
	TextDrawSetSelectable(InventoryTextDraw[19], 0);

	InventoryTextDraw[20] = TextDrawCreate(537.000000, 318.000000, "5");//武器数字4
	TextDrawFont(InventoryTextDraw[20], 2);
	TextDrawLetterSize(InventoryTextDraw[20], 0.383332, 1.899996);
	TextDrawTextSize(InventoryTextDraw[20], 400.000000, 17.000000);
	TextDrawSetOutline(InventoryTextDraw[20], 0);
	TextDrawSetShadow(InventoryTextDraw[20], 0);
	TextDrawAlignment(InventoryTextDraw[20], 2);
	TextDrawColor(InventoryTextDraw[20], -1);
	TextDrawBackgroundColor(InventoryTextDraw[20], 255);
	TextDrawBoxColor(InventoryTextDraw[20], 50);
	TextDrawUseBox(InventoryTextDraw[20], 0);
	TextDrawSetProportional(InventoryTextDraw[20], 1);
	TextDrawSetSelectable(InventoryTextDraw[20], 0);

	InventoryTextDraw[21] = TextDrawCreate(430.000000, 233.000000, "LD_SPAC:WHITE");//线条4
	TextDrawFont(InventoryTextDraw[21], 4);
	TextDrawLetterSize(InventoryTextDraw[21], 0.600000, 2.000000);
	TextDrawTextSize(InventoryTextDraw[21], 197.500000, 0.500000);
	TextDrawSetOutline(InventoryTextDraw[21], 1);
	TextDrawSetShadow(InventoryTextDraw[21], 0);
	TextDrawAlignment(InventoryTextDraw[21], 1);
	TextDrawColor(InventoryTextDraw[21], -56);
	TextDrawBackgroundColor(InventoryTextDraw[21], 255);
	TextDrawBoxColor(InventoryTextDraw[21], 50);
	TextDrawUseBox(InventoryTextDraw[21], 1);
	TextDrawSetProportional(InventoryTextDraw[21], 1);
	TextDrawSetSelectable(InventoryTextDraw[21], 0);

	InventoryTextDraw[22] = TextDrawCreate(430.000000, 317.000000, "LD_SPAC:WHITE");//线条5
	TextDrawFont(InventoryTextDraw[22], 4);
	TextDrawLetterSize(InventoryTextDraw[22], 0.600000, 2.000000);
	TextDrawTextSize(InventoryTextDraw[22], 197.500000, 0.500000);
	TextDrawSetOutline(InventoryTextDraw[22], 1);
	TextDrawSetShadow(InventoryTextDraw[22], 0);
	TextDrawAlignment(InventoryTextDraw[22], 1);
	TextDrawColor(InventoryTextDraw[22], -56);
	TextDrawBackgroundColor(InventoryTextDraw[22], 255);
	TextDrawBoxColor(InventoryTextDraw[22], 50);
	TextDrawUseBox(InventoryTextDraw[22], 1);
	TextDrawSetProportional(InventoryTextDraw[22], 1);
	TextDrawSetSelectable(InventoryTextDraw[22], 0);

	InventoryTextDraw[23] = TextDrawCreate(528.000000, 319.000000, "LD_SPAC:WHITE");//线条6
	TextDrawFont(InventoryTextDraw[23], 4);
	TextDrawLetterSize(InventoryTextDraw[23], 0.600000, 2.000000);
	TextDrawTextSize(InventoryTextDraw[23], 0.500000, 81.500000);
	TextDrawSetOutline(InventoryTextDraw[23], 1);
	TextDrawSetShadow(InventoryTextDraw[23], 0);
	TextDrawAlignment(InventoryTextDraw[23], 1);
	TextDrawColor(InventoryTextDraw[23], -56);
	TextDrawBackgroundColor(InventoryTextDraw[23], 255);
	TextDrawBoxColor(InventoryTextDraw[23], 50);
	TextDrawUseBox(InventoryTextDraw[23], 1);
	TextDrawSetProportional(InventoryTextDraw[23], 1);
	TextDrawSetSelectable(InventoryTextDraw[23], 0);
	
	InventoryTextDraw[24] = TextDrawCreate(191.000000, 53.000000, "mdl-2000:left");//库存翻页左
	TextDrawFont(InventoryTextDraw[24], 4);
	TextDrawLetterSize(InventoryTextDraw[24], 0.600000, 2.000000);
	TextDrawTextSize(InventoryTextDraw[24], 4.000000, 9.000000);
	TextDrawSetOutline(InventoryTextDraw[24], 1);
	TextDrawSetShadow(InventoryTextDraw[24], 0);
	TextDrawAlignment(InventoryTextDraw[24], 1);
	TextDrawColor(InventoryTextDraw[24], -1);
	TextDrawBackgroundColor(InventoryTextDraw[24], 255);
	TextDrawBoxColor(InventoryTextDraw[24], 50);
	TextDrawUseBox(InventoryTextDraw[24], 1);
	TextDrawSetProportional(InventoryTextDraw[24], 1);
	TextDrawSetSelectable(InventoryTextDraw[24], 1);

	InventoryTextDraw[25] = TextDrawCreate(214.000000, 53.000000, "mdl-2000:right");//库存翻页右
	TextDrawFont(InventoryTextDraw[25], 4);
	TextDrawLetterSize(InventoryTextDraw[25], 0.600000, 2.000000);
	TextDrawTextSize(InventoryTextDraw[25], 4.000000, 9.000000);
	TextDrawSetOutline(InventoryTextDraw[25], 1);
	TextDrawSetShadow(InventoryTextDraw[25], 0);
	TextDrawAlignment(InventoryTextDraw[25], 1);
	TextDrawColor(InventoryTextDraw[25], -1);
	TextDrawBackgroundColor(InventoryTextDraw[25], 255);
	TextDrawBoxColor(InventoryTextDraw[25], 50);
	TextDrawUseBox(InventoryTextDraw[25], 1);
	TextDrawSetProportional(InventoryTextDraw[25], 1);
	TextDrawSetSelectable(InventoryTextDraw[25], 1);

	InventoryTextDraw[26] = TextDrawCreate(106.000000, 53.000000, "mdl-2000:right");//附近翻页左
	TextDrawFont(InventoryTextDraw[26], 4);
	TextDrawLetterSize(InventoryTextDraw[26], 0.600000, 2.000000);
	TextDrawTextSize(InventoryTextDraw[26], 4.000000, 9.000000);
	TextDrawSetOutline(InventoryTextDraw[26], 1);
	TextDrawSetShadow(InventoryTextDraw[26], 0);
	TextDrawAlignment(InventoryTextDraw[26], 1);
	TextDrawColor(InventoryTextDraw[26], -1);
	TextDrawBackgroundColor(InventoryTextDraw[26], 255);
	TextDrawBoxColor(InventoryTextDraw[26], 50);
	TextDrawUseBox(InventoryTextDraw[26], 1);
	TextDrawSetProportional(InventoryTextDraw[26], 1);
	TextDrawSetSelectable(InventoryTextDraw[26], 1);

	InventoryTextDraw[27] = TextDrawCreate(83.000000, 53.000000, "mdl-2000:left");//附近翻页右
	TextDrawFont(InventoryTextDraw[27], 4);
	TextDrawLetterSize(InventoryTextDraw[27], 0.600000, 2.000000);
	TextDrawTextSize(InventoryTextDraw[27], 4.000000, 9.000000);
	TextDrawSetOutline(InventoryTextDraw[27], 1);
	TextDrawSetShadow(InventoryTextDraw[27], 0);
	TextDrawAlignment(InventoryTextDraw[27], 1);
	TextDrawColor(InventoryTextDraw[27], -1);
	TextDrawBackgroundColor(InventoryTextDraw[27], 255);
	TextDrawBoxColor(InventoryTextDraw[27], 50);
	TextDrawUseBox(InventoryTextDraw[27], 1);
	TextDrawSetProportional(InventoryTextDraw[27], 1);
	TextDrawSetSelectable(InventoryTextDraw[27], 1);
	
	ZombieBagTextDraws[0] = TextDrawCreate(189.000000, 93.000000, "_");//背景
	TextDrawFont(ZombieBagTextDraws[0], 1);
	TextDrawLetterSize(ZombieBagTextDraws[0], 0.600000, 26.550014);
	TextDrawTextSize(ZombieBagTextDraws[0], 400.000000, 131.500000);
	TextDrawSetOutline(ZombieBagTextDraws[0], 1);
	TextDrawSetShadow(ZombieBagTextDraws[0], 0);
	TextDrawAlignment(ZombieBagTextDraws[0], 2);
	TextDrawColor(ZombieBagTextDraws[0], -1);
	TextDrawBackgroundColor(ZombieBagTextDraws[0], 255);
	TextDrawBoxColor(ZombieBagTextDraws[0], 130);
	TextDrawUseBox(ZombieBagTextDraws[0], 1);
	TextDrawSetProportional(ZombieBagTextDraws[0], 1);
	TextDrawSetSelectable(ZombieBagTextDraws[0], 0);

	ZombieBagTextDraws[1] = TextDrawCreate(189.000000, 93.000000, "_");//标题
	TextDrawFont(ZombieBagTextDraws[1], 1);
	TextDrawLetterSize(ZombieBagTextDraws[1], 0.600000, 2.099999);
	TextDrawTextSize(ZombieBagTextDraws[1], 400.000000, 131.000000);
	TextDrawSetOutline(ZombieBagTextDraws[1], 1);
	TextDrawSetShadow(ZombieBagTextDraws[1], 0);
	TextDrawAlignment(ZombieBagTextDraws[1], 2);
	TextDrawColor(ZombieBagTextDraws[1], 255);
	TextDrawBackgroundColor(ZombieBagTextDraws[1], 255);
	TextDrawBoxColor(ZombieBagTextDraws[1], 229);
	TextDrawUseBox(ZombieBagTextDraws[1], 1);
	TextDrawSetProportional(ZombieBagTextDraws[1], 1);
	TextDrawSetSelectable(ZombieBagTextDraws[1], 0);
	
	ZombieBagTextDraws[2] = TextDrawCreate(247.000000, 93.000000, "X");//关闭
	TextDrawFont(ZombieBagTextDraws[2], 2);
	TextDrawLetterSize(ZombieBagTextDraws[2], 0.429165, 2.000000);
	TextDrawTextSize(ZombieBagTextDraws[2], 400.000000, 17.000000);
	TextDrawSetOutline(ZombieBagTextDraws[2], 0);
	TextDrawSetShadow(ZombieBagTextDraws[2], 0);
	TextDrawAlignment(ZombieBagTextDraws[2], 2);
	TextDrawColor(ZombieBagTextDraws[2], -1);
	TextDrawBackgroundColor(ZombieBagTextDraws[2], 255);
	TextDrawBoxColor(ZombieBagTextDraws[2], 50);
	TextDrawUseBox(ZombieBagTextDraws[2], 0);
	TextDrawSetProportional(ZombieBagTextDraws[2], 1);
	TextDrawSetSelectable(ZombieBagTextDraws[2], 1);

	ZombieBagTextDraws[3] = TextDrawCreate(163.000000, 334.000000, "<<");//back
	TextDrawFont(ZombieBagTextDraws[3], 1);
	TextDrawLetterSize(ZombieBagTextDraws[3], 0.266665, 1.749999);
	TextDrawTextSize(ZombieBagTextDraws[3], 400.000000, 17.000000);
	TextDrawSetOutline(ZombieBagTextDraws[3], 1);
	TextDrawSetShadow(ZombieBagTextDraws[3], 0);
	TextDrawAlignment(ZombieBagTextDraws[3], 2);
	TextDrawColor(ZombieBagTextDraws[3], -1);
	TextDrawBackgroundColor(ZombieBagTextDraws[3], 255);
	TextDrawBoxColor(ZombieBagTextDraws[3], 50);
	TextDrawUseBox(ZombieBagTextDraws[3], 0);
	TextDrawSetProportional(ZombieBagTextDraws[3], 1);
	TextDrawSetSelectable(ZombieBagTextDraws[3], 1);

	ZombieBagTextDraws[4] = TextDrawCreate(211.000000, 334.000000, ">>");//next
	TextDrawFont(ZombieBagTextDraws[4], 1);
	TextDrawLetterSize(ZombieBagTextDraws[4], 0.266665, 1.749999);
	TextDrawTextSize(ZombieBagTextDraws[4], 400.000000, 17.000000);
	TextDrawSetOutline(ZombieBagTextDraws[4], 1);
	TextDrawSetShadow(ZombieBagTextDraws[4], 0);
	TextDrawAlignment(ZombieBagTextDraws[4], 2);
	TextDrawColor(ZombieBagTextDraws[4], -1);
	TextDrawBackgroundColor(ZombieBagTextDraws[4], 255);
	TextDrawBoxColor(ZombieBagTextDraws[4], 50);
	TextDrawUseBox(ZombieBagTextDraws[4], 0);
	TextDrawSetProportional(ZombieBagTextDraws[4], 1);
	TextDrawSetSelectable(ZombieBagTextDraws[4], 1);
	return 1;
}

FUNC::UpdatePlayerZombieBagPage(playerid,zombieid,pages)//更新显示僵尸背包GUI
{
	forex(i,MAX_PLAYER_ZOMBIE_TEXTDRAWS)
	{
		PlayerTextDrawHide(playerid, PlayerZombieBagBackDraws[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerZombieBagModelDraws[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerZombieBagNameDraws[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerZombieBagAmountDraws[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerZombieBagPercentDraws[playerid][i]);
	}
	PlayerTextDrawHide(playerid, PlayerZombieBagPageDraws[playerid]);
	new index=0,PlayerZombieBagAmout=0;
    PlayerZombieBagPrevieRate[playerid]=0;
    PlayerZombieBagPrevieCount[playerid]=1;
    PlayerZombieBagClickID[playerid]=NONE;
    PlayerZombieBagZombieID[playerid]=zombieid;
	foreach(new i:ZombieBag[zombieid])
	{
		PlayerZombieBagPrevieBox[playerid][PlayerZombieBagPrevieCount[playerid]]=i;
		format(PlayerZombieBagPrevieBoxKey[playerid][PlayerZombieBagPrevieCount[playerid]],64,ZombieBag[zombieid][i][_ZombieBagKey]);
		PlayerZombieBagPrevieCount[playerid]++;
		PlayerZombieBagAmout++;
	}
	if(pages<1)pages=1;
	if(pages>floatround((PlayerZombieBagPrevieCount[playerid]-1)/float(MAX_PLAYER_ZOMBIE_TEXTDRAWS),floatround_ceil))pages=floatround((PlayerZombieBagPrevieCount[playerid]-1)/float(MAX_PLAYER_ZOMBIE_TEXTDRAWS),floatround_ceil);
    PlayerZombieBagPreviePage[playerid]=pages;
    pages=(pages-1)*MAX_PLAYER_ZOMBIE_TEXTDRAWS;
    if(pages<=0)pages=1;else pages++;
    new Strings[32];
    loop(i,pages,pages+MAX_PLAYER_ZOMBIE_TEXTDRAWS)
	{
	    index=PlayerZombieBagPrevieBox[playerid][i];
	    if(i<PlayerZombieBagPrevieCount[playerid])
		{
		    PlayerTextDrawSetPreviewModel(playerid, PlayerZombieBagModelDraws[playerid][PlayerZombieBagPrevieRate[playerid]], Item[ZombieBag[zombieid][index][_ItemID]][_Model]);
			PlayerTextDrawSetString(playerid,PlayerZombieBagNameDraws[playerid][PlayerZombieBagPrevieRate[playerid]],Item[ZombieBag[zombieid][index][_ItemID]][_NameTXD]);
            if(Item[ZombieBag[zombieid][index][_ItemID]][_Durable]==1)
            {
				format(Strings,sizeof(Strings),"%0.1f%",ZombieBag[zombieid][index][_Durable]);
				PlayerTextDrawSetString(playerid,PlayerZombieBagPercentDraws[playerid][PlayerZombieBagPrevieRate[playerid]],Strings);
			}
			format(Strings,sizeof(Strings),"%i",ZombieBag[zombieid][index][_Amounts]);
			PlayerTextDrawSetString(playerid,PlayerZombieBagAmountDraws[playerid][PlayerZombieBagPrevieRate[playerid]],Strings);
			PlayerTextDrawShow(playerid, PlayerZombieBagBackDraws[playerid][PlayerZombieBagPrevieRate[playerid]]);
			PlayerTextDrawShow(playerid, PlayerZombieBagModelDraws[playerid][PlayerZombieBagPrevieRate[playerid]]);
			PlayerTextDrawShow(playerid, PlayerZombieBagNameDraws[playerid][PlayerZombieBagPrevieRate[playerid]]);
			if(Item[ZombieBag[zombieid][index][_ItemID]][_Durable]==1)PlayerTextDrawShow(playerid, PlayerZombieBagPercentDraws[playerid][PlayerZombieBagPrevieRate[playerid]]);
			PlayerTextDrawShow(playerid, PlayerZombieBagAmountDraws[playerid][PlayerZombieBagPrevieRate[playerid]]);
		    PlayerZombieBagPrevieRate[playerid]++;
		}
	    else break;
	}

	format(Strings,sizeof(Strings),"%02d/%02d",PlayerZombieBagPreviePage[playerid],floatround((PlayerZombieBagPrevieCount[playerid]-1)/float(MAX_PLAYER_ZOMBIE_TEXTDRAWS),floatround_ceil));
    PlayerTextDrawSetString(playerid,PlayerZombieBagPageDraws[playerid],Strings);
	PlayerTextDrawShow(playerid, PlayerZombieBagPageDraws[playerid]);
	return 1;
}
FUNC::ShowPlayerZombieBagTextDraw(playerid,zombieid)
{
	forex(i,MAX_PLAYER_ZOMBIE_TEXTDRAWS)
	{
		PlayerTextDrawHide(playerid, PlayerWeaponItemDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerWeaponPercentDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerWeaponNameDraw[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerWeaponBackBottonDraw[playerid][i]);
	}
	forex(i,sizeof(ZombieBagTextDraws))TextDrawShowForPlayer(playerid,ZombieBagTextDraws[i]);
	UpdatePlayerZombieBagPage(playerid,zombieid,1);
	PlayerZombieBagTextDrawShow[playerid]=true;
	SelectTextDrawEx(playerid,0x408080C8);
	return 1;
}
FUNC::HidePlayerZombieBagTextDraw(playerid)
{
	forex(i,sizeof(ZombieBagTextDraws))TextDrawHideForPlayer(playerid,ZombieBagTextDraws[i]);
	forex(i,MAX_PLAYER_ZOMBIE_TEXTDRAWS)
	{
		PlayerTextDrawHide(playerid, PlayerZombieBagBackDraws[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerZombieBagModelDraws[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerZombieBagNameDraws[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerZombieBagAmountDraws[playerid][i]);
		PlayerTextDrawHide(playerid, PlayerZombieBagPercentDraws[playerid][i]);
	}
	PlayerTextDrawHide(playerid, PlayerZombieBagPageDraws[playerid]);
	PlayerZombieBagTextDrawShow[playerid]=false;
	return 1;
}
/*CMD:szt(playerid, params[])
{
	forex(s,10)
    {
		new RandItem=Iter_Random(Item);
	    format(ZombieBag[0][s][_ZombieKey],UUID_LEN,Zombies[0][_zKey]);
	    UUID(ZombieBag[0][s][_ZombieBagKey], UUID_LEN);
        format(ZombieBag[0][s][_ItemKey],UUID_LEN,Item[RandItem][_Key]);
        ZombieBag[0][s][_Amounts]=1;
        ZombieBag[0][s][_Durable]=100.0;
        ZombieBag[0][s][_ItemID]=RandItem;
	    Iter_Add(ZombieBag[0],s);
	}
	ShowPlayerZombieBagTextDraw(playerid,0);
	return 1;
}*/
