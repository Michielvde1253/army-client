package game.gameElements
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.gui.TooltipHealth;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.items.MapItem;
   import game.items.SignalItem;
   import game.net.MyServer;
   import game.net.ServiceIDs;
   import game.states.GameState;
   import game.utils.TimeUtils;
   
   public class SignalObject extends DecorationObject
   {
       
      
      public var mTimer:int;
      
      private const STATE_NORMAL:int = 0;
      
      private const STATE_REMOVE:int = 1;
      
      private var mSignalItem:SignalItem;
      
      public function SignalObject(param1:int, param2:IsometricScene, param3:MapItem, param4:Point, param5:Sprite = null)
      {
         super(param1,param2,param3,param4,param5);
         mMovable = false;
         this.mSignalItem = param3 as SignalItem;
         getContainer().mouseEnabled = false;
         this.changeState(this.STATE_NORMAL);
      }
      
      override public function setupFromServer(param1:Object) : void
      {
         super.setupFromServer(param1);
         this.mTimer = param1.next_action_at * 1000;
      }
      
      override public function logicUpdate(param1:int) : Boolean
      {
         var _loc2_:GameState = null;
         var _loc3_:MyServer = null;
         var _loc4_:GridCell = null;
         var _loc5_:Object = null;
         this.mTimer -= param1;
         switch(mState)
         {
            case this.STATE_NORMAL:
               if(this.mTimer <= 0)
               {
                  this.changeState(this.STATE_REMOVE);
               }
               break;
            case this.STATE_REMOVE:
               if(this.mTimer <= 0)
               {
                  _loc2_ = GameState.mInstance;
                  if(!_loc2_.visitingFriend())
                  {
                     _loc3_ = _loc2_.mServer;
                     _loc4_ = mScene.getCellAtLocation(mX,mY);
                     _loc5_ = {
                        "coord_x":_loc4_.mPosI,
                        "coord_y":_loc4_.mPosJ,
                        "reward_money":mItem.mDisbandRewardMoney
                     };
                     _loc3_.serverCallServiceWithParameters(ServiceIDs.SELL_ITEM,_loc5_,false);
                  }
                  return true;
               }
               break;
         }
         return false;
      }
      
      public function changeState(param1:int) : void
      {
         this.mTimer = 0;
         if(param1 == this.STATE_NORMAL)
         {
            this.mTimer = this.mSignalItem.mBurnTimeInMinutes * 60 * 1000;
         }
         else if(param1 == this.STATE_REMOVE)
         {
            this.mTimer = 1000;
         }
         mState = param1;
      }
      
      override public function updateTooltip(param1:int, param2:TooltipHealth) : void
      {
         if(mState == this.STATE_NORMAL)
         {
            param2.setTitleText(mItem.mName);
            param2.setDetailsText(GameState.replaceParameters(this.mSignalItem.mTooltipDescription,[TimeUtils.milliSecondsToString(this.mTimer)]));
         }
      }
      
      public function openFlarePopup() : void
      {
         var _loc1_:GameState = GameState.mInstance;
         _loc1_.moveCameraToSeeRenderable(this);
         if(_loc1_.mState == GameState.STATE_PLAY)
         {
            _loc1_.mHUD.openFlareWindow(this.mItem as SignalItem);
         }
      }
      
      override public function MousePressed(param1:MouseEvent) : void
      {
         this.openFlarePopup();
      }
   }
}
