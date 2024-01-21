package com.dchoc.GUI
{
   import com.dchoc.events.ButtonEvent;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   
   public class DCTabs extends EventDispatcher
   {
       
      
      protected var mTabContents:Vector.<DisplayObjectContainer>;
      
      protected var mTabButtons:Vector.<DCButtonSelected>;
      
      protected var mParentTabButtons:Array;
      
      protected var mSubTabsMovieClips:Array;
      
      protected var mSelectedTab:int = -1;
      
      protected var mParent:DisplayObjectContainer;
      
      protected var mFunctionToCallWhenSelectATab:Function;
      
      public function DCTabs(param1:DisplayObjectContainer, param2:Function = null)
      {
         super();
         this.mParent = param1;
         this.mTabContents = new Vector.<DisplayObjectContainer>();
         this.mTabButtons = new Vector.<DCButtonSelected>();
         this.mParentTabButtons = new Array();
         this.mSubTabsMovieClips = new Array();
         this.setFunctionToCallWhenSelectATab(param2);
         addEventListener(DCWindow.EVENT_BUTTON_CLICKED,this.tabClicked,false,0,true);
      }
      
      public function setFunctionToCallWhenSelectATab(param1:Function = null) : void
      {
         this.mFunctionToCallWhenSelectATab = param1;
      }
      
      public function getParentTabIndex(param1:int) : int
      {
         return this.mParentTabButtons[param1];
      }
      
      public function addTab(param1:int, param2:String, param3:MovieClip, param4:DisplayObjectContainer, param5:Boolean = true, param6:DisplayObject = null, param7:int = -1, param8:String = null, param9:String = "") : DCButtonSelected
      {
         var _loc10_:DCButtonSelected = new DCButtonSelected(this.mParent,param3,DCButton.BUTTON_TYPE_TAB,"" + param1,this);
         if(!param5)
         {
            _loc10_.setEnabled(false);
         }
         _loc10_.setText(param2);
         _loc10_.setHelper(param8,param9);
         this.mTabButtons.push(_loc10_);
         this.mTabContents.push(param4);
         this.mParentTabButtons.push(param7);
         this.mSubTabsMovieClips.push(param6);
         this.hideTab(param1);
         return _loc10_;
      }
      
      public function selectTab(param1:int) : void
      {
         if(param1 == this.mSelectedTab)
         {
            (this.mTabButtons[param1] as DCButtonSelected).select();
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.mParentTabButtons.length)
         {
            if(this.mParentTabButtons[_loc2_] == param1)
            {
               (this.mTabButtons[param1] as DCButtonSelected).select();
               this.selectTab(_loc2_);
               return;
            }
            _loc2_++;
         }
         this.hideTab(this.mSelectedTab);
         this.mSelectedTab = param1;
         var _loc3_:int = int(this.mParentTabButtons[param1]);
         if(_loc3_ != -1)
         {
            (this.mTabButtons[_loc3_] as DCButtonSelected).select();
            (this.mTabButtons[_loc3_] as DCButtonSelected).putToFront();
            if(this.mSubTabsMovieClips[_loc3_] != null)
            {
               (this.mSubTabsMovieClips[_loc3_] as DisplayObject).visible = true;
            }
         }
         (this.mTabButtons[param1] as DCButtonSelected).select();
         (this.mTabButtons[param1] as DCButtonSelected).putToFront();
         var _loc4_:DisplayObjectContainer;
         (_loc4_ = this.mTabContents[param1] as DisplayObjectContainer).visible = true;
         if(this.mFunctionToCallWhenSelectATab != null)
         {
            this.mFunctionToCallWhenSelectATab(this.mSelectedTab);
         }
      }
      
      public function hideTab(param1:int) : void
      {
         if(param1 == -1)
         {
            return;
         }
         (this.mTabButtons[param1] as DCButtonSelected).unselect();
         (this.mTabButtons[param1] as DCButtonSelected).playAnim(DCButton.BUTTON_FRAME_NAME_OUT);
         (this.mTabButtons[param1] as DCButtonSelected).putToBack();
         var _loc2_:int = int(this.mParentTabButtons[param1]);
         if(_loc2_ != -1)
         {
            (this.mTabButtons[param1] as DCButtonSelected).unselect();
            (this.mTabButtons[param1] as DCButtonSelected).playAnim(DCButton.BUTTON_FRAME_NAME_OUT);
            (this.mTabButtons[param1] as DCButtonSelected).putToBack();
            if(this.mSubTabsMovieClips[_loc2_] != null)
            {
               (this.mSubTabsMovieClips[_loc2_] as DisplayObject).visible = false;
            }
         }
         var _loc3_:DisplayObjectContainer = this.mTabContents[param1] as DisplayObjectContainer;
         if(_loc3_ != null)
         {
            _loc3_.visible = false;
         }
      }
      
      public function hideAllTabs() : void
      {
         var _loc1_:int = int(this.mTabButtons.length - 1);
         while(_loc1_ >= 0)
         {
            this.hideTab(_loc1_);
            _loc1_--;
         }
      }
      
      public function enableAllTabs(param1:Boolean) : void
      {
         var _loc2_:int = int(this.mTabButtons.length - 1);
         while(_loc2_ >= 0)
         {
            this.enableTabAt(_loc2_,param1);
            _loc2_--;
         }
      }
      
      public function enableTabAt(param1:int, param2:Boolean) : void
      {
         DCButtonSelected(this.mTabButtons[param1]).setEnabled(param2);
      }
      
      private function tabClicked(param1:ButtonEvent) : void
      {
         this.selectTab(parseInt(param1.getID()));
         param1.stopImmediatePropagation();
      }
      
      public function getSize() : int
      {
         return this.mTabButtons.length;
      }
      
      public function getTabButtons() : Vector.<DCButtonSelected>
      {
         return this.mTabButtons;
      }
      
      public function getSelectedTabIndex() : int
      {
         return this.mSelectedTab;
      }
      
      public function getContentAtTab(param1:int) : DisplayObjectContainer
      {
         if(param1 < this.mTabContents.length)
         {
            return this.mTabContents[param1];
         }
         return null;
      }
      
      public function setContentAtTab(param1:int, param2:DisplayObjectContainer) : void
      {
         this.mTabContents[param1] = param2;
      }
      
      public function clean() : void
      {
         removeEventListener(DCWindow.EVENT_BUTTON_CLICKED,this.tabClicked);
      }
   }
}
