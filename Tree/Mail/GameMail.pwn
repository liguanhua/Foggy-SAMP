FUNC::SendMailToPlayer(SenderKey[],ReceiverKey[],Type,Content[],Cash,Itemdata[],ExtraData[],GameTime)
{
    new ReceiveID=GetPlayerIDByKey(ReceiverKey);
    new SenderID=GetPlayerIDByKey(SenderKey);
   	if(SenderID==NONE)format(SenderKey,UUID_LEN,"null");
	if(ReceiveID==NONE)return SendGameMailToOffLPlayer(SenderKey,ReceiverKey,Type,Content,Cash,Itemdata,ExtraData,GameTime);
	else return SendGameMailToOnlPlayer(SenderID,ReceiveID,Type,Content,Cash,Itemdata,ExtraData,GameTime);
}
FUNC::SendGameMailToOnlPlayer(SenderID,ReceiverID,Type,Content[],Cash,Itemdata[],ExtraData[],GameTime)//�����ʼ����������
{
    if(Iter_Count(PlayerGameMail[ReceiverID])>=MAX_PLAYER_GAMEMAILS)
	{
	    formatex80("%i-sgmyonp error0",SenderID);
        Debug(SenderID,string80);
		return RETURN_ERROR;
    }
    
    new i=Iter_Free(PlayerGameMail[ReceiverID]);
    UUID(PlayerGameMail[ReceiverID][i][_Key], UUID_LEN);
    PlayerGameMail[ReceiverID][i][_Type]=Type;
    if(SenderID==NONE)format(PlayerGameMail[ReceiverID][i][_SenderKey],UUID_LEN,"null");
    else format(PlayerGameMail[ReceiverID][i][_SenderKey],UUID_LEN,Account[SenderID][_Key]);
    format(PlayerGameMail[ReceiverID][i][_ReceiverKey],UUID_LEN,Account[ReceiverID][_Key]);
    format(PlayerGameMail[ReceiverID][i][_Content],256,Content);
    format(PlayerGameMail[ReceiverID][i][_SendTime],32,PrintDate());
    format(PlayerGameMail[ReceiverID][i][_ExtraData],128,ExtraData);
    PlayerGameMail[ReceiverID][i][_Cash]=Cash;
    format(PlayerGameMail[ReceiverID][i][_ItemData],512,Itemdata);
	PlayerGameMail[ReceiverID][i][_Readed]=0;
	PlayerGameMail[ReceiverID][i][_GameTime]=GameTime;
	Iter_Add(PlayerGameMail[ReceiverID],i);

	new MailKey[37],SenderKey[37],ReceiverKey[37];
	format(MailKey,37,PlayerGameMail[ReceiverID][i][_Key]);
	format(SenderKey,37,PlayerGameMail[ReceiverID][i][_SenderKey]);
	format(ReceiverKey,37,PlayerGameMail[ReceiverID][i][_ReceiverKey]);

	formatex2048(\
	"INSERT INTO `"MYSQL_DB_PLAYERGAMEMAIL"` (\
	`�ʼ��ܳ�`,`�������ܳ�`,`�ռ����ܳ�`,`����`,`����`,\
	`���`,`��������`,`��������`,`����ʱ��`,`ϵͳʱ��`) VALUES \
	('%s','%s','%s','%i','%s','%i','%s','%s','%s','%i')",\
	MailKey,\
	SenderKey,\
	ReceiverKey,\
	Type,\
	Content,\
	Cash,\
	PlayerGameMail[ReceiverID][i][_ItemData],\
	ExtraData,\
	PlayerGameMail[ReceiverID][i][_SendTime],\
	GameTime);
	mysql_query(Account@Handle,string2048);
    return RETURN_SUCCESS;
}
FUNC::SendGameMailToOffLPlayer(SenderKey[],ReceiverKey[],Type,Content[],Cash,Itemdata[],ExtraData[],GameTime)//�����ʼ����������
{
	if(!IsPlayerKeyFexist(ReceiverKey))
	{
	    formatex80("%s-sgmtofflp error0",SenderKey);
        Debug(NONE,string80);
		return RETURN_ERROR;
    }
	if(GetOfflinePlayerKeyMailAmout(ReceiverKey)>=MAX_PLAYER_GAMEMAILS)
	{
	    formatex80("%s-sgmtofflp error1",SenderKey);
        Debug(NONE,string80);
		return RETURN_ERROR;
    }
    new MailKey[37];
    UUID(MailKey, UUID_LEN);
    formatex2048("INSERT INTO `"MYSQL_DB_PLAYERGAMEMAIL"`(`�ʼ��ܳ�`,`�������ܳ�`,`�ռ����ܳ�`,`����`,`����`,`���`,`��������`,`��������`,`����ʱ��`,`ϵͳʱ��`)\
	VALUES ('%s','%s','%s','%i','%s','%i','%s','%s','%s','%i')",MailKey,SenderKey,ReceiverKey,Type,Content,Cash,Itemdata,ExtraData,PrintDate(),GameTime);
	mysql_query(Account@Handle,string2048,false);
    return RETURN_SUCCESS;
}
FUNC::GetOfflinePlayerKeyMailAmout(Key[])//��ȡ��������Ա�ʼ�����
{
	formatex128("SELECT * FROM `"MYSQL_DB_PLAYERGAMEMAIL"` WHERE `�ռ����ܳ�`='%s'",Key);
	mysql_query(Account@Handle,string128);
	return cache_num_rows(Account@Handle);
}


