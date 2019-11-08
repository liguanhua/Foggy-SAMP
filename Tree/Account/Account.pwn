FUNC::GetPlayerIdByName(PlayerName[])//通过名字获取玩家ID
{
    new userID;
    sscanf(PlayerName,"u",userID);
    return userID;
}
FUNC::GetPlayerAccountData(playerid)//抓取玩家帐户数据
{
	if(Account[playerid][_Login]==false)
	{
		GetPlayerNameEx(playerid,Account[playerid][_Name],24);
		/*if(CheckPlayerNameForRP(Account[playerid][_Name]))
		{*/
		ClearChat(playerid);
		new Query[128];
		format(Query,sizeof(Query),"SELECT * FROM `"MYSQL_DB_ACCOUNT"` WHERE `名字`='%s' LIMIT 1",Account[playerid][_Name]);
 		mysql_tquery(Account@Handle,Query, "OnAccountDataLoad","i",playerid);
	    /*}
	    else
		{
			SCM(playerid,-1,"你的游戏名字不符合要求[正确命名方法:Firstname_Lastname]");
			DalayKick(playerid);
		}*/
	}
	return 1;
}
FUNC::OnAccountDataLoad(playerid)//读取
{
	TextDrawShowForPlayer(playerid,ComTextDraw[1]);
	TextDrawShowForPlayer(playerid,ComTextDraw[2]);
	SelectTextDrawEx(playerid, 0xFF4040AA);
	if(cache_num_rows(Account@Handle))//账户存在
	{
		Account[playerid][_Register]=true;
	}
	else
	{
	    Account[playerid][_Register]=false;
	}
	return 1;
}

