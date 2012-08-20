package bing.map.layer
{
	import bing.map.data.Comm;
	import bing.map.data.MapData;
	import bing.map.model.Rhombus;
	import bing.map.utils.MapUtils;
	
	import flash.geom.Point;

	/**
	 * 遮罩层设置 
	 * @author zhouzhanglin
	 */	
	public class MaskLayer
	{
		/**
		 * 初始化遮罩层数据 
		 */		
		public function initMaskLayer():void{
			for(var i:int = 0; i<MapData.xNum ; i++){
				MapData.maskArray[i] = new Array();
			}
		}
		
		/**
		 * 向地图上添加遮罩块 
		 */		
		public function addMaskOnMap():void{
			var temp:String=Comm.mainApp.mouseInfo._ix+"-"+Comm.mainApp.mouseInfo._iy; //地图坐标索引
			//此处并没有碰撞块，就可以添加遮罩块了
			if(Comm.mainApp.dragUI.getChildAt(0)!=null&&( MapData.impactArray[temp]==undefined || MapData.impactArray[temp]==false )){
				//如果已经有遮罩块了就不能再添加了，没有才能添加遮罩块
				if(MapData.maskArray[temp]==undefined || MapData.maskArray[temp]==false){
					MapData.maskArray[temp]=true;//将此处设置为遮罩块
					//创建菱形
					var rhombus:Rhombus = new Rhombus(0xff0000,0xff0000);
					rhombus.alpha=.5;
					Comm.mainApp.maskContainer.addChild(rhombus);
					rhombus.x = Comm.mainApp.dragUI.x;
					rhombus.y = Comm.mainApp.dragUI.y ;
				}
				
			}
		}
		
		
		/**
		 * 删除遮罩块 
		 */		
		public function deleteMaskOnMap():void{
			var temp:String=Comm.mainApp.mouseInfo._ix+"-"+Comm.mainApp.mouseInfo._iy; //地图坐标索引
			//如果有遮罩块才能删除
			if(MapData.maskArray[temp]!=null && MapData.maskArray[temp]==true){
				var mousePixel:Point = MapUtils.getPixelPoint( int(Comm.mainApp.mouseInfo._ix) ,int(Comm.mainApp.mouseInfo._iy));
				mousePixel.x-=MapData.tileWidth;//偏移量
				mousePixel.y-=MapData.tileHeight;
				var index:int = MapUtils.getIndexByPoint(Comm.mainApp.maskContainer,mousePixel);//此对象的索引
				if(index>-1){
					//从界面上删除菱形
					Comm.mainApp.maskContainer.removeChildAt(index);
					MapData.maskArray[temp]=false;//将此处设置为碰撞块
				}
			}
		}
		
		/**
		 * 刷新显示 
		 */		
		public function refresh():void{
			for(var i:int = 0; i<MapData.xNum ; i++ ){
				for(var j:int = 0; j<MapData.yNum*2+1 ; j++ ){
					var bool:Boolean = MapData.maskArray[i+"-"+j] ;
					if(bool==true){
						//创建菱形
						var rhombus:Rhombus = new Rhombus(0xff0000,0xff0000);
						rhombus.alpha=.5;
						Comm.mainApp.maskContainer.addChild(rhombus);
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
			while(Comm.mainApp.maskContainer.numChildren>0){
				Comm.mainApp.maskContainer.removeChildAt(0);
			}
		}
	}
}