FUNC::PlayerGameMailRest(playerid)//�������ʼ�����
{
   	Iter_Clear(PlayerGameMail[playerid]);
	return 1;
}
FUNC::LoadPlayerGameMails(playerid)//��������ʼ�����
{
    PlayerGameMailRest(playerid);
	formatex128("SELECT * FROM `"MYSQL_DB_PLAYERGAMEMAIL"` WHERE `�ռ����ܳ�`='%s' ORDER BY `"MYSQL_DB_PLAYERGAMEMAIL"`.`ϵͳʱ��` ASC",Account[playerid][_Key]);
    mysql_tquery(Account@Handle,string128, "OnPlayerGameMailsLoad", "i",playerid);
}
FUNC::OnPlayerGameMailsLoad(playerid)//��������ʼ�����
{
    forex(i,cache_num_rows())
	{
	    if(i<MAX_PLAYER_GAMEMAILS)
	    {
			cache_get_field_content(i,"�ʼ��ܳ�",PlayerGameMail[playerid][i][_Key],Account@Handle,37);
			cache_get_field_content(i,"�������ܳ�",PlayerGameMail[playerid][i][_SenderKey],Account@Handle,37);
			cache_get_field_content(i,"�ռ����ܳ�",PlayerGameMail[playerid][i][_ReceiverKey],Account@Handle,37);
            PlayerGameMail[playerid][i][_Type]=cache_get_field_content_int(i,"����",Account@Handle);
            cache_get_field_content(i,"����",PlayerGameMail[playerid][i][_Content],Account@Handle,256);
            cache_get_field_content(i,"��������",PlayerGameMail[playerid][i][_ItemData],Account@Handle,512);
	        PlayerGameMail[playerid][i][_Cash]=cache_get_field_content_int(i,"���",Account@Handle);
	        cache_get_field_content(i,"��������",PlayerGameMail[playerid][i][_ExtraData],Account@Handle,128);
            cache_get_field_content(i,"����ʱ��",PlayerGameMail[playerid][i][_SendTime],Account@Handle,32);
			PlayerGameMail[playerid][i][_Readed]=cache_get_field_content_int(i,"�Ѷ�",Account@Handle);
			PlayerGameMail[playerid][i][_GameTime]=cache_get_field_content_int(i,"ϵͳʱ��",Account@Handle);
			Iter_Add(PlayerGameMail[playerid],i);
		}
		else
		{
		    printf("%s �������������[%i],���޸�MAX_PLAYER_GAMEMAILS",Account[playerid][_Name],MAX_PLAYER_GAMEMAILS);
			break;
		}
	}
	return 1;
}
stock ShowPlayerGameMails(playerid,pager)//�������ʼ��б�
{
    DialogBoxID[playerid]=1;
   	new	Project_ID[MAX_PLAYER_GAMEMAILS],Top_Info[MAX_PLAYER_GAMEMAILS],Current_TopLine=Iter_Count(PlayerGameMail[playerid]);
	foreach(new i:PlayerGameMail[playerid])
    {
        HighestTopList(i,PlayerGameMail[playerid][i][_GameTime],Project_ID, Top_Info, Current_TopLine);
    }
    forex(i,Current_TopLine)
	{
		DialogBox[playerid][DialogBoxID[playerid]]=Project_ID[i];
		format(DialogBoxKey[playerid][DialogBoxID[playerid]],UUID_LEN,PlayerGameMail[playerid][Project_ID[i]][_Key]);
		DialogBoxID[playerid]++;
	}
    new BodyStr[1024],TempStr[128],end=0,index;
    if(pager<1)pager=1;
    //if(pager>floatround((DialogBoxID[playerid]-1)/float(MAX_BOX_LIST),floatround_ceil))pager=floatround((DialogBoxID[playerid]-1)/float(MAX_BOX_LIST),floatround_ceil);
    DialogPage[playerid]=pager;
    pager=(pager-1)*MAX_BOX_LIST;
    if(pager==0)pager=1;else pager++;
	format(BodyStr,sizeof(BodyStr), "�ʼ�����\t������\t����\t����ʱ��\n");
	strcat(BodyStr,"\t��һҳ\n");
	loop(i,pager,pager+MAX_BOX_LIST)
	{
		if(i<DialogBoxID[playerid])
		{
		    index=DialogBox[playerid][i];
			format(TempStr,sizeof(TempStr),"%s\n",ReturnPlayerGameMailListStr(playerid,index));
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
FUNC::GetPlayerUnReadGameMails(playerid)//��ȡ���δ����Ϣ����
{
	new amount=0;
	foreach(new i:PlayerGameMail[playerid])
	{
	    if(PlayerGameMail[playerid][i][_Readed]==0)amount++;
	}
	return amount;
}
stock ReturnPlayerGameMailListStr(playerid,index)//��������ʼ���������Ϣ
{
	new BodyStr[128],TempStr[64];
	switch(PlayerGameMail[playerid][index][_Type])
	{
    	case GAMEMAIL_TYPE_SYSTEM:
    	{
    	    format(TempStr,sizeof(TempStr),"%s\tϵͳ\t",GameMailTypeName[PlayerGameMail[playerid][index][_Type]]);
    	}
    	default:
    	{
    	    format(TempStr,sizeof(TempStr),"%s\t%s\t",GameMailTypeName[PlayerGameMail[playerid][index][_Type]],GetPlayerMySqlNameFromKey(PlayerGameMail[playerid][index][_SenderKey]));
    	}
	}
	strcat(BodyStr,TempStr);
	if(PlayerGameMail[playerid][index][_Cash]>0||strlen(PlayerGameMail[playerid][index][_ItemData])>3)
	{
	    strcat(BodyStr,"��\t");
	}
	else
	{
	    strcat(BodyStr,"��\t");
	}
	format(TempStr,sizeof(TempStr),"%s",PlayerGameMail[playerid][index][_SendTime]);
    strcat(BodyStr,TempStr);
    return BodyStr;
}
stock ShowPlayerGameMailInfo(playerid,index)//�������ʼ�����
{
    new BodyStr[2048],TempStr[128];

	switch(PlayerGameMail[playerid][index][_Type])
	{
		case GAMEMAIL_TYPE_FACTION_REQ:
		{
		    new SenderKey[37],FactionKey[37];
    		sscanf(PlayerGameMail[playerid][index][_ExtraData], "p<,>s[37]s[37]",SenderKey,FactionKey);
			format(TempStr,sizeof(TempStr),"%s ������������Ӫ\n�Ƿ�ͬ��?\n",GetPlayerMySqlNameFromKey(SenderKey));
			strcat(BodyStr,TempStr);
		}
		case GAMEMAIL_TYPE_FRIEND_REQ:
		{
			//format(TempStr,sizeof(TempStr),"%s �������Ϊ����\n�Ƿ�ͬ��?\n",GetPlayerMySqlNameFromKey(SenderKey));
			//strcat(BodyStr,TempStr);
		}
		case GAMEMAIL_TYPE_FACTION_INV:
		{
			new SenderKey[37],FactionKey[37];
    		sscanf(PlayerGameMail[playerid][index][_ExtraData], "p<,>s[37]s[37]",SenderKey,FactionKey);
			format(TempStr,sizeof(TempStr),"%s ���������������Ӫ %s\n�Ƿ�ͬ��?\n",GetPlayerMySqlNameFromKey(SenderKey),GetFactionFromKey(FactionKey));
			strcat(BodyStr,TempStr);
		}
		default:
		{
		    if(strlen(PlayerGameMail[playerid][index][_Content])>1)
		    {
			 	format(TempStr,sizeof(TempStr),"����:\n%s\n",PlayerGameMail[playerid][index][_Content]);
			    strcat(BodyStr,TempStr);
			}
			else strcat(BodyStr,"\n");
		}
	}

	if(PlayerGameMail[playerid][index][_Cash]>0||strlen(PlayerGameMail[playerid][index][_ItemData])>3)
	{
	    strcat(BodyStr,"\n����:\n");
	    if(PlayerGameMail[playerid][index][_Cash]>0)
	    {
			formatex32("���:%i\n",PlayerGameMail[playerid][index][_Cash]);
    		strcat(BodyStr,string32);
	    }
	    if(strlen(PlayerGameMail[playerid][index][_ItemData])>3)
	    {
			formatex512("%s\n",ReturnGameMailItemDataStr(PlayerGameMail[playerid][index][_ItemData]));
    		strcat(BodyStr,string512);
    	}
	}
 	format(TempStr,sizeof(TempStr),"\n%s",PlayerGameMail[playerid][index][_SendTime]);
    strcat(BodyStr,TempStr);
    
 	format(TempStr,sizeof(TempStr),"������:%s",GetPlayerMySqlNameFromKey(PlayerGameMail[playerid][index][_SenderKey]));

	switch(PlayerGameMail[playerid][index][_Type])
	{
    	case GAMEMAIL_TYPE_FACTION_REQ,GAMEMAIL_TYPE_FRIEND_REQ,GAMEMAIL_TYPE_FACTION_INV:SPD(playerid,_SPD_GAMEMAIL_INFO,DIALOG_STYLE_MSGBOX,TempStr,BodyStr,"ͬ��","����");
        default:SPD(playerid,_SPD_GAMEMAIL_INFO,DIALOG_STYLE_MSGBOX,TempStr,BodyStr,"����","����");
	}
	
	if(PlayerGameMail[playerid][index][_Readed]==0)
	{
	    PlayerGameMail[playerid][index][_Readed]=1;
		formatex128("UPDATE `"MYSQL_DB_PLAYERGAMEMAIL"` SET `�Ѷ�`=1 WHERE  `"MYSQL_DB_PLAYERGAMEMAIL"`.`�ʼ��ܳ�` ='%s'",PlayerGameMail[playerid][index][_Key]);
		mysql_query(Account@Handle,string128,false);
	}
    return 1;
}

stock ReturnGameMailItemDataStr(itemdata[])//����ʼ��ڸ�������
{
	new index1=0,ThingKey[MAX_PLAYER_SENDGAMEMAIL_ITEMS][37],ThingAmount[MAX_PLAYER_SENDGAMEMAIL_ITEMS]=0,Float:ThingDurable[MAX_PLAYER_SENDGAMEMAIL_ITEMS]=0.0,Things[MAX_PLAYER_SENDGAMEMAIL_ITEMS];
	forex(i,MAX_PLAYER_SENDGAMEMAIL_ITEMS)Things[i]=NONE;
	new BodyStr[512],TempStr[64];
    forex(i,MAX_PLAYER_SENDGAMEMAIL_ITEMS)
    {
        format(BodyStr,512,StrtokPack1(itemdata,index1));
    	if(strval(string512)!=-1)
    	{
    	    new index2=0;
    	    format(ThingKey[i],37,StrtokPack2(BodyStr,index2));
    	    ThingAmount[i]=strval(StrtokPack2(BodyStr,index2));
    	    ThingDurable[i]=strval(StrtokPack2(BodyStr,index2));
    	    Things[i]=GetItemIDByItemKey(ThingKey[i]);
    	}
    }
    format(BodyStr,512,"");
    forex(i,MAX_PLAYER_SENDGAMEMAIL_ITEMS)
    {
		if(Things[i]!=NONE&&ThingAmount[i]>0)
		{
		    if(Item[Things[i]][_Durable]==0)
		    {
		        format(TempStr,sizeof(TempStr),"%s ����:%i\n",Item[Things[i]][_Name],ThingAmount[i]);
	    		strcat(BodyStr,TempStr);
		    }
		    else
		    {
	 			format(TempStr,sizeof(TempStr),"%s ����:%i �;�:%0.1f\n",Item[Things[i]][_Name],ThingAmount[i],ThingDurable[i]);
	    		strcat(BodyStr,TempStr);
    		}
		}
    }
    return BodyStr;
}

FUNC::ExtractGameMailAttachment(playerid,index,itemdata[])//��ȡ�ʼ��ڸ�������
{
	if(PlayerGameMail[playerid][index][_Cash]>0)
	{
		formatex128("UPDATE `"MYSQL_DB_PLAYERGAMEMAIL"` SET `���`=0 WHERE  `"MYSQL_DB_PLAYERGAMEMAIL"`.`�ʼ��ܳ�` ='%s'",PlayerGameMail[playerid][index][_Key]);
		mysql_query(Account@Handle,string128,false);
		new MailCash=PlayerGameMail[playerid][index][_Cash];
		Account[playerid][_Cash]+=MailCash;
	    PlayerGameMail[playerid][index][_Cash]=0;
	    formatex128("UPDATE `"MYSQL_DB_ACCOUNT"` SET  `��Ǯ`='%i' WHERE  `"MYSQL_DB_ACCOUNT"`.`�ܳ�` ='%s'",Account[playerid][_Cash],Account[playerid][_Key]);
		mysql_query(Account@Handle,string128,false);
        formatex64("$%i ��ȡ�ɹ�",MailCash);
		SCM(playerid,-1,string64);
	}
	if(strlen(PlayerGameMail[playerid][index][_ItemData])>3)
	{
		new index1=0,ThingKey[MAX_PLAYER_SENDGAMEMAIL_ITEMS][37],ThingAmount[MAX_PLAYER_SENDGAMEMAIL_ITEMS]=0,Float:ThingDurable[MAX_PLAYER_SENDGAMEMAIL_ITEMS]=0.0,Things[MAX_PLAYER_SENDGAMEMAIL_ITEMS];
		forex(i,MAX_PLAYER_SENDGAMEMAIL_ITEMS)Things[i]=NONE;
		new BodyStr[512];
	    forex(i,MAX_PLAYER_SENDGAMEMAIL_ITEMS)
	    {
	        format(BodyStr,512,StrtokPack1(itemdata,index1));
	    	if(strval(string512)!=-1)
	    	{
	    	    new index2=0;
	    	    format(ThingKey[i],37,StrtokPack2(BodyStr,index2));
	    	    ThingAmount[i]=strval(StrtokPack2(BodyStr,index2));
	    	    ThingDurable[i]=strval(StrtokPack2(BodyStr,index2));
	    	    Things[i]=GetItemIDByItemKey(ThingKey[i]);
	    	}
	    }
	    format(BodyStr,512,"");
	    new UnExtractBodyStr[512],UnExtractTempStr[64];
	    format(UnExtractBodyStr,512,"");
	    format(UnExtractTempStr,64,"");
	    forex(i,MAX_PLAYER_SENDGAMEMAIL_ITEMS)
	    {
			if(Things[i]!=NONE&&ThingAmount[i]>0)
			{
                if(AddItemToPlayerInv(playerid,ThingKey[i],ThingAmount[i],ThingDurable[i],SERVER_RUNTIMES,true)==RETURN_SUCCESS)
                {
                    formatex64("���� %s %i�� �;�:%0.1f ��ȡ�ɹ�",Item[Things[i]][_Name],ThingAmount[i],ThingDurable[i]);
					SCM(playerid,-1,string64);
                }
                else
                {
                    format(UnExtractTempStr,64,"%s,%i,%0.1f&",ThingKey[i],ThingAmount[i],ThingDurable[i]);
                    strcat(UnExtractBodyStr,UnExtractTempStr);
                    formatex128("���� %s %i�� �;�:%0.1f ��ȡʧ��[ԭ��:������������]",Item[Things[i]][_Name],ThingAmount[i],ThingDurable[i]);
					SCM(playerid,-1,string128);
                }
			}
	    }
	    format(PlayerGameMail[playerid][index][_ItemData],512,UnExtractBodyStr);
	    printf("%s",UnExtractBodyStr);
		formatex512("UPDATE `"MYSQL_DB_PLAYERGAMEMAIL"` SET `��������`='%s' WHERE  `"MYSQL_DB_PLAYERGAMEMAIL"`.`�ʼ��ܳ�` ='%s'",UnExtractBodyStr,PlayerGameMail[playerid][index][_Key]);
		mysql_query(Account@Handle,string512,false);
	}
	return 1;
}


CMD:sm(playerid, params[])
{
    new Content[256],Cash,Itemdata[512];
	if(sscanf(params, "p<,>s[256]is[512]",Content,Cash,Itemdata))return SCM(playerid,-1,"/sm ���� Ǯ ��������");
    SendMailToPlayer(Account[playerid][_Key],Account[playerid][_Key],GAMEMAIL_TYPE_PLAYER,Content,Cash,Itemdata,"-1",SERVER_RUNTIMES);
//    SendGameMailToOnlPlayer(Account[SenderID][_Key],Account[SenderID][_Key],GAMEMAIL_TYPE_PLAYER,Content,Cash,Itemdata,"-1",SERVER_RUNTIMES);
	return 1;
}
CMD:mail(playerid, params[])
{
	formatex64(GAMEMAIL_PANEL,GetPlayerUnReadGameMails(playerid));
	SPD(playerid,_SPD_GAMEMAIL_PANEL,DIALOG_STYLE_LIST,"����ϵͳ",string64,"ѡ��","ȡ��");
	return 1;
}
//forex(i,MAX_PLAYER_SENDGAMEMAIL_ITEMS)NewMailItem[playerid][i][_Used]=false;
//NewMailCash[playerid]=0;
//format(NewMailContent[playerid],256,"");

stock ShowPlayerGameMailCreate(playerid)//�������½��ʼ���Ϣ
{
    new BodyStr[1024],TempStr[128];
	format(TempStr,sizeof(TempStr),"���������,�����ʼ���\n");//0��
    strcat(BodyStr,TempStr);
    if(strlen(NewMailReceiverKey[playerid])>3)
    {
		format(TempStr,sizeof(TempStr),"�ռ���:%s\n",GetPlayerMySqlNameFromKey(NewMailReceiverKey[playerid]));
	}
	else
	{
		format(TempStr,sizeof(TempStr),"�ռ���:\n");
	}
    strcat(BodyStr,TempStr);//1��
    strcat(BodyStr,"�����ݱ༭��\n");//2��
    if(strlen(NewMailContent[playerid])>32)
    {
	    new ContentEx[64];
	    strmid(ContentEx,NewMailContent[playerid], 0, 32);
	    format(TempStr,sizeof(TempStr),"%s...\n",ContentEx);
    }
    else
	{
	    if(strlen(NewMailContent[playerid])<1)format(TempStr,sizeof(TempStr),"δ�༭\n");
		else format(TempStr,sizeof(TempStr),"%s\n",NewMailContent[playerid]);
    }
    strcat(BodyStr,TempStr);//3��
    format(TempStr,sizeof(TempStr),"��Ҹ���:$%i\n",NewMailCash[playerid]);
    strcat(BodyStr,TempStr);//5��
    strcat(BodyStr,"�����߸�����\n");//6��
    new Rate=0;
    forex(i,MAX_PLAYER_SENDGAMEMAIL_ITEMS)
    {
        if(NewMailItem[playerid][i][_Used]==true)
        {
	 		format(TempStr,sizeof(TempStr),"��%s ����:%i �;�:%0.1f\n",Item[NewMailItem[playerid][i][_ItemID]][_Name],NewMailItem[playerid][i][_Amount],NewMailItem[playerid][i][_Durable]);
            strcat(BodyStr,TempStr);
			Rate++;
		}
	}
    if(Rate==0)strcat(BodyStr, "����ӵ���");
    else strcat(BodyStr, "���������");
    return BodyStr;
}

FUNC::GameMail_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case _SPD_GAMEMAIL_SEND_NAME://���ý�����
        {
            if(!response)
			{
			    formatex64("�����ʼ� ����:%s",GameMailTypeName[NewMailType[playerid]]);
				return SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"ȷ��","ȡ��");
            }
            if(strlen(inputtext)<1||strlen(inputtext)>32)return SPD(playerid,_SPD_GAMEMAIL_SEND_NAME,DIALOG_STYLE_INPUT,"������","�ַ��������\n��������������ߵ����ֻ�ID","ȷ��","ȡ��");
			if(isDigit(inputtext))
			{
			    if(!RealPlayer(strval(inputtext)))return SPD(playerid,_SPD_GAMEMAIL_SEND_NAME,DIALOG_STYLE_INPUT,"������","��ID��ǰ������\n��������������ߵ����ֻ�ID","ȷ��","ȡ��");
                format(NewMailReceiverKey[playerid],UUID_LEN,Account[strval(inputtext)][_Key]);
                formatex64("�����ʼ� ����:%s",GameMailTypeName[NewMailType[playerid]]);
                SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"ȷ��","ȡ��");
                return true;
			}
			else
			{
			    new PlayerKey[37];
			    format(PlayerKey,UUID_LEN,GetPlayerMySqlKeyFromName(inputtext));
			    if(isequal(PlayerKey,"null",false))return SPD(playerid,_SPD_GAMEMAIL_SEND_NAME,DIALOG_STYLE_INPUT,"������","û��������,�����ֿ���û��ע��\n��������������ߵ����ֻ�ID","ȷ��","ȡ��");
			    else
			    {
			        format(NewMailReceiverKey[playerid],UUID_LEN,PlayerKey);
			        formatex64("�����ʼ� ����:%s",GameMailTypeName[NewMailType[playerid]]);
			        SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"ȷ��","ȡ��");
                    return true;
				}
			}
        }
        case _SPD_GAMEMAIL_SEND_CONTENT://������������
        {
            if(!response)
			{
			    formatex64("�����ʼ� ����:%s",GameMailTypeName[NewMailType[playerid]]);
				return SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"ȷ��","ȡ��");
			}
		    if(strlen(inputtext)<0||strlen(inputtext)>128)return SPD(playerid,_SPD_GAMEMAIL_SEND_CONTENT,DIALOG_STYLE_INPUT,"��������","�ַ�����������С\n�����뷢���������64�����ֻ�128���ַ�","ȷ��","ȡ��");
	        format(NewMailContent[playerid],256,inputtext);
	        formatex64("�����ʼ� ����:%s",GameMailTypeName[NewMailType[playerid]]);
	        SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"ȷ��","ȡ��");
            return true;
        }
        case _SPD_GAMEMAIL_SEND_CASH://���ý�Ҹ���
        {
            if(!response)
			{
			    formatex64("�����ʼ� ����:%s",GameMailTypeName[NewMailType[playerid]]);
				return SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"ȷ��","ȡ��");
			}
			if(strval(inputtext)<0||strval(inputtext)>Account[playerid][_Cash])
			{
				formatex128("����������������㵱ǰӵ�е�\n�㵱ǰ��$%i���\n�����뷢�͵Ľ������",Account[playerid][_Cash]);
				return SPD(playerid,_SPD_GAMEMAIL_SEND_CASH,DIALOG_STYLE_INPUT,"��Ҹ���",string128,"ȷ��","ȡ��");
			}
			else
			{
			    NewMailCash[playerid]=strval(inputtext);
			    formatex64("�����ʼ� ����:%s",GameMailTypeName[NewMailType[playerid]]);
				SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"ȷ��","ȡ��");
            	return true;
			}
        }
        case _SPD_GAMEMAIL_SEND://�ʼ��༭������
        {
            if(!response)return true;
            if(listitem<=5)
            {
	            switch(listitem)
	            {
	                case 0:
	                {
               	 		if(SendGameMail(playerid)==true)
                        {
                            SCM(playerid,-1,"�ʼ����ͳɹ�");
                            RestPlayerTempMailData(playerid);
                        }
                        else
                        {
  		 					formatex64("�����ʼ� ����:%s",GameMailTypeName[NewMailType[playerid]]);
	                    	SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"ȷ��","ȡ��");
                        }
	                }
	                case 1:
	                {
	                    SPD(playerid,_SPD_GAMEMAIL_SEND_NAME,DIALOG_STYLE_INPUT,"������","����������ߵ����ֻ�ID","ȷ��","ȡ��");
	                }
	                case 2:
	                {
	                    formatex64("�����ʼ� ����:%s",GameMailTypeName[NewMailType[playerid]]);
	                    SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"ȷ��","ȡ��");
	                }
	                case 3:
	                {
						SPD(playerid,_SPD_GAMEMAIL_SEND_CONTENT,DIALOG_STYLE_INPUT,"�ʼ�����","�����뷢���������64�����ֻ�128���ַ�","ȷ��","ȡ��");
	                }
	                case 4:
	                {
	                    formatex128("�㵱ǰ��$%i���\n�����뷢�͵Ľ������",Account[playerid][_Cash]);
						SPD(playerid,_SPD_GAMEMAIL_SEND_CASH,DIALOG_STYLE_INPUT,"��Ҹ���",string128,"ȷ��","ȡ��");
	                }
	                case 5:
	                {
	                    formatex64("�����ʼ� ����:%s",GameMailTypeName[NewMailType[playerid]]);
	                    SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"ȷ��","ȡ��");
	                }
	            }
			}
			else
			{
			    new Rate=1;
			    forex(i,MAX_PLAYER_SENDGAMEMAIL_ITEMS)
			    {
			        if(NewMailItem[playerid][i][_Used]==true)Rate++;
				}
				if(listitem==5+Rate)
				{
					if(Rate==1)
					{
					    forex(s,MAX_DIALOG_BOX_ITEMS)
					    {
					    	DialogBoxInvSelect[playerid][s]=false;
                            DialogBoxInvAmount[playerid][s]=0;
						}
						SPD(playerid,_SPD_GAMEMAIL_SEND_ITEM,DIALOG_STYLE_TABLIST_HEADERS,"ѡ�񱳰��ڵ���[�ɶ�ѡ]",ShowPlayerInventoryList(playerid,1),"ѡ��","ȡ��");
					}
					else
					{
					    forex(i,MAX_PLAYER_SENDGAMEMAIL_ITEMS)NewMailItem[playerid][i][_Used]=false;
					    formatex64("�����ʼ� ����:%s",GameMailTypeName[NewMailType[playerid]]);
						SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"ȷ��","ȡ��");
					}
				}
			}
			return true;
        }
        case _SPD_GAMEMAIL_SEND_ITEM://�ʼ�����������ӽ���
        {
            if(!response)return true;
			new pager=(DialogPage[playerid]-1)*MAX_BOX_LIST;
			if(pager==0)pager = 1;
			else pager++;
			switch(listitem)
			{
			    case 0:
			    {
			        new Rate=0;
			        forex(i,MAX_DIALOG_BOX_ITEMS)
					{
						if(DialogBoxInvSelect[playerid][i]==true)
						{
						    formatex64("%i,%s,%i",DialogBox[playerid][i],DialogBoxKey[playerid][i],0);
						    if(VerifyPlayerGameMailInvPVarData(playerid,string64))
						    {
						        format(NewMailItem[playerid][Rate][_InvKey],37,PlayerInv[playerid][DialogBox[playerid][i]][_InvKey]);
							    NewMailItem[playerid][Rate][_Amount]=DialogBoxInvAmount[playerid][i];
							    NewMailItem[playerid][Rate][_Durable]=PlayerInv[playerid][DialogBox[playerid][i]][_Durable];
							    NewMailItem[playerid][Rate][_ItemID]=PlayerInv[playerid][DialogBox[playerid][i]][_ItemID];
							    NewMailItem[playerid][Rate][_Used]=true;
							    Rate++;
						    }
      					}
                    }
                    forex(i,MAX_DIALOG_BOX_ITEMS)
					{
						DialogBoxInvSelect[playerid][i]=false;
						DialogBoxInvAmount[playerid][i]=0;
					}
                    formatex64("�����ʼ� ����:%s",GameMailTypeName[NewMailType[playerid]]);
                    SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"ȷ��","ȡ��");
			    }
			    case 1:
			  	{
			    	DialogPage[playerid]--;
			    	if(DialogPage[playerid]<1)DialogPage[playerid]=1;
			    	SPD(playerid,_SPD_GAMEMAIL_SEND_ITEM,DIALOG_STYLE_TABLIST_HEADERS,"ѡ�񱳰��ڵ���[�ɶ�ѡ]",ShowPlayerInventoryList(playerid,DialogPage[playerid]),"ѡ��","ȡ��");
				}
				case MAX_BOX_LIST+1:
				{
		    		DialogPage[playerid]++;
		    		SPD(playerid,_SPD_GAMEMAIL_SEND_ITEM,DIALOG_STYLE_TABLIST_HEADERS,"ѡ�񱳰��ڵ���[�ɶ�ѡ]",ShowPlayerInventoryList(playerid,DialogPage[playerid]),"ѡ��","ȡ��");
			    }
				default:
				{
					new index=DialogBox[playerid][pager+listitem-2];
                    if(DialogBoxInvSelect[playerid][pager+listitem-2]==true)
                    {
                        DialogBoxInvSelect[playerid][pager+listitem-2]=false;
                        DialogBoxInvAmount[playerid][pager+listitem-2]=0;
                        SPD(playerid,_SPD_GAMEMAIL_SEND_ITEM,DIALOG_STYLE_TABLIST_HEADERS,"ѡ�񱳰��ڵ���[�ɶ�ѡ]",ShowPlayerInventoryList(playerid,DialogPage[playerid]),"ѡ��","ȡ��");
                    }
                    else
                    {
						if(GetPlayerInvBoxSelectAmount(playerid)>=MAX_PLAYER_SENDGAMEMAIL_ITEMS)
						{
		                	SPD(playerid,_SPD_GAMEMAIL_SEND_ITEM,DIALOG_STYLE_TABLIST_HEADERS,"ѡ�񱳰��ڵ���[���5��]",ShowPlayerInventoryList(playerid,DialogPage[playerid]),"ѡ��","ȡ��");
						}
						else
						{
							if(PlayerInv[playerid][index][_Amounts]>1)
							{
		                    	formatex128("�㵱ǰ��%i��%s\n��������͸õ��ߵ�����",PlayerInv[playerid][index][_Amounts],Item[PlayerInv[playerid][index][_ItemID]][_Name]);
								SPD(playerid,_SPD_GAMEMAIL_SEND_ITEM_AMOUNT,DIALOG_STYLE_INPUT,"������������",string128,"ȷ��","ȡ��");
	                 			formatex64("%i,%s,%i",index,DialogBoxKey[playerid][pager+listitem-2],pager+listitem-2);
								printf("%s",string64);
								SetPVarString(playerid,"_MailInv_Click_Info",string64);
							}
							else
							{
							    DialogBoxInvSelect[playerid][pager+listitem-2]=true;
	    						DialogBoxInvAmount[playerid][pager+listitem-2]=1;
	   							SPD(playerid,_SPD_GAMEMAIL_SEND_ITEM,DIALOG_STYLE_TABLIST_HEADERS,"ѡ�񱳰��ڵ���[�ɶ�ѡ]",ShowPlayerInventoryList(playerid,DialogPage[playerid]),"ѡ��","ȡ��");
	           				}
           				}
					}
				}
			}
			return true;
        }
        case _SPD_GAMEMAIL_SEND_ITEM_AMOUNT://���ñ�����������
        {
            if(!response)return SPD(playerid,_SPD_GAMEMAIL_SEND_ITEM,DIALOG_STYLE_TABLIST_HEADERS,"ѡ�񱳰��ڵ���[�ɶ�ѡ]",ShowPlayerInventoryList(playerid,DialogPage[playerid]),"ѡ��","ȡ��");
            else
            {
                new VarString[64];
 				GetPVarString(playerid,"_MailInv_Click_Info",VarString,64);
                if(VerifyPlayerGameMailInvPVarData(playerid,VarString)==true)
                {
                    new InvID,BoxKey[37],Listid;
    				sscanf(VarString, "p<,>is[37]i",InvID,BoxKey,Listid);
                    if(strval(inputtext)<1||strval(inputtext)>PlayerInv[playerid][InvID][_Amounts])
                    {
                        formatex128("�㵱ǰ��%i��%s\n��������͸õ��ߵ�����",PlayerInv[playerid][InvID][_Amounts],Item[PlayerInv[playerid][InvID][_ItemID]][_Name]);
						SPD(playerid,_SPD_GAMEMAIL_SEND_ITEM_AMOUNT,DIALOG_STYLE_INPUT,"������������",string128,"ȷ��","ȡ��");
					}
					else
					{
					    DialogBoxInvSelect[playerid][Listid]=true;
   						DialogBoxInvAmount[playerid][Listid]=strval(inputtext);
   						SPD(playerid,_SPD_GAMEMAIL_SEND_ITEM,DIALOG_STYLE_TABLIST_HEADERS,"ѡ�񱳰��ڵ���[�ɶ�ѡ]",ShowPlayerInventoryList(playerid,DialogPage[playerid]),"ѡ��","ȡ��");
					}
                }
                //else SPD(playerid,_SPD_GAMEMAIL_SEND_ITEM,DIALOG_STYLE_TABLIST_HEADERS,"ѡ�񱳰��ڵ���[�ɶ�ѡ]",ShowPlayerInventoryList(playerid,1),"ѡ��","ȡ��");
            }
            return true;
        }
        case _SPD_GAMEMAIL_PANEL://����������
        {
            if(!response)return true;
            switch(listitem)
			{
				case 0:
  				{
  				    RestPlayerTempMailData(playerid);
					formatex64("�����ʼ� ����:%s",GameMailTypeName[NewMailType[playerid]]);
  				    SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"ȷ��","ȡ��");
				}
				case 1:
  				{
		    		formatex64("�ʼ���[����%i�� %iδ��]",Iter_Count(PlayerGameMail[playerid]),GetPlayerUnReadGameMails(playerid));
					SPD(playerid,_SPD_GAMEMAIL_LIST,DIALOG_STYLE_TABLIST_HEADERS,string64,ShowPlayerGameMails(playerid,1),"��","ȡ��");
  				}
            }
        }
        case _SPD_GAMEMAIL_SET://�ʼ�����������
        {
            if(!response)return true;
			new VarString[64];
 			GetPVarString(playerid,"_Select_GameMail_Info",VarString,64);
			if(VerifyPlayerGameMailPVarData(playerid,string64)==true)
            {
                new index,indexKey[37];
    			sscanf(VarString, "p<,>is[37]",index,indexKey);
                switch(listitem)
				{
			    	case 0:
			  		{
                        RestPlayerTempMailData(playerid);
                        format(NewMailReceiverKey[playerid],37,PlayerGameMail[playerid][index][_SenderKey]);
						formatex64("�����ʼ� ����:%s",GameMailTypeName[NewMailType[playerid]]);
  				    	SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"ȷ��","ȡ��");
			  		}
			    	case 1:
			  		{
			  		    ExtractGameMailAttachment(playerid,index,PlayerGameMail[playerid][index][_ItemData]);
			  		}
			    	case 2:
			  		{
						formatex128("DELETE FROM `"MYSQL_DB_PLAYERGAMEMAIL"` WHERE `�ʼ��ܳ�` = '%s'",PlayerGameMail[playerid][index][_Key]);
						mysql_query(Account@Handle,string128,false);
					    Iter_Remove(PlayerGameMail[playerid],index);
			  		}
			    	case 3:
			  		{
						formatex128("DELETE FROM `"MYSQL_DB_PLAYERGAMEMAIL"` WHERE `�ռ����ܳ�` = '%s'",PlayerGameMail[playerid][index][_ReceiverKey]);
						mysql_query(Account@Handle,string128,false);
					    Iter_Clear(PlayerGameMail[playerid]);
			  		}
				}
            }
        }
        case _SPD_GAMEMAIL_INFO://�ʼ�����չʾ
        {
            if(!response)return true;
			new VarString[64];
 			GetPVarString(playerid,"_Select_GameMail_Info",VarString,64);
			if(VerifyPlayerGameMailPVarData(playerid,string64)==true)
            {
                new index,indexKey[37];
    			sscanf(VarString, "p<,>is[37]",index,indexKey);
    			PlayerGameMailTypeProcess(playerid,index);
           	}
           	return true;
        }
        case _SPD_GAMEMAIL_LIST://�ʼ��б�
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
			    	formatex64("�ʼ���[����%i�� %iδ��]",Iter_Count(PlayerGameMail[playerid]),GetPlayerUnReadGameMails(playerid));
			    	SPD(playerid,_SPD_GAMEMAIL_LIST,DIALOG_STYLE_TABLIST_HEADERS,string64,ShowPlayerGameMails(playerid,DialogPage[playerid]),"��","ȡ��");
				}
				case MAX_BOX_LIST+1:
				{
		    		DialogPage[playerid]++;
		    		formatex64("�ʼ���[����%i�� %iδ��]",Iter_Count(PlayerGameMail[playerid]),GetPlayerUnReadGameMails(playerid));
					SPD(playerid,_SPD_GAMEMAIL_LIST,DIALOG_STYLE_TABLIST_HEADERS,string64,ShowPlayerGameMails(playerid,DialogPage[playerid]),"��","ȡ��");
			    }
				default:
				{
					new index=DialogBox[playerid][pager+listitem-1];
                    formatex64("%i,%s",index,DialogBoxKey[playerid][pager+listitem-1]);
                    if(VerifyPlayerGameMailPVarData(playerid,string64)==true)
                    {
                        ShowPlayerGameMailInfo(playerid,index);
                        SetPVarString(playerid,"_Select_GameMail_Info",string64);
                   	}
				}
			}
			return true;
        }
    }
    return false;
}
FUNC::PlayerGameMailTypeProcess(playerid,index)
{
	switch(PlayerGameMail[playerid][index][_Type])
	{
		case GAMEMAIL_TYPE_FACTION_REQ:
		{
			new SenderKey[37],FactionKey[37];
    		sscanf(PlayerGameMail[playerid][index][_ExtraData], "p<,>s[37]s[37]",SenderKey,FactionKey);
    		new FactionID=GetPlayerFactionID(playerid);
            if(FactionID==NONE)
            {
				formatex128("DELETE FROM `"MYSQL_DB_PLAYERGAMEMAIL"` WHERE `�ʼ��ܳ�` = '%s'",PlayerGameMail[playerid][index][_Key]);
				mysql_query(Account@Handle,string128,false);
			    Iter_Remove(PlayerGameMail[playerid],index);
			    return SCM(playerid,-1,"���Ѿ�������Ӫ����,�����ʼ��Զ�ʧЧ!");
            }
			if(!Iter_Contains(Faction,FactionID))
			{
				formatex128("DELETE FROM `"MYSQL_DB_PLAYERGAMEMAIL"` WHERE `�ʼ��ܳ�` = '%s'",PlayerGameMail[playerid][index][_Key]);
				mysql_query(Account@Handle,string128,false);
			    Iter_Remove(PlayerGameMail[playerid],index);
			    return SCM(playerid,-1,"����ӪʧЧ��,�����ʼ��Զ�ʧЧ!");
			}
            if(!isequal(Faction[FactionID][_Key],FactionKey,false))
            {
				formatex128("DELETE FROM `"MYSQL_DB_PLAYERGAMEMAIL"` WHERE `�ʼ��ܳ�` = '%s'",PlayerGameMail[playerid][index][_Key]);
				mysql_query(Account@Handle,string128,false);
			    Iter_Remove(PlayerGameMail[playerid],index);
			    return SCM(playerid,-1,"���Ѿ�������Ӫ��,�����ʼ��Զ�ʧЧ!");
            }
            if(!isequal(GetPlayerMySqlFactionFromKey(SenderKey),"null",false))
            {
				formatex128("DELETE FROM `"MYSQL_DB_PLAYERGAMEMAIL"` WHERE `�ʼ��ܳ�` = '%s'",PlayerGameMail[playerid][index][_Key]);
				mysql_query(Account@Handle,string128,false);
			    Iter_Remove(PlayerGameMail[playerid],index);
		    	formatex64("%s �Ѿ�����Ӫ��,�����ʼ��Զ�ʧЧ!",GetPlayerMySqlNameFromKey(SenderKey));
			    return SCM(playerid,-1,string64);
            }
            formatex64("%s ��׼����� %s ��Ӫ��!",Account[playerid][_Name],Faction[FactionID][_Name]);
            SendMailToPlayer("null",PlayerGameMail[playerid][index][_SenderKey],GAMEMAIL_TYPE_SYSTEM,string64,0,"","",SERVER_RUNTIMES);
			formatex128("DELETE FROM `"MYSQL_DB_PLAYERGAMEMAIL"` WHERE `�ʼ��ܳ�` = '%s'",PlayerGameMail[playerid][index][_Key]);
			mysql_query(Account@Handle,string128,false);
		    Iter_Remove(PlayerGameMail[playerid],index);
		    formatex64("����׼ %s ������Ӫ��!",GetPlayerMySqlNameFromKey(SenderKey));
		    SCM(playerid,-1,string64);
		    return 1;
		}
		case GAMEMAIL_TYPE_FRIEND_REQ:
		{

		}
		case GAMEMAIL_TYPE_FACTION_INV:
		{
			new SenderKey[37],FactionKey[37];
    		sscanf(PlayerGameMail[playerid][index][_ExtraData], "p<,>s[37]s[37]",SenderKey,FactionKey);
  			new FactionID=GetPlayerFactionID(playerid);
            if(FactionID!=NONE)
            {
				formatex128("DELETE FROM `"MYSQL_DB_PLAYERGAMEMAIL"` WHERE `�ʼ��ܳ�` = '%s'",PlayerGameMail[playerid][index][_Key]);
				mysql_query(Account@Handle,string128,false);
			    Iter_Remove(PlayerGameMail[playerid],index);
			    return SCM(playerid,-1,"���Ѿ�������Ӫ��������Ӫ��");
            }
            new JoinFactionID=GetFactionIDKey(FactionKey);
            if(JoinFactionID==NONE)
            {
				formatex128("DELETE FROM `"MYSQL_DB_PLAYERGAMEMAIL"` WHERE `�ʼ��ܳ�` = '%s'",PlayerGameMail[playerid][index][_Key]);
				mysql_query(Account@Handle,string128,false);
			    Iter_Remove(PlayerGameMail[playerid],index);
			    return SCM(playerid,-1,"����ӪʧЧ��,�޷�����");            	
            }
            if(GetFactionNumberOfPeople(Faction[JoinFactionID][_Key])>=(Faction[JoinFactionID][_Level]+1)*5) 
            {
				formatex128("DELETE FROM `"MYSQL_DB_PLAYERGAMEMAIL"` WHERE `�ʼ��ܳ�` = '%s'",PlayerGameMail[playerid][index][_Key]);
				mysql_query(Account@Handle,string128,false);
			    Iter_Remove(PlayerGameMail[playerid],index);
			    return SCM(playerid,-1,"����Ӫ�Ѵﵽ��������,�޷�����");              	
            } 	
            SetPlayerToFaction(playerid,FactionKey,JoinFactionID,0,0);
            formatex64("��ɹ���������Ӫ%s",Faction[JoinFactionID][_Name]);
            SCM(playerid,-1,string64);     
		}
		default:SPD(playerid,_SPD_GAMEMAIL_SET,DIALOG_STYLE_LIST,"�ʼ�����",GAMEMAIL_USE_PANEL,"ȷ��","ȡ��");
	}
	return 1;
}
FUNC::bool:VerifyPlayerGameMailPVarData(playerid,VarString[])//��֤�ʼ�����
{
	new GameMailID,GameMailKey[37];
    if(sscanf(VarString, "p<,>is[37]",GameMailID,GameMailKey))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"����[#0]","�Ի���������֤ʧ��,������ѡ��","�˽�","");
        return false;
	}
	if(!Iter_Contains(PlayerGameMail[playerid],GameMailID))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"����[#1]","��������ʧЧ,������ѡ��","�˽�","");
        return false;
	}
    if(!isequal(PlayerGameMail[playerid][GameMailID][_Key],GameMailKey,false))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"����[#2]","�Ի���������֤ʧ��,������ѡ��","�˽�","");
        return false;
	}
	return true;
}
FUNC::bool:VerifyPlayerGameMailInvPVarData(playerid,VarString[])//��֤�ʼ���������
{
	new InvID,BoxKey[37],Listid;
    if(sscanf(VarString, "p<,>is[37]i",InvID,BoxKey,Listid))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"����[#0]","�Ի���������֤ʧ��,������ѡ��","�˽�","");
        return false;
	}
	if(!Iter_Contains(PlayerInv[playerid],InvID))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"����[#1]","��������ʧЧ,������ѡ��","�˽�","");
        return false;
	}
	printf("%s %s",PlayerInv[playerid][InvID][_InvKey],BoxKey);
    if(!isequal(PlayerInv[playerid][InvID][_InvKey],BoxKey,false))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"����[#2]","�Ի���������֤ʧ��,������ѡ��","�˽�","");
        return false;
	}
	return true;
}
/*			  		    forex(i,MAX_DIALOG_BOX_ITEMS)
					    {
					        if(DialogBoxInvSelect[playerid][i]==true)
					        {
					        	if(VerifyPlayerGameMailItemData(playerid,i))
					        	{

					        	}
							}
						}*/
