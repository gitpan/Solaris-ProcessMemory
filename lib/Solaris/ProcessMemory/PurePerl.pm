package Solaris::ProcessMemory::PurePerl;

use strict;
use warnings;

sub get_unshared_memory {
    my ( $class, $pid ) = @_;
    my $regex = qr/total\s+Kb\s+\d+\s+\d+\s+(\d+)/xms;
    return $class->_get_memory( $regex, $pid );
}

sub get_rss_memory {
    my ( $class, $pid ) = @_;
    my $regex = qr/total\s+Kb\s+\d+\s+(\d+)/xms;
    return $class->_get_memory( $regex, $pid );
}

sub get_total_memory {
    my ( $class, $pid ) = @_;
    my $regex = qr/total\s+Kb\s+(\d+)/xms;
    return $class->_get_memory( $regex, $pid );
}

sub _get_memory {
    my ( $class, $regex, $pid ) = @_;

    # If no pid supplied, use current pid.
    $pid           = $pid || $$;
    my $output     = `pmap -x $pid`;
    my @lines      = split /\n/xms, $output;
    my $total_line = $lines[-1];
    my ($memory)   = $total_line =~ $regex;

    return $memory;
}

1;

=pod

=head1 NAME

Solaris::ProcessMemory::PurePerl

=head1 DESCRIPTION

Pure perl implementation of Solaris::ProcessMemory

This module's interface is the same as L<Solaris::ProcessMemory>. See that perldoc for usage.

=cut
