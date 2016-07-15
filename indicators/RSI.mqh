//+------------------------------------------------------------------+
//|                                                          RSI.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
const double RSI_MININMUM = 0;
const double RSI_MAXIMUM = 100;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class RSI
  {
private:
  int                handle_;
  bool               enabled_;
  int                period_;
  double             upperThreshold_;
  double             lowerThreshold_;

  color              noSignalColor_;
  color              signalColor_;


  double             drawRangeMin_;
  double             drawRangeMax_;
  int                previouslyCalculated_;

public:
                     RSI();
                    ~RSI();

  bool               configure(int period);

  void               setColors(color noSignalColor, color signalColor);

  void               setThresholds(double upperThreshold, double lowerThreshold);

  void               setDrawRange(double min, double max);

  double             ShiftValue(double value);
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
RSI::RSI()
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
RSI::~RSI()
  {
  }
//+------------------------------------------------------------------+
bool RSI::configure(int period)
  {
  ::Print(__FUNCTION__, " > period = ", period);
  
  period_ = period;
  
  if (handle_ != INVALID_HANDLE)
    {
    IndicatorRelease(handle_);
    handle_ = INVALID_HANDLE;
    }

  handle_ = iRSI("", Period(), period_, PRICE_CLOSE);

  redraw();

  return handle_ != INVALID_HANDLE;
  }

void RSI::setColors(color noSignalColor, color signalColor)
{
  noSignalColor_ = noSignalColor;
  signalColor_ = signalColor;

  redraw();
}

void RSI::setThresholds(double upperThreshold, double lowerThreshold)
  {
  ::Print(__FUNCTION__, 
          " > upperThreshold = ", upperThreshold,
           ", lowerThreshold = ", lowerThreshold);
  upperThreshold_ = upperThreshold;
  lowerThreshold_ = lowerThreshold;

  redraw();
  }

void RSI::setDrawRange(double min, double max)
{
  if (drawRangeMin_ != min || drawRangeMax_ != max)
  {
    drawRangeMin_ = min;
    drawRangeMax_ = max;
    redraw();
  }
}

double RSI::ShiftValue(double value)
{
  return (value - RSI_MININMUM) / (RSI_MAXIMUM - RSI_MININMUM) * 
         (drawRangeMax_-drawRangeMin_) + drawRangeMin_;
}

int RSI::calculateAndCopy(int rates_total, int prev_calculated, int begin, 
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
    dataBuffer[i] = ShiftValue(dataBuffer[i]);
    }

  previouslyCalculated_ = rates_total;
  return rates_total;
  }

void RSI::redraw()
{
  previouslyCalculated_ = 0;
}