//+------------------------------------------------------------------+
//|                                                          MFI.mqh |
//+------------------------------------------------------------------+
#property copyright "Sebastian Stolzenberg"
#property version   "1.00"

#include "ShiftedIndicator.mqh"
//+------------------------------------------------------------------+
const double MFI_MININMUM = 0;
const double MFI_MAXIMUM = 100;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MFI : public ShiftedIndicator
  {
public:
                     MFI();
                    ~MFI();

  bool               configure(int period);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MFI::MFI()
  {
    setValueRange(MFI_MININMUM, MFI_MAXIMUM);
    setThresholds(MFI_MAXIMUM, MFI_MININMUM);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MFI::~MFI()
  {
  }
//+------------------------------------------------------------------+
bool MFI::configure(int period)
  {
  // ::Print(__FUNCTION__, " > period = ", period);
  
  setPeriod(period);
  setHandle(iMFI("", Period(), period, VOLUME_REAL));

  return getHandle() != INVALID_HANDLE;
  }
