package local.map.item
{
	import flash.geom.Point;
	
	import local.comm.GameData;
	import local.enum.ItemType;
	import local.enum.PickupType;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.cell.ItemBottomGrid;
	import local.map.cell.ItemObject;
	import local.map.pk.FlyLabelImage;
	import local.model.PlayerModel;
	import local.model.RoomItemsModel;
	import local.util.ResourceUtil;
	import local.vo.BitmapAnimResVO;
	import local.vo.ItemVO;
	
	public class BaseItem extends BaseMapObject
	{
		public static var cachePos:Point = new Point();
		
		public var itemVO:ItemVO ;
		public var bottom:ItemBottomGrid ; //底座
		protected var _itemObject:ItemObject ;
		public function get itemObject():ItemObject{
			return _itemObject;
		}
		
		public function BaseItem(itemVO:ItemVO )
		{
			super( itemVO.baseVO.xSpan , itemVO.baseVO.zSpan);
			this.itemVO = itemVO ;
			name = itemVO.name ;
			nodeX = itemVO.nodeX ;
			nodeZ = itemVO.nodeZ ;
		}
		
		public function recoverStatus():void
		{
			
		}
		
		override public function advanceTime(passedTime:Number):void
		{
			if(_itemObject) {
				_itemObject.advanceTime( passedTime );
			}
		}
		
		override public function showUI():void
		{
			var barvo:Vector.<BitmapAnimResVO> ;
			var itemOrGround:Boolean = !itemVO.baseVO.isWallLayer() ;
			if(itemVO.baseVO.directions==4) {
				var temp:int = itemVO.direction>2 ? itemVO.direction-2 : itemVO.direction;
				barvo = ResourceUtil.instance.getResVOByResId( name+"_"+temp ).resObject as  Vector.<BitmapAnimResVO> ;
				_itemObject = new ItemObject( name , barvo , itemOrGround );
			} else {
				barvo = ResourceUtil.instance.getResVOByResId( name ).resObject as  Vector.<BitmapAnimResVO> ;
				_itemObject = new ItemObject( name , barvo , itemOrGround );
				if( itemVO.direction==2) _itemObject.scaleX = 1;
				else _itemObject.scaleX = -1; 
			}
			addChildAt(_itemObject,0) ;
		}
		
		/**添加底座*/		
		public function drawBottomGrid():void
		{
			if(!bottom){
				bottom = new ItemBottomGrid(this);
				addChildAt(bottom,0);
				bottom.drawGrid();
				if(_itemObject){
					_itemObject.alpha = 0.6 ;
				}
			}
		}
		
		/** 移除底座*/
		public function removeBottomGrid():void
		{
			if(bottom) {
				bottom.dispose();
				if(bottom.parent){
					bottom.parent.removeChild(bottom);
				}
				bottom = null ;
				if(_itemObject){
					_itemObject.alpha = 1 ;
				}
			}
		}
		
		/**
		 * 收到收藏箱 
		 */		
		public function stash():void
		{
			this.dispose();
		}
		
		/**
		 * 售出 
		 */		
		public function sell():void
		{
			this.dispose();
		}
		
		public function onClick():void
		{
			var world:GameWorld = GameWorld.instance ;
			if(GameData.villageMode==VillageMode.EDIT){
				cachePos.x = nodeX;
				cachePos.y = nodeZ;
//				if(this is Road){
//					world.roadScene.removeRoad( this as Road );
//				}else{
//					world.buildingScene.removeBuilding( this );
//				}
//				world.topScene.addIsoObject( this );
//				world.roadScene.mouseChildren = world.buildingScene.mouseChildren = false ;
//				this.drawBottomGrid();
//				
//				var editorBtns:EditorBuildingButtons = EditorBuildingButtons.instance ;
//				addChild( editorBtns );
//				editorBtns.stashButton.enabled = editorBtns.rotateButton.enabled = editorBtns.sellButton.enabled = true ;
//				if( buildingVO.status==BuildingStatus.BUILDING){
//					editorBtns.stashButton.enabled = editorBtns.rotateButton.enabled = false ;
//				}else if( buildingVO.baseVO.type==BuildingType.DECORATION && 
//					(buildingVO.baseVO.subClass==BuildingType.DECORATION_GROUND || buildingVO.baseVO.subClass==BuildingType.DECORATION_ROAD) ){
//					editorBtns.rotateButton.enabled = false ;
//				}
				
			}
		}
		
		override public function set nodeX(value:int):void{
			super.nodeX = value ;
			itemVO.nodeX = value ;
		}
		override public function set nodeZ(value:int):void{
			super.nodeZ = value ;
			itemVO.nodeZ = value ;
		}
		
		/**
		 * 从收藏箱中添加到游戏世界中 
		 */		
		public function storageToWorld():void
		{
		}
		
		/**
		 * 从商店中添加到世界中
		 */		
		public function shopToWorld():void
		{
			//减钱
			var flyImg:FlyLabelImage ;
			if( itemVO.baseVO.costCash>0 ){
				PlayerModel.instance.changeCash( -itemVO.baseVO.costCash );
				flyImg = new FlyLabelImage( PickupType.CASH , -itemVO.baseVO.costCash ) ;
			}else if(itemVO.baseVO.costCoin>0 ){
				PlayerModel.instance.changeCoin( -itemVO.baseVO.costCoin );
				flyImg = new FlyLabelImage( PickupType.COIN , -itemVO.baseVO.costCoin ) ;
			}
			if(flyImg){
				flyImg.x = screenX ;
				flyImg.y = screenY-20 ;
				GameWorld.instance.effectScene.addChild( flyImg );
			}
			//添加到地图上
			addToWorldFromTopScene();
			//添加到房间数据中
			RoomItemsModel.instance.addItemVO( itemVO );
		}
		
		/**
		 * 从topScene添加到场景上 
		 */		
		public function addToWorldFromTopScene():void
		{
			var world:GameWorld = GameWorld.instance ;
			world.topScene.removeIsoObject( this );
			switch( itemVO.baseVO.type)
			{
				case ItemType.FLOOR:
					world.floorScene.addItem( this as Floor);
					break ;
				case ItemType.WALL_DECOR:
					world.wallDecorScene.addItem( this as WallDecor);
					break ;
				case ItemType.WALL_PAPER:
					world.wallPaperScene.addItem( this as WallPaper);
					break ;
				default:
					world.roomScene.addItem( this);
					break ;
			}	
			world.roomScene.touchable = true ;
			this.removeBottomGrid();
		}
		
		/**
		 * 旋转 
		 */		
		public function rotate():void
		{
			var barvo:Vector.<BitmapAnimResVO> ;
			var itemOrGround:Boolean = !itemVO.baseVO.isWallLayer() ;
			
			if(itemVO.baseVO.directions==4) {
				itemVO.direction++;
				if(itemVO.direction>4) itemVO.direction=1 ;
				
				var temp:int = itemVO.direction>2 ? itemVO.direction-2 : itemVO.direction;
				barvo = ResourceUtil.instance.getResVOByResId( name+"_"+temp ).resObject as  Vector.<BitmapAnimResVO> ;
				_itemObject.updateUI( name , barvo , itemOrGround );
				
				if( temp==2) _itemObject.scaleX = 1;
				else _itemObject.scaleX = -1; 
			} 
			else if( itemVO.baseVO.directions==2)
			{
				itemVO.direction++;
				if(itemVO.direction>3) itemVO.direction=2 ;
				
				if( itemVO.direction==2) _itemObject.scaleX = 1;
				else _itemObject.scaleX = -1; 
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_itemObject) _itemObject.dispose();
			if(bottom)  bottom.dispose();
			_itemObject = null ;
			bottom = null ;
		}
	}
}