//+------------------------------------------------------------------+
//|                                                          BOI.mq5 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp"
#property link      "https://www.mql5.com"
#property version   "1.00"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_plots   1 

//--- set limit of the indicator values 
#property indicator_minimum -100 
#property indicator_maximum 0 

#property indicator_label1  "WPR" 
#property indicator_color1  clrGreen
#property indicator_type1   DRAW_LINE
#property indicator_width1  1
#property indicator_minimum -100 
#property indicator_maximum 0 

#include "ControlWindow.mqh"
#include "indicators/WPR.mqh"

//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+
//---- buffers
double wprBuffer_[];


CControlWindow controlWindow_;

class IndicatorParameters : public IControlWindowListener
{
public:
  IndicatorParameters()
    : wprPreviouslyCalculated_(0)
  {
    controlWindow_.GetWprParameters(wprEnabled_, wprPeriod_, wprUpperThreshold_, wprLowerThreshold_);
  }

  ~IndicatorParameters()
  {
  }

  void OnControlWindowChanged()
  {
    double wprPeriod;
    controlWindow_.GetWprParameters(wprEnabled_, wprPeriod, wprUpperThreshold_, wprLowerThreshold_);
    if (wprPeriod != wprPeriod_)
    {
      wprPeriod_ = wprPeriod;
      InitializeWpr();
    }
  }

  bool wprEnabled_;
  double wprPeriod_;
  double wprUpperThreshold_;
  double wprLowerThreshold_;
  int wprPreviouslyCalculated_;
};
IndicatorParameters parameters_;

int wprHandle_ = INVALID_HANDLE;

bool InitializeWpr()
{
  if (wprHandle_ != INVALID_HANDLE)
  {
    IndicatorRelease(wprHandle_);
    wprHandle_ = INVALID_HANDLE;
  }

  bool wprEnabled;
  double wprPeriod;
  double wprUpperThreshold;
  double wprLowerThreshold;
  controlWindow_.GetWprParameters(wprEnabled, wprPeriod, wprUpperThreshold, wprLowerThreshold);

  int period = wprPeriod;
  wprHandle_ = iWPR("", Period(), period);
  
  parameters_.wprPreviouslyCalculated_ = 0;
  
  return wprHandle_ != INVALID_HANDLE;
}
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
    SetIndexBuffer(0,wprBuffer_);

    controlWindow_.SetListener(parameters_);
    controlWindow_.OnInitEvent();
    if (!controlWindow_.CreateTradePanel())
    {
      ::Print(__FUNCTION__," > Failed to create graphical interface!");
      return INIT_FAILED;
    }
 
    if (!InitializeWpr())
    {
      return INIT_FAILED;
    }

 
    return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Indicator deinitialization function                              |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
    controlWindow_.OnDeinitEvent(reason);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(void)
  {
  int counted_bars=Bars(Symbol(),Period());

  if (counted_bars > parameters_.wprPreviouslyCalculated_)
    {
    parameters_.wprPreviouslyCalculated_ = 
      CalculateWpr(counted_bars, parameters_.wprPreviouslyCalculated_, 0);
    }
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
    controlWindow_.OnTimerEvent();
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
  controlWindow_.ChartEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int CalculateWpr(const int rates_total,
                 const int prev_calculated,
                 const int begin)
  {
  bool wprEnabled;
  double wprPeriod;
  double wprUpperThreshold;
  double wprLowerThreshold;
  controlWindow_.GetWprParameters(wprEnabled, wprPeriod, wprUpperThreshold, wprLowerThreshold);
   
  if (rates_total < wprPeriod - 1)
    return(0);
    
  int valuesToCopy; 
  if(parameters_.wprPreviouslyCalculated_>rates_total || 
     parameters_.wprPreviouslyCalculated_<=0) 
    valuesToCopy = rates_total; 
  else 
  { 
    valuesToCopy = rates_total - parameters_.wprPreviouslyCalculated_; 
  } 

  CopyBuffer(wprHandle_,0,parameters_.wprPreviouslyCalculated_,valuesToCopy,wprBuffer_);
//--- return value of prev_calculated for next call
  parameters_.wprPreviouslyCalculated_ = rates_total;
  return(rates_total);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const int begin,
                const double &price[])
  {
  int wprTotal = CalculateWpr(rates_total, prev_calculated, begin);
  return(wprTotal);
  }

//+------------------------------------------------------------------+
