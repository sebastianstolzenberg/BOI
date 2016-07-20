//+------------------------------------------------------------------+
//|                                                ControlWindow.mqh |
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
const int WINDOW_HEIGHT = 200;

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

// BB control constants
const bool BB_DEFAULT_STATE = true;
const int BB_X = INDICATOR_X_OFFSET;
const int BB_Y = INDICATOR_Y_OFFSET;
const int BB_PERIOD_MIN_VALUE = 1;
const int BB_PERIOD_MAX_VALUE = 100;
const int BB_PERIOD_STEP_VALUE = 1;
const int BB_PERIOD_DIGITS = 0;
const int BB_PERIOD_START_VALUE = 14;
const int BB_SHIFT_MIN_VALUE = 0;
const int BB_SHIFT_MAX_VALUE = 100;
const int BB_SHIFT_STEP_VALUE = 1;
const int BB_SHIFT_DIGITS = 0;
const int BB_SHIFT_START_VALUE = 0;
const int BB_DEVIATION_MIN_VALUE = 0;
const int BB_DEVIATION_MAX_VALUE = 100;
const double BB_DEVIATION_STEP_VALUE = 0.1;
const int BB_DEVIATION_DIGITS = 1;
const int BB_DEVIATION_START_VALUE = 2;

// WPR control constants
const bool WPR_DEFAULT_STATE = true;
const int WPR_X = INDICATOR_X_OFFSET;
const int WPR_Y = BB_Y + INDICATOR_RANGE_SLIDER_HEIGHT;
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
  CWC_WPR_ENABLED,
  CWC_WPR_PERIOD,
  CWC_WPR_THRESHOLD,
  CWC_RSI_ENABLED,
  CWC_RSI_PERIOD,
  CWC_RSI_THRESHOLD,
  CWC_CCI_ENABLED,
  CWC_CCI_PERIOD,
  CWC_CCI_THRESHOLD,
  CWC_BB_ENABLED,
  CWC_BB_PARAMETERS
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

   //--- BB controls
   CCheckBox         bbEnableCheckbox_;
   CSpinEdit         bbPeriodSpinEdit_;
   CSpinEdit         bbShiftSpinEdit_;
   CSpinEdit         bbDeviationSpinEdit_;

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


   //--- BB parameters
   bool              IsBbEnabled();
   int               GetBbPeriod();
   int               GetBbShift();
   double            GetBbDeviation();

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
   bool              CreateBbControls();
   bool              CreateWprControls();
   bool              CreateRsiControls();
   bool              CreateCciControls();

   bool              CreateCheckBox(CCheckBox& checkBox, const string label,
                                    bool value, int x, int y);
   bool              CreateSpinEdit(CSpinEdit& spinEdit, const string label,
                                    double max, double min, 
                                    double step, int digits, double value, 
                                    bool enabled, int x, int y);
   bool              CreateDualSlider(CDualSlider& dualSlider, const string label,
                                      double max, double min, 
                                      double step, int digits, 
                                      double leftValue, double rightValue, 
                                      bool enabled, int x, int y);

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
      if(lparam==bbEnableCheckbox_.Id())
        {
         bbPeriodSpinEdit_.SpinEditState(bbEnableCheckbox_.CheckButtonState());
         bbShiftSpinEdit_.SpinEditState(bbEnableCheckbox_.CheckButtonState());
         bbDeviationSpinEdit_.SpinEditState(bbEnableCheckbox_.CheckButtonState());
         NotifyWindowChanged(CWC_BB_ENABLED);
        }
      if(lparam==wprEnableCheckbox_.Id())
        {
         wprPeriodSpinEdit_.SpinEditState(wprEnableCheckbox_.CheckButtonState());
         wprRangeSlider_.SliderState(wprEnableCheckbox_.CheckButtonState());
         NotifyWindowChanged(CWC_WPR_ENABLED);
        }
      if(lparam==rsiEnableCheckbox_.Id())
        {
         rsiPeriodSpinEdit_.SpinEditState(rsiEnableCheckbox_.CheckButtonState());
         rsiRangeSlider_.SliderState(rsiEnableCheckbox_.CheckButtonState());
         NotifyWindowChanged(CWC_RSI_ENABLED);
        }
      if(lparam==cciEnableCheckbox_.Id())
        {
         cciPeriodSpinEdit_.SpinEditState(cciEnableCheckbox_.CheckButtonState());
         cciRangeSlider_.SliderState(cciEnableCheckbox_.CheckButtonState());
         NotifyWindowChanged(CWC_CCI_ENABLED);
        }
     }
    if(lparam==bbPeriodSpinEdit_.Id() || lparam==bbShiftSpinEdit_.Id() || lparam==bbDeviationSpinEdit_.Id())
    {
      ::Print(__FUNCTION__," > id: ",id,"; lparam: ",lparam,"; dparam: ",dparam,"; sparam: ",sparam);
      NotifyWindowChanged(CWC_BB_PARAMETERS);
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
//| Returns BB parameters                                           |
//+------------------------------------------------------------------+
bool CControlWindow::IsBbEnabled()
{
  return bbEnableCheckbox_.CheckButtonState();
}
int CControlWindow::GetBbPeriod()
{
  return (int)bbPeriodSpinEdit_.GetValue();
}
int CControlWindow::GetBbShift()
{
  return (int)bbShiftSpinEdit_.GetValue();
}
double CControlWindow::GetBbDeviation()
{
  return bbDeviationSpinEdit_.GetValue();
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

   if(!CreateBbControls())
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
//| Creates form 1 for controls         
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
//| Creates WPR controls
//+------------------------------------------------------------------+
bool CControlWindow::CreateBbControls()
  {
    const int baseX = window1_.X() + BB_X;
    const int baseY = window1_.Y() + BB_Y;
    

    // checkbox
    int x = baseX + INDICATOR_ENABLE_CHECKBOX_X_OFFSET;
    int y = baseY + INDICATOR_ENABLE_CHECKBOX_Y_OFFSET;
    if (!CreateCheckBox(bbEnableCheckbox_, "BB", BB_DEFAULT_STATE, x, y))
      return false;

    // spin edit for period
    x = baseX + INDICATOR_PERIOD_SPINEDIT_X_OFFSET;
    y = baseY + INDICATOR_PERIOD_SPINEDIT_Y_OFFSET;
    if (!CreateSpinEdit(bbPeriodSpinEdit_, "Period", 
              BB_PERIOD_MAX_VALUE, BB_PERIOD_MIN_VALUE, BB_PERIOD_STEP_VALUE,
              BB_PERIOD_DIGITS, BB_PERIOD_START_VALUE,
              bbEnableCheckbox_.CheckButtonState(), x, y))
      return false;

    // spin edit for shift
    x += bbPeriodSpinEdit_.XSize();
    if (!CreateSpinEdit(bbShiftSpinEdit_, "Shift", 
              BB_SHIFT_MAX_VALUE, BB_SHIFT_MIN_VALUE, BB_SHIFT_STEP_VALUE,
              BB_SHIFT_DIGITS, BB_SHIFT_START_VALUE,
              bbEnableCheckbox_.CheckButtonState(), x, y))
      return false;

    // spin edit for deviation
    x += bbShiftSpinEdit_.XSize();
    if (!CreateSpinEdit(bbDeviationSpinEdit_, "Dev.", 
              BB_DEVIATION_MAX_VALUE, BB_DEVIATION_MIN_VALUE, BB_DEVIATION_STEP_VALUE,
              BB_DEVIATION_DIGITS, BB_DEVIATION_START_VALUE,
              bbEnableCheckbox_.CheckButtonState(), x, y))
      return false;

    return(true);
  }
//+------------------------------------------------------------------+
//| Creates WPR controls
//+------------------------------------------------------------------+
bool CControlWindow::CreateWprControls()
  {
    const int baseX = window1_.X() + WPR_X;
    const int baseY = window1_.Y() + WPR_Y;
    

    // checkbox
    int x = baseX + INDICATOR_ENABLE_CHECKBOX_X_OFFSET;
    int y = baseY + INDICATOR_ENABLE_CHECKBOX_Y_OFFSET;
    if (!CreateCheckBox(wprEnableCheckbox_, "WPR", WPR_DEFAULT_STATE, x, y))
      return false;

    // spin edit for period
    x = baseX + INDICATOR_PERIOD_SPINEDIT_X_OFFSET;
    y = baseY + INDICATOR_PERIOD_SPINEDIT_Y_OFFSET;
    if (!CreateSpinEdit(wprPeriodSpinEdit_, "Period", 
          WPR_PERIOD_MAX_VALUE, WPR_PERIOD_MIN_VALUE, WPR_PERIOD_STEP_VALUE,
          WPR_PERIOD_DIGITS, WPR_PERIOD_START_VALUE,
          wprEnableCheckbox_.CheckButtonState(), x, y))
      return false;

    // slider for trigger range setting
    x = baseX + INDICATOR_RANGE_SLIDER_X_OFFSET;
    y = baseY + INDICATOR_RANGE_SLIDER_Y_OFFSET;
    if (!CreateDualSlider(wprRangeSlider_, "Range", 
      WPR_RANGE_MAX_VALUE, WPR_RANGE_MIN_VALUE, WPR_RANGE_STEP_VALUE,
      WPR_RANGE_DIGITS, WPR_RANGE_LEFT_START_VALUE, WPR_RANGE_RIGHT_START_VALUE,
      wprEnableCheckbox_.CheckButtonState(), x, y))
      return false;

    return(true);
  }
//+------------------------------------------------------------------+
//| Creates RSI controls   
//+------------------------------------------------------------------+
bool CControlWindow::CreateRsiControls()
  {
    const int baseX = window1_.X() + RSI_X;
    const int baseY = window1_.Y() + RSI_Y;
    

    // checkbox
    int x = baseX + INDICATOR_ENABLE_CHECKBOX_X_OFFSET;
    int y = baseY + INDICATOR_ENABLE_CHECKBOX_Y_OFFSET;
    if (!CreateCheckBox(rsiEnableCheckbox_, "RSI", RSI_DEFAULT_STATE, x, y))
      return false;

    // spin edit for period
    x = baseX + INDICATOR_PERIOD_SPINEDIT_X_OFFSET;
    y = baseY + INDICATOR_PERIOD_SPINEDIT_Y_OFFSET;
    if (!CreateSpinEdit(rsiPeriodSpinEdit_, "Period", 
          RSI_PERIOD_MAX_VALUE, RSI_PERIOD_MIN_VALUE, RSI_PERIOD_STEP_VALUE,
          RSI_PERIOD_DIGITS, RSI_PERIOD_START_VALUE,
          rsiEnableCheckbox_.CheckButtonState(), x, y))
      return false;

    // slider for trigger range setting
    x = baseX + INDICATOR_RANGE_SLIDER_X_OFFSET;
    y = baseY + INDICATOR_RANGE_SLIDER_Y_OFFSET;
    if (!CreateDualSlider(rsiRangeSlider_, "Range", 
      RSI_RANGE_MAX_VALUE, RSI_RANGE_MIN_VALUE, RSI_RANGE_STEP_VALUE,
      RSI_RANGE_DIGITS, RSI_RANGE_LEFT_START_VALUE, RSI_RANGE_RIGHT_START_VALUE,
      rsiEnableCheckbox_.CheckButtonState(), x, y))
      return false;

    return(true);
  }
//+------------------------------------------------------------------+
//| Creates RSI controls   
//+------------------------------------------------------------------+
bool CControlWindow::CreateCciControls()
  {
    const int baseX = window1_.X() + CCI_X;
    const int baseY = window1_.Y() + CCI_Y;
    

    // checkbox
    int x = baseX + INDICATOR_ENABLE_CHECKBOX_X_OFFSET;
    int y = baseY + INDICATOR_ENABLE_CHECKBOX_Y_OFFSET;
    if (!CreateCheckBox(cciEnableCheckbox_, "CCI", CCI_DEFAULT_STATE, x, y))
      return false;

    // spin edit for period
    x = baseX + INDICATOR_PERIOD_SPINEDIT_X_OFFSET;
    y = baseY + INDICATOR_PERIOD_SPINEDIT_Y_OFFSET;
    if (!CreateSpinEdit(cciPeriodSpinEdit_, "Period", 
          CCI_PERIOD_MAX_VALUE, CCI_PERIOD_MIN_VALUE, CCI_PERIOD_STEP_VALUE,
          CCI_PERIOD_DIGITS, CCI_PERIOD_START_VALUE,
          cciEnableCheckbox_.CheckButtonState(), x, y))
      return false;

    // slider for trigger range setting
    x = baseX + INDICATOR_RANGE_SLIDER_X_OFFSET;
    y = baseY + INDICATOR_RANGE_SLIDER_Y_OFFSET;
    if (!CreateDualSlider(cciRangeSlider_, "Range", 
      CCI_RANGE_MAX_VALUE, CCI_RANGE_MIN_VALUE, CCI_RANGE_STEP_VALUE,
      CCI_RANGE_DIGITS, CCI_RANGE_LEFT_START_VALUE, RSI_RANGE_RIGHT_START_VALUE,
      cciEnableCheckbox_.CheckButtonState(), x, y))
      return false;

    return(true);
  }

bool CControlWindow::CreateCheckBox(CCheckBox& checkBox, const string label,
                                    bool value, int x, int y)
{
  checkBox.WindowPointer(window1_);
  checkBox.XSize(INDICATOR_ENABLE_CHECKBOX_WIDTH);
  checkBox.YSize(INDICATOR_ENABLE_CHECKBOX_HEIGHT);
  checkBox.AreaColor(AREA_COLOR);
  checkBox.LabelColor(LABEL_COLOR);
  checkBox.LabelColorOff(LABEL_OFF_COLOR);
  checkBox.LabelColorLocked(LABEL_LOCKED_COLOR);
  checkBox.CheckButtonState(value);
  if (!checkBox.CreateCheckBox(m_chart_id, m_subwin, label, x, y))
    return false;
  CWndContainer::AddToElementsArray(0, checkBox);
  return true;
}

bool CControlWindow::CreateSpinEdit(CSpinEdit& spinEdit, const string label,
  double max, double min, double step, int digits, double value, 
  bool enabled, int x, int y)
{
  spinEdit.WindowPointer(window1_);
  spinEdit.XSize(INDICATOR_PERIOD_SPINEDIT_WIDTH);
  spinEdit.YSize(INDICATOR_PERIOD_SPINEDIT_HEIGHT);
  spinEdit.EditXSize(INDICATOR_PERIOD_SPINEDIT_EDIT_WIDTH);
  spinEdit.MaxValue(max);
  spinEdit.MinValue(min);
  spinEdit.StepValue(step);
  spinEdit.SetDigits(digits);
  spinEdit.SetValue(value);
  spinEdit.ResetMode(true);
  spinEdit.AreaColor(AREA_COLOR);
  spinEdit.LabelColor(LABEL_COLOR);
  spinEdit.LabelColorLocked(LABEL_LOCKED_COLOR);
  spinEdit.EditColorLocked(EDIT_LOCKED_COLOR);
  spinEdit.EditTextColor(EDIT_TEXT_COLOR);
  spinEdit.EditTextColorLocked(EDIT_LOCKED_TEXT_COLOR);
  spinEdit.EditBorderColor(EDIT_BORDER_COLOR);
  spinEdit.EditBorderColorLocked(EDIT_LOCKED_BORDER_COLOR);
  spinEdit.SpinEditState(enabled);
  if (!spinEdit.CreateSpinEdit(m_chart_id, m_subwin, label, x, y))
    return false;
  CWndContainer::AddToElementsArray(0, spinEdit);
  return true;
}

bool CControlWindow::CreateDualSlider(CDualSlider& dualSlider, const string label,
  double max, double min, double step, int digits, double leftValue, double rightValue, 
  bool enabled, int x, int y)
{
  dualSlider.WindowPointer(window1_);
  dualSlider.XSize(INDICATOR_RANGE_SLIDER_WIDTH);
  dualSlider.YSize(INDICATOR_RANGE_SLIDER_HEIGHT);
  dualSlider.EditXSize(INDICATOR_RANGE_SLIDER_EDIT_WIDTH);
  dualSlider.MinValue(min);
  dualSlider.MaxValue(max);
  dualSlider.StepValue(step);
  dualSlider.SetDigits(digits);
  dualSlider.SetLeftValue(leftValue);
  dualSlider.SetRightValue(rightValue);
  dualSlider.AreaColor(AREA_COLOR);
  dualSlider.LabelColor(LABEL_COLOR);
  dualSlider.LabelColorLocked(LABEL_LOCKED_COLOR);
  dualSlider.EditColorLocked(EDIT_LOCKED_COLOR);
  dualSlider.EditBorderColor(EDIT_BORDER_COLOR);
  dualSlider.EditBorderColorLocked(EDIT_LOCKED_BORDER_COLOR);
  dualSlider.EditTextColor(EDIT_TEXT_COLOR);
  dualSlider.EditTextColorLocked(EDIT_LOCKED_TEXT_COLOR);
  dualSlider.SlotLineDarkColor(SLOT_LINE_DARK_COLOR);
  dualSlider.SlotLineLightColor(SLOT_LINE_LIGHT_COLOR);
  dualSlider.SlotIndicatorColor(SLOT_INDICATOR_COLOR);
  dualSlider.SlotIndicatorColorLocked(SLOT_INDICATOR_LOCKED_COLOR);
  dualSlider.SlotYSize(INDICATOR_RANGE_SLIDER_SLOT_HEIGHT);
  dualSlider.ThumbColorLocked(THUMB_LOCKED_COLOR);
  dualSlider.ThumbColorPressed(THUMB_COLOR_PRESSED);
  dualSlider.SliderState(enabled);
  if(!dualSlider.CreateSlider(m_chart_id,m_subwin,label,x,y))
    return(false);
  CWndContainer::AddToElementsArray(0, dualSlider);
  return true;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CControlWindow::NotifyWindowChanged(ControlWindowChange change)
  {
  if (CheckPointer(listener_) != POINTER_INVALID)
   {
   listener_.OnControlWindowChanged(change);
   }
  }
