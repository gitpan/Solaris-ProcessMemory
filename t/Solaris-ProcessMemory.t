#! perl

use strict;
use warnings;
use Test::More tests => 16;
use Data::Dumper;
use Carp;

BEGIN: { 
    use_ok('Solaris::ProcessMemory'); 
    use_ok('Solaris::ProcessMemory::PurePerl'); 
}

system("pmap -x $$");

ok( !$?, 'pmap called successfully' );

# Same value is returned when calling same method with current process id
# or with no args
ok( Solaris::ProcessMemory->get_total_memory(),
    'Got non-zero total memory' );

ok( Solaris::ProcessMemory->get_unshared_memory(),
    'Got non-zero unshared memory' );

ok( Solaris::ProcessMemory->get_rss_memory(),
    'Got non-zero rss memory' );

is( Solaris::ProcessMemory->get_unshared_memory($$),
    Solaris::ProcessMemory->get_unshared_memory(),
    'Got the same unshared memory with current pid and w/ no args' );

is( Solaris::ProcessMemory->get_total_memory($$),
    Solaris::ProcessMemory->get_total_memory(),
    'Got the same total memory with current pid and w/ no args' );

is( Solaris::ProcessMemory->get_rss_memory($$),
    Solaris::ProcessMemory->get_rss_memory(),
    'Got the same rss memory with current pid and w/ no args' );

ok( Solaris::ProcessMemory->get_total_memory() > 
    Solaris::ProcessMemory->get_unshared_memory(),
    'Total memory is greater than unshared memory' );


# Ensure we get the same results using the both XS and PurePerl 
# implementations. We must test this on a sub-process, otherwise we will
# be modifying the process memory used by checking the memory usage and 
# therefore will get different results.
my $pid = fork;

SKIP: {

    skip( 'unable to fork()', 3 ) if not defined $pid;

    if ( $pid == 0 ) {
    
        # We are the child process.
        sleep 4;
        exit;
    }

    ok( Solaris::ProcessMemory->get_total_memory($pid),
        'Got total memory for child process' );
    
    # Parent process will continue here.
    is( Solaris::ProcessMemory->get_total_memory($pid),
        Solaris::ProcessMemory::PurePerl->get_total_memory($pid),
        'Total memory is the same between XS and PP' );

    ok( Solaris::ProcessMemory->get_unshared_memory($pid),
        'Got unshared memory for child process' );
    
    is( Solaris::ProcessMemory::PurePerl->get_unshared_memory($pid),
        Solaris::ProcessMemory->get_unshared_memory($pid),
        'Unshared memory is the same between XS and PP' );
    
    ok( Solaris::ProcessMemory->get_rss_memory($pid),
        'Got rss memory for child process' );

    is( Solaris::ProcessMemory->get_rss_memory($pid),
        Solaris::ProcessMemory::PurePerl->get_rss_memory($pid),
        'RSS memory is the same between XS and PP' );
    
    # Wait for child processes to exit so we don't end up w/ zombies.
    wait;
}
