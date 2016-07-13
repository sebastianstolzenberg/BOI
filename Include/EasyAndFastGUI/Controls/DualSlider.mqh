//+------------------------------------------------------------------+
//|                                                   DualSlider.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Element.mqh"
#include "Window.mqh"
#include "SeparateLine.mqh"
//+------------------------------------------------------------------+
//| Class for creating a dual slider with edits                      |
//+------------------------------------------------------------------+
class CDualSlider : public CElement
  {
private:
   //--- Pointer to the form to which the element is attached
   CWindow          *m_wnd;
   //--- Objects for creating the element
   CRectLabel        m_area;
   CLabel            m_label;
   CEdit             m_left_edit;
   CEdit             m_right_edit;
   CSeparateLine     m_slot;
   CRectLabel        m_indicator;
   CRectLabel        m_left_thumb;
   CRectLabel        m_right_thumb;
   //--- Color of the element background
   color             m_area_color;
   //--- Text of the checkbox
   string            m_label_text;
   //--- Colors of the text label in different states
   color             m_label_color;
   color             m_label_color_hover;
   color             m_label_color_locked;
   color             m_label_color_array[];
   //--- The current value in the edits
   double            m_left_edit_value;
   double            m_right_edit_value;
   //--- Size of the edit
   int               m_edit_x_size;
   int               m_edit_y_size;
   //--- Colors of edit in different states
   color             m_edit_color;
   color             m_edit_color_locked;
   //--- Colors of the edit text in different states
   color             m_edit_text_color;
   color             m_edit_text_color_locked;
   //--- Colors of the edit frame in different states
   color             m_edit_border_color;
   color             m_edit_border_color_hover;
   color             m_edit_border_color_locked;
   color             m_edit_border_color_array[];
   //--- Size of the slit
   int               m_slot_y_size;
   //--- Colors of the slit
   color             m_slot_line_dark_color;
   color             m_slot_line_light_color;
   //--- Colors of the indicator in different states
   color             m_slot_indicator_color;
   color             m_slot_indicator_color_locked;
   //--- Size of the slider runner
   int               m_thumb_x_size;
   int               m_thumb_y_size;
   //--- Colors of the slider runner
   color             m_thumb_color;
   color             m_thumb_color_hover;
   color             m_thumb_color_locked;
   color             m_thumb_color_pressed;
   //--- Priorities of the left mouse button press
   int               m_zorder;
   int               m_area_zorder;
   int               m_edit_zorder;
   //--- (1) Minimum and (2) maximum value, (3) step for changing the value
   double            m_min_value;
   double            m_max_value;
   double            m_step_value;
   //--- Number of decimal places
   int               m_digits;
   //--- Mode of text alignment
   ENUM_ALIGN_MODE   m_align_mode;
   //--- Checkbox state (available/blocked)
   bool              m_slider_state;
   //--- Current position of the slider runners
   double            m_left_current_pos;
   double            m_left_current_pos_x;
   double            m_right_current_pos;
   double            m_right_current_pos_x;
   //--- Number of pixels in the working area
   int               m_pixels_total;
   //--- Number of steps in the working area
   int               m_value_steps_total;
   //--- Step in relation to the width of the working area
   double            m_position_step;
   //--- State of the left mouse button (pressed down/released)
   bool              m_mouse_state;
   //--- State of the mouse button (pressed/released)
   ENUM_THUMB_MOUSE_STATE m_clamping_mouse_left_thumb;
   ENUM_THUMB_MOUSE_STATE m_clamping_mouse_right_thumb;
   //--- To identify the mode of the slider runner movement
   bool              m_slider_thumb_state;
   //--- Variables connected with the slider movement
   int               m_slider_size_fixing;
   int               m_slider_point_fixing;
   //---
public:
                     CDualSlider(void);
                    ~CDualSlider(void);
   //--- Methods for creating the control
   bool              CreateSlider(const long chart_id,const int subwin,const string text,const int x,const int y);
   //---
private:
   bool              CreateArea(void);
   bool              CreateLabel(void);
   bool              CreateLeftEdit(void);
   bool              CreateRightEdit(void);
   bool              CreateSlot(void);
   bool              CreateIndicator(void);
   bool              CreateLeftThumb(void);
   bool              CreateRightThumb(void);
   //---
public:
   //--- (1) Stores the form pointer, (2) return/set the state of the control
   void              WindowPointer(CWindow &object)                 { m_wnd=::GetPointer(object);         }
   bool              SliderState(void) const                        { return(m_slider_state);             }
   void              SliderState(const bool state);
   //--- (1) Background color, (2) colors of the text label
   void              AreaColor(const color clr)                     { m_area_color=clr;                   }
   void              LabelColor(const color clr)                    { m_label_color=clr;                  }
   void              LabelColorHover(const color clr)               { m_label_color_hover=clr;            }
   void              LabelColorLocked(const color clr)              { m_label_color_locked=clr;           }
   //--- Size of (1) the edit and (2) the slot
   void              EditXSize(const int x_size)                    { m_edit_x_size=x_size;               }
   void              EditYSize(const int y_size)                    { m_edit_y_size=y_size;               }
   void              SlotYSize(const int y_size)                    { m_slot_y_size=y_size;               }
   //--- Colors of edit in different states
   void              EditColor(const color clr)                     { m_edit_color=clr;                   }
   void              EditColorLocked(const color clr)               { m_edit_color_locked=clr;            }
   //--- Colors of the edit text in different states
   void              EditTextColor(const color clr)                 { m_edit_text_color=clr;              }
   void              EditTextColorLocked(const color clr)           { m_edit_text_color_locked=clr;       }
   //--- Colors of the edit frame in different states
   void              EditBorderColor(const color clr)               { m_edit_border_color=clr;            }
   void              EditBorderColorHover(const color clr)          { m_edit_border_color_hover=clr;      }
   void              EditBorderColorLocked(const color clr)         { m_edit_border_color_locked=clr;     }
   //--- (1) Dark and (2) light color of the separation line (slit)
   void              SlotLineDarkColor(const color clr)             { m_slot_line_dark_color=clr;         }
   void              SlotLineLightColor(const color clr)            { m_slot_line_light_color=clr;        }
   //--- Colors of the slider indicator in different states
   void              SlotIndicatorColor(const color clr)            { m_slot_indicator_color=clr;         }
   void              SlotIndicatorColorLocked(const color clr)      { m_slot_indicator_color_locked=clr;  }
   //--- Size of the slider runner
   void              ThumbXSize(const int x_size)                   { m_thumb_x_size=x_size;              }
   void              ThumbYSize(const int y_size)                   { m_thumb_y_size=y_size;              }
   //--- Colors of the slider runner
   void              ThumbColor(const color clr)                    { m_thumb_color=clr;                  }
   void              ThumbColorHover(const color clr)               { m_thumb_color_hover=clr;            }
   void              ThumbColorLocked(const color clr)              { m_thumb_color_locked=clr;           }
   void              ThumbColorPressed(const color clr)             { m_thumb_color_pressed=clr;          }
   //--- Minimum value
   double            MinValue(void)                           const { return(m_min_value);                }
   void              MinValue(const double value)                   { m_min_value=value;                  }
   //--- Maximum value
   double            MaxValue(void)                           const { return(m_max_value);                }
   void              MaxValue(const double value)                   { m_max_value=value;                  }
   //--- Step of changing the value
   double            StepValue(void)                          const { return(m_step_value);               }
   void              StepValue(const double value)                  { m_step_value=(value<=0)? 1 : value; }
   //--- (1) Number of decimal places, (2) mode of text alignment
   void              SetDigits(const int digits)                    { m_digits=::fabs(digits);            }
   void              AlignMode(ENUM_ALIGN_MODE mode)                { m_align_mode=mode;                  }
   //--- Return and set the value in edits (left and right)
   double            GetLeftValue(void)                       const { return(m_left_edit_value);          }
   double            GetRightValue(void)                      const { return(m_right_edit_value);         }
   bool              SetLeftValue(double value);
   bool              SetRightValue(double value);
   //--- Changing values in edits (left and right)
   void              ChangeLeftValue(const double value);
   void              ChangeRightValue(const double value);
   //--- Changing the object color when the cursor is hovering over it
   void              ChangeObjectsColor(void);
   //--- Change the color of the slider runner
   void              ChangeThumbColor(void);
   //---
public:
   //--- Chart event handler
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Timer
   virtual void      OnEventTimer(void);
   //--- Moving the element
   virtual void      Moving(const int x,const int y);
   //--- (1) Show, (2) hide, (3) reset, (4) delete
   virtual void      Show(void);
   virtual void      Hide(void);
   virtual void      Reset(void);
   virtual void      Delete(void);
   //--- (1) Set, (2) reset priorities of the left mouse button press
   virtual void      SetZorders(void);
   virtual void      ResetZorders(void);
   //--- Reset the color
   virtual void      ResetColors(void) {}
   //---
private:
   //--- Handling the value entering in the edit
   bool              OnEndEdit(const string object_name);
   //--- Process of moving slider runners (left and right)
   void              OnDragLeftThumb(const int x);
   void              OnDragRightThumb(const int x);
   //--- Updating position of slider runners (left and right)
   void              UpdateLeftThumb(const int new_x_point);
   void              UpdateRightThumb(const int new_x_point);
   //--- Checks the state of the left mouse button over the slider runner
   void              CheckMouseOnLeftThumb(void);
   void              CheckMouseOnRightThumb(void);
   //--- Zeroing variables connected with the slider runner movement
   void              ZeroThumbVariables(void);
   //--- Calculation of values (steps and coefficients)
   bool              CalculateCoefficients(void);
   //--- Calculating the X coordinate of sliders (left and right)
   void              CalculateLeftThumbX(void);
   void              CalculateRightThumbX(void);
   //--- Changes position of the left slider runner in relation to the value (left and right)
   void              CalculateLeftThumbPos(void);
   void              CalculateRightThumbPos(void);
   //--- Updating the slider indicator
   void              UpdateIndicator(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CDualSlider::CDualSlider(void) : m_digits(2),
                                 m_left_edit_value(WRONG_VALUE),
                                 m_right_edit_value(WRONG_VALUE),
                                 m_align_mode(ALIGN_LEFT),
                                 m_slider_state(true),
                                 m_slider_size_fixing(0),
                                 m_slider_point_fixing(0),
                                 m_min_value(0),
                                 m_max_value(10),
                                 m_step_value(1),
                                 m_left_current_pos(WRONG_VALUE),
                                 m_right_current_pos(WRONG_VALUE),
                                 m_area_color(C'15,15,15'),
                                 m_label_color(clrWhite),
                                 m_label_color_hover(C'85,170,255'),
                                 m_label_color_locked(clrGray),
                                 m_edit_x_size(30),
                                 m_edit_y_size(18),
                                 m_edit_color(clrWhite),
                                 m_edit_color_locked(clrDimGray),
                                 m_edit_text_color(clrBlack),
                                 m_edit_text_color_locked(clrGray),
                                 m_edit_border_color(clrGray),
                                 m_edit_border_color_hover(C'85,170,255'),
                                 m_edit_border_color_locked(clrGray),
                                 m_slot_y_size(4),
                                 m_slot_line_dark_color(C'65,65,65'),
                                 m_slot_line_light_color(clrGray),
                                 m_slot_indicator_color(clrDodgerBlue),
                                 m_slot_indicator_color_locked(clrDimGray),
                                 m_thumb_x_size(6),
                                 m_thumb_y_size(14),
                                 m_thumb_color(C'170,170,170'),
                                 m_thumb_color_hover(C'200,200,200'),
                                 m_thumb_color_locked(clrGray),
                                 m_thumb_color_pressed(C'230,230,230')
  {
//--- Store the name of the element class in the base class
   CElement::ClassName(CLASS_NAME);
//--- Set priorities of the left mouse button click
   m_zorder      =0;
   m_area_zorder =1;
   m_edit_zorder =2;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CDualSlider::~CDualSlider(void)
  {
  }
//+------------------------------------------------------------------+
//| Chart event handler                                              |
//+------------------------------------------------------------------+
void CDualSlider::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling of the cursor movement event
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Leave, if the element is hidden   
      if(!CElement::IsVisible())
         return;
      //--- Coordinates and the state of the left mouse button
      int x=(int)lparam;
      int y=(int)dparam;
      m_mouse_state=(bool)int(sparam);
      //--- Checking the focus over elements
      CElement::MouseFocus(x>X() && x<X2() && y>Y() && y<Y2());
      m_left_thumb.MouseFocus(x>m_left_thumb.X() && x<m_left_thumb.X2() && 
                              y>m_left_thumb.Y() && y<m_left_thumb.Y2());
      m_right_thumb.MouseFocus(x>m_right_thumb.X() && x<m_right_thumb.X2() && 
                               y>m_right_thumb.Y() && y<m_right_thumb.Y2());
      //--- Leave, if the element is blocked
      if(!m_slider_state)
         return;
      //--- Check and store the state of the mouse button
      CheckMouseOnLeftThumb();
      CheckMouseOnRightThumb();
      //--- Change the color of the slider runner
      ChangeThumbColor();
      //--- If the management is passed to the slider line (left slider runner)
      if(m_clamping_mouse_left_thumb==THUMB_PRESSED_INSIDE)
        {
         //--- Moving the slider runner
         OnDragLeftThumb(x);
         //--- Calculation of the slider runner position in the value range
         CalculateLeftThumbPos();
         //--- Setting a new value in the edit
         ChangeLeftValue(m_left_current_pos);
         //--- Update the slider indicator
         UpdateIndicator();
         return;
        }
      //--- If the management is passed to the scrollbar (right slider runner)
      if(m_clamping_mouse_right_thumb==THUMB_PRESSED_INSIDE)
        {
         //--- Moving the slider runner
         OnDragRightThumb(x);
         //--- Calculation of the slider runner position in the value range
         CalculateRightThumbPos();
         //--- Setting a new value in the edit
         ChangeRightValue(m_right_current_pos);
         //--- Update the slider indicator
         UpdateIndicator();
         return;
        }
     }
//--- Handling the value change in edit event
   if(id==CHARTEVENT_OBJECT_ENDEDIT)
     {
      //--- Handling of the value entry
      if(OnEndEdit(sparam))
         return;
     }
  }
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+
void CDualSlider::OnEventTimer(void)
  {
//--- If the element is a drop-down
   if(CElement::IsDropdown())
      ChangeObjectsColor();
   else
     {
      //--- If the form and the element are not blocked
      if(!m_wnd.IsLocked())
         ChangeObjectsColor();
     }
  }
//+------------------------------------------------------------------+
//| Creates a group of editable edit control                         |
//+------------------------------------------------------------------+
bool CDualSlider::CreateSlider(const long chart_id,const int subwin,const string text,const int x,const int y)
  {
//--- Leave, if there is no form pointer  
   if(::CheckPointer(m_wnd)==POINTER_INVALID)
     {
      ::Print(__FUNCTION__," > Before creating a dual slider, the class must be passed "
              "the form pointer: CDualSlider::WindowPointer(CWindow &object)");
      return(false);
     }
//--- Initializing variables
   m_id         =m_wnd.LastId()+1;
   m_chart_id   =chart_id;
   m_subwin     =subwin;
   m_x          =x;
   m_y          =y;
   m_label_text =text;
//--- Margins from the edge
   CElement::XGap(m_x-m_wnd.X());
   CElement::YGap(m_y-m_wnd.Y());
//--- Creating an element
   if(!CreateArea())
      return(false);
   if(!CreateLabel())
      return(false);
   if(!CreateLeftEdit())
      return(false);
   if(!CreateRightEdit())
      return(false);
   if(!CreateSlot())
      return(false);
   if(!CreateIndicator())
      return(false);
   if(!CreateLeftThumb())
      return(false);
   if(!CreateRightThumb())
      return(false);
      
//--- Calculation of the X coordinates of the left slider runner in relation to the current value in the left edit
   CalculateLeftThumbX();
//--- Calculation of the left slider runner position in the value range
   CalculateLeftThumbPos();
//--- Update the slider runner
   UpdateLeftThumb(m_left_thumb.X());
//--- Update the slider indicator
   UpdateIndicator();
   
//--- Hide the element if the window is a dialog one or is minimized
   if(m_wnd.WindowType()==W_DIALOG || m_wnd.IsMinimized())
      Hide();
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Create area of editable edit control                             |
//+------------------------------------------------------------------+
bool CDualSlider::CreateArea(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_slider_area_"+(string)CElement::Id();
//--- Set the object
   if(!m_area.Create(m_chart_id,name,m_subwin,m_x,m_y,m_x_size,m_y_size))
      return(false);
//--- set properties
   m_area.BackColor(m_area_color);
   m_area.Color(m_area_color);
   m_area.BorderType(BORDER_FLAT);
   m_area.Corner(m_corner);
   m_area.Selectable(false);
   m_area.Z_Order(m_area_zorder);
//m_area.Hidden(true);
   m_area.Tooltip("\n");
//--- Store coordinates
   m_area.X(CElement::X());
   m_area.Y(CElement::Y());
//--- Size
   m_area.XSize(CElement::XSize());
   m_area.YSize(CElement::YSize());
//--- Margins from the edge
   m_area.XGap(CElement::m_x-m_wnd.X());
   m_area.YGap(CElement::m_y-m_wnd.Y());
//--- Store the object pointer
   CElement::AddToArray(m_area);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create label of editable edit control                            |
//+------------------------------------------------------------------+
bool CDualSlider::CreateLabel(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_slider_lable_"+(string)CElement::Id();
//--- Coordinates
   int x=CElement::X();
   int y=CElement::Y()+5;
//--- Set the object
   if(!m_label.Create(m_chart_id,name,m_subwin,x,y))
      return(false);
//--- set properties
   m_label.Description(m_label_text);
   m_label.Font(FONT);
   m_label.FontSize(FONT_SIZE);
   m_label.Color(m_label_color);
   m_label.Corner(m_corner);
   m_label.Anchor(m_anchor);
   m_label.Selectable(false);
   m_label.Z_Order(m_zorder);
//m_label.Hidden(true);
   m_label.Tooltip("\n");
//--- Store coordinates
   m_area.X(x);
   m_area.Y(y);
//--- Margins from the edge
   m_label.XGap(x-m_wnd.X());
   m_label.YGap(y-m_wnd.Y());
//--- Initializing gradient array
   InitColorArray(m_label_color,m_label_color_hover,m_label_color_array);
//--- Store the object pointer
   CElement::AddToArray(m_label);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create left edit control                                         |
//+------------------------------------------------------------------+
bool CDualSlider::CreateLeftEdit(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_slider_left_edit_"+(string)CElement::Id();
//--- Coordinates
   int x=CElement::X2()-(m_edit_x_size*2)-5;
   int y=CElement::Y()+3;
//--- Set the object
   if(!m_left_edit.Create(m_chart_id,name,m_subwin,x,y,m_edit_x_size,m_edit_y_size))
      return(false);
//--- set properties
   m_left_edit.Font(FONT);
   m_left_edit.FontSize(FONT_SIZE);
   m_left_edit.TextAlign(m_align_mode);
   m_left_edit.Description(::DoubleToString(m_left_edit_value,m_digits));
   m_left_edit.Color(m_edit_text_color);
   m_left_edit.BorderColor(m_edit_border_color);
   m_left_edit.BackColor(m_edit_color);
   m_left_edit.Corner(m_corner);
   m_left_edit.Anchor(m_anchor);
   m_left_edit.Selectable(false);
   m_left_edit.Z_Order(m_edit_zorder);
//m_left_edit.Hidden(true);
   m_left_edit.Tooltip("\n");
//--- Store coordinates
   m_left_edit.X(x);
   m_left_edit.Y(y);
//--- Size
   m_left_edit.XSize(m_edit_x_size);
   m_left_edit.YSize(m_edit_y_size);
//--- Margins from the edge
   m_left_edit.XGap(x-m_wnd.X());
   m_left_edit.YGap(y-m_wnd.Y());
//--- Initializing gradient array
   InitColorArray(m_edit_border_color,m_edit_border_color_hover,m_edit_border_color_array);
//--- Store the object pointer
   CElement::AddToArray(m_left_edit);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create right edit control                                        |
//+------------------------------------------------------------------+
bool CDualSlider::CreateRightEdit(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_slider_right_edit_"+(string)CElement::Id();
//--- Coordinates
   int x=CElement::X2()-m_edit_x_size;
   int y=CElement::Y()+3;
//--- Set the object
   if(!m_right_edit.Create(m_chart_id,name,m_subwin,x,y,m_edit_x_size,m_edit_y_size))
      return(false);
//--- set properties
   m_right_edit.Font(FONT);
   m_right_edit.FontSize(FONT_SIZE);
   m_right_edit.TextAlign(m_align_mode);
   m_right_edit.Description(::DoubleToString(m_right_edit_value,m_digits));
   m_right_edit.Color(m_edit_text_color);
   m_right_edit.BorderColor(m_edit_border_color);
   m_right_edit.BackColor(m_edit_color);
   m_right_edit.Corner(m_corner);
   m_right_edit.Anchor(m_anchor);
   m_right_edit.Selectable(false);
   m_right_edit.Z_Order(m_edit_zorder);
//m_right_edit.Hidden(true);
   m_right_edit.Tooltip("\n");
//--- Store coordinates
   m_right_edit.X(x);
   m_right_edit.Y(y);
//--- Size
   m_right_edit.XSize(m_edit_x_size);
   m_right_edit.YSize(m_edit_y_size);
//--- Margins from the edge
   m_right_edit.XGap(x-m_wnd.X());
   m_right_edit.YGap(y-m_wnd.Y());
//--- Initializing gradient array
   InitColorArray(m_edit_border_color,m_edit_border_color_hover,m_edit_border_color_array);
//--- Store the object pointer
   CElement::AddToArray(m_right_edit);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create slot for the scrollbar                                    |
//+------------------------------------------------------------------+
bool CDualSlider::CreateSlot(void)
  {
//--- Store the form pointer
   m_slot.WindowPointer(m_wnd);
//--- set properties
   m_slot.TypeSepLine(H_SEP_LINE);
   m_slot.DarkColor(m_slot_line_dark_color);
   m_slot.LightColor(m_slot_line_light_color);
//--- Creating a separation line
   if(!m_slot.CreateSeparateLine(m_chart_id,m_subwin,0,CElement::X(),CElement::Y()+30,CElement::XSize(),m_slot_y_size))
      return(false);
//--- Store the object pointer
   CElement::AddToArray(m_slot.Object(0));
   return(true);
  }
//+------------------------------------------------------------------+
//| Create scrollbar indicator                                       |
//+------------------------------------------------------------------+
bool CDualSlider::CreateIndicator(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_slider_indicator_"+(string)CElement::Id();
//--- Coordinates
   int x=CElement::X();
   int y=m_slot.Y()+1;
//--- Size
   int y_size=m_slot_y_size-2;
//--- Set the object
   if(!m_indicator.Create(m_chart_id,name,m_subwin,x,y,m_x_size,y_size))
      return(false);
//--- set properties
   m_indicator.BackColor(m_slot_indicator_color);
   m_indicator.Color(m_slot_indicator_color);
   m_indicator.BorderType(BORDER_FLAT);
   m_indicator.Corner(m_corner);
   m_indicator.Selectable(false);
   m_indicator.Z_Order(m_zorder);
//m_indicator.Hidden(true);
   m_indicator.Tooltip("\n");
//--- Store coordinates
   m_indicator.X(x);
   m_indicator.Y(y);
//--- Size
   m_indicator.XSize(CElement::XSize());
   m_indicator.YSize(y_size);
//--- Margins from the edge
   m_indicator.XGap(x-m_wnd.X());
   m_indicator.YGap(y-m_wnd.Y());
//--- Store the object pointer
   CElement::AddToArray(m_indicator);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the left scrollbar                                       |
//+------------------------------------------------------------------+
bool CDualSlider::CreateLeftThumb(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_slider_left_thumb_"+(string)CElement::Id();
//--- Coordinates
   int x=CElement::X();
   int y=m_slot.Y()-((m_thumb_y_size-m_slot_y_size)/2);
//--- Set the object
   if(!m_left_thumb.Create(m_chart_id,name,m_subwin,x,y,m_thumb_x_size,m_thumb_y_size))
      return(false);
//--- set properties
   m_left_thumb.BackColor(m_thumb_color);
   m_left_thumb.Color(m_thumb_color);
   m_left_thumb.BorderType(BORDER_FLAT);
   m_left_thumb.Corner(m_corner);
   m_left_thumb.Selectable(false);
   m_left_thumb.Z_Order(m_zorder);
//m_left_thumb.Hidden(true);
   m_left_thumb.Tooltip("\n");
//--- Store the size (in the object)
   m_left_thumb.XSize(m_thumb_x_size);
   m_left_thumb.YSize(m_thumb_y_size);
//--- Store coordinates
   m_left_thumb.X(x);
   m_left_thumb.Y(y);
//--- Margins from the edge
   m_left_thumb.XGap(x-m_wnd.X());
   m_left_thumb.YGap(y-m_wnd.Y());
//--- Store the object pointer
   CElement::AddToArray(m_left_thumb);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the right scrollbar                                      |
//+------------------------------------------------------------------+
bool CDualSlider::CreateRightThumb(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_slider_right_thumb_"+(string)CElement::Id();
//--- Coordinates
   int x=CElement::X();
   int y=m_slot.Y()-((m_thumb_y_size-m_slot_y_size)/2);
//--- Set the object
   if(!m_right_thumb.Create(m_chart_id,name,m_subwin,x,y,m_thumb_x_size,m_thumb_y_size))
      return(false);
//--- set properties
   m_right_thumb.BackColor(m_thumb_color);
   m_right_thumb.Color(m_thumb_color);
   m_right_thumb.BorderType(BORDER_FLAT);
   m_right_thumb.Corner(m_corner);
   m_right_thumb.Selectable(false);
   m_right_thumb.Z_Order(m_zorder);
//m_right_thumb.Hidden(true);
   m_right_thumb.Tooltip("\n");
//--- Store the size (in the object)
   m_right_thumb.XSize(m_thumb_x_size);
   m_right_thumb.YSize(m_thumb_y_size);
//--- Store coordinates
   m_right_thumb.X(x);
   m_right_thumb.Y(y);
//--- Margins from the edge
   m_right_thumb.XGap(x-m_wnd.X());
   m_right_thumb.YGap(y-m_wnd.Y());
//--- Calculation of the values of auxiliary variables
   CalculateCoefficients();
//--- Calculation of the X coordinates of the slider runner in relation to the current value in the edit
   CalculateRightThumbX();
//--- Calculation of the slider runner position in the value range
   CalculateRightThumbPos();
//--- Update the slider runner
   UpdateRightThumb(m_right_thumb.X());
//--- Update the slider indicator
   UpdateIndicator();
//--- Store the object pointer
   CElement::AddToArray(m_right_thumb);
   return(true);
  }
//+------------------------------------------------------------------+
//| Set the current value in the left edit control                   |
//+------------------------------------------------------------------+
bool CDualSlider::SetLeftValue(double value)
  {
//--- Adjust considering the step
   double corrected_value=::MathRound(value/m_step_value)*m_step_value;
//--- Check for the minimum/maximum
   if(corrected_value<=m_min_value)
      corrected_value=m_min_value;
   if(corrected_value>=m_max_value)
      corrected_value=m_max_value;
//--- If the value has been changed
   if(m_left_edit_value!=corrected_value)
     {
      m_left_edit_value=corrected_value;
      return(true);
     }
//--- Value unchanged
   return(false);
  }
//+------------------------------------------------------------------+
//| Changing the value in the left edit                              |
//+------------------------------------------------------------------+
void CDualSlider::ChangeLeftValue(const double value)
  {
//--- Check, adjust and store the new value
   SetLeftValue(value);
//--- Set the new value in the edit
   m_left_edit.Description(::DoubleToString(GetLeftValue(),m_digits));
  }
//+------------------------------------------------------------------+
//| Set the current value in the right edit control                  |
//+------------------------------------------------------------------+
bool CDualSlider::SetRightValue(double value)
  {
//--- Adjust considering the step
   double corrected_value=::MathRound(value/m_step_value)*m_step_value;
//--- Check for the minimum/maximum
   if(corrected_value<=m_min_value)
      corrected_value=m_min_value;
   if(corrected_value>=m_max_value)
      corrected_value=m_max_value;
//--- If the value has been changed
   if(m_right_edit_value!=corrected_value)
     {
      m_right_edit_value=corrected_value;
      return(true);
     }
//--- Value unchanged
   return(false);
  }
//+------------------------------------------------------------------+
//| Changing the value in the right edit                             |
//+------------------------------------------------------------------+
void CDualSlider::ChangeRightValue(const double value)
  {
//--- Check, adjust and store the new value
   SetRightValue(value);
//--- Set the new value in the edit
   m_right_edit.Description(::DoubleToString(GetRightValue(),m_digits));
  }
//+------------------------------------------------------------------+
//| Change the state of the control                                  |
//+------------------------------------------------------------------+
void CDualSlider::SliderState(const bool state)
  {
//--- Control state
   m_slider_state=state;
//--- Color of the text label
   m_label.Color((state)? m_label_color : m_label_color_locked);
//--- Color of the edit
   m_left_edit.Color((state)? m_edit_text_color : m_edit_text_color_locked);
   m_left_edit.BackColor((state)? m_edit_color : m_edit_color_locked);
   m_left_edit.BorderColor((state)? m_edit_border_color : m_edit_border_color_locked);
   m_right_edit.Color((state)? m_edit_text_color : m_edit_text_color_locked);
   m_right_edit.BackColor((state)? m_edit_color : m_edit_color_locked);
   m_right_edit.BorderColor((state)? m_edit_border_color : m_edit_border_color_locked);
//--- Color of the indicator
   m_indicator.BackColor((state)? m_slot_indicator_color : m_slot_indicator_color_locked);
   m_indicator.Color((state)? m_slot_indicator_color : m_slot_indicator_color_locked);
//--- Color of the slider runner
   m_left_thumb.BackColor((state)? m_thumb_color : m_thumb_color_locked);
   m_left_thumb.Color((state)? m_thumb_color : m_thumb_color_locked);
   m_right_thumb.BackColor((state)? m_thumb_color : m_thumb_color_locked);
   m_right_thumb.Color((state)? m_thumb_color : m_thumb_color_locked);
//--- Setting in relation of the current state
   if(!m_slider_state)
     {
      //--- Edit in the read only mode
      m_left_edit.ReadOnly(true);
      m_right_edit.ReadOnly(true);
     }
   else
     {
      //--- The edit control in the edit mode
      m_left_edit.ReadOnly(false);
      m_right_edit.ReadOnly(false);
     }
  }
//+------------------------------------------------------------------+
//| Changing the object color when the cursor is hovering over it    |
//+------------------------------------------------------------------+
void CDualSlider::ChangeObjectsColor(void)
  {
//--- Leave, if the control is blocked or is in the mode of the slider runner movement
   if(!m_slider_state || m_slider_thumb_state)
      return;
//---
   CElement::ChangeObjectColor(m_label.Name(),CElement::MouseFocus(),OBJPROP_COLOR,m_label_color,m_label_color_hover,m_label_color_array);
   CElement::ChangeObjectColor(m_left_edit.Name(),CElement::MouseFocus(),OBJPROP_BORDER_COLOR,m_edit_border_color,m_edit_border_color_hover,m_edit_border_color_array);
   CElement::ChangeObjectColor(m_right_edit.Name(),CElement::MouseFocus(),OBJPROP_BORDER_COLOR,m_edit_border_color,m_edit_border_color_hover,m_edit_border_color_array);
  }
//+------------------------------------------------------------------+
//| Change the color of the scrollbar                                |
//+------------------------------------------------------------------+
void CDualSlider::ChangeThumbColor(void)
  {
//--- Leave, if the form is blocked and the identifier of the currently active element differs
   if(m_wnd.IsLocked() && m_wnd.IdActivatedElement()!=CElement::Id())
      return;
//--- If the cursor is in the left slider runner area
   if(m_left_thumb.MouseFocus())
     {
      //--- If the left mouse button is released
      if(m_clamping_mouse_left_thumb==THUMB_NOT_PRESSED)
        {
         m_slider_thumb_state=false;
         m_left_thumb.Color(m_thumb_color_hover);
         m_left_thumb.BackColor(m_thumb_color_hover);
         return;
        }
      //--- Left mouse button is pressed
      else if(m_clamping_mouse_left_thumb==THUMB_PRESSED_INSIDE)
        {
         m_slider_thumb_state=true;
         m_left_thumb.Color(m_thumb_color_pressed);
         m_left_thumb.BackColor(m_thumb_color_pressed);
         return;
        }
     }
//--- If the cursor is outside the left slider runner area
   else
     {
      //--- Left mouse button is released
      if(!m_mouse_state)
        {
         m_slider_thumb_state=false;
         m_left_thumb.Color(m_thumb_color);
         m_left_thumb.BackColor(m_thumb_color);
        }
     }
//--- If the cursor is in the right slider runner area
   if(m_right_thumb.MouseFocus())
     {
      //--- If the left mouse button is released     
      if(m_clamping_mouse_right_thumb==THUMB_NOT_PRESSED)
        {
         m_slider_thumb_state=false;
         m_right_thumb.Color(m_thumb_color_hover);
         m_right_thumb.BackColor(m_thumb_color_hover);
         return;
        }
      //--- Left mouse button is pressed
      else if(m_clamping_mouse_right_thumb==THUMB_PRESSED_INSIDE)
        {
         m_slider_thumb_state=true;
         m_right_thumb.Color(m_thumb_color_pressed);
         m_right_thumb.BackColor(m_thumb_color_pressed);
         return;
        }
     }
//--- If the cursor is outside the right slider runner area
   else
     {
      //--- Left mouse button is released
      if(!m_mouse_state)
        {
         m_slider_thumb_state=false;
         m_right_thumb.Color(m_thumb_color);
         m_right_thumb.BackColor(m_thumb_color);
        }
     }
  }
//+------------------------------------------------------------------+
//| Moving elements                                                  |
//+------------------------------------------------------------------+
void CDualSlider::Moving(const int x,const int y)
  {
//--- Leave, if the element is hidden
   if(!CElement::IsVisible())
      return;
//--- Storing indents in the element fields
   CElement::X(x+XGap());
   CElement::Y(y+YGap());
//--- Storing coordinates in the fields of the objects
   m_area.X(x+m_area.XGap());
   m_area.Y(y+m_area.YGap());
   m_label.X(x+m_label.XGap());
   m_label.Y(y+m_label.YGap());
   m_left_edit.X(x+m_left_edit.XGap());
   m_left_edit.Y(y+m_left_edit.YGap());
   m_right_edit.X(x+m_right_edit.XGap());
   m_right_edit.Y(y+m_right_edit.YGap());
   m_indicator.X(x+m_indicator.XGap());
   m_indicator.Y(y+m_indicator.YGap());
   m_left_thumb.X(x+m_left_thumb.XGap());
   m_left_thumb.Y(y+m_left_thumb.YGap());
   m_right_thumb.X(x+m_right_thumb.XGap());
   m_right_thumb.Y(y+m_right_thumb.YGap());
//--- Updating coordinates of graphical objects  
   m_area.X_Distance(m_area.X());
   m_area.Y_Distance(m_area.Y());
   m_label.X_Distance(m_label.X());
   m_label.Y_Distance(m_label.Y());
   m_left_edit.X_Distance(m_left_edit.X());
   m_left_edit.Y_Distance(m_left_edit.Y());
   m_right_edit.X_Distance(m_right_edit.X());
   m_right_edit.Y_Distance(m_right_edit.Y());
   m_indicator.X_Distance(m_indicator.X());
   m_indicator.Y_Distance(m_indicator.Y());
   m_left_thumb.X_Distance(m_left_thumb.X());
   m_left_thumb.Y_Distance(m_left_thumb.Y());
   m_right_thumb.X_Distance(m_right_thumb.X());
   m_right_thumb.Y_Distance(m_right_thumb.Y());
//--- Moving the slot
   m_slot.Moving(x,y);
  }
//+------------------------------------------------------------------+
//| Shows a menu item                                                |
//+------------------------------------------------------------------+
void CDualSlider::Show(void)
  {
//--- Leave, if the element is already visible
   if(CElement::IsVisible())
      return;
//--- Make all objects visible
   for(int i=0; i<CElement::ObjectsElementTotal(); i++)
      CElement::Object(i).Timeframes(OBJ_ALL_PERIODS);
//--- State of visibility
   CElement::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Hides a menu item                                                |
//+------------------------------------------------------------------+
void CDualSlider::Hide(void)
  {
//--- Leave, if the element is already visible
   if(!CElement::IsVisible())
      return;
//--- Hide all objects
   for(int i=0; i<CElement::ObjectsElementTotal(); i++)
      CElement::Object(i).Timeframes(OBJ_NO_PERIODS);
//--- State of visibility
   CElement::IsVisible(false);
  }
//+------------------------------------------------------------------+
//| Redrawing                                                        |
//+------------------------------------------------------------------+
void CDualSlider::Reset(void)
  {
//--- Leave, if this is a drop-down element
   if(CElement::IsDropdown())
      return;
//--- Hide and show
   Hide();
   Show();
  }
//+------------------------------------------------------------------+
//| Deletion                                                         |
//+------------------------------------------------------------------+
void CDualSlider::Delete(void)
  {
//--- Removing objects  
   m_area.Delete();
   m_label.Delete();
   m_left_edit.Delete();
   m_right_edit.Delete();
   m_slot.Delete();
   m_indicator.Delete();
   m_left_thumb.Delete();
   m_right_thumb.Delete();
//--- Emptying the array of the objects
   CElement::FreeObjectsArray();
  }
//+------------------------------------------------------------------+
//| Seth the priorities                                              |
//+------------------------------------------------------------------+
void CDualSlider::SetZorders(void)
  {
//--- Leave, if the element is blocked
   if(!m_slider_state)
      return;
//--- Set the default values
   m_area.Z_Order(m_area_zorder);
   m_label.Z_Order(m_zorder);
   m_left_edit.Z_Order(m_edit_zorder);
   m_right_edit.Z_Order(m_edit_zorder);
   m_indicator.Z_Order(m_zorder);
   m_left_thumb.Z_Order(m_zorder);
   m_right_thumb.Z_Order(m_zorder);
//--- The edit control in the edit mode
   m_left_edit.ReadOnly(false);
   m_right_edit.ReadOnly(false);
  }
//+------------------------------------------------------------------+
//| Reset the priorities                                             |
//+------------------------------------------------------------------+
void CDualSlider::ResetZorders(void)
  {
//--- Leave, if the element is blocked
   if(!m_slider_state)
      return;
//--- Zeroing priorities
   m_area.Z_Order(0);
   m_label.Z_Order(0);
   m_left_edit.Z_Order(0);
   m_right_edit.Z_Order(0);
   m_indicator.Z_Order(0);
   m_left_thumb.Z_Order(0);
   m_right_thumb.Z_Order(0);
//--- Edit in the read only mode
   m_left_edit.ReadOnly(true);
   m_right_edit.ReadOnly(true);
  }
//+------------------------------------------------------------------+
//| End of entering the value                                        |
//+------------------------------------------------------------------+
bool CDualSlider::OnEndEdit(const string object_name)
  {
//--- If the value is entered in the left edit
   if(object_name==m_left_edit.Name())
     {
      //--- Get the entered value
      double entered_value=::StringToDouble(m_left_edit.Description());
      //--- Check, adjust and store the new value
      ChangeLeftValue(entered_value);
      //--- Calculate the X coordinate of the slider runner
      CalculateLeftThumbX();
      //--- Updating the slider runner location
      UpdateLeftThumb(m_left_thumb.X());
      //--- Calculate the position in the value range
      CalculateLeftThumbPos();
      //--- Setting a new value in the edit
      ChangeLeftValue(m_left_current_pos);
      //--- Update the slider indicator
      UpdateIndicator();
      //--- Send a message about it
      ::EventChartCustom(m_chart_id,ON_END_EDIT,CElement::Id(),CElement::Index(),m_label.Description());
      return(true);
     }
//--- If the value is entered in the right edit
   if(object_name==m_right_edit.Name())
     {
      //--- Get the entered value
      double entered_value=::StringToDouble(m_right_edit.Description());
      //--- Check, adjust and store the new value
      ChangeRightValue(entered_value);
      //--- Calculate the X coordinate of the slider runner
      CalculateRightThumbX();
      //--- Updating the slider runner location
      UpdateRightThumb(m_right_thumb.X());
      //--- Calculate the position in the value range
      CalculateRightThumbPos();
      //--- Setting a new value in the edit
      ChangeRightValue(m_right_current_pos);
      //--- Update the slider indicator
      UpdateIndicator();
      //--- Send a message about it
      ::EventChartCustom(m_chart_id,ON_END_EDIT,CElement::Id(),CElement::Index(),m_label.Description());
      return(true);
     }
//---
   return(false);
  }
//+------------------------------------------------------------------+
//| Process of the left slider runner movement                       |
//+------------------------------------------------------------------+
void CDualSlider::OnDragLeftThumb(const int x)
  {
//--- To identify the new X coordinate  
   int new_x_point=0;
//--- If the slider runner is inactive, ...
   if(!m_slider_thumb_state)
     {
      //--- ...zero auxiliary variables for moving the slider
      m_slider_point_fixing =0;
      m_slider_size_fixing  =0;
      return;
     }
//--- If the fixation point is zero, store current coordinates of the cursor
   if(m_slider_point_fixing==0)
      m_slider_point_fixing=x;
//--- If the distance from the edge of the slider to the current coordinate of the cursor is zero, calculate it
   if(m_slider_size_fixing==0)
      m_slider_size_fixing=m_left_thumb.X()-x;
//--- If the threshold is passed to the right in the pressed down state
   if(x-m_slider_point_fixing>0)
     {
      //--- Calculate the X coordinate
      new_x_point=x+m_slider_size_fixing;
      //--- Updating the scrollbar location
      UpdateLeftThumb(new_x_point);
      return;
     }
//--- If the threshold is passed to the left in the pressed down state
   if(x-m_slider_point_fixing<0)
     {
      //--- Calculate the X coordinate
      new_x_point=x-::fabs(m_slider_size_fixing);
      //--- Updating the scrollbar location
      UpdateLeftThumb(new_x_point);
      return;
     }
  }
//+------------------------------------------------------------------+
//| Process of the right slider runner movement                      |
//+------------------------------------------------------------------+
void CDualSlider::OnDragRightThumb(const int x)
  {
//--- To identify the new X coordinate  
   int new_x_point=0;
//--- If the slider runner is inactive, ...
   if(!m_slider_thumb_state)
     {
      //--- ...zero auxiliary variables for moving the slider
      m_slider_point_fixing =0;
      m_slider_size_fixing  =0;
      return;
     }
//--- If the fixation point is zero, store current coordinates of the cursor
   if(m_slider_point_fixing==0)
      m_slider_point_fixing=x;
//--- If the distance from the edge of the slider to the current coordinate of the cursor is zero, calculate it
   if(m_slider_size_fixing==0)
      m_slider_size_fixing=m_right_thumb.X()-x;
//--- If the threshold is passed to the right in the pressed down state
   if(x-m_slider_point_fixing>0)
     {
      //--- Calculate the X coordinate
      new_x_point=x+m_slider_size_fixing;
      //--- Updating the scrollbar location
      UpdateRightThumb(new_x_point);
      return;
     }
//--- If the threshold is passed to the left in the pressed down state
   if(x-m_slider_point_fixing<0)
     {
      //--- Calculate the X coordinate
      new_x_point=x-::fabs(m_slider_size_fixing);
      //--- Updating the scrollbar location
      UpdateRightThumb(new_x_point);
      return;
     }
  }
//+------------------------------------------------------------------+
//| Updating the left slider runner location                         |
//+------------------------------------------------------------------+
void CDualSlider::UpdateLeftThumb(const int new_x_point)
  {
   int x=new_x_point;
//--- Zeroing the fixation point
   m_slider_point_fixing=0;
//--- Check for exceeding the working area
   if(new_x_point<m_area.X())
      x=m_area.X();
   int right_limit=m_right_thumb.X()-m_right_thumb.XSize();
   if(new_x_point>=right_limit)
      x=right_limit-1;
//--- Update the list view and scrollbar
   m_left_thumb.X(x);
   m_left_thumb.X_Distance(x);
//--- Store margins
   m_left_thumb.XGap(m_left_thumb.X()-m_wnd.X());
  }
//+------------------------------------------------------------------+
//| Updating the right slider runner location                        |
//+------------------------------------------------------------------+
void CDualSlider::UpdateRightThumb(const int new_x_point)
  {
   int x=new_x_point;
//--- Zeroing the fixation point
   m_slider_point_fixing=0;
//--- Check for exceeding the working area
   int right_limit=m_area.X2()-m_right_thumb.XSize();
   if(new_x_point>right_limit)
      x=right_limit;
   if(new_x_point<=m_left_thumb.X2())
      x=m_left_thumb.X2()+1;
//--- Update the list view and scrollbar
   m_right_thumb.X(x);
   m_right_thumb.X_Distance(x);
//--- Store margins
   m_right_thumb.XGap(m_right_thumb.X()-m_wnd.X());
  }
//+------------------------------------------------------------------+
//| Calculation of values (steps and coefficients)                   |
//+------------------------------------------------------------------+
bool CDualSlider::CalculateCoefficients(void)
  {
//--- Leave, if the width of the element is less than the width of the slider runner
   if(CElement::XSize()<m_thumb_x_size*2+1)
      return(false);
//--- Number of pixels in the working area
   m_pixels_total=CElement::XSize()-m_thumb_x_size;
//--- Number of steps in the value range of the working area
   m_value_steps_total=int((m_max_value-m_min_value)/m_step_value);
//--- Step in relation to the width of the working area
   m_position_step=m_step_value*(double(m_value_steps_total)/double(m_pixels_total));
   return(true);
  }
//+------------------------------------------------------------------+
//| Calculating the X coordinate of the left slider runner           |
//+------------------------------------------------------------------+
void CDualSlider::CalculateLeftThumbX(void)
  {
//--- Adjustment considering that the minimum value can be negative
   double neg_range=(m_min_value<0)? ::fabs(m_min_value/m_position_step) : 0;
//--- Calculate the X coordinate for the slider runner
   m_left_current_pos_x=m_area.X()+(m_left_edit_value/m_position_step)+neg_range;
//--- If the working area is exceeded on the left
   if(m_left_current_pos_x<m_area.X())
      m_left_current_pos_x=m_area.X();
//--- If the working area is exceeded on the right
   if(m_left_current_pos_x>m_right_thumb.X())
      m_left_current_pos_x=m_right_thumb.X()-m_left_thumb.XSize();
//--- Store and set the new X coordinate
   m_left_thumb.X(int(m_left_current_pos_x));
   m_left_thumb.X_Distance(int(m_left_current_pos_x));
   m_left_thumb.XGap(m_left_thumb.X()-m_wnd.X());
  }
//+------------------------------------------------------------------+
//| Calculating the X coordinate of the right slider runner          |
//+------------------------------------------------------------------+
void CDualSlider::CalculateRightThumbX(void)
  {
//--- Adjustment considering that the minimum value can be negative
   double neg_range=(m_min_value<0)? ::fabs(m_min_value/m_position_step) : 0;
//--- Calculate the X coordinate for the slider runner
   m_right_current_pos_x=m_area.X()+(m_right_edit_value/m_position_step)+neg_range;
//--- If the working area is exceeded on the left
   if(m_right_current_pos_x<m_area.X())
      m_right_current_pos_x=m_area.X();
//--- If the working area is exceeded on the right
   if(m_right_current_pos_x+m_right_thumb.XSize()>m_area.X2())
      m_right_current_pos_x=m_area.X2()-m_right_thumb.XSize();
//--- Store and set the new X coordinate
   m_right_thumb.X(int(m_right_current_pos_x));
   m_right_thumb.X_Distance(int(m_right_current_pos_x));
   m_right_thumb.XGap(m_right_thumb.X()-m_wnd.X());
  }
//+------------------------------------------------------------------+
//| Changes position of the left slider runner in relation to value  |
//+------------------------------------------------------------------+
void CDualSlider::CalculateLeftThumbPos(void)
  {
//--- Get the position number of the slider runner
   m_left_current_pos=(m_left_thumb.X()-m_area.X())*m_position_step;
//--- Adjustment considering that the minimum value can be negative
   if(m_min_value<0 && m_left_current_pos_x!=WRONG_VALUE)
      m_left_current_pos+=int(m_min_value);
//--- Check for exceeding the working area on the left
   if(m_left_thumb.X()<=m_area.X())
      m_left_current_pos=int(m_min_value);
  }
//+------------------------------------------------------------------+
//| Changes position of the right slider runner in relation to value |
//+------------------------------------------------------------------+
void CDualSlider::CalculateRightThumbPos(void)
  {
//--- Get the position number of the slider runner
   m_right_current_pos=(m_right_thumb.X()-m_area.X())*m_position_step;
//--- Adjustment considering that the minimum value can be negative
   if(m_min_value<0 && m_right_current_pos_x!=WRONG_VALUE)
      m_right_current_pos+=int(m_min_value);
//--- Check for exceeding the working area on the right
   if(m_right_thumb.X2()>=m_area.X2())
      m_right_current_pos=int(m_max_value);
  }
//+------------------------------------------------------------------+
//| Zeroing variables connected with the slider runner movement      |
//+------------------------------------------------------------------+
void CDualSlider::ZeroThumbVariables(void)
  {
//--- If you are here, it means that the left mouse button is released.
//    If the left mouse button was pressed over the slider runner...
   if(m_clamping_mouse_left_thumb==THUMB_PRESSED_INSIDE || 
      m_clamping_mouse_right_thumb==THUMB_PRESSED_INSIDE)
     {
      //--- ... send a message that changing of the value in the entry field with the sider runner is completed
      ::EventChartCustom(m_chart_id,ON_END_EDIT,CElement::Id(),CElement::Index(),m_label.Description());
     }
//---
   m_slider_size_fixing         =0;
   m_clamping_mouse_left_thumb  =THUMB_NOT_PRESSED;
   m_clamping_mouse_right_thumb =THUMB_NOT_PRESSED;
//--- If the element identifier matches the activating identifier,
//    unblock the form and reset the identifier of the activated element
   if(CElement::Id()==m_wnd.IdActivatedElement())
     {
      m_wnd.IsLocked(false);
      m_wnd.IdActivatedElement(WRONG_VALUE);
     }
  }
//+------------------------------------------------------------------+
//| Verifies the state of the mouse button                           |
//+------------------------------------------------------------------+
void CDualSlider::CheckMouseOnLeftThumb(void)
  {
//--- If the left mouse button is released
   if(!m_mouse_state)
     {
      //--- Zero variables
      ZeroThumbVariables();
      return;
     }
//--- If the left mouse button is pressed
   else
     {
      //--- Leave, if the button is pressed down in another area
      if(m_clamping_mouse_left_thumb!=THUMB_NOT_PRESSED)
         return;
      //--- Outside of the scrollbar area
      if(!m_left_thumb.MouseFocus())
         m_clamping_mouse_left_thumb=THUMB_PRESSED_OUTSIDE;
      //--- Inside the scrollbar area
      else
        {
         //--- If inside the scrollbar
         m_clamping_mouse_left_thumb=THUMB_PRESSED_INSIDE;
         //--- Block the form and store the active element identifier
         m_wnd.IsLocked(true);
         m_wnd.IdActivatedElement(CElement::Id());
        }
     }
  }
//+------------------------------------------------------------------+
//| Verifies the state of the mouse button                           |
//+------------------------------------------------------------------+
void CDualSlider::CheckMouseOnRightThumb(void)
  {
//--- If the left mouse button is released
   if(!m_mouse_state)
     {
      //--- Zero variables
      ZeroThumbVariables();
      return;
     }
//--- If the left mouse button is pressed
   else
     {
      //--- Leave, if the button is pressed down in another area
      if(m_clamping_mouse_right_thumb!=THUMB_NOT_PRESSED)
         return;
      //--- Outside of the scrollbar area
      if(!m_right_thumb.MouseFocus())
         m_clamping_mouse_right_thumb=THUMB_PRESSED_OUTSIDE;
      //--- Inside the scrollbar area
      else
        {
         //--- If inside the scrollbar
         m_clamping_mouse_right_thumb=THUMB_PRESSED_INSIDE;
         //--- Block the form and store the active element identifier
         m_wnd.IsLocked(true);
         m_wnd.IdActivatedElement(CElement::Id());
        }
     }
  }
//+------------------------------------------------------------------+
//| Updating the slider indicator                                    |
//+------------------------------------------------------------------+
void CDualSlider::UpdateIndicator(void)
  {
//--- Calculate the size
   int x_size=m_right_thumb.X()-m_left_thumb.X();
//--- Adjustment in case of impermissible values
   if(x_size<=0)
      x_size=1;
//--- Set new values. (1) Coordinates, (2) size, (3) margin
   m_indicator.X(m_left_thumb.X2());
   m_indicator.X_Distance(m_left_thumb.X2());
   m_indicator.X_Size(x_size);
   m_indicator.XGap(m_indicator.X()-m_wnd.X());
  }
//+------------------------------------------------------------------+
