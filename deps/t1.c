#include <stdio.h>

extern int dmcall1(const double mu,const double bound,const double dt,const double tmax,double *g1,double *g2);

int main(int argc,char *argv[])
{
  double g1[400],g2[400];
  
  dmcall1(0.1,0.2,0.3,0.4,g1,g2);

  return 0;
}
  
