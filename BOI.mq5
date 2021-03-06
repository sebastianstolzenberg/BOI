//+------------------------------------------------------------------+
//|                                                          BOI.mq5 |
//+------------------------------------------------------------------+
#property copyright "SES"
#property version   "1.00"

// #property indicator_separate_window
#property indicator_chart_window
#property indicator_buffers 13
#property indicator_plots   8

//--- set limit of the indicator values 
// #property indicator_minimum -50 
// #property indicator_maximum 50 

#property indicator_label1  "Alert" 
#property indicator_color1  Gray,clrAqua,clrRed
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

#property indicator_label8  "MFI" 
#property indicator_color8  clrWheat,clrLime,clrRed
#property indicator_type8   DRAW_COLOR_ARROW
#property indicator_width8  1

#include <Files\FileTxt.mqh>

#include "ControlWindow.mqh"
#include "indicators/BB.mqh"
#include "indicators/WPR.mqh"
#include "indicators/RSI.mqh"
#include "indicators/CCI.mqh"
#include "indicators/MFI.mqh"

const double INDICATOR_PLOT_HEIGHT = 0.02;
const double INDICATOR_PLOT_SHIFT = 2;
// const double INDICATOR_PLOT_HEIGHT = 0.2;
// const double INDICATOR_PLOT_SHIFT = 1.1;

input int TIME_WINDOW_START = 9;
input int TIME_WINDOW_END = 22;
input double SIM_MONEY_START = 2000;
input double SIM_WIN_RATE = 0.7;
input double SIM_BET = 20;
input int SIM_MAX_MARTINGALE_LEVEL = 4;

#define ENABLE_CSV_DUMP

//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+
//---- buffers
double alertPriceBuffer_[];
double alertColorBuffer_[];

double chartMin_;
double chartMax_;
double wprMin_;
double wprMax_;

BB bb_;
WPR wpr_;
RSI rsi_;
CCI cci_;
MFI mfi_;
CControlWindow controlWindow_;

double simMoney_;

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
      case CWC_BB_ENABLED:
        bb_.setEnabled(controlWindow_.IsBbEnabled());
        break;
      case CWC_BB_PARAMETERS:
        InitializeBb();
        break;

      case CWC_WPR_ENABLED:
        wpr_.setEnabled(controlWindow_.IsWprEnabled());
        break;
      case CWC_WPR_PERIOD:
        InitializeWpr();
        break;
      case CWC_WPR_THRESHOLD:
        wpr_.setThresholds(controlWindow_.GetWprUpperThreshold(),
                           controlWindow_.GetWprLowerThreshold());
        break;

      case CWC_RSI_ENABLED:
        rsi_.setEnabled(controlWindow_.IsRsiEnabled());
        break;
      case CWC_RSI_PERIOD:
        InitializeRsi();
        break;
      case CWC_RSI_THRESHOLD:
        rsi_.setThresholds(controlWindow_.GetRsiUpperThreshold(),
                           controlWindow_.GetRsiLowerThreshold());
        break;

      case CWC_CCI_ENABLED:
        cci_.setEnabled(controlWindow_.IsCciEnabled());
        break;
      case CWC_CCI_PERIOD:
        InitializeCci();
        break;
      case CWC_CCI_THRESHOLD:
        cci_.setThresholds(controlWindow_.GetCciUpperThreshold(),
                           controlWindow_.GetCciLowerThreshold());
        break;

      case CWC_MFI_ENABLED:
        mfi_.setEnabled(controlWindow_.IsMfiEnabled());
        break;
      case CWC_MFI_PERIOD:
        InitializeMfi();
        break;
      case CWC_MFI_THRESHOLD:
        mfi_.setThresholds(controlWindow_.GetMfiUpperThreshold(),
                           controlWindow_.GetMfiLowerThreshold());
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
  bb_.setEnabled(controlWindow_.IsBbEnabled());
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

bool InitializeMfi()
  {
  ::Print(__FUNCTION__);
  mfi_.setThresholds(controlWindow_.GetMfiUpperThreshold(),
                     controlWindow_.GetMfiLowerThreshold());
  int period = controlWindow_.GetMfiPeriod();
  return mfi_.configure(period);
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
    SetIndexBuffer(2,bb_.upperBuffer,INDICATOR_DATA);
    SetIndexBuffer(3,bb_.middleBuffer,INDICATOR_DATA);
    SetIndexBuffer(4,bb_.lowerBuffer,INDICATOR_DATA);
    SetIndexBuffer(5,wpr_.dataBuffer,INDICATOR_DATA);
    SetIndexBuffer(6,wpr_.colorBuffer,INDICATOR_COLOR_INDEX);
    SetIndexBuffer(7,rsi_.dataBuffer,INDICATOR_DATA);
    SetIndexBuffer(8,rsi_.colorBuffer,INDICATOR_COLOR_INDEX);
    SetIndexBuffer(9,cci_.dataBuffer,INDICATOR_DATA);
    SetIndexBuffer(10,cci_.colorBuffer,INDICATOR_COLOR_INDEX);
    SetIndexBuffer(11,mfi_.dataBuffer,INDICATOR_DATA);
    SetIndexBuffer(12,mfi_.colorBuffer,INDICATOR_COLOR_INDEX);
    

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

    if (!InitializeMfi())
    {
      ::Print(__FUNCTION__," > Failed to create MFI indicator!");
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

    double mfiMin = cciMin + indicatorShift;
    double mfiMax = mfiMin + indicatorHeight;
    mfi_.setDrawRange(mfiMin, mfiMax);
    }
  }

