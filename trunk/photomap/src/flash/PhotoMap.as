package {
	
	import com.d_project.photomap.Direction;
	import com.d_project.photomap.DirectionButton;
	import com.d_project.photomap.Loading;
	import com.d_project.photomap.PhotoMapEvent;
	import com.d_project.photomap.PhotoMapView;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	
	/**
	 * PhotoMap
	 * @author Kazuhiko Arase
	 */
	[SWF(frameRate="18", width="400", height="500")]
	public class PhotoMap extends Sprite {
		
		private var _photoMapView : PhotoMapView;
		
		private var _loading : Loading;
		
		private var _titleText : TextField;
		
		private var _memoText : TextField;
		
		private var _buttonPane : Sprite;
		
		private var _leftButton : DirectionButton;
		
		private var _frontButton : DirectionButton;
		
		private var _rightButton : DirectionButton;
		
		private var _step : int;
		
		private var _status : String;
		
		private var _mouseLeave : Boolean;
		
		public function PhotoMap() {

			// ステージの設定
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			
			// コンポーネントを作成する。
			createComponents();
			
			// 読み込み中を非表示にする。
			hideLoading();
			
			// コントロール類を非表示にする。
			hideControls();
			
			// マウス制御
			_mouseLeave = false;
			stage.addEventListener(MouseEvent.MOUSE_OVER, function (e : Event) : void {
				_mouseLeave = false;
			} );
			stage.addEventListener(Event.MOUSE_LEAVE, function (e : Event) : void {
				_mouseLeave = true;
			} );
			
			// キー操作用    
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e : KeyboardEvent) : void {
				
				switch(e.keyCode) {
					
					case Keyboard.LEFT :
						toLeft();
						break;
					
					case Keyboard.UP :
						toFront();
						break;
					
					case Keyboard.RIGHT :
						toRight();
						break;
					
					default :
						break;
				}
			} );
			
			// 既定のURLを取得する
			var defaultUrl : String = this.loaderInfo.parameters.defaultUrl;
			if (defaultUrl == null) {
				// sample for debug
				defaultUrl = "sample/DSCF0001.JPG";
			}
			
			_buttonPane.alpha = 0;
			_step = 0;
			_status = Status.STOP;
			
			showLoading();
			_photoMapView.load(defaultUrl);
		}
		
		private function createComponents() : void {

			// 明示的なサイズ(コンパイル時の設定値と同じ)    
			var explicitWidth : Number = stage.stageWidth;
			var explicitHeight : Number = stage.stageHeight;
			
			// 余白
			var gap : Number = 5;
			
			// ボタンのサイズ
			var buttonSize : Number = 10;
			
			// タイトルのフォントサイズ
			var titleFontSize : Number = 14;
			
			// メモのフォントサイズ
			var memoFontSize : Number = 12;
			
			_photoMapView = new PhotoMapView();
			_photoMapView.x = 0;
			_photoMapView.y = gap;
			_photoMapView.explicitWidth = 400;
			_photoMapView.explicitHeight = 300;
			_photoMapView.addEventListener(PhotoMapEvent.LOAD_COMPLETE, function (e : Event) : void {
				hideLoading();
			});
			_photoMapView.addEventListener(PhotoMapEvent.WALK_COMPLETE, function (e : Event) : void {
				showControls();
			});
			addChild(_photoMapView);
			
			// ボタン領域
			_buttonPane = new Sprite();
			_buttonPane.x = explicitWidth / 2;
			_buttonPane.y = gap + _photoMapView.explicitHeight - (buttonSize + gap);
			_buttonPane.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addChild(_buttonPane);
			
			// 「左へ」ボタン
			_leftButton = new DirectionButton(Direction.LEFT, buttonSize);
			_leftButton.x = - (buttonSize * 2 + gap);
			_leftButton.y = 0;
			_leftButton.addEventListener(MouseEvent.CLICK, function(e : MouseEvent) : void {
				toLeft();
			});
			_buttonPane.addChild(_leftButton);
			
			// 「前へ」ボタン
			_frontButton = new DirectionButton(Direction.FRONT, buttonSize);
			_frontButton.x = 0;
			_frontButton.y = 0;
			_frontButton.addEventListener(MouseEvent.CLICK, function(e : MouseEvent) : void {
				toFront();
			});
			_buttonPane.addChild(_frontButton);
			
			// 「右へ」ボタン
			_rightButton = new DirectionButton(Direction.RIGHT, buttonSize);
			_rightButton.x = (buttonSize * 2 + gap);
			_rightButton.y = 0;
			_rightButton.addEventListener(MouseEvent.CLICK, function(e : MouseEvent) : void {
				toRight();
			});
			_buttonPane.addChild(_rightButton);
			
			// loading... 表示
			_loading = new Loading();
			_loading.x = explicitWidth / 2 - _loading.textWidth / 2;
			_loading.y = gap + _photoMapView.explicitHeight + gap * 5;
			addChild(_loading);
			
			// 文字表示
			var txtYPos : Number = gap + _photoMapView.explicitHeight + gap;
			
			_titleText = new TextField();
			_titleText.x = 0;
			_titleText.y = txtYPos;
			_titleText.width = explicitWidth;
			_titleText.defaultTextFormat = new TextFormat("Verdana", titleFontSize, 0x000000, true);
			addChild(_titleText);
			
			txtYPos += titleFontSize + gap;
			
			_memoText = new TextField();
			_memoText.x = 0;
			_memoText.y = txtYPos;
			_memoText.width = explicitWidth;
			_memoText.height = explicitHeight - gap - txtYPos;
			_memoText.multiline = true;
			_memoText.defaultTextFormat = new TextFormat("Verdana", memoFontSize, 0x000000);
			addChild(_memoText);
			
			
		}
		
		private function toLeft() : void {
			if (_photoMapView.hasLeft() ) {
				hideControls();
				showLoading();
				_photoMapView.toLeft();
			}
		}
		
		private function toFront() : void {
			if (_photoMapView.hasFront() ) {
				hideControls();
				showLoading();
				_photoMapView.toFront();
			}
		}
		
		private function toRight() : void {
			if (_photoMapView.hasRight() ) {
				hideControls();
				showLoading();
				_photoMapView.toRight();
			}
		}
		
		private function showControls() : void {
			_titleText.text = _photoMapView.title;
			_memoText.text = _photoMapView.memo;
			_leftButton.visible = _photoMapView.hasLeft();
			_frontButton.visible = _photoMapView.hasFront();
			_rightButton.visible = _photoMapView.hasRight();
		}
		
		private function hideControls() : void {
			_titleText.text = "";
			_memoText.text = "";
			_leftButton.visible = false;
			_frontButton.visible = false;
			_rightButton.visible = false;
		}
		
		private function showLoading() : void {
			_loading.start();
		}
		
		private function hideLoading() : void {
			_loading.stop();
		}
		
		private function onEnterFrame(e : Event) : void {
			
			if (!_mouseLeave && _photoMapView.hitTestPoint(_photoMapView.mouseX, _photoMapView.mouseY, true) ) {
				// ビュー上にマウスがある場合はフェードインする。
				_status = Status.FADE_IN;
			}
			
			switch(_status) {
				
				case Status.FADE_IN :
					_step += 2;
					if (_step >= 20) {
						// フェードイン終了 > フェードアウト
						_step = 20;
						_status = Status.FADE_OUT;
					}
					_buttonPane.alpha = _step / 20;
					break;
				
				case Status.FADE_OUT :
					_step--;
					if (_step <= 0) {
						// フェードアウト終了 > 停止
						_step = 0;
						_status = Status.STOP;
					}
					_buttonPane.alpha = _step / 20;
					break;
				
				case Status.STOP :
				default :
					break;
			}
		}
	}
}

final class Status {
	
	public static const STOP : String = "stop";
	
	public static const FADE_IN : String = "fadeIn";
	
	public static const FADE_OUT : String = "fadeOut";
}
