FUNC::GetPlayerIdByName(PlayerName[])//ͨ�����ֻ�ȡ���ID
{
    new userID;
    sscanf(PlayerName,"u",userID);
    return userID;
}
FUNC::GetPlayerAccountData(playerid)//ץȡ����ʻ�����
{
	if(Account[playerid][_Login]==false)
	{
		GetPlayerNameEx(playerid,Account[playerid][_Name],24);
		/*if(CheckPlayerNameForRP(Account[playerid][_Name]))
		{*/
		ClearChat(playerid);
		new Query[128];
		format(Query,sizeof(Query),"SELECT * FROM `"MYSQL_DB_ACCOUNT"` WHERE `����`='%s' LIMIT 1",Account[playerid][_Name]);
 		mysql_tquery(Account@Handle,Query, "OnAccountDataLoad","i",playerid);
	    /*}
	    else
		{
			SCM(playerid,-1,"�����Ϸ���ֲ�����Ҫ��[��ȷ��������:Firstname_Lastname]");
			DalayKick(playerid);
		}*/
	}
	return 1;
}
FUNC::OnAccountDataLoad(playerid)//��ȡ
{
	TextDrawShowForPlayer(playerid,ComTextDraw[1]);
	TextDrawShowForPlayer(playerid,ComTextDraw[2]);
	SelectTextDrawEx(playerid, 0xFF4040AA);
	if(cache_num_rows(Account@Handle))//�˻�����
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
        case _SPD_LOGIN://��¼
        {
    		if(!response)return true;
    		formatex64(inputtext,64);
    		SHA256_PassHash(inputtext,PASSWORD_SALT,string64,64);
		    new Query[128];
			format(Query, sizeof(Query), "SELECT * FROM `"MYSQL_DB_ACCOUNT"` WHERE `����` = '%s' LIMIT 1",Account[playerid][_Name]);
			mysql_query(Account@Handle,Query,true);
			new TempPassWord[64+1];
			cache_get_field_content(0,"����",TempPassWord,Account@Handle,64+1);
			if(isequal(string64,TempPassWord,false))
			{
			   	Account[playerid][_Index]=cache_get_field_content_int(0,"���",Account@Handle);
			    cache_get_field_content(0,"�ܳ�",Account[playerid][_Key],Account@Handle,64);
                cache_get_field_content(0,"����",Account[playerid][_Password],Account@Handle,64);
 			    Account[playerid][_Skin]=cache_get_field_content_int(0,"Ƥ��",Account@Handle);
			    Account[playerid][_Cash]=cache_get_field_content_int(0,"��Ǯ",Account@Handle);
			    Account[playerid][_Level]=cache_get_field_content_int(0,"�ȼ�",Account@Handle);
			    Account[playerid][_Exp]=cache_get_field_content_int(0,"����",Account@Handle);
			    Account[playerid][_SpawnTown]=cache_get_field_content_int(0,"������",Account@Handle);
			    Account[playerid][_OfflineX]=cache_get_field_content_float(0,"����X",Account@Handle);
			    Account[playerid][_OfflineY]=cache_get_field_content_float(0,"����Y",Account@Handle);
			    Account[playerid][_OfflineZ]=cache_get_field_content_float(0,"����Z",Account@Handle);
			    Account[playerid][_OfflineA]=cache_get_field_content_float(0,"����A",Account@Handle);
			    Account[playerid][_OfflineInt]=cache_get_field_content_int(0,"���߿ռ�",Account@Handle);
			    Account[playerid][_Hunger]=cache_get_field_content_float(0,"�ڿ�",Account@Handle);
			    Account[playerid][_Dry]=cache_get_field_content_float(0,"����",Account@Handle);
                Account[playerid][_Infection]=cache_get_field_content_int(0,"��Ⱦ",Account@Handle);
				cache_get_field_content(0,"��Ӫ�ܳ�",PlayerFaction[playerid][_FactionKey],Account@Handle,64);
	        	PlayerFaction[playerid][_Rank]=cache_get_field_content_int(0,"��Ӫ�׼�",Account@Handle);
	        	PlayerFaction[playerid][_AuthorCraft]=cache_get_field_content_int(0,"��Ӫ�������",Account@Handle);
	        	PlayerFaction[playerid][_FactionID]=GetPlayerFactionID(playerid);

				OnAccountLoginGame(playerid);
			}
			else SPD(playerid,_SPD_LOGIN,DIALOG_STYLE_PASSWORD,"�������","��������������","ȷ��","�뿪");
            return true;
		}
        case _SPD_REGISTER://ע��
        {
		    if(!response)return true;
			if(strlen(inputtext)<6||strlen(inputtext)>10)return SPD(playerid,_SPD_REGISTER,DIALOG_STYLE_PASSWORD,"�����ַ����ٻ����[6-10]","������������������¼","ȷ��","�뿪");
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
			`����`,\
			`�ܳ�`,\
			`����`\
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
				SPD(playerid,_SPD_BAG_USE,DIALOG_STYLE_LIST,string64,PLAYER_BAG_USE_PANEL,"ѡ��","����");
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
						    case ITEM_TYPE_MEDICAL,ITEM_TYPE_FOOD,ITEM_TYPE_BOMB,ITEM_TYPE_ANTIBIOTIC:SPD(playerid,_SPD_BAG_USE_QUICKUSE,DIALOG_STYLE_LIST,"ѡ���ݼ�",PLAYER_BAG_USE_PANEL_QUICKUSE,"ѡ��","����");
						    default:SCM(playerid,-1,"�����͵��߲�֧�ֿ�ݼ�");
						}
						
					}
					case 2:
					{
				    	switch(GetPlayerInDomainState(playerid))
						{
						    case PLAYER_DOMAIN_NONE:
							{
							    SCM(playerid,-1,"�ⲻ���������");
								return true;
							}
						    case PLAYER_DOMAIN_OTHER:
							{
								SCM(playerid,-1,"���Ǳ��˵����,�㲻�ܲ���!");
								return true;
							}
						    case PLAYER_DOMAIN_FACTION_FORBID:
							{
							    SCM(playerid,-1,"������Ӫ���,��û��Ȩ�޲���1!");
								return true;
							}
						    case PLAYER_DOMAIN_FACTION_OTHER:
							{
							    SCM(playerid,-1,"������Ӫ���,��û��Ȩ�޲���2!");
								return true;
							}
						}
					    new index=GetNearstStrongBox(playerid);
					    if(index!=NONE)
						{
						    SPD(playerid,_SPD_NEAR_STRONGBOX,DIALOG_STYLE_TABLIST_HEADERS,"�������ñ�����",ShowPlayerNearStrongBox(playerid,1),"ѡ��","ȡ��");
						}
						else SCM(playerid,-1,"�㸽��û�б�����");
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
				    	SPD(playerid,_SPD_NEAR_STRONGBOX,DIALOG_STYLE_TABLIST_HEADERS,"�������ñ�����",ShowPlayerNearStrongBox(playerid,DialogPage[playerid]),"ȷ��","ȡ��");
					}
					case MAX_BOX_LIST+1:
					{
			    		DialogPage[playerid]++;
						SPD(playerid,_SPD_NEAR_STRONGBOX,DIALOG_STYLE_TABLIST_HEADERS,"�������ñ�����",ShowPlayerNearStrongBox(playerid,DialogPage[playerid]),"ȷ��","ȡ��");
				    }
					default:
					{
						new index=DialogBox[playerid][pager+listitem-1];
						if(PlayerInv[playerid][BagID][_Amounts]>1&&Item[ItemID][_Overlap]==1)
						{
							formatex128("������ %s ����ID: %04d[%s] �����������",Item[ItemID][_Name],index,CraftBulid[index][_CName]);
							formatex64("11,%i,%s,11",index,CraftBulid[index][_Key]);
	    					SetPVarString(playerid,"_Select_BulidID_Info",string64);
	    					SPD(playerid,_SPD_BAG_PUT_AMOUNT,DIALOG_STYLE_INPUT,"���뱣����",string128,"ȷ��","ȡ��");
           				}
               			else
                  		{
                            formatex128("�Ƿ� %s ����ID: %04d[%s] ������",Item[ItemID][_Name],index,CraftBulid[index][_CName]);
							formatex64("11,%i,%s,11",index,CraftBulid[index][_Key]);
	    					SetPVarString(playerid,"_Select_BulidID_Info",string64);
							SPD(playerid,_SPD_BAG_PUT_TIP,DIALOG_STYLE_MSGBOX,"���뱣����",string128,"ȷ��","����");
        				}
	/*
						
						
						formatex64("%i,%s",index,DialogBoxKey[playerid][pager+listitem-1]);
						if(VerifyNearWirelessPVarData(playerid,string64)==true)
						{
						    if(!IsPlayerHaveWirelessChannel(playerid,Faction[index][_Wireless]))
						    {
							    formatex32("%s Mhz[%s]",Faction[index][_Wireless],Faction[index][_Name]);
							    SPD(playerid,_SPD_NEAR_WIRELESS_ADD,DIALOG_STYLE_MSGBOX,string32,"�Ƿ���Ӹ�Ƶ�ε�������ߵ�ʼ�?","�ǵ�","����");
		   						SetPVarString(playerid,"_NearWireless_Click_Info",string64);
	   						}
	   						else SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"����","��Ƶ���Ѿ�������������ߵ�ʼ���","�õ�","");
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
					formatex128("������ %s ����ID: %04d[%s] �����������",Item[ItemID][_Name],BulidID,CraftBulid[BulidID][_CName]);
					SPD(playerid,_SPD_BAG_PUT_AMOUNT,DIALOG_STYLE_INPUT,"���뱣����",string128,"ȷ��","ȡ��");
					return 1;
		 	    }
				new tItemKey[37];
				format(tItemKey,sizeof(tItemKey),"%s",Item[ItemID][_Key]);
               	if(AddItemToCraftBulidInv(playerid,BulidID,PlayerInv[playerid][BagID][_ItemKey],strval(inputtext),PlayerInv[playerid][BagID][_Durable],PlayerInv[playerid][BagID][_GetTime])==RETURN_SUCCESS)
				{
				    ReduceAmountForPlayerInv(playerid,tItemKey,strval(inputtext));
				}
				else SCM(playerid,-1,"�������ڵ����Ѿ��ﵽ����[�������ӱ�������ø���]");
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
				else SCM(playerid,-1,"�������ڵ����Ѿ��ﵽ����[�������ӱ�������ø���]");
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
				            SCM(playerid,-1,"�õ��߱������������ݼ�");
				        }
						else UpdatePlayerQuickSlot(playerid,listitem,BagID);
				    }
				    default:SCM(playerid,-1,"�����͵��߲�֧�ֿ�ݼ�");
				}
			}
        }
        case _SPD_BAG_USE_BOMB:
        {
            if(!response)return true;
            if(strval(inputtext)<=0||strval(inputtext)>999)return SPD(playerid,_SPD_BAG_USE_BOMB,DIALOG_STYLE_INPUT,"����ʱ����̻����","��ѡ�񵹼�ʱʱ��[��λ:��]","ѡ��","����");
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
	 				formatex64("��ı����ж�� %s ,�����붪��������",Item[ItemID][_Name]);
		    		SPD(playerid,_SPD_BAG_DROP_AMOUNT,DIALOG_STYLE_INPUT,"�������ֵ����",string64,"ѡ��","����");
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
					SCM(playerid,-1,"����Ʒ̫��,��ı����Ų���");
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
					SPD(playerid,_SPD_NEAR_PICKUP_AMOUNT,DIALOG_STYLE_INPUT,string64,"����Ʒ�ж��,������ʰȡ������","ѡ��","����");
				}
				else
				{
		            if(GetPlayerCurrentCapacity(playerid)+Item[ItemID][_Weight]>GetPlayerMaxCapacity(playerid))
		            {
		                SCM(playerid,-1,"��ı���������,װ����");
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
					SPD(playerid,_SPD_NEAR_PICKUP_AMOUNT,DIALOG_STYLE_INPUT,"�������ֵ����","����Ʒ�ж��,������ʰȡ������","ѡ��","����");
                    return true;
			    }
	            if(GetPlayerCurrentCapacity(playerid)+Item[ItemID][_Weight]*strval(inputtext)>GetPlayerMaxCapacity(playerid))
	            {
	                SCM(playerid,-1,"��ı���������,װ����");
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
			    	SPD(playerid,_SPD_GM_ADD_PICKUP,DIALOG_STYLE_TABLIST_HEADERS,"���ʰȡ��",ShowItems(playerid,DialogPage[playerid]),"ȷ��","ȡ��");
				}
				case MAX_BOX_LIST+1:
				{
		    		DialogPage[playerid]++;
					SPD(playerid,_SPD_GM_ADD_PICKUP,DIALOG_STYLE_TABLIST_HEADERS,"���ʰȡ��",ShowItems(playerid,DialogPage[playerid]),"ȷ��","ȡ��");
			    }
				default:
				{
					new index=DialogBox[playerid][pager+listitem-1];
    				if(Iter_Count(PickUpSpawn)>=MAX_PICKUP_SPAWNS)return Debug(playerid,"ʰȡ���ѵ�����,���޸�MAX_PICKUP_SPAWNS");
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
									`X����`,\
									`Y����`,\
									`Z����`,\
									`RX����`,\
									`RY����`,\
									`RZ����`,\
									`����`,\
									`����Key`)\
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
			    	SPD(playerid,_SPD_GM_ADD_VEH,DIALOG_STYLE_TABLIST_HEADERS,"�������",ShowCraftVehicles(playerid,DialogPage[playerid]),"ȷ��","ȡ��");
				}
				case MAX_BOX_LIST+1:
				{
		    		DialogPage[playerid]++;
					SPD(playerid,_SPD_GM_ADD_VEH,DIALOG_STYLE_TABLIST_HEADERS,"�������",ShowCraftVehicles(playerid,DialogPage[playerid]),"ȷ��","ȡ��");
			    }
				default:
				{
					new index=DialogBox[playerid][pager+listitem-1];
   					CA_FindZ_For2DCoord(PlayerPos[playerid][0],PlayerPos[playerid][1],PlayerPos[playerid][2]);
                    CreateVehData(CraftVehicleList[index][_Key],PlayerPos[playerid][0],PlayerPos[playerid][1],PlayerPos[playerid][2]+3.0,0.0,-1,-1,0,"GM���",false);
				}
			}
        }
        case _SPD_PRIVATEDOMAIN_ENTER:
        {
            if(!response)return true;
            if(GetPlayerInDomainState(playerid)==PLAYER_DOMAIN_OWNER)return SCM(playerid,-1,"���Ѿ�����������");
			new PrivateDomainID=GetPlayerHavePrivateDomainID(playerid);
            if(PrivateDomainID!=NONE)SetPlayerPosEx(playerid,PrivateDomain[PrivateDomainID][_OutX],PrivateDomain[PrivateDomainID][_OutY],PrivateDomain[PrivateDomainID][_OutZ],0.0,0,0,2000,0.5,false);
        }
        case _SPD_PRIVATEDOMAIN_CREATE:
        {
            if(!response)return true;
            CreatePrivateDomainData(playerid,"˽�����",PlayerPos[playerid][0],PlayerPos[playerid][1],PlayerPos[playerid][2]);
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
			    	SPD(playerid,_SPD_MY_WIRELESS,DIALOG_STYLE_TABLIST_HEADERS,"���ߵ�ʼ�",ShowPlayerWireless(playerid,DialogPage[playerid]),"ȷ��","ȡ��");
				}
				case MAX_BOX_LIST+1:
				{
		    		DialogPage[playerid]++;
					SPD(playerid,_SPD_MY_WIRELESS,DIALOG_STYLE_TABLIST_HEADERS,"���ߵ�ʼ�",ShowPlayerWireless(playerid,DialogPage[playerid]),"ȷ��","ȡ��");
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
			    	SPD(playerid,_SPD_NEAR_WIRELESS,DIALOG_STYLE_TABLIST_HEADERS,"�������ߵ��ź�",ShowPlayerNearWireless(playerid,DialogPage[playerid]),"ȷ��","ȡ��");
				}
				case MAX_BOX_LIST+1:
				{
		    		DialogPage[playerid]++;
					SPD(playerid,_SPD_NEAR_WIRELESS,DIALOG_STYLE_TABLIST_HEADERS,"�������ߵ��ź�",ShowPlayerNearWireless(playerid,DialogPage[playerid]),"ȷ��","ȡ��");
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
						    SPD(playerid,_SPD_NEAR_WIRELESS_ADD,DIALOG_STYLE_MSGBOX,string32,"�Ƿ���Ӹ�Ƶ�ε�������ߵ�ʼ�?","�ǵ�","����");
	   						SetPVarString(playerid,"_NearWireless_Click_Info",string64);
   						}
   						else SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"����","��Ƶ���Ѿ�������������ߵ�ʼ���","�õ�","");
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
				if(sscanf(inputtext, "i",BuildMoveSpeed))return SPD(playerid,_SPD_CRAFTBULID_MOVE_DELAY,DIALOG_STYLE_INPUT,"������ʱ","��ʱ����С��0�����50","ȷ��","����");
    			if(BuildMoveSpeed<=0||BuildMoveSpeed>50)return SPD(playerid,_SPD_CRAFTBULID_MOVE_DELAY,DIALOG_STYLE_INPUT,"������ʱ","��ʱ����С��0�����50","ȷ��","����");
                CraftBulid[BulidID][_CDelaymove]=BuildMoveSpeed;
				formatex1024("UPDATE `"MYSQL_DB_CRAFTBULID"` SET `�ƶ���ʱ`='%i' WHERE  `"MYSQL_DB_CRAFTBULID"`.`�ܳ�` ='%s'",CraftBulid[BulidID][_CDelaymove],CraftBulid[BulidID][_Key]);
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
				if(sscanf(inputtext, "f",BuildMoveSpeed))return SPD(playerid,_SPD_CRAFTBULID_MOVE_SPEED,DIALOG_STYLE_INPUT,"�����ƶ���Χ","�ƶ���Χ����С��3�����50","ȷ��","����");
    			if(BuildMoveSpeed<3.0||BuildMoveSpeed>50.0)return SPD(playerid,_SPD_CRAFTBULID_MOVE_SPEED,DIALOG_STYLE_INPUT,"�����ƶ���Χ","�ƶ���Χ����С��3�����50","ȷ��","����");
                CraftBulid[BulidID][_Cmdistance]=BuildMoveSpeed;
				formatex1024("UPDATE `"MYSQL_DB_CRAFTBULID"` SET `�ƶ���Χ`='%0.2f' WHERE  `"MYSQL_DB_CRAFTBULID"`.`�ܳ�` ='%s'",CraftBulid[BulidID][_Cmdistance],CraftBulid[BulidID][_Key]);
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
				if(sscanf(inputtext, "f",BuildMoveSpeed))return SPD(playerid,_SPD_CRAFTBULID_MOVE_SPEED,DIALOG_STYLE_INPUT,"�����ٶ�","�ٶȲ���С��0�����50","ȷ��","����");
    			if(BuildMoveSpeed<=0.0||BuildMoveSpeed>50.0)return SPD(playerid,_SPD_CRAFTBULID_MOVE_SPEED,DIALOG_STYLE_INPUT,"�����ٶ�","�ٶȲ���С��0�����50","ȷ��","����");
                CraftBulid[BulidID][_Cspeed]=BuildMoveSpeed;
				formatex1024("UPDATE `"MYSQL_DB_CRAFTBULID"` SET `�ٶ�`='%0.2f' WHERE  `"MYSQL_DB_CRAFTBULID"`.`�ܳ�` ='%s'",CraftBulid[BulidID][_Cspeed],CraftBulid[BulidID][_Key]);
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
                if(strlen(inputtext)>10)return SPD(playerid,_SPD_CRAFTBULID_MARK_NAME,DIALOG_STYLE_INPUT,"�ַ�����","�������Զ�������[���10���ַ�/����5��]","ȷ��","����");
                format(CraftBulid[BulidID][_CName],16,inputtext);
 				formatex128("UPDATE `"MYSQL_DB_CRAFTBULID"` SET  `����` = '%s' WHERE  `"MYSQL_DB_CRAFTBULID"`.`�ܳ�` ='%s'",CraftBulid[BulidID][_CName],CraftBulid[BulidID][_Key]);
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
						formatex32("�����ڱ༭������ %04d[%s] ",BulidID,CraftBulid[BulidID][_CName]);
						SCM(playerid,-1,string32);
     				}
     				case 1:
     				{
     				    formatex64("��ǰ�ٶ� %0.1f,�������µ��ٶ�",CraftBulid[BulidID][_Cspeed]);
     				    SPD(playerid,_SPD_CRAFTBULID_MOVE_SPEED,DIALOG_STYLE_INPUT,"�����ٶ�",string64,"ȷ��","����");
    				}
     				case 2:
     				{
     				    formatex64("��ǰ��ʱ %i��,�������µ���ʱ",CraftBulid[BulidID][_CDelaymove]);
     				    SPD(playerid,_SPD_CRAFTBULID_MOVE_DELAY,DIALOG_STYLE_INPUT,"������ʱ",string64,"ȷ��","����");

     				}
     				case 3:
     				{
     				    formatex64("��ǰ�ƶ���ⷶΧ %0.1f,�������µķ�Χ",CraftBulid[BulidID][_Cmdistance]);
     				    SPD(playerid,_SPD_CRAFTBULID_MOVE_DISTANCE,DIALOG_STYLE_INPUT,"���÷�Χ",string64,"ȷ��","����");

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
						 `�ƶ�X����`='%0.2f',\
						 `�ƶ�Y����`='%0.2f',\
						 `�ƶ�Z����`='%0.2f',\
						 `�ƶ�RX����`='%0.2f',\
						 `�ƶ�RY����`='%0.2f',\
						 `�ƶ�RZ����`='%0.2f',\
						 `�Ƿ��ƶ�`='%i',\
						 `�ٶ�`='%0.2f' \
						  WHERE  `"MYSQL_DB_CRAFTBULID"`.`�ܳ�` ='%s'",0.0,0.0,0.0,0.0,0.0,0.0,0,0.0,CraftBulid[BulidID][_Key]);
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
						formatex32("�����ڱ༭������ %04d[%s] ",BulidID,CraftBulid[BulidID][_CName]);
						SCM(playerid,-1,string32);
					}
					case 1:
					{
					    if(CraftItem[CraftBulid[BulidID][_CraftItemID]][_Type]!=CRAFT_TPYE_DOOR)return SCM(playerid,-1,"ֻ�������ͽ������������ƶ�");
					    SPD(playerid,_SPD_CRAFTBULID_MOVE,DIALOG_STYLE_LIST,"�ƶ�����",CRAFTBULID_MOVE_PANEL,"ѡ��","����");
					}
					case 2:
					{
					    if(CraftItem[CraftBulid[BulidID][_CraftItemID]][_Type]!=CRAFT_TPYE_COFFER)return SCM(playerid,-1,"ֻ�б��������ͽ����������òֿ�");
                        ShowPlayerStrongBoxTextDraw(playerid,BulidID);
					}
					case 3:
					{
                        SPD(playerid,_SPD_CRAFTBULID_MARK_NAME,DIALOG_STYLE_INPUT,"�������","�������Զ�������[���10���ַ�/����5��]","ȷ��","����");
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
			if(strval(inputtext)<=0)return SPD(playerid,_SPD_STORESELL_AMOUNT,DIALOG_STYLE_INPUT,"������Ʒ","��ֵ����С��1","����","������");
			new VarString[128];
    		GetPVarString(playerid,"_StoreSell_Click_Info",VarString,128);
		    if(VerifyStoreSellPVarData(playerid,VarString))
		 	{
				new StoreID,StoreKey[37],StoreSellID,StoreSellKey[37];
			    sscanf(VarString, "p<,>is[37]is[37]",StoreID,StoreKey,StoreSellID,StoreSellKey);
			    if(strval(inputtext)>StoreSells[StoreID][StoreSellID][_Amount])return SPD(playerid,_SPD_STORESELL_AMOUNT,DIALOG_STYLE_INPUT,"������Ʒ","��ֵ̫��,û����ô����","����","������");
				if(GetPlayerCurrentCapacity(playerid)+Item[StoreSells[StoreID][StoreSellID][_ItemID]][_Weight]*strval(inputtext)>GetPlayerMaxCapacity(playerid))
            	{
                	SCM(playerid,-1,"����Ʒ̫��,��ı����Ų���");
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
                	SCM(playerid,-1,"����Ʒ̫��,��ı����Ų���");
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
            		formatex128("ȷ������ %s [�ۼ� $%i/�� ]?",Item[ItemID][_SellPrice],floatround(floatmul(Item[ItemID][_SellPrice],PlayerInv[playerid][BagID][_Durable])));
	    			SPD(playerid,_SPD_PLAYERSELL_TIP,DIALOG_STYLE_MSGBOX,"�������ֵ����",string128,"�õ�","������");
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
    			formatex256("UPDATE `"MYSQL_DB_CRAFTBULID"` SET  `�����ȼ�` =  '%i' WHERE  `"MYSQL_DB_CRAFTBULID"`.`�ܳ�` ='%s'",CraftBulid[BulidID][_CcapacityLevel],CraftBulid[BulidID][_Key]);
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
			    	formatex128("%s �� %i ��,������Ҫ���뱳������",Item[ItemID][_Name],CraftBulidInv[BulidInv][_Amounts]);
 			    	SPD(playerid,_SPD_STRONGBOX_PUTAMOUNT,DIALOG_STYLE_INPUT,"�������ֵ����",string128,"ȷ��","����");
					return 1;
				}
			    if(GetPlayerCurrentCapacity(playerid)+Item[ItemID][_Weight]*strval(inputtext)>GetPlayerMaxCapacity(playerid))
            	{
                	SCM(playerid,-1,"����Ʒ̫��,��ı����Ų���");
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
					formatex128("%s �� %i ��,������Ҫ���ٵ�����",Item[ItemID][_Name],CraftBulidInv[BulidInv][_Amounts]);
     				SPD(playerid,_SPD_STRONGBOX_DROPAMOUNT,DIALOG_STYLE_INPUT,"�������ֵ����",string128,"ȷ��","����");
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
					    	formatex128("%s �� %i ��,������Ҫ���뱳������",Item[ItemID][_Name],CraftBulidInv[BulidInv][_Amounts]);
     				    	SPD(playerid,_SPD_STRONGBOX_PUTAMOUNT,DIALOG_STYLE_INPUT,"���뱳��",string128,"ȷ��","����");
						}
						else
						{
						    if(GetPlayerCurrentCapacity(playerid)+Item[ItemID][_Weight]>GetPlayerMaxCapacity(playerid))
			            	{
			                	SCM(playerid,-1,"����Ʒ̫��,��ı����Ų���");
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
     				    	formatex128("%s �� %i ��,������Ҫ���ٵ�����",Item[ItemID][_Name],CraftBulidInv[BulidInv][_Amounts]);
     				    	SPD(playerid,_SPD_STRONGBOX_DROPAMOUNT,DIALOG_STYLE_INPUT,"����",string128,"ȷ��","����");
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
FUNC::OnAccountLoginGame(playerid)//��¼��ɺ�
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
	formatex128("UPDATE `"MYSQL_DB_ACCOUNT"` SET  `������`='%i' WHERE  `"MYSQL_DB_ACCOUNT"`.`�ܳ�` ='%s'",TownID,Account[playerid][_Key]);
	mysql_query(Account@Handle,string128,false);
    return 1;
}
FUNC::UpdateAccountCash(playerid,Cash)
{
	formatex128("UPDATE `"MYSQL_DB_ACCOUNT"` SET  `��Ǯ`='%i' WHERE  `"MYSQL_DB_ACCOUNT"`.`�ܳ�` ='%s'",Cash,Account[playerid][_Key]);
	mysql_query(Account@Handle,string128,false);
    return 1;
}
FUNC::UpdateAccountSkin(playerid,SkinID)
{
	formatex128("UPDATE `"MYSQL_DB_ACCOUNT"` SET  `Ƥ��`='%i' WHERE  `"MYSQL_DB_ACCOUNT"`.`�ܳ�` ='%s'",SkinID,Account[playerid][_Key]);
	mysql_query(Account@Handle,string128,false);
    return 1;
}
stock  GetPlayerMySqlFactionFromKey(Key[])
{
	formatex128("SELECT `��Ӫ�ܳ�` FROM `"MYSQL_DB_ACCOUNT"` WHERE `�ܳ�` = '%s' LIMIT 1",Key);
	mysql_query(Account@Handle,string128);
    new FactionKey[37];
	if(cache_get_row_count(Account@Handle)==1)cache_get_field_content(0,"��Ӫ�ܳ�",FactionKey,Account@Handle,37);
	else format(FactionKey,37,"null");
	return FactionKey;
}
FUNC::GetPlayerMySqlIndexFromKey(Key[])
{
	formatex128("SELECT `���` FROM `"MYSQL_DB_ACCOUNT"` WHERE `�ܳ�` = '%s' LIMIT 1",Key);
	mysql_query(Account@Handle,string128);
	return cache_get_field_content_int(0,"���",Account@Handle);
}
stock GetPlayerMySqlNameFromKey(Key[])
{
	formatex128("SELECT `����` FROM `"MYSQL_DB_ACCOUNT"` WHERE `�ܳ�` = '%s' LIMIT 1",Key);
	mysql_query(Account@Handle,string128);
	new PlayerName[24];
	cache_get_field_content(0,"����",PlayerName,Account@Handle,24);
	return PlayerName;
}
FUNC::IsPlayerKeyFexist(Key[])
{
	formatex128("SELECT `����` FROM `"MYSQL_DB_ACCOUNT"` WHERE `�ܳ�` = '%s' LIMIT 1",Key);
	mysql_query(Account@Handle,string128);
	return cache_get_row_count(Account@Handle);
}
stock GetPlayerMySqlKeyFromName(Name[])
{
	formatex128("SELECT `�ܳ�` FROM `"MYSQL_DB_ACCOUNT"` WHERE `����` = '%s' LIMIT 1",Name);
	mysql_query(Account@Handle,string128);
    new PlayerKey[37];
	if(cache_get_row_count(Account@Handle)==1)cache_get_field_content(0,"�ܳ�",PlayerKey,Account@Handle,37);
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
