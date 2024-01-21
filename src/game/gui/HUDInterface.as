package game.gui
{
   import flash.events.MouseEvent;
   import game.isometric.elements.Renderable;
   import game.net.ErrorObject;
   
   public interface HUDInterface
   {
       
      
      function resize(param1:int, param2:int) : void;
      
      function enableMouse(param1:Boolean) : void;
      
      function hideObjectTooltip() : void;
      
      function buttonZoomOutPressed(param1:MouseEvent) : void;
      
      function buttonZoomInPressed(param1:MouseEvent) : void;
      
      function setZoomIndicator(param1:int) : void;
      
      function showObjectTooltip(param1:Renderable, param2:int = 0) : void;
      
      function itemCollected() : void;
      
      function updateToggleButtonStates() : void;
      
      function logicUpdate(param1:int) : void;
      
      function openErrorMessage(param1:String, param2:String, param3:ErrorObject, param4:Boolean = true) : void;
      
      function openHiddenErrorMessage(param1:String, param2:String, param3:Boolean = true) : void;
      
      function openPvPDebriefingDialog() : void;
      
      function openPvPMatchUpDialog() : void;
      
      function openPvPCombatSetupDialog() : void;
      
      function cancelTools() : void;
      
      function openOutOfEnergyWindow() : void;
      
      function openOutOfSuppliesTextBox(param1:Array) : void;
      
      function triggerShopOpening(param1:String, param2:String = "normal") : void;
      
      function getLastTab() : String;
      
      function setLastTab(param1:String) : void;
   }
}