FUNC::Account_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case _SPD_LOGIN://登录
        {
    		if(!response)return true;
    		formatex64(inputtext,64);
    		SHA256_PassHash(inputtext,PASSWORD_SALT,string64,64);
		    new Query[128];
			format(Query, sizeof(Query), "SELECT * FROM `"MYSQL_DB_ACCOUNT"` WHERE `名字` = '%s' LIMIT 1",Account[playerid][_Name]);
			mysql_query(Account@Handle,Query,true);
			new TempPassWord[64+1];
			cache_get_field_content(0,"密码",TempPassWord,Account@Handle,64+1);
			if(isequal(string64,TempPassWord,false))
			{
			   	Account[playerid][_Index]=cache_get_field_content_int(0,"编号",Account@Handle);
			    cache_get_field_content(0,"密匙",Account[playerid][_Key],Account@Handle,64);
                cache_get_field_content(0,"密码",Account[playerid][_Password],Account@Handle,64);
 			    Account[playerid][_Skin]=cache_get_field_content_int(0,"皮肤",Account@Handle);
			    Account[playerid][_Cash]=cache_get_field_content_int(0,"金钱",Account@Handle);
			    Account[playerid][_Level]=cache_get_field_content_int(0,"等级",Account@Handle);
			    Account[playerid][_Exp]=cache_get_field_content_int(0,"经验",Account@Handle);
			    Account[playerid][_SpawnTown]=cache_get_field_content_int(0,"出生地",Account@Handle);
			    Account[playerid][_OfflineX]=cache_get_field_content_float(0,"离线X",Account@Handle);
			    Account[playerid][_OfflineY]=cache_get_field_content_float(0,"离线Y",Account@Handle);
			    Account[playerid][_OfflineZ]=cache_get_field_content_float(0,"离线Z",Account@Handle);
			    Account[playerid][_OfflineA]=cache_get_field_content_float(0,"离线A",Account@Handle);
			    Account[playerid][_OfflineInt]=cache_get_field_content_int(0,"离线空间",Account@Handle);
			    Account[playerid][_Hunger]=cache_get_field_content_float(0,"口渴",Account@Handle);
			    Account[playerid][_Dry]=cache_get_field_content_float(0,"饥饿",Account@Handle);
                Account[playerid][_Infection]=cache_get_field_content_int(0,"感染",Account@Handle);
				cache_get_field_content(0,"阵营密匙",PlayerFaction[playerid][_FactionKey],Account@Handle,64);
	        	PlayerFaction[playerid][_Rank]=cache_get_field_content_int(0,"阵营阶级",Account@Handle);
	        	PlayerFaction[playerid][_AuthorCraft]=cache_get_field_content_int(0,"阵营建筑许可",Account@Handle);
	        	PlayerFaction[playerid][_FactionID]=GetPlayerFactionID(playerid);

				OnAccountLoginGame(playerid);
			}
			else SPD(playerid,_SPD_LOGIN,DIALOG_STYLE_PASSWORD,"密码错误","请重新输入密码","确定","离开");
            return true;
		}
        case _SPD_REGISTER://注册
        {
		    if(!response)return true;
			if(strlen(inputtext)<6||strlen(inputtext)>10)return SPD(playerid,_SPD_REGISTER,DIALOG_STYLE_PASSWORD,"密码字符过少或过长[6-10]","请重新输入密码来登录","确定","离开");
		    SHA256_PassHash(inputtext,PASSWORD_SALT,Account[playerid][_Password],64);
		    UUID(Account[playerid][_Key], UUID_LEN);
	     	Account[playerid][_Skin]=NONE;
	      	Account[playerid][_Cash]=0;
	        Account[playerid][_Level]=0;
	        Account[playerid][_Exp]=0;
	        Account[playerid][_SpawnTown]=NONE;
	        Account[playerid][_OfflineX]=0.0;
	        Account[playerid][_OfflineY]=0.0;
	        Account[playerid][_OfflineZ]=0.0;
	        Account[playerid][_OfflineA]=0.0;
	        Account[playerid][_OfflineInt]=NONE;
		    Account[playerid][_Stamina]=100.0;
		    Account[playerid][_Hunger]=100.0;
		    Account[playerid][_Dry]=100.0;
            Account[playerid][_Infection]=0;
	        format(PlayerFaction[playerid][_FactionKey],37,"null");
	        PlayerFaction[playerid][_Rank]=0;
	        PlayerFaction[playerid][_AuthorCraft]=0;
	        PlayerFaction[playerid][_FactionID]=NONE;

			new Query[1024];
			format(Query, sizeof(Query),\
			"INSERT INTO `"MYSQL_DB_ACCOUNT"` (\
			`名字`,\
			`密匙`,\
			`密码`\
			)\
			VALUES\
			('%s','%s','%s')",\
			Account[playerid][_Name],Account[playerid][_Key],Account[playerid][_Password]);
			mysql_query(Account@Handle,Query,true);
			Account[playerid][_Index]=cache_insert_id();
			Account[playerid][_Register]=true;
			OnAccountLoginGame(playerid);
		    return true;
        }
        case _SPD_BAG_INFO:
        {
            if(!response)return true;
		    new VarString[64];
		    GetPVarString(playerid,"_Bag_Click_Info",VarString,64);
		    if(VerifyInvPVarData(playerid,VarString))
		 	{
				new BagID,BagKey[37],ItemID;
				sscanf(VarString, "p<,>is[37]i",BagID,BagKey,ItemID);
				formatex64("%s",Item[ItemID][_Name]);
				SPD(playerid,_SPD_BAG_USE,DIALOG_STYLE_LIST,string64,PLAYER_BAG_USE_PANEL,"选择","返回");
	 		}
            return true;
        }
        case _SPD_BAG_USE:
        {
            if(!response)return true;
		    new VarString[64];
		    GetPVarString(playerid,"_Bag_Click_Info",VarString,64);
		    if(VerifyInvPVarData(playerid,VarString))
		 	{
				new BagID,BagKey[37],ItemID;
				sscanf(VarString, "p<,>is[37]i",BagID,BagKey,ItemID);
		        switch(listitem)
		        {
					case 0:OnPlayerInvItemUse(playerid,BagID);
					case 1:
					{
						switch(Item[ItemID][_Type])
						{
						    case ITEM_TYPE_MEDICAL,ITEM_TYPE_FOOD,ITEM_TYPE_BOMB,ITEM_TYPE_ANTIBIOTIC:SPD(playerid,_SPD_BAG_USE_QUICKUSE,DIALOG_STYLE_LIST,"选择快捷键",PLAYER_BAG_USE_PANEL_QUICKUSE,"选择","返回");
						    default:SCM(playerid,-1,"该类型道具不支持快捷键");
						}
						
					}
					case 2:
					{
				    	switch(GetPlayerInDomainState(playerid))
						{
						    case PLAYER_DOMAIN_NONE:
							{
							    SCM(playerid,-1,"这不是领地区域");
								return true;
							}
						    case PLAYER_DOMAIN_OTHER:
							{
								SCM(playerid,-1,"这是别人的领地,你不能操作!");
								return true;
							}
						    case PLAYER_DOMAIN_FACTION_FORBID:
							{
							    SCM(playerid,-1,"这是阵营领地,你没有权限操作1!");
								return true;
							}
						    case PLAYER_DOMAIN_FACTION_OTHER:
							{
							    SCM(playerid,-1,"这是阵营领地,你没有权限操作2!");
								return true;
							}
						}
					    new index=GetNearstStrongBox(playerid);
					    if(index!=NONE)
						{
						    SPD(playerid,_SPD_NEAR_STRONGBOX,DIALOG_STYLE_TABLIST_HEADERS,"附近可用保险箱",ShowPlayerNearStrongBox(playerid,1),"选择","取消");
						}
						else SCM(playerid,-1,"你附近没有保险箱");
					}
					case 3:OnPlayerInvItemDrop(playerid,BagID);
	            }
		 	}
            return true;
        }
        case _SPD_NEAR_STRONGBOX:
        {
            if(!response)return true;
		    new VarString[64];
		    GetPVarString(playerid,"_Bag_Click_Info",VarString,64);
		    if(VerifyInvPVarData(playerid,VarString))
		 	{
				new BagID,BagKey[37],ItemID;
				sscanf(VarString, "p<,>is[37]i",BagID,BagKey,ItemID);
            
				new pager=(DialogPage[playerid]-1)*MAX_BOX_LIST;
				if(pager==0)pager = 1;
				else pager++;
				switch(listitem)
				{
				    case 0:
				  	{
				    	DialogPage[playerid]--;
				    	if(DialogPage[playerid]<1)DialogPage[playerid]=1;
				    	SPD(playerid,_SPD_NEAR_STRONGBOX,DIALOG_STYLE_TABLIST_HEADERS,"附近可用保险箱",ShowPlayerNearStrongBox(playerid,DialogPage[playerid]),"确定","取消");
					}
					case MAX_BOX_LIST+1:
					{
			    		DialogPage[playerid]++;
						SPD(playerid,_SPD_NEAR_STRONGBOX,DIALOG_STYLE_TABLIST_HEADERS,"附近可用保险箱",ShowPlayerNearStrongBox(playerid,DialogPage[playerid]),"确定","取消");
				    }
					default:
					{
						new index=DialogBox[playerid][pager+listitem-1];
						if(PlayerInv[playerid][BagID][_Amounts]>1&&Item[ItemID][_Overlap]==1)
						{
							formatex128("请输入 %s 放入ID: %04d[%s] 保险箱的数量",Item[ItemID][_Name],index,CraftBulid[index][_CName]);
							formatex64("11,%i,%s,11",index,CraftBulid[index][_Key]);
	    					SetPVarString(playerid,"_Select_BulidID_Info",string64);
	    					SPD(playerid,_SPD_BAG_PUT_AMOUNT,DIALOG_STYLE_INPUT,"放入保险箱",string128,"确定","取消");
           				}
               			else
                  		{
                            formatex128("是否将 %s 放入ID: %04d[%s] 保险箱",Item[ItemID][_Name],index,CraftBulid[index][_CName]);
							formatex64("11,%i,%s,11",index,CraftBulid[index][_Key]);
	    					SetPVarString(playerid,"_Select_BulidID_Info",string64);
							SPD(playerid,_SPD_BAG_PUT_TIP,DIALOG_STYLE_MSGBOX,"放入保险箱",string128,"确定","返回");
        				}
	/*
						
						
						formatex64("%i,%s",index,DialogBoxKey[playerid][pager+listitem-1]);
						if(VerifyNearWirelessPVarData(playerid,string64)==true)
						{
						    if(!IsPlayerHaveWirelessChannel(playerid,Faction[index][_Wireless]))
						    {
							    formatex32("%s Mhz[%s]",Faction[index][_Wireless],Faction[index][_Name]);
							    SPD(playerid,_SPD_NEAR_WIRELESS_ADD,DIALOG_STYLE_MSGBOX,string32,"是否添加该频段到你的无线电笔记?","是的","返回");
		   						SetPVarString(playerid,"_NearWireless_Click_Info",string64);
	   						}
	   						else SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误","该频段已经存在于你的无线电笔记了","好的","");
						}*/
					}
				}
            }
        }
        case _SPD_BAG_PUT_AMOUNT:
        {
            if(!response)return true;
		    new VarString[64];
		    GetPVarString(playerid,"_Bag_Click_Info",VarString,64);
        	new VarString1[64];
 			GetPVarString(playerid,"_Select_BulidID_Info",VarString1,64);
		    if(VerifyInvPVarData(playerid,VarString)&&VerifyBuildPVarData(playerid,VarString1))
		 	{
				new BagID,BagKey[37],ItemID;
				sscanf(VarString, "p<,>is[37]i",BagID,BagKey,ItemID);
				new ObjectIndex,BulidID,CraftBulidKey[37],objectidEx;
				sscanf(VarString1, "p<,>iis[37]i",ObjectIndex,BulidID,CraftBulidKey,objectidEx);
		 	    if(strval(inputtext)<=0||strval(inputtext)>PlayerInv[playerid][BagID][_Amounts])
		 	    {
					formatex128("请输入 %s 放入ID: %04d[%s] 保险箱的数量",Item[ItemID][_Name],BulidID,CraftBulid[BulidID][_CName]);
					SPD(playerid,_SPD_BAG_PUT_AMOUNT,DIALOG_STYLE_INPUT,"放入保险箱",string128,"确定","取消");
					return 1;
		 	    }
				new tItemKey[37];
				format(tItemKey,sizeof(tItemKey),"%s",Item[ItemID][_Key]);
               	if(AddItemToCraftBulidInv(playerid,BulidID,PlayerInv[playerid][BagID][_ItemKey],strval(inputtext),PlayerInv[playerid][BagID][_Durable],PlayerInv[playerid][BagID][_GetTime])==RETURN_SUCCESS)
				{
				    ReduceAmountForPlayerInv(playerid,tItemKey,strval(inputtext));
				}
				else SCM(playerid,-1,"保险箱内道具已经达到上限[尝试增加保险箱放置格数]");
			}
        }
        case _SPD_BAG_PUT_TIP:
        {
            if(!response)return true;
		    new VarString[64];
		    GetPVarString(playerid,"_Bag_Click_Info",VarString,64);
			new VarString1[64];
 			GetPVarString(playerid,"_Select_BulidID_Info",VarString1,64);
		    if(VerifyInvPVarData(playerid,VarString)&&VerifyBuildPVarData(playerid,VarString1))
		 	{
				new BagID,BagKey[37],ItemID;
				sscanf(VarString, "p<,>is[37]i",BagID,BagKey,ItemID);
				new ObjectIndex,BulidID,CraftBulidKey[37],objectidEx;
				sscanf(VarString1, "p<,>iis[37]i",ObjectIndex,BulidID,CraftBulidKey,objectidEx);
				new tItemKey[37];
				format(tItemKey,sizeof(tItemKey),"%s",Item[ItemID][_Key]);
               	if(AddItemToCraftBulidInv(playerid,BulidID,PlayerInv[playerid][BagID][_ItemKey],1,PlayerInv[playerid][BagID][_Durable],PlayerInv[playerid][BagID][_GetTime])==RETURN_SUCCESS)
				{
				    ReduceAmountForPlayerInv(playerid,tItemKey,1);
				}
				else SCM(playerid,-1,"保险箱内道具已经达到上限[尝试增加保险箱放置格数]");
			}
        }
        case _SPD_BAG_USE_QUICKUSE:
        {
            if(!response)return true;
		    new VarString[64];
		    GetPVarString(playerid,"_Bag_Click_Info",VarString,64);
		    if(VerifyInvPVarData(playerid,VarString))
		 	{
				new BagID,BagKey[37],ItemID;
				sscanf(VarString, "p<,>is[37]i",BagID,BagKey,ItemID);
				switch(Item[ItemID][_Type])
				{
				    case ITEM_TYPE_MEDICAL,ITEM_TYPE_FOOD,ITEM_TYPE_BOMB,ITEM_TYPE_ANTIBIOTIC:
				    {
				        if(PlayerInv[playerid][BagID][_QuickShow]==listitem)
				        {
				            SCM(playerid,-1,"该道具本来就是这个快捷键");
				        }
						else UpdatePlayerQuickSlot(playerid,listitem,BagID);
				    }
				    default:SCM(playerid,-1,"该类型道具不支持快捷键");
				}
			}
        }
        case _SPD_BAG_USE_BOMB:
        {
            if(!response)return true;
            if(strval(inputtext)<=0||strval(inputtext)>999)return SPD(playerid,_SPD_BAG_USE_BOMB,DIALOG_STYLE_INPUT,"设置时间过短或过长","请选择倒计时时间[单位:秒]","选择","返回");
		    new VarString[64];
		    GetPVarString(playerid,"_Bag_Click_Info",VarString,64);
		    if(VerifyInvPVarData(playerid,VarString))
		 	{
				new BagID,BagKey[37],ItemID;
				sscanf(VarString, "p<,>is[37]i",BagID,BagKey,ItemID);
				new tItemKey[37];
				format(tItemKey,sizeof(tItemKey),"%s",Item[ItemID][_Key]);
				if(ReduceAmountForPlayerInv(playerid,tItemKey,1))
				{
				    CreateBomb(playerid,tItemKey,PlayerPos[playerid][0],PlayerPos[playerid][1],PlayerPos[playerid][2]-0.5,PlayerWorld[playerid],PlayerInterior[playerid],strval(inputtext));
				}
			}
        }
        case _SPD_BAG_DROP_AMOUNT:
        {
            if(!response)return true;
		    new VarString[64];
		    GetPVarString(playerid,"_Bag_Click_Info",VarString,64);
		    if(VerifyInvPVarData(playerid,VarString))
		 	{
				new BagID,BagKey[37],ItemID;
				sscanf(VarString, "p<,>is[37]i",BagID,BagKey,ItemID);
		 	    if(strval(inputtext)<=0||strval(inputtext)>PlayerInv[playerid][BagID][_Amounts])
		 	    {
	 				formatex64("你的背包有多个 %s ,请输入丢弃的数量",Item[ItemID][_Name]);
		    		SPD(playerid,_SPD_BAG_DROP_AMOUNT,DIALOG_STYLE_INPUT,"输入的数值错误",string64,"选择","返回");
                    return true;
			 	}
				new tItemKey[37],Float:tDurable;
				format(tItemKey,sizeof(tItemKey),"%s",Item[ItemID][_Key]);
				tDurable=PlayerInv[playerid][BagID][_Durable];
				if(ReduceAmountForPlayerInv(playerid,tItemKey,strval(inputtext)))
				{
					new Float:InFrontPlayerPos[3],Float:ColPos,Float:AnglePos[2];
					if(Item[ItemID][_Overlap]==1)
					{
         				GetPlayerPos(playerid,InFrontPlayerPos[0],InFrontPlayerPos[1],InFrontPlayerPos[2]);
			        	new HaveSame=GetPlayerRangeSameItemPickup(playerid,tItemKey,5.0);
			        	if(HaveSame!=NONE)AddPickUpAmount(HaveSame,strval(inputtext));
						else
						{
							GetRandomXYInFrontOfPlayer(playerid,InFrontPlayerPos[0],InFrontPlayerPos[1],3.0);
					    	CA_FindZ_For2DCoord(InFrontPlayerPos[0],InFrontPlayerPos[1],InFrontPlayerPos[2]);
                            GetPosData(playerid);
							CreatePickUpData(tItemKey,strval(inputtext),tDurable,InFrontPlayerPos[0],InFrontPlayerPos[1],InFrontPlayerPos[2],0.0,0.0,0.0,PlayerWorld[playerid],PlayerInterior[playerid],1);
						}
					}
					else
					{
						GetRandomXYInFrontOfPlayer(playerid,InFrontPlayerPos[0],InFrontPlayerPos[1],3.0);
		   				new Float:AngleRate=floatdiv(360.0,strval(inputtext));
						forex(i,strval(inputtext))
						{
					        AnglePos[0]=InFrontPlayerPos[0];
					        AnglePos[1]=InFrontPlayerPos[1];
					        GetAngleDistancePoint(AngleRate*i,1.5,AnglePos[0],AnglePos[1]);
					        CA_FindZ_For2DCoord(AnglePos[0],AnglePos[1],ColPos);
					        GetPosData(playerid);
					    	CreatePickUpData(tItemKey,1,tDurable,AnglePos[0],AnglePos[1],ColPos,0.0,0.0,0.0,PlayerWorld[playerid],PlayerInterior[playerid],1);
						}
					}
				}
		 	}
            return true;
        }
        case _SPD_ZOMBIEBAG_INFO:
        {
            if(!response)return true;
            new VarString[64];
		    GetPVarString(playerid,"_ZombieBag_Click_Info",VarString,64);
			if(VerifyZombieBagPVarData(playerid,VarString))
		 	{
				new BagID,BagKey[37],ItemID,Zombieid;
			    sscanf(VarString, "p<,>is[37]ii",BagID,BagKey,ItemID,Zombieid);
				if(GetPlayerCurrentCapacity(playerid)+Item[ItemID][_Weight]*ZombieBag[Zombieid][BagID][_Amounts]>GetPlayerMaxCapacity(playerid))
				{
					SCM(playerid,-1,"该物品太重,你的背包放不下");
			 		return true;
			  	}
			    new tItemKey[37],Float:tDurable,tAmounts;
				format(tItemKey,sizeof(tItemKey),"%s",Item[ItemID][_Key]);
				tDurable=ZombieBag[Zombieid][BagID][_Durable];
				tAmounts=ZombieBag[Zombieid][BagID][_Amounts];

				if(Iter_Remove(ZombieBag[Zombieid],BagID))
			    {
			        ApplyAnimation(playerid,"BOMBER", "BOM_PLANT_CROUCH_IN",4.1,0,0,0,0,0,1);
			        AddItemToPlayerInv(playerid,tItemKey,tAmounts,tDurable,SERVER_RUNTIMES,true);
		            UpdatePlayerZombieBagPage(playerid,PlayerZombieBagZombieID[playerid],PlayerZombieBagPreviePage[playerid]);
					return true;
				}
			}
        }
        case _SPD_NEAR_PICKUP_INFO:
        {
            if(!response)return true;
            new VarString[64];
		    GetPVarString(playerid,"_Near_Click_Info",VarString,64);
			if(VerifyNearPVarData(playerid,VarString))
		 	{
				new NearID,NearKey[37],ItemID;
			    sscanf(VarString, "p<,>is[37]i",NearID,NearKey,ItemID);
				if(PickUp[NearID][_Amounts]>1&&Item[ItemID][_Overlap]==1)
				{
					formatex64("%s",Item[ItemID][_Name]);
					SPD(playerid,_SPD_NEAR_PICKUP_AMOUNT,DIALOG_STYLE_INPUT,string64,"该物品有多个,请输入拾取的数量","选择","返回");
				}
				else
				{
		            if(GetPlayerCurrentCapacity(playerid)+Item[ItemID][_Weight]>GetPlayerMaxCapacity(playerid))
		            {
		                SCM(playerid,-1,"你的背包超重了,装不下");
		            }
		            else
		            {
					    new tItemKey[37],Float:tDurable;
						format(tItemKey,sizeof(tItemKey),"%s",Item[ItemID][_Key]);
						tDurable=PickUp[NearID][_Durable];
		                if(DestoryPickUp(NearID)==RETURN_SUCCESS)
		                {
		                	AddItemToPlayerInv(playerid,tItemKey,1,tDurable,SERVER_RUNTIMES,true);
		                }
		            }
				}
			}
        }
        case _SPD_NEAR_PICKUP_AMOUNT:
        {
            if(!response)return true;
            new VarString[64];
		    GetPVarString(playerid,"_Near_Click_Info",VarString,64);
			if(VerifyNearPVarData(playerid,VarString))
		 	{
				new NearID,NearKey[37],ItemID;
			    sscanf(VarString, "p<,>is[37]i",NearID,NearKey,ItemID);
			    if(strval(inputtext)<=0||strval(inputtext)>PickUp[NearID][_Amounts])
			    {
					formatex64("%s",Item[ItemID][_Name]);
					SPD(playerid,_SPD_NEAR_PICKUP_AMOUNT,DIALOG_STYLE_INPUT,"输入的数值错误","该物品有多个,请输入拾取的数量","选择","返回");
                    return true;
			    }
	            if(GetPlayerCurrentCapacity(playerid)+Item[ItemID][_Weight]*strval(inputtext)>GetPlayerMaxCapacity(playerid))
	            {
	                SCM(playerid,-1,"你的背包超重了,装不下");
	                return true;
	            }
	            else
	            {
				    new tItemKey[37],Float:tDurable;
					format(tItemKey,sizeof(tItemKey),"%s",Item[ItemID][_Key]);
					tDurable=PickUp[NearID][_Durable];
					AddPickUpAmount(NearID,-strval(inputtext));
                	AddItemToPlayerInv(playerid,tItemKey,strval(inputtext),tDurable,SERVER_RUNTIMES,true);
                	return true;
	            }
			}
        }
        case _SPD_GM_ADD_PICKUP:
        {
            if(!response)return true;
			new pager=(DialogPage[playerid]-1)*MAX_BOX_LIST;
			if(pager==0)pager = 1;
			else pager++;
			switch(listitem)
			{
			    case 0:
			  	{
			    	DialogPage[playerid]--;
			    	if(DialogPage[playerid]<1)DialogPage[playerid]=1;
			    	SPD(playerid,_SPD_GM_ADD_PICKUP,DIALOG_STYLE_TABLIST_HEADERS,"添加拾取点",ShowItems(playerid,DialogPage[playerid]),"确定","取消");
				}
				case MAX_BOX_LIST+1:
				{
		    		DialogPage[playerid]++;
					SPD(playerid,_SPD_GM_ADD_PICKUP,DIALOG_STYLE_TABLIST_HEADERS,"添加拾取点",ShowItems(playerid,DialogPage[playerid]),"确定","取消");
			    }
				default:
				{
					new index=DialogBox[playerid][pager+listitem-1];
    				if(Iter_Count(PickUpSpawn)>=MAX_PICKUP_SPAWNS)return Debug(playerid,"拾取点已到上限,请修改MAX_PICKUP_SPAWNS");
			    	new i=Iter_Free(PickUpSpawn);
			    	CA_FindZ_For2DCoord(PlayerPos[playerid][0],PlayerPos[playerid][1],PlayerPos[playerid][2]);

			       	PickUpSpawn[i][_X]=PlayerPos[playerid][0];
			       	PickUpSpawn[i][_Y]=PlayerPos[playerid][1];
			       	PickUpSpawn[i][_Z]=PlayerPos[playerid][2];
			       	PickUpSpawn[i][_RX]=0.0;
			       	PickUpSpawn[i][_RY]=0.0;
			       	PickUpSpawn[i][_RZ]=0.0;
			       	format(PickUpSpawn[i][_ItemKey],37,Item[index][_Key]);
			       	if(Item[index][_Overlap])PickUpSpawn[i][_Amount]=GetPVarInt(playerid,"admin_addpickup_amount");
			       	else PickUpSpawn[i][_Amount]=1;
			        Iter_Add(PickUpSpawn,i);
					formatex1024("INSERT INTO `"MYSQL_DB_PICKUP_SPAWNS"` (\
									`X坐标`,\
									`Y坐标`,\
									`Z坐标`,\
									`RX坐标`,\
									`RY坐标`,\
									`RZ坐标`,\
									`数量`,\
									`道具Key`)\
									VALUES\
									('%f','%f','%f','%f','%f','%f','%i','%s')",\
									PickUpSpawn[i][_X],PickUpSpawn[i][_Y],PickUpSpawn[i][_Z],0.0,0.0,0.0,PickUpSpawn[i][_Amount],PickUpSpawn[i][_ItemKey]);
					mysql_query(Static@Handle,string1024,false);
					GetPosData(playerid);
					CreatePickUpData(Item[index][_Key],PickUpSpawn[i][_Amount],100.0,PickUpSpawn[i][_X],PickUpSpawn[i][_Y],PickUpSpawn[i][_Z],0.0,0.0,0.0,PlayerWorld[playerid],PlayerInterior[playerid],0);
				}
			}
        }
        case _SPD_GM_ADD_VEH:
        {
            if(!response)return true;
			new pager=(DialogPage[playerid]-1)*MAX_BOX_LIST;
			if(pager==0)pager = 1;
			else pager++;
			switch(listitem)
			{
			    case 0:
			  	{
			    	DialogPage[playerid]--;
			    	if(DialogPage[playerid]<1)DialogPage[playerid]=1;
			    	SPD(playerid,_SPD_GM_ADD_VEH,DIALOG_STYLE_TABLIST_HEADERS,"添加汽车",ShowCraftVehicles(playerid,DialogPage[playerid]),"确定","取消");
				}
				case MAX_BOX_LIST+1:
				{
		    		DialogPage[playerid]++;
					SPD(playerid,_SPD_GM_ADD_VEH,DIALOG_STYLE_TABLIST_HEADERS,"添加汽车",ShowCraftVehicles(playerid,DialogPage[playerid]),"确定","取消");
			    }
				default:
				{
					new index=DialogBox[playerid][pager+listitem-1];
   					CA_FindZ_For2DCoord(PlayerPos[playerid][0],PlayerPos[playerid][1],PlayerPos[playerid][2]);
                    CreateVehData(CraftVehicleList[index][_Key],PlayerPos[playerid][0],PlayerPos[playerid][1],PlayerPos[playerid][2]+3.0,0.0,-1,-1,0,"GM添加",false);
				}
			}
        }
        case _SPD_PRIVATEDOMAIN_ENTER:
        {
            if(!response)return true;
            if(GetPlayerInDomainState(playerid)==PLAYER_DOMAIN_OWNER)return SCM(playerid,-1,"你已经在你的领地中");
			new PrivateDomainID=GetPlayerHavePrivateDomainID(playerid);
            if(PrivateDomainID!=NONE)SetPlayerPosEx(playerid,PrivateDomain[PrivateDomainID][_OutX],PrivateDomain[PrivateDomainID][_OutY],PrivateDomain[PrivateDomainID][_OutZ],0.0,0,0,2000,0.5,false);
        }
        case _SPD_PRIVATEDOMAIN_CREATE:
        {
            if(!response)return true;
            CreatePrivateDomainData(playerid,"私人领地",PlayerPos[playerid][0],PlayerPos[playerid][1],PlayerPos[playerid][2]);
        }
        case _SPD_MY_WIRELESS:
        {
            if(!response)return true;
			new pager=(DialogPage[playerid]-1)*MAX_BOX_LIST;
			if(pager==0)pager = 1;
			else pager++;
			switch(listitem)
			{
			    case 0:
			  	{
			    	DialogPage[playerid]--;
			    	if(DialogPage[playerid]<1)DialogPage[playerid]=1;
			    	SPD(playerid,_SPD_MY_WIRELESS,DIALOG_STYLE_TABLIST_HEADERS,"无线电笔记",ShowPlayerWireless(playerid,DialogPage[playerid]),"确定","取消");
				}
				case MAX_BOX_LIST+1:
				{
		    		DialogPage[playerid]++;
					SPD(playerid,_SPD_MY_WIRELESS,DIALOG_STYLE_TABLIST_HEADERS,"无线电笔记",ShowPlayerWireless(playerid,DialogPage[playerid]),"确定","取消");
			    }
				default:
				{
					new index=DialogBox[playerid][pager+listitem-1];
					formatex64("%i,%s",index,DialogBoxKey[playerid][pager+listitem-1]);
					if(VerifyWirelessPVarData(playerid,string64)==true)
					{
   						SetPVarString(playerid,"_PlayerWireless_Click_Info",string64);
					}
				}
			}
        }
        case _SPD_NEAR_WIRELESS:
        {
            if(!response)return true;
			new pager=(DialogPage[playerid]-1)*MAX_BOX_LIST;
			if(pager==0)pager = 1;
			else pager++;
			switch(listitem)
			{
			    case 0:
			  	{
			    	DialogPage[playerid]--;
			    	if(DialogPage[playerid]<1)DialogPage[playerid]=1;
			    	SPD(playerid,_SPD_NEAR_WIRELESS,DIALOG_STYLE_TABLIST_HEADERS,"附近无线电信号",ShowPlayerNearWireless(playerid,DialogPage[playerid]),"确定","取消");
				}
				case MAX_BOX_LIST+1:
				{
		    		DialogPage[playerid]++;
					SPD(playerid,_SPD_NEAR_WIRELESS,DIALOG_STYLE_TABLIST_HEADERS,"附近无线电信号",ShowPlayerNearWireless(playerid,DialogPage[playerid]),"确定","取消");
			    }
				default:
				{
					new index=DialogBox[playerid][pager+listitem-1];
					formatex64("%i,%s",index,DialogBoxKey[playerid][pager+listitem-1]);
					if(VerifyNearWirelessPVarData(playerid,string64)==true)
					{
					    if(!IsPlayerHaveWirelessChannel(playerid,Faction[index][_Wireless]))
					    {
						    formatex32("%s Mhz[%s]",Faction[index][_Wireless],Faction[index][_Name]);
						    SPD(playerid,_SPD_NEAR_WIRELESS_ADD,DIALOG_STYLE_MSGBOX,string32,"是否添加该频段到你的无线电笔记?","是的","返回");
	   						SetPVarString(playerid,"_NearWireless_Click_Info",string64);
   						}
   						else SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误","该频段已经存在于你的无线电笔记了","好的","");
					}
				}
			}
        }
        case _SPD_GPS_REUSE:
        {
            if(!response)return true;
            new Float:GpsPos[3];
		    new VarString[64];
		    GetPVarString(playerid,"_Gps_Pos_Info",VarString,64);
            sscanf(VarString, "p<,>fff",GpsPos[0],GpsPos[1],GpsPos[2]);
			ForcePlayerEndLastRoute(playerid);
			playerHasGPSActive[playerid] = true;
			AssignatePlayerPath(playerid, GpsPos[0], GpsPos[1], GpsPos[2]);
			playerMapPos[playerid][0]=GpsPos[0];
			playerMapPos[playerid][1]=GpsPos[1];
			playerMapPos[playerid][2]=GpsPos[2];
			Timer:PlayerGPSTimer[playerid] =SetTimerEx("UpdatePlayerPath", GPS_UPDATE_TIME, true, "ifff", playerid, GpsPos[0], GpsPos[1], GpsPos[2]);
        }
        case _SPD_GPS_USE:
        {
            if(!response)return true;
            new Float:GpsPos[3];
		    new VarString[64];
		    GetPVarString(playerid,"_Gps_Pos_Info",VarString,64);
            sscanf(VarString, "p<,>fff",GpsPos[0],GpsPos[1],GpsPos[2]);
			ForcePlayerEndLastRoute(playerid);
			playerHasGPSActive[playerid] = true;
			AssignatePlayerPath(playerid, GpsPos[0], GpsPos[1], GpsPos[2]);
			playerMapPos[playerid][0]=GpsPos[0];
			playerMapPos[playerid][1]=GpsPos[1];
			playerMapPos[playerid][2]=GpsPos[2];
			Timer:PlayerGPSTimer[playerid] =SetTimerEx("UpdatePlayerPath", GPS_UPDATE_TIME, true, "ifff", playerid, GpsPos[0], GpsPos[1], GpsPos[2]);
        }
        case _SPD_CRAFTBULID_MOVE_DELAY:
        {
		    if(!response)
			{
			    CancelEdit(playerid);
				return true;
			}
		    new VarString[64];
	 		GetPVarString(playerid,"_Select_BulidID_Info",VarString,64);
	 		if(VerifyBuildPVarData(playerid,VarString)==true)
	        {
	        	new ObjectIndex,BulidID,CraftBulidKey[37],objectid;
				sscanf(VarString, "p<,>iis[37]i",ObjectIndex,BulidID,CraftBulidKey,objectid);
				new BuildMoveSpeed;
				if(sscanf(inputtext, "i",BuildMoveSpeed))return SPD(playerid,_SPD_CRAFTBULID_MOVE_DELAY,DIALOG_STYLE_INPUT,"设置延时","延时不能小于0或大于50","确定","返回");
    			if(BuildMoveSpeed<=0||BuildMoveSpeed>50)return SPD(playerid,_SPD_CRAFTBULID_MOVE_DELAY,DIALOG_STYLE_INPUT,"设置延时","延时不能小于0或大于50","确定","返回");
                CraftBulid[BulidID][_CDelaymove]=BuildMoveSpeed;
				formatex1024("UPDATE `"MYSQL_DB_CRAFTBULID"` SET `移动延时`='%i' WHERE  `"MYSQL_DB_CRAFTBULID"`.`密匙` ='%s'",CraftBulid[BulidID][_CDelaymove],CraftBulid[BulidID][_Key]);
				mysql_query(Account@Handle,string1024,false);
                if(IsDynamicObjectMoving(objectid))StopDynamicObject(objectid);
				CA_SetObjectPos_DC(CraftBulid[BulidID][_CobjectIndex],CraftBulid[BulidID][_Cx],CraftBulid[BulidID][_Cy],CraftBulid[BulidID][_Cz]);
				CA_SetObjectRot_DC(CraftBulid[BulidID][_CobjectIndex],CraftBulid[BulidID][_Crx],CraftBulid[BulidID][_Cry],CraftBulid[BulidID][_Crz]);
                CraftBulid[BulidID][_CraftMoveIng]=0;
                CancelEdit(playerid);
			}
			else
	        {
  			    CancelEdit(playerid);
	        }
        }
        case _SPD_CRAFTBULID_MOVE_DISTANCE:
        {
		    if(!response)
			{
			    CancelEdit(playerid);
				return true;
			}
		    new VarString[64];
	 		GetPVarString(playerid,"_Select_BulidID_Info",VarString,64);
	 		if(VerifyBuildPVarData(playerid,VarString)==true)
	        {
	        	new ObjectIndex,BulidID,CraftBulidKey[37],objectid;
				sscanf(VarString, "p<,>iis[37]i",ObjectIndex,BulidID,CraftBulidKey,objectid);
				new Float:BuildMoveSpeed;
				if(sscanf(inputtext, "f",BuildMoveSpeed))return SPD(playerid,_SPD_CRAFTBULID_MOVE_SPEED,DIALOG_STYLE_INPUT,"设置移动范围","移动范围不能小于3或大于50","确定","返回");
    			if(BuildMoveSpeed<3.0||BuildMoveSpeed>50.0)return SPD(playerid,_SPD_CRAFTBULID_MOVE_SPEED,DIALOG_STYLE_INPUT,"设置移动范围","移动范围不能小于3或大于50","确定","返回");
                CraftBulid[BulidID][_Cmdistance]=BuildMoveSpeed;
				formatex1024("UPDATE `"MYSQL_DB_CRAFTBULID"` SET `移动范围`='%0.2f' WHERE  `"MYSQL_DB_CRAFTBULID"`.`密匙` ='%s'",CraftBulid[BulidID][_Cmdistance],CraftBulid[BulidID][_Key]);
				mysql_query(Account@Handle,string1024,false);
                DestoryCraftBulidModel(BulidID);
                CreateCraftBulidModel(BulidID);
                CancelEdit(playerid);
			}
			else
	        {
  			    CancelEdit(playerid);
	        }
        }
        case _SPD_CRAFTBULID_MOVE_SPEED:
        {
		    if(!response)
			{
			    CancelEdit(playerid);
				return true;
			}
		    new VarString[64];
	 		GetPVarString(playerid,"_Select_BulidID_Info",VarString,64);
	 		if(VerifyBuildPVarData(playerid,VarString)==true)
	        {
	        	new ObjectIndex,BulidID,CraftBulidKey[37],objectid;
				sscanf(VarString, "p<,>iis[37]i",ObjectIndex,BulidID,CraftBulidKey,objectid);
				new Float:BuildMoveSpeed;
				if(sscanf(inputtext, "f",BuildMoveSpeed))return SPD(playerid,_SPD_CRAFTBULID_MOVE_SPEED,DIALOG_STYLE_INPUT,"设置速度","速度不能小于0或大于50","确定","返回");
    			if(BuildMoveSpeed<=0.0||BuildMoveSpeed>50.0)return SPD(playerid,_SPD_CRAFTBULID_MOVE_SPEED,DIALOG_STYLE_INPUT,"设置速度","速度不能小于0或大于50","确定","返回");
                CraftBulid[BulidID][_Cspeed]=BuildMoveSpeed;
				formatex1024("UPDATE `"MYSQL_DB_CRAFTBULID"` SET `速度`='%0.2f' WHERE  `"MYSQL_DB_CRAFTBULID"`.`密匙` ='%s'",CraftBulid[BulidID][_Cspeed],CraftBulid[BulidID][_Key]);
				mysql_query(Account@Handle,string1024,false);
                if(IsDynamicObjectMoving(objectid))StopDynamicObject(objectid);
				CA_SetObjectPos_DC(CraftBulid[BulidID][_CobjectIndex],CraftBulid[BulidID][_Cx],CraftBulid[BulidID][_Cy],CraftBulid[BulidID][_Cz]);
				CA_SetObjectRot_DC(CraftBulid[BulidID][_CobjectIndex],CraftBulid[BulidID][_Crx],CraftBulid[BulidID][_Cry],CraftBulid[BulidID][_Crz]);
                CraftBulid[BulidID][_CraftMoveIng]=0;
                CancelEdit(playerid);
			}
			else
	        {
  			    CancelEdit(playerid);
	        }
        }
        case _SPD_CRAFTBULID_MARK_NAME:
        {
		    if(!response)
			{
			    CancelEdit(playerid);
				return true;
			}
		    new VarString[64];
	 		GetPVarString(playerid,"_Select_BulidID_Info",VarString,64);
	 		if(VerifyBuildPVarData(playerid,VarString)==true)
	        {
	        	new ObjectIndex,BulidID,CraftBulidKey[37],objectid;
				sscanf(VarString, "p<,>iis[37]i",ObjectIndex,BulidID,CraftBulidKey,objectid);
                if(strlen(inputtext)>10)return SPD(playerid,_SPD_CRAFTBULID_MARK_NAME,DIALOG_STYLE_INPUT,"字符过大","请输入自定义名字[最大10个字符/中文5个]","确定","返回");
                format(CraftBulid[BulidID][_CName],16,inputtext);
 				formatex128("UPDATE `"MYSQL_DB_CRAFTBULID"` SET  `别名` = '%s' WHERE  `"MYSQL_DB_CRAFTBULID"`.`密匙` ='%s'",CraftBulid[BulidID][_CName],CraftBulid[BulidID][_Key]);
				mysql_query(Account@Handle,string128,false);
				if(IsValidDynamic3DTextLabel(CraftBulid[BulidID][_C3dtext]))
				{
					UpdateCraftBulidText(BulidID);
				}
	        }
			else
	        {
  			    CancelEdit(playerid);
	        }
        }
		case _SPD_CRAFTBULID_MOVE:
		{
		    if(!response)
			{
			    CancelEdit(playerid);
				return true;
			}
		    new VarString[64];
	 		GetPVarString(playerid,"_Select_BulidID_Info",VarString,64);
	 		if(VerifyBuildPVarData(playerid,VarString)==true)
	        {
	        	new ObjectIndex,BulidID,CraftBulidKey[37],objectid;
				sscanf(VarString, "p<,>iis[37]i",ObjectIndex,BulidID,CraftBulidKey,objectid);
	            switch(listitem)
	            {
					case 0:
					{
						DomainEnter[playerid][_EditID]=BulidID;
						DomainEnter[playerid][_Move]=true;
						EditDynamicObject(playerid, objectid);
						printf("1 - %s",string64);
						UpdateDynamic3DTextLabelText(CraftBulid[BulidID][_C3dtext],-1,"");
						formatex32("你正在编辑建筑物 %04d[%s] ",BulidID,CraftBulid[BulidID][_CName]);
						SCM(playerid,-1,string32);
     				}
     				case 1:
     				{
     				    formatex64("当前速度 %0.1f,请设置新的速度",CraftBulid[BulidID][_Cspeed]);
     				    SPD(playerid,_SPD_CRAFTBULID_MOVE_SPEED,DIALOG_STYLE_INPUT,"设置速度",string64,"确定","返回");
    				}
     				case 2:
     				{
     				    formatex64("当前延时 %i秒,请设置新的延时",CraftBulid[BulidID][_CDelaymove]);
     				    SPD(playerid,_SPD_CRAFTBULID_MOVE_DELAY,DIALOG_STYLE_INPUT,"设置延时",string64,"确定","返回");

     				}
     				case 3:
     				{
     				    formatex64("当前移动检测范围 %0.1f,请设置新的范围",CraftBulid[BulidID][_Cmdistance]);
     				    SPD(playerid,_SPD_CRAFTBULID_MOVE_DISTANCE,DIALOG_STYLE_INPUT,"设置范围",string64,"确定","返回");

     				}
     				case 4:
     				{
						CraftBulid[BulidID][_Cmx]=0.0;
		    			CraftBulid[BulidID][_Cmy]=0.0;
		    			CraftBulid[BulidID][_Cmz]=0.0;
		    			CraftBulid[BulidID][_Cmrx]=0.0;
		    			CraftBulid[BulidID][_Cmry]=0.0;
		    			CraftBulid[BulidID][_Cmrz]=0.0;
	                    CraftBulid[BulidID][_Cmove]=0;
	                    CraftBulid[BulidID][_Cspeed]=0.0;
		    			formatex1024("UPDATE `"MYSQL_DB_CRAFTBULID"` SET \
						 `移动X坐标`='%0.2f',\
						 `移动Y坐标`='%0.2f',\
						 `移动Z坐标`='%0.2f',\
						 `移动RX坐标`='%0.2f',\
						 `移动RY坐标`='%0.2f',\
						 `移动RZ坐标`='%0.2f',\
						 `是否移动`='%i',\
						 `速度`='%0.2f' \
						  WHERE  `"MYSQL_DB_CRAFTBULID"`.`密匙` ='%s'",0.0,0.0,0.0,0.0,0.0,0.0,0,0.0,CraftBulid[BulidID][_Key]);
						mysql_query(Account@Handle,string1024,false);
                        if(IsDynamicObjectMoving(objectid))StopDynamicObject(objectid);
						CA_SetObjectPos_DC(CraftBulid[BulidID][_CobjectIndex],CraftBulid[BulidID][_Cx],CraftBulid[BulidID][_Cy],CraftBulid[BulidID][_Cz]);
						CA_SetObjectRot_DC(CraftBulid[BulidID][_CobjectIndex],CraftBulid[BulidID][_Crx],CraftBulid[BulidID][_Cry],CraftBulid[BulidID][_Crz]);
                        CraftBulid[BulidID][_CraftMoveIng]=0;
                        CancelEdit(playerid);
     				}
				}
			}
			else
	        {
  			    CancelEdit(playerid);
	        }
		}
		case _SPD_CRAFTBULID_USE:
		{
		    if(!response)
			{
			    CancelEdit(playerid);
				return true;
			}
		    new VarString[64];
	 		GetPVarString(playerid,"_Select_BulidID_Info",VarString,64);
	 		if(VerifyBuildPVarData(playerid,VarString)==true)
	        {
	        	new ObjectIndex,BulidID,CraftBulidKey[37],objectid;
				sscanf(VarString, "p<,>iis[37]i",ObjectIndex,BulidID,CraftBulidKey,objectid);
	            switch(listitem)
	            {
					case 0:
					{
						DomainEnter[playerid][_EditID]=BulidID;
						DomainEnter[playerid][_Move]=false;
						EditDynamicObject(playerid, objectid);
						printf("1 - %s",string64);
						UpdateDynamic3DTextLabelText(CraftBulid[BulidID][_C3dtext],-1,"");
						formatex32("你正在编辑建筑物 %04d[%s] ",BulidID,CraftBulid[BulidID][_CName]);
						SCM(playerid,-1,string32);
					}
					case 1:
					{
					    if(CraftItem[CraftBulid[BulidID][_CraftItemID]][_Type]!=CRAFT_TPYE_DOOR)return SCM(playerid,-1,"只有门类型建筑可以设置移动");
					    SPD(playerid,_SPD_CRAFTBULID_MOVE,DIALOG_STYLE_LIST,"移动设置",CRAFTBULID_MOVE_PANEL,"选择","返回");
					}
					case 2:
					{
					    if(CraftItem[CraftBulid[BulidID][_CraftItemID]][_Type]!=CRAFT_TPYE_COFFER)return SCM(playerid,-1,"只有保险箱类型建筑可以设置仓库");
                        ShowPlayerStrongBoxTextDraw(playerid,BulidID);
					}
					case 3:
					{
                        SPD(playerid,_SPD_CRAFTBULID_MARK_NAME,DIALOG_STYLE_INPUT,"标记命名","请输入自定义名字[最大10个字符/中文5个]","确定","返回");
					}
					case 4:
					{
                        CancelEdit(playerid);
                        DestoryCraftBulidModel(BulidID);
                        DestoryCraftBulid(BulidID);
					}
				}
	        }
	        else
	        {
  			    CancelEdit(playerid);
	        }
		}
		case _SPD_STORESELL_AMOUNT:
		{
			if(!response)return true;
			if(strval(inputtext)<=0)return SPD(playerid,_SPD_STORESELL_AMOUNT,DIALOG_STYLE_INPUT,"购买商品","数值不能小于1","购买","不买了");
			new VarString[128];
    		GetPVarString(playerid,"_StoreSell_Click_Info",VarString,128);
		    if(VerifyStoreSellPVarData(playerid,VarString))
		 	{
				new StoreID,StoreKey[37],StoreSellID,StoreSellKey[37];
			    sscanf(VarString, "p<,>is[37]is[37]",StoreID,StoreKey,StoreSellID,StoreSellKey);
			    if(strval(inputtext)>StoreSells[StoreID][StoreSellID][_Amount])return SPD(playerid,_SPD_STORESELL_AMOUNT,DIALOG_STYLE_INPUT,"购买商品","数值太大,没有那么多库存","购买","不买了");
				if(GetPlayerCurrentCapacity(playerid)+Item[StoreSells[StoreID][StoreSellID][_ItemID]][_Weight]*strval(inputtext)>GetPlayerMaxCapacity(playerid))
            	{
                	SCM(playerid,-1,"该物品太重,你的背包放不下");
                	return true;
            	}
	            new tItemKey[37],tAmounts;
				format(tItemKey,sizeof(tItemKey),"%s",Item[StoreSells[StoreID][StoreSellID][_ItemID]][_Key]);
				tAmounts=strval(inputtext);
            	if(ReduceStoreSellForStore(playerid,StoreID,StoreSellID,strval(inputtext))==RETURN_SUCCESS)
            	{
					AddItemToPlayerInv(playerid,tItemKey,tAmounts,100.0,SERVER_RUNTIMES,false);
			        if(StoreTextDrawShow[playerid]==true)
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
		}
		case _SPD_STORESELL_TIP:
		{
			if(!response)return true;
			new VarString[128];
    		GetPVarString(playerid,"_StoreSell_Click_Info",VarString,128);
		    if(VerifyStoreSellPVarData(playerid,VarString))
		 	{
				new StoreID,StoreKey[37],StoreSellID,StoreSellKey[37];
			    sscanf(VarString, "p<,>is[37]is[37]",StoreID,StoreKey,StoreSellID,StoreSellKey);
				if(GetPlayerCurrentCapacity(playerid)+Item[StoreSells[StoreID][StoreSellID][_ItemID]][_Weight]>GetPlayerMaxCapacity(playerid))
            	{
                	SCM(playerid,-1,"该物品太重,你的背包放不下");
                	return true;
            	}
	            new tItemKey[37];
				format(tItemKey,sizeof(tItemKey),"%s",Item[StoreSells[StoreID][StoreSellID][_ItemID]][_Key]);
            	if(ReduceStoreSellForStore(playerid,StoreID,StoreSellID,1)==RETURN_SUCCESS)
            	{
					AddItemToPlayerInv(playerid,tItemKey,1,100.0,SERVER_RUNTIMES,false);
			        if(StoreTextDrawShow[playerid]==true)
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
		}
		case _SPD_PLAYERSELL_AMOUNT:
		{
		    if(!response)return true;
		    new VarString[64];
		    GetPVarString(playerid,"_Bag_Click_Info",VarString,64);
		    if(VerifyInvPVarData(playerid,VarString))
		 	{
				new BagID,BagKey[37],ItemID;
				sscanf(VarString, "p<,>is[37]i",BagID,BagKey,ItemID);
		 	    if(strval(inputtext)<=0||strval(inputtext)>PlayerInv[playerid][BagID][_Amounts])
		 	    {
            		formatex128("确定出售 %s [售价 $%i/件 ]?",Item[ItemID][_SellPrice],floatround(floatmul(Item[ItemID][_SellPrice],PlayerInv[playerid][BagID][_Durable])));
	    			SPD(playerid,_SPD_PLAYERSELL_TIP,DIALOG_STYLE_MSGBOX,"输入的数值错误",string128,"好的","不卖了");
                   	return true;
			 	}
			 	new tItemKey[37];
				format(tItemKey,sizeof(tItemKey),"%s",Item[ItemID][_Key]);
				if(ReduceAmountForPlayerInv(playerid,tItemKey,strval(inputtext)))
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
		case _SPD_PLAYERSELL_TIP:
		{
		    if(!response)return true;
		    new VarString[64];
		    GetPVarString(playerid,"_Bag_Click_Info",VarString,64);
		    if(VerifyInvPVarData(playerid,VarString))
		 	{
				new BagID,BagKey[37],ItemID;
				sscanf(VarString, "p<,>is[37]i",BagID,BagKey,ItemID);
				new tItemKey[37];
				format(tItemKey,sizeof(tItemKey),"%s",Item[ItemID][_Key]);
				if(ReduceAmountForPlayerInv(playerid,tItemKey,1))
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
		case _SPD_STRONGBOX_CAP:
		{
		    if(!response)return true;
		    new VarString[64];
		    GetPVarString(playerid,"_CraftBulid_Click_Info",VarString,64);
		    if(VerifyCraftBulidPVarData(playerid,VarString))
		 	{
		 	    new BulidID,BulidKey[37];
    			sscanf(VarString, "p<,>is[37]",BulidID,BulidKey);
    			CraftBulid[BulidID][_CcapacityLevel]++;
    			if(CraftBulid[BulidID][_CcapacityLevel]>5)CraftBulid[BulidID][_CcapacityLevel]=5;
    			formatex256("UPDATE `"MYSQL_DB_CRAFTBULID"` SET  `容量等级` =  '%i' WHERE  `"MYSQL_DB_CRAFTBULID"`.`密匙` ='%s'",CraftBulid[BulidID][_CcapacityLevel],CraftBulid[BulidID][_Key]);
				mysql_query(Account@Handle,string256,false);
    			if(StrongBoxTextDrawShow[playerid]==true)
    			{
    			    UpdateStrongBoxPage(playerid,BulidID,1);
    			}
		 	}
		}
		case _SPD_STRONGBOX_PUTAMOUNT:
		{
		    if(!response)return true;
		    new VarString[128];
		    GetPVarString(playerid,"_StrongBox_Click_Info",VarString,128);
		    if(VerifyStrongBoxPVarData(playerid,VarString))
		 	{
   				new BulidID,BulidKey[37],BulidInv,BulidInvKey[37],ItemID;
   				sscanf(VarString, "p<,>is[37]is[37]i",BulidID,BulidKey,BulidInv,BulidInvKey,ItemID);
                if(strval(inputtext)<=0||strval(inputtext)>CraftBulidInv[BulidInv][_Amounts])
				{
			    	formatex128("%s 有 %i 个,请输入要放入背包数量",Item[ItemID][_Name],CraftBulidInv[BulidInv][_Amounts]);
 			    	SPD(playerid,_SPD_STRONGBOX_PUTAMOUNT,DIALOG_STYLE_INPUT,"输入的数值错误",string128,"确定","返回");
					return 1;
				}
			    if(GetPlayerCurrentCapacity(playerid)+Item[ItemID][_Weight]*strval(inputtext)>GetPlayerMaxCapacity(playerid))
            	{
                	SCM(playerid,-1,"该物品太重,你的背包放不下");
                	return true;
            	}
				if(AddItemToPlayerInv(playerid,CraftBulidInv[BulidInv][_ItemKey],strval(inputtext),CraftBulidInv[BulidInv][_Durable],CraftBulidInv[BulidInv][_GetTime],true))
				{
					ReduceAmountForCraftBulidInv(playerid,BulidID,CraftBulidInv[BulidInv][_ItemKey],strval(inputtext));
				}
				return true;
		 	}
		}
		case _SPD_STRONGBOX_DROPAMOUNT:
		{
		    if(!response)return true;
		    new VarString[128];
		    GetPVarString(playerid,"_StrongBox_Click_Info",VarString,128);
		    if(VerifyStrongBoxPVarData(playerid,VarString))
		 	{
   				new BulidID,BulidKey[37],BulidInv,BulidInvKey[37],ItemID;
   				sscanf(VarString, "p<,>is[37]is[37]i",BulidID,BulidKey,BulidInv,BulidInvKey,ItemID);
                if(strval(inputtext)<=0||strval(inputtext)>CraftBulidInv[BulidInv][_Amounts])
				{
					formatex128("%s 有 %i 个,请输入要销毁的数量",Item[ItemID][_Name],CraftBulidInv[BulidInv][_Amounts]);
     				SPD(playerid,_SPD_STRONGBOX_DROPAMOUNT,DIALOG_STYLE_INPUT,"输入的数值错误",string128,"确定","返回");
					return 1;
				}
				ReduceAmountForCraftBulidInv(playerid,BulidID,CraftBulidInv[BulidInv][_ItemKey],strval(inputtext));
                return true;
		 	}
		}
		case _SPD_STRONGBOX_USE:
		{
		    if(!response)return true;
		    new VarString[128];
		    GetPVarString(playerid,"_StrongBox_Click_Info",VarString,128);
		    if(VerifyStrongBoxPVarData(playerid,VarString))
		 	{
   				new BulidID,BulidKey[37],BulidInv,BulidInvKey[37],ItemID;
   				sscanf(VarString, "p<,>is[37]is[37]i",BulidID,BulidKey,BulidInv,BulidInvKey,ItemID);
	            switch(listitem)
	            {
					case 0:
					{
						if(CraftBulidInv[BulidInv][_Amounts]>1)
						{
					    	formatex128("%s 有 %i 个,请输入要放入背包数量",Item[ItemID][_Name],CraftBulidInv[BulidInv][_Amounts]);
     				    	SPD(playerid,_SPD_STRONGBOX_PUTAMOUNT,DIALOG_STYLE_INPUT,"放入背包",string128,"确定","返回");
						}
						else
						{
						    if(GetPlayerCurrentCapacity(playerid)+Item[ItemID][_Weight]>GetPlayerMaxCapacity(playerid))
			            	{
			                	SCM(playerid,-1,"该物品太重,你的背包放不下");
			                	return true;
			            	}
						    if(AddItemToPlayerInv(playerid,CraftBulidInv[BulidInv][_ItemKey],1,CraftBulidInv[BulidInv][_Durable],CraftBulidInv[BulidInv][_GetTime],true))
						    {
						        ReduceAmountForCraftBulidInv(playerid,BulidID,CraftBulidInv[BulidInv][_ItemKey],1);
						    }
						}
					}
					case 1:
					{
						if(CraftBulidInv[BulidInv][_Amounts]>1)
						{
     				    	formatex128("%s 有 %i 个,请输入要销毁的数量",Item[ItemID][_Name],CraftBulidInv[BulidInv][_Amounts]);
     				    	SPD(playerid,_SPD_STRONGBOX_DROPAMOUNT,DIALOG_STYLE_INPUT,"销毁",string128,"确定","返回");
						}
						else
						{
						    ReduceAmountForCraftBulidInv(playerid,BulidID,CraftBulidInv[BulidInv][_ItemKey],1);
						}
					}
				}
				return true;
		 	}
		}
    }
    return false;
}
FUNC::OnAccountLoginGame(playerid)//登录完成后
{
	LoadPlayerInventory(playerid);
	LoadPlayerEquip(playerid);
	LoadPlayerWeapon(playerid);
	LoadPlayerGameMails(playerid);
	if(Account[playerid][_SpawnTown]==NONE)
	{
		HidePlayerComeTextDraw(playerid);
		ShowPlayerCitySelectTextDraw(playerid);
	}
	else
	{
    	HidePlayerComeTextDraw(playerid);
 	    new Float:SpawnZ;
		CA_FindZ_For2DCoord(SafeZone[Account[playerid][_SpawnTown]][_sX],SafeZone[Account[playerid][_SpawnTown]][_sY],SpawnZ);
        if(Account[playerid][_Skin]==NONE)SetSpawnInfo(playerid,NO_TEAM,0,SafeZone[Account[playerid][_SpawnTown]][_sX],SafeZone[Account[playerid][_SpawnTown]][_sY],SpawnZ+0.5,0.0,0,0,0,0,0,0);
		else SetSpawnInfo(playerid,NO_TEAM,Account[playerid][_Skin],SafeZone[Account[playerid][_SpawnTown]][_sX],SafeZone[Account[playerid][_SpawnTown]][_sY],SpawnZ+0.5,0.0,0,0,0,0,0,0);
        CancelSelectTextDrawEx(playerid);
        //SpawnPlayer(playerid);
    	TogglePlayerSpectating(playerid,0);
	}
	return 1;
}
FUNC::UpdateAccountSpawnTown(playerid,TownID)
{
	formatex128("UPDATE `"MYSQL_DB_ACCOUNT"` SET  `出生地`='%i' WHERE  `"MYSQL_DB_ACCOUNT"`.`密匙` ='%s'",TownID,Account[playerid][_Key]);
	mysql_query(Account@Handle,string128,false);
    return 1;
}
FUNC::UpdateAccountCash(playerid,Cash)
{
	formatex128("UPDATE `"MYSQL_DB_ACCOUNT"` SET  `金钱`='%i' WHERE  `"MYSQL_DB_ACCOUNT"`.`密匙` ='%s'",Cash,Account[playerid][_Key]);
	mysql_query(Account@Handle,string128,false);
    return 1;
}
FUNC::UpdateAccountSkin(playerid,SkinID)
{
	formatex128("UPDATE `"MYSQL_DB_ACCOUNT"` SET  `皮肤`='%i' WHERE  `"MYSQL_DB_ACCOUNT"`.`密匙` ='%s'",SkinID,Account[playerid][_Key]);
	mysql_query(Account@Handle,string128,false);
    return 1;
}
stock  GetPlayerMySqlFactionFromKey(Key[])
{
	formatex128("SELECT `阵营密匙` FROM `"MYSQL_DB_ACCOUNT"` WHERE `密匙` = '%s' LIMIT 1",Key);
	mysql_query(Account@Handle,string128);
    new FactionKey[37];
	if(cache_get_row_count(Account@Handle)==1)cache_get_field_content(0,"阵营密匙",FactionKey,Account@Handle,37);
	else format(FactionKey,37,"null");
	return FactionKey;
}
FUNC::GetPlayerMySqlIndexFromKey(Key[])
{
	formatex128("SELECT `编号` FROM `"MYSQL_DB_ACCOUNT"` WHERE `密匙` = '%s' LIMIT 1",Key);
	mysql_query(Account@Handle,string128);
	return cache_get_field_content_int(0,"编号",Account@Handle);
}
stock GetPlayerMySqlNameFromKey(Key[])
{
	formatex128("SELECT `名字` FROM `"MYSQL_DB_ACCOUNT"` WHERE `密匙` = '%s' LIMIT 1",Key);
	mysql_query(Account@Handle,string128);
	new PlayerName[24];
	cache_get_field_content(0,"名字",PlayerName,Account@Handle,24);
	return PlayerName;
}
FUNC::IsPlayerKeyFexist(Key[])
{
	formatex128("SELECT `名字` FROM `"MYSQL_DB_ACCOUNT"` WHERE `密匙` = '%s' LIMIT 1",Key);
	mysql_query(Account@Handle,string128);
	return cache_get_row_count(Account@Handle);
}
stock GetPlayerMySqlKeyFromName(Name[])
{
	formatex128("SELECT `密匙` FROM `"MYSQL_DB_ACCOUNT"` WHERE `名字` = '%s' LIMIT 1",Name);
	mysql_query(Account@Handle,string128);
    new PlayerKey[37];
	if(cache_get_row_count(Account@Handle)==1)cache_get_field_content(0,"密匙",PlayerKey,Account@Handle,37);
	else format(PlayerKey,37,"null");
	return PlayerKey;
}
FUNC::GetPlayerIDByKey(PlayerKey[])
{
	foreach(new i:Player)
	{
	    if(RealPlayer(i))
	    {
	        if(isequal(Account[i][_Key],PlayerKey,false))
	        {
	            return i;
	        }
	    }
	}
	return NONE;
}
