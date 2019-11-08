stock GivePlayerDressEquip(playerid)
{
	if(Account[playerid][_Spawn]==true)
	{
		forex(i,10)
		{
			if(IsPlayerAttachedObjectSlotUsed(playerid,i))RemovePlayerAttachedObject(playerid,i);
        }
		if(Iter_Count(PlayerEquip[playerid])>0)
		{
			for(new i=Iter_End(PlayerEquip[playerid]);(i=Iter_Prev(PlayerEquip[playerid],i))!=Iter_Begin(PlayerEquip[playerid]);)
			{
			    SetPlayerDressEquip(playerid,PlayerEquip[playerid][i][_ItemID],Item[PlayerEquip[playerid][i][_ItemID]][_AttachPosID]);
			}
		}
	}
	return 1;
}
FUNC::GetItemAttachPosID(modelid)
{
	forex(i,sizeof(ItemAttachPos))
	{
	    if(ItemAttachPos[i][_Model]==modelid)return i;
	}
	return NONE;
}
FUNC::RemovePlayerDressEquip(playerid,ItemID)
{
	if(IsPlayerAttachedObjectSlotUsed(playerid,Item[ItemID][_EquipDressSlot]))RemovePlayerAttachedObject(playerid,Item[ItemID][_EquipDressSlot]);
	return 1;
}
FUNC::SetPlayerDressEquip(playerid,ItemID,AttachPosID)
{
	if(IsPlayerAttachedObjectSlotUsed(playerid,Item[ItemID][_EquipDressSlot]))RemovePlayerAttachedObject(playerid,Item[ItemID][_EquipDressSlot]);
    if(AttachPosID!=NONE)
    {
	    SetPlayerAttachedObject(playerid,\
		Item[ItemID][_EquipDressSlot],\
		Item[ItemID][_Model],\
		Item[ItemID][_EquipBone],\
		ItemAttachPos[AttachPosID][_fOffsetX],\
		ItemAttachPos[AttachPosID][_fOffsetY], \
		ItemAttachPos[AttachPosID][_fOffsetZ], \
		ItemAttachPos[AttachPosID][_fRotX], \
		ItemAttachPos[AttachPosID][_fRotY], \
		ItemAttachPos[AttachPosID][_fRotZ], \
		ItemAttachPos[AttachPosID][_fScaleX], \
		ItemAttachPos[AttachPosID][_fScaleY], \
		ItemAttachPos[AttachPosID][_fScaleZ]);
		printf("%i,%i",Item[ItemID][_Model],Item[ItemID][_EquipBone]);
	}
	else
	{
	    SetPlayerAttachedObject(playerid,\
		Item[ItemID][_EquipDressSlot],\
		Item[ItemID][_Model],\
		Item[ItemID][_EquipBone],\
		0.0,\
		0.0, \
		0.0, \
		0.0, \
		0.0, \
		0.0, \
		1.0, \
		1.0, \
		1.0);
	}
	return 1;
}
FUNC::bool:IsPlayerDressEquipSlotUsed(playerid,index)
{
    if(Iter_Contains(PlayerEquip[playerid],index))return true;
    return false;
}
FUNC::AddItemToPlayerEquip(playerid,ItemKey[],Float:Durable,GetTime)//������ӵ�װ��
{
	new ItemID=GetItemIDByItemKey(ItemKey);
	if(ItemID==NONE)
	{
	    formatex80("%i-aitpe error0",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
	new index=Item[ItemID][_EquipDressSlot];
	if(Iter_Contains(PlayerEquip[playerid],index))
	{
	    formatex80("%i-aitpe error1",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
	if(Durable<=0.0)return RETURN_SUCCESS;
	if(Iter_Count(PlayerEquip[playerid])>=MAX_PLAYER_EQUIPS)
	{
	    formatex80("%i-aitpe error2",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
    //new AttachPosID=GetItemAttachPosID(Item[ItemID][_Model]);
/*    if(AttachPosID==NONE)
    {
	    formatex80("%i-aitpe error3",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }*/
   	format(PlayerEquip[playerid][index][_AccountKey],UUID_LEN,Account[playerid][_Key]);
   	UUID(PlayerEquip[playerid][index][_EquipKey], UUID_LEN);
	format(PlayerEquip[playerid][index][_ItemKey],UUID_LEN,ItemKey);
   	PlayerEquip[playerid][index][_Durable]=Durable;
   	if(GetTime==NONE)PlayerEquip[playerid][index][_GetTime]=SERVER_RUNTIMES;
   	else PlayerEquip[playerid][index][_GetTime]=GetTime;
   	PlayerEquip[playerid][index][_ItemID]=ItemID;
    formatex512("INSERT INTO `"MYSQL_DB_EQUIP"`(`�����ܳ�`,`װ���ܳ�`,`��Ʒ�ܳ�`,`װ���;�`,`���ʱ��`) VALUES ('%s','%s','%s','%f','%i')",PlayerEquip[playerid][index][_AccountKey],PlayerEquip[playerid][index][_EquipKey],PlayerEquip[playerid][index][_ItemKey],PlayerEquip[playerid][index][_Durable],PlayerEquip[playerid][index][_GetTime]);
	mysql_query(Account@Handle,string512,true);
    Iter_Add(PlayerEquip[playerid],index);
	if(InventoryTextDrawShow[playerid]==true)UpdatePlayerEquip(playerid);
	SetPlayerDressEquip(playerid,ItemID,Item[ItemID][_AttachPosID]);
	CompositeItemAdditionForPlayer(playerid);
	return RETURN_SUCCESS;
}
FUNC::ReduceDurableForPlayerEquip(playerid,ItemKey[],Float:Durable)//װ�����߽����;�
{
    new ItemID=GetItemIDByItemKey(ItemKey);
	if(ItemID==NONE)
	{
	    formatex80("%i-rdfpe error0",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
    new index=Item[ItemID][_EquipDressSlot];
    if(!Iter_Contains(PlayerEquip[playerid],index))
	{
	    formatex80("%i-rdfpe error1",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
    if(PlayerEquip[playerid][index][_ItemID]!=ItemID)
	{
	    formatex80("%i-rdfpe error2",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
	if(Item[ItemID][_Durable]==0)return RETURN_SUCCESS;
    if(Durable<=0.0)return RETURN_SUCCESS;
    if(PlayerEquip[playerid][index][_Durable]>Durable)
    {
    	PlayerEquip[playerid][index][_Durable]-=Durable;
    	formatex256("UPDATE `"MYSQL_DB_EQUIP"` SET  `װ���;�` =  '%0.1f' WHERE  `"MYSQL_DB_EQUIP"`.`װ���ܳ�` ='%s'",PlayerEquip[playerid][index][_Durable],PlayerEquip[playerid][index][_EquipKey]);
		mysql_query(Account@Handle,string256,false);
    }
    else
	{
	    RemovePlayerDressEquip(playerid,ItemID);
 		formatex256("DELETE FROM `"MYSQL_DB_EQUIP"` WHERE `װ���ܳ�`='%s'",PlayerEquip[playerid][index][_EquipKey]);
		mysql_query(Account@Handle,string256,false);
		new	cur = index;
		Iter_SafeRemove(PlayerEquip[playerid],cur,index);
		CompositeItemAdditionForPlayer(playerid);
	}
	if(InventoryTextDrawShow[playerid]==true)UpdatePlayerEquip(playerid);
	return RETURN_SUCCESS;
}
FUNC::LoadPlayerEquip(playerid)//��ȡ���װ��
{
	formatex128("SELECT * FROM `"MYSQL_DB_EQUIP"` WHERE `�����ܳ�`='%s'",Account[playerid][_Key]);
    mysql_query(Account@Handle,string128,true);
//    mysql_tquery(Account@Handle,string128, "OnPlayerEquipLoad", "i",playerid);
//	return 1;
//}
//FUNC::OnPlayerEquipLoad(playerid)
//{
    forex(i,cache_num_rows())
	{
	    if(i<MAX_PLAYER_EQUIPS)
	    {
	        new strings[37];
	        cache_get_field_content(i,"��Ʒ�ܳ�",strings,Account@Handle,37);
	        new GetItemID=GetItemIDByItemKey(strings);
	        if(GetItemID==NONE)
			{
			    new strings1[37];
				cache_get_field_content(i,"װ���ܳ�",strings1,Account@Handle,37);
	    	    formatex128("DELETE FROM `"MYSQL_DB_EQUIP"` WHERE `"MYSQL_DB_EQUIP"`.`װ���ܳ�` ='%s'",strings1);
				mysql_query(Account@Handle,string128,false);
				printf("%s װ��,װ���ܳ�-[%s] ��Ʒ�ܳ�-[%s]�쳣,��ɾ��",Account[playerid][_Name],strings1,strings);
	    	}
	    	else
	    	{
	    	    new index=Item[GetItemID][_EquipDressSlot];
	    	    if(Iter_Contains(PlayerEquip[playerid],index)||index==NONE)
	    	    {
	    	    	new strings1[37];
					cache_get_field_content(i,"װ���ܳ�",strings1,Account@Handle,37);
	    	    	formatex128("DELETE FROM `"MYSQL_DB_EQUIP"` WHERE `"MYSQL_DB_EQUIP"`.`װ���ܳ�` ='%s'",strings1);
					mysql_query(Account@Handle,string128,false);
					printf("%s װ��,װ���ܳ�-[%s] ��Ʒ�ܳ�-[%s]װ��λ�ظ�,��ɾ��",Account[playerid][_Name],strings1,strings);
	    	    }
	    	    else
	    	    {
            		cache_get_field_content(i,"�����ܳ�",PlayerEquip[playerid][index][_AccountKey],Account@Handle,37);
            		cache_get_field_content(i,"װ���ܳ�",PlayerEquip[playerid][index][_EquipKey],Account@Handle,37);
            		cache_get_field_content(i,"��Ʒ�ܳ�",PlayerEquip[playerid][index][_ItemKey],Account@Handle,37);
	    			PlayerEquip[playerid][index][_Durable]=cache_get_field_content_float(i,"װ���;�",Account@Handle);
            		PlayerEquip[playerid][index][_GetTime]=cache_get_field_content_int(i,"���ʱ��",Account@Handle);
	    	    	PlayerEquip[playerid][index][_ItemID]=GetItemID;
					Iter_Add(PlayerEquip[playerid],index);
					printf("%s װ��,װ���ܳ�-[%s] ��Ʒ�ܳ�-[%s] [%s]",Account[playerid][_Name],PlayerEquip[playerid][index][_EquipKey],PlayerEquip[playerid][index][_ItemKey],Item[GetItemID][_Name]);
				}
			}
		}
		else
		{
		    printf("%s װ�����",Account[playerid][_Name]);
			break;
		}
	}
	GivePlayerDressEquip(playerid);
	CompositeItemAdditionForPlayer(playerid);
	return 1;
}
FUNC::RestPlayerEquip(playerid)
{
   	Iter_Clear(PlayerEquip[playerid]);
	return 1;
}
