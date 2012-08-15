package game.mvc.view
{
	import com.riaidea.text.RichTextField;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import game.elements.ground.Block;
	import game.elements.items.interfaces.IFight;
	import game.events.ChangeMapEvent;
	import game.global.GameData;
	import game.mvc.base.GameMediator;
	import game.mvc.model.MapDataModel;
	import game.mvc.model.MapItemsModel;
	import game.mvc.model.vo.MapVO;
	import game.mvc.view.bar.ShowChatBar;
	
	public class GameLayerMediator extends GameMediator
	{
		private var _moveLayerTime:int ;
		private var _mapVO:MapVO;
		
		public function get gameLayer():GameLayer
		{
			return view as GameLayer ;
		}
		
		public function GameLayerMediator(view:DisplayObjectContainer)
		{
			super(view);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			this.addContextListener( ChangeMapEvent.CHANGE_MAP_START , changeMapStartHandler );
			this.addContextListener( ChangeMapEvent.CHANGE_MAP_OVER , changeMapOverHandler );
		}
		
		//切换地图开始
		private function changeMapStartHandler( e:ChangeMapEvent ):void 
		{
			_mapVO = null ; 
			gameLayer.visible = false ;
			view.stage.removeEventListener(MouseEvent.CLICK , mouseClickHandler );
		}
		
		//切换地图完成
		private function changeMapOverHandler(e:ChangeMapEvent):void 
		{
			_mapVO =  MapDataModel.instance.currentMapVO ;
			view.stage.addEventListener(MouseEvent.CLICK , mouseClickHandler );
			setTimeout( showGameLayer , 200 );
		}
		//延迟显示游戏场景
		private function showGameLayer():void 
		{
			moveLayer(false);
			gameLayer.visible = true ; 
		}
		
		//鼠标点击地面
		private function mouseClickHandler(e:MouseEvent):void
		{
			e.stopPropagation();
			if(!GameData.hero) return ;
			
			var px:Number= e.stageX-view.x ;
			var py:Number = e.stageY -view.y ;
			var moveAble:Boolean=false ;
			if(e.target is GameLayer )
			{
				moveAble = true ;
				if(MapItemsModel.instance.mouseOverItem)
				{
					moveAble = false ;
					MapItemsModel.instance.mouseOverItem.onMouseClick();
					GameData.hero.stopMove();
					GameData.hero.setCurrentForward( new Point(px,py) , 5 );
					if( MapItemsModel.instance.mouseOverItem is IFight)
					{
						GameData.hero.setCurrentForward( new Point(px,py) , 2 );
						GameData.hero.magic(1,MapItemsModel.instance.mouseOverItem);
					}
				}
			}
			else if(e.target.parent)
			{
				if( e.target.parent is RichTextField && e.target.parent.parent && e.target.parent.parent is ShowChatBar)
				{
					moveAble = true ;
				}
			}
			if(moveAble && this.checkMouseRegion(px,py)){
				GameData.hero.findAndMove( px,py );
			}
		}
		
		//鼠标点击应该在合理的范围内
		private function checkMouseRegion(px:Number,py:Number):Boolean
		{
			if(px<_mapVO.tileWidth || py<_mapVO.tileHeight){
				return false ;
			}
			if( px>_mapVO.mapWidth-_mapVO.tileWidth || py>_mapVO.mapHeight-_mapVO.tileHeight)
			{
				return false ;
			}
			return true ;
		}
		
		//不断更新
		public function updateHandler( ):void
		{
			if(GameData.hero && MapDataModel.instance.currentMapVO )
			{
				moveLayer();
				if(MapDataModel.instance.currentMapVO.segmentation){
					updateGroundBlocks();
				}
			}
		}
		
		//移动当前层
		private function moveLayer( isTween:Boolean=true ):void 
		{
			//更新场景的位置，使英雄在场景中间
			var offsetX:Number = contextView.stage.stageWidth*0.5 - GameData.hero.x ;
			var offsetY:Number =  contextView.stage.stageHeight*0.5 - GameData.hero.y;
			
			if(offsetX<contextView.stage.stageWidth- _mapVO.mapWidth){
				offsetX = contextView.stage.stageWidth- _mapVO.mapWidth ;
			}else if(offsetX>0)	{
				offsetX = 0 ;
			}
			if(offsetY<contextView.stage.stageHeight- _mapVO.mapHeight){
				offsetY =contextView.stage.stageHeight- _mapVO.mapHeight ;
			}else if(offsetY>0)	{
				offsetY = 0 ;
			}
			
			if(isTween){
				view.x += ((offsetX-view.x)*0.04)>>0 ;
				view.y += ((offsetY-view.y)*0.04)>>0 ;
			}else{
				view.x =offsetX;
				view.y =offsetY;
			}
			//当前屏幕位置
			GameData.screenRect.x = -view.x ;
			GameData.screenRect.y = -view.y ;
			GameData.screenRect.width = contextView.stage.stageWidth ;
			GameData.screenRect.height = contextView.stage.stageHeight ;
			
		}
		
		//地图为多个块
		private function  updateGroundBlocks():void 
		{
			for each(var block:Block in MapDataModel.instance.mapBlocks)
			{
				if(block.rect.intersects(GameData.screenRect)){
					block.init();
					block.visible=true ;
				}else{
					block.visible=false ;
				}
			}
			/*
			//另外一种方式
			var mapVO:MapVO =  MapDataModel.instance.currentMapVO ;
			
			var min_X:int = ( GameData.screenRect.x/mapVO.segW)>>0 ;
			var min_Y:int = ( GameData.screenRect.y/mapVO.segH)>>0  ;
			
			var max_X:int = ( (GameData.screenRect.x+GameData.screenRect.width)/mapVO.segW)>>0 ;
			var max_Y:int = ( (GameData.screenRect.y+GameData.screenRect.height)/mapVO.segH)>>0;
			for(var i:int = min_X-1 ; i<max_X+1 ; i++ ){
				for (var j:int = min_Y-1 ; j<max_Y+1 ; j++  ){
					if(i>=0 && j>=0 && i<=mapVO.segCol && j<=mapVO.segRow)
					{
						block = MapDataModel.instance.mapBlocksHash.getValue(j+"-"+i) as Block;
						if(block){
							block.init();
						}
						gameLayer.groundLayer.addChild( block );
					}
				}
			}
			*/
		}
	}
}