package game.gameElements
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import game.gui.GameHUD;
   import game.gui.IconLoader;
   import game.gui.TextEffect;
   import game.gui.popups.PopUpManager;
   import game.isometric.IsometricScene;
   import game.items.CollectibleItem;
   import game.items.Item;
   import game.player.GamePlayerProfile;
   import game.sound.ArmySoundManager;
   import game.states.GameState;
   
   public class LootReward extends Sprite
   {
      
      private static const TIME_ON_SCREEN:Number = 2.5;
      
      private static const XP_TIME_ON_SCREEN:Number = 1.5;
      
      private static const TIME_TO_FLY_OFF_SCREEN:Number = 0.5;
      
      private static const XP_TIME_TO_FLY_OFF_SCREEN:Number = 0.5;
      
      private static var smCounter:int = 0;
      
      public static var smActivatedCounter:int;
      
      private static var smSoundPlayed:Boolean;
       
      
      private var mMaxTimeOnScreen:Number;
      
      private var mMaxTimeToFlyOffScreen:Number;
      
      private var mItem:Item;
      
      private var mBaseLoc:Point;
      
      private var mDestLoc:Point;
      
      private var mOffset:Point;
      
      private var mLifeTime:Number = 0;
      
      private var mAnimHeightFactor:Number = 600;
      
      private var mAnimTimeFactor:Number;
      
      private var mTextEffect:TextEffect;
      
      private var mGraphics:Sprite;
      
      private var mAmount:int;
      
      private var mActivated:Boolean;
      
      private var mHitArea:Sprite;
      
      private var mClicked:Boolean;
      
      public var mRewardGiven:Boolean;
      
      public function LootReward(param1:Item, param2:int, param3:Rectangle)
      {
         var _loc6_:int = 0;
         var _loc7_:IsometricScene = null;
         var _loc8_:Point = null;
         super();
         this.mItem = param1;
         IconLoader.addIcon(this,param1,this.iconLoaded);
         this.mAmount = param2;
         this.mAnimHeightFactor = 350 + Math.random() * 200;
         this.mOffset = new Point(Math.random() * 40 + 40,Math.random() * 10 + 40);
         this.mAnimTimeFactor = 0.6 + Math.random() * 0.4;
         var _loc4_:GameHUD = GameState.mInstance.mHUD;
         this.mDestLoc = new Point();
         var _loc5_:GamePlayerProfile = GameState.mInstance.mPlayerProfile;
         _loc6_ = 1;
         this.mMaxTimeOnScreen = TIME_ON_SCREEN;
         this.mMaxTimeToFlyOffScreen = TIME_TO_FLY_OFF_SCREEN;
         if(this.mItem.mId == "XP")
         {
            this.mAnimHeightFactor = 350;
            this.mAnimTimeFactor = 0.6;
            _loc6_ = Math.random() * 11 - 5;
            if(_loc4_)
            {
               this.mDestLoc = _loc4_.getXpBarLocation();
            }
            if(param2 > 0)
            {
               _loc5_.addXp(this.mAmount);
            }
            this.mMaxTimeOnScreen = XP_TIME_ON_SCREEN;
            this.mMaxTimeToFlyOffScreen = XP_TIME_TO_FLY_OFF_SCREEN;
         }
         else if(this.mItem.mId == "SocialXP")
         {
            if(_loc4_)
            {
               this.mDestLoc = _loc4_.getXpBarLocation();
            }
            if(param2 > 0)
            {
               _loc5_.addSocialXp(this.mAmount);
            }
         }
         else if(this.mItem.mId == "BadAssXP")
         {
            if(_loc4_)
            {
               this.mDestLoc = _loc4_.getXpBarLocation();
            }
            if(param2 > 0)
            {
               _loc5_.addBaddassXp(this.mAmount);
            }
         }
         else if(this.mItem.mId == "Energy")
         {
            if(_loc4_)
            {
               this.mDestLoc = _loc4_.getEnergyBarLocation();
            }
            if(param2 > 0)
            {
               _loc5_.addEnergy(this.mAmount);
            }
         }
         else if(this.mItem.mId == "Money" || this.mItem.mId == "Supplies" || this.mItem.mId == "Material")
         {
            if(_loc4_)
            {
               this.mDestLoc = _loc4_.getResourcesBarLocation();
            }
         }
         this.mBaseLoc = new Point((param3.left + param3.right) / 2,(param3.top + param3.bottom) / 2);
         if(param2 < 0)
         {
            _loc7_ = GameState.mInstance.mScene;
            _loc8_ = new Point(this.mDestLoc.x - _loc7_.mContainer.x,this.mDestLoc.y - _loc7_.mContainer.y);
            this.mDestLoc = this.mBaseLoc;
            this.mBaseLoc = _loc8_;
            this.mBaseLoc.x /= _loc7_.mContainer.scaleX;
            this.mBaseLoc.y /= _loc7_.mContainer.scaleY;
            this.mBaseLoc.x += 3 + Math.random() * -6;
            this.mBaseLoc.y += 3 + Math.random() * -6;
            this.mLifeTime = this.mMaxTimeOnScreen - this.mMaxTimeToFlyOffScreen;
            this.mouseEnabled = false;
            this.mouseChildren = false;
         }
         x = this.mBaseLoc.x;
         y = this.mBaseLoc.y;
         if(this.mActivated)
         {
            this.mActivated = false;
            smActivatedCounter = Math.max(0,--smActivatedCounter);
         }
         if(smCounter % 2 == 0)
         {
            this.mOffset.x *= -_loc6_;
         }
         ++smCounter;
         if(smCounter > 1000)
         {
            smCounter = 0;
         }
         smSoundPlayed = false;
      }
      
      public function iconLoaded(param1:Sprite) : void
      {
         if(this.mItem.mType != "Resource")
         {
            Utils.scaleIcon(param1,96,96);
         }
         else
         {
            Utils.scaleIcon(param1,60,60);
         }
         param1.mouseEnabled = true;
         param1.addEventListener(MouseEvent.MOUSE_UP,this.pressed);
         this.mGraphics = param1;
      }
      
      public function canBeRemoved() : Boolean
      {
         return this.mClicked && numChildren == 0 || !this.mClicked && this.mLifeTime > this.mMaxTimeOnScreen;
      }
      
      public function isIntel() : Boolean
      {
         return this.mItem.mType == "Intel";
      }
      
      public function getSupplies() : int
      {
         if(this.mItem.mId == "Supplies")
         {
            if(!this.mRewardGiven)
            {
               if(this.mAmount > 0)
               {
                  return this.mAmount;
               }
            }
         }
         return 0;
      }
      
      public function getWater() : int
      {
         if(this.mItem.mId == "Water")
         {
            if(!this.mRewardGiven)
            {
               if(this.mAmount > 0)
               {
                  return this.mAmount;
               }
            }
         }
         return 0;
      }
      
      public function Update(param1:int) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:IsometricScene = null;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc2_:Number = 1.2 - this.mLifeTime / this.mMaxTimeOnScreen;
         this.mLifeTime += param1 * _loc2_ / 1000;
         if(this.mItem.mId == "XP")
         {
            _loc7_ = 1 - this.mLifeTime / this.mMaxTimeOnScreen;
            if(this.mGraphics)
            {
               this.mGraphics.scaleX = _loc7_;
               this.mGraphics.scaleY = _loc7_;
            }
         }
         var _loc3_:Number = this.mLifeTime * this.mAnimTimeFactor;
         _loc3_ = Math.min(1,_loc3_);
         var _loc4_:Number = 3 * _loc3_;
         while(_loc4_ > 1)
         {
            _loc4_--;
         }
         if(!this.mClicked && this.mLifeTime + this.mMaxTimeToFlyOffScreen > this.mMaxTimeOnScreen)
         {
            if(this.mLifeTime - param1 <= this.mMaxTimeOnScreen)
            {
               this.mBaseLoc.x = x;
               this.mBaseLoc.y = y;
            }
            if(this.mAmount < 0)
            {
               if(Config.DEBUG_MODE)
               {
               }
            }
            _loc8_ = GameState.mInstance.mScene;
            if(this.mAmount > 0)
            {
               _loc10_ = (this.mDestLoc.x - _loc8_.mContainer.x) / _loc8_.mContainer.scaleX;
               _loc11_ = (this.mDestLoc.y - _loc8_.mContainer.y) / _loc8_.mContainer.scaleY;
               _loc5_ = _loc10_ - this.mBaseLoc.x;
               _loc6_ = _loc11_ - this.mBaseLoc.y;
            }
            else
            {
               _loc5_ = this.mDestLoc.x - this.mBaseLoc.x;
               _loc6_ = this.mDestLoc.y - this.mBaseLoc.y;
            }
            _loc9_ = (this.mLifeTime - this.mMaxTimeOnScreen + this.mMaxTimeToFlyOffScreen) / this.mMaxTimeToFlyOffScreen;
            x = this.mBaseLoc.x + _loc9_ * _loc5_;
            y = this.mBaseLoc.y + _loc9_ * _loc6_;
            if(this.mItem.mId != "XP")
            {
               if(Math.abs(_loc5_) < 1)
               {
                  if(Math.abs(_loc6_) < 1)
                  {
                     this.mLifeTime = this.mMaxTimeOnScreen + 1;
                  }
               }
            }
         }
         else
         {
            _loc5_ = _loc3_ * this.mOffset.x;
            _loc6_ = (_loc4_ * _loc4_ - _loc4_) * this.mAnimHeightFactor / (4 * _loc3_ + 1) + _loc3_ * this.mOffset.y;
            x = this.mBaseLoc.x + _loc5_;
            if(this.mItem.mId == "XP")
            {
               y = this.mBaseLoc.y - _loc6_;
            }
            else
            {
               y = this.mBaseLoc.y + _loc6_;
            }
         }
      }
      
      private function pressed(param1:MouseEvent) : void
      {
         if(!smSoundPlayed)
         {
            ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_COLLECT);
            smSoundPlayed = true;
         }
         this.mClicked = true;
         this.mLifeTime = this.mMaxTimeOnScreen;
         mouseEnabled = false;
         mouseChildren = false;
         this.addTextEffect();
         GameState.mInstance.getHud().itemCollected();
         if(this.mActivated)
         {
            this.mActivated = false;
            smActivatedCounter = Math.max(0,--smActivatedCounter);
         }
         if(this.mHitArea)
         {
            this.mHitArea.removeEventListener(MouseEvent.MOUSE_UP,this.pressed);
         }
         else
         {
            this.mGraphics.removeEventListener(MouseEvent.MOUSE_UP,this.pressed);
         }
         if(!smSoundPlayed)
         {
            ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_COLLECT);
            smSoundPlayed = true;
         }
         removeChild(this.mGraphics);
         this.mGraphics = null;
      }
      
      private function over(param1:MouseEvent) : void
      {
         if(this.mItem.mId != "XP")
         {
            if(!this.mActivated)
            {
               this.mActivated = true;
               ++smActivatedCounter;
               GameState.mInstance.mScene.hideObjectTooltip();
            }
         }
      }
      
      private function out(param1:MouseEvent) : void
      {
         if(this.mActivated)
         {
            this.mActivated = false;
            smActivatedCounter = Math.max(0,--smActivatedCounter);
         }
      }
      
      private function addTextEffect() : void
      {
         var _loc1_:TextEffect = new TextEffect(TextEffect.TYPE_GAIN,"+" + this.mAmount + " " + this.mItem.mName);
         var _loc2_:MovieClip = _loc1_.getClip();
         _loc2_.mouseChildre = false;
         _loc2_.mouseEnabled = false;
         addChild(_loc2_);
         _loc1_.start();
         this.mTextEffect = _loc1_;
      }
      
      public function canGiveReward() : Boolean
      {
         return !this.mRewardGiven && (this.mClicked || this.mLifeTime > this.mMaxTimeOnScreen);
      }
      
      public function getRewardFromLoot() : void
      {
         var _loc1_:GamePlayerProfile = null;
         if(!this.mRewardGiven)
         {
            if(this.mAmount > 0)
            {
               if(this.mItem.mId != "XP")
               {
                  if(this.mItem.mId != "SocialXP")
                  {
                     if(this.mItem.mId != "Energy")
                     {
                        if(this.mItem.mId != "BadAssXP")
                        {
                           _loc1_ = GameState.mInstance.mPlayerProfile;
                           _loc1_.addItem(this.mItem,this.mAmount);
                           if(FeatureTuner.USE_COLLECTION_CARD)
                           {
                              if(this.mItem is CollectibleItem)
                              {
                                 if(!PopUpManager.isModalPopupActive())
                                 {
                                    if(GameState.mInstance.mHUD)
                                    {
                                       GameState.mInstance.mHUD.mCollectionCard.pickedUpItem(CollectibleItem(this.mItem));
                                    }
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
            this.mRewardGiven = true;
         }
         else if(Config.DEBUG_MODE)
         {
         }
      }
      
      public function isActivated() : Boolean
      {
         return this.mActivated;
      }
   }
}
