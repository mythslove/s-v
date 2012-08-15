package bing.map.data
{
	import bing.map.model.Builder;
	import bing.map.model.Npc;
	import bing.map.model.Transport;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class MapData
	{
		/**
		 * 菱形宽度 
		 */		
		[Bindable]
		public static var tileWidth:int = 0;
		/**
		 * 菱形高度 
		 */		
		[Bindable]
		public static var tileHeight:int = 0;
		/**
		 * X方向上菱形数量 
		 */		
		public static var xNum:int = 0;
		/**
		 * Y方向上菱形数量 
		 */		
		public static var yNum:int = 0;
		/**
		 * 地图宽 
		 */		
		[Bindable]
		public static var mapWidth:int = 0;
		/**
		 * 地图高 
		 */		
		[Bindable]
		public static var mapHeight:int = 0;
		/**
		 * 地图名称 
		 */		
		public static var mapName:String="";
		/**
		 * 背景图片文件 
		 */		
		public static var bg:Bitmap = null;
		/**
		 * 背景图片路径 
		 */		
		public static var bgPath:String = "";
		/**
		 * 建筑集合 
		 */		
		public static var builderVector:Vector.<Builder> = new Vector.<Builder>();
		
		/**
		 * npc的dictinary 集合 
		 */		
		public static var npcDic:Dictionary = new Dictionary();
		
		/**
		 * NPC集合 
		 */		
		public static var npcVector:Vector.<Npc> = null;
		/**
		 * 碰撞块集合 
		 */		
		public static var impactArray:Array = null;
		/**
		 * 遮罩层集合 
		 */		
		public static var maskArray:Array = null ;
		/**
		 * 传输区集合 
		 */		
		public static var transportVector:Vector.<Transport> = new Vector.<Transport>();
		/**
		 * 保存地图的文件夹 
		 */		
		public static var mapDirectory:File = null;
		
		/**
		 * 初始化地图数据 
		 */		
		public static function initMapData():void{
			impactArray = new Array();
			maskArray = new Array();
			npcVector = new Vector.<Npc>();
			builderVector = new Vector.<Builder>();
		}
		
	}
}