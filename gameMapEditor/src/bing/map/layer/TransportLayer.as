package bing.map.layer
{
	import bing.map.data.Comm;
	import bing.map.data.MapData;
	import bing.map.model.Circle;
	import bing.map.model.Transport;
	import bing.map.utils.MapUtils;
	
	import flash.geom.Point;

	public class TransportLayer
	{
		/**
		 * 添加传输区 
		 */		
		public function addTransOnMap():void {
			var temp:String=Comm.mainApp.mouseInfo._ix+"-"+Comm.mainApp.mouseInfo._iy; //地图坐标索引
			//如果当前没有设置传输区，则设置
			if(Comm.mainApp.dragUI.getChildAt(0)!=null ){
				var trans:Transport = this.checkTransExists(temp ) ;
				if(trans != null ){ //如果此坐标位置已经设置了传输区
					//显示此传输区配置信息
					Comm.mainApp.transPanel.showSet( trans );
				}else {
					trans = new Transport(temp , false) ;
					MapData.transportVector.push( trans );
					var cirlce:Circle = new Circle(0x00FFFF, 0x00FF00);
					cirlce.alpha=.7;
					Comm.mainApp.transportContainer.addChild( cirlce );
					cirlce.x = Comm.mainApp.dragUI.x ;
					cirlce.y = Comm.mainApp.dragUI.y ;
					//显示此传输区配置信息
					Comm.mainApp.transPanel.showSet( trans );
				}
				
			}
		}
		
		/**
		 * 判断是否已经设置了这个坐标的传输区了 
		 * @param temp 地图坐标，格式x-y
		 * @return  此传输区对象，没有返回空
		 */		
		public function checkTransExists( temp:String ):Transport{
			var len:int = MapData.transportVector.length ;
			for( var i:int = 0 ; i<len ; i++){
				if( MapData.transportVector[i].tempLoc == temp ){
					return MapData.transportVector[i] ;
				}
			}
			return null ;
		}
		
		/**
		 * 删除地图 
		 */		
		public function deleteTransOnMap():void {
			var temp:String=Comm.mainApp.mouseInfo._ix+"-"+Comm.mainApp.mouseInfo._iy; //地图坐标索引
			if(this.checkTransExists(temp) != null ){
				var len:int = MapData.transportVector.length ;
				for( var i:int = 0 ; i<len ; i++){
					if( MapData.transportVector[i].tempLoc == temp ){
						Comm.mainApp.transportContainer.removeChildAt(i);
						MapData.transportVector.splice( i , 1);
						return ;
					}
				}
			}
		}
		
		/**
		 * 清空显示 
		 */		
		public function clearShow():void {
			while(Comm.mainApp.transportContainer.numChildren>0){
				Comm.mainApp.transportContainer.removeChildAt(0);
			}
		}
		
		/**
		 * 刷新显示 
		 */		
		public function refresh():void {
			for each(var trans:Transport in MapData.transportVector){
				var cirlce:Circle = new Circle(0x00FFFF, 0x00FF00);
				cirlce.alpha=.7;
				var xx:int =parseInt( trans.tempLoc.substring( 0 , trans.tempLoc.indexOf("-")) );
				var yy:int =parseInt( trans.tempLoc.substring( trans.tempLoc.indexOf("-")+1) );
				var loc:Point = MapUtils.getPixelPoint(xx,yy);
				cirlce.x = loc.x-MapData.tileWidth*0.5 ;
				cirlce.y = loc.y -MapData.tileHeight*0.5;
				Comm.mainApp.transportContainer.addChild( cirlce );
			}
		}
	}
}