package game.actions
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import game.characters.PlayerUnit;
   import game.isometric.IsometricScene;
   import game.items.ItemManager;
   import game.net.ServiceIDs;
   import game.sound.ArmySoundManager;
   import game.sound.SoundCollection;
   import game.states.GameState;
   
   public class AcceptHelpTrainPlayerUnitAction extends Action
   {
       
      
      private var mNeighborActionID:String;
      
      private var mLoadingCallbackEventType:String;
      
      private var mAnimation:MovieClip;
      
      private var mSound:SoundCollection;
      
      public function AcceptHelpTrainPlayerUnitAction(param1:PlayerUnit, param2:String)
      {
         super("Train Player Unit");
         mTarget = param1;
         mSkipped = false;
         this.mNeighborActionID = param2;
         this.mSound = ArmySoundManager.SC_HELI;
         this.mSound.load();
      }
      
      override public function update(param1:int) : void
      {
         var _loc2_:PlayerUnit = mTarget as PlayerUnit;
         if(mSkipped)
         {
            if(_loc2_)
            {
               _loc2_.skipTraining();
            }
            this.removeAnimation();
         }
         else if(_loc2_)
         {
            if(_loc2_.isTrainingOver())
            {
               this.execute();
            }
         }
      }
      
      override public function isOver() : Boolean
      {
         return mSkipped || (mTarget as PlayerUnit).isTrainingOver();
      }
      
      override public function start() : void
      {
         if(mSkipped)
         {
            return;
         }
         (mTarget as PlayerUnit).startTraining();
         var _loc1_:DCResourceManager = DCResourceManager.getInstance();
         var _loc2_:String = Config.SWF_EFFECTS_NAME;
         if(_loc1_.isLoaded(_loc2_))
         {
            this.addAnimaion();
         }
         else
         {
            this.mLoadingCallbackEventType = _loc2_ + DCResourceManager.EVENT_COMPLETE_SINGLE_FILE;
            _loc1_.addEventListener(this.mLoadingCallbackEventType,this.animationLoaded,false,0,true);
            if(!_loc1_.isAddedToLoadingList(_loc2_))
            {
               _loc1_.load(Config.DIR_DATA + _loc2_ + ".swf",_loc2_,null,false);
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
         this.mAnimation = new _loc1_().getChildAt(0) as MovieClip;
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
         var _loc1_:PlayerUnit = mTarget as PlayerUnit;
         var _loc2_:IsometricScene = GameState.mInstance.mScene;
         var _loc3_:Object = GameState.mConfig.AllyAction.TrainPlayerUnit;
         var _loc4_:int = int(_loc3_.AllyRewardXP);
         var _loc5_:int = int(_loc3_.AllyRewardMoney);
         _loc2_.addLootReward(ItemManager.getItem("XP","Resource"),_loc4_,_loc1_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Money","Resource"),_loc5_,_loc1_.getContainer());
         _loc1_.handleTraining();
         var _loc6_:Object = {
            "neighbor_action_id":this.mNeighborActionID,
            "reward_xp":_loc4_,
            "reward_money":_loc5_
         };
         var _loc7_:String = ServiceIDs.ACCEPT_HELP_TRAIN_UNIT;
         GameState.mInstance.mServer.serverCallServiceWithParameters(_loc7_,_loc6_,false);
         if(Config.DEBUG_MODE)
         {
         }
      }
   }
}
