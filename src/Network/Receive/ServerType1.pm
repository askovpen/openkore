# Servertype overvie: http://www.openkore.com/wiki/index.php/ServerType
package Network::Receive::ServerType1;

use strict;
use base qw(Network::Receive);

sub new {
	my ($class) = @_;
	my $self = $class->SUPER::new;
	return $self;
}

1;
