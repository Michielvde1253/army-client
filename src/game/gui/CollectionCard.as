package game.gui
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.text.TextField;
   import game.items.CollectibleItem;
   import game.items.ItemCollectionItem;
   import game.items.ItemManager;
   import game.states.GameState;
   
   public class CollectionCard
   {
      
      private static const X:int = 630;
      
      private static const Y:int = 120;
       
      
      private var mTitle:TextField;
      
      private var mItemSlots:Array;
      
      private var mItemCounts:Array;
      
      private var mReadyForAddingItems:Boolean;
      
      private var mCurrentCollection:ItemCollectionItem;
      
      private var mNewItems:Array;
      
      private var mParent:DisplayObjectContainer;
      
      public var mClip:DisplayObjectContainer;
      
      public function CollectionCard(param1:DisplayObjectContainer)
      {
         var _loc4_:DisplayObjectContainer = null;
         super();
         var _loc2_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME,"hud_collection_card");
         this.mClip = new _loc2_();
         this.mClip.x = X;
         this.mClip.y = Y;
         this.mParent = param1;
         this.mReadyForAddingItems = false;
         this.mTitle = this.mClip.getChildByName("Text_Title") as TextField;
         this.mItemSlots = new Array();
         this.mItemCounts = new Array();
         var _loc3_:int = 1;
         while(this.mClip.getChildByName("Item_0" + _loc3_))
         {
            _loc4_ = this.mClip.getChildByName("Item_0" + _loc3_) as DisplayObjectContainer;
            this.mItemSlots.push(_loc4_.getChildByName("Item"));
            _loc4_ = _loc4_.getChildByName("Item_Amount") as DisplayObjectContainer;
            this.mItemCounts.push(_loc4_.getChildByName("Text_Value") as TextField);
            _loc3_++;
         }
      }
      
      public function pickedUpItem(param1:CollectibleItem) : void
      {
         if(!this.mClip.parent)
         {
            this.populateWith(ItemManager.getItem(param1.mCollection.ID,param1.mCollection.Type) as ItemCollectionItem);
            this.show();
            new DisplayObjectTransition(DisplayObjectTransition.FADE_APPEAR,this.mClip,0,this.setReady);
         }
         if(!this.mNewItems)
         {
            this.mNewItems = new Array();
         }
         this.mNewItems.push(param1);
      }
      
      private function doAddNextItem() : void
      {
         var _loc1_:CollectibleItem = null;
         var _loc2_:int = 0;
         if(this.mNewItems.length > 0)
         {
            _loc1_ = this.mNewItems.shift();
            this.populateWith(ItemManager.getItem(_loc1_.mCollection.ID,_loc1_.mCollection.Type) as ItemCollectionItem);
            _loc2_ = 0;
            while(_loc2_ < this.mCurrentCollection.mItems.length)
            {
               if(_loc1_.mId == this.mCurrentCollection.mItems[_loc2_].mId)
               {
                  new DisplayObjectTransition(DisplayObjectTransition.ATTENTION_UP,this.mItemSlots[_loc2_],0,this.doAddNextItem);
               }
               _loc2_++;
            }
         }
         else
         {
            this.hide();
         }
      }
      
      private function populateWith(param1:ItemCollectionItem) : void
      {
         var _loc3_:CollectibleItem = null;
         var _loc4_:int = 0;
         var _loc5_:DisplayObjectContainer = null;
         var _loc6_:TextField = null;
         this.mCurrentCollection = param1;
         this.mTitle.text = param1.mName;
         var _loc2_:int = 0;
         while(_loc2_ < this.mItemSlots.length)
         {
            _loc3_ = param1.mItems[_loc2_];
            _loc4_ = GameState.mInstance.mPlayerProfile.getItemCount(_loc3_);
            _loc5_ = this.mItemSlots[_loc2_] as DisplayObjectContainer;
            _loc6_ = this.mItemCounts[_loc2_] as TextField;
            if(_loc5_.numChildren > 0)
            {
               _loc5_.removeChildAt(0);
            }
            if(_loc4_ > 0)
            {
               IconLoader.addIcon(_loc5_,_loc3_,this.iconLoaded);
               _loc6_.text = String(_loc4_);
               _loc6_.visible = true;
            }
            else
            {
               _loc6_.visible = false;
            }
            _loc2_++;
         }
      }
      
      private function iconLoaded(param1:Sprite) : void
      {
         var _loc2_:DisplayObject = param1;
         var _loc3_:DisplayObjectContainer = param1;
         if(_loc3_.numChildren > 0)
         {
            _loc2_ = _loc3_.getChildAt(0) as DisplayObject;
         }
         _loc2_.x -= _loc2_.width / 2;
         _loc2_.y -= _loc2_.height / 2;
         param1.x = 0;
         param1.y = 0;
         param1.scaleX = 40 / param1.width;
         param1.scaleY = param1.scaleX;
      }
      
      private function setReady() : void
      {
         this.mReadyForAddingItems = true;
         this.doAddNextItem();
      }
      
      public function show() : void
      {
         this.mParent.addChild(this.mClip);
      }
      
      public function hide() : void
      {
         new DisplayObjectTransition(DisplayObjectTransition.DISAPPEAR,this.mClip,0);
         if(this.mClip.parent)
         {
            this.mClip.parent.removeChild(this.mClip);
         }
         this.mClip = null;
         this.mReadyForAddingItems = false;
      }
   }
}
