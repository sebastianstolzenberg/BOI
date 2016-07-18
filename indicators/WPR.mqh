//+------------------------------------------------------------------+
//|                                                          WPR.mqh |
//+------------------------------------------------------------------+
#property copyright "Sebastian Stolzenberg"
#property version   "1.00"

#include "ShiftedIndicator.mqh"
//+------------------------------------------------------------------+
const double WPR_MININMUM = -100;
const double WPR_MAXIMUM = 0;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class WPR : public ShiftedIndicator
  {
private:
  double             upperThreshold_;
  double             lowerThreshold_;

public:
  double             dataBuffer[];
  double             colorBuffer[];

                     WPR();
                    ~WPR();

  bool               configure(int period);

  void               setThresholds(double upperThreshold, double lowerThreshold);

  void               setBuffers(double& dataBuffer[],
                                double& colorBuffer[]);

  int                doCalculateAndCopy(int rates_total,
                                        int prev_calculated,
                                        int valuesToCopy); 
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
WPR::WPR()
  : upperThreshold_(-10)
  , lowerThreshold_(-90)
  {
    setValueRange(WPR_MININMUM, WPR_MAXIMUM);
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
  // ::Print(__FUNCTION__, " > period = ", period);
  
  setPeriod(period);
  setHandle(iWPR("", Period(), period));

  return getHandle() != INVALID_HANDLE;
  }

void WPR::setThresholds(double upperThreshold, double lowerThreshold)
  {
  // ::Print(__FUNCTION__, 
  //         " > upperThreshold = ", upperThreshold,
  //          ", lowerThreshold = ", lowerThreshold);
  upperThreshold_ = upperThreshold;
  lowerThreshold_ = lowerThreshold;

  redraw();
  }

int WPR::doCalculateAndCopy(int rates_total,
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
