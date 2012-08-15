package bing.ds
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BinaryTree
	{
		//一个小块的宽度
		private var _defaultWidth:int ;
		//最大的范围
		private var _maxRect:Rectangle  = null ;
		//主节点
		private var _mainNode:Node = null ;
		//节点集合
		private var _nodeList:Vector.<Node> = null ;
		
		/**
		 * 二叉树 
		 * @param defaultWidth 一个小块的宽度
		 * @param maxRect 最大的宽度
		 */		
		public function BinaryTree( defaultWidth:int , maxRect:Rectangle )
		{
			_defaultWidth = defaultWidth;
			_maxRect = maxRect ;
			_nodeList = new Vector.<Node>();
			//初始化树的根节点
			_mainNode = new Node();
			_mainNode.hasSon = true ;
			_mainNode.rect = this._maxRect ;
			initTree( _mainNode );
		}
		
		/**
		 * 初始化树
		 * @node 树节点
		 */
		private function initTree( node:Node):void
		{
			if(node==null || node.rect.width<=_defaultWidth )
			{
				node.hasSon = false ;
				return ;
			}
			_nodeList.push( node );
			//设置子节点
			for( var i:int=0; i<node.sonNodeList.length; ++i){
				node.sonNodeList[i]= new Node();
				node.sonNodeList[i].parentNode = node; 
				node.sonNodeList[i].rect = new Rectangle( node.rect.x + (i % 2) * node.rect.width*0.5, 0 , node.rect.width*0.5, _maxRect.height ); 
				initTree(node.sonNodeList[i]); 
			}
		}
		
		/**
		 * 添加可视对象到树中 
		 * @param obj 类型为DisplayObjects
		 */		
		public function insertObj( obj:DisplayObject ):void
		{
			var sonNode:Node = searchNodeByPoint(new Point(obj.x,obj.y) , _mainNode );
			sonNode.objVec.push( obj );
		}
		
		/**
		 * 从树中删除对象 
		 * @param obj
		 */		
		public function deleteObj (obj:DisplayObject):void{
			var sonNode:Node = searchNodeByPoint(new Point(obj.x,obj.y) , _mainNode );
			for(var i:int = 0;i<sonNode.objVec.length ; i++){
				if(sonNode.objVec[i]==obj){
					sonNode.objVec.splice(i,1);
					break;
				}
			}
		}
		
		/**
		 * 通过矩形区域，查询显示对象 
		 * @param rect 矩形区域
		 * @param exact true表示精确查询
		 * @return 该区域的显示对象集合
		 */		
		public function searchByRect( rect:Rectangle , exact:Boolean ):Vector.<DisplayObject>{
			var objVec:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			if(_mainNode!=null){ 
				queryAndAdd(objVec , rect , _mainNode ,exact ) ;
			}
			return objVec ;
		}
		
		/**
		 * 遍历节点和儿子节点，查找最终的对象 
		 * @param objVec 查询结果
		 * @param rect 范围
		 * @param tempNode
		 */		
		private function queryAndAdd(objVec:Vector.<DisplayObject>,rect:Rectangle , tempNode:Node ,exact:Boolean ):void{
			//如果没有交集，则返回
			if(!rect.intersects(tempNode.rect)){
				return;
			}
			//判断是否有儿子节点，递归找儿子
			if(tempNode.hasSon){
				//遍历儿子节点
				for each(var son:Node in tempNode.sonNodeList){
					if(son.rect.intersects(rect)){ 
						queryAndAdd(objVec,rect, son ,exact);
					}
				}
			}else{
				//如果是最后的节点，则把里面的对象加入数组中
				for each(var obj:DisplayObject in tempNode.objVec){
					if(exact){
						var sonRect:Rectangle = new Rectangle(obj.x,obj.y,obj.width,obj.height) ;
						if(sonRect.intersects(rect)){
							objVec.push( obj );
						}
					}else{
						objVec.push( obj );
					}
				}
			}
		}
		
		/**
		 * 通过坐标来找节点 
		 * @param point
		 * @return 
		 */		
		private function searchNodeByPoint( point:Point ,node:Node ):Node{
			if(node.hasSon){
				if(node.checkPointIsIn(point)){
					//遍历儿子节点
					for each(var son:Node in node.sonNodeList){
						if(son.checkPointIsIn(point)){ 
							node = searchNodeByPoint( point , son );
						}
					}
				}
			}
			return node ;
		}
		
		/**
		 * 从四叉树中移除所有 
		 */		
		public function removeAll():void 
		{
			for each( var node:Node in _nodeList)
			{
				node.dispose() ;
			}
		}
	}
}

//=====================================

import flash.display.DisplayObject;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 *  四叉树的节点
 * @author zhouzhanglin
 * @date 2010/9/11
 */
class Node{
	//四个子节点
	private var oneNode:Node = null;
	private var twoNode:Node = null ;
	//此节点的范围
	public var rect:Rectangle  = null ;
	//此节点的父亲节点
	public var parentNode:Node = null ;
	//是否有子节点
	public var hasSon:Boolean = true ;
	//此节点下所有的对象集合
	public var objVec:Vector.<DisplayObject> = new Vector.<DisplayObject>();
	//此节点的儿子节点集合
	public var sonNodeList:Vector.<Node> = new Vector.<Node>();
	
	public function Node(){
		sonNodeList.push(oneNode);
		sonNodeList.push(twoNode);
	}
	
	/**
	 * 判断点是否在此节点中 
	 * @param point
	 * @return 
	 */	
	public function checkPointIsIn(point:Point):Boolean{
		if(point.x>=this.rect.x&&point.x<this.rect.x+this.rect.width){
			return true;
		}
		return false;
	}
	
	/** 
	 * 判断是否是叶子节点
	 * @param node
	 * @return 
	 */	
	public function isLeaf(node:Node):Boolean{
		if(this.parentNode!=null&&node.parentNode!=null&&this.parentNode==node.parentNode){
			return true;
		}
		return false;
	}
	
	public function dispose():void
	{
		if(sonNodeList)
		{
			for each( var node:Node in sonNodeList)
			{
				if(node) node.dispose() ;
			}
		}
		
		if(objVec)
		{
			for each( var mc:DisplayObject in objVec)
			{
				mc = null ;
			}
			objVec = new Vector.<DisplayObject>(); ;
		}
	}
}