#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"
#include "unistd.h"
#include "stdio.h"
#include "regex.h"

static SV *get_memory( const char* regex_str, int pid ) {
    /* Create the command string */
    char command[50];
    sprintf( command, "pmap -x %d", pid);


    /* Get our regular expression ready to match the last line of output */
    int         status;
    regex_t     total_re, regex_re;
    regmatch_t  match[5];

    regcomp( &total_re, "total.*", REG_EXTENDED|REG_NOSUB );
    regcomp( &regex_re, regex_str, REG_EXTENDED           );

    /* Execute the command */
    FILE *fp;
    char line[130];
    char matched_line[130];

    fp = popen( command, "r" );

    while ( fgets( line, sizeof line, fp ) ) {

        status = regexec( &total_re, line, 0, NULL, 0);

        if ( status == 0 ) {

            /* We found the "total" line */
            /* Strip out the total anonymous memory */
            status = 
                regexec( &regex_re, line, (size_t) 5, match, 0);

            if ( status == 0 ) {

                sprintf( matched_line, "%.*s", 
                        match[1].rm_eo - match[1].rm_so, 
                        &line[match[1].rm_so] );
            }
        }
    }

    regfree(&total_re);
    regfree(&regex_re);

    pclose(fp);

    /* Return the memory 
     * atoi converts a string to an int */
    return newSVuv( atoi(matched_line) );
}

/* BEGIN XSUBS */

MODULE = Solaris::ProcessMemory		PACKAGE = Solaris::ProcessMemory		

SV*
get_total_memory( class, ... )
    CODE:
      int pid = ( items > 1 ) ? (int) SvUV(ST(1)) : getpid();
      RETVAL = get_memory( "total Kb[[:blank:]]+([[:digit:]]+)", pid );
    OUTPUT:
      RETVAL

SV*
get_unshared_memory( class, ... )
    CODE:
      int pid = ( items > 1 ) ? (int) SvUV(ST(1)) : getpid();
      RETVAL = get_memory( 
              "[[:digit:]]+[[:blank:]]+[[:digit:]]+[[:blank:]]+([[:digit:]]+)", 
              pid );
    OUTPUT:
      RETVAL

SV*
get_rss_memory( class, ... )
    CODE:
      int pid = ( items > 1 ) ? (int) SvUV(ST(1)) : getpid();
      RETVAL = get_memory( 
              "[[:digit:]]+[[:blank:]]+([[:digit:]]+)[[:blank:]]+[[:digit:]]+", 
              pid );
    OUTPUT:
      RETVAL
