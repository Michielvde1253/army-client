package game.gui.popups
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import game.states.GameState;
   
   public class SocialFriendsListHandler
   {
       
      
      public var type:int;
      
      public var dragHandleMC:MovieClip;
      
      public var track:MovieClip;
      
      public var upScrollControl:MovieClip;
      
      public var downScrollControl:MovieClip;
      
      public var isUp:Boolean = true;
      
      public var isDown:Boolean = true;
      
      public var dragBot:int;
      
      public var lengthPerItem:Number;
      
      public var sy:Number = 0;
      
      public var sRect:Rectangle;
      
      public var moveFieldY:Number;
      
      public var s:int;
      
      public var fractionToMove:Number;
      
      public var lengthOfFieldToMoveExtra:Number;
      
      public var sourceClip:MovieClip;
      
      public var numRowsToShow:int;
      
      public var rowWidth:int = 40;
      
      public var scrollBar:MovieClip;
      
      public var rowsAvailable:Array;
      
      public var friendsArray:Array;
      
      public var mOtherInstance:SocialFriendsListHandler;
      
      public var popupInviteInstance:MovieClip;
      
      public function SocialFriendsListHandler()
      {
         super();
      }
      
      private function checkScroll(param1:MouseEvent) : void
      {
         if(!this.isUp && param1.type == MouseEvent.MOUSE_DOWN)
         {
            this.isUp = true;
            this.popupInviteInstance.addEventListener(Event.ENTER_FRAME,this.updateScroll);
         }
         else if(param1.type == MouseEvent.MOUSE_UP)
         {
            this.isUp = false;
            this.popupInviteInstance.removeEventListener(Event.ENTER_FRAME,this.updateScroll);
         }
      }
      
      private function checkScrolldown(param1:MouseEvent) : void
      {
         if(!this.isDown && param1.type == MouseEvent.MOUSE_DOWN)
         {
            this.isDown = true;
            this.popupInviteInstance.addEventListener(Event.ENTER_FRAME,this.updateScrolldown);
         }
         else if(param1.type == MouseEvent.MOUSE_UP)
         {
            this.isDown = false;
            this.popupInviteInstance.removeEventListener(Event.ENTER_FRAME,this.updateScrolldown);
         }
      }
      
      private function updateScroll(param1:Event) : void
      {
         if(this.isUp)
         {
            this.dragHandleMC.y -= 5;
            if(this.dragHandleMC.y < 0)
            {
               this.dragHandleMC.y = 0;
            }
            this.updateDragScroll(new MouseEvent("a"));
         }
      }
      
      private function updateScrolldown(param1:Event) : void
      {
         if(this.isDown)
         {
            this.dragHandleMC.y += 5;
            if(this.dragHandleMC.y > this.track.height - this.dragHandleMC.height - 5)
            {
               this.dragHandleMC.y = this.track.height - this.dragHandleMC.height;
            }
            this.updateDragScroll(new MouseEvent("b"));
         }
      }
      
      private function updateDragScroll(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         param1.updateAfterEvent();
         if(this.friendsArray.length < this.numRowsToShow)
         {
            this.s = 0;
            this.lengthPerItem = this.friendsArray.length / (this.track.height - this.dragHandleMC.height);
            _loc2_ = 0;
            while(_loc2_ < this.rowsAvailable.length)
            {
               if(this.s + _loc2_ < this.friendsArray.length)
               {
                  (this.rowsAvailable[_loc2_] as Row_Friend).Button_Row.Text_Amount_Resource.text = this.friendsArray[this.s + _loc2_].name;
                  (this.rowsAvailable[_loc2_] as Row_Friend).y = this.sy + this.rowWidth * _loc2_;
                  ((this.rowsAvailable[_loc2_] as Row_Friend).getChildByName("mindex") as TextField).text = String(this.s + _loc2_);
                  if(this.type == 0)
                  {
                     (this.rowsAvailable[_loc2_] as Row_Friend).Button_Row.gotoAndStop("Plain");
                  }
                  else
                  {
                     (this.rowsAvailable[_loc2_] as Row_Friend).Button_Row.gotoAndStop("Cross");
                  }
                  (this.rowsAvailable[_loc2_] as Row_Friend).visible = true;
               }
               else
               {
                  (this.rowsAvailable[_loc2_] as Row_Friend).Button_Row.Text_Amount_Resource.text = "";
                  (this.rowsAvailable[_loc2_] as Row_Friend).visible = false;
               }
               _loc2_++;
            }
            return;
         }
         this.lengthPerItem = (this.friendsArray.length - this.numRowsToShow + 1) / (this.track.height - this.dragHandleMC.height);
         this.moveFieldY = this.lengthPerItem * this.dragHandleMC.y;
         this.s = Math.floor(this.moveFieldY);
         this.fractionToMove = this.moveFieldY - this.s;
         this.lengthOfFieldToMoveExtra = this.fractionToMove * (this.rowsAvailable[0] as Row_Friend).height;
         _loc2_ = 0;
         while(_loc2_ < this.rowsAvailable.length)
         {
            if(this.s + _loc2_ < this.friendsArray.length)
            {
               (this.rowsAvailable[_loc2_] as Row_Friend).Button_Row.Text_Amount_Resource.text = this.friendsArray[this.s + _loc2_].name;
               (this.rowsAvailable[_loc2_] as Row_Friend).y = this.sy + this.rowWidth * _loc2_ - this.lengthOfFieldToMoveExtra;
               ((this.rowsAvailable[_loc2_] as Row_Friend).getChildByName("mindex") as TextField).text = String(this.s + _loc2_);
               if(this.type == 0)
               {
                  (this.rowsAvailable[_loc2_] as Row_Friend).Button_Row.gotoAndStop("Plain");
               }
               else
               {
                  (this.rowsAvailable[_loc2_] as Row_Friend).Button_Row.gotoAndStop("Cross");
               }
               (this.rowsAvailable[_loc2_] as Row_Friend).visible = true;
            }
            else
            {
               (this.rowsAvailable[_loc2_] as Row_Friend).Button_Row.Text_Amount_Resource.text = "";
               (this.rowsAvailable[_loc2_] as Row_Friend).visible = false;
            }
            _loc2_++;
         }
      }
      
      private function dragScroll(param1:MouseEvent) : void
      {
         this.dragHandleMC.startDrag(false,this.sRect);
         GameState.mInstance.getMainClip().stage.addEventListener(MouseEvent.MOUSE_UP,this.stopScroll);
         GameState.mInstance.getMainClip().stage.addEventListener(MouseEvent.MOUSE_MOVE,this.updateDragScroll);
      }
      
      private function stopScroll(param1:MouseEvent) : void
      {
         this.dragHandleMC.stopDrag();
         GameState.mInstance.getMainClip().stage.removeEventListener(MouseEvent.MOUSE_UP,this.stopScroll);
         GameState.mInstance.getMainClip().stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.updateDragScroll);
      }
      
      private function updateRowSelect(param1:MouseEvent) : void
      {
         var _loc2_:int = parseInt(((param1.currentTarget as Row_Friend).getChildByName("mindex") as TextField).text);
         this.mOtherInstance.friendsArray.push(this.friendsArray[_loc2_]);
         this.friendsArray.splice(_loc2_,1);
         this.updateDragScroll(new MouseEvent("c"));
         this.mOtherInstance.updateDragScroll(new MouseEvent("d"));
      }
      
      public function selectDeselectAllFriends() : void
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this.friendsArray)
         {
            this.mOtherInstance.friendsArray.push(_loc1_);
         }
         this.friendsArray.splice(0,this.friendsArray.length);
         this.updateDragScroll(new MouseEvent("e"));
         this.mOtherInstance.updateDragScroll(new MouseEvent("f"));
      }
      
      public function sendInvitaion() : void
      {
         var _loc2_:Object = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this.mOtherInstance.friendsArray)
         {
            _loc1_.push(_loc2_.id);
         }
         GameState.mInstance.mAndroidFBConnection.inviteFriend(_loc1_);
      }
      
      public function initiallize(param1:Array, param2:SocialFriendsListHandler, param3:MovieClip, param4:int, param5:MovieClip, param6:int) : void
      {
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         this.friendsArray = param1;
         this.mOtherInstance = param2;
         this.sourceClip = param3;
         this.numRowsToShow = param4;
         this.type = param6;
         this.popupInviteInstance = param5;
         this.rowsAvailable = new Array(this.sourceClip.mc0,this.sourceClip.mc1,this.sourceClip.mc2,this.sourceClip.mc3,this.sourceClip.mc4,this.sourceClip.mc5,this.sourceClip.mc6);
         this.scrollBar = this.sourceClip.getChildByName("mScrollBar") as MovieClip;
         this.dragHandleMC = this.scrollBar.getChildByName("dragHandleMC") as MovieClip;
         this.track = this.scrollBar.getChildByName("track") as MovieClip;
         this.upScrollControl = this.scrollBar.getChildByName("upScrollControl") as MovieClip;
         this.downScrollControl = this.scrollBar.getChildByName("downScrollControl") as MovieClip;
         if(this.sourceClip.name == "destClip")
         {
            _loc8_ = this.track.height;
            this.track.height = 76;
            this.downScrollControl.y -= _loc8_ - this.track.height;
            this.dragHandleMC.height = 25;
         }
         this.dragBot = this.track.height + this.dragHandleMC.y - this.dragHandleMC.height;
         this.sRect = new Rectangle(this.dragHandleMC.x,this.dragHandleMC.y,0,this.dragBot);
         this.dragHandleMC.addEventListener(MouseEvent.MOUSE_DOWN,this.dragScroll);
         this.dragHandleMC.addEventListener(MouseEvent.MOUSE_UP,this.stopScroll);
         this.upScrollControl.addEventListener(MouseEvent.MOUSE_DOWN,this.checkScroll);
         this.upScrollControl.addEventListener(MouseEvent.MOUSE_UP,this.checkScroll);
         this.downScrollControl.addEventListener(MouseEvent.MOUSE_DOWN,this.checkScrolldown);
         this.downScrollControl.addEventListener(MouseEvent.MOUSE_UP,this.checkScrolldown);
         _loc7_ = 0;
         while(_loc7_ < this.rowsAvailable.length)
         {
            if(_loc7_ < this.friendsArray.length)
            {
               ((this.rowsAvailable[_loc7_] as Row_Friend).getChildByName("mindex") as TextField).text = String(_loc7_);
               (this.rowsAvailable[_loc7_] as Row_Friend).addEventListener(MouseEvent.MOUSE_DOWN,this.updateRowSelect);
               if(param6 == 0)
               {
                  (this.rowsAvailable[_loc7_] as Row_Friend).Button_Row.gotoAndStop("Plain");
               }
               else
               {
                  (this.rowsAvailable[_loc7_] as Row_Friend).Button_Row.gotoAndStop("Cross");
               }
               (this.rowsAvailable[_loc7_] as Row_Friend).Button_Row.Text_Amount_Resource.text = this.friendsArray[_loc7_].name;
               (this.rowsAvailable[_loc7_] as Row_Friend).y = this.sy + this.rowWidth * _loc7_;
               (this.rowsAvailable[_loc7_] as Row_Friend).visible = true;
            }
            else
            {
               (this.rowsAvailable[_loc7_] as Row_Friend).Button_Row.Text_Amount_Resource.text = "";
               (this.rowsAvailable[_loc7_] as Row_Friend).addEventListener(MouseEvent.MOUSE_DOWN,this.updateRowSelect);
               (this.rowsAvailable[_loc7_] as Row_Friend).visible = false;
            }
            _loc7_++;
         }
      }
   }
}
