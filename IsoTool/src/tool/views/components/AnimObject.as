package tool.views.components
{
	import bing.animation.ActionVO;
	import bing.animation.AnimationBitmap;
	import bing.utils.InteractivePNG;
	
	import flash.display.Bitmap;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	
	import tool.comm.GlobalDispatcher;
	import tool.events.BuildingSettingEvent;
	import tool.local.vos.BitmapAnimResVO;
	
	public class AnimObject extends InteractivePNG
	{
		public var anim:AnimationBitmap ;
		public var bmp:Bitmap ;
		public var vo:BitmapAnimResVO ;
		
		protected var upItem:NativeMenuItem = new NativeMenuItem("上移");
		protected var downItem:NativeMenuItem = new NativeMenuItem("下移");
		protected var delItem:NativeMenuItem = new NativeMenuItem("删除");
		protected var rootMenu:NativeMenu = new NativeMenu();
		
		public function AnimObject()
		{
			super();
			bmp = new Bitmap();
			addChild(bmp);
			addEventListener(Event.ADDED_TO_STAGE , addedToStage);
			
			super._bitmapForHitDetection=bmp ;
			buildMenu();
		}
		
		protected function buildMenu():void
		{
			rootMenu.addItem(upItem);
			rootMenu.addItem(downItem);
			rootMenu.addItem( new NativeMenuItem("",true) );
			rootMenu.addItem(delItem);
			rootMenu.addEventListener(Event.SELECT, selectItem);
			this.contextMenu = rootMenu ;
		}
		
		protected function selectItem( e:Event ):void
		{
			switch( e.target)
			{
				case upItem:
					if(parent && parent.getChildIndex(this)< parent.numChildren-1){
						parent.setChildIndex( this,parent.getChildIndex(this)+1);
					}
					break ;
				case downItem:
					if(parent && parent.getChildIndex(this)>0 ){
						parent.setChildIndex( this,parent.getChildIndex(this)-1);
					}
					break ;
				case delItem:
					Alert.show( "确定要删除此图片" , "提示", Alert.YES|Alert.NO, FlexGlobals.topLevelApplication as Sprite, function(event:CloseEvent):void
					{
						if(event.detail==Alert.YES)
						{
							var evt:BuildingSettingEvent =  new BuildingSettingEvent(BuildingSettingEvent.DELETE) ;
							evt.vo = vo ;
							GlobalDispatcher.instance.dispatchEvent( evt );
						}
					});
					break ;
			}
		}
		
		public function setAnimResVO( vo:BitmapAnimResVO ):void
		{
			this.vo = vo ;
			x = vo.offsetX;
			y = vo.offsetY ;
			if(vo.isAnim)
			{
				if(anim) anim.dispose() ;
				vo.bmds = AnimationBitmap.splitBitmap( vo.png , vo.row , vo.col , vo.frame ) ;
				anim = new AnimationBitmap( vo.bmds,Vector.<ActionVO>([new ActionVO("anim",vo.frame)]) , vo.rate ) ;
			}
			else
			{
				if(anim){
					anim.dispose() ;
					anim = null ;
				}
				bmp.bitmapData = vo.bmds[0] ;
			}
		}
			
		
		protected function addedToStage( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStage);
			addEventListener( Event.REMOVED_FROM_STAGE , removedFromStage);
		}
		
		
		public function update():void
		{
			if(vo.isAnim && anim){
				anim.playAction("anim")
				if(anim.animationBmd!=bmp.bitmapData){
					bmp.bitmapData = anim.animationBmd ;
				}
			}
		}
		
		protected function removedFromStage( e:Event ):void
		{
			removeEventListener( Event.REMOVED_FROM_STAGE , removedFromStage );
			anim = null ;
			bmp = null ;
			vo = null ;
			rootMenu.removeEventListener(Event.SELECT, selectItem);
			upItem = null ;
			downItem = null ;
			delItem = null ;
		}
	}
}