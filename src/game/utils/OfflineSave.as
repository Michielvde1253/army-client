package game.utils {
	import game.player.GamePlayerProfile;
	import game.player.Inventory;
	import game.sound.ArmySoundManager;
	import game.states.GameState;
	import game.isometric.GridCell;
	import game.isometric.characters.IsometricCharacter;
	import game.isometric.elements.Renderable;
	import game.items.AreaItem;
	import game.items.ConstructionItem;
	import game.items.Item;
	import game.items.ItemCollectionItem;
	import game.items.ItemManager;
	import game.items.MapItem;
	import game.items.ShopItem;
	import game.items.SignalItem;
	import game.missions.Mission;
	import game.missions.MissionManager;
	import game.gameElements.Production;
	import game.net.ServerCall;

	public class OfflineSave {

		public static var mMaps: * = {};

		public static var mMissions: * = {};

		public var mSwitchingMap: Boolean = false;

		mMissions["missions_incomplete"] = [];
		mMissions["missions_all_complete"] = [];
		mMissions["missions_finished"] = [];

		public function OfflineSave() {
			super();
		}

		public static function generateGamefieldJson(): * {
			var cell: GridCell = null;
			var tile: * = {};
			var unit: * = {};
			var gameobj: * = {};
			var player_tiles: * = [];
			var gamefield_items: * = [];
			var known_objects: * = [];
			var production: Production = undefined;
			var friends: Array = undefined;
			var i: int = 0;
			var k;
			var friendstring = "";
			var mapgrid: * = GameState.mInstance.mMapData.mGrid;

			var result: * = {};

			i = 0;
			while (i < mapgrid.length) {
				if (mapgrid[i]["mOwner"] == 1) {
					tile = {};
					tile["coord_x"] = mapgrid[i]["mPosI"];
					tile["coord_y"] = mapgrid[i]["mPosJ"];
					player_tiles.push(tile);
				}
				if (mapgrid[i]["mCharacter"]) {
					unit = {};
					unit["coord_x"] = mapgrid[i]["mPosI"];
					unit["coord_y"] = mapgrid[i]["mPosJ"];
					if (mapgrid[i]["mCharacter"]["mItem"]) {
						unit["item_id"] = mapgrid[i]["mCharacter"]["mItem"]["mId"];
						unit["item_type"] = ItemManager.getTableNameForItem(mapgrid[i]["mCharacter"]["mItem"]);
						unit["activation_time"] = 0;
						unit["item_hit_points"] = mapgrid[i]["mCharacter"]["mHealth"];
						gamefield_items.push(unit);
					}
				}
				if (mapgrid[i]["mObject"]) {
					gameobj = {};
					if (mapgrid[i]["mObject"]["mItem"]) {
						gameobj["item_id"] = mapgrid[i]["mObject"]["mItem"]["mId"];
						gameobj["item_type"] = ItemManager.getTableNameForItem(mapgrid[i]["mObject"]["mItem"]);
						if (gameobj["item_type"] == "HomeFrontEffort") {
							if (mapgrid[i]["mObject"]["mState"] == 3) {
								gameobj["crop_state"] = "growing";
								production = mapgrid[i]["mObject"].getProduction();
								gameobj["next_action_at"] = Math.round(production.getProducingTimeLeft() / 1000);
							} else if (mapgrid[i]["mObject"]["mState"] == 4) {
								gameobj["crop_state"] = "ready";
								gameobj["next_action_at"] = 0;
							}
						} else if (gameobj["item_type"] == "Building") {
							if (mapgrid[i]["mObject"]["mState"] == 3) {
								production = mapgrid[i]["mObject"].getProduction();
								gameobj["produces"] = "HFEDrives." + production.getProductionID();
								gameobj["next_action_at"] = Math.round(production.getProducingTimeLeft() / 1000);
							} else if (mapgrid[i]["mObject"]["mState"] == 4) {
								production = mapgrid[i]["mObject"].getProduction();
								gameobj["produces"] = "HFEDrives." + production.getProductionID();
								gameobj["next_action_at"] = 0;
							} else if (mapgrid[i]["mObject"]["mState"] >= 9 && mapgrid[i]["mObject"]["mState"] <= 12) {
								gameobj["status"] = "SETUP";
								gameobj["clicks"] = mapgrid[i]["mObject"].getBuildingStepsDone();
							}
						} else if (gameobj["item_type"] == "ResourceBuilding") {
							if (mapgrid[i]["mObject"]["mState"] == 3) {
								production = mapgrid[i]["mObject"].getProduction();
								gameobj["produces"] = "HFEDrives." + production.getProductionID();
								gameobj["next_action_at"] = Math.round(production.getProducingTimeLeft() / 1000);
								friends = mapgrid[i]["mObject"].getHelpingFriends()
								k = 0;
								friendstring = "";
								for (k in friends) {
									friendstring = friendstring + friends[k] + ","
								}
								gameobj["helping_friend_ids"] = friendstring.slice(0, -1);

							} else if (mapgrid[i]["mObject"]["mState"] == 4) {
								production = mapgrid[i]["mObject"].getProduction();
								gameobj["produces"] = "HFEDrives." + production.getProductionID();
								gameobj["next_action_at"] = 0;
								friends = mapgrid[i]["mObject"].getHelpingFriends()
								k = 0;
								friendstring = "";
								for (k in friends) {
									friendstring = friendstring + friends[k] + ","
								}
								gameobj["helping_friend_ids"] = friendstring.slice(0, -1);
							} else if (mapgrid[i]["mObject"]["mState"] >= 9 && mapgrid[i]["mObject"]["mState"] <= 12) {
								gameobj["status"] = "SETUP";
								gameobj["clicks"] = mapgrid[i]["mObject"].getBuildingStepsDone();
							}
						} else if (gameobj["item_type"] == "PermanentHFE") {
							if (mapgrid[i]["mObject"]["mState"] == 3) {
								production = mapgrid[i]["mObject"].getProduction();
								gameobj["produces"] = "HFEDrives." + production.getProductionID();
								gameobj["next_action_at"] = Math.round(production.getProducingTimeLeft() / 1000);
							} else if (mapgrid[i]["mObject"]["mState"] == 4) {
								production = mapgrid[i]["mObject"].getProduction();
								gameobj["produces"] = "HFEDrives." + production.getProductionID();
								gameobj["next_action_at"] = 0;
							}
						}
						gameobj["activation_time"] = 0;
						gameobj["item_hit_points"] = mapgrid[i]["mObject"].getHealth();
						cell = mapgrid[i]["mObject"].getCell();
						gameobj["coord_x"] = cell["mPosI"];
						gameobj["coord_y"] = cell["mPosJ"];
						if (known_objects.indexOf(String(gameobj["coord_x"]) + String(gameobj["coord_y"])) == -1) {
							known_objects.push(String(gameobj["coord_x"]) + String(gameobj["coord_y"]));
							gamefield_items.push(gameobj);
						}
					}
				}
				result["player_tiles"] = player_tiles;
				result["gamefield_items"] = gamefield_items;
				result["map_id"] = GameState.mInstance.mCurrentMapId;
				i++;
			}
			return result;
		}

		public static function generateProfileJson(): * {
			var j: * = 0;
			var k: * = 0;
			var profilesave: * = {};
			var profile: * = GameState.mInstance.mPlayerProfile;
			profilesave["gained_free_units"] = 0;
			profilesave["recently_gifted_energy_to"] = "";
			profilesave["recently_gifted_supplies_to"] = "";
			profilesave["wishlist"] = [];
			profilesave["resource_experience"] = profile["mXp"];
			profilesave["resource_money"] = profile["mMoney"];
			profilesave["resource_premium"] = profile["mPremium"];
			profilesave["resource_energy"] = profile["mEnergy"];
			profilesave["resource_supplies"] = profile["mSupplies"];
			profilesave["resource_material"] = profile["mMaterial"];
			profilesave["resource_socialxp"] = profile["mSocialXp"];
			profilesave["resource_water"] = profile["mWater"];
			profilesave["supply_cap"] = profile["mSuppliesCap"];
			profilesave["secs_to_energy_gain"] = profile["mSecondsToRechargeEnergy"];
			profilesave["reward_drop_seed_term"] = profile["mRewardDropSeedTerm"];
			profilesave["reward_drops_counter"] = profile["mRewardDropsCounter"];
			profilesave["energy_cap"] = profile["mMaxEnergy"];
			profilesave["energy_recharge_time"] = profile["mTimeBetweenEnergyRecharges"];
			profilesave["resource_energy_percentiles"] = profile.getEnergyRewardCounter();
			k = 0;
			var l: int = 0;
			var invtype: Array = [];
			var inventory: * = GameState.mInstance.mPlayerProfile.mInventory.getInventory();
			var inventoryobj: Array = [];
			var item: * = {};
			var amount: int = 0;
			for (k in inventory) {
				invtype = inventory[k];
				l = 0;
				while (l < invtype.length) {
					item = {};
					if (invtype[l]["mType"] == "Area") {
						invtype[l]["mType"] = "MapArea";
					}
					item["item_id"] = invtype[l]["mId"];
					item["item_type"] = invtype[l]["mType"];
					l++;
					amount = int(invtype[l]);
					item["item_count"] = amount;
					inventoryobj.push(item);
					l++;
				}
			}
			profilesave["inventory_items"] = inventoryobj;

			return profilesave;
		}

		static function getIndexByName(array: Array, search: String): int {
			// returns the index of an array where it finds an object with the given search value for it's name property (movieclips, sprites, or custom objects)
			for (var i: int = 0; i < array.length; i++) {
				if (array[i].mission_id == search) {
					return i;
				}
			}
			return -1;
		}
		/*
		public static function generateMissionJson(): * {
			var objectives: Array = undefined;
			var j: * = 0;
			var k: * = 0;
			var missionobj: * = {};
			var objective: * = {};
			var all_missions: Array = [];

			var missionsave: * = mMissions;

			all_missions = MissionManager.getMissions();
			for (j in all_missions) {
				trace(all_missions[j]["mId"]);
				trace(all_missions[j]["mState"]);
				missionobj = {};
			    trace(JSON.stringify(missionsave))
				if (all_missions[j]["mState"] == 1) {
					missionobj["mission_id"] = all_missions[j]["mId"];
					objectives = all_missions[j].getObjectives();
					missionobj["objectives"] = [];
					k = 0;
					for (k in objectives) {
						objective = {};
						objective["objectiveId"] = objectives[k]["mId"];
						objective["startValue"] = 0;
						objective["goal"] = objectives[k]["mGoal"];
						objective["counterValue"] = objectives[k]["mCounter"];
						objective["purchased"] = objectives[k]["mPurchased"];
						missionobj["objectives"].push(objective);
					}
					var index_in_save:int = getIndexByName(missionsave["missions_incomplete"],all_missions[j]["mId"])
					if (index_in_save != -1) {
						missionsave["missions_incomplete"].splice(index_in_save, 1)
					}
					missionsave["missions_incomplete"].push(missionobj);
				} else if (all_missions[j]["mState"] == 2) {
					missionobj["mission_id"] = all_missions[j]["mId"];
					var index_in_save:int = getIndexByName(missionsave["missions_incomplete"],all_missions[j]["mId"])
					if (index_in_save != -1) {
						missionsave["missions_incomplete"].splice(index_in_save, 1)
					}
					var index_in_save:int = getIndexByName(missionsave["missions_all_complete"],all_missions[j]["mId"])
					if (index_in_save != -1) {
						missionsave.splice["missions_all_complete"](index_in_save, 1)
					}
					var index_in_save:int = getIndexByName(missionsave["missions_finished"],all_missions[j]["mId"])
					if (index_in_save != -1) {
						missionsave["missions_finished"].splice(index_in_save, 1)
					}
					missionsave["missions_all_complete"].push(missionobj);
				} else if (all_missions[j]["mState"] == 3) {
					missionobj["mission_id"] = all_missions[j]["mId"];
					var index_in_save:int = getIndexByName(missionsave["missions_incomplete"],all_missions[j]["mId"])
					if (index_in_save != -1) {
						missionsave["missions_incomplete"].splice(index_in_save, 1)
					}
					var index_in_save:int = getIndexByName(missionsave["missions_all_complete"],all_missions[j]["mId"])
					if (index_in_save != -1) {
						missionsave.splice["missions_all_complete"](index_in_save, 1)
					}
					var index_in_save:int = getIndexByName(missionsave["missions_finished"],all_missions[j]["mId"])
					if (index_in_save != -1) {
						missionsave["missions_finished"].splice(index_in_save, 1)
					}
					missionsave["missions_finished"].push(missionobj);
				}
			}

			return missionsave;
		}
		*/

		public static function generateMissionJson(): * {
			var objectives: Array = undefined;
			var j: * = 0;
			var k: * = 0;
			var missionobj: * = {};
			var objective: * = {};
			var all_missions: Array = [];

			var missionsave: * = {};
			missionsave["missions_incomplete"] = []
			missionsave["missions_all_complete"] = []
			missionsave["missions_finished"] = []

			all_missions = MissionManager.getMissions();
			for (j in all_missions) {
				trace(all_missions[j]["mId"]);
				trace(all_missions[j]["mState"]);
				missionobj = {};
				trace(JSON.stringify(missionsave))
				if (all_missions[j]["mState"] == 1) {
					missionobj["mission_id"] = all_missions[j]["mId"];
					objectives = all_missions[j].getObjectives();
					missionobj["objectives"] = [];
					k = 0;
					for (k in objectives) {
						objective = {};
						objective["objectiveId"] = objectives[k]["mId"];
						objective["startValue"] = 0;
						objective["goal"] = objectives[k]["mGoal"];
						objective["counterValue"] = objectives[k]["mCounter"];
						objective["purchased"] = objectives[k]["mPurchased"];
						missionobj["objectives"].push(objective);
					}
					missionsave["missions_incomplete"].push(missionobj);
				} else if (all_missions[j]["mState"] == 2) {
					missionobj["mission_id"] = all_missions[j]["mId"];
					missionsave["missions_all_complete"].push(missionobj);
				} else if (all_missions[j]["mState"] == 3) {
					missionobj["mission_id"] = all_missions[j]["mId"];
					missionsave["missions_finished"].push(missionobj);
				}
			}

			return missionsave;
		}

		public static function saveOldMap(): void {
			var old_map_id: String = GameState.mInstance.mCurrentMapId;
			var secs_since_last_enemy_spawn: Number = Math.round(Number(GameState.mInstance.getSpawnEnemyTimer()) / 1000);
			mMaps[old_map_id] = {
				"map_name": old_map_id,
				"secs_since_last_enemy_spawn": secs_since_last_enemy_spawn,
				"map_data": generateGamefieldJson()
			};
			mMissions = generateMissionJson();
		}

		public static function switchMap(): void {
			trace("start switching map")
			var map_id: String = GameState.mInstance.mCurrentMapId;
			GameState.mInstance.mLoadingStatesOver = false;
			GameState.mInstance.mCurrentMapGraphicsId = Math.max(GameState.GRAPHICS_MAP_ID_LIST.indexOf(map_id), 0);
			//GameState.mInstance.loadingFirstFinished();
			GameState.mInstance.mPlayerProfile.mInventory.getAreas();
			GameState.mInstance.changeState(0);
			GameState.mInstance.mMapData.destroy();
			var fakeservercall: * = new ServerCall("GetMapData", null, null, null);
			fakeservercall["mData"] = mMissions;
			if (mMaps[map_id]) {
				fakeservercall["mData"]["missions_incomplete"] = mMissions["missions_incomplete"];
				GameState.mInstance.initObjects(null);
				loadMap(mMaps[map_id]);
			} else {
				GameState.mInstance.initObjects(null);
				GameState.mInstance.initMap(null, map_id);
			}
			GameState.mInstance.updateGrid();
			GameState.mInstance.mScene.mFog.init();
			MissionManager.initialize()
			GameState.mInstance.mMissionIconsManager.reset()
			MissionManager.setupFromServer(fakeservercall);
			MissionManager.findNewActiveMissions();
			// Show water amount in HUD
			if (map_id == "Desert") {
				(GameState.mInstance.getMainClip() as GameMain).changeDiscordMap("Desert");
				GameState.mInstance.mHUD.changeWaterVisibility(true)
			} else if (map_id == "Home") {
				(GameState.mInstance.getMainClip() as GameMain).changeDiscordMap("Homeland");
				GameState.mInstance.mHUD.changeWaterVisibility(false)
			}
			GameState.mInstance.mLoadingStatesOver = true;
		}

		public static function generateSaveJson(): * {
			var map_id: String = GameState.mInstance.mCurrentMapId;
			var secs_since_last_enemy_spawn: Number = Math.round(Number(GameState.mInstance.getSpawnEnemyTimer()) / 1000);
			mMaps[map_id] = {
				"map_name": map_id,
				"secs_since_last_enemy_spawn": secs_since_last_enemy_spawn,
				"map_data": generateGamefieldJson()
			};
			var savedata: * = {};
			savedata = generateMissionJson()
			savedata["profile"] = generateProfileJson()
			savedata["maps"] = [];
			for (var i: String in mMaps) {
				savedata["maps"].push(mMaps[i])
			}
			savedata["isFogOfWarOff"] = GameState.mInstance.isFogOfWarOn();
			var now: Date = new Date();
			savedata["time_of_last_save"] = now.valueOf();
			savedata["saveversion"] = 4;
			return savedata;
		}

		public static function fixOldSave(savedata: * , version: int): * {
			if (version < 3) {
				savedata["isFogOfWarOff"] = true;
			}
			if (version < 4) {
				savedata["maps"] = [];
				var homeland = {};
				homeland["map_name"] = "Home";
				homeland["secs_since_last_enemy_spawn"] = savedata["profile"]["secs_since_last_enemy_spawn"];
				var mapdata = {};
				mapdata["player_tiles"] = savedata["player_tiles"];
				mapdata["gamefield_items"] = savedata["gamefield_items"];
				mapdata["map_id"] = "Home";
				homeland["map_data"] = mapdata;
				savedata["maps"].push(homeland)


				delete savedata["profile"]["player_tiles"];
				delete savedata["profile"]["gamefield_items"];
				delete savedata["secs_since_last_enemy_spawn"];
			}
			return savedata;
		}

		public static function updateMapTimers(mapdata: * , time_diff): * {
			var i: * = 0;
			for (i in mapdata["map_data"]["gamefield_items"]) {
				if (mapdata["map_data"]["gamefield_items"][i]["next_action_at"] != null) {
					mapdata["map_data"]["gamefield_items"][i]["next_action_at"] -= time_diff;
					if (mapdata["map_data"]["gamefield_items"][i]["next_action_at"] < 0) {
						mapdata["map_data"]["gamefield_items"][i]["next_action_at"] = 0;
					}
				}
				if (mapdata["map_data"]["gamefield_items"][i]["activation_time"] != 0) {
					mapdata["map_data"]["gamefield_items"][i]["activation_time"] -= time_diff;
					if (mapdata["map_data"]["gamefield_items"][i]["activation_time"] < 0) {
						mapdata["map_data"]["gamefield_items"][i]["activation_time"] = 0;
					}
				}
			}
			return mapdata
		}

		public static function selectMissionsByMap(all_missions: * , map_id: String): Array {
			var i: * = 0;
			var selectedMissions: Array = [];
			for (i in all_missions) {
				var mission: * = MissionManager.getMission(all_missions[i]["mission_id"]);
				if (mission) {
					trace(mission.mMapId);
					if (mission.mMapId == map_id) {
						trace(all_missions[i]["mission_id"]);
						selectedMissions.push(all_missions[i]);
					}
				}
			}

			return selectedMissions;
		}

		public static function loadMap(mapdata: * ): void {
			var fakeservercall3: * = new ServerCall("GetMapData", null, null, null);
			fakeservercall3["mData"] = mapdata["map_data"];
			GameState.mInstance.initMap(fakeservercall3, GameState.mInstance.mCurrentMapId);
			GameState.mInstance.initObjects(fakeservercall3);
		}

		public static function loadProgress(savedata: * ): void {
			var saveversion: int = int(savedata["saveversion"]);
			savedata = fixOldSave(savedata, saveversion);
			var minus_rechargetime: int = 0;
			var energy_to_give: int = 0;
			var time_needed_for_energy: int = 0;
			var item: * = undefined;
			var cell: * = undefined;
			var dateobj: Date = new Date();
			var now: int = Math.round(dateobj.valueOf() / 1000);
			var then: int = Math.round(Number(savedata["time_of_last_save"]) / 1000);
			var time_diff: * = now - then;
			if (savedata["profile"]["resource_energy"] < savedata["profile"]["energy_cap"]) {
				if (time_diff >= savedata["profile"]["secs_to_energy_gain"]) {
					savedata["profile"]["resource_energy"]++;
					if (savedata["profile"]["resource_energy"] >= savedata["profile"]["energy_cap"]) {
						savedata["profile"]["resource_energy"] = savedata["profile"]["energy_cap"];
						savedata["profile"]["secs_to_energy_gain"] = savedata["profile"]["energy_recharge_time"];
					} else {
						minus_rechargetime = time_diff - Number(savedata["profile"]["secs_to_energy_gain"]);
						energy_to_give = Math.floor(minus_rechargetime / Number(savedata["profile"]["energy_recharge_time"]));
						savedata["profile"]["resource_energy"] += energy_to_give;
						if (savedata["profile"]["resource_energy"] >= savedata["profile"]["energy_cap"]) {
							savedata["profile"]["resource_energy"] = savedata["profile"]["energy_cap"];
							savedata["profile"]["secs_to_energy_gain"] = savedata["profile"]["energy_recharge_time"];
						} else {
							time_needed_for_energy = energy_to_give * Number(savedata["profile"]["energy_recharge_time"]);
							savedata["profile"]["secs_to_energy_gain"] = minus_rechargetime - time_needed_for_energy;
						}
					}
				} else {
					savedata["profile"]["secs_to_energy_gain"] -= time_diff;
				}
			} else {
				savedata["profile"]["secs_to_energy_gain"] = savedata["profile"]["energy_recharge_time"];
			}
			GameState.mInstance.mCurrentMapId = "Home"; // Always go back to the Homeland, loading progress on other maps is broken.
			var fakeservercall: * = new ServerCall("GetMapData", null, null, null); // Not used for map, just for missions
			fakeservercall["mData"] = savedata;
			var fakeservercall2: * = new ServerCall("GetUserData", null, null, null);
			fakeservercall2["mData"] = savedata["profile"];
			GameState.mInstance.restoreFogOfWar(savedata["isFogOfWarOff"]);
			GameState.mInstance.mLoadingStatesOver = false;
			GameState.mInstance.mCurrentMapGraphicsId = Math.max(GameState.GRAPHICS_MAP_ID_LIST.indexOf(GameState.mInstance.mCurrentMapId), 0);
			GameState.mInstance.loadingFirstFinished();
			GameState.mInstance.initPlayerProfile(fakeservercall2);
			GameState.mInstance.mPlayerProfile.mInventory.getAreas();
			GameState.mInstance.changeState(0);
			GameState.mInstance.mMapData.destroy();
			mMaps = {};
			var i: * = 0;
			for (i in savedata["maps"]) {
				mMaps[savedata["maps"][i]["map_name"]] = updateMapTimers(savedata["maps"][i], time_diff);
			}
			GameState.mInstance.initObjects(null); // Remove existing units
<<<<<<< Updated upstream
=======
		
			// Init pvp
			//var fakedata:* = {};
			//fakedata["pvp_data"] = savedata["profile"]["pvp_data"];
			//fakedata["allies"] = new Array(); // Unused
		
			//var possible_opponents:Array = GameState.mPvPOpponentsConfig.possible_opponents["pvp_opponents"];
			//fakedata["possible_opponents"] = possible_opponents;
		
			//fakedata["recent_attacks"] = new Array(); // Unused
		
			//fakedata["player_unit_count"] = calculateGlobalUnits(savedata["maps"]);
		
			//GameState.mInstance.mPlayerProfile.setupPvPData(fakedata);
			//GameState.mInstance.mPlayerProfile.setupGlobalUnitCounts(fakedata);
		
			// Init map
>>>>>>> Stashed changes
			loadMap(mMaps["Home"]);
			GameState.mInstance.updateGrid();
			GameState.mInstance.mScene.mFog.init();
			mMissions = {};
			mMissions["missions_incomplete"] = savedata["missions_incomplete"];
			mMissions["missions_all_complete"] = savedata["missions_all_complete"];
			mMissions["missions_finished"] = savedata["missions_finished"];
			MissionManager.initialize()
			MissionManager.setupFromServer(fakeservercall);
			MissionManager.findNewActiveMissions();
			GameState.mInstance.mLoadingStatesOver = true;
			// Start homeland music
			GameState.mInstance.mCurrentMusic = GameState.mInstance.getMapMusic()
			ArmySoundManager.loadMusic(GameState.mInstance.mCurrentMusic);
			GameState.mInstance.startMusic();
			(GameState.mInstance.getMainClip() as GameMain).changeDiscordMap("Homeland");
			GameState.mInstance.mHUD.changeWaterVisibility(false)
		}
	
	}
}