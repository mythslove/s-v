package local.map.item
{
	import local.comm.GameSetting;
	import local.map.cell.BuildingBottomGrid;
	import local.map.cell.BuildingObject;
	import local.map.cell.RoadObject;
	import local.util.ResourceUtil;
	import local.vo.BitmapAnimResVO;
	import local.vo.BuildingVO;

	public class BaseBuilding extends BaseMapObject
	{
		protected var _buildingObject:BuildingObject ;
		protected var _roadObject:RoadObject ;
		public var buildingVO:BuildingVO ;
		public var bottom:BuildingBottomGrid; //底座
		
		public function BaseBuilding(buildingVO:BuildingVO )
		{
			super(GameSetting.GRID_SIZE,buildingVO.baseVO.span , buildingVO.baseVO.span);
			this.buildingVO = buildingVO ;
			name = buildingVO.name ;
			nodeX = buildingVO.nodeX ;
			nodeZ = buildingVO.nodeZ ;
		}
		
		override public function update():void
		{
			if(_buildingObject) {
				_buildingObject.update() ;
			}
		}
		
		override public function showUI():void
		{
			var barvo:Vector.<BitmapAnimResVO> = ResourceUtil.instance.getResVOByResId( name ).resObject as  Vector.<BitmapAnimResVO> ;
			_buildingObject = new BuildingObject( name , barvo);
			addChildAt(_buildingObject,0)
			this.scaleX = buildingVO.rotation ;
		}
		
		/**添加底座*/		
		public function drawBottomGrid():void
		{
			if(!bottom){
				bottom = new BuildingBottomGrid(this);
				addChildAt(bottom,0);
				bottom.drawGrid();
				if(_buildingObject){
					_buildingObject.y -= GameSetting.GRID_SIZE*0.25 ;
					_buildingObject.alpha = 0.6 ;
				}else if( _roadObject){
					_roadObject.y -= GameSetting.GRID_SIZE*0.25 ;
					_roadObject.alpha = 0.6 ;
				}/*else if(_buildStatusObj){
					_buildStatusObj.y -= GameSetting.GRID_SIZE*0.25 ;
					_buildStatusObj.alpha = 0.6 ;
				}*/
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
				if(_buildingObject){
					_buildingObject.y += GameSetting.GRID_SIZE*0.25 ;
					_buildingObject.alpha = 1 ;
				}else if( _roadObject){
					_roadObject.y += GameSetting.GRID_SIZE*0.25 ;
					_roadObject.alpha = 1 ;
				}/*else if(_buildStatusObj){
					_buildStatusObj.y += GameSetting.GRID_SIZE*0.25 ;
					_buildStatusObj.alpha =1 ;
				}*/
			}
		}
		
		/**
		 * 闪烁 
		 * @param value
		 */		
		public function flash( value:Boolean):void
		{
			if(_buildingObject) {
				_buildingObject.flash( value );
			}
		}

		public function onClick():void
		{
			
		}
		
		override public function set scaleX(value:Number):void
		{
			_buildingObject.scaleX = value ;
			this.buildingVO.rotation = value ;
		}
		
		override public function get scaleX():Number
		{
			return _buildingObject.scaleX ;
		}
		
		override public function set nodeX(value:int):void{
			super.nodeX = value ;
			buildingVO.nodeX = value ;
		}
		override public function set nodeZ(value:int):void{
			super.nodeZ = value ;
			buildingVO.nodeZ = value ;
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_buildingObject) _buildingObject.dispose();
			_buildingObject = null ;
		}
	}
}