Signal getSignal(const int index)
{
  Signal signal = SIGNAL_NONE;
  if (alertPriceBuffer_[index] != 0)
  {
    signal = (Signal)alertColorBuffer_[index];
  }
  return signal;
}

enum Success
{
  SUCCESS_NO_SIGNAL,
  SUCCESS_ITM,
  SUCCESS_OTM,
  SUCCESS_MARTINGALE 
};
Success wasSuccess(const int index, const double& price[])
{
  Success success = SUCCESS_NO_SIGNAL;
  if (index > 0)
  {
    Signal signal = getSignal(index);
    switch (signal)
    {
      case SIGNAL_BUY:
        success = (price[index] < price[index+1]) ? SUCCESS_ITM : SUCCESS_OTM;
        break;

      case SIGNAL_SELL:
        success = (price[index] > price[index+1]) ? SUCCESS_ITM : SUCCESS_OTM;
        break;

      case SIGNAL_NONE:
      default:
        break;
    }
  }
  return success;
}

Signal processMartingale(const int index, const double& price[])
{
  Signal signal = SIGNAL_NONE;

  if (index > 0)
  {
    Signal currentSignal = getSignal(index);

    // only checks if martingale triggers a signal when there is no signal set yet
    if (currentSignal == SIGNAL_NONE)
    {
      const int minIndex = MathMax(0, index - SIM_MAX_MARTINGALE_LEVEL);

      int currentLevel = 0;
      for (int i = index - 1; 
           i >= minIndex && wasSuccess(i, price) == SUCCESS_OTM; 
           --i)
      {
        ++currentLevel;
      }

      if (currentLevel > 0 && currentLevel < SIM_MAX_MARTINGALE_LEVEL)
      {
        signal = getSignal(index - 1);
      }
    }
  }
  return signal;
}

double simulateMoney(const int index, const double& price[])
{
  if (index == 0)
  {
    simMoney_ = SIM_MONEY_START;
  }
  else if (simMoney_ >= SIM_BET)
  {
    Success success = wasSuccess(index - 1, price);
    if (success == SUCCESS_ITM)
    {
      // TODO other than plain martingale win
      simMoney_ += SIM_BET * SIM_WIN_RATE;
    }
    else if (success == SUCCESS_OTM && getSignal(index) == SIGNAL_NONE)
    {
      // TODO proper martingale loss
      simMoney_ -= SIM_BET * SIM_MAX_MARTINGALE_LEVEL;
    }
  }
  return simMoney_;
}

