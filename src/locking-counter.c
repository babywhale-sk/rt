/* 
 * req-nextnum.c
 *
 * $Id$
 *
 * remy@ccs.neu.edu
 * 27 June 1994
 *
 * Copyright (C) 1994 by Remy Evard
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * any later version.
 *
 * A copy of the license may be found in docs/license of the source
 * distribution.
 *
 *
 *   This program is called by the mail system on the mail server, when 
 *   adding numbers to systems mail, and is also run on the network from 
 *   elsewhere, when dumping a file into the request system.   So we want
 *   to keep all the files local to the mail server, but available to the
 *   net.  NFS is probably the wrong solution, but it's convenient.
 *
 *   We lock the numberfile before even looking at it so that no number
 *   is used twice.  We could get around this with loops, but no program
 *   should be in the lock for long, so this seems to be a reasonable way
 *   to do it.
 */

#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <grp.h>
#include <fcntl.h>
#include <ctype.h>
#include <errno.h>

#define FILESIZE 1024


main(argc, argv) 
int argc;
char *argv[];
{
  int num, fd;

  if(argc != 1 && argc != 3) {
    printf("usage: ___num [-set <number>]\n");
    exit(1);
  }

  fd = lockfile();
  
  if(argc == 3) {
    if(!strcmp(argv[1],"-set")) {
	num = atoi(argv[2]);
    } else {
      printf("usage: ___num [-set <number>]\n");
      exit(1);
    }
  } else {
    num = getnumber(fd);
    num++;
  }

  writefile(fd, num);
  unlockfile(fd);
  printf("%d\n", num);
}



int lockfile()
{
  int fd;

  /* Open NUMFILE for reading. */
  if((fd = open(NUMFILE, O_RDWR | O_CREAT, 0600)) == -1 ) {
    perror("no-readfile");
    exit(1);
  }

  /* Lock the dang thing.  As if we trusted UNIX file locking.  */
  if(lockf(fd, F_LOCK, 0)) {
    printf("no-lock-file\n");
    exit(1);
  }

  return(fd);
}


int getnumber(fd)
int fd;
{
  int num;
  char buf[FILESIZE], *cp, *np;

  /* Slurp it into a buffer. */
  if(read(fd,buf,FILESIZE) < 0) {
    printf("error-file\n");
    exit(1);
  }

  /* Try to read the number from it, ignoring lines that start with #
   * and otherwise stopping once we hit a digit, and reading from there.
   * This should be safe, since we recreate the file a bit lower in this
   * program.
   */
  num = -1;
  for(cp = buf; *cp; cp++) {
    if(*cp == '#') {
      while(*cp != '\n' && *cp) cp++;
      continue;
    }

    if(isdigit(*cp)) {
      for(np = cp; isdigit(*np); *np++);
      *np = 0;
      num = atoi(cp);
      break;
    }
  }

  /* If num is stil -1, we missed the number.  Ooops.  */ 
  if(num == -1) {
    printf("no-number\n");
    exit(1);
  }

  return(num);
}


writefile(fd, num)
int fd, num;
{
  char buf[FILESIZE], *cp;
  int length;

  /* Open NUMFILE for reading. */
  if((fd = open(NUMFILE, O_RDWR | O_TRUNC)) == -1 ) {
    printf("no-writefile\n");
    exit(1);
  }

  /* Print the new file to the buffer. */
  sprintf(buf, "%s%s%s%s%s%d\n",
   "# This file contains the number of the current RT transaction/serial #, or\n",
   "# one less than the next number to be allocated.\n",
   "#\n",
   "# Please do not edit this file... it is autogenerated.\n",
   "#\n",
   num);

  for(length=0,cp=buf; *cp; cp++,length++);

  /* Dump it. */
  if(write(fd, buf, length) == -1) {
    printf("no-file-write\n");
    exit(1);
  }

  /* Chop it off, just in case garbage colleted there. */
  if(ftruncate(fd, length) == -1) {
    printf("no-file-truncate\n");
    exit(1);
  }
}  


unlockfile(fd) 
int fd;
{
  if(lockf(fd, F_ULOCK, 0)) {
    printf("no-unlock-file\n");
    exit(1);
  }

  if(close(fd) == -1) {
    printf("no-file-close\n");
    exit(1);
  }
}
