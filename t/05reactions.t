use strict;
use warnings;
use Test::InDistDir;
use Test::More;
use Event::Distributor;

my $count = 0;
my $dist  = Event::Distributor->new;
$dist->declare_signal( "announce" );

my $id1 = $dist->subscribe_sync( announce => sub { $count++ } );
my $id2 = $dist->subscribe_async( announce => sub { Future->done( $count++ ) } );
$_->() for $dist->reactions_for( announce => "Hello, world!" );
is $count, 2, "both listeners reacted";

$dist->unsubscribe( announce => $id1 );
$count = 0;
$_->() for $dist->reactions_for( announce => "Hello, world!" );
is $count, 1, "one listener removed";

$dist->unsubscribe( announce => $id2 );
$count = 0;
$_->() for $dist->reactions_for( announce => "Hello, world!" );
is $count, 0, "other listener removed";

done_testing;
