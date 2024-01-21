package game.actions
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import game.characters.PlayerUnit;
   import game.gui.TextEffect;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.items.ItemManager;
   import game.missions.MissionManager;
   import game.net.ServiceIDs;
   import game.player.GamePlayerProfile;
   import game.sound.ArmySoundManager;
   import game.sound.SoundCollection;
   import game.states.GameState;
   
   public class VisitNeighborTrainPlayerUnitAction extends Action
   {
       
      
      private var mLoadingCallbackEventType:String;
      
      private var mAnimation:MovieClip;
      
      private var mSound:SoundCollection;
      
      public function VisitNeighborTrainPlayerUnitAction(param1:PlayerUnit)
      {
         super("Train Player Unit");
         mTarget = param1;
         mSkipped = false;
         this.mSound = ArmySoundManager.SC_HELI;
         this.mSound.load();
      }
      
      override public function update(param1:int) : void
      {
         if((mTarget as PlayerUnit).isTrainingOver())
         {
            if(!mSkipped)
            {
               this.execute();
            }
         }
         if(mSkipped)
         {
            (mTarget as PlayerUnit).skipTraining();
            this.removeAnimation();
         }
      }
      
      override public function isOver() : Boolean
      {
         return (mTarget as PlayerUnit).isTrainingOver() || mSkipped;
      }
      
      override public function start() : void
      {
         if(mSkipped)
         {
            return;
         }
         var _loc1_:GameState = GameState.mInstance;
         if(_loc1_.mPlayerProfile.mNeighborActionsLeft <= 0)
         {
            (mTarget as PlayerUnit).addTextEffect(TextEffect.TYPE_GAIN,GameState.getText("SOCIAL_ENERGY_ZERO_FLOATING"));
            mSkipped = true;
            return;
         }
         (mTarget as PlayerUnit).startTraining();
         var _loc2_:DCResourceManager = DCResourceManager.getInstance();
         var _loc3_:String = Config.SWF_EFFECTS_NAME;
         if(_loc2_.isLoaded(_loc3_))
         {
            this.addAnimaion();
         }
         else
         {
            this.mLoadingCallbackEventType = _loc3_ + DCResourceManager.EVENT_COMPLETE_SINGLE_FILE;
            _loc2_.addEventListener(this.mLoadingCallbackEventType,this.animationLoaded,false,0,true);
            if(!_loc2_.isAddedToLoadingList(_loc3_))
            {
               _loc2_.load(Config.DIR_DATA + _loc3_ + ".swf",_loc3_,null,false);
            }
         }
         ArmySoundManager.getInstance().playSound(this.mSound.getSound());
      }
      
      private function checkFrame(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(_loc2_.totalFrames == _loc2_.currentFrame)
         {
            this.removeAnimation();
         }
      }
      
      private function removeAnimation() : void
      {
         if(this.mAnimation)
         {
            this.mAnimation.removeEventListener(Event.ENTER_FRAME,this.checkFrame);
            this.mAnimation.stop();
            if(this.mAnimation.parent)
            {
               this.mAnimation.parent.removeChild(this.mAnimation);
            }
            this.mAnimation = null;
         }
      }
      
      private function addAnimaion() : void
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_EFFECTS_NAME,"medevac");
         this.mAnimation = new _loc1_().getChildAt(0);
         this.mAnimation.addEventListener(Event.ENTER_FRAME,this.checkFrame);
         this.mAnimation.x = mTarget.mX;
         this.mAnimation.y = mTarget.mY;
         this.mAnimation.mouseChildren = false;
         this.mAnimation.mouseEnabled = false;
         GameState.mInstance.mScene.mSceneHud.addChild(this.mAnimation);
      }
      
      protected function animationLoaded(param1:Event) : void
      {
         DCResourceManager.getInstance().removeEventListener(param1.type,this.animationLoaded);
         this.mLoadingCallbackEventType = null;
         this.addAnimaion();
      }
      
      private function execute() : void
      {
         var _loc1_:GameState = GameState.mInstance;
         var _loc2_:IsometricScene = _loc1_.mScene;
         var _loc3_:PlayerUnit = mTarget as PlayerUnit;
         _loc3_.getCell().mNeighborActionAvailable = false;
         var _loc4_:GamePlayerProfile;
         (_loc4_ = _loc1_.mPlayerProfile).addNeighborActions(-1);
         var _loc5_:Object;
         var _loc6_:int = int((_loc5_ = GameState.mConfig.AllyAction.TrainPlayerUnit).RewardSocialXP);
         var _loc7_:int = int(_loc5_.RewardMoney);
         var _loc8_:int = int(_loc5_.RewardSupplies);
         _loc2_.addLootReward(ItemManager.getItem("SocialXP","Resource"),_loc6_,_loc3_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Money","Resource"),_loc7_,_loc3_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Supplies","Resource"),_loc8_,_loc3_.getContainer());
         _loc3_.handleTraining();
         MissionManager.increaseCounter("HelpNeighborTrain",_loc3_,1);
         var _loc9_:GridCell = mTarget.getCell();
         var _loc10_:Object = {
            "coord_x":_loc9_.mPosI,
            "coord_y":_loc9_.mPosJ,
            "neighbor_user_id":_loc1_.mVisitingFriend.mUserID,
            "reward_social_xp":_loc6_,
            "reward_money":_loc7_,
            "reward_supplies":_loc8_,
            "neighbor_counter":"Train",
            "target_type":ItemManager.getTableNameForItem(_loc3_.mItem),
            "target_id":_loc3_.mItem.mId
         };
         if(_loc1_.visitingTutor())
         {
            _loc10_.tutor_map = 2;
         }
         GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.SCHEDULE_ACTION_AT_NEIGHBOR,_loc10_,false);
         if(Config.DEBUG_MODE)
         {
         }
      }
   }
}
