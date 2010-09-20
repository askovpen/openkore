#########################################################################
#  OpenKore - Network subsystem
#  Copyright (c) 2006 OpenKore Team
#
#  This software is open source, licensed under the GNU General Public
#  License, version 2.
#  Basically, this means that you're allowed to modify and distribute
#  this software. However, if you distribute modified versions, you MUST
#  also distribute the source code.
#  See http://www.gnu.org/licenses/gpl.html for the full license.
#########################################################################
# iRO (International)
# Servertype overview: http://www.openkore.com/wiki/index.php/ServerType
package Network::Receive::iRO;

use strict;
use base qw(Network::Receive::ServerType0);

use Globals qw($questList);
use Log qw(debug);
use Misc qw(monsterName);

sub new {
	my ($class) = @_;
	my $self = $class->SUPER::new(@_);
	my %packets = (
		'0078' => ['actor_display',	'C a4 v14 a4 a2 v2 C2 a3 C3 v',				[qw(object_type ID walk_speed opt1 opt2 option type hair_style weapon lowhead shield tophead midhead hair_color clothes_color head_dir guildID emblemID manner opt3 karma sex coords unknown1 unknown2 act lv)]], # 55 # standing
		'007C' => ['actor_display',	'C a4 v14 C2 a3 C2',						[qw(object_type ID walk_speed opt1 opt2 option hair_style weapon lowhead type shield tophead midhead hair_color clothes_color head_dir karma sex coords unknown1 unknown2)]], # 42 # spawning 
		'0097' => ['private_message', 'v Z24 V Z*', [qw(len privMsgUser flag privMsg)]], # -1
		'022C' => ['actor_display', 'C a4 v3 V v5 V v5 a4 a2 v V C2 a6 C2 v',	[qw(object_type ID walk_speed opt1 opt2 option type hair_style weapon shield lowhead tick tophead midhead hair_color clothes_color head_dir guildID emblemID manner opt3 karma sex coords unknown1 unknown2 lv)]], # 65 # walking 
	);

	foreach my $switch (keys %packets) {
		$self->{packet_list}{$switch} = $packets{$switch};
	}

	return $self;
}

# 02B5
# note: this packet updates the objectives counters
sub quest_update_mission_hunt {
	my ($self, $args) = @_;
	for (my $i = 0; $i < $args->{amount}; $i++) {
		my ($questID, $mobID, $goal, $count) = unpack('V2 v2', substr($args->{RAW_MSG}, 6+$i*12, 12));
		@{$questList->{$questID}{missions}{$mobID}}{qw(mobID goal count)} = ($mobID, $goal, $count);
		debug sprintf("questID (%d) - mob(%s) count(%d/%d)\n", $questID, monsterName($mobID), $count, $goal), "info";
	}
}

1;