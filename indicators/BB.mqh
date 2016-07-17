//+------------------------------------------------------------------+
//|                                                          BB.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class BB
  {
private:
  int                handle_;
  bool               enabled_;
  int                period_;
  int                shift_;
  double             deviation_;

  int                previouslyCalculated_;

public:
                     BB();
                    ~BB();

  bool               configure(int period, int shift, double deviation);

  int                calculateAndCopy(int rates_total, 
                                      int prev_calculated, 
                                      int begin,
                                      double& upperBuffer[],
                                      double& middleBuffer[],
                                      double& lowerBuffer[]);

  void               redraw();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BB::BB()
  : handle_(INVALID_HANDLE)
  , enabled_(false)
  , period_(20)
  , shift_(0)
  , deviation_(2)
  , previouslyCalculated_(0)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BB::~BB()
  {
  }
//+------------------------------------------------------------------+
bool BB::configure(int period, int shift, double deviation)
  {
  ::Print(__FUNCTION__, " > period = ", period, 
                         ", shift = ", shift,
                         ", deviation = ", deviation);
  
  period_ = period;
  shift_ = shift;
  deviation_ = deviation;

  if (handle_ != INVALID_HANDLE)
    {
    IndicatorRelease(handle_);
    handle_ = INVALID_HANDLE;
    }

  handle_ = iBands("", Period(), period_, shift_, deviation_, PRICE_CLOSE);

  redraw();

  return handle_ != INVALID_HANDLE;
  }

int BB::calculateAndCopy(int rates_total, int prev_calculated, int begin, 
                         double& upperBuffer[], double& middleBuffer[], double& lowerBuffer[])
  {  
  if (rates_total == prev_calculated && prev_calculated == previouslyCalculated_)
  {
    // skip if no recalculations need to be done
    return rates_total;
  }

  if (rates_total < period_ - 1)
      return(0);
      
  if (prev_calculated > previouslyCalculated_)
  {
    prev_calculated = previouslyCalculated_;
  }

  int valuesToCopy; 
  if(prev_calculated>rates_total || 
     prev_calculated<=0) 
    valuesToCopy = rates_total; 
  else 
    valuesToCopy = rates_total - prev_calculated; 

  ::Print(__FUNCTION__, " > rates_total = ", rates_total, 
                         ", prev_calculated = ", prev_calculated,
                         ", previouslyCalculated_ = ", previouslyCalculated_,
                         ", begin = ", begin,
                         ", valuesToCopy = ", valuesToCopy);

  CopyBuffer(handle_,0,prev_calculated,valuesToCopy,middleBuffer);
  CopyBuffer(handle_,1,prev_calculated,valuesToCopy,upperBuffer);
  CopyBuffer(handle_,2,prev_calculated,valuesToCopy,lowerBuffer);

  previouslyCalculated_ = rates_total;
  return rates_total;
  }

void BB::redraw()
{
  previouslyCalculated_ = 0;
}