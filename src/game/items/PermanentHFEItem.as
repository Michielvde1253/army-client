package game.items
{
   public class PermanentHFEItem extends TargetItem
   {
       
      
      public var mCloudedGraphics:String;
      
      public var mCloudedGraphicsFile:String;
      
      public function PermanentHFEItem(param1:Object)
      {
         super(param1);
         mCrafting = param1.Crafting;
         var _loc2_:int = int(param1.CloudedGraphics.lastIndexOf("/"));
         this.mCloudedGraphics = param1.CloudedGraphics.substring(_loc2_ + 1);
         this.mCloudedGraphicsFile = param1.CloudedGraphics.substring(0,_loc2_);
      }
   }
}
