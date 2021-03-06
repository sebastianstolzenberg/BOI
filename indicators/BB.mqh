//+------------------------------------------------------------------+
//|                                                           BB.mqh |
//+------------------------------------------------------------------+

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
  double             upperBuffer[];
  double             middleBuffer[];
  double             lowerBuffer[];

                     BB();
                    ~BB();

  bool               configure(int period, int shift, double deviation);

  bool               isEnabled() const;
  void               setEnabled(bool enabled);

  bool               acceptsSell(double value, int index);
  bool               acceptsBuy(double value, int index);

  int                calculateAndCopy(int rates_total, 
                                      int prev_calculated);

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
  // ::Print(__FUNCTION__, " > period = ", period, 
  //                        ", shift = ", shift,
  //                        ", deviation = ", deviation);
  
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

bool BB::isEnabled() const
{
  return enabled_;
}

void BB::setEnabled(bool enabled)
{
  ::Print(__FUNCTION__, " > enabled = ", enabled);
  if (enabled_ != enabled)
  {
    enabled_ = enabled;
    redraw();
  }
}

bool BB::acceptsSell(double value, int index)
{
  return !enabled_ || value > upperBuffer[index];
}

bool BB::acceptsBuy(double value, int index)
{
  return !enabled_ || value < lowerBuffer[index];
}

int BB::calculateAndCopy(int rates_total, int prev_calculated)
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

  // ::Print(__FUNCTION__, " > rates_total = ", rates_total, 
  //                        ", prev_calculated = ", prev_calculated,
  //                        ", previouslyCalculated_ = ", previouslyCalculated_,
  //                        ", begin = ", begin,
  //                        ", valuesToCopy = ", valuesToCopy);

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