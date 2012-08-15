package bing.map.utils
{
	import bing.map.data.MapData;
	import bing.map.model.Builder;
	import bing.map.model.Npc;
	import bing.map.model.Transport;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.graphics.codec.JPEGEncoder;

	/**
	 * 保存地图数据 
	 * @author zhouzhanglin
	 */	
	public class DataSave extends EventDispatcher
	{
		private var _fs:FileStream = null ;
		private var _buildFile:File = null ;//建筑数据
		private var _npcFile:File = null ;//NPC数据
		private var _impactFile:File = null ;//碰撞块数据
		private var _maskFile:File = null ;//遮罩块数据
		private var _groundDir:File = null ;//地表块保存的文件夹
		private var _saveBlock:Boolean = false ;//地表分块保存
		/**
		 * 构造函数 
		 */		 
		public function DataSave( saveBlock:Boolean ){
			this._saveBlock = saveBlock ;
			if(MapData.mapDirectory==null){
				MapData.mapDirectory = new File();
				//创建一个文件夹
				MapData.mapDirectory.browseForDirectory("选择保存位置");
				MapData.mapDirectory.addEventListener(Event.SELECT , selectedDir);
			}else{
				saveBuildData();
			}
		}
		/** 选择了文件夹  */
		private function selectedDir(e:Event):void{
			saveBuildData();
		}
		//============================
		/**
		 * 保存建筑数据 
		 */		
		private function saveBuildData():void{
			_buildFile = new File(MapData.mapDirectory.nativePath+"/"+MapData.mapName+"/build.bing");
			if(_buildFile.exists){
				_buildFile.deleteFile();
			}
			_fs = new FileStream();
			_fs.open(_buildFile,FileMode.WRITE);
			
			try{
				_fs.writeShort(MapData.builderVector.length); //写一个short的长度,表示建筑的个数
				for each(var build:Builder in MapData.builderVector){
					var tempArr:Array = build.id.split("_");
					var type:int = parseInt( tempArr[0]); //建筑类型
					var id:int = parseInt(  tempArr[1] ) ; //建筑 ID
					_fs.writeByte(type); //写类型
					_fs.writeByte(id); //写ID
					_fs.writeByte(build.location.x);//写位置
					_fs.writeByte(build.location.y);//写位置
				}
			}catch(e:Error){
				Alert.show("保存建筑数据错误");
			}finally{
				_fs.close();
				//保存NPC数据
				saveNpcData();
			}
		}
		
		/**
		 * 保存Npc数据 
		 */		
		private function saveNpcData():void{
			_npcFile = new File(MapData.mapDirectory.nativePath+"/"+MapData.mapName+"/npc.bing");
			if(_npcFile.exists){
				_npcFile.deleteFile();
			}
			_fs = new FileStream();
			_fs.open(_npcFile,FileMode.WRITE);
			
			try{
				_fs.writeShort(MapData.npcVector.length); //写一个short的长度,表示npc的个数
				for each(var npc:Npc in MapData.npcVector){
					var id:int = parseInt(  npc.id ) ; //npc ID
					_fs.writeByte(id); //写ID
					_fs.writeByte(npc.location.x);//写位置
					_fs.writeByte(npc.location.y);//写位置
				}
			}catch(e:Error){
				Alert.show("保存npc数据错误");
			}finally{
				_fs.close();
				//保存碰撞和遮罩数据
				saveAaskAndImpactData();
			}
		}
		
		/**
		 *  保存碰撞和遮罩数据，１为碰撞块，２为遮罩，０为可走
		 */		
		private function saveAaskAndImpactData():void{
			_impactFile = new File(MapData.mapDirectory.nativePath+"/"+MapData.mapName+"/impact_mask.bing");
			if(_impactFile.exists){
				_impactFile.deleteFile();
			}
			_fs = new FileStream();
			_fs.open(_impactFile,FileMode.WRITE);
			
			try{
				for(var i:int = 0; i<MapData.xNum ; i++ ){
					for(var j:int = 0; j<MapData.yNum*2+1 ; j++ ){
						//如果不是碰撞块
						if(MapData.impactArray[i+"-"+j]==null||MapData.impactArray[i+"-"+j]==false||MapData.impactArray[i+"-"+j]==undefined){
							//如果也不是遮罩
							if(MapData.maskArray[i+"-"+j]==null||MapData.maskArray[i+"-"+j]==false||MapData.maskArray[i+"-"+j]==undefined){
								_fs.writeByte(0); //可走
							}else {
								_fs.writeByte(2);//遮罩
							}
						}else{
							_fs.writeByte(1);//碰撞块
						}
					}
				}
			}catch(e:Error){
				Alert.show("保存碰撞和遮罩块数据错误");
			}finally{
				_fs.close();
				saveConfig();//保存主配置信息
			}
		}
		
		
		/**
		 * 保存主配置 
		 */		
		private function saveConfig():void{
			var xmlFile:File = new File(MapData.mapDirectory.nativePath+"/"+MapData.mapName+"/config.xml");
			var config:String ="<config><map>" ;
			config	+= "<xNum>"+MapData.xNum+"</xNum>" ;
			config	+= "<yNum>"+MapData.yNum+"</yNum>" ;
			config	+= "<width>"+MapData.mapWidth+"</width>" ;
			config	+= "<height>"+MapData.mapHeight+"</height>" ;
			config	+= "<tileWidth>"+MapData.tileWidth+"</tileWidth>" ;
			config	+= "<tileHeight>"+MapData.tileHeight+"</tileHeight></map>" ;
			//传输区信息
			config +="<transport>" ;
			for each(var trans:Transport in MapData.transportVector){
				config	+= "<trans point='"+trans.tempLoc+"' isShow='"+trans.isShow+"' birthDirection='"+trans.direction+"' birthMapId='"+trans.nextMapId+"' birthPoint='"+trans.nextMapLoc+"'/>" ;
			}
			config  += " </transport></config>" ;
			try{
				_fs = new FileStream();
				_fs.open(xmlFile,FileMode.WRITE);
				_fs.writeUTFBytes(new XML( config.toString() ) );
			}catch(e:Error){
				Alert.show(e.message);
			}finally{
				_fs.close();
				saveNpcConfig();//保存npc的配置信息
			}
			
		}
		
		/**
		 * 保存npc的配置信息 
		 */		
		private function saveNpcConfig():void
		{
			var xmlFile:File = new File(MapData.mapDirectory.nativePath+"/"+MapData.mapName+"/npc.xml");
			var config:String ="<config>";
			for(var i:int = 0 ; i<MapData.npcVector.length ; i++ )
			{
				var npc:Npc = MapData.npcVector[i] ;
				config +="<npc>" ;
				config += "<npcId>"+ npc.npcId +"</npcId>" ;
				config += "<name>"+ npc.npcName +"</name>" ;
				config += "<panel>"+ npc.npcPanel +"</panel>" ;
				config += "</npc>" ;
			}
			config += "</config>" ;
			try{
				_fs = new FileStream();
				_fs.open(xmlFile,FileMode.WRITE);
				_fs.writeUTFBytes(new XML( config.toString() ) );
			}catch(e:Error){
				Alert.show(e.message);
			}finally{
				_fs.close();saveBgPic();//保存背景图片
			}
			
		}
		
		/**
		 * 保存地表大图片 
		 */		
		private function saveBgPic():void {
			try{
				var srcFile:File = new File(MapData.bgPath);
				var desFile:File = new File(MapData.mapDirectory.nativePath+"/"+MapData.mapName+"/ground.jpg") ; 
				if(desFile.exists){
					//如果背景图片已经存在，则直接完成
					copyCom() ;
				}else{
					srcFile.copyToAsync(desFile );
					srcFile.addEventListener(Event.COMPLETE , copyCom);
				}
			}catch(e:Error){
				Alert.show(e.message);
			}
			
		}
		
		/** 背景图片复制完成 */
		private function copyCom(e:Event = null ):void{
			if(this._saveBlock){
				saveBlock();
			}else {
				this.dispatchEvent(new Event(Event.COMPLETE));//抛出保存完成事件
			}
		}
		
		//块的宽和高
		private const BLOCKWIDTH:int = 200; 
		private const BLOCKHEIGHT:int = 200;
		/** 保存块 */
		private function saveBlock ():void {
			if(this._groundDir==null){
				_groundDir = new File(MapData.mapDirectory.nativePath+"/"+MapData.mapName+"/ground") ;
				_groundDir.createDirectory(); //创建块目录
			}
			var xCount:int = Math.ceil( MapData.bg.width/BLOCKWIDTH);
			var yCount:int = Math.ceil( MapData.bg.height/BLOCKHEIGHT );
			var bmd:BitmapData = new BitmapData(BLOCKWIDTH,BLOCKHEIGHT,false,0x000000);
			var encoder:JPEGEncoder = new JPEGEncoder();
			var blockFile:File = null ;
			for(var i:int = 0; i<xCount ; i ++){
				for(var j:int = 0; j<yCount ; j ++){
					var rect:Rectangle = new Rectangle(i*BLOCKWIDTH,j*BLOCKHEIGHT,BLOCKWIDTH,BLOCKHEIGHT);
					/*if((i+1)*BLOCKWIDTH>MapData.bg.bitmapData.width){
						rect.width = (i+1)*BLOCKWIDTH-MapData.bg.bitmapData.width ;
					}
					if((j+1)*BLOCKHEIGHT>MapData.bg.bitmapData.height){
						rect.height = (j+1)*BLOCKHEIGHT-MapData.bg.bitmapData.height ;
					}*/
					bmd = new BitmapData(rect.width ,rect.height ,false,0x000000);
					bmd.copyPixels(MapData.bg.bitmapData , rect ,new Point()) ;
					blockFile = new File (_groundDir.nativePath+"/"+i*BLOCKWIDTH+"-"+j*BLOCKHEIGHT+".jpg") ;
					_fs = new FileStream();
					_fs.open( blockFile , FileMode.WRITE );
					var byte:ByteArray =  encoder.encode(bmd);
					_fs.writeBytes( byte, 0 ,byte.length );
					_fs.close();
				}
			}
			this.dispatchEvent(new Event(Event.COMPLETE));//抛出保存完成事件
		}
		
	}
}