FUNC::Domain_OnGameModeInit()
{
	forex(i,MAX_PLAYERS)
	{
		DomainEnter[i][_EditID]=NONE;
		DomainEnter[i][_Move]=false;
	}
/*	CA_CreateObject_SC(19529, 661.05981, -4232.72266, 13.05710,   0.00000, 0.00000, 0.00000,300.0);
	CA_CreateObject_SC(19542, 723.55103, -4232.72949, 13.05710,   0.00000, 0.00000, 0.00000,300.0);
	CA_CreateObject_SC(19542, 661.06342, -4170.23779, 13.05710,   0.00000, 0.00000, 90.00000,300.0);
	CA_CreateObject_SC(19542, 661.06110, -4295.20459, 13.05710,   0.00000, 0.00000, -90.00000,300.0);
	CA_CreateObject_SC(19542, 598.57831, -4232.72705, 13.05710,   0.00000, 0.00000, 180.00000,300.0);
	CA_CreateObject_SC(19540, 598.57678, -4170.27148, 13.05710,   0.00000, 0.00000, 90.00000,300.0);
	CA_CreateObject_SC(19540, 598.57062, -4295.23047, 13.05710,   0.00000, 0.00000, 180.00000,300.0);
	CA_CreateObject_SC(19540, 723.54108, -4295.23633, 13.05710,   0.00000, 0.00000, 270.00000,300.0);
	CA_CreateObject_SC(19540, 723.56018, -4170.28027, 13.05710,   0.00000, 0.00000, 0.00000,300.0);
*/	return 1;
}
FUNC::Dom_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(PRESSED(KEY_NO))
    {
        switch(GetPlayerInDomainState(playerid))
        {
            case PLAYER_DOMAIN_OWNER,PLAYER_DOMAIN_FACTION_ALLOW:
            {
                DomainEdit[playerid][_Dalay]=GetTickCount();
            	SelectObject(playerid);
            	SCM(playerid,-1,"�㿪���˱༭ģʽ,ESC�ر�");
            }
        }
    }
    if(PRESSED(KEY_CTRL_BACK))
    {
        switch(GetPlayerInDomainState(playerid))
        {
            case PLAYER_DOMAIN_OWNER,PLAYER_DOMAIN_FACTION_ALLOW:
            {
                if(GetTickCount()-DomainEdit[playerid][_Dalay]>=1000)
	        	{
	        	    DomainEdit[playerid][_Dalay]=GetTickCount();
	            	new BulidID=GetNearstCraftBulid(playerid);
	            	if(BulidID!=NONE)
	            	{
	            	    formatex32("%04d[%s] ���̲���",BulidID,CraftBulid[BulidID][_CName]);
						SPD(playerid,_SPD_CRAFTBULID_USE,DIALOG_STYLE_LIST,string32,CRAFTBULID_USE_PANEL,"ѡ��","����");
	    				formatex64("%i,%i,%s,%i",CraftBulid[BulidID][_CobjectIndex],BulidID,CraftBulid[BulidID][_Key],CA_ObjectList[CraftBulid[BulidID][_CobjectIndex]][ObjectID]);
	    				SetPVarString(playerid,"_Select_BulidID_Info",string64);
	    				
						/*DomainEnter[playerid][_EditID]=BulidID;
                        DomainEnter[playerid][_Move]=false;
					    formatex64("%i,%i,%s,%i",CraftBulid[BulidID][_CobjectIndex],BulidID,CraftBulid[BulidID][_Key],CA_ObjectList[CraftBulid[BulidID][_CobjectIndex]][ObjectID]);
					    SetPVarString(playerid,"_Select_BulidID_Info",string64);
						EditDynamicObject(playerid, CA_ObjectList[CraftBulid[BulidID][_CobjectIndex]][ObjectID]);
						printf("1 - %s",string64);
						UpdateDynamic3DTextLabelText(CraftBulid[BulidID][_C3dtext],-1,"");
						formatex32("�����ڱ༭������ %04d ",BulidID);
						SCM(playerid,-1,string32);*/
	            	}
            	}
            }
        }
    }
	return 1;
}
FUNC::GetNearstCraftBulid(playerid)
{
    if(Iter_Count(CraftBulid)<=0)return NONE;
	new Float:dis,Float:dis2,index;
	index=NONE;
	dis=99999.99;
	foreach(new i:CraftBulid)
	{
		if(IsPlayerInDynamicArea(playerid,CraftBulid[i][_CareaID]))
		{
			new Float:x1, Float:y1, Float:z1;
			GetPlayerPos(playerid, x1, y1, z1);
			dis2 = floatsqroot(floatpower(floatabs(floatsub(CraftBulid[i][_Cx],x1)),2)+floatpower(floatabs(floatsub(CraftBulid[i][_Cy],y1)),2)+floatpower(floatabs(floatsub(CraftBulid[i][_Cz],z1)),2));
			if(dis2<dis&&dis2 != -1.00)
			{
				dis=dis2;
				index=i;
			}
		}
	}
	return index;
}
FUNC::Dom_OnPlayerDisconnect(playerid)
{
	if(DomainEnter[playerid][_EditID]!=NONE)
    {
        new VarString[64];
 		GetPVarString(playerid,"_Select_BulidID_Info",VarString,64);
 		if(VerifyBuildPVarData(playerid,VarString)==true)
        {
	        new ObjectIndex,BulidID,CraftBulidKey[37],objectidEx;
			sscanf(VarString, "p<,>iis[37]i",ObjectIndex,BulidID,CraftBulidKey,objectidEx);
			CA_SetObjectPos_DC(ObjectIndex,CraftBulid[BulidID][_Cx],CraftBulid[BulidID][_Cy],CraftBulid[BulidID][_Cz]);
			CA_SetObjectRot_DC(ObjectIndex,CraftBulid[BulidID][_Crx],CraftBulid[BulidID][_Cry],CraftBulid[BulidID][_Crz]);
            UpdateCraftBulidText(BulidID);
			CancelEdit(playerid);
        }
    }
	DomainEnter[playerid][_EditID]=NONE;
	DomainEnter[playerid][_Move]=false;
	return 1;
}
public OnPlayerSelectDynamicObject(playerid, STREAMER_TAG_OBJECT:objectid, modelid, Float:x, Float:y, Float:z)
{
	switch(GetPlayerInDomainState(playerid))
	{
	    case PLAYER_DOMAIN_NONE:
		{
		    SCM(playerid,-1,"�ⲻ���������");
		    CancelEdit(playerid);
			return true;
		}
	    case PLAYER_DOMAIN_OTHER:
		{
		    SCM(playerid,-1,"���Ǳ��˵����,�㲻�ܲ���!");
		    CancelEdit(playerid);
			return true;
		}
	    case PLAYER_DOMAIN_FACTION_FORBID:
		{
		    SCM(playerid,-1,"������Ӫ���,��û��Ȩ�޲���1!");
		    CancelEdit(playerid);
			return 0;
		}
	    case PLAYER_DOMAIN_FACTION_OTHER:
		{
		    CancelSelectTextDrawEx(playerid);
		    SCM(playerid,-1,"������Ӫ���,��û��Ȩ�޲���2!");
			return 0;
		}
	}
	new BulidID=GetCraftBulidIDbyObject(objectid);
	if(BulidID!=NONE)
	{
        formatex32("%04d[%s] ���̲���",BulidID,CraftBulid[BulidID][_CName]);
		SPD(playerid,_SPD_CRAFTBULID_USE,DIALOG_STYLE_LIST,string32,CRAFTBULID_USE_PANEL,"ѡ��","����");
	    formatex64("%i,%i,%s,%i",GetDynamicObjectIndexByObjectID(objectid),BulidID,CraftBulid[BulidID][_Key],objectid);
	    SetPVarString(playerid,"_Select_BulidID_Info",string64);
/*		DomainEnter[playerid][_EditID]=BulidID;
			
	    formatex64("%i,%i,%s,%i",GetDynamicObjectIndexByObjectID(objectid),BulidID,CraftBulid[BulidID][_Key],objectid);
	    SetPVarString(playerid,"_Select_BulidID_Info",string64);
		EditDynamicObject(playerid, objectid);
		printf("1 - %s",string64);
		UpdateDynamic3DTextLabelText(CraftBulid[BulidID][_C3dtext],-1,"");
		formatex32("�����ڱ༭������ %04d ",BulidID);
		SCM(playerid,-1,string32);*/
	}
	return 1;
}
public OnPlayerEditDynamicObject(playerid, STREAMER_TAG_OBJECT:objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    if(DomainEnter[playerid][_EditID]!=NONE)
    {
/*        new DomainState=GetPlayerInDomainState(playerid);
        printf("DomainState:%i",DomainState);
        if(DomainState<PLAYER_DOMAIN_OWNER)
		{
		    SCM(playerid,-1,"������֤ʧ��,ȡ���༭#0");
		    DomainEnter[playerid][_EditID]=NONE;
			CancelEdit(playerid);
			return 1;
		}
        new VarString[64];
 		GetPVarString(playerid,"_Select_BulidID_Info",VarString,64);
        if(VerifyBuildPVarData(playerid,VarString)==false)
        {
			SCM(playerid,-1,"������֤ʧ��,ȡ���༭#1");
            DomainEnter[playerid][_EditID]=NONE;
			CancelEdit(playerid);
			return 1;
        }*/
		switch(response)
		{
		    /*case EDIT_RESPONSE_UPDATE:
		    {

		    }*/
		    case EDIT_RESPONSE_FINAL:
		    {
		        new VarString[64];
		 		GetPVarString(playerid,"_Select_BulidID_Info",VarString,64);
		        new DomainState=GetPlayerInDomainState(playerid);
		        new ObjectIndex,BulidID,CraftBulidKey[37],objectidEx;
				sscanf(VarString, "p<,>iis[37]i",ObjectIndex,BulidID,CraftBulidKey,objectidEx);
		        if(VerifyBuildPVarData(playerid,VarString)==false)
		        {
					CA_SetObjectPos_DC(ObjectIndex,CraftBulid[BulidID][_Cx],CraftBulid[BulidID][_Cy],CraftBulid[BulidID][_Cz]);
					CA_SetObjectRot_DC(ObjectIndex,CraftBulid[BulidID][_Crx],CraftBulid[BulidID][_Cry],CraftBulid[BulidID][_Crz]);
					UpdateCraftBulidText(BulidID);

					DomainEnter[playerid][_EditID]=NONE;
					DomainEnter[playerid][_Move]=false;

					formatex64("������֤ʧ��,���� %04d[%s] �ص����λ��",BulidID,CraftBulid[BulidID][_CName]);
					SCM(playerid,-1,string64);
					return 1;
		        }
		        
				switch(DomainState)
				{
				    case PLAYER_DOMAIN_OWNER:
				    {
				        new index=GetPrivateDomainIDbyIndexKey(GetPlayerVirtualWorld(playerid)-PRIVATEDOMAIN_LIMIT);
						if(index==NONE)
				    	{
							CA_SetObjectPos_DC(ObjectIndex,CraftBulid[BulidID][_Cx],CraftBulid[BulidID][_Cy],CraftBulid[BulidID][_Cz]);
							CA_SetObjectRot_DC(ObjectIndex,CraftBulid[BulidID][_Crx],CraftBulid[BulidID][_Cry],CraftBulid[BulidID][_Crz]);
							UpdateCraftBulidText(BulidID);

							DomainEnter[playerid][_EditID]=NONE;
							DomainEnter[playerid][_Move]=false;

							formatex64("Ȩ�޼���������,���� %04d[%s] �ص����λ��",BulidID,CraftBulid[BulidID][_CName]);
							SCM(playerid,-1,string64);
							return 1;
				    	}
						if(!IsPointInDynamicArea(PrivateDomain[index][_In_Area],x,y,z))
				    	{
							CA_SetObjectPos_DC(ObjectIndex,CraftBulid[BulidID][_Cx],CraftBulid[BulidID][_Cy],CraftBulid[BulidID][_Cz]);
							CA_SetObjectRot_DC(ObjectIndex,CraftBulid[BulidID][_Crx],CraftBulid[BulidID][_Cry],CraftBulid[BulidID][_Crz]);
							UpdateCraftBulidText(BulidID);

							DomainEnter[playerid][_EditID]=NONE;
							DomainEnter[playerid][_Move]=false;

							formatex64("�༭λ�ó���˽����ط�Χ,���� %04d[%s] �ص����λ��",BulidID,CraftBulid[BulidID][_CName]);
							SCM(playerid,-1,string64);
							return 1;
				    	}
				    }
				    case PLAYER_DOMAIN_FACTION_ALLOW:
				    {
				        new factionid=GetPlayerInFactionAreaID(playerid);
				    	if(!IsPointInDynamicArea(Faction[factionid][_Areaid],x,y,z))
				    	{
							CA_SetObjectPos_DC(ObjectIndex,CraftBulid[BulidID][_Cx],CraftBulid[BulidID][_Cy],CraftBulid[BulidID][_Cz]);
							CA_SetObjectRot_DC(ObjectIndex,CraftBulid[BulidID][_Crx],CraftBulid[BulidID][_Cry],CraftBulid[BulidID][_Crz]);
							UpdateCraftBulidText(BulidID);

							DomainEnter[playerid][_EditID]=NONE;
							DomainEnter[playerid][_Move]=false;

							formatex64("�༭λ�ó�����Ӫ��ط�Χ,���� %04d[%s] �ص����λ��",BulidID,CraftBulid[BulidID][_CName]);
							SCM(playerid,-1,string64);
							return 1;
				    	}
				    }
				    default:
				    {
						CA_SetObjectPos_DC(ObjectIndex,CraftBulid[BulidID][_Cx],CraftBulid[BulidID][_Cy],CraftBulid[BulidID][_Cz]);
						CA_SetObjectRot_DC(ObjectIndex,CraftBulid[BulidID][_Crx],CraftBulid[BulidID][_Cry],CraftBulid[BulidID][_Crz]);
						UpdateCraftBulidText(BulidID);

						DomainEnter[playerid][_EditID]=NONE;
						DomainEnter[playerid][_Move]=false;
						formatex64("��û�������������,���� %04d[%s] �ص����λ��",BulidID,CraftBulid[BulidID][_CName]);
						SCM(playerid,-1,string64);
						return 1;
                    }
				}
				if(DomainEnter[playerid][_Move]==false)
				{
					CraftBulid[BulidID][_Cx]=x;
	    			CraftBulid[BulidID][_Cy]=y;
	    			CraftBulid[BulidID][_Cz]=z;
	    			CraftBulid[BulidID][_Crx]=rx;
	    			CraftBulid[BulidID][_Cry]=ry;
	    			CraftBulid[BulidID][_Crz]=rz;

	    			formatex512("UPDATE `"MYSQL_DB_CRAFTBULID"` SET \
					 `X����`='%0.2f',\
					 `Y����`='%0.2f',\
					 `Z����`='%0.2f',\
					 `RX����`='%0.2f',\
					 `RY����`='%0.2f',\
					 `RZ����`='%0.2f' \
					  WHERE  `"MYSQL_DB_CRAFTBULID"`.`�ܳ�` ='%s'",x,y,z,rx,ry,rz,CraftBulid[BulidID][_Key]);
					mysql_query(Account@Handle,string512,false);

					DestoryCraftBulidModel(BulidID);
					CreateCraftBulidModel(BulidID);
					DomainEnter[playerid][_EditID]=NONE;
					DomainEnter[playerid][_Move]=false;
					formatex64("���� %04d[%s] ����λ�óɹ�",BulidID,CraftBulid[BulidID][_CName]);
					SCM(playerid,-1,string64);
				}
				else
				{
					CraftBulid[BulidID][_Cmx]=x;
	    			CraftBulid[BulidID][_Cmy]=y;
	    			CraftBulid[BulidID][_Cmz]=z;
	    			CraftBulid[BulidID][_Cmrx]=rx;
	    			CraftBulid[BulidID][_Cmry]=ry;
	    			CraftBulid[BulidID][_Cmrz]=rz;
                    CraftBulid[BulidID][_Cmove]=1;
                    CraftBulid[BulidID][_Cspeed]=4.1;
	    			formatex1024("UPDATE `"MYSQL_DB_CRAFTBULID"` SET \
					 `�ƶ�X����`='%0.2f',\
					 `�ƶ�Y����`='%0.2f',\
					 `�ƶ�Z����`='%0.2f',\
					 `�ƶ�RX����`='%0.2f',\
					 `�ƶ�RY����`='%0.2f',\
					 `�ƶ�RZ����`='%0.2f',\
					 `�Ƿ��ƶ�`='%i',\
					 `�ٶ�`='%0.2f' \
					  WHERE  `"MYSQL_DB_CRAFTBULID"`.`�ܳ�` ='%s'",x,y,z,rx,ry,rz,CraftBulid[BulidID][_Cmove],CraftBulid[BulidID][_Cspeed],CraftBulid[BulidID][_Key]);
					mysql_query(Account@Handle,string1024,false);

					CA_SetObjectPos_DC(ObjectIndex,CraftBulid[BulidID][_Cx],CraftBulid[BulidID][_Cy],CraftBulid[BulidID][_Cz]);
					CA_SetObjectRot_DC(ObjectIndex,CraftBulid[BulidID][_Crx],CraftBulid[BulidID][_Cry],CraftBulid[BulidID][_Crz]);
					UpdateCraftBulidText(BulidID);

					DomainEnter[playerid][_EditID]=NONE;
					DomainEnter[playerid][_Move]=false;
					formatex64("���� %04d[%s] �����ƶ�λ�óɹ�",BulidID,CraftBulid[BulidID][_CName]);
					SCM(playerid,-1,string64);
				}
				return 1;
		    }
		    case EDIT_RESPONSE_CANCEL:
		    {
		        new VarString[64];
		 		GetPVarString(playerid,"_Select_BulidID_Info",VarString,64);
		        new ObjectIndex,BulidID,CraftBulidKey[37],objectidEx;
				sscanf(VarString, "p<,>iis[37]i",ObjectIndex,BulidID,CraftBulidKey,objectidEx);
                GetPVarString(playerid,"_Select_BulidID_Info",VarString,64);
				if(VerifyBuildPVarData(playerid,VarString)==false)
		        {
					CA_SetObjectPos_DC(ObjectIndex,CraftBulid[BulidID][_Cx],CraftBulid[BulidID][_Cy],CraftBulid[BulidID][_Cz]);
					CA_SetObjectRot_DC(ObjectIndex,CraftBulid[BulidID][_Crx],CraftBulid[BulidID][_Cry],CraftBulid[BulidID][_Crz]);
					UpdateCraftBulidText(BulidID);

					DomainEnter[playerid][_EditID]=NONE;
					DomainEnter[playerid][_Move]=false;

					formatex64("������֤ʧ��,���� %04d[%s] �ص����λ��",BulidID,CraftBulid[BulidID][_CName]);
					SCM(playerid,-1,string64);
					return 1;
		        }

				CA_SetObjectPos_DC(ObjectIndex,CraftBulid[BulidID][_Cx],CraftBulid[BulidID][_Cy],CraftBulid[BulidID][_Cz]);
				CA_SetObjectRot_DC(ObjectIndex,CraftBulid[BulidID][_Crx],CraftBulid[BulidID][_Cry],CraftBulid[BulidID][_Crz]);
				UpdateCraftBulidText(BulidID);

				DomainEnter[playerid][_EditID]=NONE;
				DomainEnter[playerid][_Move]=false;
				
				formatex64("ȡ���༭,���� %04d[%s] �ص����λ��",BulidID,CraftBulid[BulidID][_CName]);
				SCM(playerid,-1,string64);
				return 1;
		    }
		}
    }
	return 1;
}
FUNC::OnPlayerEnterCraftBulidMoveArea(playerid,index)
{
	if(CraftBulid[index][_CraftMoveIng]==0)
	{
		new DomainState=GetPlayerInDomainState(playerid);
		if(DomainState==PLAYER_DOMAIN_FACTION_OTHER||DomainState==PLAYER_DOMAIN_OWNER||DomainState==PLAYER_DOMAIN_FACTION_ALLOW)
		{
	    	CA_MoveObject_DC(CraftBulid[index][_CobjectIndex],\
			CraftBulid[index][_Cmx],\
			CraftBulid[index][_Cmy],\
			CraftBulid[index][_Cmz],\
			CraftBulid[index][_Cspeed],\
			CraftBulid[index][_Cmrx],\
			CraftBulid[index][_Cmry],\
			CraftBulid[index][_Cmrz]);
			CraftBulid[index][_CraftMoveIng]=1;
		}
	}
	return 1;
}
public OnDynamicObjectMoved(STREAMER_TAG_OBJECT:objectid)
{
	new index=GetCraftBulidIDbyObject(objectid);
	if(index!=NONE)
	{
	    if(CraftBulid[index][_CraftMoveIng]==1)
	    {
		    if(CraftBulid[index][_CDelaymove]<=0)
		    {
				CA_MoveObject_DC(CraftBulid[index][_CobjectIndex],\
					CraftBulid[index][_Cx],\
					CraftBulid[index][_Cy],\
					CraftBulid[index][_Cz],\
					CraftBulid[index][_Cspeed],\
					CraftBulid[index][_Crx],\
					CraftBulid[index][_Cry],\
					CraftBulid[index][_Crz]);
		        CraftBulid[index][_CraftMoveIng]=2;
			}
			else
			{
			    if(CraftBulid[index][Timer:_DelayMove]!=NONE)KillTimer(CraftBulid[index][Timer:_DelayMove]);
			    CraftBulid[index][Timer:_DelayMove]=NONE;
			    CraftBulid[index][Timer:_DelayMove]=SetTimerEx("CraftBulidStartMove",CraftBulid[index][_CDelaymove]*1000,false,"i",index);
			}
		}
		if(CraftBulid[index][_CraftMoveIng]==2)CraftBulid[index][_CraftMoveIng]=0;
	}
	return 1;
}
