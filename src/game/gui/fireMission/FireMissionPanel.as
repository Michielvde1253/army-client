package game.gui.fireMission
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.items.FireMissionItem;
   
   public class FireMissionPanel
   {
       
      
      public var mFMItem:FireMissionItem;
      
      public var mClip:DisplayObjectContainer;
      
      private var mTitleTF:TextField;
      
      private var mSlots:Array;
      
      private var mCloseDialogFunction:Function;
      
      public function FireMissionPanel(param1:DisplayObjectContainer, param2:Function)
      {
         var _loc4_:FireMissionItemSlot = null;
         super();
         this.mClip = param1;
         this.mCloseDialogFunction = param2;
         this.mTitleTF = this.mClip.getChildByName("Powerup_Header") as TextField;
         param2 = null;
         this.mSlots = new Array();
         var _loc3_:int = 1;
         while(this.mClip.getChildByName("Powerup_Item_0" + _loc3_))
         {
            _loc4_ = new FireMissionItemSlot(param1.getChildByName("Powerup_Item_0" + _loc3_) as Sprite,param1);
            this.mSlots.push(_loc4_);
            _loc3_++;
         }
      }
      
      public function hide() : void
      {
         var _loc1_:FireMissionItemSlot = null;
         if(this.mTitleTF.parent)
         {
            this.mTitleTF.parent.removeChild(this.mTitleTF);
         }
         var _loc2_:int = int(this.mSlots.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this.mSlots[_loc3_] as FireMissionItemSlot;
            _loc1_.hide();
            _loc3_++;
         }
      }
      
      public function show() : void
      {
         var _loc1_:FireMissionItemSlot = null;
         if(!this.mTitleTF.parent)
         {
            this.mClip.addChild(this.mTitleTF);
         }
         var _loc2_:int = int(this.mSlots.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this.mSlots[_loc3_] as FireMissionItemSlot;
            _loc1_.show();
            _loc3_++;
         }
      }
      
      public function setData(param1:FireMissionItem) : Boolean
      {
         var _loc6_:FireMissionItemSlot = null;
         this.mFMItem = param1;
         this.mTitleTF.text = this.mFMItem.mName;
         var _loc2_:Array = param1.mRequiredItemSet.mItems;
         var _loc3_:Array = param1.mRequiredItemSet.mAmounts;
         var _loc4_:Boolean = true;
         var _loc5_:int = 0;
         while(_loc5_ < this.mSlots.length)
         {
            _loc6_ = this.mSlots[_loc5_] as FireMissionItemSlot;
            if(_loc2_.length > _loc5_ && Boolean(_loc2_[_loc5_]))
            {
               _loc6_.show();
               _loc4_ = _loc6_.setItem(_loc2_[_loc5_],_loc3_[_loc5_]) && _loc4_;
            }
            else
            {
               _loc6_.hide();
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function buyPressed(param1:MouseEvent) : void
      {
      }
   }
}
