package utils
{
	import bing.utils.ContainerUtil;
	
	import comm.GameSetting;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import views.CenterViewContainer;

	public class PopUpManager
	{
		private static var _queuePopList:Array =[] ;
		private static var _container:DisplayObjectContainer ;
		
		/**
		 * 注册弹出窗口的显示容器 
		 * @param container
		 */		
		public static function registerPopupContainer( container:DisplayObjectContainer ):void{
			_container = container ;
		}
		
		/**
		 * 添加序列显示的弹出窗口 
		 * @param mc
		 * @param modal 是否是模式窗口
		 */		
		public static function addQueuePopUp( mc:DisplayObject , modal:Boolean=true ):void
		{
			_queuePopList.push({window:mc , modal:modal });
			popupNextWindow();
		}
		
		//弹出下一个窗口
		private static function popupNextWindow():void
		{
			if(_container.numChildren==0 && _queuePopList.length>0)
			{
				var obj:Object = _queuePopList.pop();
				var mc:DisplayObject =  obj.window as DisplayObject;
				addPopUpToFront( mc , obj.modal );
			}
		}
		
		/**
		 * 弹出窗口到最上层
		 * @param mc
		 * @param modal 是否遮挡下面
		 */		
		public static function addPopUpToFront( mc:DisplayObject , modal:Boolean=true ):void 
		{
			if(modal){
				var popMask:PopupMask = new PopupMask();
				_container.addChild(popMask);
			}
			mc.x = (GameSetting.SCREEN_WIDTH-mc.width)*0.5 ;
			mc.y = (GameSetting.SCREEN_HEIGHT-mc.height)*0.5 ;
			_container.addChild(mc);
		}
		
		/**
		 * 弹出窗口到最后面 
		 * @param mc
		 * @param modal
		 */		
		public static function addPopUpToBehind( mc:DisplayObject , modal:Boolean=true ):void 
		{
			_container.addChildAt(mc,0);
			if(modal){
				var popMask:PopupMask = new PopupMask();
				_container.addChildAt(popMask,0);
				mc.x = (GameSetting.SCREEN_WIDTH-mc.width)*0.5 ;
				mc.y = (GameSetting.SCREEN_HEIGHT-mc.height)*0.5 ;
			}
		}
		
		/**
		 * 移除弹出窗口 
		 * @param mc
		 */		
		public static function removePopup( mc:DisplayObject ):void 
		{
			if(mc.parent){
				var index:int = mc.parent.getChildIndex( mc );
				if(index-1>=0 && mc.parent.getChildAt(index-1) is PopupMask)
				{
					mc.parent.removeChildAt( index-1);
				}
				mc.parent.removeChild( mc );
			}
			//从queueList中移除
			for( var i:int = 0 ; i<_queuePopList.length ; ++i)
			{
				var obj:DisplayObject = _queuePopList[i].window ;
				if( obj==mc){
					_queuePopList.splice(i,1); //从数组中删除
				}
			}
		}
		
		/**
		 * 移除所有的窗口 
		 */		
		public static  function removeAllPopup():void
		{
			ContainerUtil.removeChildren(_container);
			_queuePopList = [];
		}
	}
}

//-----------------------------------------------------------**
//-----------------------------------------------------------**/
import comm.GameSetting;
import comm.GlobalDispatcher;
import comm.GlobalEvent;

import flash.display.Sprite;
import flash.events.Event;

/**
 * popup窗口弹出时，遮挡下面的内容 
 * @author zzhanglin
 */	
class PopupMask extends Sprite
{
	public function PopupMask( color:uint=0 , alpha:Number =0.6 )
	{
		super();
		this.graphics.beginFill( color , alpha );
		this.graphics.drawRect(0,0,GameSetting.SCREEN_WIDTH,GameSetting.SCREEN_HEIGHT );
		this.graphics.endFill() ;
		
		addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler );
	}
	
	private function addedToStageHandler(e:Event):void
	{
		removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler);
		this.x = -parent.x ;
		this.y = -parent.y ;
		this.width = stage.stageWidth ;
		this.height = stage.stageHeight;
		
		GlobalDispatcher.instance.addEventListener( GlobalEvent.RESIZE , onResizeHandler );
		addEventListener(Event.REMOVED_FROM_STAGE , removedFromStageHandler);
	}
	
	private function onResizeHandler(e:GlobalEvent):void
	{
		this.x = -parent.x ;
		this.y = -parent.y ;
		this.width = stage.stageWidth ;
		this.height = stage.stageHeight;
	}
	
	private function removedFromStageHandler(e:Event):void
	{
		GlobalDispatcher.instance.removeEventListener( GlobalEvent.RESIZE , onResizeHandler );
		removeEventListener(Event.REMOVED_FROM_STAGE , removedFromStageHandler);
	}
	
}