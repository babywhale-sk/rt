/* Credits:  7/19/93 - Thanks to Michael G. Reed for submitting the
 *           code to trap core dump and make this section more dynamic.
 *
 * This code is derived from Argonne National Labs' anlpasswd suite.
 * 
 * Jesse Vincent hacked at it and generalized things a bit for RT.
 *
 */
#include <stdio.h>
#include <string.h>

int main (argc, argv, envp)
int argc;
char *argv[],*envp[];

{
  int    i;
  char  *program_name;
  char **eargv;
  
  if (program_name = strrchr (argv[0], '/'))   /* Get root program name */
    program_name++;
  else
    program_name = argv[0];

  if (!(eargv = (char **) malloc ((argc + 3) * sizeof (char *))))
    {
      fprintf (stderr, "%s: Failed to obtain memory.\n", program_name);
      exit (1);                                  /* Trap core dump! */
    }
  eargv[0]= PERL;
  eargv[1] = "-U";
/*  eargv[2] = "-m/usr/local/rt/lib/routines/RT.pm";
	doesn't work setuid
*/

  if (!strcmp (program_name, "rt"))
    eargv[2] = RT;
  else if (!strcmp (program_name, "rtq"))
    eargv[2] = RTQ;
   else if (!strcmp (program_name, "nph-webrt.cgi"))
    eargv[2] = WEBRT;
   else if (!strcmp (program_name, "nph-admin-webrt.cgi"))
    eargv[2] = ADMINWEBRT;
  else if (!strcmp (program_name, "rtadmin"))
    eargv[2] = RTADMIN;
  else if (!strcmp (program_name, "rt-mailgate"))
    eargv[2] = RTMAILGATE;
  else
    {
      fprintf (stderr, "%s: Illegal launch program.\n", program_name);
      exit(1);
    }

  for (i = 1; i < argc; i++)
    eargv[i+2] = argv[i];
  execve(PERL, eargv, envp);
  fprintf (stderr, "%s: Failed to launch RT program.\n", program_name);
  perror (program_name);
}


