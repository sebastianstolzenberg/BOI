//+------------------------------------------------------------------+
//|                                                ControlWindow.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Sebastian Stolzenberg"
#property version   "1.00"

#include <EasyAndFastGUI\Controls\WndEvents.mqh>

//+------------------------------------------------------------------+
//| Layout                                                           |
//+------------------------------------------------------------------+
// colors
const color WINDOW_BG_COLOR = clrWhiteSmoke;
const color WINDOW_BORDER_COLOR = clrLightSteelBlue;
const color CAPTION_BG_COLOR = clrLightSteelBlue;
const color CAPTION_BG_HOVER_COLOR = clrLightSteelBlue;

const color AREA_COLOR = clrWhiteSmoke;
const color LABEL_COLOR = clrBlack;
const color LABEL_OFF_COLOR = clrBlack;
const color LABEL_LOCKED_COLOR = clrSilver;

const color EDIT_TEXT_COLOR = clrBlack;
const color EDIT_LOCKED_TEXT_COLOR = clrSilver;
const color EDIT_BORDER_COLOR = clrSilver;
const color EDIT_LOCKED_BORDER_COLOR = clrSilver;
const color EDIT_LOCKED_COLOR = clrWhiteSmoke;

const color SLOT_LINE_DARK_COLOR = clrSilver;
const color SLOT_LINE_LIGHT_COLOR = clrWhite;
const color SLOT_INDICATOR_COLOR = C'85,170,255';
const color SLOT_INDICATOR_LOCKED_COLOR = clrLightGray;

const color THUMB_LOCKED_COLOR = clrLightGray;
const color THUMB_COLOR_PRESSED = clrSilver;

// window size
const int WINDOW_WIDTH = 306;
const int WINDOW_HEIGHT = 150;

// general constants for indicators
const int INDICATOR_X_OFFSET = 5;
const int INDICATOR_Y_OFFSET = 20;

const int INDICATOR_ENABLE_CHECKBOX_X_OFFSET = 0;
const int INDICATOR_ENABLE_CHECKBOX_Y_OFFSET = 14;
const int INDICATOR_ENABLE_CHECKBOX_WIDTH = 50;
const int INDICATOR_ENABLE_CHECKBOX_HEIGHT = 18;

const int INDICATOR_PERIOD_SPINEDIT_X_OFFSET = INDICATOR_ENABLE_CHECKBOX_WIDTH;
const int INDICATOR_PERIOD_SPINEDIT_Y_OFFSET = INDICATOR_ENABLE_CHECKBOX_Y_OFFSET;
const int INDICATOR_PERIOD_SPINEDIT_WIDTH = 70;
const int INDICATOR_PERIOD_SPINEDIT_HEIGHT = 18;
const int INDICATOR_PERIOD_SPINEDIT_EDIT_WIDTH = 20;

const int INDICATOR_RANGE_SLIDER_X_OFFSET = 10 +
                INDICATOR_PERIOD_SPINEDIT_X_OFFSET + INDICATOR_PERIOD_SPINEDIT_WIDTH;
const int INDICATOR_RANGE_SLIDER_Y_OFFSET = 0;
const int INDICATOR_RANGE_SLIDER_WIDTH = 150;
const int INDICATOR_RANGE_SLIDER_HEIGHT = 40;
const int INDICATOR_RANGE_SLIDER_EDIT_WIDTH = 30;
const int INDICATOR_RANGE_SLIDER_SLOT_HEIGHT = 4;

// WPR control constants
const bool WPR_DEFAULT_STATE = true;
const int WPR_X = INDICATOR_X_OFFSET;
const int WPR_Y = INDICATOR_Y_OFFSET;
const int WPR_PERIOD_MIN_VALUE = 1;
const int WPR_PERIOD_MAX_VALUE = 100;
const int WPR_PERIOD_STEP_VALUE = 1;
const int WPR_PERIOD_DIGITS = 0;
const int WPR_PERIOD_START_VALUE = 2;
const int WPR_RANGE_MIN_VALUE = -100;
const int WPR_RANGE_MAX_VALUE = 0;
const int WPR_RANGE_STEP_VALUE = 1;
const int WPR_RANGE_DIGITS = 0;
const int WPR_RANGE_LEFT_START_VALUE = -95;
const int WPR_RANGE_RIGHT_START_VALUE = -5;

