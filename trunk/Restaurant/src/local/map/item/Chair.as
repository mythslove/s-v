package local.map.item
{
	import local.enum.ItemType;
	import local.model.MapGridDataModel;
	import local.vo.ItemVO;
	
	public class Chair extends BaseItem
	{
		public var nearTable:Table ;
		public var hasGuest:Boolean ; //是否已经有客人坐上去了
		
		public function Chair(itemVO:ItemVO)
		{
			super(itemVO);
		}
		
		override public function addToWorldFromTopScene():void{
			super.addToWorldFromTopScene();
			autoDirectionByTable();
		}
		
		/**
		 * 清除临时数据 
		 */		
		public function clearTempData():void{
			nearTable = null ;
			hasGuest = false ;
		}
		
		public function autoDirectionByTable():void
		{
			var tables:Vector.<BaseItem> = MapGridDataModel.instance.getNearRoomItemByType( this , ItemType.TABLE ) ;
			if(tables && tables.length>0)
			{
				nearTable =tables[0]  as Table;
				if(nearTable)
				{
					var direction:int ;
					if(nearTable.nodeZ==nodeZ && nearTable.nodeX+1 == nodeX){//左上
						direction = 4 ; //方向为4
					}else if(nearTable.nodeZ==nodeZ && nearTable.nodeX-1 == nodeX){ //右下
						direction = 2 ; //方向为2
					}else if(nearTable.nodeX==nodeX && nearTable.nodeZ+1 == nodeZ){ //右上
						direction = 1 ; //方向为1
					}else{
						direction = 3 ; //方向为3
					}
					if(itemVO.direction!=direction){
						itemVO.direction = direction ;
						rototeToDirection();
					}
				}
			}
		}
		
		
		public function addCharacter( character:Character ):void
		{
			_itemObject.addItem( character ,false);
		}
 			
		
		override public function dispose():void
		{
			super.dispose();
			nearTable = null ;
		}
	}
}