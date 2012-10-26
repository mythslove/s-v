package local.map.item
{
	import flash.geom.Point;
	
	import local.enum.ItemType;
	import local.map.cell.ItemObject;
	import local.util.ResourceUtil;
	import local.vo.BitmapAnimResVO;
	import local.vo.ItemVO;
	
	public class BaseItem extends BaseMapObject
	{
		public static var cachePos:Point = new Point();
		
		protected var _itemObject:ItemObject ;
		public var itemVO:ItemVO ;
		
		public function BaseItem(itemVO:ItemVO )
		{
			super( itemVO.baseVO.xSpan , itemVO.baseVO.zSpan);
			this.itemVO = itemVO ;
			name = itemVO.name ;
			nodeX = itemVO.nodeX ;
			nodeZ = itemVO.nodeZ ;
		}
		
		override public function advanceTime(passedTime:Number):void
		{
			if(_itemObject) {
				_itemObject.advanceTime( passedTime );
			}
		}
		
		override public function showUI():void
		{
			var barvo:Vector.<BitmapAnimResVO> = ResourceUtil.instance.getResVOByResId( name ).resObject as  Vector.<BitmapAnimResVO> ;
			
			var itemOrGround:Boolean = true ;
			if(itemVO.baseVO.type==ItemType.WALL_DECOR || itemVO.baseVO.type==ItemType.WALL_PAPER || itemVO.baseVO.type==ItemType.FLOOR
				||itemVO.baseVO.type==ItemType.WALL){
				itemOrGround = false ;
			}
			_itemObject = new ItemObject( name , barvo , itemOrGround );
			addChildAt(_itemObject,0)
			this.scaleX = itemVO.rotation ;
		}
		
		/**添加底座*/		
		public function drawBottomGrid():void
		{
//			if(!bottom){
//				bottom = new BuildingBottomGrid(this);
//				addChildAt(bottom,0);
//				bottom.drawGrid();
//				if(_itemObject){
//					_itemObject.y -= GameSetting.GRID_SIZE*0.25 ;
//					_itemObject.alpha = 0.6 ;
//				}else if( _roadObject){
//					_roadObject.y -= GameSetting.GRID_SIZE*0.25 ;
//					_roadObject.alpha = 0.6 ;
//				}else if(_buildStatusObj){
//					_buildStatusObj.y -= GameSetting.GRID_SIZE*0.25 ;
//					_buildStatusObj.alpha = 0.6 ;
//				}
//			}
		}
		
		/** 移除底座*/
		public function removeBottomGrid():void
		{
//			if(bottom) {
//				bottom.dispose();
//				if(bottom.parent){
//					bottom.parent.removeChild(bottom);
//				}
//				bottom = null ;
//				if(_itemObject){
//					_itemObject.y += GameSetting.GRID_SIZE*0.25 ;
//					_itemObject.alpha = 1 ;
//				}else if( _roadObject){
//					_roadObject.y += GameSetting.GRID_SIZE*0.25 ;
//					_roadObject.alpha = 1 ;
//				}else if(_buildStatusObj){
//					_buildStatusObj.y += GameSetting.GRID_SIZE*0.25 ;
//					_buildStatusObj.alpha =1 ;
//				}
//			}
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
		}
		
		/**
		 * 从topScene添加到场景上 
		 */		
		public function addToWorldFromTopScene():void
		{
		}
		
		
		override public function dispose():void
		{
			super.dispose();
			if(_itemObject) _itemObject.dispose();
			_itemObject = null ;
		}
	}
}