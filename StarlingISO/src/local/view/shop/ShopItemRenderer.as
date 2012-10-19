package local.view.shop
{
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.comm.StyleSetting;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.item.BaseBuilding;
	import local.util.BuildingFactory;
	import local.util.GameUtil;
	import local.util.PopUpManager;
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
			baseVO = value as BaseBuildingVO;
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
		public function get onChange():ISignal{ return _onChange; }
		

		public var baseVO:BaseBuildingVO ;
		private var _wid:int = 260*GameSetting.GAMESCALE ;
		private var _het:int = 340*GameSetting.GAMESCALE ;
		private var _isMove:Boolean;
	
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
			var img:BuildingThumb = new BuildingThumb( baseVO.name , 200*GameSetting.GAMESCALE , 150*GameSetting.GAMESCALE );
			img.touchable = false ;
			img.x=_wid>>1;
			img.y = _het>>1 ;
			addChild( img );
			if(baseVO.span==1 && img.height*1.2<150*GameSetting.GAMESCALE ) img.setScale(1.2) ; 
			img.center();
			
			//标题
			var txtTitle:TextField =new TextField(_wid-10*GameSetting.GAMESCALE,50*GameSetting.GAMESCALE,baseVO.title,"Verdana",20*GameSetting.GAMESCALE,0,true) ;
			txtTitle.touchable = false;
			txtTitle.hAlign = HAlign.CENTER ;
			txtTitle.autoScale = true ;
			txtTitle.y = 5*GameSetting.GAMESCALE ;
			addChild(txtTitle);
		}
		
		private function onTouchHandler( e:TouchEvent ):void
		{
			if(e.touches.length>0){
				var touch:Touch = e.touches[0] ;
				if(touch.phase==TouchPhase.BEGAN){
					GameUtil.dark( this );
					_isMove = false ;
				}else{
					GameUtil.light( this );
				}
				if(touch.phase==TouchPhase.MOVED){
					_isMove = true ;
				}else if(touch.phase==TouchPhase.ENDED){
					if(!_isMove){
						var building:BaseBuilding = BuildingFactory.createBuildingByBaseVO( baseVO );
						GameWorld.instance.addBuildingToTopScene( building);
						GameData.villageMode=VillageMode.BUILDING_SHOP ;
						PopUpManager.instance.removeCurrentPopup();
					}
				}
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			_onChange.removeAll();
			_onChange = null ;
			_data = null ;
			_owner = null ;
			baseVO = null ;
		}
	}
}