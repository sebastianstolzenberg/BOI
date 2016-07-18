//+------------------------------------------------------------------+
//|                                                          CCI.mqh |
//+------------------------------------------------------------------+
#property copyright "Sebastian Stolzenberg"
#property version   "1.00"

#include "ShiftedIndicator.mqh"
//+------------------------------------------------------------------+
const double CCI_MININMUM = -100;
const double CCI_MAXIMUM = 100;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CCI : public ShiftedIndicator
  {
private:
  double             upperThreshold_;
  double             lowerThreshold_;

public:
  double             dataBuffer[];
  double             colorBuffer[];

                     CCI();
                    ~CCI();

  bool               configure(int period);

  void               setThresholds(double upperThreshold, double lowerThreshold);

  int                doCalculateAndCopy(int rates_total,
                                        int prev_calculated,
                                        int valuesToCopy); 
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCI::CCI()
  : upperThreshold_(-10)
  , lowerThreshold_(-90)
  {
    setValueRange(CCI_MININMUM, CCI_MAXIMUM);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCI::~CCI()
  {
  }
//+------------------------------------------------------------------+
bool CCI::configure(int period)
  {
  // ::Print(__FUNCTION__, " > period = ", period);
  
  setPeriod(period);
  setHandle(iCCI("", Period(), period, PRICE_CLOSE));

  return getHandle() != INVALID_HANDLE;
  }

void CCI::setThresholds(double upperThreshold, double lowerThreshold)
  {
  // ::Print(__FUNCTION__, 
  //         " > upperThreshold = ", upperThreshold,
  //          ", lowerThreshold = ", lowerThreshold);
  upperThreshold_ = upperThreshold;
  lowerThreshold_ = lowerThreshold;

  redraw();
  }

int CCI::doCalculateAndCopy(int rates_total,
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