FUNC::bool:SendGameMail(playerid)//�༭�ʼ���ɷ����ʼ�����
{
    if(strlen(NewMailReceiverKey[playerid])<1)
	{
	    SCM(playerid,-1,"�㻹û����д�ռ���");
		return false;
	}
    if(NewMailCash[playerid]>Account[playerid][_Cash])
	{
	    SCM(playerid,-1,"�㻹û����ô����");
		return false;
	}
	else
	{
	    Account[playerid][_Cash]-=NewMailCash[playerid];
	    UpdateAccountCash(playerid,Account[playerid][_Cash]);
	}
	new BodyStr[512],TempStr[64];
    format(BodyStr,512,"");
    format(TempStr,64,"");
	forex(i,MAX_PLAYER_SENDGAMEMAIL_ITEMS)
    {
        if(NewMailItem[playerid][i][_Used]==true)
        {
        	if(VerifyPlayerGameMailItemData(playerid,i))
        	{
				format(TempStr,64,"%s,%i,%0.1f&",Item[NewMailItem[playerid][i][_ItemID]][_Key],NewMailItem[playerid][i][_Amount],NewMailItem[playerid][i][_Durable]);
                strcat(BodyStr,TempStr);
                DeleteAmountForInvByInvKey(playerid,NewMailItem[playerid][i][_InvKey],NewMailItem[playerid][i][_Amount]);
        	}
        	else
        	{
        	    formatex64("%s ����ʧ��",Item[NewMailItem[playerid][i][_ItemID]][_Name]);
        	    SCM(playerid,-1,string64);
        	}
		}
	}
	if(SendMailToPlayer(Account[playerid][_Key],NewMailReceiverKey[playerid],NewMailType[playerid],NewMailContent[playerid],NewMailCash[playerid],BodyStr,"-1",SERVER_RUNTIMES)!=RETURN_SUCCESS)
	{
	    SCM(playerid,-1,"Ͷ��ʧ��,�Է���������");
	    return false;
	}
/*    new ReceiveID=GetPlayerIDByKey(NewMailReceiverKey[playerid]);
	if(ReceiveID==NONE)
	{
		if(SendGameMailToOffLPlayer(Account[playerid][_Key],NewMailReceiverKey[playerid],NewMailType[playerid],NewMailContent[playerid],NewMailCash[playerid],BodyStr,"-1",SERVER_RUNTIMES)!=RETURN_SUCCESS)
		{
		    SCM(playerid,-1,"Ͷ��ʧ��,�Է���������");
		    return false;
		}
	}
	else
	{
		if(SendGameMailToOnlPlayer(playerid,ReceiveID,NewMailType[playerid],NewMailContent[playerid],NewMailCash[playerid],BodyStr,"-1",SERVER_RUNTIMES)!=RETURN_SUCCESS)
		{
		    SCM(playerid,-1,"Ͷ��ʧ��,�Է���������");
      		return false;
		}
	}*/
	return true;
}
FUNC::RestPlayerTempMailData(playerid)
{
	forex(i,MAX_PLAYER_SENDGAMEMAIL_ITEMS)NewMailItem[playerid][i][_Used]=false;
	NewMailType[playerid]=GAMEMAIL_TYPE_PLAYER;
	NewMailCash[playerid]=0;
	format(NewMailContent[playerid],256,"");
	format(NewMailReceiverKey[playerid],37,"");
	forex(i,MAX_DIALOG_BOX_ITEMS)
	{
		DialogBoxInvSelect[playerid][i]=false;
		DialogBoxInvAmount[playerid][i]=0;
	}
	return 1;
}
FUNC::bool:VerifyPlayerGameMailItemData(playerid,index)//��֤��ʱ�༭�ʼ�״̬����
{
	if(NewMailItem[playerid][index][_Used]==false)return false;
	new InvID=GetPlayerInvIDByInvKey(playerid,NewMailItem[playerid][index][_InvKey]);
	if(InvID==NONE)return false;
	if(PlayerInv[playerid][InvID][_Amounts]<NewMailItem[playerid][index][_Amount])return false;
	if(PlayerInv[playerid][InvID][_Durable]<NewMailItem[playerid][index][_Durable])return false;
	return true;
}
