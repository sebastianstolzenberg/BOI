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
public:
                     WPR();
                    ~WPR();

  bool               configure(int period);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
WPR::WPR()
  {
    setValueRange(WPR_MININMUM, WPR_MAXIMUM);
    setThresholds(WPR_MAXIMUM,WPR_MININMUM);
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
