package com.dchoc.engineisometric
{
   import flash.utils.ByteArray;
   
   public interface IWorldInterface
   {
       
      
      function selectToolSelect() : void;
      
      function selectToolTile(param1:Class) : void;
      
      function selectToolRaise() : void;
      
      function selectToolLower() : void;
      
      function addObject(param1:Class) : WorldElementObject;
      
      function selectToolDestroy() : void;
      
      function getLevelData() : ByteArray;
      
      function setLevelData(param1:ByteArray) : void;
      
      function setLevelDataTiles(param1:ByteArray) : void;
      
      function addListenerObjectMoved(param1:Function) : void;
      
      function addListenerObjectDestroyed(param1:Function) : void;
   }
}
