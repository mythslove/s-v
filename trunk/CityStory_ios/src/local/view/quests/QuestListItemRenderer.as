package local.view.quests
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLVariables;
	import flash.text.TextField;
	
	import local.util.GameUtil;
	import local.vo.QuestVO;
	
	public class QuestListItemRenderer extends MovieClip
	{
		public var flag:MovieClip;
		public var txtTitle:TextField ;
		public var txtGoodsCoin:TextField;
		public var txtExp:TextField ;
		public var container:Sprite;
		//====================================
		public var questVO:QuestVO ;
		
		public function QuestListItemRenderer()
		{
			super();
			stop();
			flag.stop();
			mouseChildren = false ;
		}
		
		public function show( vo:QuestVO):void
		{
			this.questVO = vo ;
			if( vo.rewards){
				var urlVar:URLVariables = new URLVariables( vo.rewards);
				if(urlVar.hasOwnProperty("good") ){
					this.gotoAndStop(2);
					GameUtil.boldTextField( txtGoodsCoin , "+"+ urlVar["good"] );
				} else if(urlVar.hasOwnProperty("goods") ){
					this.gotoAndStop(2);
					GameUtil.boldTextField( txtGoodsCoin , "+"+ urlVar["goods"] );
				} else{
					gotoAndStop(1);
				}
				if(urlVar.hasOwnProperty("coin")){
					GameUtil.boldTextField( txtGoodsCoin , "+"+ urlVar["coin"] );
				}else if(urlVar.hasOwnProperty("coins")){
					GameUtil.boldTextField( txtGoodsCoin , "+"+ urlVar["coins"] );
				}
			}
			
			if(!vo.isAccept){
				flag.visible = true ;
				flag.gotoAndStop("new");
			}
			else if(vo.getCompletedTaskCount()>0){
				flag.gotoAndStop("progress");
				flag.visible= true ;
			}else{
				flag.visible= false ;
			}
			
			GameUtil.boldTextField( txtTitle , vo.title );
			txtTitle.height = txtTitle.textHeight+4;
		}
	}
}