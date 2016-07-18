//+------------------------------------------------------------------+
//|                                                          RSI.mqh |
//+------------------------------------------------------------------+
#property copyright "Sebastian Stolzenberg"
#property version   "1.00"

#include "ShiftedIndicator.mqh"
//+------------------------------------------------------------------+
const double RSI_MININMUM = 0;
const double RSI_MAXIMUM = 100;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class RSI : public ShiftedIndicator
  {
private:
  double             upperThreshold_;
  double             lowerThreshold_;

public:
  double             dataBuffer[];
  double             colorBuffer[];

                     RSI();
                    ~RSI();

  bool               configure(int period);

  void               setThresholds(double upperThreshold, double lowerThreshold);

  int                doCalculateAndCopy(int rates_total,
                                      int prev_calculated,
                                      int valuesToCopy); 
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
RSI::RSI()
  : upperThreshold_(-10)
  , lowerThreshold_(-90)
  {
    setValueRange(RSI_MININMUM, RSI_MAXIMUM);
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
  // ::Print(__FUNCTION__, " > period = ", period);
  
  setPeriod(period);
  setHandle(iRSI("", Period(), period, PRICE_CLOSE));

  return getHandle() != INVALID_HANDLE;
  }

void RSI::setThresholds(double upperThreshold, double lowerThreshold)
  {
  // ::Print(__FUNCTION__, 
  //         " > upperThreshold = ", upperThreshold,
  //          ", lowerThreshold = ", lowerThreshold);
  upperThreshold_ = upperThreshold;
  lowerThreshold_ = lowerThreshold;

  redraw();
  }

int RSI::doCalculateAndCopy(int rates_total,
                            int prev_calculated,
                            int valuesToCopy)
  {
  CopyBuffer(getHandle(),0,prev_calculated,valuesToCopy,dataBuffer);

  // color and shift
  for (int i = prev_calculated; i < prev_calculated + valuesToCopy; ++i)
    {
    // color
    if (dataBuffer[i] < lowerThreshold_)
      colorBuffer[i] = 1;
    else if (dataBuffer[i] > upperThreshold_)
      colorBuffer[i] = 2;
    else
      colorBuffer[i] = 0;
    // shift
    dataBuffer[i] = shiftValue(dataBuffer[i]);
    }

  return rates_total;
  }
