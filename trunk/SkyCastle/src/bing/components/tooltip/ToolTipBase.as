package  bing.components.tooltip
{
	
	import flash.accessibility.AccessibilityProperties;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	

	public class ToolTipBase extends Sprite
	{
		protected var toolTipBg:Sprite=new Sprite();
		protected var toolTipArrow:Sprite=new Sprite();
		protected var label:TextField;
		private var area:DisplayObject;
		public var textColor:uint=0x666666;
		private var _backgroundColor:uint=0xFFFFFF;
		private var _textFormat:TextFormat;
		private var _mouseOffest:Point=new Point(5, 10);
		private var _showDropShadow:Boolean=true;

		private static var instance:ToolTipBase;

		public function ToolTipBase()
		{
			super();
			init();
		}
		
		/**
		 * 获得本类单例
		 * @param area 单例父级容器区域
		 * @return
		 *
		 */
		public static function getInstance():ToolTipBase
		{
			if (!instance)
			{
				instance=new ToolTipBase();
			}
			return instance;
		}

		/**
		 * 是否显示投影
		 */
		public function get showDropShadow():Boolean
		{
			return _showDropShadow;
		}

		/**
		 * @private
		 */
		public function set showDropShadow(value:Boolean):void
		{
			_showDropShadow=value;

			if (showDropShadow)
			{
				var dropShadow:DropShadowFilter=new DropShadowFilter();
				var filtersArray:Array=new Array(dropShadow);
				this.filters=filtersArray;
			}
			else
			{
				this.filters=[];
			}
		}

		/**
		 * 鼠标偏移量
		 * @return
		 *
		 */
		public function get mouseOffest():Point
		{
			return _mouseOffest;
		}

		public function set mouseOffest(value:Point):void
		{
			_mouseOffest=value;
		}

		/**
		 * 背景色
		 * @return
		 *
		 */
		public function get bgColor():uint
		{
			return _backgroundColor;
		}

		public function set bgColor(value:uint):void
		{
			_backgroundColor=value;
			//设置背景色
			this.drawArrow()
			this.drawBg()
		}

		/**
		 * 文本信息样式
		 * @return
		 *
		 */
		public function get textFormat():TextFormat
		{
			if (!_textFormat)
			{
				_textFormat=new TextFormat("Verdana", 11, textColor);
			}
			return _textFormat;
		}

		public function set textFormat(value:TextFormat):void
		{
			_textFormat=value;
		}

		/**
		 * 注册TOOLTIP
		 * @param area 注册区域
		 * @param message ToolTip 显示文本信息.
		 *
		 */
		public function register(area:DisplayObjectContainer, message:String):void
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
		
		/**
		 * 注销 
		 * @param area
		 * 
		 */		
		public function unregister(area:DisplayObject):void
		{
			if (instance != null)
			{
				area.removeEventListener(MouseEvent.MOUSE_OVER, instance.mouseEventHandler);
			}
		}

		public function show(area:DisplayObject):void
		{
			this.area=area;
			this.area.addEventListener(MouseEvent.MOUSE_OUT, this.mouseEventHandler);
			this.area.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseEventHandler);
			label.htmlText=area.accessibilityProperties.description;
			//
			drawBg();
			drawArrow();
		}

		private function hide():void
		{
			if (area)
			{
				this.area.removeEventListener(MouseEvent.MOUSE_OUT, this.mouseEventHandler);
				this.area.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseEventHandler);
				this.area=null;
				visible=false;
			}
		}

		/**
		 * 鼠标移动根据鼠标坐标调整ToolTip位置
		 * @param point
		 *
		 */
		private function move(point:Point):void
		{
			var lp:Point=this.parent.globalToLocal(point);
			if (!visible)
			{
				visible=true;
			}
			//鼠标在场景右侧
			if (point.x > this.stage.stageWidth * 0.5)
			{
				this.x=lp.x - this.width + mouseOffest.x;
			}
			else
			{
				this.x=lp.x - mouseOffest.x;
			}
			//鼠标在场景左侧
			if (point.y < this.stage.stageWidth * 0.5)
			{
				this.y=lp.y + (mouseOffest.y * 2);
			}
			else
			{
				this.y=lp.y - label.height - mouseOffest.y;
			}
			//刷新
			refurbish(point);
		}

		/**
		 *
		 * @param event
		 *
		 */
		protected function mouseEventHandler(event:MouseEvent):void
		{
			switch (event.type)
			{
				case MouseEvent.MOUSE_OUT:
					this.hide();
					break;
				case MouseEvent.MOUSE_MOVE:
					this.move(new Point(event.stageX, event.stageY));
					break;
				case MouseEvent.MOUSE_OVER:
					this.show(event.target as DisplayObject);
					this.move(new Point(event.stageX, event.stageY))
					break;
			}
		}

		/**
		 * 刷新
		 * @param point 当前鼠标在场景中的坐标
		 *
		 */
		private function refurbish(point:Point):void
		{
			var lp:Point=this.parent.globalToLocal(point);
			var w:Number=label.width - (toolTipArrow.width * 0.5) - 1;
			var h:Number=toolTipArrow.height + label.height - 1;
			if (this.y < lp.y)
			{ //下
				this.toolTipArrow.scaleY=1;
				if (point.x > this.stage.stageWidth * 0.5)
				{ //右边
					this.toolTipArrow.x=w;
					this.toolTipArrow.y=h;
				}
				else
				{ //左边
					this.toolTipArrow.x=2;
					this.toolTipArrow.y=h;
				}
			}
			else
			{ //上
				this.toolTipArrow.scaleY=-1;
				if (point.x > this.stage.stageWidth * 0.5)
				{ //右边
					this.toolTipArrow.x=w;
					this.toolTipArrow.y=0;
				}
				else
				{ //左边
					this.toolTipArrow.x=2;
					this.toolTipArrow.y=0;
				}
			}
		}

		/**
		 * 绘制背景
		 * 
		 */
		protected function drawBg():void
		{
			var w:Number=10 + label.width;
			var h:Number=4 + label.height;
			toolTipBg.graphics.clear();
			toolTipBg.graphics.beginFill(bgColor);
			toolTipBg.graphics.drawRoundRect(0, 0, w, h, 5, 5);
			toolTipBg.graphics.endFill();
		}

		/**
		 * 绘制箭头
		 *
		 */
		protected function drawArrow():void
		{
			toolTipArrow.graphics.clear();
			toolTipArrow.graphics.beginFill(bgColor);
			toolTipArrow.graphics.moveTo(3, 0);
			toolTipArrow.graphics.lineTo(9, 0);
			toolTipArrow.graphics.lineTo(6, 5);
			toolTipArrow.graphics.lineTo(3, 0);
			toolTipArrow.graphics.endFill();
		}

		/**
		 * 初始化标签
		 *
		 */
		protected function initLable():void
		{
			label=new TextField();
			label.autoSize=TextFieldAutoSize.LEFT;
			label.selectable=false;
			label.multiline=false;
			label.wordWrap=false;
			label.defaultTextFormat=textFormat; //
			label.text="";
			label.x=5;
			label.y=2;
			this.addChild(label); //
			visible=false;
			mouseEnabled=mouseChildren=false;
		}

		/**
		 * 初始化
		 *
		 */
		protected function init():void
		{
			this.addChild(toolTipBg);
			this.addChild(toolTipArrow);
			initLable();
			//设置投影
			var dropShadow:DropShadowFilter=new DropShadowFilter();
			var filtersArray:Array=new Array(dropShadow);
			this.filters=filtersArray;
		}
	}
}