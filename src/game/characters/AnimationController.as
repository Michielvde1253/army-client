package game.characters
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import game.isometric.elements.Renderable;
   
   public class AnimationController
   {
      
      public static const DIR_RIGHT:int = 0;
      
      public static const DIR_LEFT:int = 1;
      
      public static const DIR_UP:int = 3;
      
      public static const CHARACTER_ANIMATION_IDLE:int = 0;
      
      public static const CHARACTER_ANIMATION_MOVE:int = 1;
      
      public static const CHARACTER_ANIMATION_AIM:int = 2;
      
      public static const CHARACTER_ANIMATION_SHOOT:int = 3;
      
      public static const CHARACTER_ANIMATION_HIT:int = 4;
      
      public static const CHARACTER_ANIMATION_DYING:int = 5;
      
      public static const CHARACTER_ANIMATION_AIM_UP:int = 6;
      
      public static const CHARACTER_ANIMATION_SHOOT_UP:int = 7;
      
      public static const CHARACTER_ANIMATION_MOVE_UP:int = 8;
      
      public static const CHARACTER_ANIMATION_AIRDROP:int = 9;
      
      public static const CHARACTER_ANIMATION_EXPLOSION:int = 10;
      
      public static const INSTALLATION_ANIMATION_IDLE:int = 0;
      
      public static const INSTALLATION_ANIMATION_SHOOT:int = 1;
      
      public static const INSTALLATION_ANIMATION_HIT:int = 2;
      
      public static const INSTALLATION_ANIMATION_WRECKING:int = 3;
      
      public static const INSTALLATION_ANIMATION_READY_FOR_ACTION:int = 4;
      
      public static const INSTALLATION_ANIMATION_ACTION:int = 5;
      
      public static const INSTALLATION_ANIMATION_NOACTION:int = 6;
       
      
      protected var mOwner:Renderable;
      
      public var mAnimations:Array;
      
      private var mCurrentAnimation:int = 0;
      
      protected var mCurrentDirection:int = 0;
      
      private var mLoadingCallbackEventTypes:Object;
      
      private var mFiles:Array;
      
      private var mIsPlaying:Boolean = false;
      
      public function AnimationController(param1:Renderable)
      {
         super();
         this.mOwner = param1;
      }
      
      public function loadAnimations(param1:Array) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc9_:MovieClip = null;
         var _loc10_:Class = null;
         var _loc11_:String = null;
         var _loc2_:DCResourceManager = DCResourceManager.getInstance();
         this.mAnimations = new Array();
         this.mFiles = param1;
         this.mLoadingCallbackEventTypes = new Object();
         var _loc7_:int = int(param1.length);
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc5_ = (_loc6_ = param1[_loc8_] as String).lastIndexOf("/");
            _loc3_ = _loc6_.slice(_loc5_ + 1);
            _loc4_ = _loc6_.slice(0,_loc5_);
            _loc9_ = new MovieClip();
            this.mAnimations.push(_loc9_);
            if(_loc2_.isLoaded(_loc4_))
            {
               if((_loc10_ = _loc2_.getSWFClass(_loc4_,_loc3_)) != null)
               {
                  _loc9_.addChild(new _loc10_());
               }
            }
            else
            {
               _loc11_ = _loc4_ + DCResourceManager.EVENT_COMPLETE_SINGLE_FILE;
               this.mLoadingCallbackEventTypes[_loc11_] = _loc11_;
               _loc9_.visible = false;
               _loc9_.gotoAndStop(1);
               _loc2_.addEventListener(_loc11_,this.LoadingFinished);
               if(!_loc2_.isAddedToLoadingList(_loc4_))
               {
                  _loc2_.load(Config.DIR_DATA + _loc4_ + ".swf",_loc4_,null,false,false);
               }
            }
            _loc8_++;
         }
         this.mCurrentAnimation = 0;
      }
      
      public function LoadingFinished(param1:Event) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc7_:Class = null;
         var _loc8_:MovieClip = null;
         var _loc2_:DCResourceManager = DCResourceManager.getInstance();
         _loc2_.removeEventListener(param1.type,this.LoadingFinished);
         this.mLoadingCallbackEventTypes[param1.type] = null;
         var _loc6_:int = 0;
         while(_loc6_ < this.mFiles.length)
         {
            _loc5_ = (this.mFiles[_loc6_] as String).lastIndexOf("/");
            _loc3_ = (this.mFiles[_loc6_] as String).slice(_loc5_ + 1);
            _loc4_ = (this.mFiles[_loc6_] as String).slice(0,_loc5_);
            if(_loc2_.isLoaded(_loc4_))
            {
               if((this.mAnimations[_loc6_] as MovieClip).numChildren == 0)
               {
                  if((_loc7_ = _loc2_.getSWFClass(_loc4_,_loc3_)) != null)
                  {
                     (_loc8_ = this.mAnimations[_loc6_] as MovieClip).addChild(new _loc7_());
                     _loc8_.visible = true;
                  }
               }
            }
            _loc6_++;
         }
         if(this.mIsPlaying)
         {
            this.playCurrentAnimation();
         }
         else
         {
            this.stopCurrentAnimation();
         }
      }
      
      public function setAnimation(param1:int) : Boolean
      {
         if(param1 == this.mCurrentAnimation)
         {
            return false;
         }
         if(param1 >= this.mAnimations.length)
         {
            return false;
         }
         if(Config.DEBUG_MODE)
         {
         }
         this.mCurrentAnimation = param1;
         return true;
      }
      
      private function startShootAnimation(param1:Boolean) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         if(param1)
         {
            _loc2_ = this.mAnimations[CHARACTER_ANIMATION_SHOOT] as MovieClip;
         }
         else
         {
            _loc2_ = this.mAnimations[INSTALLATION_ANIMATION_SHOOT] as MovieClip;
         }
         if(_loc2_.numChildren > 0)
         {
            _loc3_ = _loc2_.getChildAt(_loc2_.numChildren - 1) as MovieClip;
            _loc3_.visible = true;
            _loc3_.gotoAndPlay(1);
            _loc3_.addEventListener(Event.ENTER_FRAME,this.enterFrame,false,0,true);
         }
      }
      
      public function setDirection(param1:int) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:MovieClip = null;
         var _loc7_:int = 0;
         var _loc8_:MovieClip = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         if(param1 != this.mCurrentDirection)
         {
            switch(param1)
            {
               case DIR_RIGHT:
                  _loc3_ = 0;
                  while(_loc3_ < this.mAnimations.length)
                  {
                     if(_loc3_ != CHARACTER_ANIMATION_DYING)
                     {
                        _loc2_ = this.mAnimations[_loc3_] as MovieClip;
                        _loc4_ = false;
                        _loc5_ = 0;
                        while(_loc5_ < _loc2_.numChildren)
                        {
                           _loc6_ = _loc2_.getChildAt(_loc5_) as MovieClip;
                           _loc7_ = 0;
                           while(_loc7_ < _loc6_.numChildren)
                           {
                              if(_loc8_ = _loc6_.getChildAt(_loc7_) as MovieClip)
                              {
                                 if(_loc8_.name == "Unit_Container")
                                 {
                                    _loc8_.scaleX = -_loc8_.scaleX;
                                    _loc4_ = true;
                                    break;
                                 }
                              }
                              if(_loc4_)
                              {
                                 break;
                              }
                              _loc7_++;
                           }
                           _loc5_++;
                        }
                        if(!_loc4_)
                        {
                           _loc2_.scaleX = -_loc2_.scaleX;
                        }
                     }
                     _loc3_++;
                  }
                  break;
               case DIR_LEFT:
                  _loc9_ = 0;
                  while(_loc9_ < this.mAnimations.length)
                  {
                     if(_loc9_ != CHARACTER_ANIMATION_DYING)
                     {
                        _loc2_ = this.mAnimations[_loc9_] as MovieClip;
                        _loc4_ = false;
                        _loc10_ = 0;
                        while(_loc10_ < _loc2_.numChildren)
                        {
                           _loc6_ = _loc2_.getChildAt(_loc10_) as MovieClip;
                           _loc11_ = 0;
                           while(_loc11_ < _loc6_.numChildren)
                           {
                              if(_loc8_ = _loc6_.getChildAt(_loc11_) as MovieClip)
                              {
                                 if(_loc8_.name == "Unit_Container")
                                 {
                                    _loc8_.scaleX = -_loc8_.scaleX;
                                    _loc4_ = true;
                                    break;
                                 }
                              }
                              _loc11_++;
                           }
                           if(_loc4_)
                           {
                              break;
                           }
                           _loc10_++;
                        }
                        if(!_loc4_)
                        {
                           _loc2_.scaleX = -_loc2_.scaleX;
                        }
                     }
                     _loc9_++;
                  }
                  break;
               case DIR_UP:
            }
            this.mCurrentDirection = param1;
         }
      }
      
      public function setSize(param1:int, param2:int) : void
      {
         (this.mAnimations[this.mCurrentAnimation] as MovieClip).width = param1;
         (this.mAnimations[this.mCurrentAnimation] as MovieClip).height = param2;
      }
      
      public function getAnimation() : MovieClip
      {
         return this.mAnimations[this.mCurrentAnimation];
      }
      
      public function getCurrentAnimationIndex() : int
      {
         return this.mCurrentAnimation;
      }
      
      public function getCurrentAnimation() : MovieClip
      {
         return this.mAnimations[this.mCurrentAnimation];
      }
      
      public function getCurrentAnimationFrameLabel() : String
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:int = 0;
         var _loc7_:MovieClip = null;
         var _loc1_:String = (this.mAnimations[this.mCurrentAnimation] as MovieClip).currentFrameLabel;
         if(!_loc1_)
         {
            _loc2_ = 0;
            while(_loc2_ < (this.mAnimations[this.mCurrentAnimation] as MovieClip).numChildren)
            {
               _loc3_ = (this.mAnimations[this.mCurrentAnimation] as MovieClip).getChildAt(_loc2_) as MovieClip;
               if(_loc3_)
               {
                  _loc1_ = _loc3_.currentFrameLabel;
                  if(_loc1_)
                  {
                     break;
                  }
                  _loc4_ = 0;
                  while(_loc4_ < _loc3_.numChildren)
                  {
                     if(_loc5_ = _loc3_.getChildAt(_loc4_) as MovieClip)
                     {
                        _loc1_ = _loc5_.currentFrameLabel;
                        if(_loc1_)
                        {
                           break;
                        }
                        _loc6_ = 0;
                        while(_loc6_ < _loc5_.numChildren)
                        {
                           if(_loc7_ = _loc5_.getChildAt(_loc6_) as MovieClip)
                           {
                              _loc1_ = _loc7_.currentFrameLabel;
                              if(_loc1_)
                              {
                                 return _loc1_;
                              }
                           }
                           _loc6_++;
                        }
                     }
                     _loc4_++;
                  }
               }
               _loc2_++;
            }
         }
         if(_loc1_)
         {
            return _loc1_;
         }
         return "";
      }
      
      protected function hasIdleAnimation() : Boolean
      {
         return false;
      }
      
      public function applyOnAllAnimations(param1:Function) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         if(this.mAnimations[this.mCurrentAnimation])
         {
            _loc2_ = 0;
            while(_loc2_ < this.mAnimations.length)
            {
               _loc3_ = this.mAnimations[_loc2_];
               if(_loc3_)
               {
                  param1(_loc3_);
               }
               _loc2_++;
            }
         }
      }
      
      public function playCurrentAnimation() : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:int = 0;
         var _loc6_:MovieClip = null;
         this.mIsPlaying = true;
         (this.mAnimations[this.mCurrentAnimation] as MovieClip).gotoAndPlay(1);
         var _loc1_:int = 0;
         while(_loc1_ < (this.mAnimations[this.mCurrentAnimation] as MovieClip).numChildren)
         {
            _loc2_ = (this.mAnimations[this.mCurrentAnimation] as MovieClip).getChildAt(_loc1_) as MovieClip;
            if(_loc2_)
            {
               _loc2_.gotoAndPlay(1);
               _loc3_ = 0;
               while(_loc3_ < _loc2_.numChildren)
               {
                  if(_loc4_ = _loc2_.getChildAt(_loc3_) as MovieClip)
                  {
                     _loc4_.gotoAndPlay(1);
                     _loc5_ = 0;
                     while(_loc5_ < _loc4_.numChildren)
                     {
                        if(_loc6_ = _loc4_.getChildAt(_loc5_) as MovieClip)
                        {
                           _loc6_.gotoAndPlay(1);
                        }
                        _loc5_++;
                     }
                  }
                  _loc3_++;
               }
            }
            _loc1_++;
         }
      }
      
      public function stopCurrentAnimation() : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:int = 0;
         var _loc6_:MovieClip = null;
         this.mIsPlaying = false;
         (this.mAnimations[this.mCurrentAnimation] as MovieClip).gotoAndStop(1);
         var _loc1_:int = 0;
         while(_loc1_ < (this.mAnimations[this.mCurrentAnimation] as MovieClip).numChildren)
         {
            _loc2_ = (this.mAnimations[this.mCurrentAnimation] as MovieClip).getChildAt(_loc1_) as MovieClip;
            if(_loc2_)
            {
               _loc2_.gotoAndStop(1);
               _loc3_ = 0;
               while(_loc3_ < _loc2_.numChildren)
               {
                  if(_loc4_ = _loc2_.getChildAt(_loc3_) as MovieClip)
                  {
                     _loc4_.gotoAndStop(1);
                     _loc5_ = 0;
                     while(_loc5_ < _loc4_.numChildren)
                     {
                        if(_loc6_ = _loc4_.getChildAt(_loc5_) as MovieClip)
                        {
                           _loc6_.gotoAndStop(1);
                        }
                        _loc5_++;
                     }
                  }
                  _loc3_++;
               }
            }
            _loc1_++;
         }
      }
      
      public function enterFrame(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(_loc2_.currentFrame == _loc2_.totalFrames)
         {
            (param1.target as MovieClip).stop();
            (param1.target as MovieClip).removeEventListener(Event.ENTER_FRAME,this.enterFrame);
         }
      }
      
      private function stopAnim(param1:DisplayObject, param2:Array) : void
      {
         if(param1 is MovieClip)
         {
            (param1 as MovieClip).gotoAndStop(1);
         }
      }
      
      public function destroy() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:MovieClip = null;
         for each(_loc1_ in this.mLoadingCallbackEventTypes)
         {
            if(_loc1_ != null)
            {
               DCResourceManager.getInstance().removeEventListener(_loc1_,this.LoadingFinished);
            }
         }
         for(_loc2_ in this.mAnimations)
         {
            _loc3_ = this.mAnimations[_loc2_];
            if(_loc3_)
            {
               Utils.CallForAllChildren(_loc3_,this.stopAnim,null);
               if(_loc3_.parent)
               {
                  _loc3_.parent.removeChild(_loc3_);
               }
            }
            this.mAnimations[_loc2_] = null;
         }
         this.mAnimations = null;
         _loc3_ = null;
      }
   }
}
