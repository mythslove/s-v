package local.utils
{
	import local.comm.GameSetting;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class PopUpManager extends Sprite
	{
		private static var _instance:PopUpManager; 
		public static function get instance():PopUpManager
		{
			if(!_instance)  _instance= new PopUpManager();
			return _instance ;
		}
		//-----------------------------------------------------------
		
		private var _popupList:Array =[] ;
		private var _currentPopupObj:Object ;//当前弹出的{window:popupwindow , modal: true }
		
		
		//---------------------------序列显示弹出窗口----------------------------------------------
		/**
		 * 添加弹出窗口 
		 * @param mc
		 * @param priority 弹出的优先级
		 * @param modal 是否是模式窗口
		 */		
		public function addQueuePopUp( mc:DisplayObject ,  modal:Boolean=true , priority:int = 0 ):void
		{
			if(!mc || this.contains(mc)) return ;
			
			_popupList.push({window:mc , modal:modal , priority:priority });
			sortByPriority();
			popupNextWindow();
		}
		/**
		 * 移除最上面的那个弹出窗口 ，会触发弹出下一个弹出窗口
		 */		
		public function removeCurrentPopup():void
		{
			if(_currentPopupObj){
				if(contains(_currentPopupObj.window))
				{
					var index:int = getChildIndex(_currentPopupObj.window );
					removeChild(_currentPopupObj.window as DisplayObject);
					if(index>0 && this.getChildAt(index-1) is PopupMask){ 
						this.removeChildAt(index-1); //移除Mask
					}
				}
				_currentPopupObj = null ;
				popupNextWindow();
			}
		}
		/**
		 * 清空queue列表，不包括当前已经弹出的
		 */		
		public function clearNextQueuePopups():void
		{
			_popupList=[];
		}
		/** 弹出下一个 */
		private function popupNextWindow():void
		{
			if(!_currentPopupObj && _popupList.length>0)
			{
				_currentPopupObj = _popupList.pop();
				var mc:DisplayObject =  _currentPopupObj.window as DisplayObject;
				if(_currentPopupObj.modal){
					addChild( new PopupMask());
				}
				this.addChild(mc);
				if(parent){ //将当前对象设置为最上面
					parent.setChildIndex( this , parent.numChildren-1); 
				}
			}
		}
		/** 根据优先级来排序 */
		private function sortByPriority():void
		{
			_popupList.sortOn("priority",Array.DESCENDING |Array.NUMERIC);
		}
		
		
		
		//---------------------------添加普通弹出窗口----------------------------------------------
		/**
		 * 添加普通的弹出窗口 
		 * @param mc 
		 * @param topOrBottom 添加到弹出窗口的最上面还是最下面，默认为最上
		 */		
		public function addPopUp( mc:DisplayObject , modal:Boolean=true , topOrBottom:Boolean=true):void
		{
			if(!mc || this.contains(mc)) return ;
			
			if(topOrBottom){ //如果弹到顶层
				if(modal){
					addChild( new PopupMask());
				}
				addChild(mc);
			} else {
				addChildAt(mc,0);
				if(modal){
					addChildAt( new PopupMask(),0);
				}
			}
		}
		/**
		 * 移除普通弹出窗口 ，不会触发弹出下一个弹出窗口
		 * @param mc
		 */		
		public function removePopUp( mc:DisplayObject ):void
		{
			for( var i:int = 0 ; i<_popupList.length ; ++i)
			{
				var obj:DisplayObject = _popupList[i].window ;
				if( obj==mc){
					_popupList.splice(i,1); //从数组中删除
					break ;
				}
			}
			if(this.contains(mc)){
				var index:int = this.getChildIndex( mc ) ;
				this.removeChild(mc); //移除弹出窗口
				if(index>0 && this.getChildAt(index-1) is PopupMask){ 
					this.removeChildAt(index-1); //移除Mask
				}
			}
		}
		
		/**
		 * 清除所有的，包含已经弹出的 
		 */		
		public function clearAll():void
		{
			_currentPopupObj = null ;
			_popupList = [] ;
			while(this.numChildren>0)
			{
				this.removeChildAt(0);
			}
		}
	}
}

//-----------------------------------------------------------**
//-----------------------------------------------------------**/
import local.comm.GameSetting;
import local.comm.GlobalDispatcher;
import local.comm.GlobalEvent;

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