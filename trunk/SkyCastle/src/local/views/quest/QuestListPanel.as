package local.views.quest
{
	import bing.components.ext.ScrollCanvas;
	import bing.utils.ContainerUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import local.model.vos.QuestVO;
	import local.utils.GameUtil;
	import local.views.base.BaseView;
	
	/**
	 * 完成的任务，激活的任务
	 * @author zzhanglin
	 */	
	public class QuestListPanel extends BaseView
	{
		public var txtTitle:TextField ;
		public var txtDes:TextField ;
		public var container:Sprite; //完成度的容器
		public var leftContainer:Sprite ; //列表的容器
		//=================================
		private var _type:String ;
		private var _canvas:ScrollCanvas ;
		private var _quests:Vector.<QuestVO> ;
		public var currentSeleted:QuestListIconRenderer ;//当前选择的项
		
		/**
		 *  
		 * @param quests
		 * @param type 为active或completed
		 */		
		public function QuestListPanel( quests:Vector.<QuestVO> , type:String  )
		{
			super();
			txtTitle.text="";
			txtDes.text="";
			GameUtil.disableTextField(this);
			_quests = quests ;
			_type = type ;
		}
		
		override protected function added():void
		{
			_canvas = new ScrollCanvas();
			_canvas.col = 1;
			_canvas.init( 120,435,ScrollCanvas.SLIDER_TYPE_V );
			leftContainer.addChild( _canvas );
			
			var renderers:Array = [] ;
			var len:int = _quests.length ;
			for( var i:int = 0 ; i<len ; ++i){
				renderers.push( new QuestListIconRenderer(_quests[i]));
			}
			_canvas.renders = renderers ;
			currentSeleted = renderers[0] as QuestListIconRenderer ;
			showItem();
			_canvas.addEventListener(MouseEvent.CLICK , onClickHandler , false , 0 ,true);
		}
		
		private function onClickHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			if(e.target is QuestListIconRenderer){
				if(currentSeleted){
					currentSeleted.setSeleted(false);
				}
				currentSeleted = e.target as QuestListIconRenderer ;
				showItem();
			}
		}
		
		private function showItem():void
		{
			if(currentSeleted){
				currentSeleted.setSeleted(true);
				txtTitle.text = currentSeleted.questVO.title ;
				txtDes.text = currentSeleted.questVO.describe ;
				
				ContainerUtil.removeChildren(container);
				var canSkip:Boolean = _type=="active"? false : true ;
				var progressPanel:QuestProgressPanel = new QuestProgressPanel(currentSeleted.questVO,canSkip);
				container.addChild( progressPanel );
			}
		}
				
		
		override protected function removed():void
		{
			_quests = null ;
			currentSeleted = null ;
			_canvas.removeEventListener(MouseEvent.CLICK , onClickHandler );
			_canvas = null ;
		}
	}
}