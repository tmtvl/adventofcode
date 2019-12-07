#include <stdio.h>
#include <string.h>

int zero_pad(char *tgt, char *in, int pad, int copy)
{
  int i;

  for (i = 0; i < pad; i++)
    {
      tgt[i] = '0';
    }

  strncpy(&tgt[i], in, copy);

  return 0;
}

int is_valid_candidate(char *candidate)
{
  int i;
  char cur;
  char prev = candidate[0];
  char duplicate_char = '\0';
  int duplicate = 0;
  char duplicate_lock = 0;

  for (i = 1; i < 6; i++) {
    cur = candidate[i];

    if (cur < prev)
      {
	return 0;
      }
    if (cur == prev)
      {
	if (duplicate == 1)
	  {
	    duplicate = 0;
	    duplicate_char = cur;
	  }
	else if (cur != duplicate_char)
	  {
	    duplicate = 1;
	  }
      }
    else if (duplicate == 1)
      {
	duplicate = 0;
	duplicate_lock = 1;
      }
    
    prev = cur;
  }

  if (duplicate == 1)
    {
      duplicate_lock = 1;
    }
  
  return duplicate_lock;
}

void next_candidate(char *candidate)
{
  int i;

  for (i = 5; i >=0; i--) {
    if (candidate[i] == '9')
      {
	candidate[i] = '0';
      }
    else
      {
	candidate[i]++;
	return;
      }
  }
}

int find_candidates(char *start, char *end)
{
  int candidates = 0;
  char current[] = "000000";
  strncpy(current, start, 6);

  while (strncmp(current, end, 6) <= 0)
    {
      if (is_valid_candidate(current) == 1)
	{
	  printf("%s\n", current);
	  candidates++;
	}

      next_candidate(current);
    }

  return candidates;
}

int main(int argc, char **argv)
{
  char start[] = "000000";
  char end[] = "000000";
  int slen, elen;
  
  if (argc != 3)
    {
      printf("Please provide 2 numbers\n");
      return 1;
    }

  slen = strlen(argv[1]);
  elen = strlen(argv[2]);

  if (slen > 6 || elen > 6)
    {
      printf("Please keep the inputs limited to maximum 6 characters.\n");
      return 1;
    }

  zero_pad(start, argv[1], 6 - slen, slen);
  zero_pad(end, argv[2], 6 - elen, elen);

  printf("%i\n", find_candidates(start, end));

  return 0;
}
