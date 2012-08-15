package game.elements.items
{
	import bing.utils.SystemUtil;
	
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import game.elements.cell.AniComponent;
	import game.elements.cell.BaseItem;
	import game.mvc.model.ItemVOModel;
	import game.mvc.model.vo.ItemVO;
	import game.utils.DirectionUtil;
	/**
	 * 有动作的ITEM 
	 * @author zzhanglin
	 */	
	public class AnimationItem extends BaseItem
	{
		public var itemVO:ItemVO ;
		public var currPoint:Point =new Point(); //当前的位置
		public var actionName:String ="stand" ; //当前的动作
		public var currentAniComponent:AniComponent ; //当前的动作组件
		public var itemContainer:Sprite ;
		public var content:Sprite ;
		private var _direction:int =1; //当前的方向
		
		//============getter/setter==================
		public function get direction():int
		{
			return _direction;
		}
		public function set direction(value:int):void
		{
			_direction = value;
			if(_direction<=5){
				if(itemContainer) this.itemContainer.scaleX=1;
			}else {
				_direction = 10-this.direction ;
				if(itemContainer) this.itemContainer.scaleX=-1;
			}
		}
		//==============getter/setter end=======================
		
		public function AnimationItem( faceId:int )
		{
			super();
			this.mouseChildren = false ;
			if(!itemVO)
			{
				itemVO = ItemVOModel.instance.getItemVOByFaceId( faceId );
			}
			this.mouseEnabled = itemVO.mouseEnable ;
		}

		/**
		 * 鼠标移入
		 */		
		public function onMouseOver( ):void
		{
			if( item.filters==null || item.filters.length==0)
			{
				TweenMax.to(item, 0, {dropShadowFilter:{color:0xffcc00, alpha:1, blurX:3, blurY:3, strength:10}});
			}
		}
		
		override protected function addedToStage():void
		{
			itemContainer = new Sprite(); //装人模型，衣服，武器的容器
			content = new Sprite(); //装item，名称，状态图标等，包括了itemContainer
			addChild(content);
			content.addChild(itemContainer);
			itemContainer.addChild(item);
			
			direction = _direction ;
		}
		
		
		/**
		 * 鼠标移出 
		 */		
		public function onMouseOut( ):void
		{
			item.filters = null ;
		}
		
		/**
		 * 鼠标点击 
		 */		
		public function onMouseClick( ):void
		{
			SystemUtil.debug("点击"+this.name);
		}
		
		
		/**
		 * 根据当前位置和target位置，计算朝向 
		 * @param targetPoint 目标位置
		 * @param directions 是八方向还是四方向
		 */		
		public function setCurrentForward( targetPoint:Point , directions:int ):void 
		{
			//根据两点，获取人的朝向
			currPoint.x = this.x ;
			currPoint.y = this.y ;
			if(directions==5){
				this.direction = DirectionUtil.getDirection8(currPoint,targetPoint);
			}else if(directions==2){
				this.direction = DirectionUtil.getDirection4(currPoint,targetPoint);
			}
		}
		
		override public function dispose():void
		{
			currentAniComponent = null ;
			itemVO = null ;
			super.dispose() ;
		}
	}
}