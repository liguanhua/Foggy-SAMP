FUNC::LoadPlayerWireless(playerid)//��ȡ������ߵ�
{
	formatex128("SELECT * FROM `"MYSQL_DB_PLAYERWIRELESS"` WHERE `�����ܳ�`='%s'",Account[playerid][_Key]);
	mysql_query(Account@Handle,string128,true);
    forex(i,cache_num_rows())
	{
	    if(i<MAX_PLAYER_WIRELESS)
	    {
	        cache_get_field_content(i,"���ߵ��ܳ�",PlayerWireless[playerid][i][_WirelessKey],Account@Handle,37);
	        cache_get_field_content(i,"���ߵ�Ƶ��",PlayerWireless[playerid][i][_WirelessChannel],Account@Handle,8);
            new FactionID=GetWirelessChannelKeyID(PlayerWireless[playerid][i][_WirelessChannel]);
	        if(FactionID==NONE)
	        {
	            cache_get_field_content(i,"�����ܳ�",PlayerWireless[playerid][i][_AccountKey],Account@Handle,37);
		    	PlayerWireless[playerid][i][_WirelessUsed]=cache_get_field_content_int(i,"ʹ��",Account@Handle);
				cache_get_field_content(i,"���ʱ��",PlayerWireless[playerid][i][_CreateTime],Account@Handle,37);
                PlayerWireless[playerid][i][_FactionID]=FactionID;
				Iter_Add(PlayerWireless[playerid],i);
				printf("%s ���ߵ�,���ߵ��ܳ�-[%s] ",Account[playerid][_Name],PlayerWireless[playerid][i][_WirelessKey]);
			}
			else
			{
	    	    formatex128("DELETE FROM `"MYSQL_DB_PLAYERWIRELESS"` WHERE `"MYSQL_DB_PLAYERWIRELESS"`.`���ߵ��ܳ�` ='%s'",PlayerWireless[playerid][i][_WirelessKey]);
				mysql_query(Account@Handle,string128,false);
				printf("%s ���ߵ��б�,���ߵ��ܳ�-[%s][%s] ʧЧ,��ɾ��",Account[playerid][_Name],PlayerWireless[playerid][i][_WirelessKey],PlayerWireless[playerid][i][_WirelessChannel]);
			}
		}
		else
		{
		    printf("%s ���ߵ��б����",Account[playerid][_Name]);
			break;
		}
	}
	return 1;
}
FUNC::IsPlayerHaveWirelessChannel(playerid,Channel[])
{
	foreach(new i:PlayerWireless[playerid])
	{
		if(isequal(PlayerWireless[playerid][i][_WirelessChannel],Channel,false))return 1;
	}
	return 0;
}
FUNC::AddWirelessToPlayer(playerid,WirelessChannel[])//���Ƶ��
{
	if(Iter_Count(PlayerWireless[playerid])>=MAX_PLAYER_WIRELESS)
	{
	    formatex80("%i-awtp error0",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
   	new i=Iter_Free(PlayerWireless[playerid]);
   	format(PlayerWireless[playerid][i][_AccountKey],UUID_LEN,Account[playerid][_Key]);
   	UUID(PlayerWireless[playerid][i][_WirelessKey], UUID_LEN);
	format(PlayerWireless[playerid][i][_WirelessChannel],8,WirelessChannel);
    PlayerWireless[playerid][i][_WirelessUsed]=1;
    format(PlayerWireless[playerid][i][_CreateTime],40,PrintDate());
    formatex512("INSERT INTO `"MYSQL_DB_PLAYERWIRELESS"`(`�����ܳ�`,`���ߵ��ܳ�`,`���ߵ�Ƶ��`,`ʹ��`,`���ʱ��`) VALUES ('%s','%s','%s','%i','%s')",PlayerWireless[playerid][i][_AccountKey],PlayerWireless[playerid][i][_WirelessKey],PlayerWireless[playerid][i][_WirelessChannel],PlayerWireless[playerid][i][_WirelessUsed],PlayerWireless[playerid][i][_CreateTime]);
   	mysql_query(Account@Handle,string512,true);
    Iter_Add(PlayerWireless[playerid],i);
	return RETURN_SUCCESS;
}
FUNC::RestPlayerWireless(playerid)
{
   	Iter_Clear(PlayerWireless[playerid]);
	return 1;
}
stock ShowPlayerWireless(playerid,pager)
{
    DialogBoxID[playerid]=1;
   	new	Project_ID[MAX_PLAYER_INV_SLOTS],Top_Info[MAX_PLAYER_INV_SLOTS],Current_TopLine=Iter_Count(PlayerWireless[playerid]);
	foreach(new i:PlayerWireless[playerid])
    {
        HighestTopList(i,PlayerWireless[playerid][i][_WirelessUsed],Project_ID, Top_Info, Current_TopLine);
    }
    forex(i,Current_TopLine)
	{
		DialogBox[playerid][DialogBoxID[playerid]]=Project_ID[i];
		format(DialogBoxKey[playerid][DialogBoxID[playerid]],UUID_LEN,PlayerWireless[playerid][Project_ID[i]][_WirelessKey]);
		DialogBoxID[playerid]++;
	}
    new BodyStr[1024],TempStr[64],end=0,index;
    if(pager<1)pager=1;
//    if(pager>floatround((DialogBoxID[playerid]-1)/float(MAX_BOX_LIST),floatround_ceil))pager=floatround((DialogBoxID[playerid]-1)/float(MAX_BOX_LIST),floatround_ceil);
    DialogPage[playerid]=pager;
    pager=(pager-1)*MAX_BOX_LIST;
    if(pager==0)pager=1;else pager++;
	format(BodyStr,sizeof(BodyStr), "���ߵ�Ƶ��\t������Ӫ\t����ʹ��\t���ʱ��\n");
	strcat(BodyStr,"\t��һҳ\n");
	loop(i,pager,pager+MAX_BOX_LIST)
	{
		index=DialogBox[playerid][i];
		if(i<DialogBoxID[playerid])
		{
			if(PlayerWireless[playerid][index][_WirelessUsed]==1)format(TempStr,sizeof(TempStr),"%s Mhz\t%s\t��\t%s\n",PlayerWireless[playerid][index][_WirelessChannel],Faction[PlayerWireless[playerid][index][_FactionID]][_Name],PlayerWireless[playerid][index][_CreateTime]);
			else format(TempStr,sizeof(TempStr),"%s Mhz\t%s\t \t%s\n",PlayerWireless[playerid][index][_WirelessChannel],Faction[PlayerWireless[playerid][index][_FactionID]][_Name],PlayerWireless[playerid][index][_CreateTime]);
        }
		if(i>=DialogBoxID[playerid])
		{
			end=1;
			break;
		}
		else strcat(BodyStr,TempStr);
	}
	if(!end)strcat(BodyStr, "\t��һҳ\n");
    return BodyStr;
}
stock ShowPlayerNearWireless(playerid,pager)
{
    DialogBoxID[playerid]=1;
   	new	Project_ID[MAX_PLAYER_INV_SLOTS],Float:Top_Info[MAX_PLAYER_INV_SLOTS],Current_TopLine=Iter_Count(Faction);
	new Float:WireStrength[MAX_FACTIONS];
	foreach(new i:Faction)
    {
	    WireStrength[i]=floatmul(floatdiv(GetDistanceBetweenPoints2D(PlayerPos[playerid][0],PlayerPos[playerid][1],Faction[i][_x],Faction[i][_y]),floatmul(1000.0,Faction[i][_Level]+1)),100);
		WireStrength[i]=floatsub(100.0,WireStrength[i]);
		if(WireStrength[i]>100.0)WireStrength[i]=100.0;
		if(WireStrength[i]<0.0)WireStrength[i]=0.0;
    }
	foreach(new i:Faction)
    {
        HighestTopListFloat(i,WireStrength[i],Project_ID, Top_Info, Current_TopLine);
    }
    forex(i,Current_TopLine)
	{
		DialogBox[playerid][DialogBoxID[playerid]]=Project_ID[i];
        format(DialogBoxKey[playerid][DialogBoxID[playerid]],UUID_LEN,Faction[Project_ID[i]][_Key]);
		DialogBoxID[playerid]++;
	}
    new BodyStr[1024],TempStr[64],end=0,index;
//    if(pager>floatround((DialogBoxID[playerid]-1)/float(MAX_BOX_LIST),floatround_ceil))pager=floatround((DialogBoxID[playerid]-1)/float(MAX_BOX_LIST),floatround_ceil);
    if(pager<1)pager=1;
    DialogPage[playerid]=pager;
    pager=(pager-1)*MAX_BOX_LIST;
    if(pager==0)pager=1;else pager++;
	format(BodyStr,sizeof(BodyStr), "���ߵ�Ƶ��\t������Ӫ\t����ʹ��\t�ź�ǿ��\n");
	strcat(BodyStr,"\t��һҳ\n");
	loop(i,pager,pager+MAX_BOX_LIST)
	{
		index=DialogBox[playerid][i];
		if(i<DialogBoxID[playerid])
		{
			if(Faction[index][_WirelessOpen]==1)format(TempStr,sizeof(TempStr),"%s Mhz\t%s\t��\t%0.1f%%\n",Faction[index][_Wireless],Faction[index][_Name],WireStrength[index]);
			else format(TempStr,sizeof(TempStr),"%s Mhz\t%s\t \t%0.1f%%\n",Faction[index][_Wireless],Faction[index][_Name],WireStrength[index]);
        }
		if(i>=DialogBoxID[playerid])
		{
			end=1;
			break;
		}
		else strcat(BodyStr,TempStr);
	}
	if(!end)strcat(BodyStr, "\t��һҳ\n");
    return BodyStr;
}
FUNC::bool:VerifyWirelessPVarData(playerid,VarString[])
{
	new WirelessID,WirelessKey[37];
    if(sscanf(VarString, "p<,>is[37]",WirelessID,WirelessKey))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"����[#0]","�Ի���������֤ʧ��,������ѡ��","�˽�","");
        return false;
	}
	if(!Iter_Contains(PlayerWireless[playerid],WirelessID))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"����[#1]","��Ƶ����ʧЧ,������ѡ��","�˽�","");
        return false;
	}
    if(!isequal(PlayerWireless[playerid][WirelessID][_WirelessKey],WirelessKey,false))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"����[#2]","�Ի���������֤ʧ��,������ѡ��","�˽�","");
        return false;
	}
	return true;
}
FUNC::bool:VerifyNearWirelessPVarData(playerid,VarString[])
{
	new FactionID,FactionKey[37];
    if(sscanf(VarString, "p<,>is[37]",FactionID,FactionKey))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"����[#0]","�Ի���������֤ʧ��,������ѡ��","�˽�","");
        return false;
	}
	if(!Iter_Contains(Faction,FactionID))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"����[#1]","����ӪƵ����ʧЧ,������ѡ��","�˽�","");
        return false;
	}
    if(!isequal(Faction[FactionID][_Key],FactionKey,false))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"����[#2]","�Ի���������֤ʧ��,������ѡ��","�˽�","");
        return false;
	}
	return true;
}
CMD:ws(playerid, params[])
{
	SPD(playerid,_SPD_MY_WIRELESS,DIALOG_STYLE_TABLIST_HEADERS,"���ߵ�ʼ�",ShowPlayerWireless(playerid,1),"ѡ��","ȡ��");
	return 1;
}
CMD:wn(playerid, params[])
{
	SPD(playerid,_SPD_NEAR_WIRELESS,DIALOG_STYLE_TABLIST_HEADERS,"�������ߵ��ź�",ShowPlayerNearWireless(playerid,1),"ѡ��","ȡ��");
	return 1;
}
