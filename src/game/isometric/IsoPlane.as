package game.isometric
{
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Vector3D;
   
   public class IsoPlane extends Sprite
   {
      
      public static const UV:Array = [[0,0],[1,0],[1,1],[0,1]];
       
      
      public function IsoPlane(param1:BitmapData, param2:Matrix, param3:int, param4:int)
      {
         super();
      }
      
      public function WithPerspection(param1:BitmapData, param2:Vector.<Vector3D>, param3:int, param4:int) : void
      {
         graphics.clear();
         var _loc5_:Vector.<Number> = new Vector.<Number>();
         var _loc6_:Vector.<Number> = new Vector.<Number>();
         var _loc7_:Vector.<int>;
         (_loc7_ = new Vector.<int>()).push(0,1,3,1,2,3);
         var _loc8_:int = 0;
         while(_loc8_ < 4)
         {
            _loc5_.push((param2[_loc8_] as Vector3D).x,(param2[_loc8_] as Vector3D).y);
            _loc6_.push(UV[_loc8_][0] * param3,UV[_loc8_][1] * param4,(param2[_loc8_] as Vector3D).w);
            _loc8_++;
         }
         graphics.beginBitmapFill(param1,null,false);
         graphics.drawTriangles(_loc5_,_loc7_,_loc6_);
      }
   }
}
