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
#property indicator_buffers 9
#property indicator_plots   6

//--- set limit of the indicator values 
// #property indicator_minimum -50 
// #property indicator_maximum 50 

#property indicator_label1  "WPR" 
#property indicator_color1  Green,Red
#property indicator_type1   DRAW_COLOR_LINE
#property indicator_width1  1

#property indicator_label2  "RSI" 
#property indicator_color2  clrDarkTurquoise,Red
#property indicator_type2   DRAW_COLOR_LINE
#property indicator_width2  1

#property indicator_label3  "CCI" 
#property indicator_color3  clrOrchid,Red
#property indicator_type3   DRAW_COLOR_LINE
#property indicator_width3  1

#property indicator_label4  "BB-upper" 
#property indicator_color4  Gray
#property indicator_type4   DRAW_LINE
#property indicator_width4  1
#property indicator_label5  "BB-middle" 
#property indicator_color5  Gray
#property indicator_type5   DRAW_LINE
#property indicator_width5  1
#property indicator_label6  "BB-lower" 
#property indicator_color6  Gray
#property indicator_type6   DRAW_LINE
#property indicator_width6  1


#include "ControlWindow.mqh"
#include "indicators/WPR.mqh"
#include "indicators/RSI.mqh"
#include "indicators/CCI.mqh"

const double INDICATOR_PLOT_HEIGHT = 0.1;
const double INDICATOR_PLOT_SHIFT = 1;

//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+
//---- buffers
double wprBuffer_[];
double wprColorBuffer_[];

double rsiBuffer_[];
double rsiColorBuffer_[];

double cciBuffer_[];
double cciColorBuffer_[];

double bbUpperBuffer_[];
double bbMiddleBuffer_[];
double bbLowerBuffer_[];

double chartMin_;
double chartMax_;
double wprMin_;
double wprMax_;

WPR wpr_;
RSI rsi_;
CCI cci_;
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

      case CWC_CCI_PERIOD:
        InitializeCci();
        break;

      case CWC_CCI_THRESHOLD:
        cci_.setThresholds(controlWindow_.GetCciUpperThreshold(),
                           controlWindow_.GetCciLowerThreshold());
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
   // if(!ChartGetDouble(chart_ID,CHART_FIXED_MAX,0,result)) 
   if(!ChartGetDouble(chart_ID,CHART_PRICE_MAX,0,result)) 
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
   // if(!ChartGetDouble(chart_ID,CHART_FIXED_MIN,0,result)) 
   if(!ChartGetDouble(chart_ID,CHART_PRICE_MIN,0,result)) 
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

bool InitializeCci()
  {
  ::Print(__FUNCTION__);
  cci_.setThresholds(controlWindow_.GetCciUpperThreshold(),
                     controlWindow_.GetCciLowerThreshold());
  int period = controlWindow_.GetCciPeriod();
  return cci_.configure(period);
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
    SetIndexBuffer(4,cciBuffer_,INDICATOR_DATA);
    SetIndexBuffer(5,cciColorBuffer_,INDICATOR_COLOR_INDEX);
    SetIndexBuffer(6,bbUpperBuffer_,INDICATOR_DATA);
    SetIndexBuffer(7,bbMiddleBuffer_,INDICATOR_DATA);
    SetIndexBuffer(8,bbLowerBuffer_,INDICATOR_DATA);
    
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
 
    if (!InitializeCci())
    {
      ::Print(__FUNCTION__," > Failed to create CCI indicator!");
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
    double indicatorHeight = (chartMax - chartMin) * 
                             INDICATOR_PLOT_HEIGHT;
    double indicatorShift = indicatorHeight * INDICATOR_PLOT_SHIFT;

    ::Print(__FUNCTION__," > chartMin = ", chartMin,
                          ", chartMax = ", chartMax,
                          ", indicatorHeight = ", indicatorHeight,
                          ", indicatorShift = ", indicatorShift);
    double wprMin = chartMin;
    double wprMax = wprMin + indicatorHeight;
    wpr_.setDrawRange(wprMin, wprMax);

    double rsiMin = wprMin + indicatorShift;
    double rsiMax = rsiMin + indicatorHeight;
    rsi_.setDrawRange(rsiMin, rsiMax);

    double cciMin = rsiMin + indicatorShift;
    double cciMax = cciMin + indicatorHeight;
    cci_.setDrawRange(cciMin, cciMax);
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

  int cciTotal = cci_.calculateAndCopy(rates_total, prev_calculated, 
                          begin, cciBuffer_, cciColorBuffer_);


  return MathMin(wprTotal, MathMin(rsiTotal, cciTotal));
  }

//+------------------------------------------------------------------+
