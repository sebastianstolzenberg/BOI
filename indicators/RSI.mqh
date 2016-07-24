//+------------------------------------------------------------------+
//|                                                          RSI.mqh |
//+------------------------------------------------------------------+

#include "ShiftedIndicator.mqh"
//+------------------------------------------------------------------+
const double RSI_MININMUM = 0;
const double RSI_MAXIMUM = 100;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class RSI : public ShiftedIndicator
  {
public:
                     RSI();
                    ~RSI();

  bool               configure(int period);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
RSI::RSI()
  {
    setValueRange(RSI_MININMUM, RSI_MAXIMUM);
    setThresholds(RSI_MAXIMUM, RSI_MININMUM);
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
  releaseHandle();
  setHandle(iRSI("", Period(), period, PRICE_CLOSE));

  return getHandle() != INVALID_HANDLE;
  }
