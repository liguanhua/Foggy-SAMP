FUNC::CreateItemListSqlData()
{
	new d@0,d@1[64],d@2,d@3[64],d@4[64],d@5[64],d@6,d@7,d@8,d@9,d@10,d@11,Float:d@12,Float:d@13,d@14;
	forex(i,sizeof(ItemEx))
	{
	    d@0=ItemEx[i][_Model];
	    format(d@1,64,ItemEx[i][_Key]);
	    d@2=ItemEx[i][_Type];
	    format(d@3,64,ItemEx[i][_Name]);
	    format(d@4,64,ItemEx[i][_NameTXD]);
	    format(d@5,64,ItemEx[i][_WeaponTXD]);
	    d@6=ItemEx[i][_WeaponID];
	    d@7=ItemEx[i][_WeaponDressSlot];
	    d@8=ItemEx[i][_EquipDressSlot];
	    d@9=ItemEx[i][_EquipBone];
	    d@10=ItemEx[i][_Durable];
	    d@11=ItemEx[i][_BuffTime];
	    d@12=ItemEx[i][_BuffEffect];
	    d@13=ItemEx[i][_Weight];
	    d@14=ItemEx[i][_Overlap];
		formatex2048("INSERT INTO `"MYSQL_DB_ITEM_LIST"` (\
					`ģ��`,\
					`�ܳ�`,\
					`����`,\
					`����`,\
					`TXD����`,\
					`����TXD����`,\
					`����ID`,\
					`������λ`,\
					`װ����λ`,\
					`װ����λ`,\
					`�����;�`,\
					`BUFF����ʱ��`,\
					`BUFF/����Ч��`,\
					`����`,\
					`�����ص�`\
					)\
					VALUES\
					('%i','%s','%i','%s','%s','%s','%i','%i','%i','%i','%i','%f','%f','%f','%i')",\
					d@0,d@1,d@2,d@3,d@4,\
					d@5,d@6,d@7,d@8,\
					d@9,d@10,d@11,d@12,d@13,d@14);
		mysql_query(Static@Handle,string2048,false);
	}
	return 1;
}
FUNC::LoadItemLists()
{
	formatex128("SELECT * FROM `"MYSQL_DB_ITEM_LIST"`");
    mysql_query(Static@Handle,string128,true);
    forex(i,cache_num_rows())
	{
	    if(i<MAX_ITEMS)
	    {
        	Item[i][_Model]=cache_get_field_content_int(i,"ģ��",Static@Handle);
        	cache_get_field_content(i,"�ܳ�",Item[i][_Key],Static@Handle,37);
            Item[i][_Type]=cache_get_field_content_int(i,"����",Static@Handle);
            cache_get_field_content(i,"����",Item[i][_Name],Static@Handle,32);
            cache_get_field_content(i,"TXD����",Item[i][_NameTXD],Static@Handle,64);
            cache_get_field_content(i,"����TXD����",Item[i][_WeaponTXD],Static@Handle,64);
            Item[i][_WeaponID]=cache_get_field_content_int(i,"����ID",Static@Handle);
            Item[i][_WeaponDressSlot]=cache_get_field_content_int(i,"������λ",Static@Handle);
            Item[i][_EquipDressSlot]=cache_get_field_content_int(i,"װ����λ",Static@Handle);
            Item[i][_EquipBone]=cache_get_field_content_int(i,"װ����λ",Static@Handle);
            Item[i][_Durable]=cache_get_field_content_int(i,"�����;�",Static@Handle);
            Item[i][_BuffTime]=cache_get_field_content_int(i,"BUFF����ʱ��",Static@Handle);
            Item[i][_BuffEffect]=cache_get_field_content_float(i,"BUFF/����Ч��",Static@Handle);
            Item[i][_Weight]=cache_get_field_content_float(i,"����",Static@Handle);
            Item[i][_Overlap]=cache_get_field_content_int(i,"�����ص�",Static@Handle);
            Item[i][_ExplosionSize]=cache_get_field_content_float(i,"��ը��Χ",Static@Handle);
            Item[i][_AttachPosID]=GetItemAttachPosID(Item[i][_Model]);
            Item[i][_SellPrice]=cache_get_field_content_int(i,"���ۼ۸�",Static@Handle);
            cache_get_field_content(i,"�ӳ�����",Item[i][_AdditionData],Static@Handle,256);
            cache_get_field_content(i,"����",Item[i][_Description],Static@Handle,128);
            Iter_Add(Item,i);
            printf("���߱�-[%s]-[%s]��ȡ�ɹ�[�������ݱ�%i]",Item[i][_Name],Item[i][_Key],Item[i][_AttachPosID]);
	    }
        else printf("���߱����");
	}
	return 1;
}
FUNC::IsItemKeySame(ItemKey[])
{
	foreach(new i:Item)if(isequal(Item[i][_Key],ItemKey,false))return 1;
	return 0;
}
CMD:additem(playerid, params[])
{
	if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<3)return SCM(playerid,-1,"�㲻�ǹ���Ա3��");
	new d@0,d@1[37],d@2,d@3[32],d@4[64],d@5[64],d@6,d@7,d@8,d@9,d@10,d@11,Float:d@12,Float:d@13,d@14,d@15;
    if(sscanf(params, "p<,>is[37]is[32]s[64]s[64]iiiiiiffif",d@0,d@1,d@2,d@3,d@4,d@5,d@6,d@7,d@8,d@9,d@10,d@11,d@12,d@13,d@14,d@15))
	{
		return SCM(playerid,-1,"��ʽ����");
    }
    if(Iter_Count(Item)>=MAX_ITEMS)return SCM(playerid,-1,"���߱��ѵ�����,���޸�MAX_ITEMS");
    if(IsItemKeySame(d@1))return SCM(playerid,-1,"����KEY�ظ�");
    new i=Iter_Free(Item);
    Item[i][_Model]=d@0;
    format(Item[i][_Key],37,d@1);
    Item[i][_Type]=d@2;
    format(Item[i][_Name],32,d@3);
    format(Item[i][_NameTXD],64,d@4);
    format(Item[i][_WeaponTXD],64,d@5);
    Item[i][_WeaponID]=d@6;
    Item[i][_WeaponDressSlot]=d@7;
    Item[i][_EquipDressSlot]=d@8;
    Item[i][_EquipBone]=d@9;
    Item[i][_Durable]=d@10;
    Item[i][_BuffTime]=d@11;
    Item[i][_BuffEffect]=d@12;
    Item[i][_Weight]=d@13;
    Item[i][_Overlap]=d@14;
    Item[i][_SellPrice]=0;
    Item[i][_ExplosionSize]=d@15;
    Item[i][_AttachPosID]=GetItemAttachPosID(Item[i][_Model]);
    format(Item[i][_AdditionData],256,"");
    Iter_Add(Item,i);
	formatex2048("INSERT INTO `"MYSQL_DB_ITEM_LIST"` (\
					`ģ��`,\
					`�ܳ�`,\
					`����`,\
					`����`,\
					`TXD����`,\
					`����TXD����`,\
					`����ID`,\
					`������λ`,\
					`װ����λ`,\
					`װ����λ`,\
					`�����;�`,\
					`BUFF����ʱ��`,\
					`BUFF/����Ч��`,\
					`����`,\
					`�����ص�`,\
					`��ը��Χ`\
					)\
					VALUES\
					('%i','%s','%i','%s','%s','%s','%i','%i','%i','%i','%i','%f','%f','%f','%i','%f')",\
					d@0,d@1,d@2,d@3,d@4,\
					d@5,d@6,d@7,d@8,\
					d@9,d@10,d@11,d@12,d@13,d@14,d@15);
	mysql_query(Static@Handle,string2048,false);
	return 1;
}
stock GetItemTypeName(ItemType)
{
	new Iname[32];
	format(Iname,32,"����");
	switch(ItemType)
	{
		case ITEM_TYPE_WEAPON:format(Iname,32,"������");//������
		case ITEM_TYPE_MEDICAL:format(Iname,32,"ҽ����");//ҽ����
		case ITEM_TYPE_FOOD:format(Iname,32,"ʳƷ��");//ʳƷ��
		case ITEM_TYPE_EQUIP:format(Iname,32,"װ����");//װ����
		case ITEM_TYPE_VEHICLETACKLE:format(Iname,32,"������Ʒ��");//������Ʒ��
		case ITEM_TYPE_COMMU:format(Iname,32,"ͨ����");//ͨ����
		case ITEM_TYPE_CRAFT:format(Iname,32,"������");//������
		case ITEM_TYPE_BOMB:format(Iname,32,"������");//������
		case ITEM_TYPE_ANTIBIOTIC:format(Iname,32,"����Ⱦ��");//������
	}
	return Iname;
}
stock ShowItems(playerid,pager)
{
    DialogBoxID[playerid]=1;
	foreach(new i:Item)
	{
		DialogBox[playerid][DialogBoxID[playerid]]=i;
		format(DialogBoxKey[playerid][DialogBoxID[playerid]],UUID_LEN,Item[i][_Key]);
		DialogBoxID[playerid]++;
	}
    new BodyStr[1024],TempStr[64],end=0,index;
    if(pager<1)pager=1;
//    if(pager>floatround((DialogBoxID[playerid]-1)/float(MAX_BOX_LIST),floatround_ceil))pager=floatround((DialogBoxID[playerid]-1)/float(MAX_BOX_LIST),floatround_ceil);
    DialogPage[playerid]=pager;
    pager=(pager-1)*MAX_BOX_LIST;
    if(pager==0)pager=1;else pager++;
	format(BodyStr,sizeof(BodyStr), "����\tģ��\t����\n");
	strcat(BodyStr,"\t��һҳ\n");
	loop(i,pager,pager+MAX_BOX_LIST)
	{
		index=DialogBox[playerid][i];
		if(i<DialogBoxID[playerid])
		{
			format(TempStr,sizeof(TempStr),"%s\t%i\t%s\n",Item[index][_Name],Item[index][_Model],GetItemTypeName(Item[index][_Type]));
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
/**********************************************************/

FUNC::CreateCraftItemListSqlData()
{
	new d@0,d@1[64],d@2,d@3,d@4,d@5[512];
	forex(i,sizeof(CraftItemEx))
	{
	    d@0=CraftItemEx[i][_Type];
	    format(d@1,64,CraftItemEx[i][_Key]);
	    d@2=CraftItemEx[i][_PrivateAllow];
	    d@3=CraftItemEx[i][_ModelID];
	    d@4=CraftItemEx[i][_Level];
        format(d@5,512,CraftItemEx[i][_NeedThing]);
		formatex2048("INSERT INTO `"MYSQL_DB_CRAFTITEM_LIST"` (\
					`����`,\
					`�ܳ�`,\
					`˽������`,\
					`ģ��`,\
					`�ȼ�`,\
					`����`)\
					VALUES\
					('%i','%s','%i','%i','%i','%s')",\
					d@0,d@1,d@2,d@3,d@4,d@5);
		mysql_query(Static@Handle,string2048,false);
	}
	return 1;
}
FUNC::LoadCraftItemLists()
{
	formatex128("SELECT * FROM `"MYSQL_DB_CRAFTITEM_LIST"`");
    mysql_query(Static@Handle,string128,true);
    forex(i,cache_num_rows())
	{
	    if(i<MAX_CRAFTITEMS)
	    {
        	CraftItem[i][_Type]=cache_get_field_content_int(i,"����",Static@Handle);
        	cache_get_field_content(i,"�ܳ�",CraftItem[i][_Key],Static@Handle,37);
            CraftItem[i][_PrivateAllow]=cache_get_field_content_int(i,"˽������",Static@Handle);
            CraftItem[i][_ModelID]=cache_get_field_content_int(i,"ģ��",Static@Handle);
            CraftItem[i][_Level]=cache_get_field_content_int(i,"�ȼ�",Static@Handle);
            CraftItem[i][_Capacity]=cache_get_field_content_int(i,"����",Static@Handle);
            cache_get_field_content(i,"����",CraftItem[i][_NeedThing],Static@Handle,512);
            Iter_Add(CraftItem,i);
            printf("������-[%i]-[%s]��ȡ�ɹ�",CraftItem[i][_ModelID],CraftItem[i][_Key]);
	    }
        else printf("���������");
	}
	return 1;
}
stock GetCraftItemTypeName(CraftItemType)
{
	new Iname[32];
	format(Iname,32,"����");
	switch(CraftItemType)
	{
    	case CRAFT_TPYE_HOUSE:format(Iname,32,"����");//������
    	case CRAFT_TPYE_FENCE:format(Iname,32,"Χǽ");//������
    	case CRAFT_TPYE_DOOR:format(Iname,32,"��");//������
    	case CRAFT_TPYE_STARIS:format(Iname,32,"¥��");//������
    	case CRAFT_TPYE_COFFER:format(Iname,32,"������");//������
    	case CRAFT_TPYE_OTHER:format(Iname,32,"����");//������
	}
	return Iname;
}
stock MakeTypeCraftItemKey(Type)
{
	new Count=0;
	foreach(new i:CraftItem)if(CraftItem[i][_Type]==Type)Count++;
	formatex32("B00%i_00%i",Type,Count);
	return string32;
}
FUNC::IsCraftItemKeySame(ItemKey[])
{
	foreach(new i:CraftItem)if(isequal(CraftItem[i][_Key],ItemKey,false))return 1;
	return 0;
}
CMD:addcraftitem(playerid, params[])
{
	if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<3)return SCM(playerid,-1,"�㲻�ǹ���Ա3��");
	new d@0,d@1,d@2,d@3,d@4[512];
    if(sscanf(params, "iiiis[512]",d@0,d@1,d@2,d@3,d@4))
	{
		return SCM(playerid,-1,"��ʽ����[0-���� 1-Χǽ 2-�� 3-¥�� 4-������ 5-����]");
    }
    if(d@0<CRAFT_TPYE_HOUSE||d@0>CRAFT_TPYE_OTHER)return SCM(playerid,-1,"������0-5֮��");
    if(Iter_Count(CraftItem)>=MAX_CRAFTITEMS)return SCM(playerid,-1,"�������ѵ�����,���޸�MAX_CRAFTITEMS");
    new i=Iter_Free(CraftItem);
    new MakeKey[37];
    format(MakeKey,37,MakeTypeCraftItemKey(d@0));
    if(IsCraftItemKeySame(MakeKey))return SCM(playerid,-1,"�����ܳ��ظ�");
	CraftItem[i][_Type]=d@0;
    format(CraftItem[i][_Key],37,MakeKey);
    CraftItem[i][_PrivateAllow]=d@1;
    CraftItem[i][_ModelID]=d@2;
    CraftItem[i][_Level]=d@3;
    CraftItem[i][_Capacity]=0;
    format(CraftItem[i][_NeedThing],512,d@4);
    Iter_Add(CraftItem,i);
	formatex1024("INSERT INTO `"MYSQL_DB_CRAFTITEM_LIST"` (\
					`����`,\
					`�ܳ�`,\
					`˽������`,\
					`ģ��`,\
					`�ȼ�`,\
					`����`)\
					VALUES\
					('%i','%s','%i','%i','%i','%s')",\
					d@0,CraftItem[i][_Key],d@1,d@2,d@3,d@4);
	mysql_query(Static@Handle,string1024,false);
	return 1;
}


/**********************************************************/
FUNC::LoadPickUpSpawns()
{
	formatex128("SELECT * FROM `"MYSQL_DB_PICKUP_SPAWNS"`");
    mysql_query(Static@Handle,string128,true);
    forex(i,cache_num_rows())
	{
	    if(i<MAX_PICKUP_SPAWNS)
	    {
        	PickUpSpawn[i][_X]=cache_get_field_content_float(i,"X����",Static@Handle);
        	PickUpSpawn[i][_Y]=cache_get_field_content_float(i,"Y����",Static@Handle);
        	PickUpSpawn[i][_Z]=cache_get_field_content_float(i,"Z����",Static@Handle);
        	PickUpSpawn[i][_RX]=cache_get_field_content_float(i,"RX����",Static@Handle);
        	PickUpSpawn[i][_RY]=cache_get_field_content_float(i,"RY����",Static@Handle);
        	PickUpSpawn[i][_RZ]=cache_get_field_content_float(i,"RZ����",Static@Handle);
        	PickUpSpawn[i][_Amount]=cache_get_field_content_int(i,"����",Static@Handle);
        	cache_get_field_content(i,"����Key",PickUpSpawn[i][_ItemKey],Static@Handle,37);
        	new ItemID=GetItemIDByItemKey(PickUpSpawn[i][_ItemKey]);
			if(ItemID==NONE)format(PickUpSpawn[i][_ItemKey],37,"");
            Iter_Add(PickUpSpawn,i);
            printf("ʰȡ��-[%s][%0.1f,%0.1f,%0.1f]��ȡ�ɹ�",PickUpSpawn[i][_ItemKey],PickUpSpawn[i][_X],PickUpSpawn[i][_Y],PickUpSpawn[i][_Z],PickUpSpawn[i][_RX],PickUpSpawn[i][_RY],PickUpSpawn[i][_RZ]);
	    }
        else printf("ʰȡ�����");
	}
	return 1;
}
CMD:addpickup(playerid, params[])
{
	if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<3)return SCM(playerid,-1,"�㲻�ǹ���Ա3��");
	new IsUseItem,ItemAmount;
	if(sscanf(params, "ii",IsUseItem,ItemAmount))return SCM(playerid,-1,"ʰȡ��������� /addpickup [0/1 ���/ָ������] [����]");
    if(ItemAmount<1||ItemAmount>999)return SCM(playerid,-1,"������1-999֮��");
    if(Iter_Count(PickUpSpawn)>=MAX_PICKUP_SPAWNS)return SCM(playerid,-1,"ʰȡ���ѵ�����,���޸�MAX_PICKUP_SPAWNS");
    if(IsUseItem)
	{
		SPD(playerid,_SPD_GM_ADD_PICKUP,DIALOG_STYLE_TABLIST_HEADERS,"���ʰȡ��",ShowItems(playerid,DialogPage[playerid]),"ȷ��","ȡ��");
		SetPVarInt(playerid,"admin_addpickup_amount",ItemAmount);
		
	}
    else
    {
    	new i=Iter_Free(PickUpSpawn);
    	CA_FindZ_For2DCoord(PlayerPos[playerid][0],PlayerPos[playerid][1],PlayerPos[playerid][2]);
    	
       	PickUpSpawn[i][_X]=PlayerPos[playerid][0];
       	PickUpSpawn[i][_Y]=PlayerPos[playerid][1];
       	PickUpSpawn[i][_Z]=PlayerPos[playerid][2];
       	PickUpSpawn[i][_RX]=0.0;
       	PickUpSpawn[i][_RY]=0.0;
       	PickUpSpawn[i][_RZ]=0.0;
       	PickUpSpawn[i][_Amount]=1;
       	format(PickUpSpawn[i][_ItemKey],37,"");
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
						PickUpSpawn[i][_X],PickUpSpawn[i][_Y],PickUpSpawn[i][_Z],PickUpSpawn[i][_RX],PickUpSpawn[i][_RY],PickUpSpawn[i][_RZ],1,PickUpSpawn[i][_ItemKey]);
		mysql_query(Static@Handle,string1024,false);
		CreatePickUpData(Item[Iter_Random(Item)][_Key],1,100.0,PickUpSpawn[i][_X],PickUpSpawn[i][_Y],PickUpSpawn[i][_Z],PickUpSpawn[i][_RX],PickUpSpawn[i][_RY],PickUpSpawn[i][_RZ],0,0,0);
    }
	return 1;
}
FUNC::CratePickUpsFromPickUpSpawns()
{
	foreach(new i:PickUpSpawn)
	{
	    new ItemID=GetItemIDByItemKey(PickUpSpawn[i][_ItemKey]);
		if(ItemID==NONE)ItemID=Iter_Random(Item);
		CreatePickUpData(Item[ItemID][_Key],PickUpSpawn[i][_Amount],100.0,PickUpSpawn[i][_X],PickUpSpawn[i][_Y],PickUpSpawn[i][_Z],PickUpSpawn[i][_RX],PickUpSpawn[i][_RY],PickUpSpawn[i][_RZ],0,0,0,false);
       	printf("ʰȡ��-[%s][%0.1f,%0.1f,%0.1f]�����ɹ�",Item[ItemID][_Name],PickUpSpawn[i][_X],PickUpSpawn[i][_Y],PickUpSpawn[i][_Z],PickUpSpawn[i][_RX],PickUpSpawn[i][_RY],PickUpSpawn[i][_RZ]);
	}
	return 1;
}
/**********************************************************/
FUNC::LoadCollectSpawns()
{
	formatex128("SELECT * FROM `"MYSQL_DB_COLLECT_SPAWNS"`");
    mysql_query(Static@Handle,string128,true);
    forex(i,cache_num_rows())
	{
	    if(i<MAX_COLLECT_SPAWNS)
	    {
        	CollectSpawn[i][_X]=cache_get_field_content_float(i,"X����",Static@Handle);
        	CollectSpawn[i][_Y]=cache_get_field_content_float(i,"Y����",Static@Handle);
        	CollectSpawn[i][_Z]=cache_get_field_content_float(i,"Z����",Static@Handle);
        	CollectSpawn[i][_RX]=cache_get_field_content_float(i,"RX����",Static@Handle);
        	CollectSpawn[i][_RY]=cache_get_field_content_float(i,"RY����",Static@Handle);
        	CollectSpawn[i][_RZ]=cache_get_field_content_float(i,"RZ����",Static@Handle);
        	CollectSpawn[i][_Type]=cache_get_field_content_int(i,"����",Static@Handle);
            Iter_Add(CollectSpawn,i);
            printf("�ɼ���-[%0.1f,%0.1f,%0.1f]��ȡ�ɹ�",CollectSpawn[i][_X],CollectSpawn[i][_Y],CollectSpawn[i][_Z],CollectSpawn[i][_RX],CollectSpawn[i][_RY],CollectSpawn[i][_RZ]);
	    }
        else printf("�ɼ������");
	}
	return 1;
}
CMD:addcollect(playerid, params[])
{
	if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<3)return SCM(playerid,-1,"�㲻�ǹ���Ա3��");
	new Types;
	if(sscanf(params, "i",Types))return SCM(playerid,-1,"�ɼ���������� /addcollect [0/1 ľ/ʯ]");
    if(Types<0||Types>1)return SCM(playerid,-1,"������0-1֮��");
    if(Iter_Count(CollectSpawn)>=MAX_COLLECT_SPAWNS)return SCM(playerid,-1,"ʰȡ���ѵ�����,���޸�MAX_PICKUP_SPAWNS");
   	new i=Iter_Free(CollectSpawn);
   	CA_FindZ_For2DCoord(PlayerPos[playerid][0],PlayerPos[playerid][1],PlayerPos[playerid][2]);

    CollectSpawn[i][_X]=PlayerPos[playerid][0];
    CollectSpawn[i][_Y]=PlayerPos[playerid][1];
    CollectSpawn[i][_Z]=PlayerPos[playerid][2];
    CollectSpawn[i][_RX]=0.0;
    CollectSpawn[i][_RY]=0.0;
    CollectSpawn[i][_RZ]=0.0;
    CollectSpawn[i][_Type]=Types;
    Iter_Add(CollectSpawn,i);
	formatex1024("INSERT INTO `"MYSQL_DB_COLLECT_SPAWNS"` (\
						`X����`,\
						`Y����`,\
						`Z����`,\
						`RX����`,\
						`RY����`,\
						`RZ����`,\
						`����`)\
						VALUES\
						('%f','%f','%f','%f','%f','%f','%i')",\
						CollectSpawn[i][_X],CollectSpawn[i][_Y],CollectSpawn[i][_Z],0.0,0.0,0.0,CollectSpawn[i][_Type]);
	mysql_query(Static@Handle,string1024,false);
	new Models;
	if(CollectSpawn[i][_Type]==0)Models=657;
	else Models=868;
    CreateCollectData(CollectSpawn[i][_Type],Models,CollectSpawn[i][_X],CollectSpawn[i][_Y],CollectSpawn[i][_Z],0.0,0.0,0.0,100.0,100.0);
	return 1;
}
FUNC::CrateCollectsFromCollectSpawns()
{
	foreach(new i:CollectSpawn)
	{
		new Models;
		if(CollectSpawn[i][_Type]==0)Models=657;
		else Models=868;
	    CreateCollectData(CollectSpawn[i][_Type],Models,CollectSpawn[i][_X],CollectSpawn[i][_Y],CollectSpawn[i][_Z],0.0,0.0,0.0,100.0,100.0);
       	printf("�ɼ���-����[%i][%0.1f,%0.1f,%0.1f]�����ɹ�",CollectSpawn[i][_Type],CollectSpawn[i][_X],CollectSpawn[i][_Y],CollectSpawn[i][_Z],CollectSpawn[i][_RX],CollectSpawn[i][_RY],CollectSpawn[i][_RZ]);
	}
	return 1;
}
/**********************************************************/
FUNC::LoadVehicleWreckageSpawns()
{
	formatex128("SELECT * FROM `"MYSQL_DB_VEHWER_SPAWN"`");
    mysql_query(Static@Handle,string128,true);
    forex(i,cache_num_rows())
	{
	    if(i<MAX_VEHWRE_SPAWNS)
	    {
			cache_get_field_content(i,"����Key",VehicleWreckageSpawn[i][_CraftVehKey],Static@Handle,37);
			new CraftVehID=GetCraftVehIDByCraftVehKey(VehicleWreckageSpawn[i][_CraftVehKey]);
			if(CraftVehID!=NONE)
			{
			    VehicleWreckageSpawn[i][_Key]=cache_get_field_content_int(i,"���",Static@Handle);
				VehicleWreckageSpawn[i][_X]=cache_get_field_content_float(i,"X����",Static@Handle);
	        	VehicleWreckageSpawn[i][_Y]=cache_get_field_content_float(i,"Y����",Static@Handle);
	        	VehicleWreckageSpawn[i][_Z]=cache_get_field_content_float(i,"Z����",Static@Handle);
	        	VehicleWreckageSpawn[i][_RX]=cache_get_field_content_float(i,"RX����",Static@Handle);
	        	VehicleWreckageSpawn[i][_RY]=cache_get_field_content_float(i,"RY����",Static@Handle);
	        	VehicleWreckageSpawn[i][_RZ]=cache_get_field_content_float(i,"RZ����",Static@Handle);
	            Iter_Add(VehicleWreckageSpawn,i);
	            printf("�����к�[%s]-[%0.1f,%0.1f,%0.1f,%0.1f,%0.1f,%0.1f]��ȡ�ɹ�",VehicleWreckageSpawn[i][_CraftVehKey],VehicleWreckageSpawn[i][_X],VehicleWreckageSpawn[i][_Y],VehicleWreckageSpawn[i][_Z],VehicleWreckageSpawn[i][_RX],VehicleWreckageSpawn[i][_RY],VehicleWreckageSpawn[i][_RZ]);
			}
			else
			{
	            printf("�����к�[%s]��ȡʧ��,��ЧKEY",VehicleWreckageSpawn[i][_CraftVehKey]);
            }
            
	    }
        else printf("�����к����");
	}
	return 1;
}
CMD:addvehwre(playerid, params[])
{
	if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<3)return SCM(playerid,-1,"�㲻�ǹ���Ա3��");
	new CraftVehKey[37];
	if(sscanf(params, "s[37]",CraftVehKey))return SCM(playerid,-1,"�����к��������� /addvehwre ������Key");
   	CA_FindZ_For2DCoord(PlayerPos[playerid][0],PlayerPos[playerid][1],PlayerPos[playerid][2]);
    CrateVehWreSpawn(CraftVehKey,PlayerPos[playerid][0],PlayerPos[playerid][1],PlayerPos[playerid][2],0.0,0.0,0.0);
	return 1;
}
FUNC::DestoryVehWreSpawn(index)
{
    if(DestoryVehicleWreckage(index)==RETURN_SUCCESS)
    {
  		formatex128("DELETE FROM `"MYSQL_DB_VEHWER_SPAWN"` WHERE `"MYSQL_DB_VEHWER_SPAWN"`.`���`='%i'",VehicleWreckageSpawn[VehicleWreckage[index][_SpawnKey]][_Key]);
		mysql_query(Static@Handle,string128,false);
    }
	return 1;
}
FUNC::CrateVehWreSpawn(CraftVehKey[],Float:X,Float:Y,Float:Z,Float:RX,Float:RY,Float:RZ)
{
	new CraftVehID=GetCraftVehIDByCraftVehKey(CraftVehKey);
	if(CraftVehID==NONE)
	{
	    formatex80("%i-cvws error0",NONE);
        Debug(NONE,string80);
		return RETURN_ERROR;
	}
    if(Iter_Count(VehicleWreckageSpawn)>=MAX_VEHWRE_SPAWNS)
	{
	    formatex80("%i-cvws error1",NONE);
        Debug(NONE,string80);
		return RETURN_ERROR;
	}
   	new i=Iter_Free(VehicleWreckageSpawn);
    VehicleWreckageSpawn[i][_X]=X;
    VehicleWreckageSpawn[i][_Y]=Y;
    VehicleWreckageSpawn[i][_Z]=Z;
    VehicleWreckageSpawn[i][_RX]=RX;
    VehicleWreckageSpawn[i][_RY]=RY;
    VehicleWreckageSpawn[i][_RZ]=RZ;
    format(VehicleWreckageSpawn[i][_CraftVehKey],UUID_LEN,CraftVehKey);
    Iter_Add(VehicleWreckageSpawn,i);
	formatex1024("INSERT INTO `"MYSQL_DB_VEHWER_SPAWN"` (\
						`X����`,\
						`Y����`,\
						`Z����`,\
						`RX����`,\
						`RY����`,\
						`RZ����`,\
						`����Key`)\
						VALUES\
						('%f','%f','%f','%f','%f','%f','%s')",\
						VehicleWreckageSpawn[i][_X],VehicleWreckageSpawn[i][_Y],VehicleWreckageSpawn[i][_Z],0.0,0.0,0.0,VehicleWreckageSpawn[i][_CraftVehKey]);
	mysql_query(Static@Handle,string1024,false);
    CreateVehicleWreckageData(CraftVehKey,VehicleWreckageSpawn[i][_X],VehicleWreckageSpawn[i][_Y],VehicleWreckageSpawn[i][_Z],0.0,0.0,0.0,i);
	return RETURN_SUCCESS;
}
FUNC::CrateVehWreFromVehWreSpawns()
{
	foreach(new i:VehicleWreckageSpawn)
	{
	    CreateVehicleWreckageData(VehicleWreckageSpawn[i][_CraftVehKey],VehicleWreckageSpawn[i][_X],VehicleWreckageSpawn[i][_Y],VehicleWreckageSpawn[i][_Z],0.0,0.0,0.0,i);
       	printf("�����к�-Key[%s][%0.1f,%0.1f,%0.1f]�����ɹ�",VehicleWreckageSpawn[i][_CraftVehKey],VehicleWreckageSpawn[i][_X],VehicleWreckageSpawn[i][_Y],VehicleWreckageSpawn[i][_Z],VehicleWreckageSpawn[i][_RX],VehicleWreckageSpawn[i][_RY],VehicleWreckageSpawn[i][_RZ]);
	}
	return 1;
}
/***************************************/
FUNC::LoadCraftVehicleLists()
{
	formatex128("SELECT * FROM `"MYSQL_DB_CRAFTVEHICLE_LIST"`");
    mysql_query(Static@Handle,string128,true);
    forex(i,cache_num_rows())
	{
	    if(i<MAX_CRAFTVEHICLE_LIST)
	    {
        	cache_get_field_content(i,"�ܳ�",CraftVehicleList[i][_Key],Static@Handle,37);
            CraftVehicleList[i][_VehicleModel]=cache_get_field_content_int(i,"����ģ��",Static@Handle);
            CraftVehicleList[i][_Model]=cache_get_field_content_int(i,"ģ��",Static@Handle);
            cache_get_field_content(i,"����",CraftVehicleList[i][_NeedThing],Static@Handle,512);
            Iter_Add(CraftVehicleList,i);
            printf("�����ϳɱ�[%s][%s]��ȡ�ɹ�",VehName[CraftVehicleList[i][_VehicleModel]-400],CraftVehicleList[i][_Model],CraftVehicleList[i][_Key]);
	    }
        else printf("�����ϳ����");
	}
	return 1;
}
stock MakeTypeCraftVehicleKey()
{
	new Count=0;
	foreach(new i:CraftVehicleList)Count++;
	formatex32("C000_00%i",Count);
	return string32;
}
FUNC::IsCraftVehicleKeySame(CraftVehicleKey[])
{
	foreach(new i:CraftVehicleList)if(isequal(CraftVehicleList[i][_Key],CraftVehicleKey,false))return 1;
	return 0;
}
CMD:addcraftvehicle(playerid, params[])
{
	if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<3)return SCM(playerid,-1,"�㲻�ǹ���Ա3��");
	new d@0,d@1,d@2[512];
    if(sscanf(params, "iis[512]",d@0,d@1,d@2))
	{
		return SCM(playerid,-1,"/addcraftvehicle ����ID ģ��ID ����");
    }
    if(d@0<400||d@0>611)return SCM(playerid,-1,"����ID��400-611֮��");
    if(Iter_Count(CraftVehicleList)>=MAX_CRAFTVEHICLE_LIST)return SCM(playerid,-1,"�����ϳɱ��ѵ�����,���޸�MAX_CRAFTITEMS");
    new i=Iter_Free(CraftVehicleList);
    new MakeKey[37];
    format(MakeKey,37,MakeTypeCraftVehicleKey());
    if(IsCraftVehicleKeySame(MakeKey))return SCM(playerid,-1,"�����ϳ��ܳ��ظ�");
    format(CraftVehicleList[i][_Key],37,MakeKey);
   	CraftVehicleList[i][_VehicleModel]=d@0;
    CraftVehicleList[i][_Model]=d@1;
    format(CraftVehicleList[i][_NeedThing],512,d@2);
    Iter_Add(CraftVehicleList,i);
	formatex1024("INSERT INTO `"MYSQL_DB_CRAFTVEHICLE_LIST"` (\
					`�ܳ�`,\
					`����ģ��`,\
					`ģ��`,\
					`����`)\
					VALUES\
					('%s','%i','%i','%s')",\
					CraftVehicleList[i][_Key],d@0,d@1,d@2);
	mysql_query(Static@Handle,string1024,false);
	return 1;
}
stock ShowCraftVehicles(playerid,pager)
{
    DialogBoxID[playerid]=1;
	foreach(new i:CraftVehicleList)
	{
		DialogBox[playerid][DialogBoxID[playerid]]=i;
		format(DialogBoxKey[playerid][DialogBoxID[playerid]],UUID_LEN,CraftVehicleList[i][_Key]);
		DialogBoxID[playerid]++;
	}
    new BodyStr[1024],TempStr[64],end=0,index;
    if(pager<1)pager=1;
//    if(pager>floatround((DialogBoxID[playerid]-1)/float(MAX_BOX_LIST),floatround_ceil))pager=floatround((DialogBoxID[playerid]-1)/float(MAX_BOX_LIST),floatround_ceil);
    DialogPage[playerid]=pager;
    pager=(pager-1)*MAX_BOX_LIST;
    if(pager==0)pager=1;else pager++;
	format(BodyStr,sizeof(BodyStr), "����\tģ��\n");
	strcat(BodyStr,"\t��һҳ\n");
	loop(i,pager,pager+MAX_BOX_LIST)
	{
		index=DialogBox[playerid][i];
		if(i<DialogBoxID[playerid])
		{
			format(TempStr,sizeof(TempStr),"%s\t%i\t%s\n",VehName[CraftVehicleList[index][_VehicleModel]-400],CraftVehicleList[index][_VehicleModel]);
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
