package game.gameElements {
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import game.actions.PvPFireMissionAction;
	import game.characters.PlayerUnit;
	import game.characters.PvPEnemyUnit;
	import game.gui.TooltipHealth;
	import game.isometric.GridCell;
	import game.isometric.ImportedObject;
	import game.isometric.IsometricScene;
	import game.isometric.characters.IsometricCharacter;
	import game.items.MapItem;
	import game.items.PowerUpItem;
	import game.states.GameState;
	import game.utils.EffectController;
	import com.dchoc.graphics.DCResourceManager;

	public class PowerUpObject extends ImportedObject {


		public function PowerUpObject(param1: int, param2: IsometricScene, param3: MapItem, param4: Point, param5: DisplayObject = null, param6: String = null) {
			super(param1, param2, param3, param4, param5, param6);
			var _loc7_: int = (param4.x + 0.5) * param2.mGridDimX;
			var _loc8_: int = (param4.y + 0.5) * param2.mGridDimY;
			setPos(_loc7_, _loc8_, 0);
			mMovable = false;
			var _loc9_: GridCell;
			if (_loc9_ = getCell()) {
				_loc9_.mPowerUp = this;
			}
		}

		public function execute(param1: IsometricCharacter): void {
			var _loc3_: GridCell = null;
			var _loc4_: Array = null;
			var _loc5_: Array = null;
			var _loc2_: PowerUpItem = mItem as PowerUpItem;
			var resourceManager: DCResourceManager = DCResourceManager.getInstance();
			if (_loc2_) {
				if (param1) {
					if (_loc2_.mIncreasedHealth > 0) {
						param1.setHealth(Math.min(param1.mMaxHealth, param1.getHealth() + _loc2_.mIncreasedHealth));
					}
					if (_loc2_.mIncreasedActions > 0) {
						if (param1 is PlayerUnit) {
							GameState.mInstance.mPvPMatch.mActionsLeft += _loc2_.mIncreasedActions;
						}
					}
					if (_loc2_.mPowerUpItem) {
						if (param1 is PlayerUnit) {
							GameState.mInstance.mPlayerProfile.addItem(_loc2_.mPowerUpItem, 1);
						}
					}
					if (_loc2_.mPowerUpFireMissionItem) {
						_loc3_ = null;
						if (param1 is PlayerUnit) {
							if ((_loc4_ = mScene.getPvPEnemyAliveUnits()).length > 0) {
								_loc3_ = (_loc4_[Math.floor(Math.random() * _loc4_.length)] as PvPEnemyUnit).getCell();
							}
						} else if ((_loc5_ = mScene.getPlayerAliveUnits()).length > 0) {
							_loc3_ = (_loc5_[Math.floor(Math.random() * _loc5_.length)] as PlayerUnit).getCell();
						}
						GameState.mInstance.queueAction(new PvPFireMissionAction(_loc3_, _loc2_.mPowerUpFireMissionItem), true);
					}



					GameState.mInstance.mScene.addEffect(null, EffectController.EFFECT_TYPE_POWER_UP, param1.mX, param1.mY, _loc2_.mEffectGraphics);




					/*
			   Unhardcoding: replaced by EffectGraphics in the config
		   
               if(_loc2_.mId == "AirSupport_1")
               {
                  GameState.mInstance.mScene.addEffect(null,EffectController.EFFECT_TYPE_POWER_UP_AIR_SUPPORT,param1.mX,param1.mY);
               }
               else if(_loc2_.mId == "HealthPack")
               {
                  GameState.mInstance.mScene.addEffect(null,EffectController.EFFECT_TYPE_POWER_UP_HEALTH_PACK,param1.mX,param1.mY);
               }
               else if(_loc2_.mId == "Paratrooper")
               {
                  GameState.mInstance.mScene.addEffect(null,EffectController.EFFECT_TYPE_POWER_UP_PARATROOPER,param1.mX,param1.mY);
               }
		       */
				}
			}
		}

		override public function destroy(): void {
			var _loc1_: GridCell = getCell();
			if (_loc1_) {
				_loc1_.mPowerUp = null;
			}
			super.destroy();
		}

		override public function updateTooltip(param1: int, param2: TooltipHealth): void {
			param2.setTitleText(mItem.mName);
			param2.setDetailsText(mItem.mName);
		}
	}
}