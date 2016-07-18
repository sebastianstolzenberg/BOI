//+------------------------------------------------------------------+
//|                                             ShiftedIndicator.mqh |
//+------------------------------------------------------------------+
#property copyright "Sebastian Stolzenberg"
#property version   "1.00"

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ShiftedIndicator
  {
private:
  int                handle_;
  bool               enabled_;

  int                period_;
  
  double             maximum_;
  double             minimum_;

  double             drawRangeMin_;
  double             drawRangeMax_;

  double             upperThreshold_;
  double             lowerThreshold_;

  int                previouslyCalculated_;

public:
  double             dataBuffer[];
  double             colorBuffer[];

                     ShiftedIndicator();
  virtual           ~ShiftedIndicator();

  int               getHandle() const;
  void               setHandle(int handle);
  void               releaseHandle();

  void               setPeriod(int period);
  void               setValueRange(double min, double max);
  void               setDrawRange(double min, double max);
  void               setThresholds(double upperThreshold, double lowerThreshold);

  double             shiftValue(double value);
  void               redraw();
  int                getPreviouslyCalculated() const;

  int                calculateAndCopy(int rates_total, 
                                      int prev_calculated, 
                                      int begin);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ShiftedIndicator::ShiftedIndicator()
  : handle_(INVALID_HANDLE)
  , enabled_(true)
  , period_(1)
  , minimum_(0)
  , maximum_(100)
  , drawRangeMin_(0)
  , drawRangeMax_(100)
  , previouslyCalculated_(0)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ShiftedIndicator::~ShiftedIndicator()
  {
    releaseHandle();
  }

int ShiftedIndicator::getHandle() const
{
  return handle_;
}

void ShiftedIndicator::setHandle(int handle)
{
  releaseHandle();
  handle_ = handle;
  redraw();
}

void ShiftedIndicator::releaseHandle()
{
  if (handle_ != INVALID_HANDLE)
  {
    IndicatorRelease(handle_);
    handle_ = INVALID_HANDLE;
  }
}

//+------------------------------------------------------------------+
void ShiftedIndicator::setPeriod(int period)
{
  period_ = period;
}

void ShiftedIndicator::setValueRange(double min, double max)
{
  if (minimum_ != min || maximum_ != max)
  {
    minimum_ = min;
    maximum_ = max;
    redraw();
  }
}

void ShiftedIndicator::setDrawRange(double min, double max)
{
  if (drawRangeMin_ != min || drawRangeMax_ != max)
  {
    drawRangeMin_ = min;
    drawRangeMax_ = max;
    redraw();
  }
}

void ShiftedIndicator::setThresholds(double upperThreshold, double lowerThreshold)
  {
  // ::Print(__FUNCTION__, 
  //         " > upperThreshold = ", upperThreshold,
  //          ", lowerThreshold = ", lowerThreshold);
  upperThreshold_ = upperThreshold;
  lowerThreshold_ = lowerThreshold;

  redraw();
  }

double ShiftedIndicator::shiftValue(double value)
{
  return (value - minimum_) / (maximum_ - minimum_) * 
         (drawRangeMax_-drawRangeMin_) + drawRangeMin_;
}

void ShiftedIndicator::redraw()
{
  previouslyCalculated_ = 0;
}

int ShiftedIndicator::getPreviouslyCalculated()const
{
  return previouslyCalculated_;
}

int ShiftedIndicator::calculateAndCopy(int rates_total, int prev_calculated, int begin)
  {  
  if (rates_total == prev_calculated && prev_calculated == previouslyCalculated_)
  {
    // skip if no recalculations need to be done
    return rates_total;
  }

  // ::Print(__FUNCTION__, " > rates_total = ", rates_total, 
  //                        ", prev_calculated = ", prev_calculated,
  //                        ", previouslyCalculated_ = ", previouslyCalculated_,
  //                        ", begin = ", begin);

  if (rates_total < period_ - 1)
      return(0);
      
  if (prev_calculated > previouslyCalculated_)
  {
    prev_calculated = previouslyCalculated_;
  }

  int valuesToCopy; 
  if(prev_calculated>rates_total || 
     prev_calculated<=0) 
    valuesToCopy = rates_total; 
  else 
    valuesToCopy = rates_total - prev_calculated; 

  CopyBuffer(getHandle(),0,prev_calculated,valuesToCopy,dataBuffer);

  // color and shift
  for (int i = prev_calculated; i < prev_calculated + valuesToCopy; ++i)
    {
    // color
    if (dataBuffer[i] < lowerThreshold_)
      colorBuffer[i] = 1;
    else if (dataBuffer[i] > upperThreshold_)
      colorBuffer[i] = 2;
    else
      colorBuffer[i] = 0;
    // shift
    dataBuffer[i] = shiftValue(dataBuffer[i]);
    }

  previouslyCalculated_ = rates_total;
  return rates_total;
  }

