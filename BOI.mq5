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
#property indicator_buffers 11
#property indicator_plots   7

//--- set limit of the indicator values 
// #property indicator_minimum -50 
// #property indicator_maximum 50 

#property indicator_label1  "Alert" 
#property indicator_color1  clrAqua,clrRed
#property indicator_type1   DRAW_COLOR_ARROW
#property indicator_width1  15

#property indicator_label2  "BB-upper" 
#property indicator_color2  Gray
#property indicator_type2   DRAW_LINE
#property indicator_style2  STYLE_DASH
#property indicator_width2  1
#property indicator_label3  "BB-middle" 
#property indicator_color3  Gray
#property indicator_type3   DRAW_LINE
#property indicator_width3  1
#property indicator_label4  "BB-lower" 
#property indicator_color4  Gray
#property indicator_type4   DRAW_LINE
#property indicator_style4  STYLE_DASH
#property indicator_width4  1

#property indicator_label5  "WPR" 
#property indicator_color5  clrPowderBlue,clrLime,clrRed
#property indicator_type5   DRAW_COLOR_ARROW
#property indicator_width5  1

#property indicator_label6  "RSI" 
#property indicator_color6  clrThistle,clrLime,clrRed
#property indicator_type6   DRAW_COLOR_ARROW
#property indicator_width6  1

#property indicator_label7  "CCI" 
#property indicator_color7  clrWheat,clrLime,clrRed
#property indicator_type7   DRAW_COLOR_ARROW
#property indicator_width7  1


#include "ControlWindow.mqh"
#include "indicators/WPR.mqh"
#include "indicators/RSI.mqh"
#include "indicators/CCI.mqh"
#include "indicators/BB.mqh"

const double INDICATOR_PLOT_HEIGHT = 0.02;
const double INDICATOR_PLOT_SHIFT = 2;

//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+
//---- buffers
double alertPriceBuffer_[];
double alertColorBuffer_[];

double bbUpperBuffer_[];
double bbMiddleBuffer_[];
double bbLowerBuffer_[];

double wprBuffer_[];
double wprColorBuffer_[];

double rsiBuffer_[];
double rsiColorBuffer_[];

double cciBuffer_[];
double cciColorBuffer_[];

double chartMin_;
double chartMax_;
double wprMin_;
double wprMax_;

WPR wpr_;
RSI rsi_;
CCI cci_;
BB bb_;
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
      case CWC_BB:
        InitializeBb();
        break;

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
  
bool InitializeBb()
  {
  ::Print(__FUNCTION__);
  return bb_.configure(controlWindow_.GetBbPeriod(),
                       controlWindow_.GetBbShift(),
                       controlWindow_.GetBbDeviation());
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
    SetIndexBuffer(0,alertPriceBuffer_,INDICATOR_DATA);
    SetIndexBuffer(1,alertColorBuffer_,INDICATOR_COLOR_INDEX);
    SetIndexBuffer(2,bbUpperBuffer_,INDICATOR_DATA);
    SetIndexBuffer(3,bbMiddleBuffer_,INDICATOR_DATA);
    SetIndexBuffer(4,bbLowerBuffer_,INDICATOR_DATA);
    SetIndexBuffer(5,wprBuffer_,INDICATOR_DATA);
    SetIndexBuffer(6,wprColorBuffer_,INDICATOR_COLOR_INDEX);
    SetIndexBuffer(7,rsiBuffer_,INDICATOR_DATA);
    SetIndexBuffer(8,rsiColorBuffer_,INDICATOR_COLOR_INDEX);
    SetIndexBuffer(9,cciBuffer_,INDICATOR_DATA);
    SetIndexBuffer(10,cciColorBuffer_,INDICATOR_COLOR_INDEX);
    
    controlWindow_.SetListener(parameters_);
    controlWindow_.OnInitEvent();
    if (!controlWindow_.CreateTradePanel())
    {
      ::Print(__FUNCTION__," > Failed to create graphical interface!");
      return INIT_FAILED;
    }
 
    if (!InitializeBb())
    {
      ::Print(__FUNCTION__," > Failed to create BB indicator!");
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

    // ::Print(__FUNCTION__," > chartMin = ", chartMin,
    //                       ", chartMax = ", chartMax,
    //                       ", indicatorHeight = ", indicatorHeight,
    //                       ", indicatorShift = ", indicatorShift);
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
  int bbTotal = bb_.calculateAndCopy(rates_total, prev_calculated,
                          begin, bbUpperBuffer_, bbMiddleBuffer_, 
                          bbLowerBuffer_);

  int wprPrevious = wpr_.getPreviouslyCalculated();
  int wprTotal = wpr_.calculateAndCopy(rates_total, prev_calculated, 
                          begin, wprBuffer_, wprColorBuffer_);

  int rsiPrevious = rsi_.getPreviouslyCalculated();
  int rsiTotal = rsi_.calculateAndCopy(rates_total, prev_calculated, 
                          begin, rsiBuffer_, rsiColorBuffer_);

  int cciPrevious = cci_.getPreviouslyCalculated();
  int cciTotal = cci_.calculateAndCopy(rates_total, prev_calculated, 
                          begin, cciBuffer_, cciColorBuffer_);

  int previous = MathMin(prev_calculated, 
                    MathMin(wprPrevious, 
                      MathMin(rsiPrevious, cciPrevious)));
  int calculated = MathMin(wprTotal, MathMin(rsiTotal, MathMin(cciTotal, bbTotal))); 

  for (int i = calculated - previous - 1; i >= 0; --i)
  {
    if (wprColorBuffer_[i] > 0 &&
        wprColorBuffer_[i] == rsiColorBuffer_[i] &&
        wprColorBuffer_[i] == cciColorBuffer_[i])
    {
      alertColorBuffer_[i] = wprColorBuffer_[i] - 1;
      alertPriceBuffer_[i] = price[i];
    }
    else 
    {
      alertPriceBuffer_[i] = 0;
    }
  }

  return MathMin(wprTotal, MathMin(rsiTotal, MathMin(cciTotal, bbTotal)));
  }

//+------------------------------------------------------------------+
