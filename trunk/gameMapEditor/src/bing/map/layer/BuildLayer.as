package bing.map.layer
{
	import bing.map.data.Comm;
	import bing.map.data.MapData;
	import bing.map.data.ResourceData;
	import bing.map.model.Builder;
	import bing.map.utils.MapUtils;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;

	/**
	 * 建筑层 
	 * @author zhouzhanglin
	 */	
	public class BuildLayer extends EventDispatcher
	{
		/**
		 *  向舞台上添加建筑图片，并将此建筑图片，放入数组中
		 */		
		public function addBuilderOnMap():void{
			if(Comm.mainApp.dragUI.getChildAt(0)!=null){
				var srcbmp:Bitmap =  Comm.mainApp.dragUI.getChildAt(0) as Bitmap ;
				var builder:Bitmap =new Bitmap (srcbmp.bitmapData );
				var builderId:String = srcbmp.name ; 
				var loc:Point = new Point(Number(Comm.mainApp.mouseInfo._ix),Number(Comm.mainApp.mouseInfo._iy));
				MapData.builderVector.push(new Builder(builderId,loc) ); //向数组中添加
				Comm.mainApp.buildContainer.addChild(builder); //向舞台上添加建筑
				builder.x = Comm.mainApp.dragUI.x;
				builder.y = Comm.mainApp.dragUI.y ;
			}
		}
		/**
		 * 删除建筑 
		 */		
		public function deleteBuilderOnMap(e:MouseEvent):void{
			if(MapData.builderVector.length==0){
				return;
			}
			//当前mouse的位置
			var mouseLoc:Point = new Point(Number(Comm.mainApp.mouseInfo._px),Number(Comm.mainApp.mouseInfo._py));
			
			//循环建筑，判断哪个建筑与此点相交
			var len:int = Comm.mainApp.buildContainer.numChildren ;
			var index:int = -1;
			for(var i:int = len-1 ; i >=0 ; i--){
				var builder:DisplayObject = Comm.mainApp.buildContainer.getChildAt(i) ;
				var builderRect:Rectangle = new Rectangle(builder.x,builder.y,builder.width,builder.height);
				if(builderRect.contains(mouseLoc.x,mouseLoc.y)){
					index = i; 
					break ;
				}
			}
			if(index>-1){ //从数组中找到图片
				//从数组中移除此建筑
				MapData.builderVector.splice(index,1);
				//从界面上移除
				Comm.mainApp.buildContainer.removeChildAt(index);
			}
		}
		
		/**
		 * 刷新显示 
		 */		
		public function refresh():void{
			for each( var build:Builder in MapData.builderVector ){
				var loader:Loader = new Loader();
				var path:String = ResourceData.getBuildPathByTypeIdAndId(build.id)  ;
				if(path!=""){
					loader.load(new URLRequest( path ) );
					Comm.mainApp.buildContainer.addChild(loader); //向舞台上添加建筑
					var loc:Point = MapUtils.getPixelPoint(build.location.x,build.location.y);
					loader.x = loc.x ;
					loader.y = loc.y ;
				}
				
			}
			
		}
		
		/**
		 * 清空显示 
		 */		
		public function clearShow():void{
			while(Comm.mainApp.buildContainer.numChildren>0){
				Comm.mainApp.buildContainer.removeChildAt(0);
			}
		}
	}
}