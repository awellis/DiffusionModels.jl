#include "ddm_fpt_lib.h"

extern "C"
{
  int fpt(double *mu,long int mu_len,
	  double *sig,long int sig_len,
	  double *bound_lo,long int bound_lo_len,
	  double *bound_hi,long int bound_hi_len,
	  double dt,double tmax,
	  double *g1,double *g2)
  {
    ExtArray e_mu(ExtArray::shared_noowner(mu),mu_len),
      e_sig(ExtArray::shared_noowner(sig),sig_len),
      e_bound_lo(ExtArray::shared_noowner(bound_lo),bound_lo_len),
      e_bound_hi(ExtArray::shared_noowner(bound_hi),bound_hi_len);
    int n_max=(int)ceil(tmax/dt);
    DMBase *dm=DMBase::create(e_mu,e_sig,e_bound_lo,e_bound_hi,
                              ExtArray::const_array(0.0),ExtArray::const_array(0.0),dt);
    ExtArray e_g1(ExtArray::shared_noowner(g1),n_max),e_g2(ExtArray::shared_noowner(g2),n_max);
    
    dm->pdfseq(n_max,e_g1,e_g2);
    delete dm;

    return 0;
  }
  
  int randvar(double *mu,long int mu_len,
	      double *sig,long int sig_len,
	      double *bound_lo,long int bound_lo_len,
	      double *bound_hi,long int bound_hi_len,
	      double dt,
	      long int n,long int seed,double *t,long int *bound_cond)
  {
    ExtArray e_mu(ExtArray::shared_noowner(mu),mu_len),
      e_sig(ExtArray::shared_noowner(sig),sig_len),
      e_bound_lo(ExtArray::shared_noowner(bound_lo),bound_lo_len),
      e_bound_hi(ExtArray::shared_noowner(bound_hi),bound_hi_len);
    DMBase *dm=DMBase::create(e_mu,e_sig,e_bound_lo,e_bound_hi,
                              ExtArray::const_array(0.0),ExtArray::const_array(0.0),dt);
    DMBase::rngeng_t rngeng;
    rngeng.seed(seed);

    int i;

    for(i=0; i<n; i++)
    {
      DMSample s=dm->rand(rngeng);
      t[i]=s.t();
      
      bound_cond[i]=s.upper_bound() ? 1 : 0;
    }

    delete dm;

    return 0;
  }
}