// RSI control constants
const bool RSI_DEFAULT_STATE = true;
const int RSI_X = INDICATOR_X_OFFSET;
const int RSI_Y = WPR_Y + INDICATOR_RANGE_SLIDER_HEIGHT;
const int RSI_PERIOD_MIN_VALUE = 1;
const int RSI_PERIOD_MAX_VALUE = 100;
const int RSI_PERIOD_STEP_VALUE = 1;
const int RSI_PERIOD_DIGITS = 0;
const int RSI_PERIOD_START_VALUE = 2;
const int RSI_RANGE_MIN_VALUE = 0;
const int RSI_RANGE_MAX_VALUE = 100;
const int RSI_RANGE_STEP_VALUE = 1;
const int RSI_RANGE_DIGITS = 0;
const int RSI_RANGE_LEFT_START_VALUE = 7;
const int RSI_RANGE_RIGHT_START_VALUE = 95;

// CCI control constants
const bool CCI_DEFAULT_STATE = true;
const int CCI_X = INDICATOR_X_OFFSET;
const int CCI_Y = RSI_Y + INDICATOR_RANGE_SLIDER_HEIGHT;
const int CCI_PERIOD_MIN_VALUE = 1;
const int CCI_PERIOD_MAX_VALUE = 100;
const int CCI_PERIOD_STEP_VALUE = 1;
const int CCI_PERIOD_DIGITS = 0;
const int CCI_PERIOD_START_VALUE = 3;
const int CCI_RANGE_MIN_VALUE = -100;
const int CCI_RANGE_MAX_VALUE = 100;
const int CCI_RANGE_STEP_VALUE = 1;
const int CCI_RANGE_DIGITS = 0;
const int CCI_RANGE_LEFT_START_VALUE = -95;
const int CCI_RANGE_RIGHT_START_VALUE = 95;


