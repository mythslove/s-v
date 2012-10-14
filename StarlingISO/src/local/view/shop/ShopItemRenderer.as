package local.view.shop
{
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	
	import local.comm.StyleSetting;
	import local.util.GameUtil;
	import local.view.base.BuildingThumb;
	import local.vo.BaseBuildingVO;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class ShopItemRenderer extends FeathersControl implements IListItemRenderer
	{
		private var _data:Object ;
		public function get data():Object{ return _data ; }
		public function set data(value:Object):void{
			_data = value;
			_baseVO = value as BaseBuildingVO;
			show();
		}
		
		private var _index:int ;
		public function get index():int{ return _index ; };
		public function set index(value:int):void{ _index = value ;}
		
		private var _owner:List ;
		public function get owner():List{ return _owner ;}
		public function set owner(value:List):void{ _owner = value ;}
		
		private var _isSelected:Boolean 
		public function get isSelected():Boolean{ return _isSelected ;}
		public function set isSelected(value:Boolean):void{ _isSelected = value ;}

		protected var _onChange:Signal = new Signal(ShopItemRenderer);
		public function get onChange():ISignal{
			return _onChange;
		}
		

		private var _baseVO:BaseBuildingVO ;
		private var _wid:int = 260 ;
		private var _het:int = 340 ;
	
		public function ShopItemRenderer()
		{
			super();
			this.width = _wid ;
			this.height = _het ;
			addEventListener(TouchEvent.TOUCH , onTouchHandler );
		}
		
		private function show():void
		{
			this.removeChildren(0,-1,true);
			
			var bg:Scale9Image = StyleSetting.SHOP_ITEM_BG_UP();
			bg.width = _wid;
			bg.height = _het;
			addChild(bg);
			
			//图片
			var img:BuildingThumb = new BuildingThumb( _baseVO.name , 200 , 150 );
			img.touchable = false ;
			img.x=_wid>>1;
			img.y = _het>>1 ;
			addChild( img );
			if(_baseVO.span==1 && img.height*1.2<150 ) img.setScale(1.2) ; 
			img.center();
			
			//标题
			var txtTitle:TextField =new TextField(_wid-10,50,_baseVO.title,"Verdana",20,0,true) ;
			txtTitle.touchable = false;
			txtTitle.hAlign = HAlign.CENTER ;
			txtTitle.autoScale = true ;
			txtTitle.y = 5 ;
			addChild(txtTitle);
		}
		
		private function onTouchHandler( e:TouchEvent ):void
		{
			if(e.touches.length>0){
				var touch:Touch = e.touches[0] ;
				if(touch.phase==TouchPhase.BEGAN){
					GameUtil.dark( this );
				}else{
					GameUtil.light( this );
				}
			}
		}
		
		override public function dispose():void
		{
			removeEventListener(TouchEvent.TOUCH , onTouchHandler );
			_data = null ;
			_owner = null ;
			_baseVO = null ;
		}
	}
}