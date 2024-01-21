package game.actions
{
   import game.characters.AnimationController;
   import game.characters.EnemyUnit;
   import game.gameElements.PlayerInstallationObject;
   import game.isometric.characters.IsometricCharacter;
   import game.isometric.elements.Renderable;
   import game.isometric.elements.WorldObject;
   import game.sound.ArmySoundManager;
   import game.states.GameState;
   
   public class Action
   {
      
      protected static var smSingleAttacksCount:int;
       
      
      public var mName:String;
      
      public var mTarget:WorldObject;
      
      public var mActor:WorldObject;
      
      public var mCharacterActors:Array;
      
      protected var mSkipped:Boolean;
      
      public var mCounterAction:Action;
      
      public var mSupportActions:Array;
      
      public function Action(param1:String = null)
      {
         super();
         this.mName = param1;
      }
      
      public function isOver() : Boolean
      {
         return true;
      }
      
      public function update(param1:int) : void
      {
      }
      
      public function addSupportAction(param1:Action) : void
      {
         if(!this.mSupportActions)
         {
            this.mSupportActions = new Array();
         }
         this.mSupportActions.push(param1);
      }
      
      public function skip() : void
      {
         var _loc1_:Action = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:IsometricCharacter = null;
         if(this.mCounterAction)
         {
            if(!this.mCounterAction.mSkipped)
            {
               this.mCounterAction.skip();
            }
         }
         if(this.mSupportActions)
         {
            _loc2_ = int(this.mSupportActions.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc1_ = this.mSupportActions[_loc3_] as Action;
               _loc1_.skip();
               _loc3_++;
            }
            this.mSupportActions = null;
         }
         if(this.mActor && this.mActor is Renderable && this.mActor.isAlive())
         {
            Renderable(this.mActor).setAnimationAction(AnimationController.CHARACTER_ANIMATION_IDLE);
         }
         else if(this.mCharacterActors)
         {
            for each(_loc4_ in this.mCharacterActors)
            {
               if(_loc4_.isAlive())
               {
                  _loc4_.setAnimationAction(AnimationController.CHARACTER_ANIMATION_IDLE);
               }
            }
         }
         this.mSkipped = true;
         if(this.mTarget)
         {
            (this.mTarget as Renderable).removedFromActionQueue();
            (this.mTarget as Renderable).hideLoadingBar();
         }
      }
      
      public function isEnemyAction() : Boolean
      {
         return Boolean(this.mActor) && this.mActor is EnemyUnit || Boolean(this.mCharacterActors) && this.mCharacterActors[0] is EnemyUnit;
      }
      
      public function isPlayerInstallationAction() : Boolean
      {
         return Boolean(this.mActor) && this.mActor is PlayerInstallationObject;
      }
      
      public function start() : void
      {
         if(this.mSkipped)
         {
            return;
         }
         if(this.mTarget)
         {
            (this.mTarget as Renderable).removedFromActionQueue();
         }
      }
      
      protected function playAttackSoundsForAttackers() : void
      {
         var _loc1_:Renderable = null;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < this.mCharacterActors.length)
         {
            _loc1_ = Renderable(this.mCharacterActors[_loc3_]);
            if(_loc2_.indexOf(_loc1_.mAttackSounds) == -1)
            {
               _loc2_.push(_loc1_.mAttackSounds);
               _loc1_.playCollectionSound(_loc1_.mAttackSounds);
            }
            _loc3_++;
         }
         if(Config.DEBUG_MODE)
         {
         }
         var _loc4_:int = int(_loc2_.length);
         while(_loc4_ < this.mCharacterActors.length)
         {
            _loc1_.playCollectionSound(ArmySoundManager.SC_FRN_ATTACK_SECONDARY);
            _loc4_++;
         }
      }
      
      public function setDirection(param1:int, param2:int = 1) : void
      {
         var _loc3_:int = 0;
         var _loc5_:Renderable = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc4_:int = param2 * GameState.mInstance.mScene.mGridDimX;
         if(this.mActor && this.mActor is Renderable && this.mActor.isRotatable())
         {
            if(param1 + _loc4_ <= this.mActor.mX)
            {
               _loc3_ = AnimationController.DIR_LEFT;
               this.mActor.setAnimationDirection(_loc3_);
            }
            else if(param1 > this.mActor.mX)
            {
               _loc3_ = AnimationController.DIR_RIGHT;
               this.mActor.setAnimationDirection(_loc3_);
            }
         }
         else if(this.mCharacterActors)
         {
            _loc6_ = int(this.mCharacterActors.length);
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               if((_loc5_ = this.mCharacterActors[_loc7_] as Renderable).isRotatable())
               {
                  if(param1 + _loc4_ <= _loc5_.mX)
                  {
                     _loc3_ = AnimationController.DIR_LEFT;
                     _loc5_.setAnimationDirection(_loc3_);
                  }
                  else if(param1 > _loc5_.mX)
                  {
                     _loc3_ = AnimationController.DIR_RIGHT;
                     _loc5_.setAnimationDirection(_loc3_);
                  }
               }
               _loc7_++;
            }
         }
      }
   }
}
