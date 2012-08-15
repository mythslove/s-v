package bing.map.layer
{
	import bing.map.data.Comm;
	import bing.map.data.MapData;
	import bing.map.data.ResourceData;
	import bing.map.model.Npc;
	import bing.map.utils.MapUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import mx.rpc.events.HeaderEvent;

	/**
	 *NPC层
	 * @author zhouzhanglin
	 */	
	public class NPCLayer
	{
		/**
		 *  向舞台上添加Npc图片，并将此Npc图片，放入数组中
		 */		
		public function addNpcOnMap():void{
			if(Comm.mainApp.dragUI.getChildAt(0)!=null){
				var srcbmp:Bitmap =  Comm.mainApp.dragUI.getChildAt(0) as Bitmap ;
				var npc :Bitmap =new Bitmap (srcbmp.bitmapData );
				var id:String = srcbmp.name ; 
				var loc:Point = new Point( Number(Comm.mainApp.mouseInfo._ix), Number(Comm.mainApp.mouseInfo._iy) );
				MapData.npcVector.push(new Npc(id,loc) ); //向数组中添加
				Comm.mainApp.npcContainer.addChild(npc); //向舞台上添加建筑
				npc.x = Comm.mainApp.dragUI.x;
				npc.y = Comm.mainApp.dragUI.y ;
			}
		}
		/**
		 * 删除Npc
		 */		
		public function deleteNpcOnMap(e:MouseEvent):void{
			if(MapData.npcVector.length==0){
				return;
			}
			//当前mouse的位置
			var mouseLoc:Point = new Point( Number(Comm.mainApp.mouseInfo._px), Number(Comm.mainApp.mouseInfo._py) );
			
			//循环npc，判断哪个npc与此点相交
			var len:int = Comm.mainApp.npcContainer.numChildren ;
			var index:int = -1;
			for(var i:int = len-1 ; i >=0 ; i--){
				var npc:DisplayObject = Comm.mainApp.npcContainer.getChildAt(i) ;
				var npcRect:Rectangle = new Rectangle(npc.x,npc.y,npc.width,npc.height);
				if(npcRect.contains(mouseLoc.x,mouseLoc.y)){
					index = i; 
					break ;
				}
			}
			if(index>-1){ //从数组中找到图片
				//从数组中移除此建筑
				MapData.npcVector.splice(index,1);
				//从界面上移除
				Comm.mainApp.npcContainer.removeChildAt(index);
			}
		}
		
		/**
		 *  调用设置npc属性的面板
		 */		
		public function setNpcInfo():void 
		{
			if(MapData.npcVector.length==0){
				return;
			}
			//当前mouse的位置
			var mouseLoc:Point = new Point( Number(Comm.mainApp.mouseInfo._px) , Number(Comm.mainApp.mouseInfo._py) );
			
			//循环npc，判断哪个npc与此点相交
			var len:int = Comm.mainApp.npcContainer.numChildren ;
			var index:int = -1;
			for(var i:int = len-1 ; i >=0 ; i--){
				var npcObj:DisplayObject = Comm.mainApp.npcContainer.getChildAt(i) ;
				var npcRect:Rectangle = new Rectangle(npcObj.x,npcObj.y,npcObj.width,npcObj.height);
				if(npcRect.contains(mouseLoc.x,mouseLoc.y)){
					index = i; 
					break ;
				}
			}
			if(index>-1){ 
				Comm.mainApp.npcPanel.currentState = "State2";
				var npc:Npc = MapData.npcVector[index]; //当前选中的npc
				Comm.mainApp.npcPanel.selectedNpc = npc ;
				Comm.mainApp.npcPanel.npcId.text = npc.id ;
			}
		}
		
		/**
		 * 刷新显示 
		 */		
		public function refresh():void{
			for each( var npc:Npc in MapData.npcVector ){
				var bitmap:Bitmap = new Bitmap(MapData.npcDic[npc.id]);
				Comm.mainApp.npcContainer.addChild(bitmap); //向舞台上添加npc
				var loc:Point = MapUtils.getPixelPoint(npc.location.x,npc.location.y);
				bitmap.x = loc.x ;
				bitmap.y = loc.y ;
			}
		}

		
		/**
		 * 清空显示 
		 */		
		public function clearShow():void{
			while(Comm.mainApp.npcContainer.numChildren>0){
				Comm.mainApp.npcContainer.removeChildAt(0);
			}
		}
	}
}