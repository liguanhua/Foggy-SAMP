new Text:CraftTextDraw[10]= {Text:INVALID_TEXT_DRAW, ...};
#define MAX_CRAFT_SHOW_LIST 12
#define MAX_CRAFT_USE_AMOUNT 4
new PlayerText:CraftBackBottonDraw[MAX_PLAYERS][MAX_CRAFT_SHOW_LIST];
new PlayerText:CraftItemDraw[MAX_PLAYERS][MAX_CRAFT_SHOW_LIST];
new PlayerText:CraftNeed[MAX_PLAYERS][MAX_CRAFT_USE_AMOUNT];
new PlayerText:CraftHave[MAX_PLAYERS][MAX_CRAFT_USE_AMOUNT];
new PlayerText:CraftProgress[MAX_PLAYERS]= PlayerText:INVALID_TEXT_DRAW;

#define MAX_CRAFT_BOX_ITEMS MAX_BOX_ITEMS+2

new CraftPrevieBox[MAX_PLAYERS][MAX_CRAFT_BOX_ITEMS];
new CraftPrevieBoxKey[MAX_PLAYERS][MAX_CRAFT_BOX_ITEMS][64];
new CraftPrevieCount[MAX_PLAYERS];
new CraftPreviePage[MAX_PLAYERS];
new CraftPrevieRate[MAX_PLAYERS];
new CraftPrevieType[MAX_PLAYERS];
new CraftClickID[MAX_PLAYERS];
new CraftClickIndex[MAX_PLAYERS];

new bool:CraftTextDrawShow[MAX_PLAYERS]= {false, ...};



new Text:CarCraftTextDraw=Text:INVALID_TEXT_DRAW;
new Text:MakeCarTextDraw=Text:INVALID_TEXT_DRAW;
#define MAX_CARCRAFT_NEEDS 3
new PlayerText:CarCraftModel[MAX_PLAYERS]= PlayerText:INVALID_TEXT_DRAW;
new PlayerText:CarCraftNeedThings[MAX_PLAYERS][MAX_CARCRAFT_NEEDS];
new bool:CarCraftTextDrawShow[MAX_PLAYERS]= {false, ...};
FUNC::HideCarCraftThings(playerid)
{
    TextDrawHideForPlayer(playerid,CarCraftTextDraw);
    TextDrawHideForPlayer(playerid,MakeCarTextDraw);
    PlayerTextDrawHide(playerid, CarCraftModel[playerid]);
   	forex(i,MAX_CARCRAFT_NEEDS)PlayerTextDrawHide(playerid,CarCraftNeedThings[playerid][i]);
    CarCraftTextDrawShow[playerid]=false;
	return 1;
}
FUNC::ShowCarCraftThings(playerid,index)
{
	TextDrawShowForPlayer(playerid,CarCraftTextDraw);
	PlayerTextDrawSetPreviewModel(playerid, CarCraftModel[playerid], CraftVehicleList[VehicleWreckage[index][_CraftVehID]][_VehicleModel]);
	PlayerTextDrawShow(playerid, CarCraftModel[playerid]);
	new index1=0,NeedthingKey[37],NeedthingAmount=0,NeedThings[MAX_CARCRAFT_NEEDS];
	forex(i,MAX_CARCRAFT_NEEDS)
	{
	    NeedThings[i]=0;
	}
    forex(i,10)
    {
    	formatex64("%s",StrtokPack1(CraftVehicleList[VehicleWreckage[index][_CraftVehID]][_NeedThing],index1));
		if(strval(string64)!=-1)
    	{
    	    new index2=0;
    	    format(NeedthingKey,sizeof(NeedthingKey),StrtokPack2(string64,index2));
    	    NeedthingAmount=strval(StrtokPack2(string64,index2));
    	    forex(s,MAX_CARCRAFT_NEEDS)
    	    {
    	        formatex32("A007_%03d",s);
    	        if(isequal(NeedthingKey,string32,false))NeedThings[s]+=NeedthingAmount;
	    	}
	    }
    }
    new HaveThings[MAX_CARCRAFT_NEEDS];
	forex(i,MAX_CARCRAFT_NEEDS)
	{
	    formatex32("A007_%03d",i);
	    HaveThings[i]=GetPlayerInvItemAmountByKey(playerid,string32);
	}
	forex(i,MAX_CARCRAFT_NEEDS)
	{
	    formatex32("%i/%i",HaveThings[i],NeedThings[i]);
		PlayerTextDrawSetString(playerid, CarCraftNeedThings[playerid][i],string32);
		PlayerTextDrawShow(playerid, CarCraftNeedThings[playerid][i]);
	}
    CarCraftTextDrawShow[playerid]=true;
    new bool:Conditional=true;
    new bodys[256];
	forex(i,MAX_CARCRAFT_NEEDS)
	{
        if(NeedThings[i]>0)
		{
	        if(NeedThings[i]>HaveThings[i])
	        {
	            formatex32("A007_%03d",i);
	            formatex64(" %i 个 %s",NeedThings[i]-HaveThings[i],Item[GetItemIDByItemKey(string32)][_Name]);
                strcat(bodys,string64);
	            Conditional=false;
	        }
		}
	}
    if(Conditional==true)
	{
		SCM(playerid,-1,"该汽车残骸需求满足,按下 回车键 可以制作");
		TextDrawShowForPlayer(playerid,MakeCarTextDraw);
		SelectTextDrawEx(playerid,0x408080C8);
	}
    else
    {
        TextDrawHideForPlayer(playerid,MakeCarTextDraw);
        formatex1024("你还缺少%s",bodys);
        SCM(playerid,-1,string1024);
    }
	return 1;
}


