//+------------------------------------------------------------------+
//|                                                          BOI.mq5 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp"
#property link      "https://www.mql5.com"
#property version   "1.00"

// #property indicator_separate_window
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_plots   2

//--- set limit of the indicator values 
// #property indicator_minimum -50 
// #property indicator_maximum 50 

#property indicator_label1  "WPR" 
#property indicator_color1  Green,Red
#property indicator_type1   DRAW_COLOR_ARROW
#property indicator_width1  1

#property indicator_label2  "RSI" 
#property indicator_color2  Blue,Red
#property indicator_type2   DRAW_COLOR_ARROW
#property indicator_width2  1
// #property indicator_label2  "WPR color" 
// #property indicator_color2  clrRed
// #property indicator_type2   DRAW_LINE
// #property indicator_width2  1

#include "ControlWindow.mqh"
#include "indicators/WPR.mqh"
#include "indicators/RSI.mqh"

//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+
//---- buffers
double wprBuffer_[];
double wprColorBuffer_[];

double rsiBuffer_[];
double rsiColorBuffer_[];

double chartMin_;
double chartMax_;
double wprMin_;
double wprMax_;

WPR wpr_;
RSI rsi_;
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

      case CWC_RSI_PERIOD:
        InitializeRsi();
        break;

      case CWC_RSI_THRESHOLD:
        rsi_.setThresholds(controlWindow_.GetRsiUpperThreshold(),
                           controlWindow_.GetRsiLowerThreshold());
        break;

      default:
        break;
      }
  }
};
IndicatorParameters parameters_;

//+------------------------------------------------------------------+ 
//| Gets the value of chart's fixed maximum                          | 
//+------------------------------------------------------------------+ 
double ChartFixedMaxGet(const long chart_ID=0) 
  { 
//--- prepare the variable to get the result 
   double result=EMPTY_VALUE; 
//--- reset the error value 
   ResetLastError(); 
//--- receive the property value 
   if(!ChartGetDouble(chart_ID,CHART_FIXED_MAX,0,result)) 
     { 
      //--- display the error message in Experts journal 
      Print(__FUNCTION__+", Error Code = ",GetLastError()); 
     } 
//--- return the value of the chart property 
   return(result); 
  } 

  //+------------------------------------------------------------------+ 
//| Gets the value of chart's fixed minimum                          | 
//+------------------------------------------------------------------+ 
double ChartFixedMinGet(const long chart_ID=0) 
  { 
//--- prepare the variable to get the result 
   double result=EMPTY_VALUE; 
//--- reset the error value 
   ResetLastError(); 
//--- receive the property value 
   if(!ChartGetDouble(chart_ID,CHART_FIXED_MIN,0,result)) 
     { 
      //--- display the error message in Experts journal 
      Print(__FUNCTION__+", Error Code = ",GetLastError()); 
     } 
//--- return the value of the chart property 
   return(result); 
  } 
  
bool InitializeWpr()
  {
  ::Print(__FUNCTION__);
  wpr_.setThresholds(controlWindow_.GetWprUpperThreshold(),
                     controlWindow_.GetWprLowerThreshold());
  int period = controlWindow_.GetWprPeriod();
  return wpr_.configure(period);
  }

bool InitializeRsi()
  {
  ::Print(__FUNCTION__);
  rsi_.setThresholds(controlWindow_.GetRsiUpperThreshold(),
                     controlWindow_.GetRsiLowerThreshold());
  int period = controlWindow_.GetRsiPeriod();
  return rsi_.configure(period);
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
    SetIndexBuffer(2,rsiBuffer_,INDICATOR_DATA);
    SetIndexBuffer(3,rsiColorBuffer_,INDICATOR_COLOR_INDEX);

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

    if (!InitializeRsi())
    {
      ::Print(__FUNCTION__," > Failed to create RSI indicator!");
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

  if (id == CHARTEVENT_CHART_CHANGE)
    {
    double chartMin = ChartFixedMinGet();
    double chartMax = ChartFixedMaxGet();

    double wprMin = chartMin;
    double wprMax = (chartMax - chartMin) * 0.1 + wprMin;
    wpr_.setDrawRange(wprMin, wprMax);

    double rsiMin = wprMax;
    double rsiMax = (chartMax - chartMin) * 0.1 + rsiMin;
    rsi_.setDrawRange(rsiMin, rsiMax);
    }
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
  int wprTotal = wpr_.calculateAndCopy(rates_total, prev_calculated, 
                          begin, wprBuffer_, wprColorBuffer_);

  int rsiTotal = rsi_.calculateAndCopy(rates_total, prev_calculated, 
                          begin, rsiBuffer_, rsiColorBuffer_);

  return (wprTotal>rsiTotal ? rsiTotal : wprTotal);
  }

//+------------------------------------------------------------------+
