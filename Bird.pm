# 2011はてなインターン事前課題3(Bird.pm)
# Author: hrk623

use strict;
use warnings;

############################################################
# Tweetパッケージ
# - name: ツイートしたユーザー
# - tweet: ツイートの内容
package Tweet;
sub new{
		my $class = shift;
		my $self = { 
				name => undef, 
				tweet => undef,
				@_
		};
		return bless $self,$class;
}

# message関数
# pre: 
# post: このツイートのユーザーと内容を返す
sub message{
		my $self = shift;
		return $self->{name}, ": ", $self->{tweet}, "\n";
}


############################################################
# Birdパッケージ
# - name: ユーザー名
# - follow_list: このユーザーがフォローしてるユーザーのリスト
# - follower_list: このユーザーをフォローしているユーザーのリスト
# - timeline: このユーザーが見えるツイートのリスト
package Bird;

sub new{
		my $class = shift; 
		my $self = {
				name => '', 
				follow_list => [], 
				follower_list => [], 
				timeline => [],
				@_
		};
		return bless $self, $class;
}

# follow関数
# pre: $_[1] ≠ undef and $_[1] ≠ undef
# post :$_[1]が$_[2]をフォローし、$_[2]のフォロワーに登録される
sub follow{
		my $self = shift;
		my $new_follow = shift;
		push @{$self->{follow_list}}, $new_follow;
		push @{$new_follow->{follower_list}}, $self;
}

# tweet関数
# pre: 
# post: このユーザーのツイートが全フォロワーのタイムラインに載る
sub tweet{
		my $self = shift;
		my $tweet = shift;
		my $new_tweet = Tweet->new(name => $self->{name}, tweet => $tweet);

		foreach my $follower (@{$self->{follower_list}}){
				unshift @{$follower->{timeline}}, $new_tweet;
		}
}

# friends_timeline関数
# pre: 
# post: このユーザーが見えているタイムラインを返す
sub friends_timeline{
		my $self = shift;
		return $self->{timeline};
}






package main;

my $b1 = Bird->new( name => 'jkondo');
my $b2 = Bird->new( name => 'reikon');
my $b3 = Bird->new( name => 'onishi');

$b1->follow($b2);
$b1->follow($b3);
$b3->follow($b1);

$b1->tweet('きょうはあついですね！');
$b2->tweet('しなもんのお散歩中です');
$b3->tweet('烏丸御池なう！');

my $b1_timelines = $b1->friends_timeline;

print $b1_timelines->[0]->message;
print $b1_timelines->[1]->message;

my $b3_timelines = $b3->friends_timeline;
print $b3_timelines->[0]->message;
