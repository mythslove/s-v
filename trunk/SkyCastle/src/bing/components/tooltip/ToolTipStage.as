package bing.components.tooltip
{
	import flash.accessibility.AccessibilityProperties;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class ToolTipStage extends ToolTipBase
	{
		private static var instance:ToolTipStage;
		
		public function ToolTipStage()
		{
			super();
			this.bgColor = 0xF6F3FB;
		}
		
		/**
		 * 获得本类单例
		 * @param area 单例父级容器区域
		 * @return
		 *
		 */
		public static function getInstance():ToolTipStage
		{
			if (!instance)
			{
				instance=new ToolTipStage();
			}
			return instance;
		}
		
		override protected function drawBg():void
		{
			super.drawBg();
//			toolTipBg.alpha = 0.5;
		}
		
		override protected function drawArrow():void
		{
//			super.drawArrow();
//			toolTipArrow.alpha = 0.5;
		}
		
		override protected function initLable():void
		{
			//
			var format:TextFormat = new TextFormat(fontName,13,0x2E1C0A);
			textFormat = format;
			//
			label=new TextField();
			label.autoSize=TextFieldAutoSize.LEFT;
			label.selectable=false;
			label.multiline=true;
			label.wordWrap=false;
			label.defaultTextFormat=textFormat; //
			label.htmlText="";
			label.x=5;
			label.y=2;
			this.addChild(label); //
			visible=false;
			mouseEnabled=mouseChildren=false;
		}
		
		override public function register(area:DisplayObjectContainer, message:String):void
		{
			if (instance != null)
			{
				area.addChild(instance);
				var prop:AccessibilityProperties=new AccessibilityProperties();
				prop.description=message;
				area.accessibilityProperties=prop;
				area.addEventListener(MouseEvent.MOUSE_OVER, instance.mouseEventHandler);
			}
		}
		
		public function registerToStage(area:DisplayObjectContainer, message:String , stage:Stage):void
		{
			if (instance != null)
			{
				stage.addChild(instance);
				//				area.addChild(instance);
				var prop:AccessibilityProperties=new AccessibilityProperties();
				prop.description=message;
				area.accessibilityProperties=prop;
				area.addEventListener(MouseEvent.MOUSE_OVER, instance.mouseEventHandler);
			}
		}
		
		/**
		 * 注销 
		 * @param area
		 * 
		 */		
		override public function unregister(area:DisplayObject):void
		{
			if (instance != null)
			{
				area.removeEventListener(MouseEvent.MOUSE_OVER, instance.mouseEventHandler);
			}
		}
	}
}