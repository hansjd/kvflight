using System;
using System.Net.Http;
using System.Threading.Tasks;
using AVFoundation;
using AVKit;
using CoreFoundation;
using Foundation;
using UIKit;

namespace kvflight
{
    public partial class ViewController : UIViewController
    {
        private AVPlayer _avPlayer;
        private UIActivityIndicatorView _activityIndicatorView;

        private string _address;

        private string[] _addresses = {
            "https://w1.kringvarp.fo/kvf/_definst_/smil:kvf.smil/playlist.m3u8",
            "https://w2.kringvarp.fo/uttanlands/_definst_/smil:uttanlands.smil/playlist.m3u8"
        };

        public ViewController(IntPtr handle) : base(handle)
        {
        }

        public override async void ViewDidLoad()
        {
            base.ViewDidLoad();

            NSNotificationCenter notificationCenter = NSNotificationCenter.DefaultCenter;
            notificationCenter.AddObserver(UIApplication.WillEnterForegroundNotification, (n) => { Reload(); });

            await InitializePlayerAsync();
        }

        public override void ViewDidAppear(bool animated)
        {
            base.ViewDidAppear(animated);

            _avPlayer?.Play();
        }

        private async Task<string> GetAddressAsync()
        {
            string foundAddress = null;

            using (HttpClient client = new HttpClient())
            {
                client.Timeout = TimeSpan.FromSeconds(5);
                foreach(var address in _addresses)
                {
                    try
                    {
                        var result = await client.GetAsync(address);
                        if(result.StatusCode == System.Net.HttpStatusCode.OK)
                        {
                            foundAddress = address;
                            break;
                        }
                    }
                    catch(Exception ex)
                    {
                       //LOG EXCEPTION
                    }
                    
                }
                
            }

            return foundAddress;    
        }

        private void Reload()
        {
            _avPlayer.ReplaceCurrentItemWithPlayerItem(new AVPlayerItem(new NSUrl(_address)));
            _avPlayer.Play();
        }

        private async Task InitializePlayerAsync()
        {
            _address = await GetAddressAsync();

            _avPlayer = new AVPlayer(new NSUrl(_address));
            _avPlayer.AddPeriodicTimeObserver(new CoreMedia.CMTime(1,600), DispatchQueue.MainQueue, (CoreMedia.CMTime t) =>
            {
                bool isBuffering = true;

                if(_avPlayer?.CurrentItem?.Status == AVPlayerItemStatus.ReadyToPlay)
                {
                    if(_avPlayer.CurrentItem.PlaybackLikelyToKeepUp)
                    {
                        isBuffering = false;
                    }
                }

                if(isBuffering)
                {
                    _activityIndicatorView.StartAnimating();
                }
                else
                {
                    _activityIndicatorView.StopAnimating();
                }
            }) ; 

            AVPlayerLayer playerLayer = AVPlayerLayer.FromPlayer(_avPlayer);

            playerLayer.Frame = View.Bounds;

            View.Layer.AddSublayer(playerLayer);

            _avPlayer.Play();

            _activityIndicatorView = new UIActivityIndicatorView(UIActivityIndicatorViewStyle.WhiteLarge);
            _activityIndicatorView.Center = this.View.Center;
            _activityIndicatorView.StartAnimating();

            View.AddSubview(_activityIndicatorView);
        }
    }
}

