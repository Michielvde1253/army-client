package game.items
{
   import flash.display.MovieClip;
   import flash.geom.Vector3D;
   import flash.utils.getDefinitionByName;
   import game.states.GameState;
   
   public class MapItem extends ShopItem
   {
       
      
      public var mObjectClass:Class;
      
      public var mLoader:String;
      
      public var mCollectionP:int;
      
      public var mCollection:Object;
      
      public var mCrafting:Object;
      
      public var mSize:Vector3D;
      
      public var mHealth:int;
      
      public var mSightRange:int;
      
      public var mWalkable:Boolean;
      
      public var mPlaceableOnAllTiles:Boolean;
      
      private var mShopIconGraphics:Array;
      
      private var mShopIconGraphicsFile:Array;
      
      public function MapItem(param1:Object)
      {
         var data:Object = param1;
         super(data);
         if(data.ObjectClass)
         {
            try
            {
               this.mObjectClass = getDefinitionByName(data.ObjectClass) as Class;
            }
            catch(errObject:Error)
            {
               Utils.LogError("MapItem() - Object class not found: " + data.ObjectClass);
            }
         }
         this.mLoader = data.GraphicsLoader;
         this.mCollectionP = data.CollectionP;
         this.mCollection = data.Collection;
         this.mCrafting = data;
         this.mSize = new Vector3D(data.DimX,data.DimY,data.DimZ);
         this.mHealth = data.Health;
         this.mSightRange = data.SightRange;
         this.mWalkable = data.Walkable != "No";
         if(data.PlaceableOnEnemyTile)
         {
            this.mPlaceableOnAllTiles = data.PlaceableOnEnemyTile == 1;
         }
         else
         {
            this.mPlaceableOnAllTiles = false;
         }
      }
      
      public function getItemSizeString() : String
      {
         return String(this.mSize.x + "x" + this.mSize.y);
      }
      
      override public function initGraphics(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1)
         {
            if(param1.IconGraphics)
            {
               this.mShopIconGraphics = new Array();
               this.mShopIconGraphicsFile = new Array();
               if(param1.IconGraphics is Array)
               {
                  _loc3_ = 0;
                  while(_loc3_ < param1.IconGraphics.length)
                  {
                     _loc2_ = (param1.IconGraphics[_loc3_] as String).lastIndexOf("/");
                     this.mShopIconGraphics[_loc3_] = (param1.IconGraphics[_loc3_] as String).substring(_loc2_ + 1);
                     this.mShopIconGraphicsFile[_loc3_] = (param1.IconGraphics[_loc3_] as String).substring(0,_loc2_);
                     _loc3_++;
                  }
               }
               else
               {
                  _loc2_ = int(param1.IconGraphics.lastIndexOf("/"));
                  this.mShopIconGraphics[0] = param1.IconGraphics.substring(_loc2_ + 1);
                  this.mShopIconGraphicsFile[0] = param1.IconGraphics.substring(0,_loc2_);
               }
            }
         }
         if(param1)
         {
            if(param1.Graphics)
            {
               mIconGraphics = new Array();
               mIconGraphicsFile = new Array();
               if(param1.Graphics is Array)
               {
                  _loc4_ = 0;
                  while(_loc4_ < param1.Graphics.length)
                  {
                     _loc2_ = (param1.Graphics[_loc4_] as String).lastIndexOf("/");
                     mIconGraphics[_loc4_] = (param1.Graphics[_loc4_] as String).substring(_loc2_ + 1);
                     mIconGraphicsFile[_loc4_] = (param1.Graphics[_loc4_] as String).substring(0,_loc2_);
                     _loc4_++;
                  }
               }
               else
               {
                  _loc2_ = int(param1.Graphics.toString().lastIndexOf("/"));
                  mIconGraphics[0] = param1.Graphics.toString().substring(_loc2_ + 1);
                  mIconGraphicsFile[0] = param1.Graphics.toString().substring(0,_loc2_);
               }
            }
         }
      }
      
      public function getShopIconGraphics() : String
      {
         if(this.mShopIconGraphics)
         {
            if(GameState.mInstance.mCurrentMapGraphicsId >= this.mShopIconGraphics.length)
            {
               return this.mShopIconGraphics[0];
            }
            return this.mShopIconGraphics[GameState.mInstance.mCurrentMapGraphicsId];
         }
         return null;
      }
      
      public function getShopIconGraphicsFile() : String
      {
         if(GameState.mInstance.mCurrentMapGraphicsId >= this.mShopIconGraphicsFile.length)
         {
            return this.mShopIconGraphicsFile[0];
         }
         return this.mShopIconGraphicsFile[GameState.mInstance.mCurrentMapGraphicsId];
      }
      
      override public function getIconMovieClip() : MovieClip
      {
         var _loc1_:MovieClip = super.getIconMovieClip();
         if(_loc1_)
         {
            _loc1_.gotoAndStop(1);
         }
         return _loc1_;
      }
      
      public function getCraftingObjectByID(param1:String) : Object
      {
         var _loc2_:Object = null;
         if(this.mCrafting is Array)
         {
            for each(_loc2_ in this.mCrafting)
            {
               if(_loc2_.ID == param1)
               {
                  return _loc2_;
               }
            }
            return null;
         }
         return this.mCrafting;
      }
   }
}
