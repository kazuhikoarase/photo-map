package {
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	
	/**
	 * PhotoMap
	 * @author Kazuhiko Arase
	 */
	[SWF(frameRate="18")]
	public class PhotoMap extends Sprite {
		
		private var _photomap : PhotoMapImpl;
		
		public function PhotoMap() {

			// ステージの設定
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			stage.addEventListener(Event.RESIZE, function(event : Event) : void {
				updateScale();
			} );

			_photomap = new PhotoMapImpl();
			addChild(_photomap);

			updateScale();
		}
		
		private function updateScale() : void {

			var scale : Number = 
				(_photomap.explicitWidth / _photomap.explicitHeight >
					stage.stageWidth / stage.stageHeight)?
						stage.stageWidth / _photomap.explicitWidth :
						stage.stageHeight / _photomap.explicitHeight;
			
			// fit to stage
			_photomap.scaleX = scale;
			_photomap.scaleY = scale;
			
			// centering
			_photomap.x = (stage.stageWidth -
				_photomap.explicitWidth * scale) / 2;
			_photomap.y = (stage.stageHeight -
				_photomap.explicitHeight * scale) / 2;
		}
	}	
}

import com.d_project.photomap.Direction;
import com.d_project.photomap.DirectionButton;
import com.d_project.photomap.Loading;
import com.d_project.photomap.PhotoMapEvent;
import com.d_project.photomap.PhotoMapView;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.external.ExternalInterface;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.ui.Keyboard;

class PhotoMapImpl extends Sprite {

	// 明示的なサイズ    
	public const explicitWidth : Number = 400;
	public const explicitHeight : Number = 500;

	private var _photoMapView : PhotoMapView;
	
	private var _loading : Loading;
	
	private var _titleText : TextField;
	
	private var _descriptionText : TextField;
	
	private var _buttonPane : Sprite;
	
	private var _leftButton : DirectionButton;
	
	private var _frontButton : DirectionButton;
	
	private var _rightButton : DirectionButton;
	
	private var _step : int;
	
	private var _status : String;
	
	private var _mouseLeave : Boolean;
	
	public function PhotoMapImpl() {
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}

	private function addedToStageHandler(event : Event) : void {
		
		// コンポーネントを作成する。
		createComponents();
		
		// 読み込み中を非表示にする。
		hideLoading();
		
		// コントロール類を非表示にする。
		hideControls();
		
		// マウス制御
		_mouseLeave = false;
		stage.addEventListener(MouseEvent.MOUSE_OVER, function (e : Event) : void {
			trace(e);
			_mouseLeave = false;
		} );
		stage.addEventListener(Event.MOUSE_LEAVE, function (event : Event) : void {
			_mouseLeave = true;
		} );
		
		// キー操作用    
		stage.addEventListener(KeyboardEvent.KEY_DOWN, function(event : KeyboardEvent) : void {
			
			switch(event.keyCode) {
				
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
		var defaultUrl : String = loaderInfo.parameters.defaultUrl;
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

		// 余白
		var gap : Number = 5;
		
		// ボタンのサイズ
		var buttonSize : Number = 10;
		
		// タイトルのフォントサイズ
		var titleFontSize : Number = 14;
		
		// 説明のフォントサイズ
		var descriptionFontSize : Number = 12;
		
		_photoMapView = new PhotoMapView();
		_photoMapView.x = 0;
		_photoMapView.y = gap;
		_photoMapView.explicitWidth = 400;
		_photoMapView.explicitHeight = 300;
		_photoMapView.addEventListener(PhotoMapEvent.LOAD_COMPLETE, function (event : Event) : void {
			hideLoading();
		});
		_photoMapView.addEventListener(PhotoMapEvent.WALK_COMPLETE, function (event : Event) : void {
			showControls();
			callPageChangeHandler();
		});
		addChild(_photoMapView);
		
		// ボタン領域
		_buttonPane = new Sprite();
		_buttonPane.x = explicitWidth / 2;
		_buttonPane.y = gap + _photoMapView.explicitHeight - (buttonSize + gap);
		_buttonPane.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		addChild(_buttonPane);
		
		// 「左へ」ボタン
		_leftButton = new DirectionButton(Direction.LEFT, buttonSize);
		_leftButton.x = - (buttonSize * 2 + gap);
		_leftButton.y = 0;
		_leftButton.addEventListener(MouseEvent.CLICK, function(event : MouseEvent) : void {
			toLeft();
		});
		_buttonPane.addChild(_leftButton);
		
		// 「前へ」ボタン
		_frontButton = new DirectionButton(Direction.FRONT, buttonSize);
		_frontButton.x = 0;
		_frontButton.y = 0;
		_frontButton.addEventListener(MouseEvent.CLICK, function(event : MouseEvent) : void {
			toFront();
		});
		_buttonPane.addChild(_frontButton);
		
		// 「右へ」ボタン
		_rightButton = new DirectionButton(Direction.RIGHT, buttonSize);
		_rightButton.x = (buttonSize * 2 + gap);
		_rightButton.y = 0;
		_rightButton.addEventListener(MouseEvent.CLICK, function(event : MouseEvent) : void {
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
		_titleText.defaultTextFormat =
			new TextFormat("_sans", titleFontSize, 0x000000, true);
		addChild(_titleText);
		
		txtYPos += titleFontSize + gap;
		
		_descriptionText = new TextField();
		_descriptionText.x = 0;
		_descriptionText.y = txtYPos;
		_descriptionText.width = explicitWidth;
		_descriptionText.height = explicitHeight - gap - txtYPos;
		_descriptionText.multiline = true;
		_descriptionText.defaultTextFormat =
			new TextFormat("_sans", descriptionFontSize, 0x000000);
		addChild(_descriptionText);
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
		_descriptionText.text = _photoMapView.description;
		_leftButton.visible = _photoMapView.hasLeft();
		_frontButton.visible = _photoMapView.hasFront();
		_rightButton.visible = _photoMapView.hasRight();
	}
	
	private function hideControls() : void {
		_titleText.text = "";
		_descriptionText.text = "";
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
	
	private function callPageChangeHandler() : void {
		var pageChangeHandler : String =
			loaderInfo.parameters.pageChangeHandler;
		if (!pageChangeHandler) {
			return;
		}
		ExternalInterface.call(pageChangeHandler,
			_photoMapView.url,
			_photoMapView.title);
	}
	
	private function enterFrameHandler(event : Event) : void {
		
		if (!_mouseLeave && 
				0 <= _photoMapView.mouseX &&
				_photoMapView.mouseX <= _photoMapView.explicitWidth &&
				0 <= _photoMapView.mouseY &&
				_photoMapView.mouseY <= _photoMapView.explicitHeight) {
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

final class Status {
	
	public static const STOP : String = "stop";
	
	public static const FADE_IN : String = "fadeIn";
	
	public static const FADE_OUT : String = "fadeOut";
}
