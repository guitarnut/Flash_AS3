package com.starz.core.media.video {
	import com.starz.core.media.video.components.VideoProgressBar;
	import com.starz.core.utils.Debug;

	//import mx.events.VideoEvent;

	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import com.starz.events.GameEvent;

	/**
	 * @author rhenley
	 */
	public dynamic class VideoPlayerLite extends Sprite {
		private static const BUFFER_TIME : Number = 10;

		private var _netConnection : NetConnection;
		private var _isPlaying : Boolean = false;
		private var _netStream : NetStream;
		private var _video : Video;
		private var _client : Object;
		private var _videoPath : String;
		private var _videoDuration : Number;
		private var _videoProgress : VideoProgressBar;
		private var _bufferIcon : BufferIcon;
		private var _videoBackground : VideoBackground;
		private var _playButton : PlayButton;
		private var _rewindButton : RewindButton;
		private var _videoWidth : Number = 400;
		private var _videoHeight : Number = 300;
		private var _videoName : String;
		private var _standalone : Boolean = false;
		private var _previewFrame : Number = 1;

		public function VideoPlayerLite() : void {
			trace('Initialized');
			
			getFlashVars();
		}

		private function getFlashVars() : void {
			try {
				var keyStr : String;
				var valueStr : String;
				var paramObj : Object = LoaderInfo(this.root.loaderInfo).parameters;
				var xmlPath : String;
				for (keyStr in paramObj) {
					trace('Found flashVar: ' + keyStr);
					valueStr = String(paramObj[keyStr]);
					if(keyStr == "videopath" && valueStr != null) {
						_videoPath = String(valueStr);
						trace('Value of ' + keyStr + ': ' + valueStr);
					}
					if(keyStr == "previewframe" && valueStr != null) {
						_previewFrame = Number(valueStr);
						trace('Value of ' + keyStr + ': ' + valueStr);
					}
				}
				_standalone = true;
				init();
				sizeVideo(_videoWidth, _videoHeight);
				setPlayButton();
				setRewindButton();
			} catch (error : Error) {
				trace('No flashVars found.  Defaulting to standard video player.');
				init();
			}
		}

		private function init() : void {
			_video = new Video();
			_video.smoothing = true;
			
			addChild(_video);
			
			_bufferIcon = new BufferIcon();

			createNetConnection();
			createNetStream();
			attachNetStream();
			getMetaData();
		}

		private function createNetConnection() : void {
			_netConnection = new NetConnection();
			_netConnection.connect(null);
		}

		private function createNetStream() : void {
			_netStream = new NetStream(_netConnection);
			_netStream.bufferTime = BUFFER_TIME;
			_netStream.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
		}

		private function attachNetStream() : void {
			_video.attachNetStream(_netStream);
		}

		public function sizeVideo(videoWidth : Number, videoHeight : Number) : void {
			_video.width = videoWidth;
			_video.height = videoHeight;

			_videoBackground = new VideoBackground();
			_videoBackground.width = videoWidth;
			_videoBackground.height = videoHeight;
			addChildAt(_videoBackground, 0);
			_videoBackground.addEventListener(MouseEvent.MOUSE_DOWN, pauseVideo);

			_videoProgress = new VideoProgressBar();
			_videoProgress.y = _video.height - _videoProgress.height;
			_videoProgress.width = _video.width;
			addChild(_videoProgress);
		}

		private function netStatus(event : NetStatusEvent) : void {
			trace(event.info.code);
			switch (event.info.code) {
				
				case "NetStream.Play.Start":
					addEventListener(Event.ENTER_FRAME, updateLoadProgress);
					addChild(_bufferIcon);
					break;
				case "NetStream.Play.Stop":
					removeChild(_bufferIcon);
					_netStream.pause();
					_netStream.seek(0);
					dispatchEvent(new GameEvent(GameEvent.VIDEO_COMPLETE));
					break;
				case "NetStream.Buffer.Empty":
					addChild(_bufferIcon);
					break;
				case "NetStream.Buffer.Full":
					removeChild(_bufferIcon);
					break;
			}
		}

		private function updateLoadProgress(event : Event) : void {
			_videoProgress.progressBar.scaleX = _netStream.bytesLoaded / _netStream.bytesTotal;
			if(_netStream.bytesLoaded == _netStream.bytesTotal) {
				removeEventListener(Event.ENTER_FRAME, updateLoadProgress);
			}
		}

		private function setPlayButton() : void {
			if(!_playButton) {
				_playButton = new PlayButton();
				if(_videoName)_playButton.videoName.text = _videoName;
				addChild(_playButton);
			}
			if(!_playButton.hasEventListener(MouseEvent.MOUSE_DOWN))_playButton.addEventListener(MouseEvent.MOUSE_DOWN, playButtonClicked);
			_playButton.visible = true;
			_playButton.mouseChildren = false;
			_playButton.buttonMode = true;
			_playButton.x = _videoWidth / 2;
			_playButton.y = _videoHeight / 2;
			if(_standalone)setPreviewImage();
		}
		
		private function setRewindButton() : void {
			if(!_rewindButton) {
				_rewindButton = new RewindButton();
				addChild(_rewindButton);
			}
			if(!_rewindButton.hasEventListener(MouseEvent.MOUSE_DOWN))_rewindButton.addEventListener(MouseEvent.MOUSE_DOWN, rewindButtonClicked);
			_rewindButton.visible = false;
			_rewindButton.mouseChildren = false;
			_rewindButton.buttonMode = true;
			_rewindButton.x = _videoWidth / 2 - _playButton.width/2-2;
			_rewindButton.y = _videoHeight / 2;
		}

		private function setPreviewImage() : void {
			_netStream.play(_videoPath);
			_netStream.pause();
			_netStream.seek(_previewFrame);
		}

		private function playButtonClicked(event : MouseEvent) : void {
			if(!_rewindButton.visible)_netStream.seek(0);
			_netStream.resume();
			_playButton.visible = false;
			_rewindButton.visible = false;
		}
		
		private function rewindButtonClicked(event : MouseEvent) : void {
			_netStream.seek(0);
			_netStream.resume();
			_playButton.visible = false;
			_rewindButton.visible = false;
		}

		public function play(videoPath : String) : void {
			_netStream.play(videoPath);
			trace('Playing '+videoPath);
		}

		public function pauseVideo(event : * = null) : void {
//			trace("Pausing...");
//			try {
//				_netStream.pause();
//				_playButton.x = _videoWidth / 2 + _playButton.width/2+2;
//				_playButton.visible = true;
//				_rewindButton.visible = true;
//			} catch(e : Error) {
//			}
		}

		public function stopVideo() : void {
			_netStream.pause();
			_netStream.seek(0);
		}

		private function getMetaData() : void {
			_client = new Object();
			_client.onMetaData = onMetaData;
			_netStream.client = _client;
		}

		private function onMetaData(data : Object) : void {
			_videoDuration = data.duration;
		}
	}
}
