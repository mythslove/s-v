package bing.map.layer
{
	import bing.map.data.Comm;
	import bing.map.data.MapData;
	import bing.map.model.Rhombus;
	import bing.map.utils.MapUtils;
	
	import flash.geom.Point;

	/**
	 * 碰撞层设置 
	 * @author zhouzhanglin
	 */	
	public class ImpactLayer
	{
		/**
		 * 构造 
		 */		
		public function initImpactLayer():void {
			for(var i:int = 0; i<MapData.xNum ; i++){
				MapData.impactArray[i] = new Array();
			}
		}
		
		
		/**
		 * 向地图上添加碰撞块 
		 */		
		public function addImpactOnMap():void{
			var temp:String=Comm.mainApp.mouseInfo._ix+"-"+Comm.mainApp.mouseInfo._iy; //地图坐标索引
			//此处并没有遮罩块，就可以添加碰撞块了
			if(Comm.mainApp.dragUI.getChildAt(0)!=null&& ( MapData.maskArray[temp]==null || MapData.maskArray[temp]==false ) ){
				//如果已经有碰撞块了就不能再添加了，没有才能添加碰撞块
				if(MapData.impactArray[temp]==null || MapData.impactArray[temp]==false){
					MapData.impactArray[temp]=true;//将此处设置为碰撞块
					//创建菱形
					var rhombus:Rhombus = new Rhombus(0x000000,0x000000);
					rhombus.alpha=.5;
					Comm.mainApp.impactContainer.addChild(rhombus);
					rhombus.x = Comm.mainApp.dragUI.x;
					rhombus.y = Comm.mainApp.dragUI.y ;
				}
				
			}
		}
		
		/**
		 * 删除碰撞块 
		 */		
		public function deleteImpactOnMap():void{
			var temp:String=Comm.mainApp.mouseInfo._ix+"-"+Comm.mainApp.mouseInfo._iy; //地图坐标索引
			//如果有碰撞块才能删除
			if(MapData.impactArray[temp]!=null && MapData.impactArray[temp]==true){
				var mousePixel:Point = MapUtils.getPixelPoint( int(Comm.mainApp.mouseInfo._ix), int(Comm.mainApp.mouseInfo._iy) );
				mousePixel.x-=MapData.tileWidth;//偏移量
				mousePixel.y-=MapData.tileHeight;
				var index:int = MapUtils.getIndexByPoint(Comm.mainApp.impactContainer,mousePixel);//此对象的索引
				if(index>-1){
					//从界面上删除菱形
					Comm.mainApp.impactContainer.removeChildAt(index);
					MapData.impactArray[temp]=false;//将此处设置为碰撞块
				}
			}
		}
		
		/**
		 * 刷新显示 
		 */		
		public function refresh():void{
			for(var i:int = 0; i<MapData.xNum ; i++ ){
				for(var j:int = 0; j<MapData.yNum*2+1 ; j++ ){
					if(MapData.impactArray[i+"-"+j]== null ){
						continue;
					}
					var bool:Boolean = MapData.impactArray[i+"-"+j] ;
					if(bool==true){
						//创建菱形
						var rhombus:Rhombus = new Rhombus(0x000000,0x000000);
						rhombus.alpha=.5;
						Comm.mainApp.impactContainer.addChild(rhombus);
						if( j%2!=0){
							rhombus.x =  i* MapData.tileWidth;
							rhombus.y =  j * MapData.tileHeight*0.5-MapData.tileHeight*0.5;
						}else{
							rhombus.x = i* MapData.tileWidth-MapData.tileWidth*0.5;
							rhombus.y =  j * MapData.tileHeight*0.5-MapData.tileHeight*0.5;
						}
					}
				}
			}
		}
		/**
		 * 清空显示 
		 */		
		public function clearShow():void{
			while(Comm.mainApp.impactContainer.numChildren>0){
				Comm.mainApp.impactContainer.removeChildAt(0);
			}
		}
	}
}