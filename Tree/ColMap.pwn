enum CAOBJECTINFO
{
	ColdAndreadsID,
	ObjectID,
	ModelID,
	ObjectType,
	bool:ObjectUsed
}
new CA_ObjectList[MAX_CA_OBJECTS][CAOBJECTINFO];
new Iterator:CA_Objects<MAX_CA_OBJECTS>;
///////////////////////
stock CA_CreateObject_SC(modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, Float:drawdistance = 300.0)
{
		new ca_index = CreateObject(modelid, x, y, z, rx, ry, rz, drawdistance);
		if(ca_index != INVALID_OBJECT_ID)
		{
			if(modelid>-2000)CA_CreateObject(modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
		}
		return ca_index;
}
///////////////////////
stock CA_CreateDynamicObject_SC(modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = STREAMER_OBJECT_SD, Float:drawdistance = STREAMER_OBJECT_DD, STREAMER_TAG_AREA:areaid = STREAMER_TAG_AREA:-1, priority = 0)
{
	new ca_index = CreateDynamicObject(modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, worldid, interiorid, playerid, streamdistance, drawdistance, areaid, priority);
	if(modelid>-2000)CA_CreateObject(modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
	return ca_index;
}
FUNC::GetDynamicObjectIndexByObjectID(objectid)
{
	foreach(new i:CA_Objects)
	{
        if(CA_ObjectList[i][ObjectType]==OBJECT_TYPE_DYNAMIC)
        {
            if(CA_ObjectList[i][ObjectID]==objectid)return i;
        }
	}
	return NONE;
}
///////////////////////
stock CA_CreateDynamicObject_DC(modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = STREAMER_OBJECT_SD, Float:drawdistance = STREAMER_OBJECT_DD, STREAMER_TAG_AREA:areaid = STREAMER_TAG_AREA:-1, priority = 0)
{
	new ca_index = -1;
	ca_index = Iter_Free(CA_Objects);
	if(ca_index > -1)
	{
		Iter_Add(CA_Objects, ca_index);
		CA_ObjectList[ca_index][ObjectID] = CreateDynamicObject(modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, worldid, interiorid, playerid, streamdistance, drawdistance, areaid, priority);
		if(modelid>-2000)CA_ObjectList[ca_index][ColdAndreadsID] = CA_CreateObject(modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, true);
		CA_ObjectList[ca_index][ObjectType] = OBJECT_TYPE_DYNAMIC;
		CA_ObjectList[ca_index][ModelID] = modelid;
	}
	return ca_index;
}
///////////////////////
stock CA_DestroyObject_DC(ca_index)
{
	if(ca_index < 0 || ca_index >= MAX_CA_OBJECTS) return 0;
	if(Iter_Contains(CA_Objects, ca_index))
	{
		new next;
		Iter_SafeRemove(CA_Objects, ca_index, next);
		switch(CA_ObjectList[ca_index][ObjectType])
		{
		    case OBJECT_TYPE_OBJECT:DestroyObject(CA_ObjectList[ca_index][ObjectID]);
		    case OBJECT_TYPE_DYNAMIC:DestroyDynamicObject(CA_ObjectList[ca_index][ObjectID]);
		}
		if(CA_ObjectList[ca_index][ModelID]>-2000)CA_DestroyObject(CA_ObjectList[ca_index][ColdAndreadsID]);
		return 1;
	}
	return 0;
}
///////////////////////

stock CA_SetObjectPos_DC(ca_index, Float:x, Float:y, Float:z)
{
	if(ca_index < 0 || ca_index >= MAX_CA_OBJECTS) return 0;
	if(Iter_Contains(CA_Objects, ca_index))
	{
	    if(CA_ObjectList[ca_index][ModelID]>-2000)CA_SetObjectPos(CA_ObjectList[ca_index][ColdAndreadsID],x,y,z);
		switch(CA_ObjectList[ca_index][ObjectType])
		{
		    case OBJECT_TYPE_OBJECT:printf("SetObjectPos  %i",SetObjectPos(CA_ObjectList[ca_index][ObjectID], x, y, z));
		    case OBJECT_TYPE_DYNAMIC:SetDynamicObjectPos(CA_ObjectList[ca_index][ObjectID], x, y, z);
		}
		return 1;
	}
	return 0;
}
stock CA_SetObjectRot_DC(ca_index, Float:rx, Float:ry, Float:rz)
{
	if(ca_index < 0 || ca_index >= MAX_CA_OBJECTS) return 0;
	if(Iter_Contains(CA_Objects, ca_index))
	{
	    if(CA_ObjectList[ca_index][ModelID]>-2000)CA_SetObjectRot(CA_ObjectList[ca_index][ColdAndreadsID],rx,ry,rz);
		switch(CA_ObjectList[ca_index][ObjectType])
		{
		    case OBJECT_TYPE_OBJECT:SetObjectRot(CA_ObjectList[ca_index][ObjectID], rx, ry, rz);
		    case OBJECT_TYPE_DYNAMIC:SetDynamicObjectRot(CA_ObjectList[ca_index][ObjectID], rx, ry, rz);

		}
		return 1;
	}
	return 0;
}
stock CA_MoveObject_DC(ca_index,Float:x, Float:y, Float:z, Float:speed, Float:rx = -1000.0, Float:ry = -1000.0, Float:rz = -1000.0)
{
	if(ca_index < 0 || ca_index >= MAX_CA_OBJECTS) return 0;
	if(Iter_Contains(CA_Objects, ca_index))
	{
		switch(CA_ObjectList[ca_index][ObjectType])
		{
		    case OBJECT_TYPE_OBJECT:MoveObject(CA_ObjectList[ca_index][ObjectID],x,y,z,speed,rx,ry,rz);
		    case OBJECT_TYPE_DYNAMIC:MoveDynamicObject(CA_ObjectList[ca_index][ObjectID],x,y,z,speed,rx,ry,rz);
		}
		return 1;
	}
	return 0;
}
stock CA_DestroyAllObjects_DC()
{
	foreach(new i : CA_Objects)
	{
		if(CA_ObjectList[i][ObjectType] == OBJECT_TYPE_OBJECT) i = CA_DestroyObject_DC(i);
	}
	return 1;
}

