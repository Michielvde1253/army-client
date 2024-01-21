package game.gameElements
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.actions.AcceptHelpCleanAction;
   import game.actions.Action;
   import game.actions.CleanAction;
   import game.actions.VisitNeighborCleanAction;
   import game.battlefield.MapData;
   import game.gui.TextEffect;
   import game.gui.TooltipHealth;
   import game.isometric.ImportedObject;
   import game.isometric.IsometricScene;
   import game.items.DebrisItem;
   import game.items.Item;
   import game.items.MapItem;
   import game.states.GameState;
   
   public class DebrisObject extends ImportedObject
   {
      
      public static const OPEN:int = 0;
      
      public static const IN_HARVEST_QUEUE:int = 1;
      
      public static const SEARCHING:int = 2;
      
      public static const REMOVE:int = 4;
       
      
      protected var mState:int = 0;
      
      private var mHealth:int = 0;
      
      private var mTextFXTimer:int;
      
      private var mTextFXQueue:Array;
      
      public function DebrisObject(param1:int, param2:IsometricScene, param3:MapItem, param4:Point, param5:Sprite = null)
      {
         super(param1,param2,param3,param4,param5);
         mMovable = false;
         this.mHealth = (param3 as DebrisItem).mHealth;
         getContainer().mouseEnabled = false;
         getContainer().mouseChildren = false;
         getContainer().visible = GameState.mInstance.mMapData.isFriendly(param4.x,param4.y);
         mVisible = GameState.mInstance.mMapData.isFriendly(param4.x,param4.y);
         this.mTextFXQueue = new Array();
      }
      
      public function setHealth(param1:int) : void
      {
         this.mHealth = param1;
      }
      
      override public function setupFromServer(param1:Object) : void
      {
         super.setupFromServer(param1);
         this.setHealth(param1.item_hit_points);
      }
      
      public function reduceHealth(param1:int) : void
      {
         this.setHealth(Math.max(0,this.getHealth() - param1));
         if(this.getHealth() <= 0)
         {
            this.remove();
         }
      }
      
      public function getHealth() : int
      {
         return this.mHealth;
      }
      
      public function getMaxHealth() : int
      {
         return (mItem as DebrisItem).mHealth;
      }
      
      public function addTextEffect(param1:int, param2:String, param3:Item = null) : void
      {
         this.mTextFXQueue.push(new TextEffect(param1,param2,param3));
      }
      
      override public function logicUpdate(param1:int) : Boolean
      {
         var _loc2_:TextEffect = null;
         var _loc3_:MovieClip = null;
         this.mTextFXTimer -= param1;
         if(this.mTextFXQueue.length > 0)
         {
            if(this.mTextFXTimer <= 0)
            {
               _loc2_ = this.mTextFXQueue[0];
               _loc3_ = _loc2_.getClip();
               _loc3_.y = 50;
               GameState.mInstance.mScene.mContainer.addChild(_loc3_);
               _loc3_.x = getContainer().x;
               _loc3_.y = getContainer().y;
               _loc2_.start();
               this.mTextFXQueue.splice(0,1);
               this.mTextFXTimer = 350;
            }
         }
         switch(this.mState)
         {
            case SEARCHING:
               mActionDelayTimer -= param1;
               setLoadingBarPercent(1 - mActionDelayTimer / GENERIC_ACTION_DELAY_TIME);
               break;
            case REMOVE:
               return true;
         }
         return false;
      }
      
      public function isCleaningOver() : Boolean
      {
         return this.mState == REMOVE || this.mState == SEARCHING && mActionDelayTimer < 0;
      }
      
      public function remove() : void
      {
         hideLoadingBar();
         this.mState = REMOVE;
      }
      
      override public function updateTooltip(param1:int, param2:TooltipHealth) : void
      {
         param2.setTitleText(mItem.mName);
         if(getCell().mOwner == MapData.TILE_OWNER_FRIENDLY)
         {
            param2.setDetailsText(mItem.getDescription());
         }
         else
         {
            param2.setDetailsText(GameState.getText("MOUSEOVER_DEBRIS_INFO_HOSTILE"));
         }
         param2.setHealth(this.mHealth,this.getMaxHealth());
      }
      
      public function skipSearch() : void
      {
         this.mState = OPEN;
         hideLoadingBar();
      }
      
      public function StartSearching() : void
      {
         this.mState = SEARCHING;
         showLoadingBar();
         spendNeighborAction();
      }
      
      override public function MousePressed(param1:MouseEvent) : void
      {
         var _loc2_:GameState = GameState.mInstance;
         _loc2_.moveCameraToSeeRenderable(this);
         if(this.mState == OPEN)
         {
            this.mState = IN_HARVEST_QUEUE;
            if(_loc2_.mState == GameState.STATE_VISITING_NEIGHBOUR)
            {
               if(mNeighborActionAvailable)
               {
                  _loc2_.queueAction(new VisitNeighborCleanAction(this));
               }
            }
            else
            {
               _loc2_.queueAction(new CleanAction(this));
            }
         }
      }
      
      override public function neighborClicked(param1:String) : Action
      {
         var _loc2_:Action = null;
         if(this.mState == OPEN)
         {
            this.mState = IN_HARVEST_QUEUE;
            _loc2_ = new AcceptHelpCleanAction(this,param1);
         }
         return _loc2_;
      }
   }
}
