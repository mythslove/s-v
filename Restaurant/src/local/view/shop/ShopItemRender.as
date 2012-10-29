package local.view.shop
{
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	
	import local.util.GameUtil;
	import local.util.StyleSetting;
	import local.view.base.BuildingThumb;
	import local.vo.BaseItemVO;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class ShopItemRender extends FeathersControl implements IListItemRenderer
	{
		private var _data:Object ;
		public function get data():Object{ return _data ; }
		public function set data(value:Object):void{
			_data = value;
			baseVO = value as BaseItemVO;
			show();
		}
		
		private var _index:int ;
		public function get index():int{ return _index ; };
		public function set index(value:int):void{ _index = value ;}
		
		private var _owner:List ;
		public function get owner():List{ return _owner ;}
		public function set owner(value:List):void{ _owner = value ;}
		
		
		public var baseVO:BaseItemVO ;
		private var _wid:int = 120 ;
		private var _het:int = 120 ;
		private var _isMove:Boolean;
		
		public function ShopItemRender()
		{
			super();
		}
		
		private function show():void
		{
			this.removeChildren(0,-1,true);
			
			var bg:Scale9Image = new Scale9Image( StyleSetting.instance.grayBgTexture );
			bg.width = _wid;
			bg.height = _het;
			addChild(bg);
			
			//图片
			var img:BuildingThumb = new BuildingThumb( baseVO.name , 150 , 150 );
			img.touchable = false ;
			img.x=_wid>>1;
			img.y = _het>>1 ;
			addChild( img );
			if(baseVO.xSpan==1 && baseVO.zSpan==1 && img.height*1.2<140) img.setScale(1.2) ; 
			img.center();
			
			//价格
			var price:int = baseVO.costCoin>0 ? baseVO.costCoin : baseVO.costCash ;
			var txtTitle:TextField =new TextField(_wid-10,50,price,"Verdana",20,0,true) ;
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
					_isMove = false ;
				}else{
					GameUtil.light( this );
				}
				if(touch.phase==TouchPhase.MOVED){
					_isMove = true ;
				}else if(touch.phase==TouchPhase.ENDED){
					if(!_isMove){
//						var building:BaseBuilding = BuildingFactory.createBuildingByBaseVO( baseVO );
//						GameWorld.instance.addBuildingToTopScene( building);
//						GameData.villageMode=VillageMode.BUILDING_SHOP ;
//						PopUpManager.instance.removeCurrentPopup();
					}
				}
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			_data = null ;
			_owner = null ;
			baseVO = null ;
		}
	}
}