bool isInTimeWindow(datetime time)
{
  MqlDateTime dateTime; 
  TimeToStruct(time, dateTime);
  return (dateTime.hour >= TIME_WINDOW_START && dateTime.hour < TIME_WINDOW_END);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate (const int rates_total,      // size of input time series 
                 const int prev_calculated,  // bars handled in previous call 
                 const datetime& time[],     // Time 
                 const double& open[],       // Open 
                 const double& high[],       // High 
                 const double& low[],        // Low 
                 const double& close[],      // Close 
                 const long& tick_volume[],  // Tick Volume 
                 const long& volume[],       // Real Volume 
                 const int& spread[]         // Spread 
   )
// int OnCalculate(const int rates_total,
//                 const int prev_calculated,
//                 const int begin,
//                 const double &price[])
  {
  int bbTotal = bb_.calculateAndCopy(rates_total, prev_calculated);

  int wprPrevious = wpr_.getPreviouslyCalculated();
  int wprTotal = wpr_.calculateAndCopy(rates_total, prev_calculated);

  int rsiPrevious = rsi_.getPreviouslyCalculated();
  int rsiTotal = rsi_.calculateAndCopy(rates_total, prev_calculated);

  int cciPrevious = cci_.getPreviouslyCalculated();
  int cciTotal = cci_.calculateAndCopy(rates_total, prev_calculated);

  int mfiPrevious = mfi_.getPreviouslyCalculated();
  int mfiTotal = mfi_.calculateAndCopy(rates_total, prev_calculated);

  int previous = MathMin(prev_calculated, 
                    MathMin(wprPrevious, 
                      MathMin(rsiPrevious, 
                        MathMin(cciPrevious, 
                          mfiPrevious))));
  int calculated = MathMin(bbTotal, 
                    MathMin(wprTotal, 
                      MathMin(rsiTotal, 
                        MathMin(cciTotal, 
                          mfiTotal)))); 

  int itm = 0;
  int otm = 0;
  // const int firstCalculated = calculated - previous - 1;

#ifdef ENABLE_CSV_DUMP
  // csv file
  string filename;
  StringConcatenate(filename, previous, "-", calculated, ".csv");
  CFileTxt file;
  file.Open(filename, FILE_WRITE);
  file.WriteString("i\ttime\titm\totm\tsignal\tmoney\tclose\n");
#endif

  // run from oldest to newest (all arrays are indexed normally)
  for (int i = previous; i < calculated; ++i)
  {
    Signal wprSignal = wpr_.getSignal(i);
    Signal rsiSignal = rsi_.getSignal(i);
    Signal cciSignal = cci_.getSignal(i);
    Signal mfiSignal = mfi_.getSignal(i);
    bool bbAcceptsSell = bb_.acceptsSell(close[i], i);
    bool bbAcceptsBuy = bb_.acceptsBuy(close[i], i);
    // filter alerts
    if (isInTimeWindow(time[i]) &&
        wprSignal != SIGNAL_NONE &&
        wprSignal == rsiSignal &&
        wprSignal == cciSignal &&
        wprSignal == mfiSignal &&
        ((bbAcceptsBuy && wprSignal == SIGNAL_BUY) || 
         (bbAcceptsSell && wprSignal == SIGNAL_SELL)))
    {
      if (wprSignal == SIGNAL_BUY && bbAcceptsBuy)
      {
        alertColorBuffer_[i] = SIGNAL_BUY;
        alertPriceBuffer_[i] = close[i];
      }
      if (wprSignal == SIGNAL_SELL && bbAcceptsSell)
      {
        alertColorBuffer_[i] = SIGNAL_SELL;
        alertPriceBuffer_[i] = close[i];
      }
    }
    else 
    {
      alertColorBuffer_[i] = processMartingale(i, close);
      if ((Signal)alertColorBuffer_[i] != SIGNAL_NONE)
      {
        ::Print(__FUNCTION__, " > Martingale at ", time[i], " (", i, ")");
        alertPriceBuffer_[i] = close[i];
      }
      else
      {
        alertPriceBuffer_[i] = 0;
      }
    }

    // check success
    Success success = wasSuccess(i-1, close);
    if (success == SUCCESS_ITM) ++itm;
    if (success == SUCCESS_OTM && getSignal(i) == SIGNAL_NONE)
    {
      ++otm;
      ::Print(__FUNCTION__, " > OTM at ", time[i], " (", i, ")");
    }

    simulateMoney(i, close);
     // ::Print(__FUNCTION__, " > i = ", i, 
      //                        ", itm = ", itm, 
      //                        ", otm = ", otm, 
      //                        ", sell = ", alertColorBuffer_[i+1], 
      //                        ", dir = ", dir, 
      //                        ", close[i+1] = ", close[i+1], 
      //                        ", close[i] = ", close[i]);

#ifdef ENABLE_CSV_DUMP
    string csvLine;
    StringConcatenate(csvLine, i, "\t", time[i], "\t", itm, "\t", otm , "\t", 
                      (Signal)alertColorBuffer_[i], "\t", simMoney_, "\t", close[i], "\n");
    file.WriteString(csvLine);
#endif
  }
#ifdef ENABLE_CSV_DUMP
  file.Close();
#endif
  if (previous < calculated)
  {
    ::Print(__FUNCTION__, " > itm = ", itm, ", otm = ", otm, ", money = ", simMoney_,
                        " (",previous,",",calculated,")");
    Comment("itm = ", itm, ", otm = ", otm, "\n money = ", simMoney_);
  }

  return calculated;
  }

void CheckSuccess()
{
  int counted_bars=Bars(Symbol(),Period());

  //   // check success
  // if (int i != 0 && i < rates_total && alertPriceBuffer_[i-1] != 0)
  // {
  //   if (alertColorBuffer_[i-1] == 0 && price[i-1] < price[i])
  //   {
  //     ++itm;
  //   }
  //   else
  //   {
  //     ++otm;
  //   }

  //   if (alertColorBuffer_[i-1] == 1 && price[i-1] > price[i])
  //   {
  //     ++itm;
  //   }
  //   else
  //   {
  //     ++otm;
  //   }
  // }
}
//+------------------------------------------------------------------+
