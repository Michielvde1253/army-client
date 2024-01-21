package game.gui
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gui.button.ResizingButton;
   import game.items.Item;
   
   public class AskPartsItemPanel
   {
      
      private static const ICON_H:int = 55;
       
      
      private var mAskButton:ResizingButton;
      
      private var mNameText:TextField;
      
      private var mCountText:TextField;
      
      private var mIconBase:MovieClip;
      
      private var mIcon:MovieClip = null;
      
      private var mItem:Item;
      
      private var mCount:int;
      
      private var mRequired:int;
      
      public var mBasePanel:MovieClip;
      
      private var mDialog:AskPartsDialog;
      
      private var mPopUpTextField:TooltipHUD;
      
      public function AskPartsItemPanel(param1:MovieClip, param2:AskPartsDialog)
      {
         super();
         this.mBasePanel = param1;
         this.mDialog = param2;
         this.mIconBase = param1.getChildByName("Icon") as MovieClip;
         this.mNameText = param1.getChildByName("Text_Title") as TextField;
         this.mNameText.mouseEnabled = false;
         this.mCountText = param1.getChildByName("Text_Description") as TextField;
      }
      
      public function setData(param1:Item, param2:int, param3:int) : void
      {
         if(this.mPopUpTextField)
         {
            if(this.mPopUpTextField.parent)
            {
               this.mPopUpTextField.parent.removeChild(this.mPopUpTextField);
            }
            this.mPopUpTextField = null;
         }
         this.mPopUpTextField = new TooltipHUD(200);
         this.mItem = param1;
         this.mPopUpTextField.setTitleText(param1.mName);
         this.mPopUpTextField.setDescriptionText(param1.getDescription());
         this.mNameText.text = param1.mName;
         this.mCount = param2;
         this.mRequired = param3;
         this.mCountText.text = this.mCount.toString() + "/" + this.mRequired.toString();
         if(this.mCount < param3)
         {
            this.mCountText.textColor = 10040064;
            this.mIconBase.alpha = 0.6;
         }
         else
         {
            this.mCountText.textColor = 0;
            this.mIconBase.alpha = 1;
         }
         if(this.mIcon != null)
         {
            this.mIconBase.removeChild(this.mIcon);
            this.mIcon = null;
         }
         IconLoader.addIcon(this.mIconBase,param1,this.loaded);
         this.mDialog.addChild(this.mPopUpTextField);
      }
      
      private function loaded(param1:Sprite) : void
      {
         var _loc2_:DisplayObject = param1.getChildAt(0);
         if(Boolean(_loc2_) && _loc2_ is Bitmap)
         {
            Bitmap(_loc2_).smoothing = true;
         }
         this.mIconBase.scaleX = ICON_H / _loc2_.height;
         this.mIconBase.scaleY = ICON_H / _loc2_.height;
         this.mIconBase.mouseChildren = false;
      }
      
      private function askPressed(param1:MouseEvent) : void
      {
         this.mDialog.askItem(this.mItem);
      }
      
      private function mouseMoved(param1:MouseEvent) : void
      {
         this.mPopUpTextField.visible = true;
         this.mPopUpTextField.x = this.mBasePanel.x - (this.mPopUpTextField.width >> 1);
         this.mPopUpTextField.y = this.mBasePanel.y - (this.mBasePanel.height >> 1) - this.mPopUpTextField.height;
      }
      
      private function mouseExit(param1:Event) : void
      {
         this.mPopUpTextField.visible = false;
      }
   }
}
