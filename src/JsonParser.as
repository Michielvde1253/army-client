package
{
   public class JsonParser
   {
      
      private static const REFERENCE_TOKEN:String = "#";
      
      private static const REFERENCE_SEPARATOR:String = ".";
      
      private static const LIST_SEPARATOR:String = ",";
      
      public static const TEXTS_TABLE:String = "TID";
       
      
      public function JsonParser()
      {
         super();
      }
      
      public static function parseFile(param1:Object, param2:String) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:Object = null;
         var _loc10_:RegExp = null;
         var _loc3_:Object = JSONWrapper.decode(param2);
         for(_loc4_ in _loc3_)
         {
            param1[_loc4_] = new Object();
            for(_loc5_ in _loc3_[_loc4_])
            {
               param1[_loc4_][_loc5_] = new Object();
               for(_loc6_ in _loc3_[_loc4_][_loc5_])
               {
                  if((_loc7_ = String(_loc3_[_loc4_][_loc5_][_loc6_])) != null && _loc4_ != TEXTS_TABLE && _loc7_.search(LIST_SEPARATOR) != -1)
                  {
                     _loc8_ = _loc7_.split(LIST_SEPARATOR);
                     for(_loc9_ in _loc8_)
                     {
                        _loc8_[_loc9_] = trim(_loc8_[_loc9_]);
                     }
                     param1[_loc4_][_loc5_][_loc6_] = _loc8_;
                  }
                  else
                  {
                     if(_loc4_ == TEXTS_TABLE)
                     {
                        _loc10_ = /\\n/g;
                        _loc7_ = _loc7_.replace(_loc10_,"\n");
                     }
                     param1[_loc4_][_loc5_][_loc6_] = _loc7_;
                  }
               }
            }
         }
      }
      
      public static function link(param1:Object, param2:String) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         var _loc12_:Object = null;
         var _loc3_:Array = new Array();
         for(_loc4_ in param1)
         {
            for(_loc8_ in param1[_loc4_])
            {
               for(_loc9_ in param1[_loc4_][_loc8_])
               {
                  if((_loc10_ = param1[_loc4_][_loc8_][_loc9_]) is Array)
                  {
                     for(_loc11_ in _loc10_)
                     {
                        createLink(param1,param2,_loc3_,_loc10_[_loc11_] as String,_loc4_,_loc8_,_loc9_,_loc11_);
                     }
                  }
                  else
                  {
                     createLink(param1,param2,_loc3_,_loc10_ as String,_loc4_,_loc8_,_loc9_);
                  }
               }
            }
         }
         _loc6_ = int(_loc3_.length);
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            if((_loc5_ = _loc3_[_loc7_] as Object).refFieldName)
            {
               _loc12_ = param1[_loc5_.refTableName][_loc5_.refRowName][_loc5_.refFieldName];
            }
            else if(_loc5_.refRowName)
            {
               _loc12_ = param1[_loc5_.refTableName][_loc5_.refRowName];
            }
            else
            {
               _loc12_ = param1[_loc5_.refTableName];
            }
            if(_loc5_.arrayIndex != null)
            {
               param1[_loc5_.tableName][_loc5_.rowName][_loc5_.fieldName][_loc5_.arrayIndex] = _loc12_;
            }
            else
            {
               param1[_loc5_.tableName][_loc5_.rowName][_loc5_.fieldName] = _loc12_;
            }
            _loc7_++;
         }
      }
      
      private static function createLink(param1:Object, param2:String, param3:Array, param4:String, param5:Object, param6:Object, param7:Object, param8:Object = null) : void
      {
         var _loc9_:Object = null;
         var _loc10_:Array = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         if(param4 != null)
         {
            param4 = trim(param4);
            _loc9_ = null;
            if(param4.charAt(0) == REFERENCE_TOKEN)
            {
               if((_loc10_ = param4.split(REFERENCE_SEPARATOR)).length == 0 || _loc10_.length > 2)
               {
                  throw new Error("Invalid reference in " + param5 + " : " + param4);
               }
               _loc11_ = (_loc10_[0] as String).substring(1,(_loc10_[0] as String).length);
               if(param1[_loc11_] == null)
               {
                  throw new Error("Invalid reference in " + param5 + " : " + param4);
               }
               (_loc9_ = new Object()).refTableName = _loc11_;
               if(_loc10_.length == 2)
               {
                  _loc12_ = _loc10_[1] as String;
                  _loc9_.refRowName = _loc12_;
                  if(param1[_loc11_][_loc12_] == null)
                  {
                     throw new Error("Invalid reference in " + param5 + " : " + param4);
                  }
               }
               if(_loc11_ == TEXTS_TABLE)
               {
                  if(_loc10_.length != 2)
                  {
                     throw new Error("Invalid text reference in " + param5 + " : " + param4);
                  }
                  if(param1[TEXTS_TABLE][_loc12_][param2] == null || param1[TEXTS_TABLE][_loc12_][param2] == "")
                  {
                     throw new Error(_loc12_ + " is not defined in language " + param2);
                  }
                  _loc9_.refFieldName = param2;
               }
            }
            if(_loc9_)
            {
               _loc9_.tableName = param5;
               _loc9_.rowName = param6;
               _loc9_.fieldName = param7;
               _loc9_.arrayIndex = param8;
               param3.push(_loc9_);
            }
         }
      }
      
      public static function trim(param1:String) : String
      {
         var _loc2_:int = 0;
         while(param1.charCodeAt(_loc2_) < 33)
         {
            _loc2_++;
         }
         var _loc3_:int = param1.length - 1;
         while(param1.charCodeAt(_loc3_) < 33)
         {
            _loc3_--;
         }
         return param1.substring(_loc2_,_loc3_ + 1);
      }
   }
}