//+------------------------------------------------------------------+
enum ControlWindowChange
{
  CWC_WPR_PERIOD,
  CWC_WPR_THRESHOLD,
  CWC_RSI_PERIOD,
  CWC_RSI_THRESHOLD,
  CWC_CCI_PERIOD,
  CWC_CCI_THRESHOLD
};
//+------------------------------------------------------------------+
class IControlWindowListener
{
protected:
  ~IControlWindowListener() {}

public:
  virtual void OnControlWindowChanged(ControlWindowChange change) = 0;
};
//+------------------------------------------------------------------+
class CControlWindow : public CWndEvents
  {
private:
   IControlWindowListener* listener_;

   //--- Form 1
   CWindow           window1_;

   //--- WPR controls
   CCheckBox         wprEnableCheckbox_;
   CSpinEdit         wprPeriodSpinEdit_;
   CDualSlider       wprRangeSlider_;

   //--- RSI controls
   CCheckBox         rsiEnableCheckbox_;
   CSpinEdit         rsiPeriodSpinEdit_;
   CDualSlider       rsiRangeSlider_;

   //--- CCI controls
   CCheckBox         cciEnableCheckbox_;
   CSpinEdit         cciPeriodSpinEdit_;
   CDualSlider       cciRangeSlider_;

public:
                     CControlWindow();
                    ~CControlWindow();

   void              SetListener(IControlWindowListener& listener);

   //--- Initialization/deinitialization
   void              OnInitEvent(void);
   void              OnDeinitEvent(const int reason);
   //--- Timer
   //---
   void              OnTimerEvent(void);


   //--- WPR parameters
   bool              IsWprEnabled();
   int               GetWprPeriod();
   double            GetWprLowerThreshold();
   double            GetWprUpperThreshold();

   //--- RSI parameters
   bool              IsRsiEnabled();
   int               GetRsiPeriod();
   double            GetRsiLowerThreshold();
   double            GetRsiUpperThreshold();

   //--- CCI parameters
   bool              IsCciEnabled();
   int               GetCciPeriod();
   double            GetCciLowerThreshold();
   double            GetCciUpperThreshold();

protected:
   //--- Chart event handler
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //---
public:
   //--- Creates the trading panel
   bool              CreateTradePanel(void);
   //---
private:
   //--- Form 1
   bool              CreateWindow1(const string text);
   bool              CreateWprControls();
   bool              CreateRsiControls();
   bool              CreateCciControls();

   void              NotifyWindowChanged(ControlWindowChange change);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CControlWindow::CControlWindow()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CControlWindow::~CControlWindow()
  {
  }
//+------------------------------------------------------------------+
//| Initialization                                                   |
//+------------------------------------------------------------------+
void CControlWindow::SetListener(IControlWindowListener& listener)
  {
    listener_ = GetPointer(listener);
  }
//+------------------------------------------------------------------+
//| Initialization                                                   |
//+------------------------------------------------------------------+
void CControlWindow::OnInitEvent(void)
  {
  }
//+------------------------------------------------------------------+
//| Uninitialization                                                 |
//+------------------------------------------------------------------+
void CControlWindow::OnDeinitEvent(const int reason)
  {
  ::Print(__FUNCTION__," > reason = ", reason);
//--- Removing the interface
   CWndEvents::Destroy();
  }
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+
void CControlWindow::OnTimerEvent(void)
  {
   CWndEvents::OnTimerEvent();
   // //--- Redraw the chart
   // m_chart.Redraw();
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CControlWindow::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
    if(id==CHARTEVENT_CUSTOM+ON_CLICK_LABEL)
     {
      if(lparam==wprEnableCheckbox_.Id())
        {
         wprPeriodSpinEdit_.SpinEditState(wprEnableCheckbox_.CheckButtonState());
         wprRangeSlider_.SliderState(wprEnableCheckbox_.CheckButtonState());
        }
      if(lparam==rsiEnableCheckbox_.Id())
        {
         rsiPeriodSpinEdit_.SpinEditState(rsiEnableCheckbox_.CheckButtonState());
         rsiRangeSlider_.SliderState(rsiEnableCheckbox_.CheckButtonState());
        }
      if(lparam==cciEnableCheckbox_.Id())
        {
         cciPeriodSpinEdit_.SpinEditState(cciEnableCheckbox_.CheckButtonState());
         cciRangeSlider_.SliderState(cciEnableCheckbox_.CheckButtonState());
        }
     }
    if(lparam==wprPeriodSpinEdit_.Id())
    {
      ::Print(__FUNCTION__," > id: ",id,"; lparam: ",lparam,"; dparam: ",dparam,"; sparam: ",sparam);
      NotifyWindowChanged(CWC_WPR_PERIOD);
    }
    if(lparam==wprRangeSlider_.Id())
    {
      ::Print(__FUNCTION__," > id: ",id,"; lparam: ",lparam,"; dparam: ",dparam,"; sparam: ",sparam);
      NotifyWindowChanged(CWC_WPR_THRESHOLD);
    }
    if(lparam==rsiPeriodSpinEdit_.Id())
    {
      ::Print(__FUNCTION__," > id: ",id,"; lparam: ",lparam,"; dparam: ",dparam,"; sparam: ",sparam);
      NotifyWindowChanged(CWC_RSI_PERIOD);
    }
    if(lparam==rsiRangeSlider_.Id())
    {
      ::Print(__FUNCTION__," > id: ",id,"; lparam: ",lparam,"; dparam: ",dparam,"; sparam: ",sparam);
      NotifyWindowChanged(CWC_RSI_THRESHOLD);
    }
    if(lparam==cciPeriodSpinEdit_.Id())
    {
      ::Print(__FUNCTION__," > id: ",id,"; lparam: ",lparam,"; dparam: ",dparam,"; sparam: ",sparam);
      NotifyWindowChanged(CWC_CCI_PERIOD);
    }
    if(lparam==cciRangeSlider_.Id())
    {
      ::Print(__FUNCTION__," > id: ",id,"; lparam: ",lparam,"; dparam: ",dparam,"; sparam: ",sparam);
      NotifyWindowChanged(CWC_CCI_THRESHOLD);
    }
  }
//+------------------------------------------------------------------+
//| Returns WPR parameters                                           |
//+------------------------------------------------------------------+
bool CControlWindow::IsWprEnabled()
{
  return wprEnableCheckbox_.CheckButtonState();
}
int CControlWindow::GetWprPeriod()
{
  return (int)wprPeriodSpinEdit_.GetValue();
}
double CControlWindow::GetWprLowerThreshold()
{
  return wprRangeSlider_.GetLeftValue();
}
double CControlWindow::GetWprUpperThreshold()
{
  return wprRangeSlider_.GetRightValue();
}
//+------------------------------------------------------------------+
//| Returns RSI parameters                                           |
//+------------------------------------------------------------------+
bool CControlWindow::IsRsiEnabled()
{
  return rsiEnableCheckbox_.CheckButtonState();
}
int CControlWindow::GetRsiPeriod()
{
  return (int)rsiPeriodSpinEdit_.GetValue();
}
double CControlWindow::GetRsiLowerThreshold()
{
  return rsiRangeSlider_.GetLeftValue();
}
double CControlWindow::GetRsiUpperThreshold()
{
  return rsiRangeSlider_.GetRightValue();
}
//+------------------------------------------------------------------+
//| Returns CCI parameters                                           |
//+------------------------------------------------------------------+
bool CControlWindow::IsCciEnabled()
{
  return cciEnableCheckbox_.CheckButtonState();
}
int CControlWindow::GetCciPeriod()
{
  return (int)cciPeriodSpinEdit_.GetValue();
}
double CControlWindow::GetCciLowerThreshold()
{
  return cciRangeSlider_.GetLeftValue();
}
double CControlWindow::GetCciUpperThreshold()
{
  return cciRangeSlider_.GetRightValue();
}
//+------------------------------------------------------------------+
//| Creates the trading panel                                        |
//+------------------------------------------------------------------+
bool CControlWindow::CreateTradePanel(void)
  {
//--- Creating form 1 for controls
   if(!CreateWindow1("EXPERT PANEL"))
      return(false);

   if(!CreateWprControls())
      return(false);
   if(!CreateRsiControls())
      return(false);
   if(!CreateCciControls())
      return(false);

//--- Redrawing the chart
   m_chart.Redraw();
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates form 1 for controls                                      |
//+------------------------------------------------------------------+
bool CControlWindow::CreateWindow1(const string caption_text)
  {
//--- Add the window pointer to the window array
   CWndContainer::AddWindow(window1_);
//--- Coordinates
   int x=(window1_.X()>0) ? window1_.X() : 1;
   int y=(window1_.Y()>0) ? window1_.Y() : 20;
//--- Properties
   window1_.Movable(true);
   window1_.XSize(WINDOW_WIDTH);
   window1_.YSize(WINDOW_HEIGHT);
   window1_.WindowBgColor(WINDOW_BG_COLOR);
   window1_.WindowBorderColor(WINDOW_BORDER_COLOR);
   window1_.CaptionBgColor(CAPTION_BG_COLOR);
   window1_.CaptionBgColorHover(CAPTION_BG_HOVER_COLOR);
//--- Creating the form
   if(!window1_.CreateWindow(m_chart_id,m_subwin,caption_text,x,y))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates RSI controls                                      |
//+------------------------------------------------------------------+
bool CControlWindow::CreateWprControls()
  {
    const int baseX = window1_.X() + WPR_X;
    const int baseY = window1_.Y() + WPR_Y;
    

    // checkbox
    wprEnableCheckbox_.WindowPointer(window1_);
    wprEnableCheckbox_.XSize(INDICATOR_ENABLE_CHECKBOX_WIDTH);
    wprEnableCheckbox_.YSize(INDICATOR_ENABLE_CHECKBOX_HEIGHT);
    wprEnableCheckbox_.AreaColor(AREA_COLOR);
    wprEnableCheckbox_.LabelColor(LABEL_COLOR);
    wprEnableCheckbox_.LabelColorOff(LABEL_OFF_COLOR);
    wprEnableCheckbox_.LabelColorLocked(LABEL_LOCKED_COLOR);
    wprEnableCheckbox_.CheckButtonState(WPR_DEFAULT_STATE);
    int x = baseX + INDICATOR_ENABLE_CHECKBOX_X_OFFSET;
    int y = baseY + INDICATOR_ENABLE_CHECKBOX_Y_OFFSET;
    if (!wprEnableCheckbox_.CreateCheckBox(m_chart_id, m_subwin, "WPR", x, y))
      return false;
    CWndContainer::AddToElementsArray(0, wprEnableCheckbox_);

    // spin edit for period
    wprPeriodSpinEdit_.WindowPointer(window1_);
    wprPeriodSpinEdit_.XSize(INDICATOR_PERIOD_SPINEDIT_WIDTH);
    wprPeriodSpinEdit_.YSize(INDICATOR_PERIOD_SPINEDIT_HEIGHT);
    wprPeriodSpinEdit_.EditXSize(INDICATOR_PERIOD_SPINEDIT_EDIT_WIDTH);
    wprPeriodSpinEdit_.MaxValue(WPR_PERIOD_MAX_VALUE);
    wprPeriodSpinEdit_.MinValue(WPR_PERIOD_MIN_VALUE);
    wprPeriodSpinEdit_.StepValue(WPR_PERIOD_STEP_VALUE);
    wprPeriodSpinEdit_.SetDigits(WPR_PERIOD_DIGITS);
    wprPeriodSpinEdit_.SetValue(WPR_PERIOD_START_VALUE);
    wprPeriodSpinEdit_.ResetMode(true);
    wprPeriodSpinEdit_.AreaColor(AREA_COLOR);
    wprPeriodSpinEdit_.LabelColor(LABEL_COLOR);
    wprPeriodSpinEdit_.LabelColorLocked(LABEL_LOCKED_COLOR);
    wprPeriodSpinEdit_.EditColorLocked(EDIT_LOCKED_COLOR);
    wprPeriodSpinEdit_.EditTextColor(EDIT_TEXT_COLOR);
    wprPeriodSpinEdit_.EditTextColorLocked(EDIT_LOCKED_TEXT_COLOR);
    wprPeriodSpinEdit_.EditBorderColor(EDIT_BORDER_COLOR);
    wprPeriodSpinEdit_.EditBorderColorLocked(EDIT_LOCKED_BORDER_COLOR);
    wprPeriodSpinEdit_.SpinEditState(wprEnableCheckbox_.CheckButtonState());
    x = baseX + INDICATOR_PERIOD_SPINEDIT_X_OFFSET;
    y = baseY + INDICATOR_PERIOD_SPINEDIT_Y_OFFSET;
    if (!wprPeriodSpinEdit_.CreateSpinEdit(m_chart_id, m_subwin, "Period", x, y))
      return false;
    CWndContainer::AddToElementsArray(0, wprPeriodSpinEdit_);

    // slider for trigger range setting
    wprRangeSlider_.WindowPointer(window1_);
    wprRangeSlider_.XSize(INDICATOR_RANGE_SLIDER_WIDTH);
    wprRangeSlider_.YSize(INDICATOR_RANGE_SLIDER_HEIGHT);
    wprRangeSlider_.EditXSize(INDICATOR_RANGE_SLIDER_EDIT_WIDTH);
    wprRangeSlider_.MinValue(WPR_RANGE_MIN_VALUE);
    wprRangeSlider_.MaxValue(WPR_RANGE_MAX_VALUE);
    wprRangeSlider_.StepValue(WPR_RANGE_STEP_VALUE);
    wprRangeSlider_.SetDigits(WPR_RANGE_DIGITS);
    wprRangeSlider_.SetLeftValue(WPR_RANGE_LEFT_START_VALUE);
    wprRangeSlider_.SetRightValue(WPR_RANGE_RIGHT_START_VALUE);
    wprRangeSlider_.AreaColor(AREA_COLOR);
    wprRangeSlider_.LabelColor(LABEL_COLOR);
    wprRangeSlider_.LabelColorLocked(LABEL_LOCKED_COLOR);
    wprRangeSlider_.EditColorLocked(EDIT_LOCKED_COLOR);
    wprRangeSlider_.EditBorderColor(EDIT_BORDER_COLOR);
    wprRangeSlider_.EditBorderColorLocked(EDIT_LOCKED_BORDER_COLOR);
    wprRangeSlider_.EditTextColor(EDIT_TEXT_COLOR);
    wprRangeSlider_.EditTextColorLocked(EDIT_LOCKED_TEXT_COLOR);
    wprRangeSlider_.SlotLineDarkColor(SLOT_LINE_DARK_COLOR);
    wprRangeSlider_.SlotLineLightColor(SLOT_LINE_LIGHT_COLOR);
    wprRangeSlider_.SlotIndicatorColor(SLOT_INDICATOR_COLOR);
    wprRangeSlider_.SlotIndicatorColorLocked(SLOT_INDICATOR_LOCKED_COLOR);
    wprRangeSlider_.SlotYSize(INDICATOR_RANGE_SLIDER_SLOT_HEIGHT);
    wprRangeSlider_.ThumbColorLocked(THUMB_LOCKED_COLOR);
    wprRangeSlider_.ThumbColorPressed(THUMB_COLOR_PRESSED);
    wprRangeSlider_.SliderState(wprEnableCheckbox_.CheckButtonState());
    x = baseX + INDICATOR_RANGE_SLIDER_X_OFFSET;
    y = baseY + INDICATOR_RANGE_SLIDER_Y_OFFSET;
    if(!wprRangeSlider_.CreateSlider(m_chart_id,m_subwin,"Range",x,y))
      return(false);
    CWndContainer::AddToElementsArray(0, wprRangeSlider_);

    return(true);
  }
//+------------------------------------------------------------------+
//| Creates RSI controls                                      |
//+------------------------------------------------------------------+
bool CControlWindow::CreateRsiControls()
  {
    const int baseX = window1_.X() + RSI_X;
    const int baseY = window1_.Y() + RSI_Y;
    

    // checkbox
    rsiEnableCheckbox_.WindowPointer(window1_);
    rsiEnableCheckbox_.XSize(INDICATOR_ENABLE_CHECKBOX_WIDTH);
    rsiEnableCheckbox_.YSize(INDICATOR_ENABLE_CHECKBOX_HEIGHT);
    rsiEnableCheckbox_.AreaColor(AREA_COLOR);
    rsiEnableCheckbox_.LabelColor(LABEL_COLOR);
    rsiEnableCheckbox_.LabelColorOff(LABEL_OFF_COLOR);
    rsiEnableCheckbox_.LabelColorLocked(LABEL_LOCKED_COLOR);
    rsiEnableCheckbox_.CheckButtonState(RSI_DEFAULT_STATE);
    int x = baseX + INDICATOR_ENABLE_CHECKBOX_X_OFFSET;
    int y = baseY + INDICATOR_ENABLE_CHECKBOX_Y_OFFSET;
    if (!rsiEnableCheckbox_.CreateCheckBox(m_chart_id, m_subwin, "RSI", x, y))
      return false;
    CWndContainer::AddToElementsArray(0, rsiEnableCheckbox_);

    // spin edit for period
    rsiPeriodSpinEdit_.WindowPointer(window1_);
    rsiPeriodSpinEdit_.XSize(INDICATOR_PERIOD_SPINEDIT_WIDTH);
    rsiPeriodSpinEdit_.YSize(INDICATOR_PERIOD_SPINEDIT_HEIGHT);
    rsiPeriodSpinEdit_.EditXSize(INDICATOR_PERIOD_SPINEDIT_EDIT_WIDTH);
    rsiPeriodSpinEdit_.MaxValue(RSI_PERIOD_MAX_VALUE);
    rsiPeriodSpinEdit_.MinValue(RSI_PERIOD_MIN_VALUE);
    rsiPeriodSpinEdit_.StepValue(RSI_PERIOD_STEP_VALUE);
    rsiPeriodSpinEdit_.SetDigits(RSI_PERIOD_DIGITS);
    rsiPeriodSpinEdit_.SetValue(RSI_PERIOD_START_VALUE);
    rsiPeriodSpinEdit_.ResetMode(true);
    rsiPeriodSpinEdit_.AreaColor(AREA_COLOR);
    rsiPeriodSpinEdit_.LabelColor(LABEL_COLOR);
    rsiPeriodSpinEdit_.LabelColorLocked(LABEL_LOCKED_COLOR);
    rsiPeriodSpinEdit_.EditColorLocked(EDIT_LOCKED_COLOR);
    rsiPeriodSpinEdit_.EditTextColor(EDIT_TEXT_COLOR);
    rsiPeriodSpinEdit_.EditTextColorLocked(EDIT_LOCKED_TEXT_COLOR);
    rsiPeriodSpinEdit_.EditBorderColor(EDIT_BORDER_COLOR);
    rsiPeriodSpinEdit_.EditBorderColorLocked(EDIT_LOCKED_BORDER_COLOR);
    rsiPeriodSpinEdit_.SpinEditState(rsiEnableCheckbox_.CheckButtonState());
    x = baseX + INDICATOR_PERIOD_SPINEDIT_X_OFFSET;
    y = baseY + INDICATOR_PERIOD_SPINEDIT_Y_OFFSET;
    if (!rsiPeriodSpinEdit_.CreateSpinEdit(m_chart_id, m_subwin, "Period", x, y))
      return false;
    CWndContainer::AddToElementsArray(0, rsiPeriodSpinEdit_);

    // slider for trigger range setting
    rsiRangeSlider_.WindowPointer(window1_);
    rsiRangeSlider_.XSize(INDICATOR_RANGE_SLIDER_WIDTH);
    rsiRangeSlider_.YSize(INDICATOR_RANGE_SLIDER_HEIGHT);
    rsiRangeSlider_.EditXSize(INDICATOR_RANGE_SLIDER_EDIT_WIDTH);
    rsiRangeSlider_.MinValue(RSI_RANGE_MIN_VALUE);
    rsiRangeSlider_.MaxValue(RSI_RANGE_MAX_VALUE);
    rsiRangeSlider_.StepValue(RSI_RANGE_STEP_VALUE);
    rsiRangeSlider_.SetDigits(RSI_RANGE_DIGITS);
    rsiRangeSlider_.SetLeftValue(RSI_RANGE_LEFT_START_VALUE);
    rsiRangeSlider_.SetRightValue(RSI_RANGE_RIGHT_START_VALUE);
    rsiRangeSlider_.AreaColor(AREA_COLOR);
    rsiRangeSlider_.LabelColor(LABEL_COLOR);
    rsiRangeSlider_.LabelColorLocked(LABEL_LOCKED_COLOR);
    rsiRangeSlider_.EditColorLocked(EDIT_LOCKED_COLOR);
    rsiRangeSlider_.EditBorderColor(EDIT_BORDER_COLOR);
    rsiRangeSlider_.EditBorderColorLocked(EDIT_LOCKED_BORDER_COLOR);
    rsiRangeSlider_.EditTextColor(EDIT_TEXT_COLOR);
    rsiRangeSlider_.EditTextColorLocked(EDIT_LOCKED_TEXT_COLOR);
    rsiRangeSlider_.SlotLineDarkColor(SLOT_LINE_DARK_COLOR);
    rsiRangeSlider_.SlotLineLightColor(SLOT_LINE_LIGHT_COLOR);
    rsiRangeSlider_.SlotIndicatorColor(SLOT_INDICATOR_COLOR);
    rsiRangeSlider_.SlotIndicatorColorLocked(SLOT_INDICATOR_LOCKED_COLOR);
    rsiRangeSlider_.SlotYSize(INDICATOR_RANGE_SLIDER_SLOT_HEIGHT);
    rsiRangeSlider_.ThumbColorLocked(THUMB_LOCKED_COLOR);
    rsiRangeSlider_.ThumbColorPressed(THUMB_COLOR_PRESSED);
    rsiRangeSlider_.SliderState(rsiEnableCheckbox_.CheckButtonState());
    x = baseX + INDICATOR_RANGE_SLIDER_X_OFFSET;
    y = baseY + INDICATOR_RANGE_SLIDER_Y_OFFSET;
    if(!rsiRangeSlider_.CreateSlider(m_chart_id,m_subwin,"Range",x,y))
      return(false);
    CWndContainer::AddToElementsArray(0, rsiRangeSlider_); 

    return(true);
  }
//+------------------------------------------------------------------+
//| Creates RSI controls                                      |
//+------------------------------------------------------------------+
bool CControlWindow::CreateCciControls()
  {
    const int baseX = window1_.X() + CCI_X;
    const int baseY = window1_.Y() + CCI_Y;
    

    // checkbox
    cciEnableCheckbox_.WindowPointer(window1_);
    cciEnableCheckbox_.XSize(INDICATOR_ENABLE_CHECKBOX_WIDTH);
    cciEnableCheckbox_.YSize(INDICATOR_ENABLE_CHECKBOX_HEIGHT);
    cciEnableCheckbox_.AreaColor(AREA_COLOR);
    cciEnableCheckbox_.LabelColor(LABEL_COLOR);
    cciEnableCheckbox_.LabelColorOff(LABEL_OFF_COLOR);
    cciEnableCheckbox_.LabelColorLocked(LABEL_LOCKED_COLOR);
    cciEnableCheckbox_.CheckButtonState(CCI_DEFAULT_STATE);
    int x = baseX + INDICATOR_ENABLE_CHECKBOX_X_OFFSET;
    int y = baseY + INDICATOR_ENABLE_CHECKBOX_Y_OFFSET;
    if (!cciEnableCheckbox_.CreateCheckBox(m_chart_id, m_subwin, "CCI", x, y))
      return false;
    CWndContainer::AddToElementsArray(0, cciEnableCheckbox_);

    // spin edit for period
    cciPeriodSpinEdit_.WindowPointer(window1_);
    cciPeriodSpinEdit_.XSize(INDICATOR_PERIOD_SPINEDIT_WIDTH);
    cciPeriodSpinEdit_.YSize(INDICATOR_PERIOD_SPINEDIT_HEIGHT);
    cciPeriodSpinEdit_.EditXSize(INDICATOR_PERIOD_SPINEDIT_EDIT_WIDTH);
    cciPeriodSpinEdit_.MaxValue(CCI_PERIOD_MAX_VALUE);
    cciPeriodSpinEdit_.MinValue(CCI_PERIOD_MIN_VALUE);
    cciPeriodSpinEdit_.StepValue(CCI_PERIOD_STEP_VALUE);
    cciPeriodSpinEdit_.SetDigits(CCI_PERIOD_DIGITS);
    cciPeriodSpinEdit_.SetValue(CCI_PERIOD_START_VALUE);
    cciPeriodSpinEdit_.ResetMode(true);
    cciPeriodSpinEdit_.AreaColor(AREA_COLOR);
    cciPeriodSpinEdit_.LabelColor(LABEL_COLOR);
    cciPeriodSpinEdit_.LabelColorLocked(LABEL_LOCKED_COLOR);
    cciPeriodSpinEdit_.EditColorLocked(EDIT_LOCKED_COLOR);
    cciPeriodSpinEdit_.EditTextColor(EDIT_TEXT_COLOR);
    cciPeriodSpinEdit_.EditTextColorLocked(EDIT_LOCKED_TEXT_COLOR);
    cciPeriodSpinEdit_.EditBorderColor(EDIT_BORDER_COLOR);
    cciPeriodSpinEdit_.EditBorderColorLocked(EDIT_LOCKED_BORDER_COLOR);
    cciPeriodSpinEdit_.SpinEditState(cciEnableCheckbox_.CheckButtonState());
    x = baseX + INDICATOR_PERIOD_SPINEDIT_X_OFFSET;
    y = baseY + INDICATOR_PERIOD_SPINEDIT_Y_OFFSET;
    if (!cciPeriodSpinEdit_.CreateSpinEdit(m_chart_id, m_subwin, "Period", x, y))
      return false;
    CWndContainer::AddToElementsArray(0, cciPeriodSpinEdit_);

    // slider for trigger range setting
    cciRangeSlider_.WindowPointer(window1_);
    cciRangeSlider_.XSize(INDICATOR_RANGE_SLIDER_WIDTH);
    cciRangeSlider_.YSize(INDICATOR_RANGE_SLIDER_HEIGHT);
    cciRangeSlider_.EditXSize(INDICATOR_RANGE_SLIDER_EDIT_WIDTH);
    cciRangeSlider_.MinValue(CCI_RANGE_MIN_VALUE);
    cciRangeSlider_.MaxValue(CCI_RANGE_MAX_VALUE);
    cciRangeSlider_.StepValue(CCI_RANGE_STEP_VALUE);
    cciRangeSlider_.SetDigits(CCI_RANGE_DIGITS);
    cciRangeSlider_.SetLeftValue(CCI_RANGE_LEFT_START_VALUE);
    cciRangeSlider_.SetRightValue(RSI_RANGE_RIGHT_START_VALUE);
    cciRangeSlider_.AreaColor(AREA_COLOR);
    cciRangeSlider_.LabelColor(LABEL_COLOR);
    cciRangeSlider_.LabelColorLocked(LABEL_LOCKED_COLOR);
    cciRangeSlider_.EditColorLocked(EDIT_LOCKED_COLOR);
    cciRangeSlider_.EditBorderColor(EDIT_BORDER_COLOR);
    cciRangeSlider_.EditBorderColorLocked(EDIT_LOCKED_BORDER_COLOR);
    cciRangeSlider_.EditTextColor(EDIT_TEXT_COLOR);
    cciRangeSlider_.EditTextColorLocked(EDIT_LOCKED_TEXT_COLOR);
    cciRangeSlider_.SlotLineDarkColor(SLOT_LINE_DARK_COLOR);
    cciRangeSlider_.SlotLineLightColor(SLOT_LINE_LIGHT_COLOR);
    cciRangeSlider_.SlotIndicatorColor(SLOT_INDICATOR_COLOR);
    cciRangeSlider_.SlotIndicatorColorLocked(SLOT_INDICATOR_LOCKED_COLOR);
    cciRangeSlider_.SlotYSize(INDICATOR_RANGE_SLIDER_SLOT_HEIGHT);
    cciRangeSlider_.ThumbColorLocked(THUMB_LOCKED_COLOR);
    cciRangeSlider_.ThumbColorPressed(THUMB_COLOR_PRESSED);
    cciRangeSlider_.SliderState(cciEnableCheckbox_.CheckButtonState());
    x = baseX + INDICATOR_RANGE_SLIDER_X_OFFSET;
    y = baseY + INDICATOR_RANGE_SLIDER_Y_OFFSET;
    if(!cciRangeSlider_.CreateSlider(m_chart_id,m_subwin,"Range",x,y))
      return(false);
    CWndContainer::AddToElementsArray(0, cciRangeSlider_);

    return(true);
  }

//+------------------------------------------------------------------+
//|                                                                � |
//+------------------------------------------------------------------+
void CControlWindow::NotifyWindowChanged(ControlWindowChange change)
  {
  if (CheckPointer(listener_) != POINTER_INVALID)
   {
   listener_.OnControlWindowChanged(change);
   }
  }
