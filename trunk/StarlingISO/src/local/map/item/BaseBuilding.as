package local.map.item
{
	import local.comm.GameSetting;
	import local.map.cell.BuildingObject;
	import local.util.ResourceUtil;
	import local.vo.BitmapAnimResVO;
	import local.vo.BuildingVO;

	public class BaseBuilding extends BaseMapObject
	{
		protected var _buildingObject:BuildingObject ;
		public var buildingVO:BuildingVO ;
		
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