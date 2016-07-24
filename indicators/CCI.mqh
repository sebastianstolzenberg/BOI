//+------------------------------------------------------------------+
//|                                                          CCI.mqh |
//+------------------------------------------------------------------+

#include "ShiftedIndicator.mqh"
//+------------------------------------------------------------------+
const double CCI_MININMUM = -140;
const double CCI_MAXIMUM = 140;

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
  releaseHandle();
  setHandle(iCCI("", Period(), period, PRICE_CLOSE));

  return getHandle() != INVALID_HANDLE;
  }
