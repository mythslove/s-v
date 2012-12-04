package game.util
{
	import game.comm.GameSetting;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	public class PopUpManager extends Sprite
	{
		private static var _instance:PopUpManager; 
		public function PopUpManager()	{
			super();
			if(_instance) throw new Error("只能有一个");
			else _instance = this ;
			x = GameSetting.SCREEN_WIDTH >> 1 ;
			y = GameSetting.SCREEN_HEIGHT >> 1 ;
		}
		public static function get instance():PopUpManager
		{
			if(!_instance)  _instance= new PopUpManager();
			return _instance ;
		}
		//-----------------------------------------------------------
		
		private var _popupList:Array =[] ;
		private var _currentPopupObj:Object ;//当前弹出的{window:popupwindow , modal: true }
		
		/**
		 * 当前队列中的数量 
		 * @return 
		 */		
		public function get queueSize():int
		{
			return _popupList.length;
		}
		
		
		/**
		 * 是否已经弹出来，或者已经在队列中 
		 * @param obj 类或者实例
		 * @return 
		 */		
		public function isInPop( obj:Object ):Boolean
		{
			var len:int = _popupList.length ;
			var cls:Class = obj as Class ;
			if( cls ){
				for( var i:int = 0 ; i<len ; ++i){
					if(_popupList[i].window is cls) return true ;
				}
				for( i=0;i<numChildren ; ++i){
					if(getChildAt(i) is cls) return true ;
				}
			}
			else
			{
				for( i = 0 ; i<len ; ++i){
					if( obj == _popupList[i].window ) return true ;
				}
				for( i=0 ; i<numChildren ; ++i){
					if( obj == getChildAt(i) ) return true ;
				}
			}
			return false;
		}
		
		
		//---------------------------序列显示弹出窗口----------------------------------------------
		/**
		 * 添加弹出窗口 
		 * @param mc
		 * @param priority 弹出的优先级
		 * @param modal 是否是模式窗口
		 */		
		public function addQueuePopUp( mc:DisplayObject ,  modal:Boolean=true , priority:int = 0 , maskAlpha:Number=0.0 ):void
		{
			if(!mc || this.contains(mc)) return ;
			
			_popupList.push({window:mc , modal:modal , priority:priority,maskAlpha:maskAlpha });
			if(priority!=0) sortByPriority();
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
			if(this.numChildren==0 && !_currentPopupObj && _popupList.length>0)
			{
				_currentPopupObj = _popupList.shift(); 
				var mc:DisplayObject =  _currentPopupObj.window as DisplayObject;
				if(_currentPopupObj.modal){
					var mask:PopupMask = new PopupMask();
					mask.alpha = _currentPopupObj.maskAlpha ;
					addChild( mask);
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
		public function addPopUp( mc:DisplayObject , modal:Boolean=true , topOrBottom:Boolean=true , maskAlpha:Number=0.7):void
		{
			if(!mc || this.contains(mc)) return ;
			
			if(topOrBottom){ //如果弹到顶层
				if(modal){
					var mask:PopupMask = new PopupMask();
					mask.alpha = maskAlpha ;
					addChild( mask);
				}
				addChild(mc);
			} else {
				addChildAt(mc,0);
				if(modal){
					mask = new PopupMask();
					mask.alpha = maskAlpha ;
					addChildAt( mask,0);
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
			popupNextWindow();
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

import game.comm.GameSetting;
import starling.display.DisplayObjectContainer;
import starling.display.Quad;
import starling.events.Event;

/**
 * popup窗口弹出时，遮挡下面的内容 
 * @author zzhanglin
 */	
class PopupMask extends Quad
{
	public function PopupMask( color:uint=0 )
	{
		super(GameSetting.SCREEN_WIDTH,GameSetting.SCREEN_HEIGHT ,color);
		pivotX = GameSetting.SCREEN_WIDTH>>1 ;
		pivotY = GameSetting.SCREEN_HEIGHT>>1 ;
		addEventListener(Event.ADDED_TO_STAGE , addedHandler) ;
	}
	
	private function addedHandler(e:Event):void
	{
		removeEventListener(Event.ADDED_TO_STAGE , addedHandler) ;
		addEventListener(Event.REMOVED_FROM_STAGE , removedHandler );
		if(parent)
		{
			var index:int = parent.getChildIndex(this);
			var container:DisplayObjectContainer ;
			for(var i:int=index-1 ; i>=0 ; --i){
				container = parent.getChildAt(i) as DisplayObjectContainer ;
				if(container is PopupMask) break ;
				else if(container) container.touchable = false ;
			}
		}
	}
	
	private function removedHandler(e:Event):void
	{
		removeEventListener(Event.REMOVED_FROM_STAGE , removedHandler );
		if(parent)
		{
			var index:int = parent.getChildIndex(this);
			var container:DisplayObjectContainer ;
			for(var i:int=index-1 ; i>=0 ; --i){
				container = parent.getChildAt(i) as DisplayObjectContainer ;
				if(container is PopupMask) break ;
				else if(container) container.touchable = true ;
			}
		}
	}
}