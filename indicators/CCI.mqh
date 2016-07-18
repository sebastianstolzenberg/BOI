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
public:
                     CCI();
                    ~CCI();

  bool               configure(int period);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCI::CCI()
  {
    setValueRange(CCI_MININMUM, CCI_MAXIMUM);
    setThresholds(CCI_MAXIMUM, CCI_MININMUM);
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
