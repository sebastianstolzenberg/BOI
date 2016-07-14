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

  color              noSignalColor_;
  color              signalColor_;

  int                previouslyCalculated_;

public:
                     WPR();
                    ~WPR();

  bool               configure(int period);

  void               setColors(color noSignalColor, color signalColor);

  void               setThresholds(double upperThreshold, double lowerThreshold);

  int                calculateAndCopy(int start_pos, int count, double& buffer[]);
  int                calculateAndCopy(int rates_total, 
                                      int prev_calculated, 
                                      int begin, 
                                      double& dataBuffer[],
                                      double& colorBuffer[]);

  void               redraw();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
WPR::WPR()
  : handle_(INVALID_HANDLE)
  , enabled_(false)
  , period_(1)
  , upperThreshold_(-10)
  , lowerThreshold_(-90)
  , noSignalColor_(clrGreen)
  , signalColor_(clrRed)
  , previouslyCalculated_(0)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
WPR::~WPR()
  {
  }
//+------------------------------------------------------------------+
bool WPR::configure(int period)
  {
  ::Print(__FUNCTION__, " > period = ", period);
  
  period_ = period;
  
  if (handle_ != INVALID_HANDLE)
    {
    IndicatorRelease(handle_);
    handle_ = INVALID_HANDLE;
    }

  handle_ = iWPR("", Period(), period_);

  redraw();

  return handle_ != INVALID_HANDLE;
  }

void WPR::setColors(color noSignalColor, color signalColor)
{
  noSignalColor_ = noSignalColor;
  signalColor_ = signalColor;

  redraw();
}

void WPR::setThresholds(double upperThreshold, double lowerThreshold)
  {
  ::Print(__FUNCTION__, 
          " > upperThreshold = ", upperThreshold,
           ", lowerThreshold = ", lowerThreshold);
  upperThreshold_ = upperThreshold;
  lowerThreshold_ = lowerThreshold;

  redraw();
  }

int WPR::calculateAndCopy(int start_pos, int count, double& buffer[])
  { 
  ::Print(__FUNCTION__, " > start_pos = ", start_pos, ", count = ", count);
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

int WPR::calculateAndCopy(int rates_total, int prev_calculated, int begin, 
                          double& dataBuffer[], double& colorBuffer[])
  {  
  if (rates_total == prev_calculated && prev_calculated == previouslyCalculated_)
  {
    // skip if no recalculations need to be done
    return rates_total;
  }

  ::Print(__FUNCTION__, " > rates_total = ", rates_total, 
                         ", prev_calculated = ", prev_calculated,
                         ", previouslyCalculated_ = ", previouslyCalculated_,
                         ", begin = ", begin);

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

  CopyBuffer(handle_,0,prev_calculated,valuesToCopy,dataBuffer);

  // color and shift
  for (int i = prev_calculated; i < prev_calculated + valuesToCopy; ++i)
    {
    // color
    if (dataBuffer[i] < lowerThreshold_ || dataBuffer[i] > upperThreshold_)
      colorBuffer[i] = 1;
    else
      colorBuffer[i] = 0;
    // shift
    dataBuffer[i] += 50;
    }

  previouslyCalculated_ = rates_total;
  return rates_total;
  }

void WPR::redraw()
{
  previouslyCalculated_ = 0;
}