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
  
  int randxxx(double *mu,long int mu_len,
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
  
#if 0  
  int fpt(double mu,double bound,const double dt,const double tmax,double *g1,double *g2)
  {
    ExtArray e_mu(ExtArray::shared_noowner(&mu),1),e_bound(ExtArray::shared_noowner(&bound),1);
    int n_max=(int)ceil(tmax/dt);
    DMBase *dm=DMBase::create(e_mu,e_bound,dt);
    ExtArray e_g1(ExtArray::shared_noowner(g1),n_max),e_g2(ExtArray::shared_noowner(g2),n_max);

    dm->pdfseq(n_max,e_g1,e_g2);
    delete dm;

    return 0;
  }

  int fpt_driftrange(double *mu,long int mu_len,double bound,const double dt,const double tmax,double *g1,double *g2)
  {
    ExtArray e_mu(ExtArray::shared_noowner(mu),mu_len),e_bound(ExtArray::shared_noowner(&bound),1);
    int n_max=(int)ceil(tmax/dt);
    DMBase *dm=DMBase::create(e_mu,e_bound,dt);
    ExtArray e_g1(ExtArray::shared_noowner(g1),n_max),e_g2(ExtArray::shared_noowner(g2),n_max);

    dm->pdfseq(n_max,e_g1,e_g2);
    delete dm;

    return 0;
  }

  int rand_asym(double mu,double bound_lo,double bound_hi,double dt_rand,long int n,long int seed,double *t,long int *bound_cond)
  {

    fprintf(stderr,"---> bound lo %f bound hi %f\n",bound_lo,bound_hi);
    
    /*
      # mu::Float64=1.0
      # bound_lo::Float64=-1.5
      # bound_hi::Float64=1.0
      # dt_rand::Float64=0.001
      # n::Int32=10000
      # seed::Int32=0

    */
    ExtArray e_mu(ExtArray::shared_noowner(&mu),1),
             e_bound_lo(ExtArray::shared_noowner(&bound_lo),1),
             e_bound_hi(ExtArray::shared_noowner(&bound_hi),1);

    DMBase *dm=DMBase::create(mu,ExtArray::const_array(1.0),e_bound_lo,e_bound_hi,
                              ExtArray::const_array(0.0),ExtArray::const_array(0.0),dt_rand);

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
#endif  
}


