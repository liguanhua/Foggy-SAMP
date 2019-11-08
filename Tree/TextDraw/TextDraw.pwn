FUNC::TD_OnGameModeInit()
{
    PresonState_OnGameModeInit();
    Inv_OnGameModeInit();
    Come_OnGameModeInit();
    Speedo_OnGameModeInit();
    CraftDraw_OnGameModeInit();
    WeaponShow_OnGameModeInit();
    PlayerInfo_OnGameModeInit();
    QuickUse_OnGameModeInit();
    StoreDraw_OnGameModeInit();
    StrongBoxUI_OnGameModeInit();
	return 1;
}

FUNC::TD_OnPlayerRequestClass(playerid)
{
    Come_OnPlayerRequestClass(playerid);
	return 1;
}
FUNC::TD_OnPlayerConnect(playerid)
{
    PresonState_OnPlayerConnect(playerid);
    Inv_OnPlayerConnect(playerid);
    Come_OnPlayerConnect(playerid);
    Speedo_OnPlayerConnect(playerid);
    CraftDraw_OnPlayerConnect(playerid);
    WeaponShow_OnPlayerConnect(playerid);
    PlayerInfo_OnPlayerConnect(playerid);
    QuickUse_OnPlayerConnect(playerid);
    StoreDraw_OnPlayerConnect(playerid);
    StrongBoxUI_OnPlayerConnect(playerid);
	return 1;
}
FUNC::TD_OnPlayerDisconnect(playerid)
{
    Inv_OnPlayerDisconnect(playerid);
    PresonState_OnPlayerDisconnect(playerid);
    Speedo_OnPlayerDisconnect(playerid);
    Come_OnPlayerDisconnect(playerid);
    CraftDraw_OnPlayerDisconnect(playerid);
    WeaponShow_OnPlayerDisconnect(playerid);
    QuickUse_OnPlayerDisconnect(playerid);
    StoreDraw_OnPlayerDisconnect(playerid);
    StrongBoxUI_OnPlayerDisconnect(playerid);
	return 1;
}
FUNC::TD_OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate==PLAYER_STATE_DRIVER||newstate==PLAYER_STATE_PASSENGER)
	{
	    if(PlayerSpeedoShow[playerid]==false)
		{
		    new vehicleid=GetPlayerVehicleID(playerid);
			ShowPlayerSpeedo(playerid);
			if(newstate==PLAYER_STATE_DRIVER)GobalVehicleEngine[vehicleid]=true;
        }
	}
	else
	{
	    if(PlayerSpeedoShow[playerid]==true)
		{
			HidePlayerSpeedo(playerid);
		}
	}
	return 1;
}
FUNC::TD_OnPlayerClickTD(playerid, Text:clickedid)
{
    if(ComeTextDrawShow[playerid]==true)
    {
		if(clickedid==ComTextDraw[1])
		{
		    if(Account[playerid][_Register]==false)
		    {
		        SPD(playerid,_SPD_REGISTER,DIALOG_STYLE_PASSWORD,"��ӭ���� ����ĩ��","������������ע��","ȷ��","�뿪");
		    }
		    else SCM(playerid,-1,"���Ѿ�ע����,������¼��ť");
			return true;
		}
		if(clickedid==ComTextDraw[2])
		{
		    if(Account[playerid][_Register]==true)
		    {
		        SPD(playerid,_SPD_LOGIN,DIALOG_STYLE_PASSWORD,"��ӭ���� ����ĩ��","��������������¼","ȷ��","�뿪");
		    }
		    else SCM(playerid,-1,"�㻹û��ע��,����ע�ᰴť");
			return true;
		}
	}
	if(CitySelectTextDrawShow[playerid]==true)
	{
		loop(i,5,13)
		{
			if(clickedid==CitySelectTextDraw[i])
			{
				new SafeZoneID=i-5;
				if(SafeZoneID>4)
				{
				    formatex64("%s û�п���,��ѡ��С��",SafeZone[SafeZoneID][_sName]);
					SCM(playerid,-1,string64);
					return true;
				}
				else
				{
	    	    	formatex64("���Ϊ�� %s С���һԱ!",SafeZone[SafeZoneID][_sName]);
	    	    	SCM(playerid,-1,string64);
	    	    	Account[playerid][_SpawnTown]=SafeZoneID;
	    	    	UpdateAccountSpawnTown(playerid,SafeZoneID);
	    	    	HidePlayerCitySelectTextDraw(playerid);
	    	    	new Float:SpawnZ;
					CA_FindZ_For2DCoord(SafeZone[SafeZoneID][_sX],SafeZone[SafeZoneID][_sY],SpawnZ);
					SetSpawnInfo(playerid,NO_TEAM,0,SafeZone[SafeZoneID][_sX],SafeZone[SafeZoneID][_sY],SpawnZ+0.5,0.0,0,0,0,0,0,0);
					TogglePlayerSpectating(playerid,0);
                    return true;
				}
			}
		}
	}
	if(PlayerSkinSelectDrawShow[playerid]==true)
	{
	    if(clickedid==SkinSelectTextDraw[0])
	    {
		    if(PlayerSkinSelectSex[playerid]==0)PlayerSkinSelectSex[playerid]=1;
		    else PlayerSkinSelectSex[playerid]=0;
		    PlayerSkinSelectShowID[playerid]=2;
		    ShowPlayerSkinSelectTextDraw(playerid,PlayerSkinSelectSex[playerid],PlayerSkinSelectShowID[playerid]);
        	return true;
	    }
	    if(clickedid==SkinSelectTextDraw[1])
	    {
            if(PlayerSkinSelectSex[playerid]==0)Account[playerid][_Skin]=MaleSkin[PlayerSkinSelectShowID[playerid]][_SkinID];
		    else Account[playerid][_Skin]=FaMaleSkin[PlayerSkinSelectShowID[playerid]][_SkinID];
        	UpdateAccountSkin(playerid,FaMaleSkin[PlayerSkinSelectShowID[playerid]][_SkinID]);
	        HidePlayerSkinSelectTextDraw(playerid);
	        SpawnPlayer(playerid);
	        return true;
	    }
	}
	if(NavigationBarShow[playerid]==true)
	{
		if(clickedid==NavigationBar[1])
		{
		    HidePlayerNavigationBarTextDraw(playerid);
		    CancelSelectTextDrawEx(playerid);
		    new FactionID=GetPlayerFactionID(playerid);
		    if(FactionID==NONE)
		    {
		        formatex64(FACTION_INFO_PANEL,Iter_Count(Faction));
				SPD(playerid,_SPD_FACTION_TIP,DIALOG_STYLE_LIST,"�ҵ���Ӫ",string64,"ȷ��","ȡ��");
		    }
			else
			{
			    formatex64("%s",Faction[FactionID][_Name]);
				SPD(playerid,_SPD_FACTION_SET,DIALOG_STYLE_LIST,string64,FACTION_USE_PANEL,"ȷ��","ȡ��");
			}
		    return true;
		}
		if(clickedid==NavigationBar[2])
		{
		    HidePlayerNavigationBarTextDraw(playerid);
		    CancelSelectTextDrawEx(playerid);
		    if(GetPlayerHavePrivateDomainID(playerid)!=NONE)
		    {
                SPD(playerid,_SPD_PRIVATEDOMAIN_ENTER,DIALOG_STYLE_MSGBOX,"��ʾ","�Ƿ�������˽�����?","ȷ��","ȡ��");
		    }
		    else
		    {
		        SPD(playerid,_SPD_PRIVATEDOMAIN_CREATE,DIALOG_STYLE_MSGBOX,"��ʾ","�㻹û�д���˽����أ��Ƿ񴴽�?","ȷ��","ȡ��");
		    }
		    return true;
		}
		if(clickedid==NavigationBar[3])
		{
		    HidePlayerNavigationBarTextDraw(playerid);
		    ShowPlayerInfoTextDraw(playerid);
		    return true;
		}
		if(clickedid==NavigationBar[4])
		{
		    HidePlayerNavigationBarTextDraw(playerid);
	     	ShowPlayerInventoryTextDraw(playerid);
		    return true;
		}
		if(clickedid==NavigationBar[5])
		{
		    HidePlayerNavigationBarTextDraw(playerid);
	     	ShowPlayerInventoryTextDraw(playerid);
		    return true;
		}
		if(clickedid==NavigationBar[6])
		{
		    HidePlayerNavigationBarTextDraw(playerid);
		    CancelSelectTextDrawEx(playerid);
		    return true;
		}
		if(clickedid==NavigationBar[7])
		{
		    HidePlayerNavigationBarTextDraw(playerid);
		    CancelSelectTextDrawEx(playerid);
		    return true;
		}
		if(clickedid==NavigationBar[8])
		{
		    HidePlayerNavigationBarTextDraw(playerid);
		    ShowCraftTextDrawForPlayer(playerid,CRAFT_TPYE_FENCE);
		    return true;
		}
	}
	/**************************************************/
	if(CraftTextDrawShow[playerid]==true)
	{
		switch(GetPlayerInDomainState(playerid))
		{
		    case PLAYER_DOMAIN_NONE:
			{
			    CancelSelectTextDrawEx(playerid);
			    SCM(playerid,-1,"�ⲻ���������");
				return true;
			}
		    case PLAYER_DOMAIN_OTHER:
			{
			    CancelSelectTextDrawEx(playerid);
			    SCM(playerid,-1,"���Ǳ��˵����,�㲻�ܲ���!");
				return true;
			}
		    case PLAYER_DOMAIN_FACTION_FORBID:
			{
			    CancelSelectTextDrawEx(playerid);
			    SCM(playerid,-1,"������Ӫ���,��û��Ȩ�޲���1!");
				return true;
			}
		    case PLAYER_DOMAIN_FACTION_OTHER:
			{
			    CancelSelectTextDrawEx(playerid);
			    SCM(playerid,-1,"������Ӫ���,��û��Ȩ�޲���2!");
				return 0;
			}
		}
		if(clickedid==CraftTextDraw[2])
		{
		    if(CraftPrevieType[playerid]==CRAFT_TPYE_FENCE)SCM(playerid,-1,"Ŀǰ����Ŀ��ʾ��");
            else UpdateCraftPageForPlayer(playerid,1,CRAFT_TPYE_FENCE);
		    return true;
		}
		if(clickedid==CraftTextDraw[3])
		{
		    if(CraftPrevieType[playerid]==CRAFT_TPYE_HOUSE)SCM(playerid,-1,"Ŀǰ����Ŀ��ʾ��");
            else UpdateCraftPageForPlayer(playerid,1,CRAFT_TPYE_HOUSE);
		    return true;
		}
		if(clickedid==CraftTextDraw[4])
		{
		    if(CraftPrevieType[playerid]==CRAFT_TPYE_STARIS)SCM(playerid,-1,"Ŀǰ����Ŀ��ʾ��");
            else UpdateCraftPageForPlayer(playerid,1,CRAFT_TPYE_STARIS);
		    return true;
		}
		if(clickedid==CraftTextDraw[5])
		{
		    if(CraftPrevieType[playerid]==CRAFT_TPYE_DOOR)SCM(playerid,-1,"Ŀǰ����Ŀ��ʾ��");
            else UpdateCraftPageForPlayer(playerid,1,CRAFT_TPYE_DOOR);
		    return true;
		}
		if(clickedid==CraftTextDraw[6])
		{
		    if(CraftPrevieType[playerid]==CRAFT_TPYE_COFFER)SCM(playerid,-1,"Ŀǰ����Ŀ��ʾ��");
            else UpdateCraftPageForPlayer(playerid,1,CRAFT_TPYE_COFFER);
		    return true;
		}
		if(clickedid==CraftTextDraw[7])
		{
		    if(CraftPrevieType[playerid]==CRAFT_TPYE_OTHER)SCM(playerid,-1,"Ŀǰ����Ŀ��ʾ��");
            else UpdateCraftPageForPlayer(playerid,1,CRAFT_TPYE_OTHER);
		    return true;
		}
		if(clickedid==CraftTextDraw[8])//��һҳ
		{
		    SCM(playerid,-1,"��һҳ");
		    new pages=CraftPreviePage[playerid];
      		CraftPreviePage[playerid]--;
			if(CraftPreviePage[playerid]<1)CraftPreviePage[playerid]=1;
			if(pages!=CraftPreviePage[playerid])
			{
			    UpdateCraftPageForPlayer(playerid,CraftPreviePage[playerid],CraftPrevieType[playerid]);
           	}
           	return true;
		}
		if(clickedid==CraftTextDraw[9])//��һҳ
		{
		    SCM(playerid,-1,"��һҳ");
            new pages=CraftPreviePage[playerid];
            CraftPreviePage[playerid]++;
            if(CraftPreviePage[playerid]>floatround((CraftPrevieCount[playerid]-1)/float(MAX_CRAFT_SHOW_LIST),floatround_ceil))CraftPreviePage[playerid]--;
			if(pages!=CraftPreviePage[playerid])
			{
				UpdateCraftPageForPlayer(playerid,CraftPreviePage[playerid],CraftPrevieType[playerid]);
           	}
           	return true;
		}
		if(clickedid==CraftTextDraw[1])
		{
			if(CraftClickIndex[playerid]==NONE)
			{
				SCM(playerid,-1,"�㻹û��ѡ����,�޷�����");
			}
			else
			{
			    CompositeCraftThingsForPlayer(playerid,CraftClickIndex[playerid]);
			}
		    return true;
		}
	}
	/**********************************************************************/
	if(StoreTextDrawShow[playerid]==true)
	{
        if(clickedid==StoreBackGroundTextDraws[1])
        {
		    new pages=PlayerSellPreviePage[playerid];
      		PlayerSellPreviePage[playerid]--;
			if(PlayerSellPreviePage[playerid]<1)
			{
				PlayerSellPreviePage[playerid]=1;
				SCM(playerid,-1,"û����һҳ��");
			}
			if(pages!=PlayerSellPreviePage[playerid])
			{
			    if(PlayerSellClickID[playerid]!=NONE)
      			{
        			PlayerTextDrawColor(playerid, PlayerSellBackBottonDraw[playerid][PlayerSellClickID[playerid]], 2094792749);
          			PlayerTextDrawShow(playerid, PlayerSellBackBottonDraw[playerid][PlayerSellClickID[playerid]]);
				}
			    UpdatePlayerSellPage(playerid,PlayerSellStoreID[playerid],PlayerSellPreviePage[playerid]);
           	}
        }
        if(clickedid==StoreBackGroundTextDraws[2])
        {
            new pages=PlayerSellPreviePage[playerid];
            PlayerSellPreviePage[playerid]++;
            if(PlayerSellPreviePage[playerid]>floatround((PlayerSellPrevieCount[playerid]-1)/float(MAX_PLAYERSTROE_SHOW_LIST),floatround_ceil))
			{
				PlayerSellPreviePage[playerid]--;
				SCM(playerid,-1,"û����һҳ��");
            }
			if(pages!=PlayerSellPreviePage[playerid])
			{
			    if(PlayerSellClickID[playerid]!=NONE)
      			{
        			PlayerTextDrawColor(playerid, PlayerSellBackBottonDraw[playerid][PlayerSellClickID[playerid]], 2094792749);
          			PlayerTextDrawShow(playerid, PlayerSellBackBottonDraw[playerid][PlayerSellClickID[playerid]]);
				}
				UpdatePlayerSellPage(playerid,PlayerSellStoreID[playerid],PlayerSellPreviePage[playerid]);
           	}
        }
	}
	/**********************************************************************/
	if(QuickUseShow[playerid]==true&&InventoryTextDrawShow[playerid]==true)
	{
	    forex(i,MAX_PLAYER_QUICKUSE_SLOT)
		{
			if(clickedid==QuickUseBackGroundTextDraw[i])
            {
				if(ClickQuickUseID[playerid]==NONE)
                {
                	ClickQuickUseID[playerid]=i;
                 	return true;
               	}
                if(ClickQuickUseID[playerid]!=i)
                {
                	ClickQuickUseID[playerid]=i;
                	return true;
                }
                if(ClickQuickUseID[playerid]==i)
                {
                	UpdatePlayerQuickSlot(playerid,i,NONE);
                	ClickQuickUseID[playerid]=NONE;
     				return true;
         		}
    		}
	    }
	}
    if(InventoryTextDrawShow[playerid]==true)
    {
        if(clickedid==InventoryTextDraw[27])
        {
		    new pages=PlayerNearPreviePage[playerid];
      		PlayerNearPreviePage[playerid]--;
			if(PlayerNearPreviePage[playerid]<1)
			{
				PlayerNearPreviePage[playerid]=1;
				SCM(playerid,-1,"û����һҳ��");
			}
			if(pages!=PlayerNearPreviePage[playerid])
			{
			    UpdatePlayerNearPage(playerid,PlayerNearPreviePage[playerid]);
           	}
        }
        if(clickedid==InventoryTextDraw[26])
        {
            new pages=PlayerNearPreviePage[playerid];
            PlayerNearPreviePage[playerid]++;
            if(PlayerNearPreviePage[playerid]>floatround((PlayerNearPrevieCount[playerid]-1)/float(MAX_PLAYERINV_SHOW_LIST),floatround_ceil))
			{
				PlayerNearPreviePage[playerid]--;
				SCM(playerid,-1,"û����һҳ��");
            }
			if(pages!=PlayerNearPreviePage[playerid])
			{
				UpdatePlayerNearPage(playerid,PlayerNearPreviePage[playerid]);
           	}
        }
        if(clickedid==InventoryTextDraw[24])
        {
		    new pages=PlayerInvPreviePage[playerid];
      		PlayerInvPreviePage[playerid]--;
			if(PlayerInvPreviePage[playerid]<1)
			{
				PlayerInvPreviePage[playerid]=1;
				SCM(playerid,-1,"û����һҳ��");
            }
			if(pages!=PlayerInvPreviePage[playerid])
			{
			    UpdatePlayerInvPage(playerid,PlayerInvPreviePage[playerid],PlayerInvPrevieSortType[playerid]);
           	}
        }
        if(clickedid==InventoryTextDraw[25])
        {
            new pages=PlayerInvPreviePage[playerid];
            PlayerInvPreviePage[playerid]++;
            if(PlayerInvPreviePage[playerid]>floatround((PlayerInvPrevieCount[playerid]-1)/float(MAX_PLAYERINV_SHOW_LIST),floatround_ceil))
			{
				PlayerInvPreviePage[playerid]--;
				SCM(playerid,-1,"û����һҳ��");
            }
			if(pages!=PlayerInvPreviePage[playerid])
			{
				UpdatePlayerInvPage(playerid,PlayerInvPreviePage[playerid],PlayerInvPrevieSortType[playerid]);
           	}
        }
        if(clickedid==InventoryTextDraw[6])
        {
            if(PlayerInvPrevieSortType[playerid]!=0)
            {
                SCM(playerid,-1,"�������������óɹ�");
                PlayerInvPrevieSortType[playerid]=0;
                UpdatePlayerInvPage(playerid,PlayerInvPreviePage[playerid],PlayerInvPrevieSortType[playerid]);
            }
        }
        if(clickedid==InventoryTextDraw[7])
        {
            if(PlayerInvPrevieSortType[playerid]!=1)
            {
                SCM(playerid,-1,"�����ʱ���������óɹ�");
                PlayerInvPrevieSortType[playerid]=1;
                UpdatePlayerInvPage(playerid,PlayerInvPreviePage[playerid],PlayerInvPrevieSortType[playerid]);
            }
        }
    }
    if(PlayerZombieBagTextDrawShow[playerid]==true)
    {
        if(clickedid==ZombieBagTextDraws[3])
        {
		    new pages=PlayerZombieBagPreviePage[playerid];
      		PlayerZombieBagPreviePage[playerid]--;
			if(PlayerZombieBagPreviePage[playerid]<1)
			{
				PlayerZombieBagPreviePage[playerid]=1;
				SCM(playerid,-1,"û����һҳ��");
            }
			if(pages!=PlayerZombieBagPreviePage[playerid])
			{
			    UpdatePlayerZombieBagPage(playerid,PlayerZombieBagZombieID[playerid],PlayerZombieBagPreviePage[playerid]);
           	}
        }
        if(clickedid==ZombieBagTextDraws[4])
        {
            new pages=PlayerZombieBagPreviePage[playerid];
            PlayerZombieBagPreviePage[playerid]++;
            if(PlayerZombieBagPreviePage[playerid]>floatround((PlayerZombieBagPrevieCount[playerid]-1)/float(MAX_PLAYER_ZOMBIE_TEXTDRAWS),floatround_ceil))
			{
				PlayerZombieBagPreviePage[playerid]--;
				SCM(playerid,-1,"û����һҳ��");
            }
			if(pages!=PlayerZombieBagPreviePage[playerid])
			{
				UpdatePlayerZombieBagPage(playerid,PlayerZombieBagZombieID[playerid],PlayerZombieBagPreviePage[playerid]);
           	}
        }
        if(clickedid==ZombieBagTextDraws[2])
        {
            HidePlayerZombieBagTextDraw(playerid);
            CancelSelectTextDrawEx(playerid);
        }
    }
    if(CarCraftTextDrawShow[playerid]==true)
    {
        if(clickedid==MakeCarTextDraw)
        {
            new index=GetNearstVehicleWreckage(playerid);
            if(index!=NONE)
            {
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
			    new bool:Conditional=true;
				forex(i,MAX_CARCRAFT_NEEDS)
				{
			        if(NeedThings[i]>0)
					{
				        if(NeedThings[i]>HaveThings[i])
				        {
				            Conditional=false;
				        }
					}
				}
			    if(Conditional==true)
				{
                    CreateVehData(CraftVehicleList[VehicleWreckage[index][_CraftVehID]][_Key],VehicleWreckage[index][_X],VehicleWreckage[index][_Y],VehicleWreckage[index][_Z]+1.0,0.0,-1,-1,0,"�������",false);
                    DestoryVehWreSpawn(index);
			  		HideCarCraftThings(playerid);
					CancelSelectTextDrawEx(playerid);
				}
            }
        }
    }
    if(StrongBoxTextDrawShow[playerid]==true)
    {
        forex(i,sizeof(StrongBoxLockTextDraws))
        {
            if(clickedid==StrongBoxLockTextDraws[i])
            {
                OnPlayerClickStrongBoxLock(playerid,StrongBoxBoxID[playerid]);
            }
        }
    }
	return false;
}
FUNC::TD_OnPlayerClickPlayerTD(playerid, PlayerText:playertextid)
{
	if(PlayerSkinSelectDrawShow[playerid]==true)
	{
		if(playertextid==PlayerSkinSelectTextDraw[playerid][1])
		{
		    PlayerSkinSelectShowID[playerid]--;
			ShowPlayerSkinSelectTextDraw(playerid,PlayerSkinSelectSex[playerid],PlayerSkinSelectShowID[playerid]);
			return true;
		}
		if(playertextid==PlayerSkinSelectTextDraw[playerid][2])
		{
		    PlayerSkinSelectShowID[playerid]++;
		    ShowPlayerSkinSelectTextDraw(playerid,PlayerSkinSelectSex[playerid],PlayerSkinSelectShowID[playerid]);
	        return true;
		}
	}
	/*************************************************************************************/
	if(CraftTextDrawShow[playerid]==true)
	{
		switch(GetPlayerInDomainState(playerid))
		{
		    case PLAYER_DOMAIN_NONE:
			{
			    CancelSelectTextDrawEx(playerid);
			    SCM(playerid,-1,"�ⲻ���������");
				return true;
			}
		    case PLAYER_DOMAIN_OTHER:
			{
			    CancelSelectTextDrawEx(playerid);
			    SCM(playerid,-1,"���Ǳ��˵����,�㲻�ܲ���!");
				return true;
			}
		    case PLAYER_DOMAIN_FACTION_FORBID:
			{
			    CancelSelectTextDrawEx(playerid);
			    SCM(playerid,-1,"������Ӫ���,��û��Ȩ�޲���1!");
				return true;
			}
		    case PLAYER_DOMAIN_FACTION_OTHER:
			{
			    CancelSelectTextDrawEx(playerid);
			    SCM(playerid,-1,"������Ӫ���,��û��Ȩ�޲���2!");
				return 0;
			}
		}
		forex(i,MAX_CRAFT_SHOW_LIST)
		{
		    if(playertextid==CraftBackBottonDraw[playerid][i])//��������б�
		    {
	           	new pages=CraftPreviePage/*PlayerInvPreviePage*/[playerid]-1;
	            if(pages<1)pages=0;
	            new index=pages*MAX_CRAFT_SHOW_LIST+i+1;
		        ShowCraftItemNeedThings(playerid,CraftPrevieBox[playerid][index]);
		        CraftClickIndex[playerid]=CraftPrevieBox[playerid][index];
				if(CraftClickID[playerid]==NONE)
		        {
	                PlayerTextDrawColor(playerid, CraftBackBottonDraw[playerid][i], -186);
	                PlayerTextDrawShow(playerid, CraftBackBottonDraw[playerid][i]);
	            }
				else
				{
				    if(CraftClickID[playerid]!=i)
		        	{
	                	PlayerTextDrawColor(playerid, CraftBackBottonDraw[playerid][CraftClickID[playerid]], -256);
	                	PlayerTextDrawShow(playerid, CraftBackBottonDraw[playerid][CraftClickID[playerid]]);
		                PlayerTextDrawColor(playerid, CraftBackBottonDraw[playerid][i], -186);
		                PlayerTextDrawShow(playerid, CraftBackBottonDraw[playerid][i]);
	                }
				}
		        CraftClickID[playerid]=i;
		        return true;
		    }
        }
	}
	/*************************************************************************************/
    if(StrongBoxTextDrawShow[playerid]==true)
    {
		forex(i,MAX_PLAYERSTROE_SHOW_LIST)
		{
		    if(playertextid==StrongBoxBackBottonDraw[playerid][i])
		    {
				if(StrongBoxClickID[playerid]==NONE)
		        {
	                PlayerTextDrawColor(playerid, StrongBoxBackBottonDraw[playerid][i], -186);
	                PlayerTextDrawShow(playerid, StrongBoxBackBottonDraw[playerid][i]);
	            }
				else
				{
				    if(StrongBoxClickID[playerid]!=i)
		        	{
	                	PlayerTextDrawColor(playerid, StrongBoxBackBottonDraw[playerid][StrongBoxClickID[playerid]], -256);
	                	PlayerTextDrawShow(playerid, StrongBoxBackBottonDraw[playerid][StrongBoxClickID[playerid]]);
		                PlayerTextDrawColor(playerid, StrongBoxBackBottonDraw[playerid][i], -186);
		                PlayerTextDrawShow(playerid, StrongBoxBackBottonDraw[playerid][i]);
	                }
	                else
	                {
	                	PlayerTextDrawColor(playerid, StrongBoxBackBottonDraw[playerid][i], -186);
	                	PlayerTextDrawShow(playerid, StrongBoxBackBottonDraw[playerid][i]);
	                    new pages=StrongBoxPreviePage[playerid]-1;
	                    if(pages<1)pages=0;
	                    new index=pages*MAX_STRONGBOX_SHOW_LIST+i+1;
	                    OnPlayerClickStrongBoxBotton(playerid,StrongBoxBoxID[playerid],index);
	                }
				}
		        StrongBoxClickID[playerid]=i;
		    }
		}
    }
	if(StoreTextDrawShow[playerid]==true)
	{
		forex(i,MAX_PLAYERSTROE_SHOW_LIST)
		{
			if(playertextid==StoreSellBackBottonDraw[playerid][i])
		    {
				if(StoreSellClickID[playerid]==NONE)
		        {
	                PlayerTextDrawColor(playerid, StoreSellBackBottonDraw[playerid][i], -186);
	                PlayerTextDrawShow(playerid, StoreSellBackBottonDraw[playerid][i]);
	            }
				else
				{
				    if(StoreSellClickID[playerid]!=i)
		        	{
	                	PlayerTextDrawColor(playerid, StoreSellBackBottonDraw[playerid][StoreSellClickID[playerid]], 2094792749);
	                	PlayerTextDrawShow(playerid, StoreSellBackBottonDraw[playerid][StoreSellClickID[playerid]]);
		                PlayerTextDrawColor(playerid, StoreSellBackBottonDraw[playerid][i], -186);
		                PlayerTextDrawShow(playerid, StoreSellBackBottonDraw[playerid][i]);
	                }
	                else
	                {
	                	PlayerTextDrawColor(playerid, StoreSellBackBottonDraw[playerid][i], -186);
	                	PlayerTextDrawShow(playerid, StoreSellBackBottonDraw[playerid][i]);
	                    new pages=StoreSellPreviePage[playerid]-1;
	                    if(pages<1)pages=0;
	                    new index=pages*MAX_PLAYERSTROE_SHOW_LIST+i+1;
	                    OnPlayerClickStoreSellBotton(playerid,StoreSellStoreID[playerid],index);
	                }
				}
		        StoreSellClickID[playerid]=i;
		        //return true;
		    }
			if(playertextid==PlayerSellBackBottonDraw[playerid][i])
		    {
				if(PlayerSellClickID[playerid]==NONE)
		        {
	                PlayerTextDrawColor(playerid, PlayerSellBackBottonDraw[playerid][i], -186);
	                PlayerTextDrawShow(playerid, PlayerSellBackBottonDraw[playerid][i]);
	            }
				else
				{
				    if(PlayerSellClickID[playerid]!=i)
		        	{
	                	PlayerTextDrawColor(playerid, PlayerSellBackBottonDraw[playerid][PlayerSellClickID[playerid]], 2094792749);
	                	PlayerTextDrawShow(playerid, PlayerSellBackBottonDraw[playerid][PlayerSellClickID[playerid]]);
		                PlayerTextDrawColor(playerid, PlayerSellBackBottonDraw[playerid][i], -186);
		                PlayerTextDrawShow(playerid, PlayerSellBackBottonDraw[playerid][i]);
	                }
	                else
	                {
	                	PlayerTextDrawColor(playerid, PlayerSellBackBottonDraw[playerid][i], -186);
	                	PlayerTextDrawShow(playerid, PlayerSellBackBottonDraw[playerid][i]);
	                    new pages=PlayerSellPreviePage[playerid]-1;
	                    if(pages<1)pages=0;
	                    new index=pages*MAX_PLAYERSTROE_SHOW_LIST+i+1;
	                    OnPlayerClickPlayerSellBotton(playerid,PlayerSellStoreID[playerid],index);
	                }
				}
		        PlayerSellClickID[playerid]=i;
		        //return true;
		    }
		}
	}
	/*************************************************************************************/
    if(PlayerZombieBagTextDrawShow[playerid]==true)
    {
		forex(i,MAX_PLAYER_ZOMBIE_TEXTDRAWS)
		{
		    if(playertextid==PlayerZombieBagBackDraws[playerid][i])
		    {
		        if(PlayerZombieBagClickID[playerid]==NONE)
				{
					PlayerZombieBagClickID[playerid]=i;
					return true;
				}
				if(PlayerZombieBagClickID[playerid]!=i)
				{
					PlayerZombieBagClickID[playerid]=i;
					return true;
				}
				if(PlayerZombieBagClickID[playerid]==i)
				{
					PlayerInvClickID[playerid]=NONE;
                    new pages=PlayerZombieBagPreviePage[playerid]-1;
                    if(pages<1)pages=0;
                    new index=pages*MAX_PLAYER_ZOMBIE_TEXTDRAWS+i+1;
                    OnPlayerClickZBagItemBotton(playerid,PlayerZombieBagZombieID[playerid],index);
				}
            }
		}
    }
	if(InventoryTextDrawShow[playerid]==true)
	{
		forex(i,MAX_PLAYERINV_SHOW_LIST)
		{
		    if(playertextid==PlayerNearBackBottonDraw[playerid][i])//������������б�
		    {
		        new ClickInvType=GetLastClickInvType(playerid,i,INV_CLICK_TYPE_NEAR);
		        switch(ClickInvType)
		        {
				    case INV_CLICK_NONE:
				    {
						PlayerInvClickType[playerid]= INV_CLICK_TYPE_NEAR;
						PlayerInvClickID[playerid]= i;
						return true;
				    }
				    case INV_CLICK_SAME:
				    {
						PlayerInvClickType[playerid]= INV_CLICK_TYPE_BAG;
						PlayerInvClickID[playerid]= i;
	                    new pages=PlayerNearPreviePage[playerid]-1;
	                    if(pages<1)pages=0;
	                    new index=pages*MAX_PLAYERINV_SHOW_LIST+i+1;
	                    OnPlayerClickNearItemBotton(playerid,index);
	                    return true;
				    }
				    case INV_CLICK_NOT_TYPE:
				    {
						PlayerInvClickType[playerid]= INV_CLICK_TYPE_NEAR;
						PlayerInvClickID[playerid]= i;
						return true;
				    }
				    case INV_CLICK_NOT_ID:
				    {
						PlayerInvClickType[playerid]= INV_CLICK_TYPE_NEAR;
						PlayerInvClickID[playerid]= i;
						return true;
				    }
				    case INV_CLICK_NOT_ALL:
				    {
						PlayerInvClickType[playerid]= INV_CLICK_TYPE_NEAR;
						PlayerInvClickID[playerid]= i;
						return true;
				    }
		        }
		    }
		}
		forex(i,MAX_PLAYERINV_SHOW_LIST)
		{
		    if(playertextid==PlayerInvBackBottonDraw[playerid][i])//������������б�
		    {
		        new ClickInvType=GetLastClickInvType(playerid,i,INV_CLICK_TYPE_BAG);
		        switch(ClickInvType)
		        {
				    case INV_CLICK_NONE:
				    {
						PlayerInvClickType[playerid]= INV_CLICK_TYPE_BAG;
						PlayerInvClickID[playerid]= i;
						return true;
				    }
				    case INV_CLICK_SAME:
				    {
						PlayerInvClickType[playerid]= INV_CLICK_TYPE_BAG;
						PlayerInvClickID[playerid]= i;
	                    new pages=PlayerInvPreviePage[playerid]-1;
	                    if(pages<1)pages=0;
	                    new index=pages*MAX_PLAYERINV_SHOW_LIST+i+1;
	                    OnPlayerClickInvItemBotton(playerid,index);
	                    return true;
				    }
				    case INV_CLICK_NOT_TYPE:
				    {
						PlayerInvClickType[playerid]= INV_CLICK_TYPE_BAG;
						PlayerInvClickID[playerid]= i;
						return true;
				    }
				    case INV_CLICK_NOT_ID:
				    {
						PlayerInvClickType[playerid]= INV_CLICK_TYPE_BAG;
						PlayerInvClickID[playerid]= i;
						return true;
				    }
				    case INV_CLICK_NOT_ALL:
				    {
						PlayerInvClickType[playerid]= INV_CLICK_TYPE_BAG;
						PlayerInvClickID[playerid]= i;
						return true;
				    }
		        }
		    }
		}
		forex(i,MAX_PLAYER_EQUIPS)
		{
		    if(playertextid==PlayerEquipBackBottonDraw[playerid][i])//���װ�������б�
		    {
		        new ClickInvType=GetLastClickInvType(playerid,i,INV_CLICK_TYPE_EQUIP);
		        switch(ClickInvType)
		        {
				    case INV_CLICK_NONE:
				    {
						PlayerInvClickType[playerid]= INV_CLICK_TYPE_EQUIP;
						PlayerInvClickID[playerid]= i;
						return true;
				    }
				    case INV_CLICK_SAME:
				    {
						PlayerInvClickType[playerid]= INV_CLICK_TYPE_EQUIP;
						PlayerInvClickID[playerid]= i;
						if(Iter_Contains(PlayerEquip[playerid],i))
						{
						    printf("PlayerEquip:%i",i);
						    new tItemKey[37],Float:tDurable,tGetTime;
						    format(tItemKey,sizeof(tItemKey),"%s",PlayerEquip[playerid][i][_ItemKey]);
						    tDurable=PlayerEquip[playerid][i][_Durable];
						    tGetTime=PlayerEquip[playerid][i][_GetTime];
						    if(ReduceDurableForPlayerEquip(playerid,tItemKey,tDurable)==RETURN_SUCCESS)
							{
								AddItemToPlayerInv(playerid,tItemKey,1,tDurable,tGetTime,false);
							}
						}
						return true;
				    }
				    case INV_CLICK_NOT_TYPE:
				    {
						PlayerInvClickType[playerid]= INV_CLICK_TYPE_EQUIP;
						PlayerInvClickID[playerid]= i;
						return true;
				    }
				    case INV_CLICK_NOT_ID:
				    {
						PlayerInvClickType[playerid]= INV_CLICK_TYPE_EQUIP;
						PlayerInvClickID[playerid]= i;
						return true;
				    }
				    case INV_CLICK_NOT_ALL:
				    {
						PlayerInvClickType[playerid]= INV_CLICK_TYPE_EQUIP;
						PlayerInvClickID[playerid]= i;
						return true;
				    }
		        }
		    }
		}
		forex(i,MAX_PLAYER_WEAPONS)
		{
		    if(playertextid==PlayerWeaponBackBottonDraw[playerid][i])//������������б�
		    {
		        new ClickInvType=GetLastClickInvType(playerid,i,INV_CLICK_TYPE_WEAPON);
		        switch(ClickInvType)
		        {
				    case INV_CLICK_NONE:
				    {
						PlayerInvClickType[playerid]= INV_CLICK_TYPE_WEAPON;
						PlayerInvClickID[playerid]= i;
						return true;
				    }
				    case INV_CLICK_SAME:
				    {
						PlayerInvClickType[playerid]= INV_CLICK_TYPE_WEAPON;
						PlayerInvClickID[playerid]= i;
						if(Iter_Contains(PlayerWeapon[playerid],i))
						{
						    new tItemKey[37],Float:tDurable,tGetTime;
						    format(tItemKey,sizeof(tItemKey),"%s",PlayerWeapon[playerid][i][_ItemKey]);
						    tDurable=PlayerWeapon[playerid][i][_Durable];
						    tGetTime=PlayerWeapon[playerid][i][_GetTime];
						    if(ReduceDurableForPlayerWeapon(playerid,tItemKey,tDurable))
						    {
								AddItemToPlayerInv(playerid,tItemKey,1,tDurable,tGetTime,false);
							}
						}
						return true;
				    }
				    case INV_CLICK_NOT_TYPE:
				    {
						PlayerInvClickType[playerid]= INV_CLICK_TYPE_WEAPON;
						PlayerInvClickID[playerid]= i;
						return true;
				    }
				    case INV_CLICK_NOT_ID:
				    {
						PlayerInvClickType[playerid]= INV_CLICK_TYPE_WEAPON;
						PlayerInvClickID[playerid]= i;
						return true;
				    }
				    case INV_CLICK_NOT_ALL:
				    {
						PlayerInvClickType[playerid]= INV_CLICK_TYPE_WEAPON;
						PlayerInvClickID[playerid]= i;
						return true;
				    }
		        }
		    }
		}
	}
	return false;
}
FUNC::TD_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	new playerState=GetPlayerState(playerid);
    if(playerState==PLAYER_STATE_ONFOOT)
    {
		if((newkeys&KEY_SPRINT)&&(newkeys&KEY_NO))//���� ������Ϣ
	    {
	    }
		if((newkeys&KEY_SPRINT)&&(newkeys&KEY_YES))//���� ���˱���
	    {
	        ShowPlayerInventoryTextDraw(playerid);
	        return true;
	    }
		if((newkeys&KEY_SPRINT)&&(newkeys&KEY_CTRL_BACK))//���� ���˽���
	    {
	        ShowCraftTextDrawForPlayer(playerid,CRAFT_TPYE_FENCE);
	        return true;
	    }
//-------------------------------------------------------------------------//
		if((newkeys&KEY_WALK)&&(newkeys&KEY_NO))//����
	    {
	        new BagID=GetPlayerQuickSlotInvID(playerid,1);
            if(BagID!=NONE)
            {
				new ItemID=PlayerInv[playerid][BagID][_ItemID];
				formatex64("%i,%s,%i",BagID,PlayerInv[playerid][BagID][_InvKey],ItemID);
				SetPVarString(playerid,"_Bag_Click_Info",string64);
				OnPlayerInvItemUse(playerid,BagID);
            }
	        return true;
	    }
		if((newkeys&KEY_WALK)&&(newkeys&KEY_YES))//����
	    {
	        new BagID=GetPlayerQuickSlotInvID(playerid,0);
            if(BagID!=NONE)
            {
				new ItemID=PlayerInv[playerid][BagID][_ItemID];
				formatex64("%i,%s,%i",BagID,PlayerInv[playerid][BagID][_InvKey],ItemID);
				SetPVarString(playerid,"_Bag_Click_Info",string64);
				OnPlayerInvItemUse(playerid,BagID);
            }
	        return true;
	    }
		if((newkeys&KEY_WALK)&&(newkeys&KEY_CTRL_BACK))//����
	    {
	        new BagID=GetPlayerQuickSlotInvID(playerid,2);
            if(BagID!=NONE)
            {
				new ItemID=PlayerInv[playerid][BagID][_ItemID];
				formatex64("%i,%s,%i",BagID,PlayerInv[playerid][BagID][_InvKey],ItemID);
				SetPVarString(playerid,"_Bag_Click_Info",string64);
				OnPlayerInvItemUse(playerid,BagID);
            }
	        return true;
	    }
    }
    if(playerState==PLAYER_STATE_DRIVER||playerState==PLAYER_STATE_PASSENGER)
    {
		if((newkeys&KEY_HANDBRAKE)&&(newkeys&KEY_NO))//�� ������Ϣ
	    {
	    }
		if((newkeys&KEY_HANDBRAKE)&&(newkeys&KEY_YES))//�� ���˱���
	    {
	        ShowPlayerInventoryTextDraw(playerid);
	        return true;
	    }
		if((newkeys&KEY_HANDBRAKE)&&(newkeys&KEY_CTRL_BACK))//�� ���˽���
	    {
	        ShowCraftTextDrawForPlayer(playerid,CRAFT_TPYE_FENCE);
	        return true;
	    }
//-------------------------------------------------------------------------//
		if((newkeys&KEY_FIRE)&&(newkeys&KEY_NO))//��
	    {
	        new BagID=GetPlayerQuickSlotInvID(playerid,1);
            if(BagID!=NONE)
            {
				new ItemID=PlayerInv[playerid][BagID][_ItemID];
				if(Item[ItemID][_Type]==ITEM_TYPE_BOMB)
				{
                    SCM(playerid,-1,"����װ��ֻ�ܲ���ʹ��");
                    return true;
				}
				formatex64("%i,%s,%i",BagID,PlayerInv[playerid][BagID][_InvKey],ItemID);
				SetPVarString(playerid,"_Bag_Click_Info",string64);
				OnPlayerInvItemUse(playerid,BagID);
            }
	        return true;
	    }
		if((newkeys&KEY_FIRE)&&(newkeys&KEY_YES))//��
	    {
	        new BagID=GetPlayerQuickSlotInvID(playerid,0);
            if(BagID!=NONE)
            {
				new ItemID=PlayerInv[playerid][BagID][_ItemID];
				if(Item[ItemID][_Type]==ITEM_TYPE_BOMB)
				{
                    SCM(playerid,-1,"����װ��ֻ�ܲ���ʹ��");
                    return true;
				}
				formatex64("%i,%s,%i",BagID,PlayerInv[playerid][BagID][_InvKey],ItemID);
				SetPVarString(playerid,"_Bag_Click_Info",string64);
				OnPlayerInvItemUse(playerid,BagID);
            }
	        return true;
	    }
		if((newkeys&KEY_FIRE)&&(newkeys&KEY_CTRL_BACK))//��
	    {
	        new BagID=GetPlayerQuickSlotInvID(playerid,2);
            if(BagID!=NONE)
            {
				new ItemID=PlayerInv[playerid][BagID][_ItemID];
				if(Item[ItemID][_Type]==ITEM_TYPE_BOMB)
				{
                    SCM(playerid,-1,"����װ��ֻ�ܲ���ʹ��");
                    return true;
				}
				formatex64("%i,%s,%i",BagID,PlayerInv[playerid][BagID][_InvKey],ItemID);
				SetPVarString(playerid,"_Bag_Click_Info",string64);
				OnPlayerInvItemUse(playerid,BagID);
            }
	        return true;
	    }
    }
    if(PRESSED(KEY_YES))
    {
        ShowPlayerNavigationBarTextDraw(playerid);
        SelectTextDrawEx(playerid,0x408080C8);
        return true;
    }
	return false;
}
