//+------------------------------------------------------------------+
//|                                                          WPR.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class WPR
  {
private:
  int                handle_;
  bool               enabled_;
  int                period_;
  double             upperThreshold_;
  double             lowerThreshold_;

public:
                     WPR();
                    ~WPR();

  bool               configure(int period, double upperThreshold, double lowerThreshold);
  
  void               setParameters(int period, double upperThreshold, double lowerThreshold);

  int                calculateAndCopy(int start_pos, int count, double& buffer[]);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
WPR::WPR()
  : handle_(INVALID_HANDLE)
  , enabled_(false)
  , period_(1)
  , upperThreshold_(0)
  , lowerThreshold_(-100)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
WPR::~WPR()
  {
  }
//+------------------------------------------------------------------+
bool WPR::configure(int period, double upperThreshold, double lowerThreshold)
  {
  upperThreshold_ = upperThreshold;
  lowerThreshold_ = lowerThreshold;

  if (handle_ != INVALID_HANDLE)
    {
    IndicatorRelease(handle_);
    handle_ = INVALID_HANDLE;
    }

  handle_ = iWPR("", 0, period_);

  return handle_ != INVALID_HANDLE;
  }

int WPR::calculateAndCopy(int start_pos, int count, double& buffer[])
  { 
/*  if (rates_total < wprPeriod - 1)
    return(0);
    
  int valuesToCopy; 
  if(parameters_.wprPreviouslyCalculated_>rates_total || 
     parameters_.wprPreviouslyCalculated_<=0) 
    valuesToCopy = rates_total; 
  else 
  { 
    valuesToCopy = rates_total - parameters_.wprPreviouslyCalculated_; 
  } 
*/
  CopyBuffer(handle_,0,start_pos,count,buffer);
  return (count);
  }