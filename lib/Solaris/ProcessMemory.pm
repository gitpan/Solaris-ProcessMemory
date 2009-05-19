package Solaris::ProcessMemory;

use 5.008006;
use strict;
use warnings;

our $VERSION = '0.02';

require XSLoader;
XSLoader::load('Solaris::ProcessMemory', $VERSION);

# Preloaded methods go here.

1;

__END__

=head1 NAME

Solaris::ProcessMemory - Determine process memory usage on Solaris

=head1 SYNOPSIS

  use Solaris::ProcessMemory;

  # Get unshared memory used by current process
  $unshared_memory = Solaris::ProcessMemory->get_unshared_memory();
  $unshared_memory = Solaris::ProcessMemory->get_unshared_memory($$);

  # Get total memory used by current process
  $total_memory = Solaris::ProcessMemory->get_total_memory();
  $total_memory = Solaris::ProcessMemory->get_total_memory($$);

  # Get RSS memory used by current process
  $rss_memory = Solaris::ProcessMemory->get_rss_memory();
  $rss_memory = Solaris::ProcessMemory->get_rss_memory($$);

=head1 DESCRIPTION

This module uses the solaris C<'pmap -x'> command behind the scenes to determine the amount of memory used by the process.

If you require a pure perl implementation, see L<Solaris::ProcessMemory::PurePerl>.

=head1 CLASS METHODS

Each method must be called as a class method (i.e using the arrow notation) as opposed to a function. See L</"SYNOPSIS"> above.

=over

=item get_unshared_memory

Returns the amount of unshared memory used by the passed in process id. If no process id is passed in, defaults to the current process id.

=item get_total_memory

Returns the amount of total memory used by the passed in process id. If no process id is passed in, defaults to the current process id.

=item get_rss_memory

Returns the amount of RSS memory used by the passed in process id. If no process id is passed in, defaults to the current process id.

=back

=head1 AUTHOR

Bob Stockdale, E<lt>STOCKS@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Bob Stockdale

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.

=cut
