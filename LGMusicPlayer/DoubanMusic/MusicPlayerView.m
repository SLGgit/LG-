
#import "MusicPlayerView.h"
#import "MusicPlayer.h"
#import "AppDelegate.h"

@implementation MusicPlayerView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}

- (void)dealloc {
    [_headImageView release];
    [_titleLabel release];
    [_timeLabel release];
    [_playOrPauseButton release];
    [_progressBar release];
    [super dealloc];
}

- (IBAction)playOrPauseClick:(id)sender {
    MusicPlayer *musicPlayer = [MusicPlayer shareInstance];
    if (musicPlayer.state == NCMusicEnginePlayStatePlaying) {
        [musicPlayer pause];
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
    } else if (musicPlayer.state == NCMusicEnginePlayStatePaused) {
        [musicPlayer resume];
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
    }
}

- (IBAction)nextClick:(id)sender {
    [[MusicPlayer shareInstance] next];
}

@end
