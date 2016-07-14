//+------------------------------------------------------------------+
//|                                                          BOI.mq5 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp"
#property link      "https://www.mql5.com"
#property version   "1.00"

#property indicator_separate_window
// #property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   1

//--- set limit of the indicator values 
#property indicator_minimum -50 
#property indicator_maximum 50 

#property indicator_label1  "WPR" 
#property indicator_color1  Green,Red
#property indicator_type1   DRAW_COLOR_HISTOGRAM
#property indicator_width1  1

// #property indicator_label2  "WPR color" 
// #property indicator_color2  clrRed
// #property indicator_type2   DRAW_LINE
// #property indicator_width2  1

#include "ControlWindow.mqh"
#include "indicators/WPR.mqh"

//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+
//---- buffers
double wprBuffer_[];
double wprColorBuffer_[];


WPR wpr_;
CControlWindow controlWindow_;


class IndicatorParameters : public IControlWindowListener
{
public:
  IndicatorParameters()
  {
  }

  ~IndicatorParameters()
  {
  }

  void OnControlWindowChanged(ControlWindowChange change)
  {
    // ::Print(__FUNCTION__);
    switch (change)
      {
      case CWC_WPR_PERIOD:
        InitializeWpr();
        break;

      case CWC_WPR_THRESHOLD:
        wpr_.setThresholds(controlWindow_.GetWprUpperThreshold(),
                           controlWindow_.GetWprLowerThreshold());
        break;

      default:
        break;
      }
  }
};
IndicatorParameters parameters_;

bool InitializeWpr()
  {
  ::Print(__FUNCTION__);
  wpr_.setThresholds(controlWindow_.GetWprUpperThreshold(),
                     controlWindow_.GetWprLowerThreshold());
  int period = controlWindow_.GetWprPeriod();
  return wpr_.configure(period);
  }

void RedrawChangedIndicators()
  {
  // int counted_bars=Bars(Symbol(),Period());

  // ::Print(__FUNCTION__," > parameters_.wprPreviouslyCalculated_ = ", parameters_.wprPreviouslyCalculated_);
  // if (counted_bars > parameters_.wprPreviouslyCalculated_)
  //   {
  //   ::Print(__FUNCTION__," > Redrawing WPR!");
  //   parameters_.wprPreviouslyCalculated_ = 
  //     CalculateWpr(counted_bars, parameters_.wprPreviouslyCalculated_, 0);
  //   }
  }

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
  ::Print(__FUNCTION__);
    SetIndexBuffer(0,wprBuffer_,INDICATOR_DATA);
    SetIndexBuffer(1,wprColorBuffer_,INDICATOR_COLOR_INDEX);
    // PlotIndexSetInteger(0,PLOT_COLOR_INDEXES,2);
    // PlotIndexSetInteger(0,PLOT_LINE_COLOR,0,Green);
    // PlotIndexSetInteger(0,PLOT_LINE_COLOR,1,Red);

    controlWindow_.SetListener(parameters_);
    controlWindow_.OnInitEvent();
    if (!controlWindow_.CreateTradePanel())
    {
      ::Print(__FUNCTION__," > Failed to create graphical interface!");
      return INIT_FAILED;
    }
 
    if (!InitializeWpr())
    {
      ::Print(__FUNCTION__," > Failed to create WPR indicator!");
      return INIT_FAILED;
    }

 
    return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Indicator deinitialization function                              |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  ::Print(__FUNCTION__, " > reason = ", reason);
  controlWindow_.OnDeinitEvent(reason);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(void)
  {
  // ::Print(__FUNCTION__);
  // RedrawChangedIndicators();
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
    // ::Print(__FUNCTION__);
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
  // ::Print(__FUNCTION__);
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
  return wpr_.calculateAndCopy(rates_total, prev_calculated, begin, 
                               wprBuffer_, wprColorBuffer_);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const int begin,
                const double &price[])
  {
  // ::Print(__FUNCTION__);
  int wprTotal = CalculateWpr(rates_total, prev_calculated, begin);
  return(wprTotal);
  }

//+------------------------------------------------------------------+