FUNC::ShowCraftItemHaveThings(playerid)
{
    new HaveThings[MAX_CRAFT_USE_AMOUNT];
	forex(i,MAX_CRAFT_USE_AMOUNT)
	{
	    formatex32("A008_%03d",i);
	    HaveThings[i]=GetPlayerInvItemAmountByKey(playerid,string32);
	}
	forex(i,MAX_CRAFT_USE_AMOUNT)
	{
	    formatex32("%i",HaveThings[i]);
		PlayerTextDrawSetString(playerid, CraftHave[playerid][i],string32);
		PlayerTextDrawShow(playerid, CraftHave[playerid][i]);
	}
	return 1;
}
FUNC::ShowCraftItemNeedThings(playerid,index)
{
    if(CraftTextDrawShow[playerid]==true)
    {
		new index1=0,NeedthingKey[37],NeedthingAmount=0,NeedThings[MAX_CRAFT_USE_AMOUNT];
		forex(i,MAX_CRAFT_USE_AMOUNT)
		{
		    NeedThings[i]=0;
		}
	    forex(i,10)
	    {
	    	formatex64("%s",StrtokPack1(CraftItem[index][_NeedThing],index1));
	    	if(strval(string64)!=-1)
	    	{
	    	    new index2=0;
	    	    format(NeedthingKey,sizeof(NeedthingKey),StrtokPack2(string64,index2));
	    	    NeedthingAmount=strval(StrtokPack2(string64,index2));
	    	    forex(s,MAX_CRAFT_USE_AMOUNT)
	    	    {
	    	        formatex32("A008_%03d",s);
	    	        if(isequal(NeedthingKey,string32,false))NeedThings[s]+=NeedthingAmount;
	    	    }
	    	}
	    }
		forex(i,MAX_CRAFT_USE_AMOUNT)
		{
		    formatex32("%i",NeedThings[i]);
			PlayerTextDrawSetString(playerid, CraftNeed[playerid][i],string32);
			PlayerTextDrawShow(playerid, CraftNeed[playerid][i]);
		}
	}
    return 1;
}
FUNC::UpdateCraftPageForPlayer(playerid,pages,type)
{
	forex(i,MAX_CRAFT_SHOW_LIST)
	{
	    PlayerTextDrawColor(playerid, CraftBackBottonDraw[playerid][i], -256);
		PlayerTextDrawHide(playerid, CraftBackBottonDraw[playerid][i]);
		PlayerTextDrawHide(playerid, CraftItemDraw[playerid][i]);
	}
	forex(i,MAX_CRAFT_USE_AMOUNT)
	{
		PlayerTextDrawHide(playerid, CraftNeed[playerid][i]);
		//PlayerTextDrawHide(playerid, CraftHave[playerid][i]);
	}
	PlayerTextDrawHide(playerid, CraftProgress[playerid]);

	new index=0,CraftAmout=0;
    CraftPrevieRate[playerid]=0;
    CraftPrevieCount[playerid]=1;
    CraftClickID[playerid]=NONE;
    CraftClickIndex[playerid]=NONE;
    CraftPrevieType[playerid]=type;
    
    foreach(new i:CraftItem)
    {
        if(type==CraftItem[i][_Type])
        {
			CraftPrevieBox[playerid][CraftPrevieCount[playerid]]=i;
			format(CraftPrevieBoxKey[playerid][CraftPrevieCount[playerid]],64,"");
			format(CraftPrevieBoxKey[playerid][CraftPrevieCount[playerid]],64,CraftItem[i][_Key]);
   			CraftPrevieCount[playerid]++;
   			CraftAmout++;
        }
    }
	if(pages<1)pages=1;
	if(pages>floatround((CraftPrevieCount[playerid]-1)/float(MAX_CRAFT_SHOW_LIST),floatround_ceil))pages=floatround((CraftPrevieCount[playerid]-1)/float(MAX_CRAFT_SHOW_LIST),floatround_ceil);
    CraftPreviePage[playerid]=pages;
    pages=(pages-1)*MAX_CRAFT_SHOW_LIST;
    if(pages<=0)pages=1;else pages++;
    loop(i,pages,pages+MAX_CRAFT_SHOW_LIST)
	{
	    index=CraftPrevieBox[playerid][i];
	    if(i<CraftPrevieCount[playerid])
		{
		    PlayerTextDrawShow(playerid, CraftBackBottonDraw[playerid][CraftPrevieRate[playerid]]);
		    PlayerTextDrawSetPreviewModel(playerid, CraftItemDraw[playerid][CraftPrevieRate[playerid]], CraftItem[index][_ModelID]);
            PlayerTextDrawSetPreviewRot(playerid,CraftItemDraw[playerid][CraftPrevieRate[playerid]], -16.000000, 0.000000, -55.000000, 0.899998);
			PlayerTextDrawShow(playerid, CraftItemDraw[playerid][CraftPrevieRate[playerid]]);
		    CraftPrevieRate[playerid]++;
		}
	    else break;
	}
	new Float:BarTextSize=floatdiv(266.000000,floatround(floatdiv(CraftAmout,MAX_CRAFT_SHOW_LIST),floatround_ceil));
	PlayerTextDrawTextSize(playerid, CraftProgress[playerid], 17.000000, floatmul(CraftPreviePage[playerid],BarTextSize));
	PlayerTextDrawShow(playerid, CraftProgress[playerid]);
	return 1;
}
CMD:cr1(playerid, params[])
{
	new ownerkey;
    sscanf(params, "i",ownerkey);
    ShowCraftTextDrawForPlayer(playerid,ownerkey);
	return 1;
}
CMD:cr2(playerid, params[])
{
	HideCraftTextDrawForPlayer(playerid);
	return 1;
}
FUNC::ShowCraftTextDrawForPlayer(playerid,type)
{
	switch(GetPlayerInDomainState(playerid))
	{
	    case PLAYER_DOMAIN_NONE:
		{
		    CancelSelectTextDrawEx(playerid);
		    SCM(playerid,-1,"这不是领地区域");
			return 0;
		}
	    case PLAYER_DOMAIN_OTHER:
		{
		    CancelSelectTextDrawEx(playerid);
		    SCM(playerid,-1,"这是别人的领地,你不能操作!");
			return 0;
		}
	    case PLAYER_DOMAIN_FACTION_FORBID:
		{
		    CancelSelectTextDrawEx(playerid);
		    SCM(playerid,-1,"这是阵营领地,你没有权限操作1!");
			return 0;
		}
	    case PLAYER_DOMAIN_FACTION_OTHER:
		{
		    CancelSelectTextDrawEx(playerid);
		    SCM(playerid,-1,"这是阵营领地,你没有权限操作2!");
			return 0;
		}
	}
    HidePlayerPresonStateTextDraw(playerid);
    HidePlayerNavigationBarTextDraw(playerid);
    HideWeaponHudTextDrawForPlayer(playerid);
	forex(i,sizeof(CraftTextDraw))TextDrawShowForPlayer(playerid,CraftTextDraw[i]);
    UpdateCraftPageForPlayer(playerid,CRAFT_TPYE_HOUSE,type);
    ShowCraftItemHaveThings(playerid);
    SelectTextDrawEx(playerid,0x408080C8);
    CraftTextDrawShow[playerid]=true;
    return 1;
}
FUNC::HideCraftTextDrawForPlayer(playerid)
{
	forex(i,MAX_CRAFT_SHOW_LIST)
	{
		PlayerTextDrawHide(playerid, CraftBackBottonDraw[playerid][i]);
		PlayerTextDrawHide(playerid, CraftItemDraw[playerid][i]);
	}
	forex(i,MAX_CRAFT_USE_AMOUNT)
	{
		PlayerTextDrawHide(playerid, CraftNeed[playerid][i]);
		PlayerTextDrawHide(playerid, CraftHave[playerid][i]);
	}
	PlayerTextDrawHide(playerid, CraftProgress[playerid]);
	forex(i,sizeof(CraftTextDraw))TextDrawHideForPlayer(playerid,CraftTextDraw[i]);
	CraftTextDrawShow[playerid]=false;
	ShowPlayerPresonStateTextDraw(playerid);
	OnPlayerWeaponChange(playerid,GetPlayerWeapon(playerid),GetPlayerWeapon(playerid));
	return 1;
}
FUNC::CraftDraw_OnGameModeInit()
{
	forex(i,MAX_PLAYERS)
	{
		forex(s,MAX_CRAFT_SHOW_LIST)
		{
			CraftBackBottonDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			CraftItemDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
		}
		forex(s,MAX_CRAFT_USE_AMOUNT)
		{
			CraftNeed[i][s]=PlayerText:INVALID_TEXT_DRAW;
			CraftHave[i][s]=PlayerText:INVALID_TEXT_DRAW;
		}
		CraftProgress[i]=PlayerText:INVALID_TEXT_DRAW;
	}
	
	CraftTextDraw[0] = TextDrawCreate(6.000000, 7.000000, "mdl-2002:CrateBack");//背景
	TextDrawFont(CraftTextDraw[0], 4);
	TextDrawLetterSize(CraftTextDraw[0], 0.600000, 2.000000);
	TextDrawTextSize(CraftTextDraw[0], 632.000000, 443.000000);
	TextDrawSetOutline(CraftTextDraw[0], 1);
	TextDrawSetShadow(CraftTextDraw[0], 0);
	TextDrawAlignment(CraftTextDraw[0], 1);
	TextDrawColor(CraftTextDraw[0], -1);
	TextDrawBackgroundColor(CraftTextDraw[0], 255);
	TextDrawBoxColor(CraftTextDraw[0], 50);
	TextDrawUseBox(CraftTextDraw[0], 1);
	TextDrawSetProportional(CraftTextDraw[0], 1);
	TextDrawSetSelectable(CraftTextDraw[0], 0);

	CraftTextDraw[1] = TextDrawCreate(551.000000, 357.000000, "mdl-2002:CraftBotton");//制作按钮
	TextDrawFont(CraftTextDraw[1], 4);
	TextDrawLetterSize(CraftTextDraw[1], 0.600000, 2.000000);
	TextDrawTextSize(CraftTextDraw[1], 60.000000, 67.000000);
	TextDrawSetOutline(CraftTextDraw[1], 1);
	TextDrawSetShadow(CraftTextDraw[1], 0);
	TextDrawAlignment(CraftTextDraw[1], 1);
	TextDrawColor(CraftTextDraw[1], -1);
	TextDrawBackgroundColor(CraftTextDraw[1], 255);
	TextDrawBoxColor(CraftTextDraw[1], 50);
	TextDrawUseBox(CraftTextDraw[1], 1);
	TextDrawSetProportional(CraftTextDraw[1], 1);
	TextDrawSetSelectable(CraftTextDraw[1], 1);
	
	CraftTextDraw[2] = TextDrawCreate(26.000000, 28.000000, "mdl-2002:FENCE");
	TextDrawFont(CraftTextDraw[2], 4);
	TextDrawLetterSize(CraftTextDraw[2], 0.600000, 2.000000);
	TextDrawTextSize(CraftTextDraw[2], 102.000000, 43.000000);
	TextDrawSetOutline(CraftTextDraw[2], 1);
	TextDrawSetShadow(CraftTextDraw[2], 0);
	TextDrawAlignment(CraftTextDraw[2], 1);
	TextDrawColor(CraftTextDraw[2], -1);
	TextDrawBackgroundColor(CraftTextDraw[2], 255);
	TextDrawBoxColor(CraftTextDraw[2], 50);
	TextDrawUseBox(CraftTextDraw[2], 1);
	TextDrawSetProportional(CraftTextDraw[2], 1);
	TextDrawSetSelectable(CraftTextDraw[2], 1);

	CraftTextDraw[3] = TextDrawCreate(26.000000, 69.000000, "mdl-2002:HOUSE");
	TextDrawFont(CraftTextDraw[3], 4);
	TextDrawLetterSize(CraftTextDraw[3], 0.600000, 2.000000);
	TextDrawTextSize(CraftTextDraw[3], 102.000000, 43.000000);
	TextDrawSetOutline(CraftTextDraw[3], 1);
	TextDrawSetShadow(CraftTextDraw[3], 0);
	TextDrawAlignment(CraftTextDraw[3], 1);
	TextDrawColor(CraftTextDraw[3], -1);
	TextDrawBackgroundColor(CraftTextDraw[3], 255);
	TextDrawBoxColor(CraftTextDraw[3], 50);
	TextDrawUseBox(CraftTextDraw[3], 1);
	TextDrawSetProportional(CraftTextDraw[3], 1);
	TextDrawSetSelectable(CraftTextDraw[3], 1);

	CraftTextDraw[4] = TextDrawCreate(26.000000, 110.000000, "mdl-2002:STARIS");
	TextDrawFont(CraftTextDraw[4], 4);
	TextDrawLetterSize(CraftTextDraw[4], 0.600000, 2.000000);
	TextDrawTextSize(CraftTextDraw[4], 102.000000, 43.000000);
	TextDrawSetOutline(CraftTextDraw[4], 1);
	TextDrawSetShadow(CraftTextDraw[4], 0);
	TextDrawAlignment(CraftTextDraw[4], 1);
	TextDrawColor(CraftTextDraw[4], -1);
	TextDrawBackgroundColor(CraftTextDraw[4], 255);
	TextDrawBoxColor(CraftTextDraw[4], 50);
	TextDrawUseBox(CraftTextDraw[4], 1);
	TextDrawSetProportional(CraftTextDraw[4], 1);
	TextDrawSetSelectable(CraftTextDraw[4], 1);

	CraftTextDraw[5] = TextDrawCreate(26.000000, 151.000000, "mdl-2002:DOOR");
	TextDrawFont(CraftTextDraw[5], 4);
	TextDrawLetterSize(CraftTextDraw[5], 0.600000, 2.000000);
	TextDrawTextSize(CraftTextDraw[5], 102.000000, 43.000000);
	TextDrawSetOutline(CraftTextDraw[5], 1);
	TextDrawSetShadow(CraftTextDraw[5], 0);
	TextDrawAlignment(CraftTextDraw[5], 1);
	TextDrawColor(CraftTextDraw[5], -1);
	TextDrawBackgroundColor(CraftTextDraw[5], 255);
	TextDrawBoxColor(CraftTextDraw[5], 50);
	TextDrawUseBox(CraftTextDraw[5], 1);
	TextDrawSetProportional(CraftTextDraw[5], 1);
	TextDrawSetSelectable(CraftTextDraw[5], 1);

	CraftTextDraw[6] = TextDrawCreate(26.000000, 192.000000, "mdl-2002:COFFER");
	TextDrawFont(CraftTextDraw[6], 4);
	TextDrawLetterSize(CraftTextDraw[6], 0.600000, 2.000000);
	TextDrawTextSize(CraftTextDraw[6], 102.000000, 43.000000);
	TextDrawSetOutline(CraftTextDraw[6], 1);
	TextDrawSetShadow(CraftTextDraw[6], 0);
	TextDrawAlignment(CraftTextDraw[6], 1);
	TextDrawColor(CraftTextDraw[6], -1);
	TextDrawBackgroundColor(CraftTextDraw[6], 255);
	TextDrawBoxColor(CraftTextDraw[6], 50);
	TextDrawUseBox(CraftTextDraw[6], 1);
	TextDrawSetProportional(CraftTextDraw[6], 1);
	TextDrawSetSelectable(CraftTextDraw[6], 1);

	CraftTextDraw[7] = TextDrawCreate(26.000000, 233.000000, "mdl-2002:OTHERS");
	TextDrawFont(CraftTextDraw[7], 4);
	TextDrawLetterSize(CraftTextDraw[7], 0.600000, 2.000000);
	TextDrawTextSize(CraftTextDraw[7], 102.000000, 43.000000);
	TextDrawSetOutline(CraftTextDraw[7], 1);
	TextDrawSetShadow(CraftTextDraw[7], 0);
	TextDrawAlignment(CraftTextDraw[7], 1);
	TextDrawColor(CraftTextDraw[7], -1);
	TextDrawBackgroundColor(CraftTextDraw[7], 255);
	TextDrawBoxColor(CraftTextDraw[7], 50);
	TextDrawUseBox(CraftTextDraw[7], 1);
	TextDrawSetProportional(CraftTextDraw[7], 1);
	TextDrawSetSelectable(CraftTextDraw[7], 1);
	
	CraftTextDraw[8] = TextDrawCreate(584.000000, 30.000000, "LD_BEAT:up");
	TextDrawFont(CraftTextDraw[8], 4);
	TextDrawLetterSize(CraftTextDraw[8], 0.600000, 2.000000);
	TextDrawTextSize(CraftTextDraw[8], 23.500000, 21.000000);
	TextDrawSetOutline(CraftTextDraw[8], 1);
	TextDrawSetShadow(CraftTextDraw[8], 0);
	TextDrawAlignment(CraftTextDraw[8], 1);
	TextDrawColor(CraftTextDraw[8], -1);
	TextDrawBackgroundColor(CraftTextDraw[8], 255);
	TextDrawBoxColor(CraftTextDraw[8], 50);
	TextDrawUseBox(CraftTextDraw[8], 1);
	TextDrawSetProportional(CraftTextDraw[8], 1);
	TextDrawSetSelectable(CraftTextDraw[8], 1);

	CraftTextDraw[9] = TextDrawCreate(584.000000, 322.000000, "LD_BEAT:down");
	TextDrawFont(CraftTextDraw[9], 4);
	TextDrawLetterSize(CraftTextDraw[9], 0.600000, 2.000000);
	TextDrawTextSize(CraftTextDraw[9], 23.500000, 21.000000);
	TextDrawSetOutline(CraftTextDraw[9], 1);
	TextDrawSetShadow(CraftTextDraw[9], 0);
	TextDrawAlignment(CraftTextDraw[9], 1);
	TextDrawColor(CraftTextDraw[9], -1);
	TextDrawBackgroundColor(CraftTextDraw[9], 255);
	TextDrawBoxColor(CraftTextDraw[9], 50);
	TextDrawUseBox(CraftTextDraw[9], 1);
	TextDrawSetProportional(CraftTextDraw[9], 1);
	TextDrawSetSelectable(CraftTextDraw[9], 1);
	
	CarCraftTextDraw = TextDrawCreate(360.000000, 143.000000, "mdl-2002:car_craftback");
	TextDrawFont(CarCraftTextDraw, 4);
	TextDrawLetterSize(CarCraftTextDraw, 0.600000, 2.000000);
	TextDrawTextSize(CarCraftTextDraw, 150.000000, 174.000000);
	TextDrawSetOutline(CarCraftTextDraw, 1);
	TextDrawSetShadow(CarCraftTextDraw, 0);
	TextDrawAlignment(CarCraftTextDraw, 1);
	TextDrawColor(CarCraftTextDraw, -1);
	TextDrawBackgroundColor(CarCraftTextDraw, 255);
	TextDrawBoxColor(CarCraftTextDraw, 50);
	TextDrawUseBox(CarCraftTextDraw, 1);
	TextDrawSetProportional(CarCraftTextDraw, 1);
	TextDrawSetSelectable(CarCraftTextDraw, 0);
	
	MakeCarTextDraw = TextDrawCreate(407.000000, 291.000000, "mdl-2002:MakeCar");
	TextDrawFont(MakeCarTextDraw, 4);
	TextDrawLetterSize(MakeCarTextDraw, 0.600000, 2.000000);
	TextDrawTextSize(MakeCarTextDraw, 83.000000, 20.500000);
	TextDrawSetOutline(MakeCarTextDraw, 1);
	TextDrawSetShadow(MakeCarTextDraw, 0);
	TextDrawAlignment(MakeCarTextDraw, 1);
	TextDrawColor(MakeCarTextDraw, -1);
	TextDrawBackgroundColor(MakeCarTextDraw, 255);
	TextDrawBoxColor(MakeCarTextDraw, 50);
	TextDrawUseBox(MakeCarTextDraw, 1);
	TextDrawSetProportional(MakeCarTextDraw, 1);
	TextDrawSetSelectable(MakeCarTextDraw, 1);
	return 1;
}
FUNC::CraftDraw_OnPlayerDisconnect(playerid)
{
	forex(i,MAX_CRAFT_SHOW_LIST)
	{
		if(CraftBackBottonDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,CraftBackBottonDraw[playerid][i]);
		CraftBackBottonDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(CraftItemDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,CraftItemDraw[playerid][i]);
		CraftItemDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
	}
	forex(i,MAX_CRAFT_USE_AMOUNT)
	{
		if(CraftNeed[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,CraftNeed[playerid][i]);
		CraftNeed[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(CraftHave[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,CraftHave[playerid][i]);
		CraftHave[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
	}
	if(CraftProgress[playerid]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,CraftProgress[playerid]);
	CraftProgress[playerid]=PlayerText:INVALID_TEXT_DRAW;
    CraftTextDrawShow[playerid]=false;
    
	if(CarCraftModel[playerid]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,CarCraftModel[playerid]);
	CarCraftModel[playerid]=PlayerText:INVALID_TEXT_DRAW;
	forex(i,MAX_CARCRAFT_NEEDS)
	{
		if(CarCraftNeedThings[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,CarCraftNeedThings[playerid][i]);
		CarCraftNeedThings[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
	}
	CarCraftTextDrawShow[playerid]=false;
	return 1;
}
FUNC::CraftDraw_OnPlayerConnect(playerid)
{
    new BreakLine=0,NowLine=0;
	forex(i,MAX_CRAFT_SHOW_LIST)
	{
	    if(BreakLine>=4)
		{
			NowLine++;
			BreakLine=0;
		}
		new Float:BackGroundX=148.000000+(i-NowLine*4)*110.0;
		new Float:BackGroundY=29.000000+NowLine*105.5;
		new Float:ModelX=151.000000+(i-NowLine*4)*110.0;
		new Float:ModelY=29.000000+NowLine*105.5;
		CraftBackBottonDraw[playerid][i] = CreatePlayerTextDraw(playerid, BackGroundX, BackGroundY, "LD_SPAC:WHITE");
		PlayerTextDrawFont(playerid, CraftBackBottonDraw[playerid][i], 4);
		PlayerTextDrawLetterSize(playerid, CraftBackBottonDraw[playerid][i], 0.600000, 2.000000);
		PlayerTextDrawTextSize(playerid, CraftBackBottonDraw[playerid][i], 107.000000, 102.000000);
		PlayerTextDrawSetOutline(playerid, CraftBackBottonDraw[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, CraftBackBottonDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, CraftBackBottonDraw[playerid][i], 1);
		PlayerTextDrawColor(playerid, CraftBackBottonDraw[playerid][i], -256);
		PlayerTextDrawBackgroundColor(playerid, CraftBackBottonDraw[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, CraftBackBottonDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, CraftBackBottonDraw[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, CraftBackBottonDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, CraftBackBottonDraw[playerid][i], 1);
		
		CraftItemDraw[playerid][i] = CreatePlayerTextDraw(playerid, ModelX, ModelY, "Nowy_TextDraw");
		PlayerTextDrawFont(playerid, CraftItemDraw[playerid][i], 5);
		PlayerTextDrawLetterSize(playerid, CraftItemDraw[playerid][i], 0.600000, 2.000000);
		PlayerTextDrawTextSize(playerid, CraftItemDraw[playerid][i], 102.000000, 102.000000);
		PlayerTextDrawSetOutline(playerid, CraftItemDraw[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, CraftItemDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, CraftItemDraw[playerid][i], 1);
		PlayerTextDrawColor(playerid, CraftItemDraw[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, CraftItemDraw[playerid][i], 0);
		PlayerTextDrawBoxColor(playerid, CraftItemDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, CraftItemDraw[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, CraftItemDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, CraftItemDraw[playerid][i], 0);
		PlayerTextDrawSetPreviewModel(playerid, CraftItemDraw[playerid][i], NULL_MODEL);
		PlayerTextDrawSetPreviewRot(playerid, CraftItemDraw[playerid][i], 0.000000, 0.000000, 180.000000, 0.629998);
		PlayerTextDrawSetPreviewVehCol(playerid, CraftItemDraw[playerid][i], 1, 1);
        BreakLine++;
	}
	forex(i,MAX_CRAFT_USE_AMOUNT)
	{
		CraftNeed[playerid][i] = CreatePlayerTextDraw(playerid, 226.000000+i*84.0, 368.000000, "0");
		PlayerTextDrawFont(playerid, CraftNeed[playerid][i], 2);
		PlayerTextDrawLetterSize(playerid, CraftNeed[playerid][i], 0.333333, 1.750000);
		PlayerTextDrawTextSize(playerid, CraftNeed[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, CraftNeed[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, CraftNeed[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, CraftNeed[playerid][i], 1);
		PlayerTextDrawColor(playerid, CraftNeed[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, CraftNeed[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, CraftNeed[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, CraftNeed[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, CraftNeed[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, CraftNeed[playerid][i], 0);

		CraftHave[playerid][i] = CreatePlayerTextDraw(playerid, 226.000000+i*84.0, 394.000000, "0");
		PlayerTextDrawFont(playerid, CraftHave[playerid][i], 2);
		PlayerTextDrawLetterSize(playerid, CraftHave[playerid][i], 0.333333, 1.750000);
		PlayerTextDrawTextSize(playerid, CraftHave[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, CraftHave[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, CraftHave[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, CraftHave[playerid][i], 1);
		PlayerTextDrawColor(playerid, CraftHave[playerid][i], -16776961);
		PlayerTextDrawBackgroundColor(playerid, CraftHave[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, CraftHave[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, CraftHave[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, CraftHave[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, CraftHave[playerid][i], 0);
	}
	CraftProgress[playerid] = CreatePlayerTextDraw(playerid, 588.000000, 53.000000, "LD_SPAC:WHITE");
	PlayerTextDrawFont(playerid, CraftProgress[playerid], 4);
	PlayerTextDrawLetterSize(playerid, CraftProgress[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, CraftProgress[playerid], 17.000000, 266.000000);
	PlayerTextDrawSetOutline(playerid, CraftProgress[playerid], 1);
	PlayerTextDrawSetShadow(playerid, CraftProgress[playerid], 0);
	PlayerTextDrawAlignment(playerid, CraftProgress[playerid], 1);
	PlayerTextDrawColor(playerid, CraftProgress[playerid], 16777105);
	PlayerTextDrawBackgroundColor(playerid, CraftProgress[playerid], 255);
	PlayerTextDrawBoxColor(playerid, CraftProgress[playerid], 50);
	PlayerTextDrawUseBox(playerid, CraftProgress[playerid], 1);
	PlayerTextDrawSetProportional(playerid, CraftProgress[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, CraftProgress[playerid], 0);
	
	CarCraftModel[playerid] = CreatePlayerTextDraw(playerid, 377.000000, 123.000000, "Nowy_TextDraw");
	PlayerTextDrawFont(playerid, CarCraftModel[playerid], 5);
	PlayerTextDrawLetterSize(playerid, CarCraftModel[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, CarCraftModel[playerid], 130.000000, 130.000000);
	PlayerTextDrawSetOutline(playerid, CarCraftModel[playerid], 1);
	PlayerTextDrawSetShadow(playerid, CarCraftModel[playerid], 0);
	PlayerTextDrawAlignment(playerid, CarCraftModel[playerid], 1);
	PlayerTextDrawColor(playerid, CarCraftModel[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, CarCraftModel[playerid], 0);
	PlayerTextDrawBoxColor(playerid, CarCraftModel[playerid], 50);
	PlayerTextDrawUseBox(playerid, CarCraftModel[playerid], 1);
	PlayerTextDrawSetProportional(playerid, CarCraftModel[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, CarCraftModel[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, CarCraftModel[playerid], 411);
	PlayerTextDrawSetPreviewRot(playerid, CarCraftModel[playerid], -10.000000, 0.000000, -43.000000, 0.910000);
	PlayerTextDrawSetPreviewVehCol(playerid, CarCraftModel[playerid], 1, 1);

	forex(i,MAX_CARCRAFT_NEEDS)
	{
		CarCraftNeedThings[playerid][i] = CreatePlayerTextDraw(playerid, 463.000000, 240.000000+i*19, "0");
		PlayerTextDrawFont(playerid, CarCraftNeedThings[playerid][i], 2);
		PlayerTextDrawLetterSize(playerid, CarCraftNeedThings[playerid][i], 0.316666, 1.599999);
		PlayerTextDrawTextSize(playerid, CarCraftNeedThings[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, CarCraftNeedThings[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, CarCraftNeedThings[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, CarCraftNeedThings[playerid][i], 2);
		PlayerTextDrawColor(playerid, CarCraftNeedThings[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, CarCraftNeedThings[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, CarCraftNeedThings[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, CarCraftNeedThings[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, CarCraftNeedThings[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, CarCraftNeedThings[playerid][i], 0);
	}
	return 1;
}



