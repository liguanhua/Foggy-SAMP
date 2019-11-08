#define MYSQL_HOST "127.0.0.1"
#define MYSQL_USER "wd"
#define MYSQL_PASS "li123856"

new Account@Handle;
#define MYSQL_DB_NAME   "foggy"
#define MYSQL_DB_ACCOUNT "account"
#define MYSQL_DB_INVENTORY "inventory"
#define MYSQL_DB_PLAYERWIRELESS  "playerwireless"
#define MYSQL_DB_WIRELESS  "wireless"
#define MYSQL_DB_CRAFTBULID "bulid"
#define MYSQL_DB_WEAPON "weapon"
#define MYSQL_DB_EQUIP "equip"
#define MYSQL_DB_FACTION "faction"
#define MYSQL_DB_PICKUP "pickup"
#define MYSQL_DB_DOMAIN "domain"
#define MYSQL_DB_COLLECT "collect"
#define MYSQL_DB_VEHICLE "vehicle"
#define MYSQL_DB_STORE "store"
#define MYSQL_DB_STORESELL "storesell"
#define MYSQL_DB_CRAFTBULID_INV "bulidinv"
#define MYSQL_DB_PLAYERGAMEMAIL "gamemail"
#define PASSWORD_SALT   "foggy"

new Static@Handle;
#define MYSQL_DB_SERVER_STATIC   "foggystatic"
#define MYSQL_DB_COLLECT_SPAWNS "collectspawn"
#define MYSQL_DB_PICKUP_SPAWNS "pickupspawn"
#define MYSQL_DB_ITEM_LIST "itemlist"
#define MYSQL_DB_CRAFTITEM_LIST "craftitemlist"
#define MYSQL_DB_CRAFTVEHICLE_LIST "cratevehiclelist"
#define MYSQL_DB_VEHWER_SPAWN "vehiclewreckagespawn"



new Server@Handle;
#define MYSQL_DB_SERVER_SET   "foggyset"
#define MYSQL_SERVER_SET   "serverset"
#define MYSQL_SERVER_ADMIN   "administrator"

new Log@Handle;
#define MYSQL_DB_SERVER_LOG   "foggylog"
#define MYSQL_SERVER_CHAT_LOG   "chat"
#define MYSQL_SERVER_CHEAT_LOG   "cheat"
FUNC::MySql_OnGameModeInit()
{
    mysql_log(LOG_ERROR|LOG_WARNING);

    Account@Handle=mysql_connect(MYSQL_HOST,MYSQL_USER,MYSQL_DB_NAME,MYSQL_PASS);
    mysql_set_charset("gbk",Account@Handle);

    Server@Handle=mysql_connect(MYSQL_HOST,MYSQL_USER,MYSQL_DB_SERVER_SET,MYSQL_PASS);
    mysql_set_charset("gbk",Server@Handle);
    
    Static@Handle=mysql_connect(MYSQL_HOST,MYSQL_USER,MYSQL_DB_SERVER_STATIC,MYSQL_PASS);
    mysql_set_charset("gbk",Static@Handle);

    Log@Handle=mysql_connect(MYSQL_HOST,MYSQL_USER,MYSQL_DB_SERVER_LOG,MYSQL_PASS);
    mysql_set_charset("gbk",Log@Handle);
    
	if(mysql_errno(Account@Handle)!=0||mysql_errno(Server@Handle)!=0||mysql_errno(Static@Handle)!=0||mysql_errno(Log@Handle)!=0)
	{
	    SendRconCommand("exit");
		print("链接配置数据库失败");
	}
	else
	{
		print("链接配置数据库成功");
		//CreateItemListSqlData();
		//CreateCraftItemListSqlData();
		
	    ServerSet_LoadServerRunTime();

	    LoadItemLists();
	    LoadCraftItemLists();
	    LoadCraftVehicleLists();
	    LoadPickUpSpawns();
	    LoadCollectSpawns();
    	LoadVehicleWreckageSpawns();

		LoadStores();
		LoadCraftBulidInv();
    	
        LoadFactions();
		LoadCraftBulids();
		LoadVehs();
		LoadPrivateDomains();
		LoadPickUps();
		//LoadCollects();

		CratePickUpsFromPickUpSpawns();
		CrateCollectsFromCollectSpawns();
		CrateVehWreFromVehWreSpawns();
	}
	return 1;
}
