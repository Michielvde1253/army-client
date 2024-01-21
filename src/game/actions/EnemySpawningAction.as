package game.actions
{
   import game.battlefield.MapArea;
   import game.characters.AnimationController;
   import game.gameElements.DebrisObject;
   import game.gameElements.EnemyInstallationObject;
   import game.isometric.GridCell;
   import game.isometric.elements.Element;
   import game.items.ItemManager;
   import game.items.MapItem;
   import game.net.ServiceIDs;
   import game.states.GameState;
   
   public class EnemySpawningAction extends Action
   {
      
      protected static const STATE_BEFORE_SPAWN:int = 0;
      
      protected static const STATE_SPAWNING:int = 1;
      
      protected static const STATE_ENDING:int = 2;
      
      protected static const STATE_OVER:int = 3;
       
      
      protected var mState:int;
      
      protected var mNewState:int;
      
      protected var mSafetyTimer:int;
      
      private var mSpawnTile:GridCell;
      
      public function EnemySpawningAction(param1:EnemyInstallationObject)
      {
         super("SpawnEnemy");
         mActor = param1;
         this.mState = -1;
         this.mNewState = -1;
         this.mSpawnTile = null;
      }
      
      override public function update(param1:int) : void
      {
         if(mSkipped)
         {
            return;
         }
         if(this.mNewState != this.mState)
         {
            this.changeState(this.mNewState);
         }
         else
         {
            switch(this.mState)
            {
               case STATE_SPAWNING:
                  this.mSafetyTimer += param1;
                  if(mActor.getCurrentAnimationFrameLabel() == "end" || this.mSafetyTimer >= 3000)
                  {
                     this.execute();
                  }
                  break;
               case STATE_ENDING:
                  this.mSafetyTimer += param1;
                  if(mActor.getCurrentAnimationFrameLabel() == "end" || this.mSafetyTimer >= 300)
                  {
                     this.mNewState = STATE_OVER;
                  }
            }
         }
      }
      
      protected function changeState(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:GridCell = null;
         var _loc5_:Object = null;
         var _loc6_:MapArea = null;
         this.mState = param1;
         this.mNewState = param1;
         this.mSafetyTimer = 0;
         switch(this.mState)
         {
            case STATE_BEFORE_SPAWN:
               _loc2_ = (mActor as EnemyInstallationObject).mSpawnTileNumber;
               if(_loc2_ > 0)
               {
                  _loc6_ = MapArea.getAreaAroundObject(GameState.mInstance.mScene,mActor.getCell(),mActor.getTileSize().x,mActor.getTileSize().y);
                  this.mSpawnTile = _loc6_.getCells()[_loc2_ - 1];
                  if(!this.mSpawnTile || !this.mSpawnTile.mWalkable || this.mSpawnTile.mCharacterComingToThisTile || this.mSpawnTile.mCharacter || this.mSpawnTile.mObject && !(this.mSpawnTile.mObject is DebrisObject))
                  {
                     this.mSpawnTile = null;
                  }
               }
               else
               {
                  this.mSpawnTile = GameState.mInstance.mScene.getSurroundingFreeCell((mActor as Element).mX,(mActor as Element).mY);
               }
               if(this.mSpawnTile)
               {
                  this.mNewState = STATE_SPAWNING;
               }
               else
               {
                  this.mNewState = STATE_ENDING;
               }
               break;
            case STATE_SPAWNING:
               _loc3_ = mActor.setAnimationAction(AnimationController.INSTALLATION_ANIMATION_ACTION,false,true);
               if(!_loc3_)
               {
                  this.execute();
               }
               break;
            case STATE_ENDING:
               _loc3_ = mActor.setAnimationAction(AnimationController.INSTALLATION_ANIMATION_NOACTION,false,true);
               if(!_loc3_)
               {
                  this.mNewState = STATE_OVER;
               }
               break;
            case STATE_OVER:
               mActor.setAnimationAction(AnimationController.INSTALLATION_ANIMATION_IDLE,false,true);
               (mActor as EnemyInstallationObject).changeReactionState(EnemyInstallationObject.REACT_STATE_ACTION_COMPLETED);
               GameState.mInstance.enemyMoveMade();
               _loc4_ = mActor.getCell();
               _loc5_ = {
                  "enemy_coord_x":_loc4_.mPosI,
                  "enemy_coord_y":_loc4_.mPosJ,
                  "item_hit_points":0,
                  "reward_xp":0,
                  "reward_money":0,
                  "reward_supplies":0,
                  "reward_energy":0
               };
               GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.ACTIVATE_TURN_BASED_ENEMY,_loc5_,false);
         }
      }
      
      override public function isOver() : Boolean
      {
         return this.mState == STATE_OVER || mSkipped;
      }
      
      override public function start() : void
      {
         if(mSkipped)
         {
            (mActor as EnemyInstallationObject).changeReactionState(EnemyInstallationObject.REACT_STATE_ACTION_COMPLETED);
            return;
         }
         if(mActor == null || !mActor.isAlive())
         {
            skip();
            (mActor as EnemyInstallationObject).changeReactionState(EnemyInstallationObject.REACT_STATE_ACTION_COMPLETED);
            return;
         }
         if(GameState.mInstance.mState == GameState.STATE_VISITING_NEIGHBOUR)
         {
            skip();
            (mActor as EnemyInstallationObject).changeReactionState(EnemyInstallationObject.REACT_STATE_ACTION_COMPLETED);
            return;
         }
         this.mNewState = STATE_BEFORE_SPAWN;
      }
      
      protected function execute() : void
      {
         if(Config.DEBUG_MODE)
         {
         }
         if(this.mState != STATE_SPAWNING)
         {
            Utils.LogError("EnemySpawningAction: Illegal state");
            this.mNewState = STATE_OVER;
            return;
         }
         var _loc1_:MapItem = ItemManager.getItem((mActor as EnemyInstallationObject).mSpawnEnemy,"EnemyUnit") as MapItem;
         if(_loc1_)
         {
            GameState.mInstance.spawnEnemy(_loc1_,this.mSpawnTile);
         }
         this.mNewState = STATE_OVER;
      }
   }
}
