//+------------------------------------------------------------------+
//|                                                 WndContainer.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Window.mqh"
#include "MenuBar.mqh"
#include "MenuItem.mqh"
#include "ContextMenu.mqh"
#include "SeparateLine.mqh"
#include "SimpleButton.mqh"
#include "IconButton.mqh"
#include "SplitButton.mqh"
#include "ButtonsGroup.mqh"
#include "IconButtonsGroup.mqh"
#include "RadioButtons.mqh"
#include "StatusBar.mqh"
#include "Tooltip.mqh"
#include "ListView.mqh"
#include "ComboBox.mqh"
#include "CheckBox.mqh"
#include "SpinEdit.mqh"
#include "CheckBoxEdit.mqh"
#include "CheckComboBox.mqh"
#include "Slider.mqh"
#include "DualSlider.mqh"
//+------------------------------------------------------------------+
//| Class for storing all interface objects                          |
//+------------------------------------------------------------------+
class CWndContainer
  {
private:
   //--- Element counter
   int               m_counter_element_id;
   //---
protected:
   //--- Window array
   CWindow          *m_windows[];
   //--- Structure of element arrays
   struct WindowElements
     {
      //--- Common array of all objects
      CChartObject     *m_objects[];
      //--- Common array of all elements
      CElement         *m_elements[];

      //--- Private arrays of elements:
      //    Context menu array
      CContextMenu     *m_context_menus[];
      //--- Array of main menus
      CMenuBar         *m_menu_bars[];
      //--- Tooltips
      CTooltip         *m_tooltips[];
      //--- Array of drop-down list views of different types
      CElement         *m_drop_lists[];
     };
   //--- Array of element arrays for each window
   WindowElements    m_wnd[];
   //---
protected:
                     CWndContainer(void);
                    ~CWndContainer(void);
   //---
public:
   //--- Number of windows in the interface
   int               WindowsTotal(void) { return(::ArraySize(m_windows)); }
   //--- Number of objects of all elements
   int               ObjectsElementsTotal(const int window_index);
   //--- Number of elements
   int               ElementsTotal(const int window_index);
   //--- Number of context menus
   int               ContextMenusTotal(const int window_index);
   //--- Number of main menus
   int               MenuBarsTotal(const int window_index);
   //--- Number of tooltips
   int               TooltipsTotal(const int window_index);
   //--- Number of drop-down list views
   int               DropListsTotal(const int window_index);
   //---
protected:
   //--- Adds a window pointer to the base of interface elements
   void              AddWindow(CWindow &object);
   //--- Adds element object pointers to the common array
   template<typename T>
   void              AddToObjectsArray(const int window_index,T &object);
   //--- Adds the object pointer to the array
   void              AddToArray(const int window_index,CChartObject &object);
   //--- Adds a pointer to the element array
   void              AddToElementsArray(const int window_index,CElement &object);
   //--- Template method for adding pointers to the array passed by a link
   template<typename T1,typename T2>
   void              AddToRefArray(T1 &object,T2 &ref_array[]);
   //---
private:
   //--- Stores pointers to the context menu elements in the base
   bool              AddContextMenuElements(const int window_index,CElement &object);
   //--- Stores pointers to the main menu elements in the base
   bool              AddMenuBarElements(const int window_index,CElement &object);
   //--- Stores pointers to the split button elements in the base
   bool              AddSplitButtonElements(const int window_index,CElement &object);
   //--- Stores pointers to the tooltip elements in the base
   bool              AddTooltipElements(const int window_index,CElement &object);
   //--- Stores pointers to the list view objects in the base
   bool              AddListViewElements(const int window_index,CElement &object);
   //--- Stores pointers to the drop-down list views elements in the base (combobox)
   bool              AddComboBoxElements(const int window_index,CElement &object);
   //--- Stores pointers to the drop-down list views elements in the base (combobox with checkbox)
   bool              AddCheckComboBoxElements(const int window_index,CElement &object);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CWndContainer::CWndContainer(void) : m_counter_element_id(0)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CWndContainer::~CWndContainer(void)
  {
  }
//+------------------------------------------------------------------+
//| Returns the object number by the specified window index          |
//+------------------------------------------------------------------+
int CWndContainer::ObjectsElementsTotal(const int window_index)
  {
   if(window_index>=::ArraySize(m_wnd))
     {
      ::Print(PREVENTING_OUT_OF_RANGE);
      return(WRONG_VALUE);
     }
//---
   return(::ArraySize(m_wnd[window_index].m_objects));
  }
//+------------------------------------------------------------------+
//| Returns the element number by the specified window index         |
//+------------------------------------------------------------------+
int CWndContainer::ElementsTotal(const int window_index)
  {
   if(window_index>=::ArraySize(m_wnd))
     {
      ::Print(PREVENTING_OUT_OF_RANGE);
      return(WRONG_VALUE);
     }
//---
   return(::ArraySize(m_wnd[window_index].m_elements));
  }
//+------------------------------------------------------------------+
//| Returns the number of context menus by the specified window index|
//+------------------------------------------------------------------+
int CWndContainer::ContextMenusTotal(const int window_index)
  {
   if(window_index>=::ArraySize(m_wnd))
     {
      ::Print(PREVENTING_OUT_OF_RANGE);
      return(WRONG_VALUE);
     }
//---
   return(::ArraySize(m_wnd[window_index].m_context_menus));
  }
//+------------------------------------------------------------------+
//| Returns the number of main menus by the specified window index   |
//+------------------------------------------------------------------+
int CWndContainer::MenuBarsTotal(const int window_index)
  {
   if(window_index>=::ArraySize(m_wnd))
     {
      ::Print(PREVENTING_OUT_OF_RANGE);
      return(WRONG_VALUE);
     }
//---
   return(::ArraySize(m_wnd[window_index].m_menu_bars));
  }
//+------------------------------------------------------------------+
//| Returns the number of tooltips by the specified window index     |
//+------------------------------------------------------------------+
int CWndContainer::TooltipsTotal(const int window_index)
  {
   if(window_index>=::ArraySize(m_wnd))
     {
      ::Print(PREVENTING_OUT_OF_RANGE);
      return(WRONG_VALUE);
     }
//---
   return(::ArraySize(m_wnd[window_index].m_tooltips));
  }
//+------------------------------------------------------------------+
//| Returns number of drop-down list views by specified window index |
//+------------------------------------------------------------------+
int CWndContainer::DropListsTotal(const int window_index)
  {
   if(window_index>=::ArraySize(m_wnd))
     {
      ::Print(PREVENTING_OUT_OF_RANGE);
      return(WRONG_VALUE);
     }
//---
   return(::ArraySize(m_wnd[window_index].m_drop_lists));
  }
//+------------------------------------------------------------------+
//| Adds the window pointer to the base of the interface elements    |
//+------------------------------------------------------------------+
void CWndContainer::AddWindow(CWindow &object)
  {
   int windows_total=::ArraySize(m_windows);
//--- If there are not windows, zero the element counter
   if(windows_total<1)
      m_counter_element_id=0;
//--- Add the pointer to the window array
   ::ArrayResize(m_wnd,windows_total+1);
   ::ArrayResize(m_windows,windows_total+1);
   m_windows[windows_total]=::GetPointer(object);
//--- Add the pointer to the common array of elements
   int elements_total=::ArraySize(m_wnd[windows_total].m_elements);
   ::ArrayResize(m_wnd[windows_total].m_elements,elements_total+1);
   m_wnd[windows_total].m_elements[elements_total]=::GetPointer(object);
//--- Add element objects to the common array of objects
   AddToObjectsArray(windows_total,object);
//--- Set the identifier and store the id of the last element
   m_windows[windows_total].Id(m_counter_element_id);
   m_windows[windows_total].LastId(m_counter_element_id);
//--- Increase the counter of the element identifiers
   m_counter_element_id++;
  }
//+------------------------------------------------------------------+
//| Adds the element object pointers to the common array             |
//+------------------------------------------------------------------+
template<typename T>
void CWndContainer::AddToObjectsArray(const int window_index,T &object)
  {
   int total=object.ObjectsElementTotal();
   for(int i=0; i<total; i++)
      AddToArray(window_index,object.Object(i));
  }
//+------------------------------------------------------------------+
//| Adds an object pointer to the array                              |
//+------------------------------------------------------------------+
void CWndContainer::AddToArray(const int window_index,CChartObject &object)
  {
   int size=::ArraySize(m_wnd[window_index].m_objects);
   ::ArrayResize(m_wnd[window_index].m_objects,size+1);
   m_wnd[window_index].m_objects[size]=::GetPointer(object);
  }
//+------------------------------------------------------------------+
//| Adds a pointer to the element array                              |
//+------------------------------------------------------------------+
void CWndContainer::AddToElementsArray(const int window_index,CElement &object)
  {
//--- If the base does not contain forms for controls
   if(::ArraySize(m_windows)<1)
     {
      ::Print(__FUNCTION__," > Before creating a control, create a form "
              "and add it to the base using the CWndContainer::AddWindow(CWindow &object) method.");
      return;
     }
//--- If the request is for a non-existent form
   if(window_index>=::ArraySize(m_windows))
     {
      Print(PREVENTING_OUT_OF_RANGE," window_index: ",window_index,"; ArraySize(m_windows): ",::ArraySize(m_windows));
      return;
     }
//--- Add to the common array of elements
   int size=::ArraySize(m_wnd[window_index].m_elements);
   ::ArrayResize(m_wnd[window_index].m_elements,size+1);
   m_wnd[window_index].m_elements[size]=::GetPointer(object);
//--- Add element objects to the common array of objects
   AddToObjectsArray(window_index,object);
//--- Store the id of the last element in all forms
   int windows_total=::ArraySize(m_windows);
   for(int w=0; w<windows_total; w++)
      m_windows[w].LastId(m_counter_element_id);
//--- Increase the counter of the element identifiers
   m_counter_element_id++;

//--- Stores pointers to the context menu objects in the base
   if(AddContextMenuElements(window_index,object))
      return;
//--- Stores pointers to the main menu objects in the base
   if(AddMenuBarElements(window_index,object))
      return;
//--- Stores pointers to the split button objects in the base
   if(AddSplitButtonElements(window_index,object))
      return;
//--- Stores pointers to the tooltip objects in the base
   if(AddTooltipElements(window_index,object))
      return;
//--- Stores pointers to the list view objects in the base
   if(AddListViewElements(window_index,object))
      return;
//--- Stores pointers to the combobox control objects in the base
   if(AddComboBoxElements(window_index,object))
      return;
//--- Stores pointers to the combobox with a checkbox control objects in the base
   if(AddCheckComboBoxElements(window_index,object))
      return;
  }
//+------------------------------------------------------------------+
//| Stores the pointers to the context menu objects in the base      |
//+------------------------------------------------------------------+
bool CWndContainer::AddContextMenuElements(const int window_index,CElement &object)
  {
//--- Leave, if this is not a context menu
   if(object.ClassName()!="CContextMenu")
      return(false);
//--- Get the context menu pointer
   CContextMenu *cm=::GetPointer(object);
//--- Store the pointers to its objects in the base
   int items_total=cm.ItemsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- Increasing the element array
      int size=::ArraySize(m_wnd[window_index].m_elements);
      ::ArrayResize(m_wnd[window_index].m_elements,size+1);
      //--- Getting the menu item pointer
      CMenuItem *mi=cm.ItemPointerByIndex(i);
      //--- Store the pointer in the array
      m_wnd[window_index].m_elements[size]=mi;
      //--- Add the pointers to all menu item objects to the common array
      AddToObjectsArray(window_index,mi);
     }
//--- Add the pointer to the private array
   AddToRefArray(cm,m_wnd[window_index].m_context_menus);
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores the pointers to the main menu objects in the base         |
//+------------------------------------------------------------------+
bool CWndContainer::AddMenuBarElements(const int window_index,CElement &object)
  {
//--- Leave, if this is not the main menu
   if(object.ClassName()!="CMenuBar")
      return(false);
//--- Get the main menu pointer
   CMenuBar *mb=::GetPointer(object);
//--- Store the pointers to its objects in the base
   int items_total=mb.ItemsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- Increasing the element array
      int size=::ArraySize(m_wnd[window_index].m_elements);
      ::ArrayResize(m_wnd[window_index].m_elements,size+1);
      //--- Getting the menu item pointer
      CMenuItem *mi=mb.ItemPointerByIndex(i);
      //--- Store the pointer in the array
      m_wnd[window_index].m_elements[size]=mi;
      //--- Add the pointers to all menu item objects to the common array
      AddToObjectsArray(window_index,mi);
     }
//--- Add the pointer to the private array
   AddToRefArray(mb,m_wnd[window_index].m_menu_bars);
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores the pointers to the elements of a split button in the base|
//+------------------------------------------------------------------+
bool CWndContainer::AddSplitButtonElements(const int window_index,CElement &object)
  {
//--- Leave, if this is not a split button
   if(object.ClassName()!="CSplitButton")
      return(false);
//--- Get the split button pointer
   CSplitButton *sb=::GetPointer(object);
//--- Increasing the element array
   int size=::ArraySize(m_wnd[window_index].m_elements);
   ::ArrayResize(m_wnd[window_index].m_elements,size+1);
//--- Getting the context menu pointer
   CContextMenu *cm=sb.GetContextMenuPointer();
//--- Store the element and objects in the base
   m_wnd[window_index].m_elements[size]=cm;
   AddToObjectsArray(window_index,cm);
//--- Store the pointers to its objects in the base
   int items_total=cm.ItemsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- Increasing the element array
      size=::ArraySize(m_wnd[window_index].m_elements);
      ::ArrayResize(m_wnd[window_index].m_elements,size+1);
      //--- Getting the menu item pointer
      CMenuItem *mi=cm.ItemPointerByIndex(i);
      //--- Store the pointer in the array
      m_wnd[window_index].m_elements[size]=mi;
      //--- Add the pointers to all menu item objects to the common array
      AddToObjectsArray(window_index,mi);
     }
//--- Add the pointer to the private array
   AddToRefArray(cm,m_wnd[window_index].m_context_menus);
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores the tooltip pointer in the private array                  |
//+------------------------------------------------------------------+
bool CWndContainer::AddTooltipElements(const int window_index,CElement &object)
  {
//--- Leave, if this is not a tooltip
   if(object.ClassName()!="CTooltip")
      return(false);
//--- Get the tooltip pointer
   CTooltip *t=::GetPointer(object);
//--- Add the pointer to the private array
   AddToRefArray(t,m_wnd[window_index].m_tooltips);
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores the pointers to the list view objects in the base         |
//+------------------------------------------------------------------+
bool CWndContainer::AddListViewElements(const int window_index,CElement &object)
  {
//--- Leave, if this is not a list view
   if(object.ClassName()!="CListView")
      return(false);
//--- Get the list view pointer
   CListView *lv=::GetPointer(object);
//--- Increasing the element array
   int size=::ArraySize(m_wnd[window_index].m_elements);
   ::ArrayResize(m_wnd[window_index].m_elements,size+1);
//--- Get the scrollbar pointer
   CScrollV *sv=lv.GetScrollVPointer();
//--- Store the element in the base
   m_wnd[window_index].m_elements[size]=sv;
   AddToObjectsArray(window_index,sv);
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores the pointer to the drop-down list view in a private array |
//| (combobox)                                                       |
//+------------------------------------------------------------------+
bool CWndContainer::AddComboBoxElements(const int window_index,CElement &object)
  {
//--- Leave, if this is not a combobox
   if(object.ClassName()!="CComboBox")
      return(false);
//--- Get the combobox pointer
   CComboBox *cb=::GetPointer(object);
//---
   for(int i=0; i<2; i++)
     {
      //--- Increasing the element array
      int size=::ArraySize(m_wnd[window_index].m_elements);
      ::ArrayResize(m_wnd[window_index].m_elements,size+1);
      //--- Add the list to the base
      if(i==0)
        {
         CListView *lv=cb.GetListViewPointer();
         m_wnd[window_index].m_elements[size]=lv;
         AddToObjectsArray(window_index,lv);
         //--- Add the pointer to the private array
         AddToRefArray(lv,m_wnd[window_index].m_drop_lists);
        }
      //--- Add the scrollbar to the base
      else if(i==1)
        {
         CScrollV *sv=cb.GetScrollVPointer();
         m_wnd[window_index].m_elements[size]=sv;
         AddToObjectsArray(window_index,sv);
        }
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores the pointer to the drop-down list view in a private array |
//| (combobox with checkbox)                                         |
//+------------------------------------------------------------------+
bool CWndContainer::AddCheckComboBoxElements(const int window_index,CElement &object)
  {
//--- Leave, if this is not a combobox with checkbox
   if(object.ClassName()!="CCheckComboBox")
      return(false);
//--- Get the pointer to the drop-down list view
   CCheckComboBox *ccb=::GetPointer(object);
//---
   for(int i=0; i<2; i++)
     {
      int size=::ArraySize(m_wnd[window_index].m_elements);
      ::ArrayResize(m_wnd[window_index].m_elements,size+1);
      if(i==0)
        {
         CListView *lv=ccb.GetListViewPointer();
         m_wnd[window_index].m_elements[size]=lv;
         AddToObjectsArray(window_index,lv);
         //--- Add the pointer to the private array
         AddToRefArray(lv,m_wnd[window_index].m_drop_lists);
        }
      else if(i==1)
        {
         CScrollV *s=ccb.GetScrollVPointer();
         m_wnd[window_index].m_elements[size]=s;
         AddToObjectsArray(window_index,s);
        }
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores the pointer (T1) in the array passed by the link (T2)     |
//+------------------------------------------------------------------+
template<typename T1,typename T2>
void CWndContainer::AddToRefArray(T1 &object,T2 &array[])
  {
   int size=::ArraySize(array);
   ::ArrayResize(array,size+1);
   array[size]=object;
  }
//+------------------------------------------------------------------+
