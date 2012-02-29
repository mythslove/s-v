package local.views.shop
{
	import bing.components.button.BaseButton;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import local.comm.GlobalDispatcher;
	import local.enum.BuildingType;
	import local.events.ShopEvent;
	import local.game.elements.Building;
	import local.model.buildings.vos.BaseBuildingVO;
	import local.model.buildings.vos.BaseDecorationVO;
	import local.model.buildings.vos.BaseFactoryVO;
	import local.model.buildings.vos.BaseHouseVO;
	import local.model.buildings.vos.BaseRoadVO;
	import local.model.buildings.vos.BaseStoneVO;
	import local.model.buildings.vos.BaseTreeVO;
	import local.model.buildings.vos.BuildingVO;
	import local.views.base.Image;
	import local.views.tooltip.GameToolTip;
	
	public class ShopItemRenderer extends MovieClip
	{
		public var container:Sprite;
		public var btnNormal:BaseButton;
		public var btnBg:SimpleButton ;
		public var txtBtn:TextField ,txtName:TextField;
		public var txtCoin:TextField , txtWood:TextField ,txtStone:TextField ;
		//==========================
		private const LABEL_DEFAULT:String = "defalut";
		private const LABEL_BUILDING:String = "building";
		
		public var vo:BuildingVO;
		
		public function ShopItemRenderer()
		{
			super();
			stop();
			container.mouseEnabled = container.mouseChildren=false ;
			addEventListener(Event.ADDED_TO_STAGE , addedToStageHandler , false , 0 , true  );
		}
		
		private function addedToStageHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			addEventListener( Event.REMOVED_FROM_STAGE , removedFromStageHandler , false , 0 , true  );
		}
		
		/**
		 * 显示此建筑 
		 * @param vo
		 */		
		public function showBuilding( vo:BuildingVO ):void
		{
			this.vo = vo ;
			txtName.text = vo.baseVO.name ; //显示名称
			container.addChild( new Image(vo.baseVO.alias+"Thumb" , vo.baseVO.thumb) ); //显示缩略图
			GameToolTip.instance.register(btnBg,stage,vo.baseVO.description); //注册ToolTip
			var type:String = vo.baseVO.type ;
			switch( type )
			{
				case BuildingType.BUILDING://建筑
					break ;
				case BuildingType.BUILDING_HOUSE: //房子
					gotoAndStop(LABEL_BUILDING);
					btnNormal.addEventListener(MouseEvent.CLICK , clickNormalBtnHandler,false,0,true);
					var baseHouseVO:BaseHouseVO = vo.baseVO as BaseHouseVO ;
					this["txtCoin"].text= vo.price+"";
					this["txtWood"].text= baseHouseVO.buildWood+"";
					this["txtStone"].text= baseHouseVO.buildStone+"";
					break ;
				case BuildingType.BUILDING_FACTORY: //工厂
					gotoAndStop(LABEL_BUILDING);
					btnNormal.addEventListener(MouseEvent.CLICK , clickNormalBtnHandler,false,0,true);
					var baseFactoryVO:BaseFactoryVO = vo.baseVO as BaseFactoryVO ;
					this["txtCoin"].text= vo.price+"";
					this["txtWood"].text= baseFactoryVO.buildWood+"";
					this["txtStone"].text= baseFactoryVO.buildStone+"";
					break ;
				case BuildingType.DECORATION: //装饰
					break ;
				case BuildingType.DEC_TREE: //树
					var baseTreeVO:BaseTreeVO = vo.baseVO as BaseTreeVO ;
					break ;
				case BuildingType.DEC_STONE: //石头
					break ;
				case BuildingType.DEC_ROAD: //路
					btnNormal.addEventListener(MouseEvent.CLICK , clickNormalBtnHandler,false,0,true);
					var baseRoadVO:BaseRoadVO = vo.baseVO as BaseRoadVO;
					this["txtCoin"].text= vo.price+"";
					break ;
			}
			disabledSprite();
		}
		
		private function clickNormalBtnHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			var type:String = vo.baseVO.type ;
			switch( type )
			{
				case BuildingType.BUILDING://建筑
					var baseVO:BaseBuildingVO = vo.baseVO ;
					break ;
				case BuildingType.BUILDING_HOUSE: //房子
					GlobalDispatcher.instance.dispatchEvent( new ShopEvent(ShopEvent.SELECTED_BUILDING,vo));
					break ;
				case BuildingType.BUILDING_FACTORY: //工厂
					var baseFactoryVO:BaseFactoryVO = vo.baseVO as BaseFactoryVO ;
					break ;
				case BuildingType.DECORATION: //装饰
					var baseDecVO:BaseDecorationVO = vo.baseVO as BaseDecorationVO ;
					break ;
				case BuildingType.DEC_TREE: //树
					var baseTreeVO:BaseTreeVO = vo.baseVO as BaseTreeVO ;
					break ;
				case BuildingType.DEC_STONE: //石头
					var baseStoneVO:BaseStoneVO = vo.baseVO as BaseStoneVO ;
					break ;
				case BuildingType.DEC_ROAD: //路
					GlobalDispatcher.instance.dispatchEvent( new ShopEvent(ShopEvent.SELECTED_BUILDING,vo));
					break ;
			}
		}
		
		private function disabledSprite():void
		{
			var inter:InteractiveObject; 
			for(var i:int = 0 ;i<numChildren ; ++i){
				inter = getChildAt(i) as InteractiveObject ;
				if( inter && !(inter is BaseButton) && !( inter is SimpleButton)){
					inter.mouseEnabled = false ;
					if(inter is DisplayObjectContainer){
						(inter as DisplayObjectContainer).mouseChildren=false;
					}
				}
			}
		}
		
		private function removedFromStageHandler( e:Event ):void
		{
			removeEventListener( Event.REMOVED_FROM_STAGE , removedFromStageHandler);
			btnNormal.removeEventListener(MouseEvent.CLICK , clickNormalBtnHandler );
			vo = null ;
			GameToolTip.instance.unRegister(btnBg);
		}
	}
}